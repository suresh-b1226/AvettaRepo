/**
 * Created by brett on 3/17/18.
 */

@IsTest
public with sharing class API_CONNECT_Invoice_TriggerHandlerTests {

    private static Account createAccount() {
        Datetime sameDate = Datetime.now();
        Account account = new Account();
        account.Name = 'Test Account ' + sameDate;

        upsert account;

        return account;
    }
    private static Zuora__ZInvoice__c createInvoice(Account account, Boolean insertInvoice) {
        Zuora__ZInvoice__c invoice = new Zuora__ZInvoice__c();
        invoice.Zuora__Account__c = account.Id;

        if (insertInvoice) {
            insert invoice;
        }
        return invoice;
    }

    private static Opportunity createOpportunity(Account[] accounts, Boolean insertOpportunity) {

        Schema.DescribeFieldResult fieldResult =
                Opportunity.Self_Registered_Status__c.getDescribe();
        Schema.PicklistEntry[] ple = fieldResult.getPicklistValues();

        Opportunity returnOpportunity = New Opportunity();
        returnOpportunity.AccountId = accounts[0].Id;
        returnOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        returnOpportunity.Client_Account__c = accounts[1].Id;
        returnOpportunity.Type = null;
        returnOpportunity.StageName = 'Closed Won';
        returnOpportunity.Name = 'test Opportunity';
        returnOpportunity.CloseDate = Date.today().addDays(-15);
        returnOpportunity.Self_Registered_Status__c = ple[0].getValue();
        returnOpportunity.Free_Connection__c = false;

        if (insertOpportunity) {
            insert returnOpportunity;
        }
        return returnOpportunity;

    }


    // Happy Path Tests

    static testMethod void testSetLastInvoiceDate() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange
        Account account = createAccount();

        // Act
        Test.startTest();
        Zuora__ZInvoice__c invoice = createInvoice(account, true);
        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate From Zuora__ZInvoice__c WHERE Zuora__Account__c = :account.Id];
        Account resultAccount = [SELECT Id, Last_Invoice_Date__c FROM Account WHERE Id = :account.Id];

        // Assert
        System.assert(resultAccount.Last_Invoice_Date__c != null);

        System.assertEquals(resultInvoice.CreatedDate, resultAccount.Last_Invoice_Date__c);

        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadeInvoiceTypeRegistration() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;

        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);
        contractorOpportunity.Type = 'Registration';
        insert contractorOpportunity;


        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);

        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);
        System.assertEquals(true, resultOperatorContractor.Initial_Payment_Made__c);
        System.assertEquals(true, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadeInvoiceTypeReactivation() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;


        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);
        contractorOpportunity.Type = 'Reactivation';
        insert contractorOpportunity;


        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);

        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);
        System.assertNotEquals(resultOperatorContractor.Initial_Payment_Made__c, operatorContractor.Initial_Payment_Made__c);
        System.assertEquals(true, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadeInvoiceTypeUpgradeFreeConnection() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;


        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);
        contractorOpportunity.Type = 'Upgrade';
        contractorOpportunity.Free_Connection__c = true;
        insert contractorOpportunity;


        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);

        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);
        System.assertNotEquals(resultOperatorContractor.Initial_Payment_Made__c, operatorContractor.Initial_Payment_Made__c);
        System.assertEquals(true, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadeInvoiceTypeUpgradeNotFreeConnection() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;


        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);
        contractorOpportunity.Type = 'Upgrade';
        contractorOpportunity.Free_Connection__c = true;
        insert contractorOpportunity;


        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);

        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);
        System.assertNotEquals(resultOperatorContractor.Initial_Payment_Made__c, operatorContractor.Initial_Payment_Made__c);
        System.assertEquals(true, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadeInvoiceTypeNull() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;


        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);

        insert contractorOpportunity;


        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);
        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);
        System.assertNotEquals(resultOperatorContractor.Initial_Payment_Made__c, operatorContractor.Initial_Payment_Made__c);
        System.assertEquals(true, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    // Not Happy Paths

    static testMethod void testSetInitialPaymentMadeInvoiceTypeOther() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;

        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);
        contractorOpportunity.Type = 'Other';
        insert contractorOpportunity;

        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);

        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);

        System.assertEquals(false, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadeInvoiceTypeBad() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;
        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);
        contractorOpportunity.Type = 'bad';
        insert contractorOpportunity;

        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);

        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);

        System.assertEquals(false, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadePaymentAmountZero() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;

        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);

        insert contractorOpportunity;

        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);

        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 0;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(0, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);

        System.assertEquals(false, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadeBalanceGreaterThanZero() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;
        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);

        insert contractorOpportunity;

        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);

        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = 1;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(1, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);

        System.assertEquals(false, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadeOperatorContractorCreatedBeforeLastInvoiceUpgradeNotFree() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-5);
        insert operatorContractor;

        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);
        contractorOpportunity.Type = 'Upgrade';
        insert contractorOpportunity;


        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-7);
        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);

        System.assertEquals(false, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }

    static testMethod void testSetInitialPaymentMadeOperatorContractorLessThan10DaysAgo() {
        System.debug('START: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');

        // Arrange

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;
        accountRecords[0].Organizer_ID__c = '1234';
        accountRecords[1].Organizer_ID__c = '0987';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];

        operatorContractor.CreatedDate = Date.today().addDays(-1);
        insert operatorContractor;

        Opportunity contractorOpportunity = createOpportunity(accountRecords, false);

        insert contractorOpportunity;

        Zuora__ZInvoice__c invoice = createInvoice(accountRecords[0], false);

        invoice.CreatedDate = Date.today().addDays(-15);

        insert invoice;


        // Act
        Test.startTest();
        invoice.Zuora__PaymentAmount__c = 100;
        invoice.Zuora__Balance__c = -10;
        upsert invoice;

        Test.stopTest();

        Zuora__ZInvoice__c resultInvoice = [SELECT Id, CreatedDate, Zuora__Balance__c, Zuora__PaymentAmount__c From Zuora__ZInvoice__c WHERE Zuora__Account__c = :accountRecords[0].Id];
        Operator_Contractor__c resultOperatorContractor = [SELECT Id, Initial_Payment_Made__c FROM Operator_Contractor__c WHERE Id = :operatorContractor.Id];


        // Assert

        System.assertEquals(-10, resultInvoice.Zuora__Balance__c);
        System.assertEquals(100, resultInvoice.Zuora__PaymentAmount__c);
        System.assertEquals(resultOperatorContractor.Id, operatorContractor.Id);

        System.assertEquals(false, resultOperatorContractor.Initial_Payment_Made__c);


        System.debug('END: API_CONNECT_Invoice_TriggerHandlerTests.testSetLastInvoiceDate');
    }


}