/**
 * Created by JasonMcGrew on 6/3/2019.
 *
 * Modified By Mark Simpson on 3/4/2020
 *
 * Updated to trigger on email events for a talkdesk activity and audio files from callminer
 */

trigger Talkdesk_Trigger on talkdesk__Talkdesk_Activity__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    UpdateLeadEmailCallCount talkdeskLeadEmailCallHandler = new UpdateLeadEmailCallCount();
    API_CS_Callminer_Audio callMinerAPI = new API_CS_Callminer_Audio();
    updateEmailCallCount emailCallCountHandler = new updateEmailCallCount();
    supplier_SER_Opty_EmailAutomation  ser_EmailAutomation = new supplier_SER_Opty_EmailAutomation();

    //After insert and After Update.
    if(Trigger.isInsert  && Trigger.isAfter){
        //talkdeskLeadEmailCallHandler.updateTalkdesk_LeadEmailCallCountHandler(Trigger.new);
        callMinerAPI.generateTalkDeskJSON(Trigger.new);
        emailCallCountHandler.updateEmailCallCountHandler(Trigger.new, Trigger.old, FALSE);
        ser_EmailAutomation.ser_EmailAutomationHandler(Trigger.new);
    }

    if(Trigger.isUpdate  && Trigger.isAfter){
        //talkdeskLeadEmailCallHandler.updateTalkdesk_LeadEmailCallCountHandler(Trigger.new);
        callMinerAPI.generateTalkDeskJSON(Trigger.new);
        emailCallCountHandler.updateEmailCallCountHandler(Trigger.new, Trigger.old, FALSE);
        ser_EmailAutomation.ser_EmailAutomationHandler(Trigger.new);
    }
}