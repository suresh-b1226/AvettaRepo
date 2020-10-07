/**
 * Created by JasonMcGrew on 8/21/2019.
 *
 * Apex Test Class for Supplier_SavesDeact_Opty_Deactivation
 *
 */

@IsTest private class Supplier_SavesDeact_Opty_Deac_Test {

        @IsTest(SeeAllData = true)
        public static void midTermDeactivationRequests() {
            Account AccountRecord = QB_TestDataFactory.createAndInsertAccountRecord(true);
            //System.debug(' **** AccountRecord = '  + AccountRecord);

            Contact ContactRecord = QB_TestDataFactory.createAndInsertContactRecord(true, AccountRecord.Id, 'test@avetta.com');
            //System.debug(' **** ContactRecord = ' + ContactRecord);

            List<Zuora__CustomerAccount__c> billingAccount = QB_TestDataFactory.createBillingAccountRecord(1, true, AccountRecord.Id);
            //System.debug(' **** billingAccount = ' + billingAccount);

            Zuora__ZInvoice__c invoiceRecord = new Zuora__ZInvoice__c();
                invoiceRecord.Zuora__Account__c              = AccountRecord.Id;
                invoiceRecord.Zuora__BillingAccount__c       = billingAccount[0].Id;
                invoiceRecord.Zuora__Balance2__c             = 500;
                invoiceRecord.Most_Recent_Renewal_Invoice__c = true;
                invoiceRecord.PICSInvoiceTag__c              = 'Renewal';
                invoiceRecord.Zuora__PostedDate__c           = Date.today().addDays(-35);
            insert invoiceRecord;

            //System.debug(' **** invoiceRecord = ' + invoiceRecord);

            Zuora__Payment__c zuoraAccountPayment = new Zuora__Payment__c();
                zuoraAccountPayment.Zuora__Account__c        = AccountRecord.Id;
                zuoraAccountPayment.Name                     = 'Test Zuora Payment';
                zuoraAccountPayment.Zuora__PaymentMethod__c  = 'Web';
                zuoraAccountPayment.Zuora__Effective_Date__c = Date.today();
                zuoraAccountPayment.Zuora__SubmittedOn__c    = Date.today();
                zuoraAccountPayment.Zuora__BillingAccount__c = billingAccount[0].Id;
                zuoraAccountPayment.Zuora__Status__c         = 'Processed';
            insert zuoraAccountPayment;

            //System.debug(' **** zuoraAccountPayment = ' + zuoraAccountPayment);

            Zuora__Subscription__c subscriptionRecord = new Zuora__Subscription__c();
                subscriptionRecord.Name                      = 'Test Subscription';
                subscriptionRecord.Zuora__CustomerAccount__c = billingAccount[0].Id;
                subscriptionRecord.Zuora__Zuora_Id__c        = 'Test';
                subscriptionRecord.Zuora__TermStartDate__c   = Date.today().addDays(-405);
                subscriptionRecord.Zuora__Account__c         = AccountRecord.Id;
                subscriptionRecord.Zuora__Status__c          = 'Active';
                subscriptionRecord.Zuora__NextRenewalDate__c = Date.today().addDays(-40);
            insert subscriptionRecord;

            //System.debug(' **** subscriptionRecord = ' + subscriptionRecord);

            Case newCase = new Case();
                newCase.AccountId                  = AccountRecord.Id;
                newCase.ContactId                  = ContactRecord.Id;
                newCase.Subject                    = 'Test Case';
                newCase.Description                = 'TEST TEST TEST TEST';
                newCase.Origin                     = 'Phone';
                newCase.Type                       = 'Deactivation';
                newCase.DeactivationRequestDate__c = Date.today();
                newCase.Status                     = 'Closed';
                newCase.Resolution__c              = 'I can\'t justify the cost';
                newCase.RecordTypeId               = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
            insert newCase;

            //System.debug(' **** NewCase = ' + newCase);

            Opportunity newOpp = [
                    SELECT Name, StageName, Result__c, DeactivationRequestDate__c
                    FROM Opportunity
                    WHERE AccountId =: AccountRecord.Id
            ];
            //System.debug(' ** NEWOPP = ' + newOpp);

            newOpp = [
                    SELECT Result__c
                    FROM Opportunity
                    WHERE AccountId =: AccountRecord.Id
            ];

            System.assertEquals('Pending Deactivation', newOpp.Result__c );

    }

    @IsTest 
    public static void outsideDeactivationRequests() {
        //Create account record to be used for Testing
        List<roundRobinVariable__c> roundRobin = new List<roundRobinVariable__c>();

        for (Integer i=0; i<1; i++) {
            roundRobin.add(new roundRobinVariable__c(
                    Name            = 'Saves Deactivation',
                    roundRobinID__c = i));
        }
        insert roundRobin;

        List<Account> outsideAccountRecords = QB_TestDataFactory.createAccountRecordsWithCountry(1, true, 'PE');
        System.debug(' **** AccountRecord = ' + outsideAccountRecords);

        Contact ContactRecord = QB_TestDataFactory.createAndInsertContactRecord(true, outsideAccountRecords[0].Id, 'test@avetta.com');

        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE);

        List<Zuora__CustomerAccount__c> billingAccount = QB_TestDataFactory.createBillingAccountRecord(1, true, outsideAccountRecords[0].Id);
        System.debug(' **** billingAccount = ' + billingAccount);

        Zuora__ZInvoice__c invoiceRecord = new Zuora__ZInvoice__c();
            invoiceRecord.Zuora__Account__c              = outsideAccountRecords[0].Id;
            invoiceRecord.Zuora__BillingAccount__c       = billingAccount[0].Id;
            invoiceRecord.Zuora__Balance2__c             = 500;
            invoiceRecord.Most_Recent_Renewal_Invoice__c = true;
            invoiceRecord.PICSInvoiceTag__c              = 'Renewal';
            invoiceRecord.Zuora__PostedDate__c           = Date.today().addDays(-35);
        insert invoiceRecord;

        System.debug(' **** invoiceRecord = ' + invoiceRecord);

        Zuora__Payment__c zuoraAccountPayment = new Zuora__Payment__c();
            zuoraAccountPayment.Zuora__Account__c        = outsideAccountRecords[0].Id;
            zuoraAccountPayment.Name                     = 'Test Zuora Payment';
            zuoraAccountPayment.Zuora__PaymentMethod__c  = 'Web';
            zuoraAccountPayment.Zuora__Effective_Date__c = Date.today();
            zuoraAccountPayment.Zuora__SubmittedOn__c    = Date.today();
            zuoraAccountPayment.Zuora__BillingAccount__c = billingAccount[0].Id;
            zuoraAccountPayment.Zuora__Status__c         = 'Processed';
        insert zuoraAccountPayment;
        System.debug(' **** zuoraAccountPayment = ' + zuoraAccountPayment);

        Zuora__Subscription__c subscriptionRecord = new Zuora__Subscription__c();
            subscriptionRecord.Name                      = 'Test Subscription';
            subscriptionRecord.Zuora__CustomerAccount__c = billingAccount[0].Id;
            subscriptionRecord.Zuora__Zuora_Id__c        = 'Test';
            subscriptionRecord.Zuora__TermStartDate__c   = Date.today().addDays(5);
            subscriptionRecord.Zuora__Account__c         = outsideAccountRecords[0].Id;
            subscriptionRecord.Zuora__Status__c          = 'Active';
            subscriptionRecord.Zuora__NextRenewalDate__c = Date.today().addDays(5);
        insert subscriptionRecord;
        System.debug(' **** subscriptionRecord = ' + subscriptionRecord);

        Case newCase = new Case();
            newCase.AccountId                  = outsideAccountRecords[0].Id;
            newCase.ContactId                  = ContactRecord.Id;
            newCase.Subject                    = 'Test Case';
            newCase.Description                = 'TEST TEST TEST TEST';
            newCase.Origin                     = 'Phone';
            newCase.Type                       = 'Deactivation';
            newCase.DeactivationRequestDate__c = Date.today();
            newCase.Status                     = 'Closed';
            newCase.Resolution__c              = 'I can\'t justify the cost';
            newCase.RecordTypeId               = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();

        insert newCase;

        Opportunity newOpp = [
                SELECT Name, StageName, Result__c, DeactivationRequestDate__c
                FROM Opportunity
                WHERE AccountId =: outsideAccountRecords[0].Id
        ];
        System.debug(' ** NEWOPP = ' + newOpp);

        newOpp = [
                SELECT Result__c, StageName
                FROM Opportunity
                WHERE AccountId =: outsideAccountRecords[0].Id
        ];

        System.assertEquals('Ready for Deactivation - Refund', newOpp.StageName);
        System.assertEquals('Cancelled', newOpp.Result__c);

    }
}