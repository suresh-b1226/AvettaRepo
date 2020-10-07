Global class Supplier_SavesDeact_Opty_EligibleUpdate implements Schedulable{
    Global void execute(SchedulableContext sc){
        Supplier_SavesDeact_FieldUpdate_Batch b = new Supplier_SavesDeact_FieldUpdate_Batch();
         if(!Test.isRunningTest()){
        Database.executebatch(b, 5);
         }
    }
}