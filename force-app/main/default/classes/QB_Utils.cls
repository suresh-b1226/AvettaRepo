/*
Name:        QB_Utils

Description: These utilities are called by the QB_UpdateAccount API which enables accounts to stay syncronized between
Salesforce and Organizer.
*/

public class QB_Utils {
    
    public static List<Account> QB_FindProspectAccount
        (
            Id recordTypeId,
            String name,
            String email,
            String city,
            String state,
            String country,
            String pnumber,
            String url,
            String emailDomain
        ) {
            List<Account> acts = new List<Account> ();
            Boolean aAdded;
            
            // ToDo: Use regex to build a search string to add to the WHERE clause
            // WHERE clause should use a case insensitive like and truncate common
            // suffixes and replace with %.  It should also do the same for common prefixes.
            
            String nameSearch = '%';
            
            if (name != null) {
                
                for (String part : name.split('\\s')) {
                    
                    if (nameSearch.length() < part.length()) {
                        nameSearch = part;
                    }
                }
                
                nameSearch = '%' + nameSearch + '%';
            }
            
            String phoneNumberSearch = '%';
            
            if (pnumber != null) {
                phoneNumberSearch = '%' + pnumber.replaceAll('[^0-9]', '%') + '%';
            }
            
            String websiteSearch = '%';
            
            if (url != null) {
                
                for (String part : url.split('.')) {
                    
                    if (websiteSearch.length() < part.length()) {
                        websiteSearch = part;
                    }
                }
                
                websiteSearch = '%' + websiteSearch + '%';
            }
            
            String domain = '%';
            
            if (email != null && email.contains('@')) {
                System.debug('********** email **************** = ' + email);
                
                domain = '%' + email.split('@').get(1) + '%';
                emailDomain = domain;
                
            }
            
            System.debug('phoneNumberSearch = ' + phoneNumberSearch);
            
            //System.debug('SELECT Id, Organizer_ID__c, Name, Email, Website, BillingCity, Billing Country, Phone FROM Account WHERE Organizer_ID__c = NULL AND RecordTypeId = :' + recordTypeId + 'AND Name Like :' + nameSearch + 'AND Phone Like :' + phoneNumberSearch + 'AND BillingCity Like :' + city + 'AND Email like : ' + domain);
            
            String candidateAccountsQuery = 'SELECT  Id, Organizer_ID__c, Name, Primary_Contact_Email__c, Website, BillingCity, BillingState, BillingCountry, Phone FROM Account WHERE Organizer_ID__c = NULL AND RecordTypeId = :recordTypeId';
            Boolean orExists = FALSE;
            if(email != NULL || (nameSearch != NULL && city != NULL) || (domain != NULL && country != NULL) || phoneNumberSearch != NULL) {
                candidateAccountsQuery += ' AND (';
                
                if(email != NULL && email != '%%') {
                    candidateAccountsQuery += 'Primary_Contact_Email__c LIKE: email';
                    orExists = TRUE;
                }
                
                if(nameSearch != NULL && nameSearch != '%%' && city != NULL && city != '%%' && orExists == TRUE) {
                    candidateAccountsQuery += ' OR (Name LIKE :nameSearch AND BillingCity LIKE :city)';
                    orExists = TRUE;
                } else if (nameSearch != NULL && nameSearch != '%%' && city != NULL && city != '%%') {
                    candidateAccountsQuery += '(Name LIKE :nameSearch AND BillingCity LIKE :city)';
                    orExists = TRUE;
                }
                
                if(domain != NULL && domain != '%%' && country != NULL && country != '%%' && orExists == TRUE) {
                    candidateAccountsQuery += ' OR (Primary_Contact_Email__c LIKE : domain AND BillingCountry LIKE: country)';
                    orExists = TRUE;
                } else if (domain != NULL && domain != '%%' && country != NULL && country != '%%') {
                    candidateAccountsQuery += '(Primary_Contact_Email__c LIKE : domain AND BillingCountry LIKE: country)';
                    orExists = TRUE;
                }
                 
                if(phoneNumberSearch != NULL && phoneNumberSearch != '%%' && orExists == TRUE) {
                    candidateAccountsQuery += ' OR Phone LIKE : phoneNumberSearch';
                    orExists = TRUE;
                } else if (phoneNumberSearch != NULL && phoneNumberSearch != '%%') {
                    candidateAccountsQuery += 'Phone LIKE : phoneNumberSearch';
                    orExists = TRUE;
                }
                
                candidateAccountsQuery += ')';
            }
            
            System.debug('candidateAccountsQuery = ' + candidateAccountsQuery);
            List<Account> candidateAccounts = Database.query(candidateAccountsQuery);
            System.debug('candidateAccounts = ' + candidateAccounts);
            /*
            candidateAccounts = [
                SELECT  Id,
                Organizer_ID__c,
                Name,
                Primary_Contact_Email__c,
                Website,
                BillingCity,
                BillingState,
                BillingCountry,
                Phone
                FROM Account
                WHERE Organizer_ID__c = NULL
                AND RecordTypeId = :recordTypeId
                AND ( Primary_Contact_Email__c LIKE: email
                     OR ( Name LIKE :nameSearch AND BillingCity LIKE :city )
                     OR ( Primary_Contact_Email__c LIKE : domain AND BillingCountry LIKE: country )
                     OR ( Phone LIKE : phoneNumberSearch))
            ];
			*/
            
            //Integer rows = [select count() from Account WHERE Organizer_ID__c = NULL AND recordTypeId = :recordTypeId];
            //System.debug('number of candidate accounts: ' + rows);
            
            //System.debug('***** EMAIL DOMAIN **** = ' + emailDomain);
            //System.debug('***** EMAILS **** = ' + email);
            //System.debug('*****Number of accounts to find a match:' + candidateAccounts.size());
            //System.debug('candidate accounts:' + candidateAccounts);
            
            
            List<Account> emailMatchList        = new List<Account>();
            List<Account> stateMatchList        = new List<Account>();
            List<Account> phoneMatchList        = new List<Account>();
            List<Account> emailDomainMatchList  = new List<Account>();
            List<Account> countryMatchList      = new List<Account>();
            
            //List<Account> emailCountryMatchList = new List<Account>();
            //List<Account> cityMatchList = new List<Account>();
            //List<Account> nameFuzzyMatchList = new List<Account>();
            
            
            for (Account a : candidateAccounts) {
                aAdded = false;
                System.debug('*****account to match:' + a);
                
                if (a.Primary_Contact_Email__c != null && email != null && a.Primary_Contact_Email__c == email) {
                    
                    System.debug('Email Match');
                    emailMatchList.add(a);
                    continue;
                    
                } else if (a.Phone != null && pnumber != null) {
                    if ((a.Phone.replaceAll('\\D', '')) == pnumber.replaceAll('\\D', '')) {
                        
                        System.debug('Phone Numbers Match = ' + a.Phone.replaceAll('\\D', '') + ' == ' + pnumber.replaceAll('\\D', ''));
                        phoneMatchList.add(a);
                        continue;
                    }
                    
                } else if (a.Primary_Contact_Email__c != null && email != null) {
                    if (a.Primary_Contact_Email__c.split('@').get(1) == email.split('@').get(1)) {
                        
                        System.debug('Email Domain Match');
                        emailDomainMatchList.add(a);
                        
                        if (a.BillingCountry != null && country != null && a.BillingCountry.toLowerCase() == country.toLowerCase()) {
                            
                            System.debug('Account Country Match');
                            countryMatchList.add(a);
                            
                            if (countryMatchList.size() >= 1) {
                                if (a.BillingState != null && state != null && a.BillingState.toLowerCase() == state.toLowerCase()) {
                                    
                                    System.debug('Account State Match');
                                    stateMatchList.add(a);
                                }
                            }
                        }
                    }
                }
            }
            
            List<Account> noMatchingAccounts = new List<Account>();
            
            if (emailMatchList.size() == 0 && phoneMatchList.size() == 0 && emailDomainMatchList.size() == 0) {
                return noMatchingAccounts;
            } else if (emailMatchList.size() == 1) {
                return emailMatchList;
            } else if (emailMatchList.size() > 1) {
                return noMatchingAccounts;
            } else if (emailMatchList.size() == 0 && phoneMatchList.size() == 1) {
                return phoneMatchList;
            } else if (emailMatchList.size() == 0 && phoneMatchList.size() > 1) {
                return noMatchingAccounts;
                
            } else if (emailMatchList.size() == 0 && phoneMatchList.size() == 0 && emailDomainMatchList.size() == 1) {
                if (countryMatchList.size() == 0 ) {
                    return noMatchingAccounts;
                } else if (countryMatchList.size() == 1) {
                    return countryMatchList;
                } else if (countryMatchList.size() > 1 && stateMatchList.size() == 1) {
                    return stateMatchList;
                } else if (countryMatchList.size() > 1 && stateMatchList.size() > 1) {
                    return noMatchingAccounts;
                } else if (countryMatchList.size() > 1 && stateMatchList.size() == 0) {
                    return noMatchingAccounts;
                }
            }
            
            /*                if (a.BillingState != NULL && state != NULL && a.BillingState == state) {
            stateMatchList.add(a);
            
            if (a.BillingCity != NULL && city != NULL && a.BillingCity == city) {
            cityMatchList.add(a);
            }
            } else if (a.name != NULL && name != NULL && a.name.replaceAll('[^A-Za-z0-9]', '') == name.replaceAll('[^A-Za-z0-9]', '')) {
            System.debug ('name match' + a.name.replaceAll('[^A-Za-z0-9]', ''));
            nameFuzzyMatchList.add(a);
            //aAdded = true;
            }
            }
            
            */
                        
                        /*
            if (!aAdded && a.phone != NULL && pnumber != NULL) {
            System.debug ('phone match' + a.phone.replaceAll('[^0-9]', ''));
            If ((a.phone.replaceAll('[^0-9]', '')) == pnumber.replaceAll('[^0-9]', '')) {
            acts.add(a);
            aAdded = true;
            }
            }
            
            if (!aAdded && url != NULL && a.website == url) {
            System.debug ('url match' + url);
            acts.add(a);
            }
            */
                        /*
            }
            
            List<Account> matchingAccounts = new List<Account>();
            
            if (emailCountryMatchList.size() == 0) {
            return matchingAccounts;
            } else if (emailCountryMatchList.size() == 1) {
            return emailCountryMatchList;
            } else if (emailCountryMatchList.size() > 1) {
            if (stateMatchList.size() == 1) {
            return stateMatchList;
            } else if (stateMatchList.size() > 1) {
            if (cityMatchList.size() == 1) {
            return cityMatchList;
            } else if (cityMatchList.size() == 0 && cityMatchList.size() > 1) {
            return matchingAccounts;
            }
            } else if (stateMatchList.size() == 0) {
            if (nameFuzzyMatchList.size() == 0 || nameFuzzyMatchList.size() > 1) {
            return matchingAccounts;
            } else if (nameFuzzyMatchList.size() == 1) {
            return nameFuzzyMatchList;
            }
            }
            }*/
            
            System.debug ('found accounts' + acts);
            return acts;
        }
    
    public static String QB_FindExactAccount(String pid, String organizerid) {
        String query = 'SELECT Id, name, status__c, Website, Type, BillingAddress, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ' +
            ' Client_Success_Manager__c, Sales_Development_Rep__c, Account_Executive__c, ' +
            ' Implementation_Project_Manager__c, Sales_Rep_Owner__c, ' +
            ' Custom_Registration_Link__c, ' +
            ' (select casenumber, subject, type, status, origin, RecordType.Name, ' +
            ' related_client_account__c, related_supplier_account__c ' +
            ' from Cases where isClosed = false), ' +
            ' (select Client_Account__r.AccountMongoID__c, Pre_Registration_Tags__c, External_Ids__c ' +
            ' from Opportunities where Priority__c = \'Registration Request\') ' +
            ' FROM Account WHERE ';
        
        if (organizerId != NULL) {
            query += ' organizer_id__c = :organizerId';
            system.debug('find exact account by org id');
        } else if (pid != NULL) {
            system.debug('PID__c = ' + pid);
            query += 'PID__c = \'' + pid + '\'';
        } else {
            return null;
        }
        
        System.debug('query = ' + query);
        
        List<Account> a = new List<Account> ();
        System.debug ('finding by ' + pid + organizerid);
        a = Database.query (query);
        
        if (a.size() == 1) {
            List<Id> optyIds = new List<Id>();
            for(Opportunity o : a[0].Opportunities) {
                optyIds.add(o.Id);
            }
            
            List<Opportunity_Related_Clients__c> relatedClients = [SELECT Account__r.AccountMongoID__c, Related_Opportunity__r.Id
                                                                  FROM Opportunity_Related_Clients__c
                                                                  WHERE Related_Opportunity__r.Id =: optyIds];
            
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if(a[0].Id != NULL) {
                gen.writeStringField('Id', a[0].Id);
            }
            if(a[0].Name != NULL) {
            gen.writeStringField('Name', a[0].Name);
            }
            if(a[0].Status__c != NULL) {
            gen.writeStringField('Status', a[0].Status__c);
            }
            if(a[0].Type != NULL) {
            gen.writeStringField('Type', a[0].Type);
            }
            System.debug('here');
            gen.writeFieldName('BillingAddress');
            gen.writeStartObject();
            System.debug('here');
            if(a[0].BillingCity != NULL) {
            gen.writeStringField('City', a[0].BillingCity);
            }
            System.debug('here');
            if(a[0].BillingCountry != NULL) {
            gen.writeStringField('Country', a[0].BillingCountry);
            }
            if(a[0].BillingPostalCode != NULL) {
            gen.writeStringField('PostalCode', a[0].BillingPostalCode);
            }
            if(a[0].BillingState != NULL) {
            gen.writeStringField('State', a[0].BillingState);
            }
            if(a[0].BillingStreet != NULL) {
            gen.writeStringField('Street', a[0].BillingStreet);
            }
            gen.writeEndObject();
            System.debug('here1');
            /*
            if(a[0].Pre_Registration_Tags__c != NULL) {
            gen.writeStringField('PreRegistrationTags', a[0].Pre_Registration_Tags__c);
            }
            if(a[0].ExternalIds__c != NULL) {
            gen.writeStringField('ExternalIds', a[0].ExternalIds__c);
            }
			*/
            System.debug('o = ' + a[0].Opportunities);
            gen.writeFieldName('Opportunities');
            gen.writeStartArray();
            for(Opportunity o : a[0].Opportunities) {
                gen.writeStartObject();
                System.debug('here');
                if(o.Client_Account__r.AccountMongoID__c != NULL) {
                	gen.writeStringField('RequestedByClientId', o.Client_Account__r.AccountMongoID__c);
                }
                if(o.Pre_Registration_Tags__c != NULL) {
                	gen.writeStringField('PreRegistrationTags', o.Pre_Registration_Tags__c);
                }
                if(o.External_Ids__c != NULL) {
                	gen.writeStringField('ExternalIds', o.External_Ids__c);
                }
                System.debug('here');
                for(Opportunity_Related_Clients__c orc : relatedClients) {
                    if(orc.Related_Opportunity__r.Id == o.Id) {
                        System.debug('here');
                        if(a[0].AccountMongoID__c != NULL) {
                        gen.writeStringField('SiteId', orc.Account__r.AccountMongoID__c);
                        }
                    }
                }
                System.debug('here');
                gen.writeEndObject();
            }
            gen.writeEndArray();
            gen.writeEndObject();
            
            return gen.getAsString();
        } else return null;
    }
    
    /*
    public static List<Case> QB_getOpenCases (id accountId)
    {
    return [select casenumber, subject, type, status, origin, related_client_account__c, related_supplier_account__c
    from case
    where accountid=:accountId
    and isClosed = false];
    }
    */
    
    //Create tasks
    public static void createTask(Account a, String subj, Id ownerId) {
        Id recordTypeId;
        
        recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        Task t = new Task();
        t.OwnerId = ownerId;
        t.RecordTypeId = recordTypeId;
        t.Subject = subj;
        t.WhatId = a.id;
        insert t;
    }
    
}