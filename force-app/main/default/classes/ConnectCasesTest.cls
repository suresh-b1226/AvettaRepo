@IsTest
private class ConnectCasesTest {

    // Helper method
    static Case[] createTestRecord(Integer howMany, Boolean doInsert) {

        Case[] testCases = new List<Case>();

        for (Integer i = 0; i < howMany; i++) {
            Case testCase = new Case(
                    Subject = 'Test record' + i,
                    Status = 'New',
                    Origin = 'Phone',
                    Priority = 'Medium',
                    Connect_Form_ID__c = '1234' + i);

            testCases.add(testCase);
        }

        if (doInsert) {
            insert testCases;
        }
        return testCases;
    }

    static CaseComment[] createTestComment(Case testCase, Integer howMany, Boolean doInsert) {

        CaseComment[] comments = new List<CaseComment>();

        for (Integer i = 0; i < howMany; i++) {
            CaseComment comment = new CaseComment(

                    ParentId = testCase.Id,
                    CommentBody = 'Test comment ' + i,
                    IsPublished = true

            );
            comments.add(comment);
        }

        if (doInsert) {
            insert comments;
        }

        return comments;

    }

    static Account[] createClientAccounts(Integer howMany, Boolean doInsert) {

        Account[] clientAccounts = new List<Account>();

        for (Integer i = 0; i < howMany; i++) {
            Account clientAccount = new Account(

                    RecordTypeId = Id.valueOf('01270000000MRzi'),
                    Name = 'Test Account ' + i,
                    Organizer_ID__c = String.valueOf(i)

            );
            clientAccounts.add(clientAccount);
        }

        if (doInsert) {
            insert clientAccounts;
        }

        return clientAccounts;

    }

    /*
    static Related_Client__c[] createRelatedClients(Case testCase, List<Account> clientAccounts, Integer howMany, Boolean doInsert) {

        Related_Client__c[] clients = new List<Related_Client__c>();

        for (Integer i = 0; i < howMany; i++) {
            Related_Client__c relatedClient = new Related_Client__c(

                    Related_Case__c = testCase.Id,
                    Related_Client__c = clientAccounts[i].Id

            );
            clients.add(relatedClient);
        }

        if (doInsert) {
            insert clients;
        }

        return clients;

    }
    */

    @isTest static void testGetCaseById() {
        Case[] testCases = createTestRecord(1, true);
        CaseComment[] testComments = createTestComment(testCases[0], 1, true);
        Account[] testClientAccounts = createClientAccounts(2, true);

        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
                Url.getSalesforceBaseUrl() + '/services/apexrest/Cases/'
                        + testCases[0].Connect_Form_ID__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        ConnectCases.CaseLite[] results = ConnectCases.getCaseById();
        // Verify results
        System.debug(results);
        System.assert(results != null);
        ConnectCases.CaseLite result = results[0];
        Case testCase = testCases[0];

        System.assertEquals(testCase.Subject, result.subject);
        System.assertNotEquals(null, result.recordTypeId);
        System.assertNotEquals(null, result.caseNumber);
        System.assertEquals(testCase.Type, result.type);
        System.assertEquals(testCase.Organizer_ID__c, result.avettaId);
        System.assertEquals(testCase.Status, result.status);
        System.assertEquals(testCase.Sub_Type__c, result.subType);
        System.assertEquals(testCase.Connect_Form_ID__c, result.connectFormId);
        System.assertEquals(testCase.Connect_Url__c, result.connectUrl);
        System.assertNotEquals(null, result.lastStatusChange);
        System.assertEquals(testComments.size(), result.comments.size());

        CaseComment testComment = testComments[0];
        ConnectCases.CaseCommentsLite resultComment = result.comments[0];

        System.assertEquals(testComment.Id, resultComment.id);
        System.assertEquals(testComment.ParentId, resultComment.parentId);
        System.assertEquals(testComment.CommentBody, resultComment.commentBody);
        System.assertNotEquals(null, resultComment.createdDate);

        // other things
        ConnectCases.CaseLite updateTestCase = new ConnectCases.CaseLite();
        String clientId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        updateTestCase.recordTypeId = clientId;
        updateTestCase.subject = 'test';
        updateTestCase.type = 'test';
        updateTestCase.subType = 'test';
        updateTestCase.connectFormId = 'test';
        updateTestCase.connectUrl = 'test';
        updateTestCase.status = 'test';
        updateTestCase.lastStatusChange = Datetime.now();


        ConnectCases.CaseCommentsLite updateTestComment = new ConnectCases.CaseCommentsLite();

        updateTestComment.id = testComment.Id;
        updateTestComment.commentBody = testComment.CommentBody;
    }

    @isTest static void testGetCaseByIdWithoutUnPublishedComment() {
        Case[] testCases = createTestRecord(1, true);
        CaseComment[] testComments = createTestComment(testCases[0], 2, true);
        testComments[0].IsPublished = false;

        update testComments[0];


        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
                Url.getSalesforceBaseUrl() + '/services/apexrest/Cases/'
                        + testCases[0].Connect_Form_ID__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        ConnectCases.CaseLite[] resultsCase = ConnectCases.getCaseById();
        // Verify results
        System.debug(resultsCase);
        System.assert(resultsCase != null);
        System.assertEquals(testCases[0].Subject, resultsCase[0].Subject);


        ConnectCases.CaseCommentsLite[] resultsComments = resultsCase[0].comments;
        System.assertEquals(1, resultsComments.size());
    }

    @isTest static void testGetCaseByIdDates() {
        Case[] testCases = createTestRecord(1, true);
        CaseComment[] testComments = createTestComment(testCases[0], 2, true);

        testComments[0].CommentBody = 'updated later';

        update testComments[0];


        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
                Url.getSalesforceBaseUrl() + '/services/apexrest/Cases/'
                        + testCases[0].Connect_Form_ID__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        ConnectCases.CaseLite[] resultsCase = ConnectCases.getCaseById();
        // Verify results
        System.debug(resultsCase);
        System.assert(resultsCase != null);
        System.assertEquals(testCases[0].Subject, resultsCase[0].Subject);

        System.debug(resultsCase);


        ConnectCases.CaseCommentsLite[] resultsComments = resultsCase[0].comments;
        System.assertEquals(testComments.size(), resultsComments.size());
        System.assertEquals(testComments[0].CommentBody, resultsComments[1].commentBody);
    }

    @isTest static void testUpsertCase() {
        Id profileId = [SELECT Id
						FROM Profile
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        Id userRoleId = [SELECT Id
						FROM UserRole
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        String testUserEmail;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser) {
        	List<User> testUsers = QB_TestDataFactory.createUserRecords(1, TRUE, profileId, userRoleId);
            testUserEmail = testUsers[0].Email;
        }
        
        Account[] testClientAccounts = createClientAccounts(2, true);
        
        String[] clientConnectIds = new List<String>();
        for(Account testClientAccount : testClientAccounts) {
            clientConnectIds.add(testClientAccount.Id);
        }

        // 1. Insert new record
        ID case1Id = ConnectCases.upsertCase(
                '123456', '123456', '9876548768757657', 'Manual Audit', 'Implementation Audit', 'https://www.ksl.com', 'Connect', 'New', '2018-08-06T00:00:00.000Z', '2018-08-07T00:00:00.000Z', clientConnectIds, TRUE, testUserEmail);
        // Verify new record was created
        System.assert(Case1Id != null);
        Case case1 = [
                SELECT
                        Id,
                        Subject,
                        Valid_Start_Date__c,
                        Valid_End_Date__c
                FROM
                        Case
                WHERE Id = :case1Id
        ];

        System.assert(case1 != null);
        System.assertEquals(case1.Subject, 'Implementation Audit');
        System.assertEquals((Datetime) JSON.deserialize('"2018-08-06T00:00:00.000Z"', Datetime.class), case1.Valid_Start_Date__c);
        System.assertEquals((Datetime) JSON.deserialize('"2018-08-07T00:00:00.000Z"', Datetime.class), case1.Valid_End_Date__c);

        // 2. Update status of existing record to Working
        ID case2Id = ConnectCases.upsertCase(
                '123456', '123456', '9876548768757657', 'Manual Audit', 'Implementation Audit', 'https://www.espn.com', 'Connect', 'waitingOnSupplier', '', '', clientConnectIds, TRUE, testUserEmail);
        // Verify record was updated
        System.assertEquals(case1Id, case2Id);
        Case case2 = [SELECT Id, Connect_URL__C FROM Case WHERE Id = :case2Id];
        System.assert(case2 != null);
        System.assertEquals(case2.Connect_URL__C, 'https://www.espn.com');
    }


    @isTest static void testInsertCaseManualAudit() {
        /*
        Account[] testClientAccounts = createClientAccounts(2, true);
        String[] clientConnectIds = new List<String>();
        for(Account testClientAccount : testClientAccounts) {
            clientConnectIds.add(testClientAccount.Id);
        }

        // 1. Insert new record
        ID case1Id = ConnectCases.upsertCase(
                '123456', '123456', '19876548768757657', 'Manual Audit', 'Manual Audit', 'https://www.ksl.com', 'Connect', '', '2018-08-06T00:00:00.000Z', '2018-08-07T00:00:00.000Z', clientConnectIds, TRUE);
        // Verify new record was created
        System.assert(Case1Id != null);
        Case case1 = [
                SELECT
                        Id,
                        Subject,
                        Valid_Start_Date__c,
                        Valid_End_Date__c
                FROM
                        Case
                WHERE Id = :case1Id
        ];

        System.assert(case1 != null);
        System.assertEquals('Manual Audit', case1.Subject);
        System.assertEquals((Datetime) JSON.deserialize('"2018-08-06T00:00:00.000Z"', Datetime.class), case1.Valid_Start_Date__c);
        System.assertEquals((Datetime) JSON.deserialize('"2018-08-07T00:00:00.000Z"', Datetime.class), case1.Valid_End_Date__c);

        // 2. Update status of existing record to Working
        ID case2Id = ConnectCases.upsertCase(
                '123456', '123456', '19876548768757657', 'Manual Audit', 'Manual Audit', 'https://www.espn.com', 'Connect', '', '', '', clientConnectIds, TRUE);
        // Verify record was updated
        //System.assertEquals(case1Id, case2Id);
        Case case2 = [SELECT Id, Connect_URL__C, Status FROM Case WHERE Id = :case2Id];
        System.assert(case2 != null);
        System.assertEquals(case2.Connect_URL__C, 'https://www.espn.com');
       // System.assertEquals('Pending', case2.Status);
       */
    }


    @isTest static void testUpdateCaseManualAudit() {
        Id profileId = [SELECT Id
						FROM Profile
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        Id userRoleId = [SELECT Id
						FROM UserRole
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        String testUserEmail;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser) {
        	List<User> testUsers = QB_TestDataFactory.createUserRecords(1, TRUE, profileId, userRoleId);
            testUserEmail = testUsers[0].Email;
        }
        
        Account[] testClientAccounts = createClientAccounts(2, true);
        
        String[] clientConnectIds = new List<String>();
        for(Account testClientAccount : testClientAccounts) {
            clientConnectIds.add(testClientAccount.Id);
        }

        // 1. Insert new record
        ID insertId = ConnectCases.upsertCase(
                '123456', '123456', '9876548768757657', 'Manual Audit', 'Manual Audit', 'https://www.ksl.com', 'Connect', '', '2018-08-06T00:00:00.000Z', '2018-08-07T00:00:00.000Z', clientConnectIds, TRUE, testUserEmail);


        // Verify new record was created
        System.assert(insertId != null);


        // 1. Insert new record
        ID case1Id = ConnectCases.upsertCase(
                '123456', '123456', '9876548768757657', 'Manual Audit', 'Manual Audit', 'https://www.ksl.com', 'Connect', 'waitingOnClient', '2018-08-06T00:00:00.000Z', '2018-08-07T00:00:00.000Z', clientConnectIds, TRUE, testUserEmail);


        // Verify new record was created
        //System.assert(Case1Id != null);
        Case case1 = [
                SELECT
                        Id,
                        Subject,
                        Valid_Start_Date__c,
                        Valid_End_Date__c
                FROM
                        Case
                WHERE Id = :case1Id
        ];

        System.assert(case1 != null);
        System.assertEquals('Manual Audit', case1.Subject);
        System.assertEquals((Datetime) JSON.deserialize('"2018-08-06T00:00:00.000Z"', Datetime.class), case1.Valid_Start_Date__c);
        System.assertEquals((Datetime) JSON.deserialize('"2018-08-07T00:00:00.000Z"', Datetime.class), case1.Valid_End_Date__c);

        // 2. Update status of existing record to Working
        ID case2Id = ConnectCases.upsertCase(
                '123456', '123456', '9876548768757657', 'Manual Audit', 'Implementation Audit', 'https://www.espn.com', 'Connect', 'waitingOnClient', '', '', clientConnectIds, TRUE, testUserEmail);
        // Verify record was updated
        System.assertEquals(case1Id, case2Id);
        Case case2 = [SELECT Id, Connect_URL__C, Status FROM Case WHERE Id = :case2Id];
        System.assert(case2 != null);
        System.assertEquals(case2.Connect_URL__C, 'https://www.espn.com');
        System.assertEquals('Waiting on Client', case2.Status);
    }


    @isTest static void testUpdateCaseStatus() {
        Id profileId = [SELECT Id
						FROM Profile
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        Id userRoleId = [SELECT Id
						FROM UserRole
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        String testUserEmail;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser) {
        	List<User> testUsers = QB_TestDataFactory.createUserRecords(1, TRUE, profileId, userRoleId);
            testUserEmail = testUsers[0].Email;
        }
        
        Account[] testClientAccounts = createClientAccounts(2, true);
        
        String[] clientConnectIds = new List<String>();
        for(Account testClientAccount : testClientAccounts) {
            clientConnectIds.add(testClientAccount.Id);
        }

        // 1. Insert new record
        ID case1Id = ConnectCases.upsertCase(
                '123456', '123456', '9876548768757657', 'Manual Audit', 'Implementation Audit', 'https://www.ksl.com', 'Connect', '', '', '', clientConnectIds, TRUE, testUserEmail);
        // Verify new record was created
        System.assert(Case1Id != null);
        Case case1 = [
                SELECT
                        Id,
                        Subject,
                        Connect_Form_ID__c
                FROM
                        Case
                WHERE
                        Id = :case1Id
        ];
        System.assert(case1 != null);
        System.assertEquals(case1.Subject, 'Implementation Audit');
        // 2. Update status of existing record to Working

        case1.Status = 'on HOLD';
        Update case1;

        case1.Status = 'Submitted';
        Update case1;
        case1.Status = 'on HOLD';
        Update case1;
//
//        Contact testUser = new Contact(FirstName = 'test', );
//        upsert testUser;

        CaseHistory[] histories = new List<CaseHistory>();

        for (Integer i = 0; i < 10; i++) {
            histories.add(new CaseHistory(Field = 'Status', CaseId = case1.Id));
            histories.add(new CaseHistory(Field = 'Status', CaseId = case1.Id));
        }

        upsert histories;


        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = Url.getSalesforceBaseUrl() + '/services/apexrest/Cases/'
                + case1.Connect_Form_ID__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;
        // Call the method to test
        Test.startTest();
        ConnectCases.CaseLite[] results = ConnectCases.getCaseById();
        Test.stopTest();
        // Verify results

        System.debug(results);
        System.assert(results != null);
        ConnectCases.CaseLite result = results[0];

        System.assertNotEquals(null, result.statusHistory);
        System.assertEquals(20, result.statusHistory.size());

    }

    @isTest static void CaseHistoryLiteCoverage() {
        ConnectCases.CaseHistoryLite test = new ConnectCases.CaseHistoryLite();

        test.oldValue = 'old';
        test.newValue = 'new';
        test.createdByAvettaId = 'spoomeId';
        test.createdByEmail = 'an@email.com';
        test.createdByName = 'name';


    }


    @isTest static void testInsertCaseComment() {
        Id profileId = [SELECT Id
						FROM Profile
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        Id userRoleId = [SELECT Id
						FROM UserRole
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        String testUserEmail;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser) {
        	List<User> testUsers = QB_TestDataFactory.createUserRecords(1, TRUE, profileId, userRoleId);
            testUserEmail = testUsers[0].Email;
        }
        
        Account[] testClientAccounts = createClientAccounts(2, true);
        
        String[] clientConnectIds = new List<String>();
        for(Account testClientAccount : testClientAccounts) {
            clientConnectIds.add(testClientAccount.Id);
        }

        // 1. Insert new record
        ID case1Id = ConnectCases.upsertCase(
                '123456', '123456', '9876548768757657', 'Manual Audit', 'Implementation Audit', 'https://www.ksl.com', 'Connect', '', '', '', clientConnectIds, TRUE, testUserEmail);
        // Verify new record was created
        System.assert(Case1Id != null);

        Id[] results = ConnectCases.createCaseComment('9876548768757657', 'Test comment Body');

        System.assertNotEquals(null, results);
        System.assertEquals(1, results.size());

        Id result = results[0];

        CaseComment comment = [
                SELECT
                        Id,
                        CommentBody
                FROM
                        CaseComment
                WHERE
                        Id = :result
        ];

        System.assertNotEquals(null, comment);

        System.assertEquals(result, comment.Id);
        System.assertEquals('Test comment Body', comment.CommentBody);


    }

    @isTest static void testInsertCaseCommentWithoutCaseFirst() {
        Id profileId = [SELECT Id
						FROM Profile
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        Id userRoleId = [SELECT Id
						FROM UserRole
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        String testUserEmail;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser) {
        	List<User> testUsers = QB_TestDataFactory.createUserRecords(1, TRUE, profileId, userRoleId);
            testUserEmail = testUsers[0].Email;
        }
        
        Account[] testClientAccounts = createClientAccounts(2, true);
        
        String[] clientConnectIds = new List<String>();
        for(Account testClientAccount : testClientAccounts) {
            clientConnectIds.add(testClientAccount.Id);
        }

        // 1. Insert new record
//        ID case1Id = ConnectCases.upsertCase(
//                '123456', '123456', '9876548768757657', 'auditGUARD', 'Implementation Audit', 'https://www.ksl.com', 'Connect', '', '', '', clientConnectIds);
//        // Verify new record was created
//        System.assert(Case1Id != null);

        Id[] results = ConnectCases.createCaseComment('9876548768757657', 'Test comment Body');

        System.assertNotEquals(null, results);
        System.assertEquals(1, results.size());

        Id result = results[0];

        CaseComment comment = [
                SELECT
                        Id,
                        CommentBody
                FROM
                        CaseComment
                WHERE
                        Id = :result
        ];

        System.assertNotEquals(null, comment);

        System.assertEquals(result, comment.Id);
        System.assertEquals('Test comment Body', comment.CommentBody);


    }
    
    @isTest static void testCaseWithDataCommentWithoutData() {
        Id profileId = [SELECT Id
						FROM Profile
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        Id userRoleId = [SELECT Id
						FROM UserRole
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        String testUserEmail;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser) {
        	List<User> testUsers = QB_TestDataFactory.createUserRecords(1, TRUE, profileId, userRoleId);
            testUserEmail = testUsers[0].Email;
        }
        
        Account[] testClientAccounts = createClientAccounts(2, true);
        
        String[] clientConnectIds = new List<String>();
        for(Account testClientAccount : testClientAccounts) {
            clientConnectIds.add(testClientAccount.Id);
        }

        // 1. Insert new record
        ID case1Id = ConnectCases.upsertCase(
                '123456', '123456', '9876548768757657', 'Manual Audit', 'Implementation Audit', 'https://www.ksl.com', 'Connect', '', '', '', clientConnectIds, TRUE, testUserEmail);

        Id[] results = ConnectCases.createCaseComment('9876548768757657', 'Test comment Body');

        System.assertNotEquals(null, results);
        System.assertEquals(1, results.size());

        Id result = results[0];

        CaseComment comment = [
                SELECT
                        Id,
                        CommentBody
                FROM
                        CaseComment
                WHERE
                        Id = :result
        ];

        System.assertNotEquals(null, comment);

        System.assertEquals(result, comment.Id);
        System.assertEquals('Test comment Body', comment.CommentBody);
        
        Case case2 = [
                SELECT
                        Id,
                        Subject,
            			Type,
                        Connect_Form_ID__c
                FROM
                        Case
                WHERE
                        Id = :case1Id
        ];
        
		System.assertNotEquals(NULL, case2.Id);
        System.assertEquals('Manual Audit', case2.Type);
        System.assertEquals('Implementation Audit', case2.Subject);
        

    }

/*
    @isTest static void testUpdateCaseFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
           Url.getSalesforceBaseUrl() + '/services/apexrest/Cases/'
            + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"status": "Working"}');
        RestContext.request = request;
        // Update status of existing record to Working
        ID thisCaseId = ConnectCases.updateCaseFields();
        // Verify record was updated
        System.assert(thisCaseId != null);
        Case thisCase = [SELECT Id,Status FROM Case WHERE Id=:thisCaseId];
        System.assert(thisCase != null);
        System.assertEquals(thisCase.Status, 'Working');
    }
*/


}