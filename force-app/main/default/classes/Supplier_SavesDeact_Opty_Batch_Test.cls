/**
 * Created by JasonMcGrew on 9/23/2019.
 *
 * Apex Test Class for 'Supplier_SavesDeact_Opty_Deact_Batch'
 *
 *
 *
 */

@IsTest private class Supplier_SavesDeact_Opty_Batch_Test {

    @IsTest /*(SeeAllData = true)*/
    static void deactivateAccounts() {

        List<roundRobinVariable__c> roundRobin = new List<roundRobinVariable__c>();

        for (Integer i=0; i<1; i++) {
            roundRobin.add(new roundRobinVariable__c(
                    Name            = 'Saves Deactivation',
                    roundRobinID__c = i));
        }
        insert roundRobin;

        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE);

        Account AccountRecord = QB_TestDataFactory.createAndInsertAccountRecord(true);
        System.debug(' **** AccountRecord = '  + AccountRecord);

        List<Zuora__CustomerAccount__c> billingAccount = QB_TestDataFactory.createBillingAccountRecord(1, true, AccountRecord.Id);
        System.debug(' **** billingAccount = ' + billingAccount);

        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, AccountRecord.Id, billingAccount[0].Id);
        System.debug(' **** invoiceRecords = ' + invoiceRecords);

        Zuora__Payment__c zuoraAccountPayment = new Zuora__Payment__c();
        zuoraAccountPayment.Zuora__Account__c        = AccountRecord.Id;
        zuoraAccountPayment.Name                     = 'Test Zuora Payment';
        zuoraAccountPayment.Zuora__PaymentMethod__c  = 'Web';
        zuoraAccountPayment.Zuora__Effective_Date__c = Date.today().addDays(-365);
        zuoraAccountPayment.Zuora__SubmittedOn__c    = Date.today().addDays(-365);
        zuoraAccountPayment.Zuora__BillingAccount__c = billingAccount[0].Id;
        zuoraAccountPayment.Zuora__Status__c         = 'Processed';
        insert zuoraAccountPayment;

        System.debug(' **** zuoraAccountPayment = ' + zuoraAccountPayment);

        Zuora__Subscription__c subscriptionRecord = new Zuora__Subscription__c();
        subscriptionRecord.Name                      = 'Test Subscription';
        subscriptionRecord.Zuora__CustomerAccount__c = billingAccount[0].Id;
        subscriptionRecord.Zuora__Zuora_Id__c        = 'Test';
        subscriptionRecord.Zuora__TermStartDate__c   = Date.today().addDays(5);
        insert subscriptionRecord;

        Contact ContactRecord = QB_TestDataFactory.createAndInsertContactRecord(true, AccountRecord.Id, 'test@avetta.com');
        System.debug(' **** ContactRecord = ' + ContactRecord);

        Opportunity retOptyRecord1 = new Opportunity();
            retOptyRecord1.Name                         = 'Deactivation Request';
            retOptyRecord1.AccountId                    = AccountRecord.Id;
            retOptyRecord1.RecordTypeId                 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId();
            retOptyRecord1.CloseDate                    = Date.today().addDays(10);
            retOptyRecord1.StageName                    = 'Open';
            retOptyRecord1.CurrencyIsoCode              = 'USD';
            retOptyRecord1.Renewal_Date__c              = Date.today().addDays(325);
            retOptyRecord1.CreatedDate                  = Date.today();
            retOptyRecord1.Term_Start_Date__c           = Date.today().addDays(-65);
            retOptyRecord1.Eligible_for_Deactivation__c = true;
            retOptyRecord1.Send_Email_1__c              = Date.today().addDays(-65);
            retOptyRecord1.Send_Email_2__c              = Date.today();
            retOptyRecord1.Send_Email_3__c              = Date.today();
            retOptyRecord1.Send_Email_4__c              = Date.today();
            retOptyRecord1.Start_Automated_Email_Send__c= Date.today();
            //retOptyRecord1.Membership_Level_Offered__c  = '0%';

            insert retOptyRecord1;
        System.debug(' **** retOptyRecord1 = '  + retOptyRecord1);


        Test.startTest();
        Supplier_SavesDeact_Opty_Deact_Batch b = new Supplier_SavesDeact_Opty_Deact_Batch();
        Database.executeBatch(b);
        Test.stopTest();


        retOptyRecord1 = [
                SELECT StageName, Result__c
                FROM Opportunity
                WHERE Id =: retOptyRecord1.Id
        ];

        System.assertEquals('Cancelled', retOptyRecord1.Result__c );
        System.assertEquals('Ready for Deactivation', retOptyRecord1.StageName );

    }

    @IsTest /*(SeeAllData = true)*/
    public static void deactivatePaidAccounts() {

        List<roundRobinVariable__c> roundRobin = new List<roundRobinVariable__c>();

        for (Integer i=0; i<1; i++) {
            roundRobin.add(new roundRobinVariable__c(
                    Name            = 'Saves Deactivation',
                    roundRobinID__c = i));
        }
        insert roundRobin;

        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE);

        //Create account record to be used for Testing
        List<Account> AccountRecords = QB_TestDataFactory.createAccountRecordsWithCountry(1, true, 'PE');
        System.debug(' **** AccountRecord = ' + AccountRecords);

        List<Zuora__CustomerAccount__c> billingAccount = QB_TestDataFactory.createBillingAccountRecord(1, true, AccountRecords[0].Id);
        System.debug(' **** billingAccount = ' + billingAccount);

        List<Zuora__ZInvoice__c> invoiceRecords = QB_TestDataFactory.createInvoiceRecord(1, true, AccountRecords[0].Id, billingAccount[0].Id);
        System.debug(' **** invoiceRecords = ' + invoiceRecords);

        Zuora__Payment__c zuoraAccountPayment = new Zuora__Payment__c();
            zuoraAccountPayment.Zuora__Account__c        = AccountRecords[0].Id;
            zuoraAccountPayment.Name                     = 'Test Zuora Payment';
            zuoraAccountPayment.Zuora__PaymentMethod__c  = 'Web';
            zuoraAccountPayment.Zuora__Effective_Date__c = Date.today();
            zuoraAccountPayment.Zuora__SubmittedOn__c    = Date.today().addDays(-75);
            zuoraAccountPayment.Zuora__BillingAccount__c = billingAccount[0].Id;
            zuoraAccountPayment.Zuora__Status__c         = 'Processed';
        insert zuoraAccountPayment;

        System.debug(' **** zuoraAccountPayment = ' + zuoraAccountPayment);

        Zuora__Subscription__c subscriptionRecord = new Zuora__Subscription__c();
            subscriptionRecord.Name                      = 'Test Subscription';
            subscriptionRecord.Zuora__CustomerAccount__c = billingAccount[0].Id;
            subscriptionRecord.Zuora__Zuora_Id__c        = 'Test';
            subscriptionRecord.Zuora__TermStartDate__c   = Date.today().addDays(5);
        insert subscriptionRecord;

        System.debug(' **** subscriptionRecord = ' + subscriptionRecord);

        Opportunity retOptyRecord = new Opportunity();
            retOptyRecord.Name                          = 'Deactivation Request';
            retOptyRecord.AccountId                     = AccountRecords[0].Id;
            retOptyRecord.RecordTypeId                  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId();
            retOptyRecord.CloseDate                     = Date.today().addDays(10);
            retOptyRecord.StageName                     = 'Open';
            retOptyRecord.CurrencyIsoCode               = 'USD';
            retOptyRecord.Renewal_Date__c               = Date.today().addDays(-65);
            retOptyRecord.CreatedDate                   = Date.today();
            retOptyRecord.Term_Start_Date__c            = Date.today().addDays(-65);
            retOptyRecord.Eligible_for_Deactivation__c  = true;
            retOptyRecord.Send_Email_1__c               = Date.today().addDays(-65);
            retOptyRecord.Send_Email_2__c               = Date.today();
            retOptyRecord.Send_Email_3__c               = Date.today();
            retOptyRecord.Send_Email_4__c               = Date.today();
            retOptyRecord.Start_Automated_Email_Send__c = Date.today();
            //retOptyRecord.Membership_Level_Offered__c   = '0%';

        insert retOptyRecord;

        System.debug(' **** retOptyRecord = ' + retOptyRecord);

        Test.startTest();
        Supplier_SavesDeact_Opty_Deact_Batch b = new Supplier_SavesDeact_Opty_Deact_Batch();
        Database.executeBatch(b);
        Test.stopTest();

        retOptyRecord = [
                SELECT StageName, Result__c
                FROM Opportunity
                WHERE Id =: retOptyRecord.Id
        ];

        System.assertEquals('Cancelled', retOptyRecord.Result__c );
        System.assertEquals('Ready for Deactivation - Refund', retOptyRecord.StageName );

    }
}