//Created on 2/15/2019 by Parker Brown
//This class is called by the schedulable class 'Supplier_All_SendEmail_FieldUpdate' and will update the 'Send_Email_#' fields
//to datetime.now() for any MYM, Collection, Saves Downgrade, or Saves Deactivation Opty that falls with the datetime range. 
//This will kick off the emailing processes for MYM, Collections, Saves Downgrade, and Saves Deactivation.
//
//Edited 6/10/2019 by Parker Brown -> removed Saves Downgrade email sending from this class. Because it sends every 3 days, it is incompatible with this class.
//								   -> Time-based workflow rules now control the automated email sending for Saves Downgrades
//Edited 6/25/2019 by Parker Brown -> added Saves Downgrade email sending back to this class. Workflow Rules were running into SOQL limit errors which prevented emails from sending.

global class Supplier_All_SendEmailUpdate_Batch implements Database.Batchable<SObject>, Database.Stateful{
			 
   
    DateTime Dat7 = date.today().adddays(-7);
    DateTime Dat6 = date.today().adddays(-6);
    DateTime Dat5 = date.today().adddays(-5);
    DateTime Dat4 = date.today().adddays(-4);
    DateTime Dat3 = date.today().adddays(-3);
    DateTime Dat2 = date.today().adddays(-2);
    @TestVisible static DateTime DatToday = datetime.newInstance(System.today(), time.newInstance(0,0,0,0));
    DateTime DatTmrw = date.today().adddays(1);
    @TestVisible static String dayofweek = DatToday.format('E');

    global Database.QueryLocator start(Database.BatchableContext BC)

    {
        if(dayofweek == 'Mon'){
    		return Database.getQueryLocator([SELECT Id, Sent_Email_1__c, Sent_Email_2__c, Sent_Email_3__c, Sent_Email_4__c
                                          FROM Opportunity
                                          WHERE (
                                              //Saves Downgrade Criteria
                                              (RecordType.Name = 'Saves Downgrade')
                                              /*(RecordTypeId = '0120g000000EBgpAAG')*/
                           				  AND (StageName = 'Open' OR StageName = 'Attempted' OR StageName = 'In Progress')  
                           				  AND (
                                              	   (Start_Automated_Email_Send__c >: DatToday AND Start_Automated_Email_Send__c <: DatTmrw) 
                                                OR (Send_Email_1__c >: Dat3 AND Send_Email_1__c <: Dat2) 
                                                OR (Send_Email_2__c >: Dat3 AND Send_Email_2__c <: Dat2) 
                                                OR (Send_Email_3__c >: Dat3 AND Send_Email_3__c <: Dat2)
                                              	OR (Send_Email_1__c >: Dat5 AND Send_Email_1__c <: Dat4) 
                                                OR (Send_Email_2__c >: Dat5 AND Send_Email_2__c <: Dat4) 
                                                OR (Send_Email_3__c >: Dat5 AND Send_Email_3__c <: Dat4)
                                          	    OR (Send_Email_1__c >: Dat6 AND Send_Email_1__c <: Dat5)
                                          		OR (Send_Email_2__c >: Dat6 AND Send_Email_2__c <: Dat5)
                                          		OR (Send_Email_3__c >: Dat6 AND Send_Email_3__c <: Dat5)))
                                         OR(
                                              //Collections and MYM Criteria
                                                  (RecordType.Name = 'Collections' OR RecordType.Name = 'MYM')
                                              /*(RecordTypeId = '0120g000000YTz4AAG'
                                                 OR RecordTypeId = '0120g0000009tIpAAI')*/
                                          AND (StageName = 'Open' OR StageName = 'Attempted' OR StageName = 'In Progress')
                                          AND (
                                              	  (Start_Automated_Email_Send__c >: DatToday AND Start_Automated_Email_Send__c <: DatTmrw)
                                               OR (Start_Collections_Email_Send__c >: DatToday AND Start_Collections_Email_Send__c <: DatTmrw)
                                               OR (Send_Email_1__c >: Dat7 AND Send_Email_1__c <: Dat6) 
                                               OR (Send_Email_2__c >: Dat7 AND Send_Email_2__c <: Dat6) 
                                               OR (Send_Email_3__c >: Dat7 AND Send_Email_3__c <: Dat6)))
                                         OR(
                                             	//Retention Criteria
                                                  (RecordType.Name = 'Retention')
                                                /*(RecordTypeId = '01270000000cebpAAA')*/
                                         	AND (StageName = 'Open' OR StageName = 'Attempted' OR StageName = 'In Progress')
                                            AND (
                                                  (Start_Saves_Deactivation_Email_Send__c >: DatToday AND Start_Saves_Deactivation_Email_Send__c <: DatTmrw)
                                               OR (Send_Email_1__c >: Dat7 AND Send_Email_1__c <: Dat6) 
                                               OR (Send_Email_2__c >: Dat7 AND Send_Email_2__c <: Dat6) 
                                               OR (Send_Email_3__c >: Dat7 AND Send_Email_3__c <: Dat6)))
                                               
                                         ]);
        }
        else{                 
        //Query all Collections/MYM/SavesDeactivation optys with a 'Start Automated Email Send'/'Send Email 1'/'Send Email 2'/'Send Email 3'/'Send Email 4' field 
        //that has a date 7 days prior to today (between today() - 7 and today() - 6). 
        return Database.getQueryLocator([SELECT Id, Sent_Email_1__c, Sent_Email_2__c, Sent_Email_3__c, Sent_Email_4__c
                                          FROM Opportunity
                                          WHERE (
                                              //Saves Downgrade Criteria
                                                (RecordType.Name = 'Saves Downgrade')
                                              /*(RecordTypeId = '0120g000000EBgpAAG')*/
                           				  AND (StageName = 'Open' OR StageName = 'Attempted' OR StageName = 'In Progress')  
                           				  AND (
                                              	   (Start_Automated_Email_Send__c >: DatToday AND Start_Automated_Email_Send__c <: DatTmrw) 
                                                OR (Send_Email_1__c >: Dat3 AND Send_Email_1__c <: Dat2) 
                                                OR (Send_Email_2__c >: Dat3 AND Send_Email_2__c <: Dat2) 
                                                OR (Send_Email_3__c >: Dat3 AND Send_Email_3__c <: Dat2)))
                                         OR(
                                              //Collections and MYM Criteria
                                                (RecordType.Name = 'Collections' OR RecordType.Name = 'MYM')
                                              /*(RecordTypeId = '0120g000000YTz4AAG'
                                                 OR RecordTypeId = '0120g0000009tIpAAI')*/
                                          AND (StageName = 'Open' OR StageName = 'Attempted' OR StageName = 'In Progress')
                                          AND (
                                              	  (Start_Automated_Email_Send__c >: DatToday AND Start_Automated_Email_Send__c <: DatTmrw)
                                               OR (Start_Collections_Email_Send__c >: DatToday AND Start_Collections_Email_Send__c <: DatTmrw)
                                               OR (Send_Email_1__c >: Dat7 AND Send_Email_1__c <: Dat6) 
                                               OR (Send_Email_2__c >: Dat7 AND Send_Email_2__c <: Dat6) 
                                               OR (Send_Email_3__c >: Dat7 AND Send_Email_3__c <: Dat6)))
                                         OR(
                                             //Retention Criteria
                                             (RecordType.Name = 'Retention')
                                             /*(RecordTypeId = '01270000000cebpAAA')*/
                                         	AND (StageName = 'Open' OR StageName = 'Attempted' OR StageName = 'In Progress')
                                            AND (
                                                  (Start_Saves_Deactivation_Email_Send__c >: DatToday AND Start_Saves_Deactivation_Email_Send__c <: DatTmrw)
                                               OR (Send_Email_1__c >: Dat7 AND Send_Email_1__c <: Dat6) 
                                               OR (Send_Email_2__c >: Dat7 AND Send_Email_2__c <: Dat6) 
                                               OR (Send_Email_3__c >: Dat7 AND Send_Email_3__c <: Dat6)))
                                               
                                         ]);
        
        
        
        }	
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