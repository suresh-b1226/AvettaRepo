/**
 * Created by JasonMcGrew on 10/28/2020.
 */

trigger FeedComment_Trigger on FeedComment (after insert) {

    SFTeam_FeedComment_Notification feedCommentTrigger = new SFTeam_FeedComment_Notification();


//After Insert Trigger.

    if (Trigger.isInsert  && Trigger.isAfter){
        feedCommentTrigger.feedComment_Notification(Trigger.new);

    }

}