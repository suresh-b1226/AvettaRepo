//Written by Dallin Wasden 5.21.2018
//Checks to see where updated Collections opportunity is in the emailing process. If it is deemed the proper time by the established criteria (facilitated by Spencer's workflow),
//then the 2nd, 3rd, and 4th emails are drafted through the emailHelper class and sent through this class. The Sent_Email_2__c, Sent_Email_3__c, and Sent_Email_4__c fields are then
//checked accordingly. This trigger and class is intended as a follow-up to the Supplier_Collect_Opty_RoundRobin class.
@IsTest public class Supplier_SavesDowngr_Opty_FollowUp_Test {
	
    //Tests the sending of email #1 to a Canada opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email1() {
         
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, false, false);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //create opportunity of type 'Saves Downgrade'
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, true, false, false, false);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        //opportunityRecordsUs[0].Send_Email_2__c = Date.today();
        //Update opportunityRecords[0];
        
        opportunityRecords[0].Send_Email_1__c = Date.today();
        update opportunityRecords[0];
    }
    //Tests the sending of email #1 to an India opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email1India() {
        
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, false, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //List<Opportunity> opportunityRecordsUs = QB_TestDataFactory.createCollectionOptyRecordEmailTester(1, TRUE, accountRecordsUs[0].id, invoiceRecords, contactRecords[0].id, TRUE, FALSE, FALSE);
        //System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecordsUs);
        
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, true, false, false, false);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        //opportunityRecordsUs[0].Send_Email_2__c = Date.today();
        //Update opportunityRecords[0];
        
        opportunityRecords[0].Send_Email_1__c = Date.today();
        update opportunityRecords[0];
    }
    
    //Tests the sending of email #1 to a US opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email1US() {
        
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, true, false);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //List<Opportunity> opportunityRecordsUs = QB_TestDataFactory.createCollectionOptyRecordEmailTester(1, TRUE, accountRecordsUs[0].id, invoiceRecords, contactRecords[0].id, TRUE, FALSE, FALSE);
        //System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecordsUs);
        
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, true, false, false, false);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        //opportunityRecordsUs[0].Send_Email_2__c = Date.today();
        //Update opportunityRecords[0];
        
        opportunityRecords[0].Send_Email_1__c = Date.today();
        update opportunityRecords[0];
    }
    
    //Tests the sending of email #2 to a Canada opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email2() {
        
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, false, false);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //List<Opportunity> opportunityRecordsUs = QB_TestDataFactory.createCollectionOptyRecordEmailTester(1, TRUE, accountRecordsUs[0].id, invoiceRecords, contactRecords[0].id, TRUE, FALSE, FALSE);
        //System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecordsUs);
        
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, false, true, false, false);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        //opportunityRecordsUs[0].Send_Email_2__c = Date.today();
        //Update opportunityRecords[0];
        
        opportunityRecords[0].Send_Email_2__c = Date.today();
        update opportunityRecords[0];
    }
    
    //Tests the sending of email #2 to a US opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email2US() {
        
        //Create account record for test purposes.
        List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, true, false);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecordsUs[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecordsUs[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecordsUs[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        List<Opportunity> opportunityRecordsUs = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecordsUs[0].Id, invoiceRecords, contactRecords[0].Id, false, true, false, false);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecordsUs);
        
        opportunityRecordsUs[0].Send_Email_2__c = Date.today();
        update opportunityRecordsUs[0];
    }
    
    //Tests the sending of email #2 to an India opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email2India() {
        
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, false, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //List<Opportunity> opportunityRecordsUs = QB_TestDataFactory.createCollectionOptyRecordEmailTester(1, TRUE, accountRecordsUs[0].id, invoiceRecords, contactRecords[0].id, TRUE, FALSE, FALSE);
        //System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecordsUs);
        
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, false, true, false, false);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        //opportunityRecordsUs[0].Send_Email_2__c = Date.today();
        //Update opportunityRecords[0];
        
        opportunityRecords[0].Send_Email_2__c = Date.today();
        update opportunityRecords[0];
    }
    //Tests the sending of email #3 to a Canada opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email3() {
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, false, false);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //Create collections opportunity records for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, false, false, true, false);
        System.debug('after creating opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
         opportunityRecords[0].Send_Email_3__c = Date.today();
        update opportunityRecords[0];
    }
    //Tests the sending of email #3 to a India opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email3India() {
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, false, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //Create collections opportunity records for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, false, false, true, false);
        System.debug('after creating opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
         opportunityRecords[0].Send_Email_3__c = Date.today();
        update opportunityRecords[0];
    }
    //Tests the sending of email #3 to a US opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email3US() {
        
        //Create account record for test purposes.
        List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, true, false);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecordsUs[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecordsUs[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecordsUs[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //Create collections opportunity records for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecordsUs[0].Id, invoiceRecords, contactRecords[0].Id, false, false, true, false);
        System.debug('after creating opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
         opportunityRecords[0].Send_Email_3__c = Date.today();
        update opportunityRecords[0];
    }
    
    //Tests the sending of email #4 to a Canada opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email4() {
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, false, false);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //Create collections opportunity records for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, false, false, false, true);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        opportunityRecords[0].Send_Email_4__c = Date.today();
        update opportunityRecords[0];
    }
    //Tests the sending of email #4 to a India opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email4India() {
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, false, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //Create collections opportunity records for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, false, false, false, true);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        opportunityRecords[0].Send_Email_4__c = Date.today();
        update opportunityRecords[0];
    }
    //Tests the sending of email #4 to a US opportunity
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_Email4US() {
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, true, false);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //Create collections opportunity records for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, false, false, false, true);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        opportunityRecords[0].Send_Email_4__c = Date.today();
        update opportunityRecords[0];
    }
    
    //Tests the sending of email not owned by collections rep
    @IsTest(SeeAllData=true) static void Suppler_SavesDowngr_Opty_FollowUp_EmailNoOwner() {
        
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, true, false, false);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, true, accountRecords[0].Id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, true, accountRecords[0].Id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, accountRecords[0].Id, billingAccountRecords[0].Id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //List<Opportunity> opportunityRecordsUs = QB_TestDataFactory.createCollectionOptyRecordEmailTester(1, TRUE, accountRecordsUs[0].id, invoiceRecords, contactRecords[0].id, TRUE, FALSE, FALSE);
        //System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecordsUs);
        
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createSavesDowngradeOptyRecordEmailTester(1, true, accountRecords[0].Id, invoiceRecords, contactRecords[0].Id, false, false, false, false);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        //opportunityRecordsUs[0].Send_Email_2__c = Date.today();
        //Update opportunityRecords[0];
        
        opportunityRecords[0].Send_Email_1__c = Date.today();
        update opportunityRecords[0];
    }
}