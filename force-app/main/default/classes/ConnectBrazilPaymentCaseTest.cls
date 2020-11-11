/**
 * Created by dwasden on 11/2/2020.
 */

@IsTest
private class ConnectBrazilPaymentCaseTest {

    @IsTest
    static void newCase() {
        Double invoiceAmount = 100;
        Double termLength = 24;
        String currencyCode = 'USD';

        Account testAccount = new Account(Name='Test Account',
                                            RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(),
                                            AccountMongoID__c = '12345');

        insert testAccount;

        Contact testContact = new Contact(FirstName='Test',
                                            LastName='Contact',
                                            MongoDB_ID__c='6789');

        insert testContact;

        Id returnId = ConnectBrazilPaymentCase.insertCase(testAccount.AccountMongoID__c, testContact.Id, 100, 24, 'USD');
        System.assertEquals(100, [SELECT Invoice_Amount__c FROM Case WHERE Id =: returnId][0].Invoice_Amount__c);
    }

    @IsTest
    static void existingCase() {
        Double invoiceAmount = 100;
        Double termLength = 24;
        String currencyCode = 'USD';

        Account testAccount = new Account(Name='Test Account',
                                            RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(),
                                            AccountMongoID__c = '12345');

        insert testAccount;

        Contact testContact = new Contact(FirstName='Test',
                                            LastName='Contact',
                                            MongoDB_ID__c='6789');

        insert testContact;

        Case testCase = new Case(AccountId = testAccount.Id,
                                    ContactId = testContact.Id,
                                    Invoice_Amount__c = 105,
                                    Term_Length_Months__c = 12,
                                    RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Supplier - RSM').getRecordTypeId(),
                                    Origin = 'Avetta',
                                    Status = 'New',
                                    Priority = 'High',
                                    CurrencyIsoCode = 'USD');

        insert testCase;
        System.debug(testCase);

        Id testAccountId = testAccount.Id;
        Id returnId = ConnectBrazilPaymentCase.insertCase(testAccount.AccountMongoID__c, testContact.Id, 100, 24, 'USD');
        System.assertEquals(105, [SELECT Invoice_Amount__c FROM Case WHERE Id =: returnId][0].Invoice_Amount__c);
        System.assertEquals(1, database.countQuery('SELECT COUNT() FROM Case WHERE AccountId =: testAccountId'));

    }

    @IsTest
    static void coupon() {
        Double invoiceAmount = 100;
        Double termLength = 24;
        String currencyCode = 'USD';

        Account testAccount = new Account(Name='Test Account',
                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(),
                AccountMongoID__c = '12345');

        insert testAccount;

        Contact testContact = new Contact(FirstName='Test',
                LastName='Contact',
                MongoDB_ID__c='6789');

        insert testContact;

        Id returnId = ConnectBrazilPaymentCase.insertCase(testAccount.AccountMongoID__c, testContact.Id, 100, 24, 'USD');

        Id newCase = ConnectBrazilPaymentCase.updateCaseCouponCode(testAccount.AccountMongoID__c, 'ABC123');
        System.assertEquals('ABC123', [SELECT Id, Coupon_Code__c FROM Case WHERE Id =: newCase][0].Coupon_Code__c);
    }

}