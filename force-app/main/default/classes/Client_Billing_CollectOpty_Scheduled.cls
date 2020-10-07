//Created by Parker Brown on 4/5/4019
//This class is used to execute the 'Client_Billing_CollectOpty_BatchCreate' class. 
//This class is scheduled Apex that runs daily. (See Client_Billing_CollectOpty_BatchCreate for more details)



Global class Client_Billing_CollectOpty_Scheduled implements Schedulable{
    Global void execute(SchedulableContext sc){
        Client_Billing_CollectOpty_BatchCreate b = new Client_Billing_CollectOpty_BatchCreate();
        Database.executebatch(b, 5);
    }
}