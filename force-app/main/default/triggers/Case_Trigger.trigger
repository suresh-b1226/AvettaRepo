/**
 * Created by dwasden on 10/31/2018.
 *
 * Updated on 11/6/2020 by Jason McGrew for SF Case # 03274885. Added a Trigger validation rule.
 */

trigger Case_Trigger on Case (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    Supplier_Vetify_Case_RoundRobin   vetifyRoundRobin = new Supplier_Vetify_Case_RoundRobin();
    Supplier_Vetify_Case_FollowUp   vetifyFollowUp = new Supplier_Vetify_Case_FollowUp();
    //Supplier_CS_Case_Waiting caseWaiting = new Supplier_CS_Case_Waiting();

    Client_CSM_Case_CloseValidation validateCase = new Client_CSM_Case_CloseValidation();

    //After insert and After Update.
    if (Trigger.isInsert  && Trigger.isBefore){
        vetifyRoundRobin.Supplier_Vetify_Case_RoundRobinHandler(Trigger.new, Trigger.old);
    }

    if (Trigger.isInsert  && Trigger.isAfter){
		//caseWaiting.Supplier_CS_Case_Waiting_Handler(Trigger.new, Trigger.old, TRUE);
    }

    if (Trigger.isUpdate  && Trigger.isBefore) {
        for(Case c : Trigger.new) {
            if (c.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Client').getRecordTypeId() &&
                    c != null &&
                    c.Type == 'Complaint' &&
                    c.Status == 'Closed') {
                validateCase.validateAssociatedCases(Trigger.new);{
                    if (validateCase.stillOpenCases == true) {
                        c.addError('Case cannot be closed with tasks that are not completed.');
                    }
                }
            }
        }
    }
    
    if (Trigger.isUpdate  && Trigger.isAfter){
        vetifyFollowUp.Supplier_Vetify_Case_FollowUp_Handler(Trigger.new, Trigger.old);
        //caseWaiting.Supplier_CS_Case_Waiting_Handler(Trigger.new, Trigger.old, FALSE);

    }

}