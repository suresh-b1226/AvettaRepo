//Created on 4/4/2019 by Parker Brown
//Batch Apex that runs daily and looks for any Invoice of type 'ClientActivation' or 'ClientRenewal' and is 7 days past due. 
//A Client Collection opty is created for each account connected to those invoices. Round robin functionality is built in to this class.


global class Client_Billing_CollectOpty_BatchCreate implements Database.Batchable<SObject>, Database.Stateful{
	
    Date Dat7 = date.today().adddays(-30);
    Date td = system.date.today();
    Integer numberOfDays = Date.daysInMonth(td.year(), td.month());
	Date lastDayOfMonth = Date.newInstance(td.year(), td.month(), numberOfDays);
    List<Opportunity> clientCollectOptys = new List<Opportunity>();
    List<Zuora__ZInvoice__c> validInvoices = new List<Zuora__ZInvoice__c>();
    List<Id> invAccts = new List<Id>();
    List<Id> dupAccts = new List<Id>();
    Integer rr = 0;
    List<OpportunityContactRole> newContactRoleList = new List<OpportunityContactRole>();
   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Query any Invoice that has a status of 'Posted' and where today is 7 days after the due date. Also has to be ClientRenewal or ClientActivation type.
        List<Zuora__ZInvoice__c> eligibleInvs = [SELECT Id, Zuora__DueDate__c, Zuora__Account__c 
                                        			 FROM Zuora__ZInvoice__c 
                                        			 WHERE Zuora__DueDate__c =: Dat7
                                                     AND Zuora__Status__c = 'Posted'
                                                	 AND (PICSInvoiceTag__c = 'ClientActivation' OR PICSInvoiceTag__C = 'ClientRenewal')];
        for(Zuora__ZInvoice__c inv : eligibleInvs){
            validInvoices.add(inv);
        }
        
        for(Zuora__ZInvoice__c inv : eligibleInvs){
            invAccts.add(inv.Zuora__Account__c);
        }
        
        //This query covers for duplicate Client Collection optys for each account in the scope. 
        //If opty is in stage 'Paid' or 'Written Off,' still create an opty.
        List<Opportunity> dupClientCollectOptys = [ SELECT Id, AccountId  
                                               FROM Opportunity 
                                               WHERE AccountId =: invAccts 
                                               AND RecordTypeId =: Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client Collection').getRecordTypeId() 
                                               AND (StageName != 'Paid' OR StageName != 'Written Off') 
                                               ];
        for(Opportunity dupes : dupClientCollectOptys){
            dupAccts.add(dupes.AccountId);
        }
        
      
        //Query all -active- 'Operator' accounts that match the accounts with the Invoices in the query above^. These will be held in 'scope'
        return Database.getQueryLocator([SELECT Id, Name, Status__c, BillingCountry, CurrencyIsoCode, Primary_Contact__c, Client_Billing_Notes__c, AP_Contact__c
                                         FROM Account
                                         WHERE Id =: invAccts
                                         AND Id !=: dupAccts
                                         AND Status__c = 'Active' 
                                         AND RecordTypeId =:  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId()
                                         ]);
        
        			
    }
    
     
    global void execute(Database.BatchableContext BC, List<Account> scope){
		//SOQL query to get the users with a role of 'Billing' to assign opty owner
		/*
        List<User> billingUsers = [SELECT Id, Name, Billing_Invoice_Owner__c, UserRole.Name
                                   FROM User
                                   WHERE UserRole.Name = 'Billing'
                                   AND Billing_Collection_Owner__c = true
                                   AND IsActive = true
                                  ];
        */
        //SOQL query to get the user in the supplierManager role. Will be assigned as owner if there are 0 'billingUsers'
        User avettaSales = [SELECT Id, Name
                                      FROM User
                                      WHERE Name = 'Avetta Sales'
                                      AND IsActive = true
                                      LIMIT 1];
        
        //SOQL query to get all Billing contacts on the account
        List<Contact> apContacts = [SELECT Id, Name, AccountId
                                    FROM Contact
                                    WHERE AccountId =: scope
                                    AND AP_Contact__c = true
                                   ];
        
        //Loop through each account and create an Client Collection opportunity
        for(Account acct : scope){
            //create an opportunity object
            Opportunity opp = new Opportunity();
            
            //Populate the required/necessary Opportunity fields
            /*
            if(billingUsers.size() > 0){
				opp.OwnerId = billingUsers[rr].Id;
            }
			*/
            opp.OwnerId = avettaSales.Id;
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client Collection').getRecordTypeId();
            opp.AccountId = acct.Id;
            opp.CloseDate = lastDayOfMonth;
            opp.StageName = 'Open';
            opp.CurrencyIsoCode = acct.CurrencyIsoCode;
            opp.Primary_Contact__c = acct.Primary_Contact__c;
            opp.Name = 'Client Collection';
            opp.Client_Billing_Notes__c = acct.Client_Billing_Notes__c;
            for(Zuora__ZInvoice__c inv: validInvoices){
                if(inv.Zuora__Account__c == acct.Id){
                    opp.Invoice__c = inv.Id;
                }
            }
            			
            //Make sure round robin variable is <= the number of users.
            //increment round robin variable
            /*
            if(rr == billingUsers.size() - 1){
                rr = 0;
            }
            else{
                rr = rr + 1;
            }  
*/
                        
            //add all new opportunities to the clientCollectOptys
            clientCollectOptys.add(opp);

       }
        	 

        //Insert the opportunities
        insert clientCollectOptys;
        
        //Create a 'billing contact' role for each ap contact on the account and add to the opportunity
        for(Opportunity opp: clientCollectOptys){
            for(Contact apContact: apContacts){
                if(apContact.AccountId == opp.AccountId){
                    newContactRoleList.add(new OpportunityContactRole(ContactId=apContact.Id,OpportunityId=opp.Id,Role='Billing Contact'));
                }
        	}
        }
        
        //insert the contact roles
        insert newContactRoleList;
        
        //Clear all lists
        clientCollectOptys.clear();
        newContactRoleList.clear();
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