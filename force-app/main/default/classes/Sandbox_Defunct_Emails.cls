//Written by Dallin Wasden 11.2.2018
//Intended to be called on Sandbox refreshes to kill non-Avetta email addresses. This will prevent automated emails from being sent externally in Sandbox testing.

global class Sandbox_Defunct_Emails implements Database.Batchable<sObject> {
    global final String query;
    
    global Sandbox_Defunct_Emails() {
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
        
    }
}