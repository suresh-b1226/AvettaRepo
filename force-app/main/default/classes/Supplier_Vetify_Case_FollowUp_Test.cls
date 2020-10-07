//Written by Dallin Wasden 5.21.2018
//Checks to see where updated Collections opportunity is in the emailing process. If it is deemed the proper time by the established criteria (facilitated by Spencer's workflow),
//then the 2nd, 3rd, and 4th emails are drafted through the emailHelper class and sent through this class. The Sent_Email_2__c, Sent_Email_3__c, and Sent_Email_4__c fields are then
//checked accordingly. This trigger and class is intended as a follow-up to the Supplier_Collect_Opty_RoundRobin class.
@isTest public class Supplier_Vetify_Case_FollowUp_Test {
	
    //Tests the sending of email #1 to a non-US opportunity
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_FollowUp_Email1() {

        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);
        
        caseRecords[0].Send_Email_1__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
 
    //Tests the sending of email #2 to a non-US opportunity
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_FollowUp_Email2() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_2__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    
    //Tests the sending of email #2 to a US opportunity
    /*
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_FollowUp_Email2US() {
        
        //Create account record for test purposes.
        List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecordsUS[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecordsUS[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, TRUE, accountRecordsUS[0].id, billingAccountRecords[0].id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        List<Opportunity> opportunityRecordsUs = QB_TestDataFactory.createCollectionOptyRecordEmailTester(1, TRUE, accountRecordsUs[0].id, invoiceRecords, contactRecords[0].id, FALSE, TRUE, FALSE, FALSE);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecordsUs);
        
        opportunityRecordsUs[0].Send_Email_2__c = Date.today();
        Update opportunityRecordsUs[0];
    }
	*/
    
    
    //Tests the sending of email #3 to a non-US opportunity
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_FollowUp_Email3() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_3__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    
    //Tests the sending of email #4 to a non-US opportunity
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_FollowUp_Email4() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_4__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    
    //Tests the sending of email #4 to a non-US opportunity
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_FollowUp_Email5() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_5__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    
    //************************************************************************			VETIFY LEGACY EMAIL TESTS
    //Canada legacy tests
    //Tests the sending of email #1 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_LegacyFollowUp_Email1() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_1__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    //Tests the sending of email #2 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_LegacyFollowUp_Email2() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);

        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_2__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];

    }
    //Tests the sending of email #3 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_LegacyFollowUp_Email3() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_3__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    //Tests the sending of email #4 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_LegacyFollowUp_Email4() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE, FALSE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_4__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    
    //Tests the sending of email #5 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_LegacyFollowUp_Email5() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE, FALSE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, FALSE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_5__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    
    //US Legacy Test
        //Tests the sending of email #1 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_Legacy_US_FollowUp_Email1() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_1__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    //Tests the sending of email #2 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_Legacy_US_FollowUp_Email2() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);

        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_2__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];

    }
    //Tests the sending of email #3 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_Legacy_US_FollowUp_Email3() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_3__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    //Tests the sending of email #4 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_Legacy_US_FollowUp_Email4() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE, FALSE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_4__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
    
    //Tests the sending of email #5 to a Vetify Legacy account
    @isTest(SeeAllData=true) static void Supplier_Collect_Opty_Legacy_US_FollowUp_Email5() {
        Supplier_Vetify_Case_FollowUp.setRunCountZero();
        //Create account record for test purposes.
        //List<Account> accountRecordsUs = QB_TestDataFactor  y.cr  
        //
        //
        //
        //   
        //
        //
        //eateClientAccountRecordsEmailCadence(1, TRUE, TRUE, FALSE);
        //System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecordsUs);
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecordsEmailCadence(1, TRUE, TRUE, FALSE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create collections contact records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        
        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createVetifyCaseRecordEmailTester(1, TRUE, accountRecords[0].id, contactRecords[0].id, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE);
        System.debug('after creating contacts in QB_TestDataFactory.createCaseRecords' + caseRecords);

        caseRecords[0].Send_Email_5__c = Date.today();
        caseRecords[0].Send_Fulfillment_Emails__c = TRUE;
        Update caseRecords[0];
    }
}