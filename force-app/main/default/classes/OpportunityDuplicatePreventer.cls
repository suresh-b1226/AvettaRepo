//Written by TorrenPhillips(3rdEyeConsulting) 6/9/2017  SFDC-129

public class OpportunityDuplicatePreventer {
    
    private static boolean firstRun = true;
    
    //Used to prevent recursion
    public static boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }
    
    //Method to set recursion variable to false
    public static void setFirstRunFalse(){
        firstRun = false;
        System.debug('setFirstRunFalse run');
    }
    
    public void DeDupeCheck(List<Opportunity> NewOpties) {
        //Creates Lists
        Set<Id> OptyAccount = new Set<Id>();
        for(Opportunity Opty : NewOpties) {
            // keep track of all suppliers that made a connection who paid
            if(Opty.AccountId != null 
                && Opty.Client_Account__c != null
                && Opty.Type == 'Registration'
                && Opty.RecordTypeId =='01270000000cebq')
                //Then
            {
                //If the Opty was the kind we want, we add it to our list here
                OptyAccount.add(Opty.AccountId);
            }          
        }
        //Gets the Other Opportunities to compare (ignores the one we are updating)
        List<Opportunity> opps = [select id, Client_Account__c, AccountId from Opportunity 
                                  where AccountId in: OptyAccount And  StageName <> 'Closed Lost' And Type = 'Registration' AND RecordTypeId ='01270000000cebq' AND id not in:NewOpties];
        Set<String> ExistingOptys = new Set<String>();
        for(Opportunity LoadCompare : opps) {
             ExistingOptys.add(LoadCompare.AccountId + '' + LoadCompare.Client_Account__c);     
        }
        ID UserProfileID = UserInfo.getProfileId();
        //SFDC-225 Updated line 31 to look to not include additional UserProfileID - Scott Ohlund
        //IF(UserProfileID <> '00e70000000tKSw' && UserProfileID <>'00e7000000185eW'){
        IF(UserProfileID <> '00e70000000tKSw' && UserProfileID <>'00e7000000185eW' && UserProfileID <>'00e7000000184Tz'){
        //Comparing of lists
            for(Opportunity FinalCompare : NewOpties) {
                //compares Opty Changes to the list we pulled - throws error when it finds one
                IF(ExistingOptys.contains(FinalCompare.AccountId + '' + FinalCompare.Client_Account__c)) {
                    FinalCompare.addError('We already have an Opportunity like this, we do not want another.');
                } 
                
            }
        }
    }
    
}