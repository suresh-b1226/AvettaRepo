//Written by Dallin Wasden 7.20.2018
//Round robins new Vetify cases to distribute evenly among reps with "Vetify" role. Runs after auto-creation of cases from committed opportunities.
//Used in conjunction with Supplier_Vetify_Case_FollowUp trigger and class.

public class Supplier_Vetify_Case_RoundRobin {
    public void Supplier_Vetify_Case_RoundRobinHandler( List<Case> newTrigger, List<Case> oldTrigger ) {

        List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
        
        List<Case> vetifyCase = new List<Case>();

        //Check all cases in trigger to ensure at least one of Record Type 'Vetify' exists
        for (Case singleCase : newTrigger) {
            if (singleCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId()) {
                vetifyCase.add(singleCase);
            }
        }

        //Prevents recursion and ensures at least one of opportunities in trigger is of Record Type 'Vetify' to ensure trigger and class are necessary
        if (profileName != 'Bizable User' && newTrigger != NULL && vetifyCase.size() > 0) {

            //SOQL query all users with role 'Vetify Fulfillment'
            List<User> userList = [
                    select Id, Name, Email, UserRole.Name
                    from User
                    where UserRole.Name = 'Vetify Fulfillment' and isActive = TRUE
            ];
            System.debug('userList =' + userList);

            //Gets a list of Vetify User IDs
            List<Id> vetifyIds = new List<Id>();
            for (User vetifyUser : userList) {
                vetifyIds.add(vetifyUser.Id);
            }

            List<roundRobinVariable__c> roundRobinList = new List<roundRobinVariable__c>();

            //Queries roundRobinVariable custom object to determine which rep is next in line to be assigned a Vetify case
            roundRobinList = [
                    select roundRobinID__c
                    from roundRobinVariable__c
                    where name = 'Vetify Fulfillment'
            ];

            roundRobinVariable__c roundRobin = (roundRobinList != NULL && roundRobinList.size() > 0) ? roundRobinList[0] : NULL;

            Integer roundRobinOriginal = 0;
            if (roundRobin != NULL) {
                roundRobinOriginal = integer.valueOf(roundRobin.roundRobinID__c);
            } else {
                roundRobin.roundRobinID__c = 0;
            }

			if (roundRobin.roundRobinID__c > userList.size() - 1){
                        roundRobin.roundRobinID__c = 0;
                    }
            update roundRobin;

            //Iterates through cases in the trigger to assign case to proper rep. If the roundRobinVariable is at the end of the queue of reps, this logic starts it over at the beginning.
            for (Case singleCase : newTrigger) {
                if (vetifyIds.contains(singleCase.OwnerId) == FALSE) {
                    singleCase.OwnerId = userList[integer.valueOf(roundRobin.roundRobinID__c)].Id;
                    if (roundRobin.roundRobinID__c == userList.size() - 1) {
                        roundRobin.roundRobinID__c = 0;
                    } else {
                        roundRobin.roundRobinID__c++;
                    }
                }
            }

            System.debug('roundRobin = ' + roundRobin);
            System.debug('roundRobinOriginal = ' + roundRobinOriginal);

            //Updates the roundRobinVariable in the database, if it changed
            if (roundRobinOriginal != integer.valueOf(roundRobin.roundRobinID__c)) {
                update roundRobin;
            }
        }
    }
}