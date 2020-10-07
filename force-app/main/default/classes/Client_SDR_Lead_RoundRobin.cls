//Written by Dallin Wasden 5.15.2019
//Used to round robin SDR leads. Interacts with settings and objects found in SDR_Round_Robin App. Components for the 
//UI are found in the following lightning components:

/*

Updated by Jason McGrew 12.19.2019

Changes made to account for round robin to international regions and countries.

*/


public class Client_SDR_Lead_RoundRobin {
    
    public static Decimal findGCF(Decimal x,  Decimal y) {
        Integer gcf = 1;
        Boolean dec = false;
        
        if(x < 1 || y < 1) {
            System.debug('decimal');
            x *= 100;
            y *= 100;
            dec = true;
        }
        
        Integer smaller;
        if(x > y) {
            smaller = (Integer) y;
        } else {
            smaller = (Integer) x;
        }
        System.debug('smaller = ' + smaller);
        
        for(Integer i = 1; i <= smaller; i++) {
            if((Math.mod((Integer) x, i) == 0) && (Math.mod((Integer) y, i) == 0)) {
                System.debug('Enter for loop if');
                gcf = i;
            }
        }
        
        System.debug('gcf = ' + gcf);
        System.debug('dec = ' + dec);
        
        Decimal dGcf;
        if(dec == true) {
            dGcf = (Decimal) gcf / 100;
        } else {
            dGcf = gcf;
        }
        
        System.debug('dGcf = ' + dGcf);
        return dGcf;
    }

    public void Client_SDR_Lead_RoundRobin(List<Lead> TriggerNew) {
        System.debug('Enter Client_SDR_Lead_RoundRobin class ' + TriggerNew);
        
        List<Lead> sdrLeads = new List<Lead>();
        for(Lead triggeredLead : TriggerNew) {
            System.debug('triggeredLead = ' + triggeredLead);
            if (triggeredLead.RecordTypeId          == Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Field Sales').getRecordTypeId() &&
                triggeredLead.Status                == 'Urgent'  || triggeredLead.Status  == 'Warm' &&
                //triggeredLead.CompanyHQState__c     != null &&
                triggeredLead.Company_HQ_Country__c != null &&
                triggeredLead.Country_Code__c       != null &&
                triggeredLead.Country               != null &&

               //This line will need to be adjusted and additional logic will need to be added in the future when the need arises to round robin international leads
               //(triggeredLead.Country == 'United States' || triggeredLead.Country == 'US') &&

                triggeredLead.Named_Lead__c         == false) {
                   sdrLeads.add(triggeredLead);
               }
        }
        
        if(sdrLeads != null && sdrLeads.size() > 0) {
            
            Automation_Switch__mdt sdrSwitch = [
                SELECT On_Off__c
                FROM Automation_Switch__mdt
                WHERE DeveloperName = 'SDR_Round_Robin'
            ];
            
            if(sdrSwitch.On_Off__c == true) {
                
                String defaultOwnerSetting = (String)[
                        SELECT SDR_Lead_Default_Owner_ID__c
                        FROM SDR_Settings__c
                        LIMIT 1][0].SDR_Lead_Default_Owner_ID__c;
                System.debug('defaultOwnerSetting = ' + defaultOwnerSetting);

                
                /*
                //Determines default lead owner. If lead is owned by this user (or null), lead should be round robined.
                User defaultOwner = [SELECT Id, Name
                                     FROM User
                                     WHERE Id =: defaultId
                                     LIMIT 1];
				*/
                
                List<List<SObject>> defaultOwnerLists = [
                         FIND : defaultOwnerSetting
                         IN NAME FIELDS
                         RETURNING User(Name), Group(Name)
                ];
                System.debug('defaultOwnerLists = ' + defaultOwnerLists);
                
                List<User> userDefault = (User[])defaultOwnerLists[0];
                System.debug('userDefault = ' + userDefault);

                List<Group> groupDefault = (Group[])defaultOwnerLists[1];
                List<Id> defaultOwner = new List<Id>();
                
                for(User u : userDefault) {
                    defaultOwner.add(u.Id);
                }
                
                for(Group g : groupDefault) {
                    defaultOwner.add(g.Id);
                }
                
                System.debug('defaultOwner = ' + defaultOwner);
                
                //Maps states to regions
                Map<String, Region__c> statesMap = new Map<String, Region__c>();
                Map<String, String> statesAbbreviationMap = new Map<String, String>();
                for(State__c state : [SELECT Name, Abbreviation__c, Region__r.Round_Robin_Variable__c, Region__r.Name
                                          FROM State__c]) {
                                              statesMap.put(state.Name.toLowerCase(), state.Region__r);
                                              statesAbbreviationMap.put(state.Abbreviation__c.toLowerCase(), state.Name.toLowerCase());
                                          }
                System.debug('statesMap = ' + statesMap);
                System.debug('statesAbbreviationMap = ' + statesAbbreviationMap);

                //Maps non-NORAM countries
                Map<String, Region__c> nonNoramCountryMap = new Map<String, Region__c>();
                Map<String, String> nonNoramCountryAbbreviationMap = new Map<String, String>();
                for(State__c state : [
                        SELECT Name, Abbreviation__c, Region__r.Round_Robin_Variable__c, Region__r.Name
                        FROM State__c
                        WHERE Region__r.Global_Region__c != 'NORAM'
                ]) {
                    nonNoramCountryMap.put(state.Name.toLowerCase(), state.Region__r);
                    nonNoramCountryAbbreviationMap.put(state.Abbreviation__c.toLowerCase(), state.Name.toLowerCase());
                }
                System.debug('statesMap = ' + statesMap);
                System.debug('statesAbbreviationMap = ' + statesAbbreviationMap);

                //Maps countries to abbreviations
                Map<String, String> countryAbbreviationsMap = new Map<String, String>();
                List<Country_Language__c> countryList = [
                        SELECT Country_Code__c, Name
                        FROM Country_Language__c
                ];
                for(Country_Language__c country : countryList) {
                    countryAbbreviationsMap.put(country.Name.toLowerCase(), country.Country_Code__c.toLowerCase());
                }
                System.debug('countryAbbreviationsMap = ' + countryAbbreviationsMap);
                //Creates list of regions
                List<Region__c> regions = [SELECT Name, Named_SDR__c, Round_Robin_Variable__c
                                               FROM Region__c];
                System.debug('regions = ' + regions);
                
                //Creates list of reps
                List<Rep__c> reps = [SELECT Id, Name, Region__c, User__c, Out_Of_Office__c, Max_Case_Workload__c, Current_Workload__c, Distribution_Weight__c
                                     FROM Rep__c];
                Map<Id, Rep__c> idRepMap = new Map<Id, Rep__c>();
                for(Rep__c rep : reps) {
                    idRepMap.put(rep.Id, rep);
                }
                System.debug('reps = ' + reps);
                
                //Creates integer to determine if a lead has not been worked according to time constraint
                Integer openLeadTimeLimit = (Integer)[SELECT SDR_Open_Lead_Time_Limit__c 
                                                      FROM SDR_Settings__c 
                                                      LIMIT 1][0].SDR_Open_Lead_Time_Limit__c;
                System.debug('openLeadTimeLimit = ' + openLeadTimeLimit);
                
                //Maps all reps to appropriate region
                Map<String, List<Rep__c>> repRegionMaps = new Map<String, List<Rep__c>>();
                for(Region__c region : regions) {
                    List<Rep__c> thisRepList = new List<Rep__c>();
                    
                    for(Rep__c rep : reps) {
                        if(rep.Region__c == region.Id) {
                            thisRepList.add(rep);
                        }
                    }
                    System.debug('thisRepList = ' + thisRepList);
                    
                    repRegionMaps.put(region.Name, thisRepList);
                }

                List<String> usaStrings = new List<String>{'usa', 'u.s.a.', 'us', 'the united states of america', 'the united states','united states', 'united states of america'};

                
                List<Region__c> regionUpdates = new List<Region__c>();
                //Loop through all triggered SDR Leads
                for (Lead sdrLead : sdrLeads) {
                    System.debug('sdrLead = ' + sdrLead);
                    System.debug('sdrLead.OwnerId = ' + sdrLead.OwnerId);
                    
                    Rep__c thisRep;
                    Region__c thisRegion;
                    //System.debug('statesAbbreviationMap.get(sdrLead.State) = ' + statesAbbreviationMap.get(sdrLead.CompanyHQState__c.toLowerCase()));

                   /* if(sdrLead.Company_HQ_Country__c == null && sdrLead.Country != null) {
                        sdrLead.Company_HQ_Country__c = sdrLead.Country;
                    }*/
                    //Determine region from state (taking into account state name or abbreviation)

                    // US and Canada Round Robin Logic

/*                    if(statesMap.keySet().contains(sdrLead.CompanyHQState__c.toLowerCase())) {
                        thisRegion = statesMap.get(sdrLead.CompanyHQState__c.toLowerCase());
                    } else if (statesMap.keySet().contains(statesAbbreviationMap.get(sdrLead.CompanyHQState__c.toLowerCase()))) {
                        thisRegion = statesMap.get(statesAbbreviationMap.get(sdrLead.CompanyHQState__c.toLowerCase()));
                    } else {
                        continue;
                    }*/

                    // International Round Robin Logic
                    if (sdrLead.Region__c == 'U.S.' || sdrLead.Region__c == 'Canada') {

                        if ((sdrLead.Country.toLowerCase() == sdrLead.Company_HQ_Country__c.toLowerCase() ||
                                countryAbbreviationsMap.get(sdrLead.Country.toLowerCase()) == sdrLead.Company_HQ_Country__c.toLowerCase() ||
                                countryAbbreviationsMap.get(sdrLead.Company_HQ_Country__c.toLowerCase()) == sdrLead.Country.toLowerCase())
                                && (usaStrings.contains(sdrLead.Company_HQ_Country__c.toLowerCase()) ||
                                sdrLead.Company_HQ_Country__c == 'CA' || sdrLead.Company_HQ_Country__c == 'Canada')) {
                            if (sdrLead.CompanyHQState__c == null) {
                                return;
                            } else if (statesMap.keySet().contains(sdrLead.CompanyHQState__c.toLowerCase())) {
                                    thisRegion = statesMap.get(sdrLead.CompanyHQState__c.toLowerCase());
                                } else if (statesMap.keySet().contains(statesAbbreviationMap.get(sdrLead.CompanyHQState__c.toLowerCase()))) {
                                    thisRegion = statesMap.get(statesAbbreviationMap.get(sdrLead.CompanyHQState__c.toLowerCase()));
                                } else {
                                    continue;
                                }
                            System.debug(' ** this Region1 =  ' + thisRegion);
                        }

                        else if (sdrLead.Country.toLowerCase() != sdrLead.Company_HQ_Country__c.toLowerCase() && (usaStrings.contains(sdrLead.Country.toLowerCase()) ||
                                sdrLead.Country == 'Canada' || sdrLead.Country == 'CA')) {
                            if (sdrLead.State == null) {
                                return;
                            } else if (statesMap.keySet().contains(sdrLead.State.toLowerCase())) {
                                    thisRegion = statesMap.get(sdrLead.State.toLowerCase());
                                } else if (statesMap.keySet().contains(statesAbbreviationMap.get(sdrLead.State.toLowerCase()))) {
                                    thisRegion = statesMap.get(statesAbbreviationMap.get(sdrLead.State.toLowerCase()));
                                } else {
                                    continue;
                                }
                            }
                            System.debug(' ** this Region2 =  ' + thisRegion);
                    }

                    else if (sdrLead.Region__c == 'APAC'  || sdrLead.Region__c == 'EMEA' || sdrLead.Region__c == 'LATAM') {
                        if (nonNoramCountryMap.keySet().contains(sdrLead.Country.toLowerCase())) {
                            thisRegion = nonNoramCountryMap.get(sdrLead.Country.toLowerCase());
                        }  else if (nonNoramCountryMap.keySet().contains(nonNoramCountryAbbreviationMap.get(sdrLead.Country.toLowerCase()))) {
                            thisRegion = nonNoramCountryMap.get(nonNoramCountryAbbreviationMap.get(sdrLead.Country.toLowerCase()));
                        } else {
                            continue;
                        }
                    }

                    /*else if (sdrLead.Region__c == 'APAC'  || sdrLead.Region__c == 'EMEA' || sdrLead.Region__c == 'LATAM') {
                        if (statesMap.keySet().contains(sdrLead.Country.toLowerCase())) {
                            thisRegion = statesMap.get(sdrLead.Country.toLowerCase());
                        }  else if (statesMap.keySet().contains(statesAbbreviationMap.get(sdrLead.Country.toLowerCase()))) {
                            thisRegion = statesMap.get(statesAbbreviationMap.get(sdrLead.Country.toLowerCase()));
                        } else {
                            continue;
                        }
                    }*/

                    System.debug('thisRegion = ' + thisRegion);

                    //If named lead, assign to senior SDR
                    /*
                    if(sdrLead.Named_Lead__c == TRUE) {
                    thisRep = idRepMap.get(thisRegion.Named_SDR__c);
                    System.debug('named lead = ' + thisRep);
                    }
                    */
                    
                    //Rep assignment logic for null or default owner. Loops until there is a valid Lead owner.
                    do {
                        System.debug('Enter do assignment');
                        System.debug('Lead Owner Id = ' + sdrLead.OwnerId);
                        System.debug('Lead Owner Name = ' + sdrLead.Owner.Name);
                        System.debug('Lead Owner IsActive = ' + sdrLead.Owner.IsActive);
                        System.debug('defaultOwner = ' + defaultOwner);
                        //System.debug('repRegionMaps.get(thisRegion.Name) = ' + repRegionMaps.get(thisRegion.Name));
                        if(sdrLead != null &&
                           !defaultOwner.contains(sdrLead.OwnerId)) {
                               System.debug('Enter break');
                               return;
                           } else if((sdrLead.OwnerId == null ||
                            !sdrLead.Owner.IsActive ||
                            defaultOwner.contains(sdrLead.OwnerId)) && 
                           repRegionMaps.get(thisRegion.Name).size() > 0) {
                               System.debug('Enter round robin do');
                               
                               Double repDistributionTotal = 0;
                               Double lowest = 0;
                               Double highest = 0;
                               Integer minCount = 0;
                               for(Rep__c rep : repRegionMaps.get(thisRegion.Name)) {
                                   if(lowest == 0 || rep.Distribution_Weight__c < lowest) {
                                       lowest = rep.Distribution_Weight__c;
                                   }
                                   if(highest == 0 || rep.Distribution_Weight__c > highest) {
                                       highest = rep.Distribution_Weight__c;
                                   }
                                   repDistributionTotal = repDistributionTotal + rep.Distribution_Weight__c;
                               }
                               System.debug('lowest = ' + lowest);
                               System.debug('repDistributionTotal = ' + repDistributionTotal);
                               
                               Decimal gcf = findGCF(lowest, highest);
                               
                               for(Rep__c rep : repRegionMaps.get(thisRegion.Name)) {
                                   minCount += (Integer) (rep.Distribution_Weight__c / gcf);
                               }
                               System.debug('minCount = ' + minCount);
                               
                               //Restarts round robin after full pattern has been set
                               if(thisRegion.Round_Robin_Variable__c > ((Decimal) minCount / repRegionMaps.get(thisRegion.Name).size()).round(RoundingMode.UP) *
                                  repRegionMaps.get(thisRegion.Name).size()) {
                                      thisRegion.Round_Robin_Variable__c = 0;
                                      System.debug('Reset round robin count');
                                  }
                               
                               System.debug('repDistributionTotal = ' + repDistributionTotal);
                               System.debug(repRegionMaps.get(thisRegion.Name)
                                  [Math.mod((Integer)thisRegion.Round_Robin_Variable__c, repRegionMaps.get(thisRegion.Name).size())].Distribution_Weight__c / gcf);
                               
                               if((thisRegion.Round_Robin_Variable__c / repRegionMaps.get(thisRegion.Name).size()).round(RoundingMode.DOWN) <
                                  repRegionMaps.get(thisRegion.Name)
                                  [Math.mod((Integer)thisRegion.Round_Robin_Variable__c, repRegionMaps.get(thisRegion.Name).size())].Distribution_Weight__c / gcf) {
                                                System.debug('Enter assignment if');
                                                thisRep = repRegionMaps.get(thisRegion.Name)
                                                    [Math.mod((Integer)thisRegion.Round_Robin_Variable__c, repRegionMaps.get(thisRegion.Name).size())];
                                            }
                               
                               thisRegion.Round_Robin_Variable__c++;
                               System.debug('thisRep = ' + thisRep);
                               System.debug('thisRegion.Round_Robin_Variable__c = ' + thisRegion.Round_Robin_Variable__c);
                               
                           }
                        
                        if(thisRep != NULL && thisRep.Out_Of_Office__c == TRUE
                           //thisRep.Current_Workload__c > thisRep.Max_Case_Workload__c || 
                           //sdrLead.LastActivityDate < DateTime.now() - openLeadTimeLimit
                          ) {
                              System.debug('Out_Of_Office__c = ' + thisRep.Out_Of_Office__c);
                              //System.debug('Current_Workload__c = ' + thisRep.Current_Workload__c);
                              //System.debug('Max_Case_Workload__c = ' + thisRep.Max_Case_Workload__c);
                              //System.debug('LastActivityDate = ' + sdrLead.LastActivityDate);
                              
                              thisRep = NULL;
                              System.debug('thisRep2 = ' + thisRep);
                          }
                        
                        //Keeps list of region round robin data. If region is already in list, replace existing instance with updated data
                        if(regionUpdates.contains(thisRegion)) {
                            regionUpdates.remove(regionUpdates.indexOf(thisRegion));
                        } 
                        regionUpdates.add(thisRegion);
                        
                    } while(thisRep == NULL);
                    
                    sdrLead.OwnerId = thisRep.User__c;
                    System.debug('sdrLead.OwnerId = ' + sdrLead.OwnerId);
                }
                
                update(new List<Region__c>(regionUpdates));
            }
        }
    }
}