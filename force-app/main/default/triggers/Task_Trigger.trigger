/**
 * Created by dwasden on 10/31/2018 .
 */

trigger Task_Trigger on Task (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    linkTouchpointEmailToOpportunity   linkTouchpointEmailToOpportunity = new linkTouchpointEmailToOpportunity();
    updateEmailCallCount    emailCallHandler = new updateEmailCallCount();
    UpdateLeadEmailCallCount leadEmailCallHandler = new UpdateLeadEmailCallCount();
    supplier_SER_Opty_EmailAutomation  ser_EmailAutomation = new supplier_SER_Opty_EmailAutomation();
    //updateLeadStatus    updateLeadStatusHandler = new updateLeadStatus();
    //LeadStatusUpdate    LeadStatusUpdateHandler = new LeadStatusUpdate();

    //After insert and After Update.
    if(Trigger.isInsert  && Trigger.isAfter){
        linkTouchpointEmailToOpportunity.linkTouchpointEmailToOpportunityHandler(Trigger.new, Trigger.old, false);
        emailCallHandler.updateEmailCallCountHandler(Trigger.new, Trigger.old, false);
        leadEmailCallHandler.updateTask_LeadEmailCallCountHandler(Trigger.new);
        ser_EmailAutomation.ser_EmailAutomationHandler(Trigger.new);
        //updateLeadStatusHandler.updateLeadStatusHandler(Trigger.new);
        //LeadStatusUpdateHandler.LeadStatusUpdateHandler(Trigger.new);
    }

    if(Trigger.isUpdate  && Trigger.isAfter){
        linkTouchpointEmailToOpportunity.linkTouchpointEmailToOpportunityHandler(Trigger.new, Trigger.old, false);
        emailCallHandler.updateEmailCallCountHandler(Trigger.new, Trigger.old, false);
    }

    if(Trigger.isDelete  && Trigger.isAfter){
        emailCallHandler.updateEmailCallCountHandler(null, Trigger.old, true);
        linkTouchpointEmailToOpportunity.linkTouchpointEmailToOpportunityHandler(null, Trigger.old, true);
    }
    
    if(Trigger.isDelete  && Trigger.isBefore){
    }
}