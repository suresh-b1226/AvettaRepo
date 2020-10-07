/**
 * Created by brett on 9/10/18.
 */

@IsTest
private class ConnectCasesDeleteTest {

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

    @isTest static void testDeleteNoCaseByConnectFormId() {
        Case[] testCases = createTestRecord(1, true);
        CaseComment[] testComments = createTestComment(testCases[0], 1, true);
        // Set up a test request

        String[] payload = new List<String>();
//        payload.add(testCases[0].Connect_Form_ID__c);

        // Call the method to test
        ConnectCasesDelete.DeleteCasesResponse results = ConnectCasesDelete.deleteCasesFromConnectFormId(payload);
        // Verify results
        System.debug(results);
        System.assert(results != null);

        System.assertEquals(true, results.success);
        System.assertEquals('', results.message);
        Boolean resultsNotFound = false;

        try {
            Case queryResult = [
                    SELECT Id
                    FROM Case
                    WHERE Connect_Form_ID__c in :payload
            ];
        } catch (Exception e) {

            resultsNotFound = true;

        }
        System.assertEquals(true, resultsNotFound);
    }

    @isTest static void testDeleteSingleCaseByConnectFormId() {
        Case[] testCases = createTestRecord(1, true);
        CaseComment[] testComments = createTestComment(testCases[0], 1, true);
        // Set up a test request

        String[] payload = new List<String>();
        payload.add(testCases[0].Connect_Form_ID__c);

        // Call the method to test
        ConnectCasesDelete.DeleteCasesResponse results = ConnectCasesDelete.deleteCasesFromConnectFormId(payload);
        // Verify results
        System.debug(results);
        System.assert(results != null);

        System.assertEquals(true, results.success);
        System.assertEquals('', results.message);
        Boolean resultsNotFound = false;

        try {
            Case queryResult = [
                    SELECT Id
                    FROM Case
                    WHERE Connect_Form_ID__c = :testCases[0].Id
            ];
        } catch (Exception e) {

            resultsNotFound = true;

        }
        System.assertEquals(true, resultsNotFound);
    }

    @isTest static void testDeleteTwoCasesByConnectFormId() {
        Case[] testCases = createTestRecord(2, true);
        CaseComment[] testComments = createTestComment(testCases[0], 1, true);
        // Set up a test request

        String[] payload = new List<String>();
        payload.add(testCases[0].Connect_Form_ID__c);
        payload.add(testCases[1].Connect_Form_ID__c);

        // Call the method to test
        ConnectCasesDelete.DeleteCasesResponse results = ConnectCasesDelete.deleteCasesFromConnectFormId(payload);
        // Verify results
        System.debug(results);
        System.assert(results != null);

        System.assertEquals(true, results.success);
        System.assertEquals('', results.message);
        Boolean resultsNotFound = false;

        try {
            Case queryResult = [
                    SELECT Id
                    FROM Case
                    WHERE Connect_Form_ID__c in :payload
            ];
        } catch (Exception e) {

            resultsNotFound = true;

        }
        System.assertEquals(true, resultsNotFound);
    }

    @isTest static void testDeleteTwoOfThreeCasesByConnectFormId() {
        Case[] testCases = createTestRecord(3, true);
        CaseComment[] testComments = createTestComment(testCases[0], 1, true);
        // Set up a test request

        String[] payload = new List<String>();
        payload.add(testCases[0].Connect_Form_ID__c);
        payload.add(testCases[1].Connect_Form_ID__c);

        // Call the method to test
        ConnectCasesDelete.DeleteCasesResponse results = ConnectCasesDelete.deleteCasesFromConnectFormId(payload);
        // Verify results
        System.debug(results);
        System.assert(results != null);

        System.assertEquals(true, results.success);
        System.assertEquals('', results.message);
        Boolean resultsNotFound = false;

        payload.add(testCases[2].Connect_Form_ID__c);

        Case[] queryResults;

        try {
            queryResults = [
                    SELECT Id
                    FROM Case
                    WHERE Connect_Form_ID__c in :payload
            ];
        } catch (Exception e) {

            resultsNotFound = true;

        }
        System.assertEquals(false, resultsNotFound);

        System.assertEquals(1, queryResults.size());
    }

    @isTest static void testDeleteNoCasesByConnectFormId() {
        Case[] testCases = createTestRecord(3, true);
        CaseComment[] testComments = createTestComment(testCases[0], 1, true);
        // Set up a test request

        String[] payload = new List<String>();
        payload.add('test');
//        payload.add(testCases[0].Connect_Form_ID__c);
//        payload.add(testCases[1].Connect_Form_ID__c);

        // Call the method to test
        ConnectCasesDelete.DeleteCasesResponse results = ConnectCasesDelete.deleteCasesFromConnectFormId(payload);
        // Verify results
        System.debug(results);
        System.assert(results != null);

        System.assertEquals(true, results.success);
        System.assertEquals('', results.message);
        Boolean resultsNotFound = false;

        payload.add(testCases[0].Connect_Form_ID__c);
        payload.add(testCases[1].Connect_Form_ID__c);
        payload.add(testCases[2].Connect_Form_ID__c);

        Case[] queryResults;

        try {
            queryResults = [
                    SELECT Id
                    FROM Case
                    WHERE Connect_Form_ID__c in :payload
            ];
        } catch (Exception e) {

            resultsNotFound = true;

        }
        System.assertEquals(false, resultsNotFound);

        System.assertEquals(3, queryResults.size());
    }
    @isTest static void testDeleteNoCasesByConnectFormId2() {
        Case[] testCases = createTestRecord(3, true);
        CaseComment[] testComments = createTestComment(testCases[0], 1, true);
        // Set up a test request

        String[] payload = new List<String>();
        payload.add(null);
//        payload.add(testCases[0].Connect_Form_ID__c);
//        payload.add(testCases[1].Connect_Form_ID__c);

        // Call the method to test
        ConnectCasesDelete.DeleteCasesResponse results = ConnectCasesDelete.deleteCasesFromConnectFormId(null);
        // Verify results
        System.debug(results);
        System.assert(results != null);
//
//        System.assertEquals(true, results.success);
//        System.assertEquals('', results.message);
//        Boolean resultsNotFound = false;
//
//        payload.add(testCases[0].Connect_Form_ID__c);
//        payload.add(testCases[1].Connect_Form_ID__c);
//        payload.add(testCases[2].Connect_Form_ID__c);
//
//        Case[] queryResults;
//
//        try {
//            queryResults = [
//                    SELECT Id
//                    FROM Case
//                    WHERE Connect_Form_ID__c in :payload
//            ];
//        } catch (Exception e) {
//
//            resultsNotFound = true;
//
//        }
//        System.assertEquals(false, resultsNotFound);
//
//        System.assertEquals(3, queryResults.size());
    }
}