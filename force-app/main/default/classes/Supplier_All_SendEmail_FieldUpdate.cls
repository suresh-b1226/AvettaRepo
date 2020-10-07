//Created by Parker Brown 2/15/2019
//This class simply calls the 'Supplier_All_SendEmailUpdate_Batch' class and is schedulable
Global class Supplier_All_SendEmail_FieldUpdate implements Schedulable{
    Global void execute(SchedulableContext sc){
        Supplier_All_SendEmailUpdate_Batch b = new Supplier_All_SendEmailUpdate_Batch();
        if(!Test.isRunningTest()){
            Database.executebatch(b, 5);
        }
    }
}