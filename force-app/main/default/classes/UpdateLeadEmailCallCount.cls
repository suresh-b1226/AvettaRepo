/**Created by Jason McGrew on 5.29.2019
 * 
 * Developed for SF Case #00913947
 * 
 * This Class will count the amount of calls and emails on leads and update the calls_made__c & Emails_sent__c fields with the current amount. 
 * 
 * The Process Builder for Lead-Create.Edit will then reset the counts of calls_made__c and Emails_sent__c to 0 when then Lead Status is changed.
 *
 *
 */

public class UpdateLeadEmailCallCount {
    private static Boolean firstRun = true;
    private static Integer runCount = 0;

    //Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }

    //Method to set recursion variable to false
    public static void setRunCountZero() {
        runCount = 0;
        System.debug('setRunCountZero run');
    }

    //Method to set recursion variable to false
    public static void addRunCount() {
        runCount = runCount + 1;
        System.debug('runCount = ' + runCount);
    }

    public void updateTask_LeadEmailCallCountHandler(List<Task> newTrigger) {
        List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;

        //Prevents recursion
        if (profileName != 'Bizable User' && UpdateLeadEmailCallCount.runCount < 30
                && newTrigger != null) {


            List<Id> leadIds = new List<Id>();
            for (Task t : newTrigger) {
                if (!leadIds.contains(t.WhoId)) {
                    leadIds.add(t.WhoId);
                }
            }
            System.debug(' ** leadIds = ' + leadIds);

            List<Lead> leadList = [
                    SELECT Id, Calls_Made__c, Emails_Sent__c, Status
                    FROM Lead
                    WHERE Id = :leadIds
            ];
            System.debug(' ** leadList = ' + leadList);

            for (Task t : newTrigger) {
                if (t.Type == 'Call' || t.Type == 'call') {
                    if (t.Subject == 'Call' || t.Subject == 'call') {
                        for (Lead l : leadList) {
                            if (t.WhoId == l.Id) {
                                System.debug(' ** calls  - got here ');
                                if(l.Calls_Made__c == null) {
                                    l.Calls_Made__c = 0;
                                    l.Calls_Made__c = l.Calls_Made__c + 1;
                                }else if(l.Calls_Made__c != null) {
                                    l.Calls_Made__c = l.Calls_Made__c + 1;
                                }
                            }
                        }
                    }
                } else if (t.Type == 'Email' || t.Type == 'email') {
                    for (Lead l : leadList) {
                        if (t.WhoId == l.Id) {
                            System.debug(' ** emails - got here ');
                            if(l.Emails_Sent__c == null){
                                l.Emails_Sent__c = 0;
                                l.Emails_Sent__c = l.Emails_Sent__c + 1;
                            }else if(l.Emails_Sent__c != null) {
                                l.Emails_Sent__c = l.Emails_Sent__c + 1;
                            }
                        }
                    }
                }
            }
            System.debug(' ** leadListNum2 = ' + leadList);

            //Calls recursion prevention methods
            addRunCount();

            update leadList;
        }
    }
/*
    public void updateTalkdesk_LeadEmailCallCountHandler(List<talkdesk__Talkdesk_Activity__c> newTrigger) {
        System.debug(' ** updateTalkdesk_LeadEmailCallCountHandler Is Activated = ' + newTrigger);

        //Prevents recursion
        if (UpdateLeadEmailCallCount.runCount < 30
                && newTrigger != null) {

            List<Id> leadIds = new List<Id>();
            for (talkdesk__Talkdesk_Activity__c td : newTrigger) {
                if (!leadIds.contains(td.talkdesk__Lead__c)) {
                    leadIds.add(td.talkdesk__Lead__c);
                }
            }
            System.debug(' ** leadIds = ' + leadIds);

            List<Lead> leadList = [
                    SELECT Id, Calls_Made__c, Emails_Sent__c, Status
                    FROM Lead
                    WHERE Id = :leadIds
            ];
            System.debug(' ** leadList = ' + leadList);

            for (talkdesk__Talkdesk_Activity__c td : newTrigger) {
                if (td.talkdesk__Type__c != null) {
                    for (Lead l : leadList) {
                        System.debug(' ** Talk Desk Calls  - GOT HERE ');
                        if(l.Calls_Made__c == null) {
                            l.Calls_Made__c = 0;
                            l.Calls_Made__c = l.Calls_Made__c + 1;
                        }else if(l.Calls_Made__c != null) {
                            l.Calls_Made__c = l.Calls_Made__c + 1;
                        }
                    }
                }
            }
            System.debug(' ** leadListNum2 = ' + leadList);

            //Calls recursion prevention methods
            addRunCount();

            update leadList;
        }
    }
*/
}