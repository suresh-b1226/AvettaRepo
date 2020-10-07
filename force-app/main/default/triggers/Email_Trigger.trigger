trigger Email_Trigger on EmailMessage (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    UpdateLeadEmailCallCount talkdeskLeadEmailCallHandler = new UpdateLeadEmailCallCount();
    API_CS_Callminer_Email callMinerAPIEmail = new API_CS_Callminer_Email();

    //After insert and After Update.
    if (Trigger.isInsert && Trigger.isAfter) {
        //talkdeskLeadEmailCallHandler.updateTalkdesk_LeadEmailCallCountHandler(Trigger.new);
        callMinerAPIEmail.generateEmailJSON(Trigger.new);
    }

    if (Trigger.isUpdate && Trigger.isAfter) {
        //talkdeskLeadEmailCallHandler.updateTalkdesk_LeadEmailCallCountHandler(Trigger.new);
        callMinerAPIEmail.generateEmailJSON(Trigger.new);
    }
}