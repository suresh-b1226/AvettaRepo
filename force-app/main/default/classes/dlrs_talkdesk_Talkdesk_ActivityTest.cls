/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_talkdesk_Talkdesk_ActivityTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_talkdesk_Talkdesk_ActivityTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new talkdesk__Talkdesk_Activity__c());
    }
}