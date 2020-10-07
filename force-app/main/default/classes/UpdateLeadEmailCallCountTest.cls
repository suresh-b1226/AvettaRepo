/**
 * Created by JasonMcGrew on 6/3/2019.
 *
 * Test Class for UpdateLeadEmailCallCountTest.
 *
 */

@IsTest private class UpdateLeadEmailCallCountTest {

    @IsTest static void LeadTaskTest() {
        List<Lead> ld = QB_TestDataFactory.createLeads(1, true);
        System.debug(' ** Lead1 Created = ' + ld);

        List<Task> EmailTasks = QB_TestDataFactory.createTaskRecordOnLead(10, true, 'Email', 'Email', ld[0].Id);
        System.debug(' ** EmailTasks Created = ' + EmailTasks);

        List<Task> CallTasks = QB_TestDataFactory.createTaskRecordOnLead(10, true, 'Call', 'Call', ld[0].Id);
        System.debug(' ** CallTasks Created = ' + CallTasks);

        Decimal i = 1;
        System.assertEquals(ld[0].Calls_Made__c, i);
    }

    @IsTest static void LeadTalkDeskTest(){
        List<Lead> Lead = QB_TestDataFactory.createLeads(1, true);
        System.debug(' ** Lead2 Created = ' + Lead);

        List<talkdesk__Talkdesk_Activity__c> TalkDeskActivity = QB_TestDataFactory.createTalkDeskActivityRecordOnLead(1, true, Lead[0].Id);
        System.debug(' ** TalkDeskActivity Created = ' + TalkDeskActivity);


    }
}