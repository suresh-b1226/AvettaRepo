/**
* Created by: Jason McGrew
* Date: 10.2.2019
*
* Salesforce Case # 01219200.
*
* This class is called by 'Supplier_SavesDeact_Opty_Batch_Scheduled' to run daily. It will query for all deactivation optys
* that have had 1-4 of the follow-up emails sent. If the opty hasn't been closed  62 days after the 'send_email_1' was
* sent the opty will auto stage to 'Ready for Deactivation' or 'Ready for Deactivation - Refund'
*
*
*/

global class Supplier_SavesDeact_Opty_Deact_Batch  implements Database.Batchable<SObject> {

    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query =  'SELECT Id, RecordTypeId, StageName, Result__c, Account.BillingState, Term_Start_Date__c, CreatedDate, AccountId, Eligible_for_Deactivation__c, Account.Status__c, Send_Email_1__c, Renewal_Date__c ' +
                        'FROM Opportunity ' +
                        'WHERE Name = \'Deactivation Request\' ' +
                            'AND Eligible_for_Deactivation__c = true ' +
                            'AND Result__c                    = null ' +
                            'AND Send_Email_1__c             != null ' +
                            'AND Send_Email_2__c             != null ' +
                            'AND Send_Email_3__c             != null ' +
                            'AND Send_Email_4__c             != null ' +
                            'AND StageName IN ( \'Open\' , \'Attempted\' , \'In Progress\' , \'Commit\' ) ' ;

        return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext bc, List<Opportunity> deactivationOptys){

        List<Id> AccountIds = new List<Id>();
        List<Opportunity> optysToDeactivate = new List<Opportunity>();

        for (Opportunity opp : deactivationOptys) {
            if (opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId()) {
                optysToDeactivate.add(opp);
            }
            if (!AccountIds.contains(opp.AccountId)) {
                AccountIds.add(opp.AccountId);
            }
        }
        List<Zuora__Payment__c> zuoraAccountPayments = [
                SELECT Id, Zuora__Account__c, Zuora__CreatedDate__c, Zuora__Invoice__c, Zuora__Status__c, Zuora__SubmittedOn__c
                FROM Zuora__Payment__c
                WHERE Zuora__Account__c = :AccountIds
        ];

        Map<Id, Zuora__Payment__c> paymentMap = new Map<Id, Zuora__Payment__c>();

        for (Zuora__Payment__c p : zuoraAccountPayments) {

            paymentMap.put(p.Zuora__Account__c, p);
        }

        for(Opportunity o : optysToDeactivate) {

            Date renewalDatePlus90Days  = o.Renewal_Date__c.addDays(90);
            Date renewalDateMinus30Days = o.Renewal_Date__c.addDays(-30);

            if (Date.today() > o.Send_Email_1__c.addDays(61)) {

                if (paymentMap.get(o.AccountId).Zuora__Status__c == 'Processed' || paymentMap.get(o.AccountId).Zuora__Status__c == 'Processing') {

                    if (paymentMap.get(o.AccountId).Zuora__SubmittedOn__c > renewalDateMinus30Days && paymentMap.get(o.AccountId).Zuora__SubmittedOn__c < renewalDatePlus90Days) {

                        o.StageName = 'Ready for Deactivation - Refund';
                        o.Result__c = 'Cancelled';

                    } else {

                        o.StageName = 'Ready for Deactivation';
                        o.Result__c = 'Cancelled';

                    }
                }
            }
            update optysToDeactivate;
        }
    }    

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }  
}