//Written by Dallin Wasden 6.5.2018
//Sends email to all contacts on an account upon deactivation of an account with record type 'contractor'.
@isTest public class Supplier_Collect_Acct_Deactivated_Test {  
    
    @isTest(SeeAllData=true) static void Supplier_Collect_Acct_Deactivated() {
    //Tests the sending of email #4 to a non-US opportunity
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, TRUE, accountRecords[0].id, billingAccountRecords[0].id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //Create collections opportunity records for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createCollectionOptyRecord(1, TRUE, accountRecords[0].id, invoiceRecords, contactRecords[0].id);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        accountRecords[0].Status__c = 'Deactivated';
        accountRecords[0].Sent_Deactivation_Notification__c=Date.today();
        System.debug('Test status = ' + accountRecords[0].Status__c);
        update accountRecords[0];
    }
}