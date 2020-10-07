/**
 * Created by brett on 3/17/18.
 */

trigger API_CONNECT_Invoice on Zuora__ZInvoice__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    API_CONNECT_Invoice_TriggerHandler handler = new API_CONNECT_Invoice_TriggerHandler(true);

//    /* Before Insert */
//    if(Trigger.isInsert && Trigger.isBefore){
//        handler.OnBeforeInsert(Trigger.new);
//    }
    /* After Insert */
//     else
    if (Trigger.isInsert && Trigger.isAfter) {
        handler.OnAfterInsert(Trigger.new);
    }
//    /* Before Update */
//    else if(Trigger.isUpdate && Trigger.isBefore){
//        handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
//    }

    /* After Update */
    else if (Trigger.isUpdate && Trigger.isAfter) {
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }

//    /* Before Delete */
//    else if(Trigger.isDelete && Trigger.isBefore){
//        handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
//    }
//    /* After Delete */
//    else if(Trigger.isDelete && Trigger.isAfter){
//        handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
//    }
//
//    /* After Undelete */
//    else if(Trigger.isUnDelete){
//        handler.OnUndelete(Trigger.new);
//    }


}