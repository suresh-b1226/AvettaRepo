@isTest public class emailHelperTest {
	
    @isTest(SeeAllData=true) static void emailHelperTest() {
        
        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);
        
        List<Id> acctIds = new List<Id>();
        for(Account acct: accountRecords) {
            acctIds.add(acct.Id);
        }
        
        //Create collections opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(2, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);
        //added on 4/10 by Parker Brown -> used to test 'sendMYMEmail' method of emailHelper class.
        Contact mymContact = new Contact(AccountId = accountRecords[0].id,
                    FirstName = 'One',
                    LastName = 'test single contact',
                    Account_Type__c = 'Contractor',
                    CurrencyIsoCode = 'USD',
                    Phone = '619-000-0001',
                    Email = 'test@avetta.com',
                    Organizer_isActive__c = 'Yes',
                    Primary_PICS_Organizer_User__c = True);
        
        //Create collections opportunity records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createCaseRecords(0, TRUE, accountRecords[0].id, contactRecords[0].id);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.caseRecords' + caseRecords);
        
        //Create billing account record for test purposes.
        List<Zuora__CustomerAccount__c> billingAccountRecords = QB_TestDataFactory.createBillingAccountRecord(1, TRUE, accountRecords[0].id);
        System.debug('after creating billing account in QB_TestDataFactory.createBillingAccountRecord' + billingAccountRecords);
        
        //Create invoice record for test purposes.
        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(29, TRUE, accountRecords[0].id, billingAccountRecords[0].id);
        System.debug('after creating invoice in QB_TestDataFactory.invoiceRecords' + invoiceRecords);
        
        //Create collections opportunity records for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createCollectionOptyRecord(29, TRUE, accountRecords[0].id, invoiceRecords, contactRecords[0].id);
        System.debug('after creating opportunities in QB_TestDataFactory.createComboOpportunitiesRecord' + opportunityRecords);
        
        EmailTemplate template = [select Id from EmailTemplate where name = '1] Collections'];
        
        emailHelper.sendCollectionEmail(opportunityRecords[0], template, contactRecords, Id.valueOf('00570000004tHnB'), FALSE);
        emailHelper.sendCSWaitingEmail(caseRecords[0], template, contactRecords, Id.valueOf('00570000004tHnB'));
            emailHelper.sendDeactivationEmail(accountRecords[0], template, contactRecords, Id.valueOf('00570000004tHnB'), opportunityRecords[0], FALSE);
            emailHelper.sendMYMEmail(opportunityRecords[0], template, mymContact, Id.valueOf('00570000004tHnB'), acctIds);
            emailHelper.sendVetifyEmail(caseRecords[0], template, Id.valueOf('00570000004tHnB'), contactRecords);
    }
}