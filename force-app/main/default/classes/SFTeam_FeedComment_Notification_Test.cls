/**
 * Created by JasonMcGrew on 10/29/2020.
 */

@IsTest
private class SFTeam_FeedComment_Notification_Test {

    @IsTest static void FeedCommentTest() {

        User User1 = [ SELECT Id FROM User WHERE Id = :UserInfo.getUserId() ];

        System.runAs ( User1 ) {


            User User2 = new User();
            User2.FirstName = 'Test';
            User2.LastName = 'User2';
            User2.Email = 'TestUser@test.com';
            User2.Username = 'testUser9999@test.com';
            User2.LanguageLocaleKey = 'en_US';
            User2.LocaleSidKey = 'en_US';
            User2.Alias = 'alias';
            User2.TimeZoneSidKey = 'America/Los_Angeles';
            User2.EmailEncodingKey = 'UTF-8';
            User2.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;

            insert User2;

            Case insertSFCase = new Case();
            insertSFCase.Status = 'Waiting on reporter';
            insertSFCase.Subject = 'Test Case 1';
            insertSFCase.RecordTypeId = '0120g0000009tDpAAI';
            insertSFCase.Reporting_User__c = User1.Id;
            insertSFCase.EffortType__c = 'Enhancement';
            insertSFCase.Fast_Pass__c = 'No';

            insert insertSFCase;
            System.debug('insertSFCase = ' + insertSFCase);


            FeedItem chatterMessage = new FeedItem();
            chatterMessage.Body = 'This is a test chatter message!';
            chatterMessage.ParentId = insertSFCase.Id;

            insert chatterMessage;
            System.debug('chatterMessage = ' + chatterMessage);

            FeedComment comment1 = new FeedComment();
            comment1.CommentBody = 'Response to the Chatter Message';
            comment1.CreatedById = User2.Id;
            comment1.FeedItemId  = chatterMessage.Id;

            insert comment1;

            FeedComment comment2 = new FeedComment();
            comment2.CommentBody = 'This response should not send an Email.';
            comment2.CreatedById = User1.Id;
            comment2.FeedItemId  = chatterMessage.Id;

            insert comment2;
        }
    }
}