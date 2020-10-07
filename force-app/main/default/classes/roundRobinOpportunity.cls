//Written by Dallin Wasden 4.26.2018
//Round robins new retention opportunities to distribute evenly among reps with "Retention" role. Allows opportunities to pile up to a predetermined size before assigning to reps.
public class roundRobinOpportunity {

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

    //Method to return a random Integer between 0 and passed through integer
    public static Integer getRandomNumber( Integer size ) {
        Double d = math.random() * size;
        return d.intValue();
    }

    //Method to handle all Retention opportunities
    public void roundRobinOpportunityRetentionHandler( List<Opportunity> newTrigger, List<Opportunity> oldTrigger ) {
        System.debug('roundRobinOpportunityTrigger Activated');

        //Prevents recursion
        if (roundRobinOpportunity.isFirstRun() == true) {
            setFirstRunFalse();
            Boolean correctRecordType = False;

            //Test all new opportunities to verify at least one of type 'retention' exists
            for (Opportunity opp : newTrigger) {
                if (opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId()) {
                    correctRecordType = True;
                }
            }

            //If one of type 'retention' exists, proceed
            if (correctRecordType == True) {

                //Retreive SIT Setting values to pull default user
                SIT_Settings__c defaultUser = SIT_Settings__c.getAll().values();

                //SOQL query all unclaimed retention opportunities
                List<Opportunity> opportunityList = [
                        select name, Id, OwnerId, Owner.Email, RecordTypeId, Amount_Due__c, Eligible_for_Deactivation__c, Primary_Contact__c, AccountId
                        from Opportunity
                        where ((RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId() and
                        Eligible_for_Deactivation__c = True))
                        and (Owner.Id = :defaultUser.Default_Opportunity_Owner__c
                        or Owner.Name = 'Dallin Wasden'
                        or Owner.Name = 'Spencer Petty')
                        and StageName = 'Open'
                        and Account_Status__c = 'Active'
                        order by Amount_Due__c desc
                ];
                System.debug('opportunityList size = ' + opportunityList.size());
                System.debug('newTrigger = ' + newTrigger);

                //************************************************************
                //**********CHANGE TRIGGERED PILE SIZE HERE*******************
                //************************************************************
                //Wait until x amount of opportunities of type retention or collection pile up and then run Round Robin (originally set at 20)
                if (opportunityList.size() > 20) {

                    //SOQL query all users with role 'Retention'
                    List<User> retentionUsers = [
                            select Id, Name, Email
                            from User
                            where UserRole.Name = 'Retention'
                    ];
                    System.debug('retentionUsers =' + retentionUsers);


                    System.debug('Enter roundRobinOpportunityRetentionHandler');

                    //Uses predefined method to retrieve a random number between 0 and the number of users as determined in trigger
                    Integer randomNumber = getRandomNumber(retentionUsers.size());
                    List<Opportunity> changedRetentionOpportunities = new List<Opportunity>();
                    System.debug('randomNumber = ' + randomNumber);
                    System.debug('retentionUsers.size = ' + retentionUsers.size());

                    //Loop through each retention opportunity from list instantiated in trigger
                    for (Opportunity retentionOpportunity : opportunityList) {

                        //Set first opportunity owner equal to random number and then set each following opportunity owner equal to the next consecutive retention user
                        retentionOpportunity.OwnerId = retentionUsers.get(randomNumber).Id;
                        System.debug('retentionOpportunity = ' + retentionOpportunity);

                        //Cycle through users using random number + 1 each time; once random number is larger than the retention user pool, start over at the beginning
                        randomNumber = randomNumber + 1;
                        if (randomNumber == retentionUsers.size()) {
                            randomNumber = 0;
                        }
                        System.debug('randomNumber increment = ' + randomNumber);

                        //Add changed opportunity to list of opportunities for bulk update
                        changedRetentionOpportunities.add(retentionOpportunity);
                        System.debug('changedRetentionOpportunities = ' + changedRetentionOpportunities);
                    }

                    //Bulk update assigned opportunities
                    update changedRetentionOpportunities;
                }
            }
        }
    }
}