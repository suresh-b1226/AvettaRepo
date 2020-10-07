trigger QB_OperatorContractorHandlerTrigger on Operator_Contractor__c (after delete, after insert, after undelete,after update, before delete, before insert, before update)
{
    qB_OperatorContractorHandler   handler = new qB_OperatorContractorHandler(Trigger.isExecuting);
    
    //After insert and After Update. 
    if(Trigger.isInsert  && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new, Trigger.newMap);   
    }
    
    if(Trigger.isUpdate  && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
    }     
}