//Created on 2/15/2019 by Parker Brown
//This class is called by the schedulable class '____' and will update the 'Send_Email_#' fields
//to datetime.now() for any MYM or Collection Opty that falls with the datetime range. 
//This will kick off the emailing processes for MYM and Collections.

global class Supplier_MYMColl_SendEmailUpdate_Batch implements Database.Batchable<SObject>, Database.Stateful{
			 
   
    DateTime Dat7 = date.today().adddays(-7);
    DateTime Dat6 = date.today().adddays(-6);
    DateTime DatToday = date.today();
    DateTime DatTmrw = date.today().adddays(1);
    
    
	
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        //Query all Collections/MYM optys with a 'Start Automated Email Send'/'Send Email 1'/'Send Email 2'/'Send Email 3'/'Send Email 4' field 
        //that have a date between today() - 7 and today() - 6 (DateTime data type).
        return Database.getQueryLocator([SELECT Id, Sent_Email_1__c, Sent_Email_2__c, Sent_Email_3__c, Sent_Email_4__c
                                          FROM Opportunity
                                          WHERE (RecordTypeId = '0120g000000YTz4AAG' OR RecordTypeId = '0120g0000009tIpAAI')
                                          AND (StageName = 'Open' OR StageName = 'Attempted' OR StageName = 'In Progress')
                                          AND (
                                              	  (Start_Automated_Email_Send__c >: DatToday AND Start_Automated_Email_Send__c <: DatTmrw)
                                               OR (Start_Collections_Email_Send__c >: DatToday AND Start_Collections_Email_Send__c <: DatTmrw)
                                               OR (Send_Email_1__c >: Dat7 AND Send_Email_1__c <: Dat6) 
                                               OR (Send_Email_2__c >: Dat7 AND Send_Email_2__c <: Dat6) 
                                               OR (Send_Email_3__c >: Dat7 AND Send_Email_3__c <: Dat6))
                                               
                                         ]);
        
        
        			
    }
    
 
        global void execute(Database.BatchableContext BC, List<Opportunity> scope){
            
                List<Opportunity> finalOptys = new List<Opportunity>();
                
                //Loop through each opty from SOQL query and set the 'send_email_#' to DateTime.now(). Then add to finalOptys list
                for(Opportunity o: scope){
                    if(o.Sent_Email_1__c == false){
                        o.Send_Email_1__c = DateTime.now();
                    }
                    else if(o.Sent_Email_1__c == true && o.Sent_Email_2__c == false){
                        o.Send_Email_2__c = DateTime.now();
                    }
                    else if(o.Sent_Email_2__c == true && o.Sent_Email_3__c == false){
                        o.Send_Email_3__c = DateTime.now();
                    }
                    else if(o.Sent_Email_3__c == true && o.Sent_Email_4__c == false){
                        o.Send_Email_4__c = DateTime.now();
                    }
                    
                    finalOptys.add(o);
                }
                
            
                update finalOptys;
                     
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