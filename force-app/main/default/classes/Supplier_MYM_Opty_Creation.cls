//Created by Parker Brown on 11/13/2018
//This class is used to execute the 'Batch_MYM_CreateOpty' class. 
//This class is scheduled Apex that runs daily. (See Batch_MYM_CreateOpty for more details)



Global class Supplier_MYM_Opty_Creation implements Schedulable{
    Global void execute(SchedulableContext sc){
        Supplier_MYM_Opty_BatchCreate b = new Supplier_MYM_Opty_BatchCreate();
        Database.executebatch(b, 5);
    }
}