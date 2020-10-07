//Originally written by Leon Edwards (Slalom) 3.15.17
//Edited Lines 112 (include only Supplier RT) &  96/101 (Only trigger for Active:Contractor Status)  TorrenPhillips(3rdI) 5.25.17

/**
* Updated on 02.19.2020 by Jason McGrew
*
* Updated to not include opportunities that are StageName = 'Closed Lost", Result__C = 'Duplicate' in additional Automation.
* 
* */


public without sharing class QB_OperatorContractorHandler 
{
    
    private Boolean m_isExecuting = false;
    
    
    public QB_OperatorContractorHandler(Boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    private static Boolean firstRun = true;
    
    //Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }
    
    //Method to set recursion variable to false
    public static void setFirstRunFalse(){
        firstRun = false;
        System.debug('setFirstRunFalse run');
    }
    
    //Method to set recursion variable to true
    public static void setFirstRunTrue(){
        firstRun = true;
        System.debug('setFirstRunTrue run');
    }
    
    //Use for adding future lines of code to an Operator Contractor trigger in OnBeforeInsert, OnBeforeUpdate
    
    
    /*   public void OnBeforeInsert(List<Operator_Contractor__c> listOpCon)
{

Set<Id> contractorIds = new Set<Id>();
Set<String> setOfOperatorContractorCombo = new Set<String>();

for(Operator_Contractor__c operaCon : listOpCon)
{
if(operaCon.Operator__c != null && operaCon.Contractor__c != null){
contractorIds.add(operaCon.Contractor__c);
setOfOperatorContractorCombo.add(operaCon.Operator__c + '' + operaCon.Contractor__c);
}

}

List<Opportunity> oppsToUpdate = new List<Opportunity>();

for(Opportunity opp : [select id, StageName, Client_Account__c, AccountId from Opportunity where AccountId in: contractorIds And IsClosed = false])
{
if (setOfOperatorContractorCombo.contains(opp.Client_Account__c + '' + opp.AccountId)) {

opp.StageName='Closed Won';

oppsToUpdate.add(opp);
System.debug(opp);
}
}

update oppsToUpdate; 

} */
    
    public void OnAfterInsert(List<Operator_Contractor__c> listOpCon, Map<Id, Operator_Contractor__c> mapNew )
    {
        System.debug( ' on after insert');
        updateSelfRegistrationStatus (listOpCon)  ;  
        uppdatOperactorContractor(listOpCon, new Map<Id, Operator_Contractor__c>());
    }
    
    
    /* public void OnBeforeUpdate()
{
// BEFORE UPDATE LOGIC
}*/
    
    public void OnAfterUpdate(Operator_Contractor__c[] updatedObjects,Map<Id, Operator_Contractor__c> mapOld)
    {
        updateSelfRegistrationStatus (updatedObjects)  ; 
        uppdatOperactorContractor(updatedObjects,mapOld);
    }
    
    // Use for adding future lines of code to an opportunity trigger OnBeforeDelete, OnAfterDelete, OnUndelete
    /*    public void OnBeforeDelete(Object[] ObjectsToDelete)
{
// BEFORE DELETE LOGIC
}

public void OnAfterDelete(Object[] deletedObjects)
{
// AFTER DELETE LOGIC
}

public void OnUndelete(Object[] restoredObjects){
// AFTER UNDELETE LOGIC
} */
    
    
    public Boolean IsTriggerContext{ get{ return m_isExecuting;}
                                    
                                   }
    
    private void uppdatOperactorContractor(List<Operator_Contractor__c> newList, Map<Id, Operator_Contractor__c> mapOld){
        if(isFirstRun() == true) {
            Set<Id> contractorIds = new Set<Id>();
            Set<String> setOfOperatorContractorCombo = new Set<String>();        
            
            for(Operator_Contractor__c operaCon : newList)
            {
                // keep track of all suppliers that made a connection who paid
                if((mapOld.size()>0
                    && operaCon.Operator__c != null 
                    && operaCon.Contractor__c != null
                    && operaCon.Initial_Payment_Made__c == true
                    //EDIITED BY: JMCGREW FOR CASE 00560783 :: CHANGED THE 'IS ACTIVE' TO 'ACTIVE'
                    //&& operaCon.Is_Active__c == true
                    //EDIT:changed contractor_status1__c to Contractor_status__c per JIRA SFDC-243
                    //&& operaCon.Contractor_Status__c == 'Active'
                    && operaCon.Status__c == 'Active'
                   )               
                   ||(mapOld.size() == 0 && operaCon.Operator__c != null 
                      && operaCon.Contractor__c != null
                      //EDIITED BY: JMCGREW FOR CASE 00560783 :: CHANGED THE 'IS ACTIVE' TO 'ACTIVE'
                      //&& operaCon.Is_Active__c == true
                      //EDIT:changed contractor_status1__c to Contractor_status__c per JIRA SFDC-243
                      //&& operaCon.Contractor_Status__c == 'Active'
                      && operaCon.Status__c == 'Active'
                      && operaCon.Initial_Payment_Made__c == true))
                {
                    contractorIds.add(operaCon.Contractor__c);
                    setOfOperatorContractorCombo.add(operaCon.Operator__c + '' + operaCon.Contractor__c);
                }          
            }
            
            System.debug('Contractor Ids ' + contractorIds);
            System.debug('SOQL&&&&&&&&&&');
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            List<Opportunity> opps = [
                    SELECT Id, StageName, Client_Account__c, AccountId
                    FROM Opportunity
                    WHERE AccountId IN: contractorIds
                    AND ((StageName = 'Closed Lost' AND Campaign_Aged__c = FALSE) OR IsClosed = FALSE)
                    AND Type <> 'Vetify'AND RecordTypeId ='01270000000cebq'
                    AND Result__c != 'Duplicate'
            ];
            
            for(Opportunity opp : opps)
            {
                if (setOfOperatorContractorCombo.contains(opp.Client_Account__c + '' + opp.AccountId)) {
                    
                    opp.StageName='Closed Won'; 
                    opp.Result__c = null;
                    opp.Description = null;
                    oppsToUpdate.add(opp);
                    System.debug(opp);
                }
            }
            
            update oppsToUpdate;      
            setFirstRunFalse();
        }
    }

    private void updateSelfRegistrationStatus (List<Operator_Contractor__c> newList){

        System.debug(' in updateSelfRegistrationStatus ')  ;            
        Set<Id> contractorIds = new Set<Id>();
        Set<Id> operatorIds = new Set<Id>();
        Set <Id> previousIds = new Set<Id>();
        Set<String> setOfOperatorContractorCombo = new Set<String>();        
        if(isFirstRun() == TRUE) {
            for(Operator_Contractor__c operaCon : newList)
            {
                contractorIds.add(operaCon.Contractor__c);
                operatorIds.add(operaCon.Operator__c);
                setOfOperatorContractorCombo.add(operaCon.Operator__c + '' + operaCon.Contractor__c);        
            }
            
            List<Account> acctsToUpdate = new List<Account>(); 
            Map<Id,Account> accountMapToUpdate = new Map<Id,Account>();
            
            System.debug('Contractor Ids ' + contractorIds);
            System.debug('SOQL&&&&&&&&&&');
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            List<Opportunity> opps = [select id, StageName, Client_Account__c, AccountId , Free_Connection__c
                                      from Opportunity 
                                      where AccountId in: contractorIds 
                                      AND Client_Account__c in:operatorIds 
                                      AND type in( 'Registration', 'Reactivation')];
            
            
            SIT_Settings__c SITSettings = SIT_Settings__c.getInstance('General SIT');
            system.debug('SITSettings***' + SITSettings);
            Date commDate = System.today () - Integer.valueOf(SITSettings.Num_Days_For_Commission__c);
            
            System.debug('Opps ' + opps);
            System.debug('SOQL&&&&&&&&&&');
            List<Task> activities = new List<Task>();
            // get all activities for these opps that are within x days of type call
            activities = [select whatid 
                          from Task 
                          where whatid in:opps 
                          AND (Type = 'Call' OR (CallType ='Inbound' OR CallType ='Outbound' )) 
                          AND createdDate > :commDate];
            
            Set<ID> whatids = new Set<ID> ();
            for (Task a: activities) {
                whatids.add(a.whatid);
            }

            List<talkdesk__Talkdesk_Activity__c> tdactivities = new List<talkdesk__Talkdesk_Activity__c>();

            tdactivities = [select talkdesk__Talkdesk_Id__c, talkdesk__Opportunity__c
                            from talkdesk__Talkdesk_Activity__c
                            where talkdesk__Opportunity__c in: opps
                            AND(talkdesk__Type__c = 'Call' Or (talkdesk__Type__c = 'Inbound' OR talkdesk__Type__c = 'Outbound'))
                            AND createdDate > :commDate];

            Set<ID> talkdesk_activity_ids = new Set<ID>();

            for (talkdesk__Talkdesk_Activity__c a: tdactivities) {
                talkdesk_activity_ids.add(a.talkdesk__Opportunity__c);
            }

            for(Opportunity opp : opps)
            {
                if (setOfOperatorContractorCombo.contains(opp.Client_Account__c + '' + opp.AccountId)) {
                    System.debug('match operator/contractor' + opp);
                    System.debug('SOQL&&&&&&&&&&');
                    
                    Account supplier = [select id from Account where id = :opp.AccountId];
                    if (whatids.contains(opp.id) || (talkdesk_activity_ids.contains(opp.id))) {
                        System.debug('setting to SER enabled');
                        opp.Self_Registered_Status__c = 'SER enabled';
                        supplier.Last_Self_Registered_Status__c = 'SER enabled';
                    }

                    else {
                        System.debug('setting to Self-Registered');
                        opp.Self_Registered_Status__c = 'Self-Registered';
                        supplier.Last_Self_Registered_Status__c = 'Self-Registered';
                    }
                    
                    // now see if the opportunity was a 'free connection' and close it if it was
                    // and not wait for payment to come in
                    
                    System.debug('checking for free' + opp);
                    if (opp.Free_Connection__c == true )
                        opp.StageName='Closed Won';
                    
                    oppsToUpdate.add(opp);
                    
                    if(!accountMapToUpdate.containsKey(supplier.Id)) {
                        System.debug('accountMapToUpdate if');
                        accountMapToUpdate.put(supplier.Id, supplier);
                    }      
                    System.debug('accountMapToUpdate = ' + accountMapToUpdate);
                }               
                
                System.debug(opp);
            }
            
            update oppsToUpdate; 
            update accountMapToUpdate.values();  
        }
    }
}