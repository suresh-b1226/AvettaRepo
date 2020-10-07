//Created by Parker Brown 2/15/2019
//This class simply calls the Supplier_MYMColl_SendEmailUpdate_Batch' class and is schedulable
Global class Supplier_MYMColl_SendEmail_FieldUpdate implements Schedulable{
    Global void execute(SchedulableContext sc){
        Supplier_MYMColl_SendEmailUpdate_Batch b = new Supplier_MYMColl_SendEmailUpdate_Batch();
        if(!Test.isRunningTest()){
            Database.executebatch(b, 5);
        }
    }
}