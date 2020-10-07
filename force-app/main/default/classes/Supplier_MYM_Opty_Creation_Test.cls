//Created by Parker Brown on 11/27/2018
//Tests the creation of an MYM opty based on the subscription renewal date being within the appropriate time period 
//(60 days before the renewal date)
//Edited on 5/1/2019 to include two other test methods to test the scheduled classes for client opty creation

@IsTest public class Supplier_MYM_Opty_Creation_Test {
	
    public static testmethod void testMYMCreation() {
        
        Test.StartTest();
        Supplier_MYM_Opty_Creation MymOptySch = new Supplier_MYM_Opty_Creation();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, MymOptySch);
        Test.stopTest();
        
    }
    
    public static testmethod void clientInvoiceOptyTest(){
        Test.StartTest();
        Client_Billing_InvoiceOpty_Scheduled clientInvSch = new Client_Billing_InvoiceOpty_Scheduled();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, clientInvSch);
        Test.stopTest();
    }
    
    public static testmethod void clientCollectionOptyTest(){
        Test.StartTest();
        Client_Billing_CollectOpty_Scheduled clientCollSch = new Client_Billing_CollectOpty_Scheduled();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, clientCollSch);
        Test.stopTest();
    }
    
}