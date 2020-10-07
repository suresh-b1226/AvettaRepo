global class ScheduledAccountFields implements Schedulable
{
    global void execute(SchedulableContext SC)
    {
        UpdateAccountFields updateAccount = new UpdateAccountFields();
        updateAccount.query = 'select Id, Next_Scheduled_Account_Review__c, Last_Account_Review__c, (select StartDateTime from Events where Type = \'Account Review\' order by StartDateTime desc) from Account';
        Database.executeBatch(updateAccount, 100);
    }
    
    @isTest
    public static void testScheduledAccount()
    {
        Account acc = new Account(Name = 'Test');
        insert acc;
        Event testEvent = new Event(Type='Account Review', WhatId = acc.Id, Subject = 'Test', DurationInMinutes = 2);
        testEvent.ActivityDateTime = DateTime.now();
        insert testEvent;
        UpdateAccountFields updateAccount = new UpdateAccountFields();
        updateAccount.query = 'select Id, Next_Scheduled_Account_Review__c, Last_Account_Review__c, (select StartDateTime from Events where Type = \'Account Review\' order by StartDateTime desc) from Account';
        Database.executeBatch(updateAccount, 100);
    }
}