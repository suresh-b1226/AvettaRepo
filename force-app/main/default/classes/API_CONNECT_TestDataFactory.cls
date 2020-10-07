/**
 * Created by brett on 6/18/18.
 */

@IsTest
public class API_CONNECT_TestDataFactory {


    // Helper method
    public static Case[] createTestRecord(Integer howMany, Boolean doInsert) {

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

    public static CaseComment[] createTestComment(Case testCase, Integer howMany, Boolean doInsert) {

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
}