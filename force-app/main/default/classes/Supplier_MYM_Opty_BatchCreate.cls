//Created on 12/18/2018 by Parker Brown
//This class is called by 'Supplier_MYM_Opty_Creation' class (run daily). 
//It creates MYM opportunities for any account with a renewal date 60 days from today(). 
//Each opportunity is round robined to the appropriate rep
//Once the opportunities are created, the MYM email automation starts



global class Supplier_MYM_Opty_BatchCreate implements Database.Batchable<SObject>, Database.Stateful{
			 
    Date Dat60 = date.today().adddays(60);
    Date td = system.date.today();
    Integer numberOfDays = Date.daysInMonth(td.year(), td.month());
	Date lastDayOfMonth = Date.newInstance(td.year(), td.month(), numberOfDays);
    List<Opportunity> mymOptys = new List<Opportunity>();
    List<Account> finalAccts = new List<Account>();
    List<Id> subAccts = new List<Id>();
    List<Id> dupAccts = new List<Id>();
    List<Operator_Contractor__c> jllOpCon = new List<Operator_Contractor__c>();
    List<Id> tempAccts = new List<Id>();
    List<Id> goodContractors = new List<Id>();
    List<Id> badContractors = new List<Id>();
    List<Id> excludeList = new List<Id>();
   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Query any subscription that is active and has a renewal date that is 60 days away.
        List<Zuora__Subscription__c> eligibleSubs = [SELECT Id, Zuora__NextRenewalDate__c, Zuora__Account__c 
                                        			FROM Zuora__Subscription__c 
                                        			WHERE Zuora__NextRenewalDate__c =: Dat60  AND Zuora__Status__c = 'Active'];
        
        for(Zuora__Subscription__c sub : eligibleSubs){
            subAccts.add(sub.Zuora__Account__c);
        }
        
        
        //This query covers for duplicate MYM optys for each account in the scope. If opty is in stage 'Closed Lost,' still create an opty.
        List<Opportunity> duplicateMYMOptys = [ SELECT Id, AccountId  
                                               FROM Opportunity 
                                               WHERE AccountId =: subAccts 
                                               AND RecordTypeId = '0120g000000YTz4AAG'
                                               AND StageName != 'Closed Lost' 
                                               AND StageName != 'Unresponsive'];
        for(Opportunity dupes : duplicateMYMOptys){
            dupAccts.add(dupes.AccountId);
        }
        
      
        //Query all -active- accounts that match the accounts with the subscriptions in the query above^. These will be held in 'scope'
        return Database.getQueryLocator([SELECT Id, Name, Status__c, BillingCountry, CurrencyIsoCode, Primary_Contact__c, Supplier_is_also_a_client__c
                                         FROM Account
                                         WHERE Id =: subAccts
                                         AND Id !=: dupAccts
                                         AND Status__c = 'Active' 
                                         AND (BillingCountry = 'United States' OR BillingCountry = 'US' OR BillingCountry = 'United Kingdom' OR BillingCountry = 'GB' OR BillingCountry = 'Canada' OR BillingCountry = 'CA' OR BillingCountry = 'Australia' OR BillingCountry = 'AU') 
                                         AND BillingCity != 'Quebec'
                                         AND Supplier_is_also_a_client__c = false
                                         
                                         ]);
        
        			
    }
    
     
    global void execute(Database.BatchableContext BC, List<SObject> scope){
			
        	
        
        	//SOQL query to retrieve all blacklisted accounts (will pass this info to be used in the class)
            List<MYM_Blacklisted_Account__c> blacklistedAccts = [ SELECT Id, Name, Account__c
                                                                   FROM MYM_Blacklisted_Account__c
                                                                  ];
               
            for(MYM_Blacklisted_Account__c blackAcct : blacklistedAccts){
            	excludeList.add(blackAcct.Account__c);    
            }
            System.debug('excludeList >>>>>>>> ' + excludeList);
           
            //SOQL query to retrieve all VALID Operator_Contractor__c account Ids
            List<Operator_Contractor__c> goodOperContractors = [ SELECT Contractor__c, Contractor_Status__c, Operator__c
                                                   	 FROM Operator_Contractor__C
                                                   	 WHERE Contractor__c =: scope
                                                     AND Operator__c !=: excludeList
                                                     AND Status__c = 'Active'
                                                     
                                                   ];
        	//place the valid contractor account Ids in a list
            for(Operator_Contractor__c goodOper : goodOperContractors){
                if(!goodContractors.contains(goodOper.Contractor__c)){
                	goodContractors.add(goodOper.Contractor__c);
                }
            }
        	System.debug('goodContractors >>>>>>>>> ' + goodContractors);
        	//SOQL query to retrieve all blacklisted Operator_Contractor__c account Ids 
            List<Operator_Contractor__c> badOperContractors = [ SELECT Contractor__c, Contractor_Status__c, Operator__c
                                                   	 FROM Operator_Contractor__C
                                                   	 WHERE Contractor__c =: scope
                                                     AND Operator__c =: excludeList
                                                     AND Status__c = 'Active'
                                                     
                                                   ];
        	//put the blacklisted contractor account Ids in a list
            for(Operator_Contractor__c badOper : badOperContractors){
                if(!badContractors.contains(badOper.Contractor__c))
                    badContractors.add(badOper.Contractor__c);
                }
			System.debug('badContractors >>>>>>>> ' + badContractors);
           
        
        
        	//SOQL query to retrieve all Account names that contain 'Jll North America'
           List<Account> jllIds = [ SELECT Id
                                  	FROM Account
                                  	WHERE Name LIKE '%JLL North America%'
                                  ];
        	
        	//Put the 'Jll north america' accounts in a list
            for(Operator_Contractor__c oc : badOperContractors) {
                for(Account jll : jllIds){
                    if(oc.Operator__c == jll.Id){
                        jllOpCon.add(oc);
                    }
                }
            }
            

			
            List<Account> validAccts = [ SELECT Id, currencyIsoCode, Primary_Contact__c 
                                               FROM Account 
                                               WHERE ((Id =: goodContractors
                                        	   OR Id =: scope)
                                        	   AND Id !=: badContractors) OR (Id =: goodContractors)
                                        	   
                                             ];
        for(Account fAcct : validAccts){
            if(finalAccts.contains(fAcct) == False){
                finalAccts.add(fAcct);
            }
        }
            
        
        
        //Loop through each account and create an MYM opportunity
        for(Account acct : finalAccts){
                        //create an opportunity object
                        Opportunity opp = new Opportunity();
                        
                        //Populate the required/necessary Opportunity fields
                        opp.RecordTypeId = '0120g000000YTz4AAG'; 
                        opp.AccountId = acct.Id;
                        opp.CloseDate = lastDayOfMonth;
                        opp.StageName = 'Open';
                        opp.CurrencyIsoCode = acct.CurrencyIsoCode;
            			opp.Primary_Contact__c = acct.Primary_Contact__c;
            
                        
                        //Set the Opportunity Name to 'MYM (JLL)' if there is an operator name containing the string 'JLL North America' (heavy lifting for this is done in SOQL in trigger)
                        for(Operator_Contractor__c jll: jllOpCon){
                            if(jll.Contractor__c == acct.Id) {
                                opp.Name = 'MYM (JLL)';
                                break;
                            }
                            else {
                                opp.Name = 'MYM';
                            }
                        }
                                
                          
                        
                        //Cover for any fields that did not populate (this helps avoid the error of 'Required fields missing')    
                        if(opp.Name == null){
                            opp.Name = 'MYM';
                        }    	
                        if(opp.Renewal_Date__c == null){
                           opp.Renewal_Date__c = Dat60; 
                        }
                        
                        //add all new opportunities to the mymOptys
                        
            			mymOptys.add(opp);

                    }
            
            //Insert the opportunities
            insert mymOptys;
        
        	//Clear all lists
        	finalAccts.clear();
        	excludeList.clear();
        	goodContractors.clear();
        	badContractors.clear();
        	jllOpCon.clear();
        	mymOptys.clear();
          }
              
   
    //The 'finish' method is required and all it does is send an email to whoever called the Batch Job. 
    //The email shows # of successes and errors
    global void finish(Database.BatchableContext BC){
       
       // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
       // Query the AsyncApexJob object to retrieve the current job's information.
       /*AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
          				TotalJobItems, CreatedBy.Email
          				FROM AsyncApexJob WHERE Id =
          				:BC.getJobId()];
       
       // Send an email to the Apex job's submitter notifying of job completion.
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Apex Sharing Recalculation ' + a.Status);
       mail.setPlainTextBody
       ('The batch Apex job processed ' + a.TotalJobItems +
       ' batches with '+ a.NumberOfErrors + ' failures.');
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/

    }
}