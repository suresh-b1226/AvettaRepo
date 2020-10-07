//Created by Parker Brown on 4/5/2019
//This class is used to execute the 'Client_Billing_InvoiceOpty_BatchCreate' class. 
//This class is scheduled Apex that runs daily. (See Client_Billing_InvoiceOpty_BatchCreate for more details)



Global class Client_Billing_InvoiceOpty_Scheduled implements Schedulable{
    Global void execute(SchedulableContext sc){
        Client_Billing_InvoiceOpty_BatchCreate b = new Client_Billing_InvoiceOpty_BatchCreate();
        Database.executebatch(b, 5);
    }
}