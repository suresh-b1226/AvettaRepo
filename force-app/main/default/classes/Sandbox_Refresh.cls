//Written by Dallin Wasden 1.7.19.
//Apex class to be called for all sandbox refreshes. Contains necessary automation to set up sandboxes.

global class Sandbox_Refresh implements Database.Batchable<sObject> {
    
    global final String query;
    
    global Sandbox_Refresh() {
        if(Test.isRunningTest() == TRUE) {
            System.debug('Test Query');
            query='select Id, Email from Contact where not (Email like \'%@avetta.com%\' or Email = NULL) limit 10';
        } else {
            System.debug('Non-Test Query');
            query='select Id, Email from Contact where not (Email like \'%@avetta.com%\' or Email = NULL)';
        }
    }
    
    global Database.Querylocator start (Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext BC, List<sObject> scope) {        
        List<Contact> allContacts = new List<Contact>();
        
        System.debug('scope = ' + scope.size());
        for(sObject s: scope) {
            Contact cont = (Contact)s;
            cont.Email = '';
            allContacts.add(cont);
            
            System.debug('allContacts = ' + allContacts);
        }
        update allContacts;
    }
    
    global void finish(Database.BatchableContext BC) {
        
        //Automated test data insertion
        List<roundRobinVariable__c> roundRobinRecords = Sandbox_Test_Data.createRoundRobinRecords();
        List<Account> accountRecords = Sandbox_Test_Data.createAccountRecords(1, TRUE);
        List<Account> clientAccountRecords = Sandbox_Test_Data.createClientAccountRecords(1, TRUE);
        List<Contact> contactRecords = Sandbox_Test_Data.createContactRecords(1, TRUE, accountRecords[0].Id, clientAccountRecords[0].Id, 'test@test.com');
        List<Opportunity> opportunityRecords = Sandbox_Test_Data.createOpportunityRecords(1, TRUE, accountRecords[0].Id, clientAccountRecords[0].Id, contactRecords[0].Id);
        List<Case> caseRecords = Sandbox_Test_Data.createCaseRecords(1, TRUE, accountRecords[0].Id, contactRecords[0].Id);
        
        //Upgrade "Development" profiles to "System Admins"
        List<User> devUsers = [select Id, Profile.Name
                               from User
                               where Profile.Name = 'Development'];
        
        List<Profile> devProfile = [select Id
                              from Profile
                              where Name = 'Development'];
        
        if(devUsers.size() > 0 && devProfile.size() > 0) {
            List<User> updatedDevUsers = new List<User>();
            for(User devUser: devUsers) {
                devUser.ProfileId = devProfile[0].Id;
                updatedDevUsers.add(devUser);
            }
            update updatedDevUsers;
        }
    }
}