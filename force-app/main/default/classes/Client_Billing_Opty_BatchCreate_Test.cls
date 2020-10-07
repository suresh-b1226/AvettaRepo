//Created by Parker Brown 5/1/2019
//This is a test class for 'Client_Billing_CollectOpty_BatchCreate' and 'Client_Billing_InvoiceOpty_BatchCreate' classes.

@isTest 
public class Client_Billing_Opty_BatchCreate_Test 
{

    @testSetup 
    static void setup() {
        Date td = date.today();
        Date Dat7 = date.today().adddays(-30);
        List<Account> accounts = new List<Account>();
  		List<Zuora__Subscription__c> subs = new List<Zuora__Subscription__c>();
        List<Zuora__ZInvoice__c> invoices = new List<Zuora__ZInvoice__c>();
        List<Contact> contacts = new List<Contact>();
                
        // insert 10 accounts
        for (Integer i=0;i<5;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', 
                billingcountry='US', 
                CurrencyIsoCode = 'USD', 
                Status__c='Active', 
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(),
                Organizer_Id__c = '1233234'+i
            ));
                
        }
        insert accounts;
		
        //insert 10 contacts
        for (Account account : [select id from account]) {
            contacts.add(new Contact(FirstName='test1', LastName='test1',AccountId=account.id, 
                AP_Contact__c=True, Organizer_isActive__c='Active'));
        }
        insert contacts;
        
        //insert 10 subscriptions
        for (Account account : [select id from account]) {
            subs.add(new Zuora__Subscription__c(Zuora__Account__c=account.id, 
                Zuora__SubscriptionEndDate__c=td, Zuora__Status__c='Active'));
        }
        insert subs;
        
        //insert 10 invoices
        for (Account account : [select id from account]) {
            invoices.add(new Zuora__ZInvoice__c(name='testInvoice', Zuora__Account__c = account.id, PICSInvoiceTag__c = 'ClientRenewal', 
                                                Zuora__DueDate__c =Dat7,Zuora__Status__c='Posted'));
        }
        insert invoices;
    }
    
    static testmethod void testCollectOptyCreate() {        
        Test.startTest();
        Client_Billing_CollectOpty_BatchCreate bcollect = new Client_Billing_CollectOpty_BatchCreate();
        Database.executebatch(bcollect, 5);
        Test.stopTest();
        //after the testing stops, assert records were created properly
        System.assertEquals(5, [select count() from Opportunity]);
    }
    
    static testmethod void testInvoiceOptyCreate() {        
        Test.startTest();
        //Client_Billing_InvoiceOpty_BatchCreate binvoice = new Client_Billing_InvoiceOpty_BatchCreate();
        //Database.executebatch(binvoice, 5);
        Test.stopTest();
        //after the testing stops, assert records were created properly
        //System.assertEquals(5, [select count() from Opportunity]);
    }
    

}