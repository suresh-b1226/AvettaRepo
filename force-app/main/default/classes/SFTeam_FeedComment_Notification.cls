/**
 * Created by JasonMcGrew on 10/27/2020.
 *
 * For SF Case# 02821804
 *
 */

public with sharing class SFTeam_FeedComment_Notification {

    public void feedComment_Notification(List<FeedComment> newTrigger){
        System.debug('ENTERING FEED COMMENT TRIGGER');

        //Query for the OrgWideEmailAddress that the email will be sent from
/*        OrgWideEmailAddress emailAddress = [
                SELECT Id
                FROM OrgWideEmailAddress
                WHERE Address = 'salesforcesupport@avetta.com'
        ];
        System.debug('emailAddress = ' + emailAddress );*/

        //Query for the correct Email Template to be sent
/*        EmailTemplate template = [
                SELECT Id
                FROM EmailTemplate
                WHERE DeveloperName = 'Reporting_User_Responded'
        ];
        System.debug('template = ' + template );*/

        //create a set of all the feedComment Ids
        Set<Id> ccIds = new Set<Id>();
        for (FeedComment fc : newTrigger){
            if (fc != null) ccIds.add(fc.ParentId);
        }
        System.debug('ccIds = ' +  ccIds);

        //Create a set of all the feedComment Owner Ids
        Set<Id> feedCommentersId = new Set<Id>();
        Map<Id, Id> commentersMap = new Map<Id, Id>();
        for (FeedComment f : newTrigger){
            if (f.CreatedById != null) {
                feedCommentersId.add(f.CreatedById);
                commentersMap.put(f.ParentId, f.CreatedById);
            }
        }
        System.debug('feedCommentersId = ' +  feedCommentersId);

        Map<Id, User> userProfileMap = new Map<Id, User>([
                SELECT Id, Profile.Name
                FROM User
                WHERE Id =: feedCommentersId]);
        System.debug('userProfileMap = ' + userProfileMap);

        //Query all the Cases that have an associated FeedComment ParentId
        List<Case> associatedCases = new List<Case>([
                SELECT Id, OwnerId
                FROM Case
                WHERE Id IN : ccIds
                AND Status = 'Waiting on Reporter'
                AND (RecordType.DeveloperName = 'Avetta_Salesforce_Support')
        ]);
        System.debug('associatedCases = ' +  associatedCases);


        // Set up the email notification to send to the Case Owner that a comment has been made.
        // Will not send to the Case Owner if the comment on a case they own.
        // This will also set the Case.Status to 'Waiting on Reporter'

        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
        for (Case c : associatedCases) {

            if (feedCommentersId.contains(c.OwnerId)){
                break;
            } else if (userProfileMap.get(commentersMap.get(c.Id)).Profile.Name == 'System Administrator' || userProfileMap.get(commentersMap.get(c.Id)).Profile.Name == 'Development') {
                break;

                } else {

                c.Status = 'Under Review';

/*                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

                message.setTargetObjectId(c.OwnerId);
                message.setTemplateId(template.Id);
                message.saveAsActivity = false;
                //message.setWhatId(c.Id);
                messageList.add(message);*/
            }
        }
        update associatedCases;
        System.debug('messageList = ' + messageList);

  /*      if (messageList != null){
            Messaging.sendEmail(messageList);
            update associatedCases;
        }*/
    }
}