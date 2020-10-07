/**
 * Created by brett on 5/31/18.
 */

@IsTest
private class API_CONNECT_HelpersTest {

    @IsTest
    static void testLogException() {

        Test.startTest();
        try {
            throw new API_CONNECT_Helpers.ApiConnectException();
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
        }
        Test.stopTest();

    }

    @IsTest
    static void testInsertOpportunityFromMatch() {
        // Arrange
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();
        Account matchAccount = accounts[0];

        match.accountRecordType__c = 'Client';
        match.accountName__c = 'MatchName';
        match.OrganizerId__c = 'test';
        match.lastName__c = 'testLName';
        match.firstName__c = 'testfName';
        match.Deadline__c = Date.today();
        match.Account__c = matchAccount.Id;


        insert match;

// Act
        Test.startTest();

        API_CONNECT_Helpers.insertOpportunityFromMatch(match);
        Test.stopTest();

        Opportunity[] results = [
                SELECT
                        Id,
                        Name,
                        Primary_Contact__r.FirstName,
                        Primary_Contact__r.LastName
                FROM Opportunity
                WHERE Name = :matchAccount.Name
        ];

        System.assertEquals(1, results.size());

        Opportunity result = results[0];

        System.assertEquals(matchAccount.Name, result.Name);
        System.assertEquals(match.firstName__c, result.Primary_Contact__r.FirstName);
        System.assertEquals(match.lastName__c, result.Primary_Contact__r.LastName);
    }

    @IsTest
    static void testInsertOpportunityFromMatchWithNotAccount() {
        /*
        // Arrange
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();
        Account matchAccount = accounts[0];

        match.accountName__c = 'MatchName';
        match.accountRecordTypeId__c = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        match.OrganizerId__c = 'test';
        match.lastName__c = 'testLName';
        match.firstName__c = 'testfName';
        match.Deadline__c = Date.today();


//        insert match;
// Act

        Test.startTest();

        Opportunity results = API_CONNECT_Helpers.insertOpportunityFromMatch(match);

        Test.stopTest();

        Opportunity[] resultsQueried = [
                SELECT
                        Id,
                        Name,
                        Primary_Contact__r.FirstName,
                        Primary_Contact__r.LastName,
                        Priority__c
                FROM Opportunity
                WHERE Name = :results.Name
        ];

        //System.assertEquals(1, resultsQueried.size());

        Opportunity result = resultsQueried[0];

        System.assertEquals(result.Name, results.Name);
        System.assertEquals('Registration Request', results.Priority__c);
		*/
    }

    @IsTest
    static void testGetContractorMatch() {

        API_CONNECT_ContractorMatchCntrTest.makeMatches(true);

        Contractor_Match__c[] matches = [
                SELECT
                        Account__c,
                        City__c,
                        CurrencyIsoCode,
                        Id,
                        IsDeleted,
                        Name,
                        OwnerId,
                        Phone_Number__c,
                        webUrl__c
                FROM Contractor_Match__c
                ORDER BY Name
        ];

        // Act
        Test.startTest();

        API_CONNECT_ContractorMatchController.DTOoptions options = new API_CONNECT_ContractorMatchController.DTOoptions();
        options.page = 0;
        options.pageSize = 2;
        options.orderBy = 'name';

        String stringOptions = JSON.serialize(options);

        Contractor_Match__c[] results = API_CONNECT_ContractorMatchController.getContractorMatches(stringOptions);
        Test.stopTest();

        // Assert
        System.assertEquals(results.size(), 2);

        Contractor_Match__c resultOne = results[0];
        Contractor_Match__c matchOne = matches[0];
        Contractor_Match__c resultTwo = results[1];
        Contractor_Match__c matchTwo = matches[1];

        API_CONNECT_ContractorMatchCntrTest.assertMatchesMatch(matchOne, resultOne);
        API_CONNECT_ContractorMatchCntrTest.assertMatchesMatch(matchTwo, resultTwo);

    }

    @IsTest
    static void testInsertContractorAccount() {

        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.accountName__c = 'MatchName';
        match.OrganizerId__c = '12349999';
        match.lastName__c = 'last';
        match.firstName__c = 'first';

        Account matchAccount = accounts[0];

        insert match;

        Test.startTest();

        API_CONNECT_ContractorMatchController.createAccountFromMatch(match.Id);
        Test.stopTest();

        Account[] results = [
                SELECT
                        Id
                FROM Account
                WHERE Organizer_ID__c = :match.OrganizerId__c
        ];

        System.assertEquals(1, results.size());

    }

    @IsTest
    static void testInsertContractorContact() {

        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.accountName__c = 'MatchName';
        match.OrganizerId__c = 'test';
        match.lastName__c = 'testLName';
        match.firstName__c = 'testfName';
        match.Deadline__c = Date.today();

        Account matchAccount = accounts[0];

        match.Account__c = matchAccount.Id;

        insert match;

        Test.startTest();

        Contact result = API_CONNECT_Helpers.insertContractorContact(match);
        Test.stopTest();

        System.assertEquals(match.firstName__c, result.FirstName);
        System.assertEquals(match.lastName__c, result.LastName);


        Account resultsAccount = [
                SELECT
                        Id,
                        Primary_Contact__c
                FROM
                        Account
                WHERE
                        Id = :matchAccount.Id
                LIMIT 1
        ][0];

        System.assert(resultsAccount != null);


        System.assertEquals(result.Id, resultsAccount.Primary_Contact__c);
    }

    @IsTest
    static void testUpdateAccount() {

        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';

        Account matchAccount = accounts[0];

        insert match;

        // Act
        Test.startTest();

        API_CONNECT_Helpers.updateAccount(matchAccount, match);
        Test.stopTest();

        Integer MatchesResultsCount = [
                SELECT
                        COUNT()
                FROM
                        Contractor_Match__c
                WHERE Id = :match.Id
        ];

        Account resultAccount = [
                SELECT
                        Id,
                        Name,
                        Type,
                        Vetify_Position__c,
                        RecordTypeId,
                        Status__c
                FROM Account
                WHERE Id = :matchAccount.Id
        ];

        System.assertEquals(matchAccount.Id, resultAccount.Id);
        System.assertEquals(matchAccount.Name, resultAccount.Name);
        System.assertEquals(matchAccount.Type, resultAccount.Type);
        System.assertEquals(matchAccount.Vetify_Position__c, resultAccount.Vetify_Position__c);
        System.assertEquals(matchAccount.RecordTypeId, resultAccount.RecordTypeId);
        System.assertEquals(matchAccount.Status__c, resultAccount.Status__c);

    }

    @IsTest
    static void testUpdateAccountWithParentAccount() {

        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';

        Account matchAccount = accounts[0];

        Account parentAccount = accounts[1];
        parentAccount.Organizer_ID__c = '12349999999';
        update parentAccount;

        match.parentAccountId__c = parentAccount.Organizer_ID__c;

        insert match;

        // Act
        Test.startTest();

        API_CONNECT_Helpers.updateAccount(matchAccount, match);
        Test.stopTest();

        Integer MatchesResultsCount = [
                SELECT
                        COUNT()
                FROM
                        Contractor_Match__c
                WHERE Id = :match.Id
        ];

        Account resultAccount = [
                SELECT
                        Id,
                        Name,
                        Type,
                        Vetify_Position__c,
                        RecordTypeId,
                        Status__c
                FROM Account
                WHERE Id = :matchAccount.Id
        ];

        System.assertEquals(matchAccount.Id, resultAccount.Id);
        System.assertEquals(matchAccount.Name, resultAccount.Name);
        System.assertEquals(matchAccount.Type, resultAccount.Type);
        System.assertEquals(matchAccount.Vetify_Position__c, resultAccount.Vetify_Position__c);
        System.assertEquals(matchAccount.RecordTypeId, resultAccount.RecordTypeId);
        System.assertEquals(matchAccount.Status__c, resultAccount.Status__c);

    }

    @IsTest
    static void testUpdateAccountWithParentAccountException() {

        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';

        Account matchAccount = accounts[0];

        Account parentAccount = accounts[1];
        parentAccount.Organizer_ID__c = '123499999999999';


        match.parentAccountId__c = parentAccount.Organizer_ID__c;

        insert match;

        Boolean success = false;

        // Act
        Test.startTest();
        try {
            API_CONNECT_Helpers.updateAccount(matchAccount, match);
        } catch (API_CONNECT_Helpers.ApiConnectException e) {

            success = true;

        }
        Test.stopTest();

        System.assertEquals(true, success);


    }

    @IsTest
    static void testUpdateAccountWithGlobalAccount() {

        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';

        Account matchAccount = accounts[0];

        Account parentAccount = accounts[1];
        parentAccount.Organizer_ID__c = '12349999999999';
        update parentAccount;
        Account globalAccount = accounts[1];
        globalAccount.Organizer_ID__c = '123499999';
        update globalAccount;

        match.parentAccountId__c = parentAccount.Organizer_ID__c;
        match.globalAccountId__c = globalAccount.Organizer_ID__c;

        insert match;

        // Act
        Test.startTest();

        API_CONNECT_Helpers.updateAccount(matchAccount, match);
        Test.stopTest();

        Integer MatchesResultsCount = [
                SELECT
                        COUNT()
                FROM
                        Contractor_Match__c
                WHERE Id = :match.Id
        ];

        Account resultAccount = [
                SELECT
                        Id,
                        Name,
                        Type,
                        Vetify_Position__c,
                        RecordTypeId,
                        Status__c
                FROM Account
                WHERE Id = :matchAccount.Id
        ];

        System.assertEquals(matchAccount.Id, resultAccount.Id);
        System.assertEquals(matchAccount.Name, resultAccount.Name);
        System.assertEquals(matchAccount.Type, resultAccount.Type);
        System.assertEquals(matchAccount.Vetify_Position__c, resultAccount.Vetify_Position__c);
        System.assertEquals(matchAccount.RecordTypeId, resultAccount.RecordTypeId);
        System.assertEquals(matchAccount.Status__c, resultAccount.Status__c);

    }

    @IsTest
    static void testUpdateAccountWithGlobalAccountException() {

        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';

        Account matchAccount = accounts[0];

        Account parentAccount = accounts[1];
        parentAccount.Organizer_ID__c = '12349999999999999';


        Account globalAccount = accounts[1];
        globalAccount.Organizer_ID__c = '12349999999';


        match.parentAccountId__c = parentAccount.Organizer_ID__c;
        match.globalAccountId__c = globalAccount.Organizer_ID__c;

        insert match;

        Boolean success = false;

        // Act
        Test.startTest();
        try {
            API_CONNECT_Helpers.updateAccount(matchAccount, match);
        } catch (API_CONNECT_Helpers.ApiConnectException e) {

            success = true;

        }
        Test.stopTest();


        System.assertEquals(true, success);
    }

    @IsTest
    static void testUpdateAccountWithBillableEntityId() {

        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';

        Account matchAccount = accounts[0];

        Account parentAccount = accounts[1];
        parentAccount.Organizer_ID__c = '1234999999999999';
        update parentAccount;

        match.billableEntityId__c = parentAccount.Organizer_ID__c;

        insert match;

        // Act
        Test.startTest();

        API_CONNECT_Helpers.updateAccount(matchAccount, match);
        Test.stopTest();

        Integer MatchesResultsCount = [
                SELECT
                        COUNT()
                FROM
                        Contractor_Match__c
                WHERE Id = :match.Id
        ];

        Account resultAccount = [
                SELECT
                        Id,
                        Name,
                        Type,
                        Vetify_Position__c,
                        RecordTypeId,
                        Status__c
                FROM Account
                WHERE Id = :matchAccount.Id
        ];

        System.assertEquals(matchAccount.Id, resultAccount.Id);
        System.assertEquals(matchAccount.Name, resultAccount.Name);
        System.assertEquals(matchAccount.Type, resultAccount.Type);
        System.assertEquals(matchAccount.Vetify_Position__c, resultAccount.Vetify_Position__c);
        System.assertEquals(matchAccount.RecordTypeId, resultAccount.RecordTypeId);
        System.assertEquals(matchAccount.Status__c, resultAccount.Status__c);

    }

    @IsTest
    static void testUpdateAccountWithBillableEntityIdException() {

        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';

        Account matchAccount = accounts[0];

        Account parentAccount = accounts[1];
        parentAccount.Organizer_ID__c = '1234999999999999';


        match.billableEntityId__c = parentAccount.Organizer_ID__c;

        insert match;


        Boolean success = false;

        // Act
        Test.startTest();
        try {
            API_CONNECT_Helpers.updateAccount(matchAccount, match);
        } catch (API_CONNECT_Helpers.ApiConnectException e) {

            success = true;

        }
        Test.stopTest();
 

        System.assertEquals(true, success);

    }
}