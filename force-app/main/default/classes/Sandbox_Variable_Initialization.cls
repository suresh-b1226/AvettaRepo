/* Created By JMcGrew on 4.23.2019. This class will run after a sandbox refresh.  */

/* This class will This class will run when the sandbox is refreshed. It check to see if there are any roundRobinVariable__c created already, 
   based on results it will create the needed roundRobinVariable__c and insert them. It will also set roundRobinID__c to 0. 
*/

public class Sandbox_Variable_Initialization {
    public static void createRoundRobin() {        
        roundRobinVariable__c rrv_1 = new roundRobinVariable__c ( Name = 'Vetify Fulfillment', roundRobinID__c = 0 );
        roundRobinVariable__c rrv_2 = new roundRobinVariable__c ( Name = 'Saves Deactivation', roundRobinID__c = 0 );
        roundRobinVariable__c rrv_3 = new roundRobinVariable__c ( Name = 'Collections - IN',   roundRobinID__c = 0 );
        roundRobinVariable__c rrv_4 = new roundRobinVariable__c ( Name = 'MYM',                roundRobinID__c = 0 );
        roundRobinVariable__c rrv_5 = new roundRobinVariable__c ( Name = 'Collections',        roundRobinID__c = 0 );
        roundRobinVariable__c rrv_6 = new roundRobinVariable__c ( Name = 'Saves Downgrade',    roundRobinID__c = 0 );
                
        List<roundRobinVariable__c> roundRobinVariableList = new List<roundRobinVariable__c>();
            roundRobinVariableList.add( rrv_1 );
            roundRobinVariableList.add( rrv_2 );
            roundRobinVariableList.add( rrv_3 );
            roundRobinVariableList.add( rrv_4 );
            roundRobinVariableList.add( rrv_5 );
            roundRobinVariableList.add( rrv_6 );
        
        upsert roundRobinVariableList Name;
        System.debug(' ** SIZE OF ROUND ROBIN LIST ** = ' + roundRobinVariableList.size());        
    }

/* This class will check for all users with a 'Development' profile and change their profile to 'System Administrator.' */   
    
    public static void userProfileUpdate() {
        List<User> userProfileList = new List <User>([  SELECT Id, Name, Profile.Name
                                                        FROM   User
                                                        WHERE  Profile.Name = 'Development'
                                                        AND    IsActive = TRUE]);
        System.debug(' ** THE LIST OF DEV USERS ** : ' + userProfileList);

        Profile pID = [SELECT Id
                       FROM   Profile
                       WHERE  Name = 'System Administrator'
        ];

        System.debug(' ** SYSTEM ADMINISTRATOR ID ** : '  + pID);

        for( User userList : userProfileList ) {
            userList.ProfileId = pID.Id;
        }

        update userProfileList;
        System.debug(' ** UPDATED LIST ** ' + userProfileList);
    }


    public static Region__c createRegionRecords(Boolean isInsert, String regionName, string globalRegion) {
        Region__c regions = new Region__c();
            regions.Name = regionName;
            regions.Round_Robin_Variable__c = 0;
        	regions.Global_Region__c = globalRegion;

        if (isInsert) {
            insert regions;
        }
        return regions;
    }

    public static List<State__c> createSDRStateRecords(Integer count, Boolean isInsert, List<String> abbreviationList, List<String> stateNameList, Region__c region) {
        List<State__c> states = new List<State__c>();
        for (Integer i = 0; i < count; i++) {
            states.add(
                    new State__c(
                            Abbreviation__c = abbreviationList[i],
                            Name = stateNameList[i],
                            Region__c = region.Id
                    )
            );
        }
        if (isInsert) {
            insert states;
        }
        return states;
    }

    public static List<Rep__c> createRepRecords(Integer count, Boolean isInsert, Region__c region, User userList) {
        List<Rep__c> rep = new List<Rep__c>();
        Integer r = 0;
        for (Integer i = 0; i < count; i++) {
            rep.add(
                    new Rep__c(
                            Distribution_Weight__c = 1,
                            Name = userList.Name,
                            Out_Of_Office__c = false,
                            RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SDR').getRecordTypeId(),
                            Region__c = region.Id,
                            User__c = userList.Id
                    )
            );
            r++;
        }
        if (isInsert) {
            insert rep;
        }
        return rep;
    }

    public static void create_SDR_Mapping() {

        String westRegion      = 'West';
        String southWestRegion = 'South West';
        String midWestRegion   = 'Mid West';
        String eastRegion      = 'East';
        String southRegion     = 'South';
        String easternEurope   = 'Eastern Europe';
        String westernEurope   = 'Western Europe';
        String apac            = 'APAC';
        String canada          = 'Canada';
        
        String noramRegion = 'NORAM';
        String emeaRegion = 'EMEA';
      

        Region__c westRegionRecords          = (Region__c) createRegionRecords(true, westRegion, noramRegion );
        Region__c southWestRegionRecords     = (Region__c) createRegionRecords(true, southWestRegion, noramRegion);
        Region__c midWestRegionRecords       = (Region__c) createRegionRecords(true, midWestRegion, noramRegion);
        Region__c eastRegionRecords          = (Region__c) createRegionRecords(true, eastRegion, noramRegion);
        Region__c southRegionRecords         = (Region__c) createRegionRecords(true, southRegion, noramRegion);
        Region__c easternEuropeRegionRecords = (Region__c) createRegionRecords(true, easternEurope, emeaRegion);
        Region__c westernEuropeRegionRecords = (Region__c) createRegionRecords(true, westernEurope, emeaRegion);
        Region__c apacRegionRecords          = (Region__c) createRegionRecords(true, apac, apac);
        Region__c canadaRegionRecords        = (Region__c) createRegionRecords(true, canada, noramRegion);

        List<String> abbreviationListWest = new List<String>{'AK', 'WA', 'OR', 'CA', 'HI', 'ID', 'WY', 'NV', 'UT', 'CO','MT'};
        List<String> stateNameListWest    = new List<String>{'Alaska','Washington', 'Oregon','California', 'Hawaii','Idaho','Wyoming','Nevada', 'Utah', 'Colorado', 'Montana'};

        List<String> abbreviationListSouthwest = new List<String>{'AZ', 'NM', 'TX'};
        List<String> stateNameListSouthwest    = new List<String>{'Arizona','New Mexico','Texas'};

        List<String> abbreviationListMidwest = new List<String>{'AR', 'IL', 'IN', 'IA', 'KS', 'KY', 'MI', 'MN', 'MO', 'NE', 'ND', 'OH', 'OK', 'SD', 'TN', 'WI'};
        List<String> stateNameListMidWest    = new List<String>{'Arkansas','Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Michigan', 'Minnesota', 'Missouri',
                'Nebraska', 'North Dakota', 'Ohio', 'Oklahoma', 'South Dakota', 'Tennessee',  'Wisconsin'};

        List<String> abbreviationListEast = new List<String>{'CT', 'DE', 'MA', 'MD', 'ME', 'NH', 'NJ', 'NY', 'PA', 'RI', 'VT', 'VA', 'WV'};
        List<String> stateNameListEast    = new List<String>{'Connecticut', 'Delaware',  'Maine', 'Maryland', 'Massachusetts', 'New Hampshire', 'New Jersey','New York', 'Pennsylvania',
                'Rhode Island', 'Vermont', 'Virginia', 'West Virginia'};

        List<String> abbreviationListSouth = new List<String>{'AL', 'FL', 'GA', 'LA', 'MS', 'NC', 'SC'};
        List<String> stateNameListSouth    = new List<String>{'Alabama', 'Florida', 'Georgia','Louisiana', 'Mississippi', 'North Carolina','South Carolina'};

        List<String> abbreviationListEasternEurope = new List<String>{'DE', 'PL', 'RO', 'AT', 'DK'};
        List<String> stateNameListEasternEurope    = new List<String>{'Germany', 'Poland', 'Romania', 'Austria', 'Denmark'};

        List<String> abbreviationListWesternEurope = new List<String>{'FR', 'ES', 'PT', 'IT', 'GB'};
        List<String> stateNameListWesternEurope    = new List<String>{'France', 'Spain', 'Portugal', 'Italy', 'England'};

        List<String> abbreviationListApac     = new List<String>{'AU', 'JP', 'NZ'};
        List<String> stateNameListWesternApac = new List<String>{'Australia', 'Japan', 'New Zealand'};

        List<String> abbreviationListCanada     = new List<String>{'BC', 'MB', 'NB', 'NL', 'NS', 'ON', 'QC', 'YT', 'SK', 'AB'};
        List<String> stateNameListWesternCanada = new List<String>{'British Columbia', 'Manitoba', 'New Brunswick', 'Newfoundland and Labrador', 'Nova Scotia', 'Ontario', 'Quebec', 'Yukon', 'Saskatchewan', 'Alberta'};

        List<State__c> westStateRecords          = createSDRStateRecords(11, true, abbreviationListWest, stateNameListWest, westRegionRecords);
        List<State__c> southWestStateRecords     = createSDRStateRecords(3, true, abbreviationListSouthwest, stateNameListSouthwest, southWestRegionRecords);
        List<State__c> midwestStateRecords       = createSDRStateRecords(16, true, abbreviationListMidwest, stateNameListMidWest, midWestRegionRecords);
        List<State__c> eastStateRecords          = createSDRStateRecords(13, true, abbreviationListEast, stateNameListEast, eastRegionRecords);
        List<State__c> southStateRecords         = createSDRStateRecords(7, true, abbreviationListSouth, stateNameListSouth, southRegionRecords);
        List<State__c> easternEuropeStateRecords = createSDRStateRecords(5, true, abbreviationListEasternEurope, stateNameListEasternEurope, easternEuropeRegionRecords);
        List<State__c> westernEuropeStateRecords = createSDRStateRecords(5, true, abbreviationListWesternEurope, stateNameListWesternEurope, westernEuropeRegionRecords);
        List<State__c> apacStateRecords          = createSDRStateRecords(3, true, abbreviationListApac, stateNameListWesternApac, apacRegionRecords);
        List<State__c> canadaStateRecords        = createSDRStateRecords(10, true, abbreviationListCanada, stateNameListWesternCanada, canadaRegionRecords);


        Id profileId = [
                SELECT Id
                FROM Profile
                WHERE Name = 'SDR'
                LIMIT 1][0].Id;

        Id userRoleId = [
                SELECT Id
                FROM UserRole
                WHERE Name = 'SDR'
                LIMIT 1][0].Id;

        List<User> userRecords = [
                SELECT Id, Name
                FROM User
                WHERE UserRoleId =: userRoleId
                AND ProfileId =: profileId
                LIMIT 9
        ];

        List<Rep__c> westRepRecords          = createRepRecords(1, true, westRegionRecords, userRecords[0]);
        List<Rep__c> southWestRepRecords     = createRepRecords(1, true, southWestRegionRecords, userRecords[1]);
        List<Rep__c> midWestRepRecords       = createRepRecords(1, true, midWestRegionRecords, userRecords[2]);
        List<Rep__c> eastRepRecords          = createRepRecords(1, true, eastRegionRecords, userRecords[3]);
        List<Rep__c> southRepRecords         = createRepRecords(1, true, southRegionRecords, userRecords[4]);
        List<Rep__c> easternEuropeRepRecords = createRepRecords(1, true, southWestRegionRecords, userRecords[5]);
        List<Rep__c> westernEuropeRepRecords = createRepRecords(1, true, midWestRegionRecords, userRecords[6]);
        List<Rep__c> apacRepRecords          = createRepRecords(1, true, eastRegionRecords, userRecords[7]);
        List<Rep__c> canadaRepRecords        = createRepRecords(1, true, southRegionRecords, userRecords[8]);

    }
}