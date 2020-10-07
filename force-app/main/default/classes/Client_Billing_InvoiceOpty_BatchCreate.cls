//Created on 4/4/2019 by Parker Brown
//Batch Apex that is run daily and looks for any -active- Subscriptions with a 'Subscription end date' of today and creates a Client Invoice opty for the accounts that are
//connected to those subscriptions. Round robin functionality is built in to this class.



global class Client_Billing_InvoiceOpty_BatchCreate implements Database.Batchable<SObject>, Database.Stateful{
			 
    Date td = system.date.today();
    Integer numberOfDays = Date.daysInMonth(td.year(), td.month());
	Date lastDayOfMonth = Date.newInstance(td.year(), td.month(), numberOfDays);
    List<Opportunity> clientInvoiceOptys = new List<Opportunity>();
    List<Id> subAccts = new List<Id>();
    List<Id> dupAccts = new List<Id>();
    Integer rr = 0;
   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Query any subscription that is active and has a 'subscription end date' that is 30 days away.
        List<Zuora__Subscription__c> eligibleSubs = [SELECT Id, Zuora__SubscriptionEndDate__c, Zuora__Account__c 
                                        			 FROM Zuora__Subscription__c 
                                        			 WHERE Zuora__SubscriptionEndDate__c =: td  
                                                     AND Zuora__Status__c = 'Active'];
        
        for(Zuora__Subscription__c sub : eligibleSubs){
            subAccts.add(sub.Zuora__Account__c);
        }
        
        
        //This query covers for duplicate Client Invoice optys for each account in the scope. 
        //If opty is in stage 'Closed,' still create an opty.
        List<Opportunity> dupClientInvoiceOptys = [ SELECT Id, AccountId  
                                               FROM Opportunity 
                                               WHERE AccountId =: subAccts 
                                               AND RecordTypeId =:  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client Invoice').getRecordTypeId()
                                               AND StageName != 'Closed' 
                                               ];
        for(Opportunity dupes : dupClientInvoiceOptys){
            dupAccts.add(dupes.AccountId);
        }
        
      
        //Query all -active- 'Operator' accounts that match the accounts with the subscriptions in the query above^. These will be held in 'scope'
        return Database.getQueryLocator([SELECT Id, Name, Status__c, BillingCountry, CurrencyIsoCode, Primary_Contact__c, Client_Billing_Notes__c
                                         FROM Account
                                         WHERE Id =: subAccts
                                         AND Id !=: dupAccts
                                         AND Status__c = 'Active' 
                                         AND RecordTypeId =:  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId()
                                         ]);
        
        			
    }
    
     
    global void execute(Database.BatchableContext BC, List<Account> scope){
		//Loop through users with 'Billing' role to check for the user with 'Billing Invoice Owner' = true
		List<User> billingUsers = [SELECT Id, Name, Billing_Invoice_Owner__c, UserRole.Name
                                   FROM User
                                   WHERE UserRole.Name = 'Billing'
                                   AND Billing_Invoice_Owner__c = true
                                   AND IsActive = true
                                  ];
        
        //SOQL query to get the user in the supplierManager role. Will be assigned as owner if there are 0 'billingUsers'
        User supplierManager = [SELECT Id, Name, UserRole.Name
                                      FROM User
                                      WHERE UserRole.Name = 'Supplier Management'
                                      AND IsActive = true
                                      LIMIT 1];
        
        //Loop through each account and create an Client Invoice opportunity
        for(Account acct : scope){
            //create an opportunity object
            Opportunity opp = new Opportunity();
            
            //Populate the required/necessary Opportunity fields
            if(billingUsers.size() > 0){
                opp.OwnerId = billingUsers[rr].Id;
            }
            else{
                opp.OwnerId = supplierManager.Id;
            }
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client Invoice').getRecordTypeId(); 
            opp.AccountId = acct.Id;
            opp.CloseDate = lastDayOfMonth;
            opp.StageName = 'Open';
            opp.CurrencyIsoCode = acct.CurrencyIsoCode;
            opp.Primary_Contact__c = acct.Primary_Contact__c;
            opp.Name = 'Client Renewal Alert';
            opp.Client_Billing_Notes__c = acct.Client_Billing_Notes__c;
            
            //Make sure round robin variable is <= the number of users.
            //increment round robin variable
            if(rr == billingUsers.size() - 1){
                rr = 0;
            }
            else{
                rr = rr + 1;
            }
            
            //add all new opportunities to the clientInvoiceOptys
            clientInvoiceOptys.add(opp);

            }
            
        //Insert the opportunities
        insert clientInvoiceOptys;
        
        //Clear all lists
        clientInvoiceOptys.clear();

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