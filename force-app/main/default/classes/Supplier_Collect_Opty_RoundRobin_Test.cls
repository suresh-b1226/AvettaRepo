//Written by Dallin Wasden 4.26.2018
//Round robins new collection opportunities to distribute evenly among reps with "Collections" role. Allows opportunities to pile up to a predetermined pile size before
//assigning to reps. Sorts opportunities by dollar amounts in order to divvy ~evenly. Upon assignment, calls emailHelper class to automatically send out personalized
//1st collections email template from new owner.
@isTest public class Supplier_Collect_Opty_RoundRobin_Test {

    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_RoundRobin() {

        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);

        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);

        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(29, TRUE, accountRecords[0].id, billingAccountRecords[0].id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);

        //Create collections opportunity records for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createCollectionOptyRecord(29, TRUE, accountRecords[0].id, invoiceRecords, contactRecords[0].id);
        System.debug('after creating opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
  }
}