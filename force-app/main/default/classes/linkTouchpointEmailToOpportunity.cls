//Written by Dallin Wasden 2.21.2018
//Links opportunities matching specified criteria to tasks created in account. Created for Marketo campaign use case
//which would insert tasks and not link them to the opportunity that already existed in the account. Tasks must have 
//Subject "Was Sent Email...Contractors/Suppliers" in subject line and be owned by the Marketo user. Matching opportunities
//must be linked to the same Account as the Task, not of Stage "Closed Lost" or "Closed Won", of Type "Reactivation" or "Retention",
//and of Record Type "Supplier".
public class linkTouchpointEmailToOpportunity {
    private static boolean firstRun = true;

    //Used to prevent recursion
    public static boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }

    //Method to set recursion variable to false
    public static void setFirstRunFalse() {
        firstRun = false;
        System.debug('setFirstRunFalse run');
    }

    public void linkTouchpointEmailToOpportunityHandler( List<Task> newTrigger, List<Task> oldTrigger, Boolean isDelete ) {
        List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;

        //Prevents recursion
        if (profileName != 'Bizable User' && linkTouchpointEmailToOpportunity.isFirstRun() == true) {
            linkTouchpointEmailToOpportunity.setFirstRunFalse();

            //Query to pull Id for Marketo's Marketing User
            List<User> marketoUsers = [
                    select Id, Username, CommunityNickname
                    from User
                    Where CommunityNickname = 'Marketo' or
                    Username = 'dwasden@avetta.com.refactor' or
                    Username = 'dwasden@avetta.com.dev' or
                    Username = 'dwasden@avetta.com.stg' or
                    Username = 'dwasden@avetta.com'
            ];
            List<Task> touchTasks = new List<Task>();

            List<Task> taskList = new List<Task>();
            if(isDelete == FALSE) {
                taskList = newTrigger;
            } else {
                taskList = oldTrigger;
            }
                
            
            for (Task t : taskList) {
                System.debug('Pass t:' + t);
                if (t.Subject != NULL) {
                    //If inserted task contains string 'Was Sent Email: TM.' or 'Was Sent Email: EBL.EXT' & 'Contractors' or 'Suppliers' in subject
                    if (String.ValueOf(t.Subject).contains('Was Sent Email: TM.') == TRUE |
                            (String.ValueOf(t.Subject).contains('Was Sent Email: EBL.EXT') == TRUE &
                                    (String.ValueOf(t.Subject).contains('Contractors') == TRUE |
                                            String.ValueOf(t.Subject).contains('Suppliers') == TRUE))) {

                        //Populate list with all matching tasks in trigger
                        touchTasks.add(t);
                    }
                }
            }

            System.debug('Enter linkTouchpointEmailToOpportunity with TouchTasks = ' + touchTasks);
            System.debug('marketoUsers = ' + marketoUsers);
            List<Id> associatedAccounts = new List<Id>();
            List<Id> taskIds = new List<Id>();
            List<Task> updatedTaskList = new List<Task>();

            for (Task t : touchTasks) {
                System.debug('t = ' + t);

                //Only run class for marketo-created task (and test class created by Dallin)
                if ((t.OwnerId == marketoUsers[0].Id) & t.AccountId != NULL) {
                    associatedAccounts.add(t.AccountId);
                    taskIds.add(t.Id);
                }
            }

            //Instantiates list of opportunities with associated account id and a match to specified criteria (ideally 1 opportunity)
            System.debug('taskIds = ' + taskIds);
            List<Opportunity> allLinkedOpportunityList = [
                    select Id, CreatedDate, Client_Account__c, Campaign__c, AccountId
                    from Opportunity
                    where AccountId = :associatedAccounts
                    And (StageName != 'Closed Lost' And StageName != 'Closed Won')
                    And (Type = 'Reactivation' Or Type = 'Registration')
                    And RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId()
            ];
            System.debug('allLinkedOpportunityList = ' + allLinkedOpportunityList);

            //Instantiates list of client accounts with associated id from task client accounts
            List<String> associatedCampaigns = new List<String>();
            for (Opportunity linkedOpportunity : allLinkedOpportunityList) {
                associatedCampaigns.add(linkedOpportunity.Campaign__c);
            }

            //Instantiates list of associated subject lines
            List<String> associatedSubjects = new List<String>();
            for (Opportunity linkedOpportunity : allLinkedOpportunityList) {
                associatedSubjects.add('Was Sent Email: %' + linkedOpportunity.Campaign__c + '%');
            }
            System.debug('associatedSubjects = ' + associatedSubjects);

            //Instantiates list of campaigns with matching client account id
            List<Campaign> allLinkedCampaignList = [
                    select Id, Name
                    from Campaign
                    where Name = :associatedCampaigns
            ];
            System.debug('allLinkedCampaignList = ' + allLinkedCampaignList);

            //Instantiates list of tasks with associated subjects and IDs from trigger
            List<Task> allTaskListUpdate = [
                    select Id, WhatId, Subject, Type, AccountId
                    from Task
                    where Id = :taskIds
                    and Subject like :associatedSubjects
            ];
            System.debug('allTaskListUpdate = ' + allTaskListUpdate);

            //Loop through all matching tasks
            for (Task t : allTaskListUpdate) {
                System.debug('touchTasks Task = ' + t);
                List<Opportunity> linkedOpportunityList = new List<Opportunity>();

                //Loop through opportunities to find matching which one's AccountId matches the task's AccountId
                for (Opportunity linkedOpportunity : allLinkedOpportunityList) {
                    if (t.AccountId == linkedOpportunity.AccountId) {
                        linkedOpportunityList.add(linkedOpportunity);
                    }
                }

                //Handles situations where multiple opportunities match established criteria by taking the opportunity with the most recent creation date
                if (!linkedOpportunityList.isEmpty()) {
                    datetime highCreatedDate = Datetime.newInstance(1960, 2, 17);
                    Opportunity recentOpportunity;

                    //Loops through all matching opportunities to find most recently created
                    for (Opportunity indOpportunity : linkedOpportunityList) {
                        if (indOpportunity.CreatedDate > highCreatedDate) {
                            highCreatedDate = indOpportunity.CreatedDate;
                            recentOpportunity = indOpportunity;
                        }
                    }
                    system.debug('recentOpportunity = ' + recentOpportunity);
                    system.debug('t = ' + t);
                    system.debug('allLinkedCampaignList = ' + allLinkedCampaignList.size());
                    //Instantiates list of campaigns with matching ClientAccountIds to the most recent opportunity
                    List<Campaign> linkedCampaignList = new List<Campaign>();
                    for (Campaign linkedCampaign : allLinkedCampaignList) {
                        if (String.ValueOf(t.Subject).contains(linkedCampaign.Name) == TRUE) {
                            linkedCampaignList.add(linkedCampaign);
                        }
                    }
                    System.debug('linkedCampaignList = ' + linkedCampaignList);

                    //Ensures linked campaign exists, if so, then opportunity is marked as a valid match ready to be linked
                    if (!linkedCampaignList.isEmpty()) {
                        System.debug('Enter valid campaign if statement');
                        System.debug('t = ' + t);

                        //Link opportunity to task and change Type to 'Email'
                        t.WhatId = recentOpportunity.Id;
                        t.Type = 'Email';

                        //Add task to list of updated tasks to use for bulk update
                        updatedTaskList.add(t);
                    }
                }
            }

            //Bulk update tasks
            system.debug('updatedTaskList = ' + updatedTaskList);
            update updatedTaskList;
        }
    }
}