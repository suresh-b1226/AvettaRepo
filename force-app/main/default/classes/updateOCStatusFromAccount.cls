//Written by Dallin Wasden 11.9.17
//Change operator contractor statuses to match linked account status upon change

public class updateOCStatusFromAccount {
    
    private static boolean firstRun = true;
    private static Integer runCount = 0;
    
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
    
    //Main handler method
    public void updateOCStatusFromAccountHandler( List<Account> newTrigger, List<Account> oldTrigger) {
        List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
        
        //Stops recursion
        if (profileName != 'Bizable User' && (updateOCStatusFromAccount.runCount < 1 || (test.isRunningTest() && updateOCStatusFromAccount.runCount < 5))) {
            
            System.debug('newTrigger = ' + newTrigger);
            
            List<Id> accountIds = new List<Id>();
            
            //Checks conditions for each updated account
            for (Account a : newTrigger) {
                Account matchingOldAccount;
                
                if(oldTrigger != NULL) {
                    for (Account oldAcct : oldTrigger) {
                        if (oldAcct.Id == a.Id) {
                            //Checks Status__C for changes and launches class if changed
                            if (oldAcct == NULL || a.Status__c != oldAcct.Status__c) {
                                System.debug('Entered trigger if statement');
                                String accountId = String.ValueOf(Trigger.newMap.get(a.id).Id);
                                accountIds.add(accountId);
                            }
                        }
                    }
                }
            }
            
            if(accountIds.size() > 0) {
                System.debug('OC Status Soql&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
                
                //Creates list of operator contractor objects where Contractor__c matches updated Account ID
                List<Operator_Contractor__c> oppconts = [
                    SELECT Id, Contractor_Status__c, Status__c, Contractor__c, Initial_Payment_Made__c
                    FROM Operator_Contractor__c
                    WHERE Contractor__c = :accountIds
                ];
                
                System.debug('Opps list: ' + oppconts);
                List<Operator_Contractor__c> oppContsToUpdate = new List<Operator_Contractor__c>();
                
                //For each operator contractor in list, set each Contractor_Status__c equal to the corresponding account Status__c
                for (Operator_Contractor__c oppcont : oppconts) {
                    for (Account a : newTrigger) {
                        if(oppcont.Contractor__c == a.Id) {
                            System.debug(oppcont.Id);
                            
                            oppcont.Contractor_Status__c = a.Status__c;
                            
                            if(a.Status__c == 'Active' && oppcont.Status__c == 'Active'){
                                oppcont.Initial_Payment_Made__c = true;
                            }
                            System.debug('After status ' + oppcont.Contractor_Status__c);
                            
                            System.debug(oppcont);
                            
                            oppContsToUpdate.add(oppcont);
                            System.debug('oppcont added to update list ' + oppcont);
                        }
                    }
                }
                update oppContsToUpdate;
                System.debug('oppcont successfully updated');
            }
        }
        
            addRunCount();
    }
}