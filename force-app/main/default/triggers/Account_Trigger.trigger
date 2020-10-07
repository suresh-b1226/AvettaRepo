/**
 * Created by dwasden on 10/31/2018.
 */

trigger Account_Trigger on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    Supplier_Collect_Acct_Deactivated   Supplier_Collect_Acct_DeactivatedHandler = new Supplier_Collect_Acct_Deactivated();
    updateOCStatusFromAccount   updateOCStatusFromAccountHandler = new updateOCStatusFromAccount();

    //After insert and After Update.
    if(Trigger.isInsert  && Trigger.isAfter){
        updateOCStatusFromAccountHandler.updateOCStatusFromAccountHandler(Trigger.new, Trigger.old);
    }

    if(Trigger.isUpdate  && Trigger.isBefore){
        Supplier_Collect_Acct_DeactivatedHandler.Supplier_Collect_Acct_DeactivatedHandler(Trigger.new, Trigger.old);
    }

    if(Trigger.isUpdate  && Trigger.isAfter){
        updateOCStatusFromAccountHandler.updateOCStatusFromAccountHandler(Trigger.new, Trigger.old);
    }
}