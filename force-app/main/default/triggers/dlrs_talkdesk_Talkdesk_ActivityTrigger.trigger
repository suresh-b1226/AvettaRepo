/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_talkdesk_Talkdesk_ActivityTrigger on talkdesk__Talkdesk_Activity__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(talkdesk__Talkdesk_Activity__c.SObjectType);
}