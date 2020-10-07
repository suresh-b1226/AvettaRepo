/**
 * Created by dwasden on 11/2/2018.
 * 
 * Update by Jason McGrew: 8.7.2019 - Changed the user role of 'Retention' to 'Saves (Downgrade)' SF Ticket: 01194730.
 */

public with sharing class Supplier_SavesDowngrade_Opty_RoundRobin {
    
    public void Supplier_SavesDowngrade_Opty_RoundRobin_Handler( List<Opportunity> newTrigger, List<Opportunity> oldTrigger ) {
        
        List<Opportunity> downgradeSaveOpty = new List<Opportunity>();

        //++Instantiate handler
        //Supplier_Vetify_Case_RoundRobin  handler = new Supplier_Vetify_Case_RoundRobin();

        //Check all opportunities in trigger to ensure at least one of Record Type 'Retention' exists
        for (Opportunity singleOpty : newTrigger) {
            if (singleOpty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId()) {
                downgradeSaveOpty.add(singleOpty);
            }
        }

//--Prevents recursion and ensures at least one of opportunities in trigger is of Record Type 'Vetify' to ensure trigger and class are necessary
        if (newTrigger != null && downgradeSaveOpty.size() > 0) {
            
        List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
            
        if (profileName != 'Bizable User') {

//--SOQL query all users with the role of 'Saves (Downgrade)'
            List<User> userList = [
                    SELECT Id, Name, Email, UserRole.Name
                    FROM User
                    WHERE UserRole.Name = 'Saves (Downgrade)'
                    AND IsActive = TRUE
            ];
            System.debug('userList =' + userList);
            
            //List all AccountIds linked to opportunities in trigger
               List<Id> accountIds = new List<Id>();
               for(Opportunity opty: newTrigger){
                   accountIds.add(opty.AccountId);
               }
            
            //SOQL query account to determine is supplier is also a client
               List<Account> linkedAccounts = [
                       SELECT Id, Supplier_is_also_a_client__c
                       FROM Account
                       WHERE Id IN: accountIds ];

//--Gets a list of 'Retention' User IDs
            List<Id> retentionUserIds = new List<Id>();
            for (User retentionUser : userList) {
                retentionUserIds.add(retentionUser.Id);
            }

            List<roundRobinVariable__c> roundRobinList = new List<roundRobinVariable__c>();

//Queries roundRobinVariable custom object to determine which rep is next in line to be assigned a Vetify case
            roundRobinList = [
                    SELECT roundRobinID__c
                    FROM roundRobinVariable__c
                    WHERE Name = 'Saves Downgrade'
            ];

            roundRobinVariable__c roundRobin = (roundRobinList != null && roundRobinList.size() > 0) ? roundRobinList[0] : null;

            Integer roundRobinOriginal = 0;
            if (roundRobin != null) {
                roundRobinOriginal = Integer.valueOf(roundRobin.roundRobinID__c);
            } else {
                roundRobin.roundRobinID__c = 0;
            }

			if (roundRobin.roundRobinID__c > userList.size() - 1){
                        roundRobin.roundRobinID__c = 0;
                    }
            update roundRobin;
            
            
//Iterates through cases in the trigger to assign case to proper rep. If the roundRobinVariable is at the end of the queue of reps, this logic starts it over at the beginning.
            for (Opportunity singleOpty : newTrigger) {
                
                Boolean supplierIsClient;                       
                       for (Account linkedAcct : linkedAccounts) {
                           if(linkedAcct.Id == singleOpty.AccountId) {
                               supplierIsClient = linkedAcct.Supplier_is_also_a_client__c;
                           }
                       }
                
                if (retentionUserIds.contains(singleOpty.OwnerId) == false && supplierIsClient == false) {
                    singleOpty.OwnerId = userList[Integer.valueOf(roundRobin.roundRobinID__c)].Id;
                    if (roundRobin.roundRobinID__c == userList.size() - 1) {
                        roundRobin.roundRobinID__c = 0;
                    } else {
                        roundRobin.roundRobinID__c++;
                    }
                }
            }

            System.debug('roundRobin = ' + roundRobin);
            System.debug('roundRobinOriginal = ' + roundRobinOriginal);

//Updates the roundRobinVariable in the database, if it changed
            if (roundRobinOriginal != Integer.valueOf(roundRobin.roundRobinID__c)) {
                update roundRobin;
            }
        }
        }
    }
}