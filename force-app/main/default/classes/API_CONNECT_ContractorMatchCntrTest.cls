/**
 * Created by brett on 4/12/18.
 */


@IsTest
public with sharing class API_CONNECT_ContractorMatchCntrTest {


    public static Contractor_Match__c[] makeMatches(Boolean doInsert, Integer count) {
        Contractor_Match__c[] matches = new List<Contractor_Match__c>();

        for (Integer i = 0; i < count; i++) {
            Contractor_Match__c match = new Contractor_Match__c();

            match.Name = 'Match ' + i;
            match.webUrl__c = 'www.match' + i + '.com';
            match.Phone_Number__c = '123123123' + i;
            match.firstName__c = 'first' + i;
            match.lastName__c = 'last' + i;

            matches.add(match);
        }

        if (doInsert) {
            insert matches;
        }

        return matches;
    }

    public static Contractor_Match__c[] makeMatches(Boolean doInsert) {

        return API_CONNECT_ContractorMatchCntrTest.makeMatches(doInsert, 30);
    }

    public static void assertMatchesMatch(Contractor_Match__c expected, Contractor_Match__c actual) {

        System.assertEquals(expected.Phone_Number__c, actual.Phone_Number__c);
        System.assertEquals(expected.Name, actual.Name);
        System.assertEquals(expected.webUrl__c, actual.webUrl__c);
        System.assertEquals(expected.City__c, actual.City__c);
        System.assertEquals(expected.Id, actual.Id);
    }


// Tests
    static testMethod void testDTOoptionsGetOffsetPage1() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testDTOoptionsGetOffsetPage1');

        // Arrange
        API_CONNECT_ContractorMatchController.DTOoptions options = new API_CONNECT_ContractorMatchController.DTOoptions();

        options.page = 0;
        options.pageSize = 10;

        // Act
        Test.startTest();

        Integer results = options.getOffset();
        Test.stopTest();

        // Assert
        System.assertEquals(results, 0);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testDTOoptionsGetOffsetPage1');
    }

    static testMethod void testDTOoptionsGetOffsetPage2() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testDTOoptionsGetOffsetPage2');

        // Arrange
        API_CONNECT_ContractorMatchController.DTOoptions options = new API_CONNECT_ContractorMatchController.DTOoptions();

        options.page = 1;
        options.pageSize = 10;

        // Act
        Test.startTest();

        Integer results = options.getOffset();
        Test.stopTest();

        // Assert
        System.assertEquals(results, 10);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testDTOoptionsGetOffsetPage2');
    }

    static testMethod void testDTOoptionsGetOffsetPage7() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testDTOoptionsGetOffsetPage7');

        // Arrange
        API_CONNECT_ContractorMatchController.DTOoptions options = new API_CONNECT_ContractorMatchController.DTOoptions();

        options.page = 6;
        options.pageSize = 10;

        // Act
        Test.startTest();

        Integer results = options.getOffset();
        Test.stopTest();

        // Assert
        System.assertEquals(results, 60);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testDTOoptionsGetOffsetPage7');
    }


    static testMethod void testGetContractorMatchesCount() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testGetContractorMatchesCount');

        // Arrange
        makeMatches(true);

        // Act
        Test.startTest();

        Integer results = API_CONNECT_ContractorMatchController.getContractorMatchesCount();
        Test.stopTest();

        // Assert
        System.assertEquals(results, 30);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testGetContractorMatchesCount');
    }

    static testMethod void testGetContractorMatchesCount100() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testGetContractorMatchesCount');

        // Arrange
        makeMatches(true, 100);

        // Act
        Test.startTest();

        Integer results = API_CONNECT_ContractorMatchController.getContractorMatchesCount();
        Test.stopTest();

        // Assert
        System.assertEquals(results, 100);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testGetContractorMatchesCount');
    }

    static testMethod void testGetContractorMatchesCount1000() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testGetContractorMatchesCount');

        // Arrange
        makeMatches(true, 1000);

        // Act
        Test.startTest();

        Integer results = API_CONNECT_ContractorMatchController.getContractorMatchesCount();
        Test.stopTest();

        // Assert
        System.assertEquals(results, 1000);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testGetContractorMatchesCount');
    }


    static testMethod void testGetPageOne() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testPaging');

        // Arrange
        makeMatches(true);

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

        assertMatchesMatch(matchOne, resultOne);
        assertMatchesMatch(matchTwo, resultTwo);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testPaging');
    }

    static testMethod void testGetPageTwo() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testPaging');

        // Arrange
        makeMatches(true);

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
        options.page = 1;
        options.pageSize = 2;
        options.orderBy = 'name';
        String stringOptions = JSON.serialize(options);

        Contractor_Match__c[] results = API_CONNECT_ContractorMatchController.getContractorMatches(stringOptions);
        Test.stopTest();

        // Assert
        System.assertEquals(results.size(), 2);

        Contractor_Match__c resultOne = results[0];
        Contractor_Match__c matchOne = matches[2];
        Contractor_Match__c resultTwo = results[1];
        Contractor_Match__c matchTwo = matches[3];

        assertMatchesMatch(matchOne, resultOne);
        assertMatchesMatch(matchTwo, resultTwo);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testPaging');
    }

    static testMethod void testGetPageFive() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testPaging');

        // Arrange
        makeMatches(true);

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
        options.page = 4;
        options.pageSize = 2;
        options.orderBy = 'name';


        String stringOptions = JSON.serialize(options);

        Contractor_Match__c[] results = API_CONNECT_ContractorMatchController.getContractorMatches(stringOptions);
        Test.stopTest();

        // Assert
        System.assertEquals(results.size(), 2);

        Contractor_Match__c resultOne = results[0];
        Contractor_Match__c matchOne = matches[8];
        Contractor_Match__c resultTwo = results[1];
        Contractor_Match__c matchTwo = matches[9];

        assertMatchesMatch(matchOne, resultOne);
        assertMatchesMatch(matchTwo, resultTwo);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testPaging');
    }


    static testMethod void testAccountSearch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testAccountSearch');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);

        // Act
        Test.startTest();

        Account[] results = API_CONNECT_ContractorMatchController.accountSearch('1');
        Test.stopTest();

        // Assert
        System.assertEquals(1, results.size());
        //System.assertEquals('global test account1', results[0].Name);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testAccountSearch');

    }

    static testMethod void testAccountSearchSize() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testAccountSearch');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);

        // Act
        Test.startTest();

        Account[] results = API_CONNECT_ContractorMatchController.accountSearch('account');
        Test.stopTest();

        // Assert
        System.assertEquals(10, results.size());
        for (Integer i = 0; i < 10; i++) {

            //System.assertEquals('global test account' + i, results[i].Name);
        }

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testAccountSearch');

    }

    static testMethod void testAccountSearchSizeLimitTo100() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testAccountSearchSizeLimitTo100');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(110, true);

        // Act
        Test.startTest();

        Account[] results = API_CONNECT_ContractorMatchController.accountSearch('account');
        Test.stopTest();

        // Assert
        System.assertEquals(100, results.size());


        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testAccountSearchSizeLimitTo100');

    }

    // Contact Search


    static testMethod void testContactSearch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testContactSearch');

        // Arrange
        Account account = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(1, true)[0];
        Contact[] contacts = QB_TestDataFactory.createContactRecords(10, true, account.Id);

        // Act
        Test.startTest();

        Contact[] results = API_CONNECT_ContractorMatchController.contactSearch('1');
        Test.stopTest();

        // Assert
        System.assertEquals(1, results.size());
        System.assertEquals('One test contact1', results[0].Name);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testContactSearch');

    }

    static testMethod void testContactSearchSize() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testContactSearchSize');

        // Arrange
        Account account = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(1, true)[0];
        Contact[] contacts = QB_TestDataFactory.createContactRecords(10, true, account.Id);

        // Act
        Test.startTest();

        Contact[] results = API_CONNECT_ContractorMatchController.contactSearch('test');
        Test.stopTest();

        // Assert
        System.assertEquals(10, results.size());
        for (Integer i = 0; i < 10; i++) {

            System.assertEquals('One test contact' + i, results[i].Name);
        }

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testContactSearchSize');

    }

    static testMethod void testContactSearchSizeLimitTo100() {
       /*
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testContactSearchSizeLimitTo100');

        // Arrange
        Account account = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(1, true)[0];
        Contact[] contacts = QB_TestDataFactory.createContactRecords(110, true, account.Id);

        // Act
        Test.startTest();

        Contact[] results = API_CONNECT_ContractorMatchController.contactSearch('test');
        Test.stopTest();

        // Assert
        System.assertEquals(100, results.size());


        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testContactSearchSizeLimitTo100');
		*/

    }

    static testMethod void testGetAccountTypesMap() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testGetAccountTypesMap');

        // Arrange

        // Act
        Test.startTest();

        Map<String, String> results = API_CONNECT_ContractorMatchController.getAccountTypesMap();
        Test.stopTest();

        // Assert
        System.assertEquals(2, results.size());

        System.assertEquals('Contractor', results.values()[0]);
        System.assertEquals('Operator', results.values()[1]);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testGetAccountTypesMap');
    }


    static testMethod void testAccountFetch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testAccountSearch');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientProspectAccountRecords(10, true);

        Account control = [
                SELECT
                        Name,
                        Id,
                        RecordTypeId,
                        Status__c,
                        IsBillable__c,
                        Billable_Entity__c,
                        BillingCity,
                        BillingCountry,
                        DBA_Name__c,
                        Fax,
                        Global_Parent__c,
                        Organizer_ID__c,
                        Paying_Facilities__c,
                        Phone,
                        BillingPostalCode,
                        Preferred_Language__c,
                        Registration_Date__c,
                        BillingState,
                        BillingAddress,
                        SUID__c,
                        Tax_ID__c,
                        Website,
                        Primary_Contact_Email__c
                FROM Account
                WHERE Id = :accounts[0].Id
        ];

        // Act
        Test.startTest();

        Account results = API_CONNECT_ContractorMatchController.accountFetch(control.Id);
        Test.stopTest();

        // Assert
        System.assertEquals(control.Id, results.Id);
        System.assertEquals(control.Name, results.Name);
        System.assertEquals(control.Status__c, results.Status__c);
        System.assertEquals(control.IsBillable__c, results.IsBillable__c);
        System.assertEquals(control.Billable_Entity__c, results.Billable_Entity__c);
        System.assertEquals(control.BillingCity, results.BillingCity);
        System.assertEquals(control.BillingCountry, results.BillingCountry);
        System.assertEquals(control.DBA_Name__c, results.DBA_Name__c);
        System.assertEquals(control.Fax, results.Fax);
        System.assertEquals(control.Global_Parent__c, results.Global_Parent__c);
        System.assertEquals(control.Organizer_ID__c, results.Organizer_ID__c);
        System.assertEquals(control.Paying_Facilities__c, results.Paying_Facilities__c);
        System.assertEquals(control.Phone, results.Phone);
        System.assertEquals(control.BillingPostalCode, results.BillingPostalCode);
        System.assertEquals(control.Preferred_Language__c, results.Preferred_Language__c);
        System.assertEquals(control.Registration_Date__c, results.Registration_Date__c);
        System.assertEquals(control.BillingState, results.BillingState);
        System.assertEquals(control.BillingAddress, results.BillingAddress);
        System.assertEquals(control.SUID__c, results.SUID__c);
        System.assertEquals(control.Tax_ID__c, results.Tax_ID__c);
        System.assertEquals(control.Website, results.Website);
        System.assertEquals(control.Primary_Contact_Email__c, results.Primary_Contact_Email__c);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testAccountSearch');

    }

    static testMethod void testContactFetch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testContactFetch');

        // Arrange
        Account accounts = QB_TestDataFactory.createClientAccountRecords(1, true)[0];
        Contact[] contacts = QB_TestDataFactory.createContactRecords(10, true, accounts.Id);

        Contact control = [
                SELECT
                        Name,
                        Id,
                        Fax,
                        Phone
                FROM Contact
                WHERE Id = :contacts[0].Id
        ];

        // Act
        Test.startTest();

        Contact results = API_CONNECT_ContractorMatchController.contactFetch(control.Id);
        Test.stopTest();

        // Assert
        System.assertEquals(control.Id, results.Id);
        System.assertEquals(control.Name, results.Name);
        System.assertEquals(control.Phone, results.Phone);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testContactFetch');

    }

    static testMethod void testClearAccountMatch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testClearAccountMatch');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.Account__c = accounts[0].Id;

        insert match;


        // Act
        Test.startTest();

        Contractor_Match__c results = API_CONNECT_ContractorMatchController.clearAccountMatch(match.Id);
        Test.stopTest();

        // Assert
        System.assertEquals(null, results.Account__c);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testAccountSearch');

    }

    static testMethod void testClearContactMatch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testClearContactMatch');

        // Arrange
        Account account = QB_TestDataFactory.createClientAccountRecords(1, true)[0];
        Contact[] contacts = QB_TestDataFactory.createContactRecords(10, true, account.Id);
        Contractor_Match__c match = new Contractor_Match__c();

        match.Account__c = account.Id;
        match.Contact__c = contacts[0].Id;

        insert match;


        // Act
        Test.startTest();

        Contractor_Match__c results = API_CONNECT_ContractorMatchController.clearContactMatch(match.Id);
        Test.stopTest();

        // Assert
        System.assertEquals(null, results.Contact__c);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testClearContactMatch');
    }


    static testMethod void testSaveAccountMatch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testAccountSearch');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        Account matchAccount = accounts[0];

        insert match;


        // Act
        Test.startTest();

        Contractor_Match__c results = API_CONNECT_ContractorMatchController.saveAccountMatch(match.Id, matchAccount.Id);
        Test.stopTest();

        // Assert
        System.assertEquals(match.Id, results.Id);
        System.assertEquals(matchAccount.Id, results.Account__c);

        Contractor_Match__c matchFetched = [SELECT Account__c, Id FROM Contractor_Match__c WHERE Id = :match.Id];

        System.assertEquals(matchAccount.Id, matchFetched.Account__c);


        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testAccountSearch');

    }


    static testMethod void testSaveContactMatch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testSaveContactMatch');

        // Arrange
        Account account = QB_TestDataFactory.createClientAccountRecords(1, true)[0];
        Contact contact = QB_TestDataFactory.createContactRecords(10, true, account.Id)[0];

        Contractor_Match__c match = new Contractor_Match__c();

        insert match;


        // Act
        Test.startTest();

        Contractor_Match__c results = API_CONNECT_ContractorMatchController.saveContactMatch(match.Id, contact.Id);
        Test.stopTest();

        // Assert
        System.assertEquals(match.Id, results.Id);
        System.assertEquals(contact.Id, results.Contact__c);

        Contractor_Match__c matchFetched = [SELECT Account__c, Id, Contact__c FROM Contractor_Match__c WHERE Id = :match.Id];

        System.assertEquals(contact.Id, matchFetched.Contact__c);


        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testSaveContactMatch');

    }


    static testMethod void testApproveClientAccountMatch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveClientAccountMatch');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';

        Account matchAccount = accounts[0];

        insert match;

        // Act
        Test.startTest();

        API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
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

        // Assert
        System.assertEquals(0, MatchesResultsCount);
        System.assertEquals(matchAccount.Id, resultAccount.Id);
        System.assertEquals(matchAccount.Name, resultAccount.Name);
        System.assertEquals(matchAccount.Type, resultAccount.Type);
        System.assertEquals(matchAccount.Vetify_Position__c, resultAccount.Vetify_Position__c);
        System.assertEquals(matchAccount.RecordTypeId, resultAccount.RecordTypeId);
        System.assertEquals(matchAccount.Status__c, resultAccount.Status__c);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveClientAccountMatch');

    }

    static testMethod void testApproveSuplierAccountMatch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveSuplierAccountMatch');

//        // Arrange
//        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
//
//        // Create Custom Settings
//        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE);
//
//        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');
//        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
//        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);
//        List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecordsWithClientId(1, TRUE, clientAccountRecords[0].id);
//
//        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id);
//        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecordsWithClientId(1, TRUE, accountRecords[0].id, clientAccountRecords[0].id);
//        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(20, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);
//
//
//        Contractor_Match__c match = new Contractor_Match__c();
//
//        match.accountRecordType__c = 'Client';
//
//        Account matchAccount = accounts[0];
//
//        insert match;
//
//        // Act
//        Test.startTest();
//
//        API_CONNECT_ContractorMatchController.approveAccountMatch(match.Id, matchAccount.Id);
//        Test.stopTest();
//
//        Integer MatchesResultsCount = [
//                SELECT
//                        COUNT()
//                FROM
//                        Contractor_Match__c
//                WHERE Id = :match.Id
//        ];
//
//        Account resultAccount = [
//                SELECT
//                        Id,
//                        Name,
//                        Type,
//                        Vetify_Position__c,
//                        RecordTypeId,
//                        Status__c
//                FROM Account
//                WHERE Id = :matchAccount.Id
//        ];
//
//        // Assert
//        System.assertEquals(0, MatchesResultsCount);
//        System.assertEquals(matchAccount.Id, resultAccount.Id);
//        System.assertEquals(matchAccount.Name, resultAccount.Name);
//        System.assertEquals(matchAccount.Type, resultAccount.Type);
//        System.assertEquals(matchAccount.Vetify_Position__c, resultAccount.Vetify_Position__c);
//        System.assertEquals(matchAccount.RecordTypeId, resultAccount.RecordTypeId);
//        System.assertEquals(matchAccount.Status__c, resultAccount.Status__c);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveSuplierAccountMatch');

    }

    static testMethod void testApproveAccountMatchWithNameChange() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithNameChange');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.accountName__c = 'MatchName';

        Account matchAccount = accounts[0];

        insert match;

        // Act
        Test.startTest();

        API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
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

        // Assert
        System.assertEquals(0, MatchesResultsCount);
        System.assertEquals(matchAccount.Id, resultAccount.Id);
        System.assertEquals(match.accountName__c, resultAccount.Name);
        System.assertEquals(matchAccount.Type, resultAccount.Type);
        System.assertEquals(matchAccount.Vetify_Position__c, resultAccount.Vetify_Position__c);
        System.assertEquals(matchAccount.RecordTypeId, resultAccount.RecordTypeId);
        System.assertEquals(matchAccount.Status__c, resultAccount.Status__c);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithNameChange');

    }


    static testMethod void testApproveAccountMatchWithBadAccountRecordType() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAccountRecordType');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = '!!!!!!';

        Account matchAccount = accounts[0];

        insert match;
        String message;

        // Act
        Test.startTest();
        try {
            API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
        } catch (Exception e) {
            message = e.getMessage();

        }
        Test.stopTest();
        System.assertEquals('ERROR: Invalid Account Type. Expected: Supplier or Client. Received: !!!!!!', message);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAccountRecordType');
    }

    static testMethod void testApproveAccountMatchWithBadParentAccountId() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadParentAccountId');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.parentAccountId__c = '!!!!!!';

        Account matchAccount = accounts[0];

        insert match;
        String message;

        // Act
        Test.startTest();
        try {
            API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
        } catch (Exception e) {
            message = e.getMessage();

        }
        Test.stopTest();
        System.assertEquals('ERROR: Invalid Parent Account Id: Account Not found: !!!!!!', message);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadParentAccountId');
    }

    static testMethod void testApproveAccountMatchWithBadGlobalAccountId() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadGlobalAccountId');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.globalAccountId__c = '!!!!!!';

        Account matchAccount = accounts[0];

        insert match;

        String message;

        // Act
        Test.startTest();
        try {
            API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
        } catch (Exception e) {
            message = e.getMessage();

        }
        Test.stopTest();
        System.assertEquals('ERROR: Invalid Global Account Id: Account Not found: !!!!!!', message);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadGlobalAccountId');
    }

    static testMethod void testApproveAccountMatchWithBadBillableEntityId() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadBillableEntityId');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.billableEntityId__c = '!!!!!!';

        Account matchAccount = accounts[0];

        insert match;

        String message;

        // Act
        Test.startTest();
        try {
            API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
        } catch (Exception e) {
            message = e.getMessage();

        }
        Test.stopTest();
        System.assertEquals('ERROR: Invalid Billable Entity Id: Account Not found: !!!!!!', message);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadBillableEntityId');
    }

    static testMethod void testApproveAccountMatchWithBadAdditionalText1Setting() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAdditionalText1Setting');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.additionalText1__c = '1';


        API_Settings__c setting = new API_Settings__c();
        setting.name = 'Update Account API';
        setting.Insert_Account_When_Not_Found__c = true;
        setting.admin_id__c = UserInfo.getUserId();
        setting.additionalText1__c = null;
        setting.additionalText2__c = 'sic';
        setting.additionalDate1__c = 'Health_Modified_Date__c';
        setting.additionalBoolean1__c = 'IsBillable__c';
        Database.insert(setting);


        Account matchAccount = accounts[0];

        insert match;

        String message;

        // Act
        Test.startTest();
        try {
            API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
        } catch (Exception e) {
            message = e.getMessage();

        }
        Test.stopTest();
        System.assertEquals('ERROR: additionalText1 passed, but not set in the APISettings', message);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAdditionalText1Setting');
    }

    static testMethod void testApproveAccountMatchWithBadAdditionalText2Setting() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAdditionalText2Setting');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.additionalText2__c = '1';


        API_Settings__c setting = new API_Settings__c();
        setting.name = 'Update Account API';
        setting.Insert_Account_When_Not_Found__c = true;
        setting.admin_id__c = UserInfo.getUserId();
//        setting.additionalText1__c = null;
        setting.additionalText2__c = null;
        setting.additionalDate1__c = 'Health_Modified_Date__c';
        setting.additionalBoolean1__c = 'IsBillable__c';
        Database.insert(setting);


        Account matchAccount = accounts[0];

        insert match;

        String message;

        // Act
        Test.startTest();
        try {
            API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
        } catch (Exception e) {
            message = e.getMessage();

        }
        Test.stopTest();
        System.assertEquals('ERROR:  additionalText2 passed, but not set in the APISettings', message);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAdditionalText2Setting');
    }

    static testMethod void testApproveAccountMatchWithBadAdditionalDateSetting() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAdditionalDateSetting');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.additionalDate1__c = '1';


        API_Settings__c setting = new API_Settings__c();
        setting.name = 'Update Account API';
        setting.Insert_Account_When_Not_Found__c = true;
        setting.admin_id__c = UserInfo.getUserId();
//        setting.additionalText1__c = null;
//        setting.additionalText2__c = null;
        setting.additionalDate1__c = null;
        setting.additionalBoolean1__c = 'IsBillable__c';
        Database.insert(setting);


        Account matchAccount = accounts[0];

        insert match;

        String message;

        // Act
        Test.startTest();
        try {
            API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
        } catch (Exception e) {
            message = e.getMessage();

        }
        Test.stopTest();
        System.assertEquals('ERROR:  additionalDate1 passed, but not set in the APISettings', message);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAdditionalDateSetting');
    }

    static testMethod void testApproveAccountMatchWithBadAdditionalBoolean1Setting() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAdditionalBoolean1Setting');

        // Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.additionalBoolean1__c = true;


        API_Settings__c setting = new API_Settings__c();
        setting.name = 'Update Account API';
        setting.Insert_Account_When_Not_Found__c = true;
        setting.admin_id__c = UserInfo.getUserId();
//        setting.additionalText1__c = null;
//        setting.additionalText2__c = null;
//        setting.additionalDate1__c = null;
        setting.additionalBoolean1__c = null;
        Database.insert(setting);


        Account matchAccount = accounts[0];

        insert match;

        String message;

        // Act
        Test.startTest();
        try {
            API_CONNECT_ContractorMatchController.approveMatch(match.Id, matchAccount.Id);
        } catch (Exception e) {
            message = e.getMessage();

        }
        Test.stopTest();
        System.assertEquals('ERROR:  additionalBoolean1 passed, but not set in the APISettings', message);

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testApproveAccountMatchWithBadAdditionalBoolean1Setting');
    }

    static testMethod void testDeleteMatch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testDeleteMatch');

        // Arrange
        Account account = QB_TestDataFactory.createClientAccountRecords(1, true)[0];
        Contact[] contacts = QB_TestDataFactory.createContactRecords(10, true, account.Id);
        Contractor_Match__c match = new Contractor_Match__c();


        insert match;


        // Act
        Test.startTest();

        API_CONNECT_ContractorMatchController.deleteMatch(match.Id);
        Test.stopTest();

        Boolean pass = false;
        try {
            Contractor_Match__c results = [
                    SELECT
                            Id
                    From
                            Contractor_Match__c
                    WHERE
                            Id = :match.id
            ];
        } catch (QueryException e) {

            String message = e.getMessage();
            if (message == 'List has no rows for assignment to SObject') {
                pass = true;
            }
        }


        // Assert
        System.assert(pass, 'Query Exception "List has no rows for assignment to SObject" not thrown.');

        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testDeleteMatch');
    }


    static testMethod void testCreateAccountFromMatch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testCreateAccountFromMatch');


// Arrange
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.accountName__c = 'MatchName';
        match.OrganizerId__c = '1234999999';
        match.lastName__c = 'last';
        match.firstName__c = 'first';

        Account matchAccount = accounts[0];

        insert match;

// Act
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


        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testCreateAccountFromMatch');
    }


    static testMethod void testCreateOpportunityFromMatch() {
        System.debug('START: API_CONNECT_ContractorMatchCntrTest.testCreateAccountFromMatch');
		
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        Account[] accounts = QB_TestDataFactory.createClientAccountRecords(10, true);
        Contractor_Match__c match = new Contractor_Match__c();

        match.accountRecordType__c = 'Client';
        match.accountName__c = 'MatchName';
        match.OrganizerId__c = '123499999';
        match.lastName__c = 'testLName';
        match.firstName__c = 'testfName';
        match.Deadline__c =  Date.today();

        Account matchAccount = accounts[0];

        insert match;

        Test.startTest();

        API_CONNECT_ContractorMatchController.createOpportunityFromMatch(match.Id);
        Test.stopTest();

        Opportunity[] results = [
                SELECT
                        Id,
                        Name,
                        Primary_Contact__r.FirstName,
                        Primary_Contact__r.LastName
                FROM Opportunity
                WHERE Name = :match.accountName__c
        ];

        System.assertEquals(1, results.size());

        Opportunity result = results[0];

        System.assertEquals(match.accountName__c, result.Name);
        System.assertEquals(match.firstName__c, result.Primary_Contact__r.FirstName);
        System.assertEquals(match.lastName__c, result.Primary_Contact__r.LastName);


        System.debug('END: API_CONNECT_ContractorMatchCntrTest.testCreateAccountFromMatch');
    }
}