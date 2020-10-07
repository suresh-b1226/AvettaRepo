/**
*
Created on 1/24/2019 by Parker Brown
This class is called by the schedulable class 'Supplier_SavesDeact_Opty_EligibleUpdate' and will change the 'Eligible for Deactivation' field
to 'true.' This will kick off the round robining and emailing processes for Saves Deactivation.

Edited on 8.14.2019 By Jason McGrew for SF Case 00078636.
    - When class is run, it sets any midterm deactivations 'Result__c' from 'Pending Deactivation' to 'NULL'

*/

global class Supplier_SavesDeact_FieldUpdate_Batch implements Database.Batchable<SObject>, Database.Stateful{

    List<Opportunity> tempOptys  = new List<Opportunity>();
    List<Opportunity> queryOptys = new List<Opportunity>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {

        tempOptys = [
                 SELECT Eligible_for_Deactivation__c, Term_Start_Date__c, Renewal_Date__c, Name, Result__c, RecordTypeId, OwnerId, Account.BillingState, Account.BillingCountry, DeactivationRequestDate__c, CreatedDate, Case__c,Case__r.CreatedDate, Case__r.DeactivationRequestDate__c
                 FROM Opportunity
                 WHERE RecordTypeId               = '01270000000cebpAAA'
                 AND Eligible_for_Deactivation__c = FALSE
                 AND Term_Start_Date__c          != NULL
                 AND Renewal_Date__c             != NULL
                 AND (StageName = 'Open' OR StageName = 'Attempted' OR StageName = 'In Progress')
        ];

        //System.debug(' TEMP OPTY SIZE = ' + tempOptys.size());

        //Tharon wanted 'collections' deactivation requests to cover for up to 89 days after the term start date
        //The 'MYM' and normal deactivation requests will still be 30 days before and after the term start date

        for(Opportunity temp: tempOptys) {

            Date termPlus31 = temp.Term_Start_Date__c + 31;
            Date renMinus31 = temp.Renewal_Date__c - 31;
            Date termMinus31 = temp.Term_Start_Date__c - 31;
            Date termPlus89 = temp.Term_Start_Date__c + 89;

            if (temp.Name == 'Deactivation Request - Collections' && ((Date.today() >= temp.Term_Start_Date__c && Date.today() <= termPlus89)
              || (Date.today() >= termMinus31 && Date.today() <= temp.Term_Start_Date__c)
              || (Date.today() >= renMinus31 && Date.today() <= temp.Renewal_Date__c))) {

              queryOptys.add(temp);

            }
            else if ((temp.Name == 'Deactivation Request - MYM' || temp.Name == 'Deactivation Request') &&
                    ((Date.today() >= temp.Term_Start_Date__c  && Date.today() <= termPlus31)
               || (Date.today() >= termMinus31 && Date.today() <= temp.Term_Start_Date__c)
               || (Date.today() >= renMinus31 && Date.today() <= temp.Renewal_Date__c))) {

                queryOptys.add(temp);

            }
        }

        //Query all 'Retention' optys that have a term end date 31 days away, term start date between 30 days before and 30 days after, or
        //are from MYM/Collections and are either 30 days before term start date or 89 days after -
        //and have 'Eligible for Deactivation' equal to false 
        //(and that are in the proper stage)
        return Database.getQueryLocator ([
                SELECT Eligible_for_Deactivation__c, Term_Start_Date__c, Account.Status__c, Name, RecordTypeId, OwnerId, Result__c, StageName, Account.BillingState, Account.BillingCountry, DeactivationRequestDate__c, CreatedDate, Case__c,Case__r.CreatedDate, Case__r.DeactivationRequestDate__c
                FROM Opportunity
                WHERE Id =: queryOptys
                AND Account.Status__c = 'Active'
        ]);

    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope){

/*        List<Opportunity> finalOptys = new List<Opportunity>();

        //loop through each opty from SOQL query and set the 'eligible_for_deactivation' to true and set the 'Result__c' field to null, then add to list
        for(Opportunity o: scope) {
            o.Eligible_for_Deactivation__c = true;
            o.Result__c = null;
            finalOptys.add(o);
        }

        update finalOptys;

    }*/

            List<Opportunity> finalBig4Optys    = new List<Opportunity>();
            List<Opportunity> finalOutsideOptys = new List<Opportunity>();

            //loop through each opty from SOQL query and set the 'eligible_for_deactivation' to true and set the 'Result__c' field to null, then add to list
            for(Opportunity o: scope) {

                if ( o.Name == 'Deactivation Request'
                        && o.Account.BillingCountry  != 'United States'
                        && o.Account.BillingCountry  != 'US'
                        && o.Account.BillingCountry  != 'USA'
                        && o.Account.BillingCountry  != 'Australia'
                        && o.Account.BillingCountry  != 'AU'
                        && o.Account.BillingCountry  != 'United Kingdom'
                        && o.Account.BillingCountry  != 'UK'
                        && o.Account.BillingCountry  != 'Great Britain'
                        && o.Account.BillingCountry  != 'GB'
                        && o.Account.BillingCountry  != 'Ireland'
                        && o.Account.BillingCountry  != 'IE'
                        && (o.Account.BillingCountry != 'Canada' || (o.Account.BillingCountry == 'Canada' && o.Account.BillingState == 'Quebec'))
                        && (o.Account.BillingCountry != 'CA'     || (o.Account.BillingCountry == 'CA'     && o.Account.BillingState == 'Quebec'))) {

                    o.Midterm_Opportunity__c = true;
                    finalOutsideOptys.add(o);
                    System.debug('********* finalOutsideOptys = ' + finalOutsideOptys);

                } else {

                    o.Eligible_for_Deactivation__c = true;
                    o.Result__c = null;
                    finalBig4Optys.add(o);
                    System.debug('********* finalBig4Optys = ' + finalBig4Optys);
                }

            }

            update finalOutsideOptys;

            if (finalOutsideOptys != null) {

                Supplier_SavesDeact_Opty_Deactivation deactivationClassCall = new Supplier_SavesDeact_Opty_Deactivation();
                deactivationClassCall.SER_Deactivation_Requests_Handler(finalOutsideOptys);
            }
            
            update finalBig4Optys;

            if (finalBig4Optys != null) {

                Supplier_SavesDeact_Opty_RoundRobin rrOptyClass = new Supplier_SavesDeact_Opty_RoundRobin();
                rrOptyClass.Supplier_SavesDeact_Opty_RoundRobin_Handler(finalBig4Optys);
            }
    }


    //The 'finish' method is required and all it does is send an email to whoever called the Batch Job. 
    //The email shows # of successes and errors
    global void finish(Database.BatchableContext BC) {

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