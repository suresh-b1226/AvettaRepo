trigger Related_Client_Case_Trigger on Related_Client_Case__c (after insert, after update) {

 /**
 * Created by dwasden on 10/31/2018.
 */
    Supplier_CS_Case_RelatedAccount relatedAccount = new Supplier_CS_Case_RelatedAccount();

    //After insert and After Update.
    if(Trigger.isInsert  && Trigger.isBefore){

    }

    if(Trigger.isInsert  && Trigger.isAfter){
        relatedAccount.Supplier_CS_Case_RelatedAccount(Trigger.new);
    }

    if(Trigger.isUpdate  && Trigger.isAfter){
        relatedAccount.Supplier_CS_Case_RelatedAccount(Trigger.new);
    }
 
}