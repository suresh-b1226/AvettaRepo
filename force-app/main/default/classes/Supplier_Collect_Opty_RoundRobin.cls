/**

Written by Dallin Wasden 4.26.2018
Round robins new collection opportunities to distribute evenly among reps with "Collections" role. Allows opportunities to pile up to a predetermined pile size before
assigning to reps. Sorts opportunities by dollar amounts in order to divvy ~evenly. Upon assignment, calls emailHelper class to automatically send out personalized
1st collections email template from new owner.

Edited by Parker Brown on 3/20/2019
Round robins new collection optys to distribute evenly to reps with a 'Collections' role.
The class also covers for Indian optys and US optys and distributes to Indian collection reps and US collection reps appropriately

Edited by Jason McGrew 10.15.2019 for SF Case 01362319
Commented out the Round Robin process for all India collection opportunities. All India Opportunities should be assigned to
the Default Opportunity Owner (Eric Olsen)

*/

public class Supplier_Collect_Opty_RoundRobin {
    
    public void Supplier_Collect_Opty_RoundRobinHandler(List<Opportunity> TriggerNew) {
        
        List<Opportunity> collOpty = new List<Opportunity>();

        //Check all opportunities in trigger to ensure at least one of Record Type 'Collections' exists
        for (Opportunity singleOpty : TriggerNew) {
            if (singleOpty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId()) {
                collOpty.add(singleOpty);
            }
        }

        //--Prevents recursion and ensures at least one of opportunities in trigger is of Record Type 'Collections' to ensure trigger and class are necessary
        if (TriggerNew != NULL && collOpty.size() > 0) {

            List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        	String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
            
            if (profileName != 'Bizable User') {
            
            //--SOQL query all Indian users with the role of 'Collections'
            List<User> inUserList = [
                    SELECT Id, Name, Email, UserRole.Name
                    FROM User
                    WHERE UserRole.Name = 'Collections'
                    AND IsActive = TRUE
                    AND LocaleSidKey = 'en_IN'
            ];


            //--SOQL query all non-Indian users with the role of 'Collections'
            List<User> UserList = [
                    SELECT Id, Name, Email, UserRole.Name
                    FROM User
                    WHERE UserRole.Name = 'Collections'
                    AND IsActive = TRUE
                    AND LocaleSidKey != 'en_IN'
            ];


            //--Get a list of -Indian- Collections User IDs
            List<Id> collINUserIds = new List<Id>();
            for (User collINUser : inUserList) {
                collINUserIds.add(collINUser.Id);
            }


            //--Get a list of non-Indian Collections User IDs
            List<Id> collUserIds = new List<Id>();
            for (User collUser : UserList) {
                collUserIds.add(collUser.Id);
            }

            //Queries roundRobinVariable custom object to determine which -Indian- rep is next in line to be assigned a Collection opty
            List<roundRobinVariable__c> roundRobinListIN = new List<roundRobinVariable__c>();
            roundRobinListIN = [
                    SELECT roundRobinID__c
                    FROM roundRobinVariable__c
                    WHERE Name = 'Collections - IN'
            ];

            roundRobinVariable__c roundRobinIN = (roundRobinListIN != NULL && roundRobinListIN.size() > 0) ? roundRobinListIN[0] : NULL;

                
            Integer roundRobinOriginalIN = 0;
                
            if (roundRobinIN != NULL) {
                roundRobinOriginalIN = Integer.valueOf(roundRobinIN.roundRobinID__c);
            } else {
                roundRobinIN.roundRobinID__c = 0;
            }

            //if a user is removed from a role and the index is out of bounds, the below if statement will reset the roundRobinID to 0
            if (roundRobinIN.roundRobinID__c > inUserList.size() - 1) {
                roundRobinIN.roundRobinID__c = 0;
            }
            update roundRobinIN;


            //Queries roundRobinVariable custom object to determine which non-Indian rep is next in line to be assigned a Collection opty
            List<roundRobinVariable__c> roundRobinList = new List<roundRobinVariable__c>();
            roundRobinList = [
                    SELECT roundRobinID__c
                    FROM roundRobinVariable__c
                    WHERE Name = 'Collections'
            ];

            roundRobinVariable__c roundRobin = (roundRobinList != NULL && roundRobinList.size() > 0) ? roundRobinList[0] : NULL;

            Integer roundRobinOriginal = 0;
            if (roundRobin != NULL) {
                roundRobinOriginal = Integer.valueOf(roundRobin.roundRobinID__c);
            } else {
                roundRobin.roundRobinID__c = 0;
            }

            //if a user is removed from a role and the index is out of bounds, the below if statement will reset the roundRobinID to 0
            if (roundRobin.roundRobinID__c > UserList.size() - 1) {
                roundRobin.roundRobinID__c = 0;
            }
            update roundRobin;

            //List all AccountIds linked to opportunities in trigger
            List<Id> accountIds = new List<Id>();
            for (Opportunity opty : TriggerNew) {
                accountIds.add(opty.AccountId);
            }

            //SOQL query account to determine if supplier is also a client
            List<Account> linkedAccounts = [
                    SELECT Id, Supplier_is_also_a_client__c, BillingCountry
                    FROM Account
                    WHERE Id IN:accountIds
            ];
            System.debug('**linkedAccounts =  ' + linkedAccounts);


            //Iterates through optys in the trigger to assign opty to proper rep. If the roundRobinVariable is at the end of the queue of reps, this logic starts it over at the beginning.
            for (Opportunity singleOpty : TriggerNew) {
                System.debug(' ** THE OPP =' + singleOpty);

                SIT_Settings__c SITSettings = SIT_Settings__c.getInstance('General SIT');
                Id sitId = SITSettings.Default_Opportunity_Owner__c;

                Map<Id, Account> acctMap = new Map<Id, Account>();
                for (Account acc : linkedAccounts) {

                    acctMap.put(acc.Id, acc);
                }

                System.debug(' ** ACCOUNT MAP = ' + acctMap);
                System.debug(' ** single opty billing country = ' + singleOpty.Account.BillingCountry);

                //Round robin any Collection optys connected to accounts in India
                if (acctMap.get(singleOpty.AccountId).BillingCountry == 'IN' || acctMap.get(singleOpty.AccountId).BillingCountry == 'India') {

                    Boolean isSupplierClient;
                    for (Account linkedAcct : linkedAccounts) {
                        if (linkedAcct.Id == singleOpty.AccountId) {
                            isSupplierClient = linkedAcct.Supplier_is_also_a_client__c;
                        }
                    }

                    if (collINUserIds.contains(singleOpty.OwnerId) == false && isSupplierClient == false) {

                        singleOpty.OwnerId = sitId;

                        /*****
                        // CODE BELOW IS USED WHEN INDIA COLLECTIONS NEED TO BE ROUND ROBIN'D

                        singleOpty.OwnerId = inUserList[Integer.valueOf(roundRobinIN.roundRobinID__c)].Id;
                        if(roundRobinIN.roundRobinID__c == inUserList.size() - 1) {
                            roundRobinIN.roundRobinID__c = 0;
                        } else {
                            roundRobinIN.roundRobinID__c ++;
                        }
                        *******/
                    }
                }

                //Round robin any Collection optys connected to non-Indian accounts
                else {

                    Boolean isSupplierClient;
                    for (Account linkedAcct : linkedAccounts) {
                        if (linkedAcct.Id == singleOpty.AccountId) {
                            isSupplierClient = linkedAcct.Supplier_is_also_a_client__c;
                        }
                    }
                    System.debug(isSupplierClient);

                    if (collUserIds.contains(singleOpty.OwnerId) == FALSE && isSupplierClient == FALSE) {

                        singleOpty.OwnerId = UserList[Integer.valueOf(roundRobin.roundRobinID__c)].Id;
                        if (roundRobin.roundRobinID__c == UserList.size() - 1) {
                            roundRobin.roundRobinID__c = 0;
                        } else {
                            roundRobin.roundRobinID__c++;
                        }
                    }
                }
                //}

                //Updates the roundRobinVariable in the database, if either non-Indian or IN roundRobin changed
                if (roundRobinOriginal != Integer.valueOf(roundRobin.roundRobinID__c)) {
                    update roundRobin;
                }
                /*
            else if(roundRobinOriginalIN != Integer.valueOf(roundRobinIN.roundRobinID__c)) {
                update roundRobinIN;
            }
            */
            }
            }
        }
    }
}