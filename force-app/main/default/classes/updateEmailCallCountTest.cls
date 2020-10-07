//Written by Dallin Wasden 12.14.2017
//Tracks the number of email and call activities by opportunity. Viewable on "Calls Made" and "Emails Sent" fields on the opportunity page.
//5.1.2018 - Revised by Dallin Wasden. Bulkified class as a result of SOQL errors while developing Supplier_Collect_Opty_RoundRobin.
//Testing Notes - Log call, add notes to opportunity
@isTest(SeeAllData=true) private class updateEmailCallCountTest {
    
    @isTest(SeeAllData=true) static void addEmail() {
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords');
        
        //Create account record for test purposes.
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords');
        
        //Create opportunity record for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecordsWithClientId(1, TRUE, accountRecords[0].id, clientAccountRecords[0].id);
        System.debug('after creating contact in QB_TestDataFactory.createContactRecords');

        //Create opportunity record for test purposes.
        List<Contact> contactsRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@test.com');
        System.debug('after creating contact in QB_TestDataFactory.createContactRecords');

        //Create opportunity record for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createCaseRecords(1, TRUE, accountRecords[0].id, contactsRecords[0].id);
        System.debug('after creating contact in QB_TestDataFactory.createContactRecords');

        //Create email task using QB_TestDataFactory
        updateEmailCallCount.setFirstRunTrue();
        List<Task> emailTaskRecords = QB_TestDataFactory.createTaskRecord(25, TRUE, 'Email', 'Test Email', opportunityRecords[0].id);
        System.debug('after creating task in QB_TestDataFactory.createTaskRecords');

        //Create email task using QB_TestDataFactory
        updateEmailCallCount.setFirstRunTrue();
        List<talkdesk__Talkdesk_Activity__c> talkDeskRecords = QB_TestDataFactory.createTalkDeskActivityRecord(1, TRUE, accountRecords[0].Id, caseRecords[0].Id, contactsRecords[0].Id);
        System.debug('after creating task in QB_TestDataFactory.createTalkDeskRecords');
        
        delete talkDeskRecords[0];

        //Update Email Subject
        updateEmailCallCount.setFirstRunTrue();
        emailTaskRecords[0].Subject = 'Call';
        Update emailTaskRecords[0];
        
        //Delete Email Task
        updateEmailCallCount.setFirstRunTrue();
        delete emailTaskRecords[0];
        System.debug('after deleting task');
        
        //Create call task using QB_TestDataFactory
        updateEmailCallCount.setFirstRunTrue();
        List<Task> callTaskRecords = QB_TestDataFactory.createTaskRecord(25, TRUE, 'Call', 'Test Call', opportunityRecords[0].id);
        System.debug('after creating task in QB_TestDataFactory.createTaskRecords');
        
        //Update Call Subject
        updateEmailCallCount.setFirstRunTrue();
        callTaskRecords[0].Subject = 'Email';
        Update callTaskRecords[0];
        
        //Delete Call Task
        updateEmailCallCount.setFirstRunTrue();
        delete callTaskRecords[0];
        System.debug('after deleting task');
        
        updateEmailCallCount.setFirstRunFalse();
    }
}