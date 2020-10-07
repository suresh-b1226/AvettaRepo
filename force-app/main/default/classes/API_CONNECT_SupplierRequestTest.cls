@IsTest
public with sharing class API_CONNECT_SupplierRequestTest {

    public static List<Account> createAccountRecords(Integer count, Boolean isInsert) {
        List<Account> accountRecords = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accountRecords.add(
                    new Account(
                            Name = 'test account' + i,
                            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(),
                            //Vetify_Position__c = 'Client Opt In',
                            Status__c = 'Prospect ' + i,
                            Organizer_ID__c = '11111' + i,
                            Website = 'http://testaccount' + i + '.com'

                    )
            );
        }
        if (isInsert) {
            insert accountRecords;
        }
        return accountRecords;
    }


    static testMethod void testUpsertSupplierRequestOneMatch() {
        System.debug('START: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestOneMatch');

        // Arrange
        Account[] accounts = createAccountRecords(10, false);
        Account matchAccount = accounts[0];

        insert accounts;

        Account requester = QB_TestDataFactory.createClientAccountRecords(1, false)[0];
        requester.Organizer_ID__c = '1234';

        insert requester;

        Contact testContact = QB_TestDataFactory.createContactRecords(1, false, matchAccount.Id, 'test@test.com', 'Avetta', 'User')[0];

        upsert testContact;

        matchAccount.Primary_Contact__c = testContact.Id;

        upsert matchAccount;


        API_CONNECT_SupplierRequest.SupplierRequestLite request = new API_CONNECT_SupplierRequest.SupplierRequestLite();


        Date due = Date.today();
        due.addDays(5);

        String accountName = matchAccount.Name;
        String address = matchAccount.BillingStreet;
        String address2;
        String city = matchAccount.BillingCity;
        String country = matchAccount.BillingCountry;
        String firstName = testContact.FirstName;
        String lastName = testContact.LastName;
        String email = testContact.Email;
        String phoneNumber = matchAccount.Phone;
        String language = matchAccount.Preferred_Language__c;
        String requestSummary = 'test test';
        String requestBy = requester.Organizer_ID__c;  // Avetta Id
        String requestedByClientId = requester.Organizer_ID__c;    // Avetta Id
        Date deadline = due;
        String webUrl = matchAccount.Website;
        String matchId = matchAccount.Id;
        String externalId = '1241425325';
        String requesterEmail = 'tester@testerclient.com';
        
        List<API_CONNECT_SupplierRequest.externalIds> externalIds = new List<API_CONNECT_SupplierRequest.externalIds>();
        API_CONNECT_SupplierRequest.externalIds ei1 = new API_CONNECT_SupplierRequest.externalIds();
        ei1.externalId = '1234';
        ei1.externalIdType = 'SAP';
        ei1.corpClientId = 'kljdsjlk14';
        externalIds.add(ei1);
        
        API_CONNECT_SupplierRequest.externalIds ei2 = new API_CONNECT_SupplierRequest.externalIds();
        ei2.externalId = '5678';
        ei2.externalIdType = 'Oracle';
        ei2.corpClientId = 'jlkj235';
        externalIds.add(ei2);
        
        String submittingUserId = '9999999';
          String submittedByUserId = '999999';
          String requestedByUserName = 'Bob Tester';
        String requestedByContact = 'Bob Tester';
        List<String> preregistrationTags = new List<String>{'sampletag1', 'sampletag2'};


        // Act
        Test.startTest();
        API_CONNECT_SupplierRequest.SupplierRequestLite[] requestResults = API_CONNECT_SupplierRequest.upsertSupplierRequest(
                accountName,
                address,
                address2,
                city,
                country,
                firstName,
                lastName,
                email,
                phoneNumber,
                language,
                requestSummary,
                requestBy,
                requestedByClientId,    // Avetta Id
                deadline,
                webUrl,
                matchId,
            	externalId,
            	submittingUserId,
                submittedByUserId,
                requestedByUserName,
            	requestedByContact,
            	requesterEmail,
            	preRegistrationTags,
            	externalIds
        );
        Test.stopTest();


        Contractor_Match__c[] matchResults = [
                SELECT
                        Id,
                        accountName__c,
                        street__c,
                        address_Line_2__c,
                        City__c,
                        firstName__c,
                        lastName__c,
                        email__c,
                        phone_Number__c,
                        preferredLang__c,
                        requestSummary__c,
                        Deadline__c,
                        webUrl__c,
                        requestedBy__c,
                        All_Matches__c
                FROM
                        Contractor_Match__c
                WHERE
                        Id = :requestResults[0].matchId
        ];


        // Assert


        System.assertEquals(accountName, requestResults[0].accountName);
        System.assertEquals(address, requestResults[0].address);
        System.assertEquals(address2, requestResults[0].address2);
        System.assertEquals(city, requestResults[0].city);
        System.assertEquals(firstName, requestResults[0].firstName);
        System.assertEquals(lastName, requestResults[0].lastName);
        System.assertEquals(email, requestResults[0].email);
        System.assertEquals(phoneNumber, requestResults[0].phoneNumber);
        System.assertEquals(language, requestResults[0].language);
        System.assertEquals(requestSummary, requestResults[0].requestSummary);
        System.assertEquals(deadline, requestResults[0].deadline);
        System.assertEquals(webUrl, requestResults[0].webUrl);
        System.assertEquals(requestBy, requestResults[0].requestBy);


        System.assertEquals(0, matchResults.size());


        Opportunity[] oppResults = [
                SELECT
                        Id,
                        Name
                FROM Opportunity
                Where Name = :requestResults[0].accountName
        ];


        System.assertEquals(requestResults[0].accountName, oppResults[0].Name);


        System.debug('END: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestOneMatch');
    }

    /*
    static testMethod void testUpsertSupplierRequestMultiMatch() {
        System.debug('START: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestMultiMatch');

        // Arrange
        Account[] accounts = createAccountRecords(10, false);
        accounts[0].Name = 'test account';
        accounts[1].Name = 'test account';
        accounts[2].Name = 'test account';
        accounts[0].Website = 'http://testaccount.com';
        accounts[1].Website = 'http://testaccount.com';
        accounts[2].Website = 'http://testaccount.com';

        insert accounts;

        Account matchAccount = accounts[0];

        Account requester = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(1, false)[0];
        requester.Organizer_ID__c = '1234';

        insert requester;


        Date due = Date.today();
        due.addDays(5);

        String accountName = 'test account';
        String address;
        String address2;
        String city;
        String firstName;
        String lastName = 'test';
        String email;
        String phoneNumber;
        String language;
        String requestSummary = 'test test';
        String requestBy = requester.Organizer_ID__c;
        Date deadline = due ;
        String webUrl = matchAccount.Website;
        String matchId;


        // Act
        Test.startTest();
        API_CONNECT_SupplierRequest.SupplierRequestLite[] requestResults = API_CONNECT_SupplierRequest.upsertSupplierRequest(
                accountName,
                address,
                address2,
                city,
                firstName,
                lastName,
                email,
                phoneNumber,
                language,
                requestSummary,
                requestBy,    // Avetta Id
                deadline,
                webUrl,
                matchId
        );

        Test.stopTest();


        Contractor_Match__c[] matchResults = [
                SELECT
                        Id,
                        accountName__c,
                        street__c,
                        address_Line_2__c,
                        City__c,
                        firstName__c,
                        lastName__c,
                        email__c,
                        phone_Number__c,
                        preferredLang__c,
                        requestSummary__c,
                        Deadline__c,
                        webUrl__c,
                        requestedBy__c,
                        All_Matches__c
                FROM
                        Contractor_Match__c
                WHERE
                        Id = :requestResults[0].matchId
        ];


        // Assert

        System.assertEquals(accountName, requestResults[0].accountName);
        System.assertEquals(address, requestResults[0].address);

        System.assertEquals(requestSummary, requestResults[0].requestSummary);
        System.assertEquals(deadline, requestResults[0].deadline);
        System.assertEquals(webUrl, requestResults[0].webUrl);
        System.assertEquals(requestBy, requestResults[0].requestBy);


        System.assertEquals(0, matchResults.size());
        System.assertNotEquals(null, requestResults[0].matchId);
        System.assertNotEquals('', requestResults[0].matchId);
//        System.assertEquals(matchResults[0].Id, requestResults[0].matchId);
//
//        System.assertEquals(matchResults[0].accountName__c, requestResults[0].accountName);
//        System.assertEquals(matchResults[0].street__c, requestResults[0].address);
//        System.assertEquals(matchResults[0].address_Line_2__c, requestResults[0].address2);
//        System.assertEquals(matchResults[0].city__c, requestResults[0].city);
//        System.assertEquals(matchResults[0].firstName__c, requestResults[0].firstName);
//        System.assertEquals(matchResults[0].lastName__c, requestResults[0].lastName);
//        System.assertEquals(matchResults[0].email__c, requestResults[0].email);
//        System.assertEquals(matchResults[0].phoneNumber__c, requestResults[0].phoneNumber);
//        System.assertEquals(matchResults[0].preferredLang__c, requestResults[0].language);
//        System.assertEquals(matchResults[0].requestSummary__c, requestResults[0].requestSummary);
//        System.assertEquals(matchResults[0].deadline__c, requestResults[0].deadline);
//        System.assertEquals(matchResults[0].webUrl__c, requestResults[0].webUrl);
//        System.assertEquals(matchResults[0].requestedBy__c, requestResults[0].requestBy);
//
//        String allMatches = matchResults[0].All_Matches__c;

//        System.assertNotEquals(null, allMatches);
//        System.assertNotEquals('', allMatches);
//
//        String[] matches = allMatches.split(',');

//        System.assertEquals(3, matches.size());


        System.debug('END: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestMultiMatch');
    }
    */

    static testMethod void testUpsertSupplierRequestWebSite() {
        System.debug('START: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestWebSite');

        // Arrange
        Account[] accounts = createAccountRecords(10, false);
        accounts[0].Website = 'http://test.com';

        insert accounts;
        Account matchAccount = accounts[0];

        Account requester = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(1, false)[0];
        requester.Organizer_ID__c = '1234';

        insert requester;

        Contact testContact = QB_TestDataFactory.createContactRecords(1, false, matchAccount.Id, 'test@test.com', 'Avetta', 'User')[0];

        upsert testContact;

        matchAccount.Primary_Contact__c = testContact.Id;

        upsert matchAccount;

        API_CONNECT_SupplierRequest.SupplierRequestLite request = new API_CONNECT_SupplierRequest.SupplierRequestLite();


        Date due = Date.today();
        due.addDays(5);

        String accountName = 'test account';
        String address;
        String address2;
        String city;
        String country;
        String firstName = testContact.FirstName;
        String lastName = testContact.LastName;
        String email;
        String phoneNumber;
        String language;
        String requestSummary = 'test test';
        String requestBy = requester.Organizer_ID__c;  // Avetta Id
        String requestedByClientId = requester.Organizer_ID__c;    // Avetta Id
        Date deadline;
        String webUrl = matchAccount.Website;
        String matchId = matchAccount.Id;
        String externalId = '1234';
        String submittingUserId = '9999999';
        String submittedByUserId = '999999';
        String requestedByUserName = 'Bob Tester';
        String requestedByContact = 'Bob Tester';
        String requesterEmail = 'tester@testerclient.com';
        List<String> preregistrationTags = new List<String>{'sampletag1', 'sampletag2'};

		List<API_CONNECT_SupplierRequest.externalIds> externalIds = new List<API_CONNECT_SupplierRequest.externalIds>();
        API_CONNECT_SupplierRequest.externalIds ei1 = new API_CONNECT_SupplierRequest.externalIds();
        ei1.externalId = '1234';
        ei1.externalIdType = 'SAP';
        ei1.corpClientId = 'kljdsjlk14';
        externalIds.add(ei1);
        
        API_CONNECT_SupplierRequest.externalIds ei2 = new API_CONNECT_SupplierRequest.externalIds();
        ei2.externalId = '5678';
        ei2.externalIdType = 'Oracle';
        ei2.corpClientId = 'jlkj235';
        externalIds.add(ei2);
            
        // Act
        Test.startTest();
        API_CONNECT_SupplierRequest.SupplierRequestLite[] requestResults = API_CONNECT_SupplierRequest.upsertSupplierRequest(
                accountName,
                address,
                address2,
                city,
                country,
                firstName,
                lastName,
                email,
                phoneNumber,
                language,
                requestSummary,
                requestBy,
                requestedByClientId,    // Avetta Id
                deadline,
                webUrl,
                matchId,
                externalId,
            	submittingUserId,
                submittedByUserId,
                requestedByUserName,
            	requestedByContact,
            	requesterEmail,
            	preregistrationTags,
            	externalIds
        );
        Test.stopTest();


        Contractor_Match__c[] matchResults = [
                SELECT
                        Id,
                        accountName__c,
                        street__c,
                        address_Line_2__c,
                        City__c,
                        firstName__c,
                        lastName__c,
                        email__c,
                        phone_Number__c,
                        preferredLang__c,
                        requestSummary__c,
                        Deadline__c,
                        webUrl__c,
                        requestedBy__c,
                        All_Matches__c
                FROM
                        Contractor_Match__c
                WHERE
                        Id = :requestResults[0].matchId
        ];


        // Assert


        System.assertEquals(accountName, requestResults[0].accountName);
        System.assertEquals(address, requestResults[0].address);
        System.assertEquals(address2, requestResults[0].address2);
        System.assertEquals(city, requestResults[0].city);
        System.assertEquals(firstName, requestResults[0].firstName);
        System.assertEquals(lastName, requestResults[0].lastName);
        System.assertEquals(email, requestResults[0].email);
        System.assertEquals(phoneNumber, requestResults[0].phoneNumber);
        System.assertEquals(language, requestResults[0].language);
        System.assertEquals(requestSummary, requestResults[0].requestSummary);
        System.assertEquals(deadline, requestResults[0].deadline);
        System.assertEquals(webUrl, requestResults[0].webUrl);
        System.assertEquals(requestBy, requestResults[0].requestBy);


        System.assertEquals(0, matchResults.size());


        Opportunity[] oppResults = [
                SELECT
                        Id,
                        Name
                FROM Opportunity
                Where Name = :requestResults[0].accountName
        ];

        //System.assertEquals(1, oppResults.size());


//        System.assertEquals(requestResults[0].accountName, oppResults[0].Name);


        System.debug('END: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestWebSite');
    }

    static testMethod void testUpsertSupplierRequestWebSiteWithNoProtocol() {
        System.debug('START: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestWebSite');

        // Arrange
        Account[] accounts = createAccountRecords(10, false);
        accounts[0].Website = 'test.com';

        insert accounts;
        Account matchAccount = accounts[0];

        Account requester = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(1, false)[0];
        requester.Organizer_ID__c = '1234';

        insert requester;

        Contact testContact = QB_TestDataFactory.createContactRecords(1, false, matchAccount.Id, 'test@test.com', 'Avetta', 'User')[0];

        upsert testContact;

        matchAccount.Primary_Contact__c = testContact.Id;

        upsert matchAccount;

        API_CONNECT_SupplierRequest.SupplierRequestLite request = new API_CONNECT_SupplierRequest.SupplierRequestLite();


        Date due = Date.today();
        due.addDays(5);

        String accountName ='test';
        String address;
        String address2;
        String city;
        String country;
        String firstName = testContact.FirstName;
        String lastName = testContact.LastName;
        String email;
        String phoneNumber;
        String language;
        String requestSummary = 'test test';
        String requestBy = requester.Organizer_ID__c;  // Avetta Id
        String requestedByClientId = requester.Organizer_ID__c;    // Avetta Id
        Date deadline;
        String webUrl = matchAccount.Website;
        String matchId = matchAccount.Id;
        String externalId = '1234';
        String submittingUserId = '9999999';
        String submittedByUserId = '999999';
        String requestedByUserName = 'Bob Tester';
        String requestedByContact = 'Bob Tester';
        String requesterEmail = 'tester@testerclient.com';
        List<String> preregistrationTags = new List<String>{'sampletag1', 'sampletag2'};

        List<API_CONNECT_SupplierRequest.externalIds> externalIds = new List<API_CONNECT_SupplierRequest.externalIds>();
        API_CONNECT_SupplierRequest.externalIds ei1 = new API_CONNECT_SupplierRequest.externalIds();
        ei1.externalId = '1234';
        ei1.externalIdType = 'SAP';
        ei1.corpClientId = 'kljdsjlk14';
        externalIds.add(ei1);
        
        API_CONNECT_SupplierRequest.externalIds ei2 = new API_CONNECT_SupplierRequest.externalIds();
        ei2.externalId = '5678';
        ei2.externalIdType = 'Oracle';
        ei2.corpClientId = 'jlkj235';
        externalIds.add(ei2);
            
        // Act
        Test.startTest();
        API_CONNECT_SupplierRequest.SupplierRequestLite[] requestResults = API_CONNECT_SupplierRequest.upsertSupplierRequest(
                accountName,
                address,
                address2,
                city,
                country,
                firstName,
                lastName,
                email,
                phoneNumber,
                language,
                requestSummary,
                requestBy,
                requestedByClientId,    // Avetta Id
                deadline,
                webUrl,
                matchId,
                externalId,
            	submittingUserId,
                submittedByUserId,
                requestedByUserName,
            	requestedByContact,
            	requesterEmail,
            	preregistrationTags,
            	externalIds
        );
        Test.stopTest();


        Contractor_Match__c[] matchResults = [
                SELECT
                        Id,
                        accountName__c,
                        street__c,
                        address_Line_2__c,
                        City__c,
                        firstName__c,
                        lastName__c,
                        email__c,
                        phone_Number__c,
                        preferredLang__c,
                        requestSummary__c,
                        Deadline__c,
                        webUrl__c,
                        requestedBy__c,
                        All_Matches__c
                FROM
                        Contractor_Match__c
                WHERE
                        Id = :requestResults[0].matchId
        ];


        // Assert


        System.assertEquals(accountName, requestResults[0].accountName);
        System.assertEquals(address, requestResults[0].address);
        System.assertEquals(address2, requestResults[0].address2);
        System.assertEquals(city, requestResults[0].city);
        System.assertEquals(firstName, requestResults[0].firstName);
        System.assertEquals(lastName, requestResults[0].lastName);
        System.assertEquals(email, requestResults[0].email);
        System.assertEquals(phoneNumber, requestResults[0].phoneNumber);
        System.assertEquals(language, requestResults[0].language);
        System.assertEquals(requestSummary, requestResults[0].requestSummary);
        System.assertEquals(deadline, requestResults[0].deadline);
        System.assertEquals(webUrl, requestResults[0].webUrl);
        System.assertEquals(requestBy, requestResults[0].requestBy);


        System.assertEquals(0, matchResults.size());


        Opportunity[] oppResults = [
                SELECT
                        Id,
                        Name
                FROM Opportunity
                Where Name = :requestResults[0].accountName
        ];


        //System.assertEquals(1, oppResults.size());

//        System.assertEquals(requestResults[0].accountName, oppResults[0].Name);


        System.debug('END: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestWebSite');
    }

    static testMethod void testUpsertSupplierRequestOneMatchWithContact() {
        System.debug('START: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestOneMatch');

        // Arrange
        Account[] accounts = createAccountRecords(10, false);

        insert accounts;
        Account matchAccount = accounts[0];

        Contact matchContact = QB_TestDataFactory.createContactRecords(1, false, matchAccount.Id, 'test@test.com', 'Avetta', 'User')[0];


        Account requester = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(1, false)[0];
        requester.Organizer_ID__c = '1234';

        insert requester;
        upsert matchContact;

        API_CONNECT_SupplierRequest.SupplierRequestLite request = new API_CONNECT_SupplierRequest.SupplierRequestLite();


        Date due = Date.today();
        due.addDays(5);

        String accountName = matchAccount.Name;
        String address = matchAccount.BillingStreet;
        String address2;
        String city = matchAccount.BillingCity;
        String country = matchAccount.BillingCountry;
        String firstName = matchContact.FirstName;
        String lastName = matchContact.LastName;
        String email = matchContact.Email;
        String phoneNumber = matchAccount.Phone;
        String language = matchAccount.Preferred_Language__c;
        String requestSummary = 'test test';
        
        String requestedByClientId = requester.Organizer_ID__c;    // Avetta Id
        Date deadline;
        
        String matchId = matchAccount.Id;
        String externalId = '1234';
        String submittingUserId = '9999999';
        String submittedByUserId = '999999';
        String requestedByUserName = 'Bob Tester';
        String requestedByContact = 'Bob Tester';
        String requesterEmail = 'tester@testerclient.com';
        List<String> preregistrationTags = new List<String>{'sampletag1', 'sampletag2'};

        List<API_CONNECT_SupplierRequest.externalIds> externalIds = new List<API_CONNECT_SupplierRequest.externalIds>();
        API_CONNECT_SupplierRequest.externalIds ei1 = new API_CONNECT_SupplierRequest.externalIds();
        ei1.externalId = '1234';
        ei1.externalIdType = 'SAP';
        ei1.corpClientId = 'kljdsjlk14';
        externalIds.add(ei1);
        
        API_CONNECT_SupplierRequest.externalIds ei2 = new API_CONNECT_SupplierRequest.externalIds();
        ei2.externalId = '5678';
        ei2.externalIdType = 'Oracle';
        ei2.corpClientId = 'jlkj235';
        externalIds.add(ei2);
            
        String webUrl = matchAccount.Website;

        firstName = matchContact.FirstName;
        lastName = matchContact.LastName;
        email = matchContact.Email;

        String requestBy = requester.Organizer_ID__c;  // Avetta Id

        // Act
        Test.startTest();
        API_CONNECT_SupplierRequest.SupplierRequestLite[] requestResults = API_CONNECT_SupplierRequest.upsertSupplierRequest(
                accountName,
                address,
                address2,
                city,
                country,
                firstName,
                lastName,
                email,
                phoneNumber,
                language,
                requestSummary,
                requestBy,
                requestedByClientId,    // Avetta Id
                deadline,
                webUrl,
                matchId,
                externalId,
            	submittingUserId,
                submittedByUserId,
                requestedByUserName,
            	requestedByContact,
            	requesterEmail,
            	preregistrationTags,
            	externalIds
        );
        Test.stopTest();


        Contractor_Match__c[] matchResults = [
                SELECT
                        Id,
                        accountName__c,
                        street__c,
                        address_Line_2__c,
                        City__c,
                        firstName__c,
                        lastName__c,
                        email__c,
                        phone_Number__c,
                        preferredLang__c,
                        requestSummary__c,
                        Deadline__c,
                        webUrl__c,
                        requestedBy__c,
                        All_Matches__c
                FROM
                        Contractor_Match__c
                WHERE
                        Id = :requestResults[0].matchId
        ];


        // Assert


        System.assertEquals(accountName, requestResults[0].accountName);
        System.assertEquals(address, requestResults[0].address);
        System.assertEquals(address2, requestResults[0].address2);
        System.assertEquals(city, requestResults[0].city);
        System.assertEquals(firstName, requestResults[0].firstName);
        System.assertEquals(lastName, requestResults[0].lastName);
        System.assertEquals(email, requestResults[0].email);
        System.assertEquals(phoneNumber, requestResults[0].phoneNumber);
        System.assertEquals(language, requestResults[0].language);
        System.assertEquals(requestSummary, requestResults[0].requestSummary);
        System.assertEquals(deadline, requestResults[0].deadline);
        System.assertEquals(webUrl, requestResults[0].webUrl);
        System.assertEquals(requestBy, requestResults[0].requestBy);


        System.assertEquals(0, matchResults.size());


        Opportunity[] oppResults = [
                SELECT
                        Id,
                        Name
                FROM Opportunity
                Where Name = :requestResults[0].accountName
        ];


        System.assertEquals(requestResults[0].accountName, oppResults[0].Name);


        System.debug('END: API_CONNECT_SupplierRequestTest.testUpsertSupplierRequestOneMatch');
    }


}