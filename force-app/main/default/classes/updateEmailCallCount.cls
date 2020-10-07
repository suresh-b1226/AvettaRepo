//Written by Dallin Wasden 12.14.2017
//Tracks the number of email and call activities by opportunity. Viewable on "Calls Made" and "Emails Sent" fields on the opportunity page.
//5.1.2018 - Revised by Dallin Wasden. Bulkified class as a result of SOQL errors while developing Supplier_Collect_Opty_RoundRobin.
//Testing Notes - Log call, add notes to opportunity

// Code Update 9.16.2020 by Jason McGrew - Added Current_Emails_Sent__c & Current_Calls_Made__c to the call counter.

public class updateEmailCallCount {
    private static Boolean firstRun = true;

    //Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }

    //Method to set recursion variable to false
    public static void setFirstRunFalse() {
        firstRun = false;
        System.debug('setFirstRunFalse run');
    }

    //Method to set recursion variable to true
    public static void setFirstRunTrue() {
        firstRun = true;
        System.debug('setFirstRunTrue run');
    }

    public void updateEmailCallCountHandler( List<SObject> newTrigger, List<SObject> oldTrigger, Boolean isDelete ) {
        System.debug('updateEmailCallCountTrigger Activated: Trigger.old = ' + oldTrigger);
        System.debug('updateEmailCallCountTrigger Activated' + newTrigger);

        List<Id> accountIds = new List<Id>();

        //Finds all WhatIds on all inserted/updated Tasks
        if (isDelete == false) {

            for (SObject o : newTrigger) {

                if(String.valueOf(o.getSObjectType()) == 'Task') {
                    Task t = new Task();
                    t = (Task) o ;
                    accountIds.add( t.WhatId );
                }

                else {
                    talkdesk__Talkdesk_Activity__c td = new talkdesk__Talkdesk_Activity__c();
                    td = (talkdesk__Talkdesk_Activity__c) o ;
                    accountIds.add( td.talkdesk__Opportunity__c );
                }
            }
        }

        else {

            for (SObject o : oldTrigger) {

                if(String.valueOf(o.getSObjectType()) == 'Task') {
                    Task t = new Task();
                    t = (Task) o ;
                    accountIds.add( t.WhatId );
                }

                else {
                    talkdesk__Talkdesk_Activity__c td = new talkdesk__Talkdesk_Activity__c();
                    td = (talkdesk__Talkdesk_Activity__c) o ;
                    accountIds.add( td.talkdesk__Opportunity__c );
                }
            }
        }

        System.debug('taskWhatIds = ' + accountIds);

        Integer iCount = 0;
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        List<Id> oppIds = new List<Id>();

        //Instantiates list of opportunities with associated ids
        List<Opportunity> opportunityList = [
                SELECT Id, Calls_Made__c, Emails_Sent__c, Current_Emails_Sent__c, Current_Calls_Made__c
                FROM Opportunity
                WHERE Id = :accountIds
        ];

        System.debug('opportunityList = ' + opportunityList);

        //Instantiates list to use for tasks with subject containing or of type 'email' or 'call'
        List<talkdesk__Talkdesk_Activity__c> oppTalkdeskActivityList = [
                SELECT talkdesk__Type__c, talkdesk__Account__c, talkdesk__Opportunity__c
                FROM talkdesk__Talkdesk_Activity__c
                WHERE talkdesk__Opportunity__c = :opportunityList
        ];

        System.debug('oppTalkdeskActivityList = ' + oppTalkdeskActivityList);

        //Instantiates list to use for tasks with subject containing or of type 'email' or 'call'
        List<Task> oppTaskList = [
                SELECT Subject, Type, WhatId
                FROM Task
                WHERE WhatId = :opportunityList
                AND (Subject LIKE '%email%' OR Type LIKE '%email%' OR Subject LIKE '%call%' OR Type LIKE '%call%')
                AND Type != NULL
        ];

        System.debug('oppTaskList = ' + oppTaskList);
        System.debug('oppTaskList.size() = ' + oppTaskList.size());

        List<Opportunity> updatedOptys = new List<Opportunity>();
        for (Opportunity opty : opportunityList) {
            opty.Calls_Made__c          = 0;
            opty.Emails_Sent__c         = 0;

            System.debug('opty = ' + opty);

            for (talkdesk__Talkdesk_Activity__c talkDeskActivity : oppTalkdeskActivityList) {
                System.debug('talkDeskActivity = ' + talkDeskActivity);
                if(talkDeskActivity.talkdesk__Opportunity__c == opty.Id) {
                    opty.Calls_Made__c++;
                }
            }

            for (Task oppTask : oppTaskList) {
                System.debug('oppTask = ' + oppTask);
                if (oppTask != null) {
                    if (oppTask.WhatId == opty.Id) {
                        if (oppTask.Type == 'Call' | String.valueOf(oppTask.Subject).toLowerCase().contains('call')) {
                            System.debug('new call made = ' + opty);
                            opty.Calls_Made__c++;
                        }
                        if (oppTask.Type == 'Email' | String.valueOf(oppTask.Subject).toLowerCase().contains('email')) {
                            System.debug('new email sent = ' + opty);
                            opty.Emails_Sent__c++;
                        }
                    }
                }
            }

            updatedOptys.add(opty);
        }



        System.debug('updatedOptys = ' + updatedOptys);

        //Removes duplicated entries
        if(updatedOptys.size() > 0){

            //Bulk updates all opportunities with accurate email and call counts
            update updatedOptys;
        }
    }
}