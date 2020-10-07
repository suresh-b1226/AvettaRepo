/**
 * Created by Paker Brown on 1/19/2019. This class replaces the old 'roundRobinOpportunity' class. It round robins the correct reps for any 
 * retention (saves deactivation) optys that are created.
 *
 * Update by Jason McGrew: 8.7.2019 - Changed the user role of 'Retention' to 'Saves (Deactivation)' SF Ticket: 01194730.
 * Update by Jason McGrew: 8.20.2019 - Opty will be assigned to the 'Default Opportunity Owner' if it's a MidTerm deactivation Opty
 *
 */

public with sharing class Supplier_SavesDeact_Opty_RoundRobin {
    
    public void Supplier_SavesDeact_Opty_RoundRobin_Handler( List<Opportunity> newTrigger /*, List<Opportunity> oldTrigger */) {

        Boolean defaultOptyOwnerAssigned = false;
        List<Opportunity> deactivationSaveOpty = new List<Opportunity>();

        //Check all opportunities in trigger to ensure at least one of Record Type 'Retention' exists
        for (Opportunity singleOpty : newTrigger) {
            if (singleOpty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId()) {
                deactivationSaveOpty.add(singleOpty);
            }
        }

//--Prevents recursion and ensures at least one of opportunities in trigger is of Record Type 'Vetify' to ensure trigger and class are necessary
        if (newTrigger != null && deactivationSaveOpty.size() > 0) {

            List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        	String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
            
            if (profileName != 'Bizable User') {
            
//--SOQL query all users with the role of 'Retention'
            List<User> userList = [
                    SELECT Id, Name, Email, UserRole.Name
                    FROM User
                    WHERE UserRole.Name = 'Saves (Deactivation)'
                    AND IsActive = TRUE
            ];

            //List all AccountIds linked to opportunities in trigger
               List<Id> accountIds = new List<Id>();
               for(Opportunity opty: newTrigger){
                   accountIds.add(opty.AccountId);
               }
            
            //SOQL query account to determine is supplier is also a client
               List<Account> linkedAccounts = [
                       SELECT Id, Supplier_is_also_a_client__c
                       FROM Account
                       WHERE Id IN: accountIds
               ];

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
                    WHERE Name = 'Saves Deactivation'
            ];
			//System.debug(' ** RRLIST =' + roundRobinList);
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

                SIT_Settings__c SITSettings = SIT_Settings__c.getInstance('General SIT');
                Id sitId = SITSettings.Default_Opportunity_Owner__c;

                //Makes the Opty owner the 'Default Opportunity Owner'(Eric Olsen) if in a Pending deactivation result, if not the opty will round robin.

                if (singleOpty.OwnerId == sitId && singleOpty.Result__c == null && singleOpty.StageName == 'Open' && singleOpty.Eligible_for_Deactivation__c == true ){
                    defaultOptyOwnerAssigned = true;
                }
                //System.debug('** defaultOptyOwnerAssigned = ' + defaultOptyOwnerAssigned);

                    if (retentionUserIds.contains(singleOpty.OwnerId) == false && supplierIsClient == false) {

                        if (singleOpty.StageName == 'Open' && singleOpty.Result__c == 'Pending Deactivation') {

                            singleOpty.OwnerId = sitId;

                        } else {
                            singleOpty.OwnerId = userList[Integer.valueOf(roundRobin.roundRobinID__c)].Id;
                        }

                            //System.debug('** singleOpty.OwnerId = ' + singleOpty.OwnerId);

                            if (roundRobin.roundRobinID__c == userList.size() - 1) {

                                roundRobin.roundRobinID__c = 0;

                            } else {
                                roundRobin.roundRobinID__c++;
                            }
                    }
                    if (defaultOptyOwnerAssigned == true) {
                        update singleOpty;
                    }
            }
//Updates the roundRobinVariable in the database, if it changed
            if (roundRobinOriginal != Integer.valueOf(roundRobin.roundRobinID__c)) {
                update roundRobin;
            }
            }
        }
    }
}