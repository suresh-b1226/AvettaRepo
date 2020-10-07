/**
* Created by JasonMcGrew on 8.13.2019 
* 
* SalesForce Case # 00078636.
*
* This Apex Class will look for Retention-deactivation opportunities outside of the the Big 4 Countries and Quebec.
*
* It will auto-cancel these opportunities if they are eligible for deactivation and within the 60day window that an account can deactivate.
*
* These opportunities will be set to a stage of 'ready for deactivation' or 'ready for deactivation-refund' with a result of 'cancelled'
*
* Process has an automation switch to turn on and off the process listing under Custom Metadata Types - Automation switches, named: Retention_Deactivation_AutoCancelled
*
*/

// Updated by Jeff DeGraw 1.23.2020
// Moved some SOQL queries to be inside the if() block that they are actually needed in.
// This will help the triggers run faster, because the queries are only run if they are
// for sure needed.

public without sharing class Supplier_SavesDeact_Opty_Deactivation  {

    private static Boolean firstRun = true;
    private static Integer runCount = 0;

    //Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug(' ** isFirstRun returned ' + firstRun);
        return firstRun;
    }

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

    private Boolean getRetentionDeactivationAutomationSwitchStatus() {
        Automation_Switch__mdt Retention_Deactivation_AutoCancelled = [
                SELECT On_Off__c
                FROM Automation_Switch__mdt
                WHERE Label = 'Retention Deactivation AutoCancelled'
        ];

        return Retention_Deactivation_AutoCancelled.On_Off__c;
    }

    public void SER_Opty_Midterm_Deactivation_Handler(List<Opportunity> newTrigger) {

        if (!getRetentionDeactivationAutomationSwitchStatus()) return;

        if (Supplier_SavesDeact_Opty_Deactivation.runCount < 5) {

            List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        	String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
            
            if (profileName != 'Bizable User') {
            
            List<Opportunity> midTermOpps = new List<Opportunity>();
            List<Id> optyIds = new List<Id>();

            for (Opportunity opp : newTrigger) {

                if (opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId() &&
                        opp != null &&
                        opp.DeactivationRequestDate__c != null &&
                        opp.StageName == 'Open') {

                    midTermOpps.add(opp);
                }
            }

            System.debug(' ** midTermOpps = ' + midTermOpps);

            if (midTermOpps.size() > 0) {

                for (Opportunity opty : midTermOpps) {

                    optyIds.add(opty.Id);
                }

                List<Opportunity> midtermDeactivations = [
                        SELECT Id, StageName, Result__c, Account.BillingState, Term_Start_Date__c, CreatedDate, AccountId, Eligible_for_Deactivation__c, Account.Status__c, DeactivationRequestDate__c, Renewal_Date__c
                        FROM Opportunity
                        WHERE Name = 'Deactivation Request'
                        AND RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId()
                        AND StageName = 'Open'
                        AND Eligible_for_Deactivation__c = FALSE
                        AND Id = :optyIds
                ];

                System.debug(' ** MidtermDeactivations LIST SIZE = ' + midtermDeactivations.size());

                SIT_Settings__c SITSettings = SIT_Settings__c.getInstance('General SIT');
                Id sitId = SITSettings.Default_Opportunity_Owner__c;

                System.debug(' ** SIT ID = ' + sitId);

                //If the Deactivation Opportunity created date is before the renewal time period, set the stage result to 'Pending Deactivation'
                for (Opportunity midTermOpty : midtermDeactivations) {

                    if (Date.today() < midTermOpty.Renewal_Date__c.addDays(-30) || midTermOpty.Renewal_Date__c.addDays(+30) < Date.today()) {

                        midTermOpty.Eligible_for_Deactivation__c = false;
                        midTermOpty.Result__c = 'Pending Deactivation';
                        midTermOpty.OwnerId = sitId;
                    }
                    System.debug(' ** RESULT = ' + midTermOpty.Result__c);
                    System.debug(' ** DeactivationRequestDate__c = ' + midTermOpty.DeactivationRequestDate__c);

                }
                addRunCount();
                update midtermDeactivations;
            }
            }
        }
    }

    public void SER_Deactivation_Requests_Handler(List<Opportunity> newTrigger){
        System.debug(' ** TRIGGER IS ACTIVATED **SER_Deactivation_Requests_Handler = ' + newTrigger);

        if(!getRetentionDeactivationAutomationSwitchStatus()) return;

        if (Supplier_SavesDeact_Opty_Deactivation.runCount < 10) {

            List<Opportunity> deactOpptys = new List<Opportunity>();
            List<Opportunity> retentionOpps = new List<Opportunity>();
            List<Id> optyIds = new List<Id>();
            List<Id> caseIds = new List<Id>();

            for (Opportunity opp : newTrigger) {

                if (opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId()
                        && opp != null
                        && opp.StageName == 'Open') {

                    retentionOpps.add(opp);
                }

                if (!caseIds.contains(opp.Case__c)) {
                    caseIds.add(opp.Case__c);
                }
            }
            System.debug('retentionOpps = ' + retentionOpps);
            System.debug('caseIds = ' + caseIds);

            List<Case> matchingCases = [
                    SELECT DeactivationRequestDate__c, Id, CreatedDate
                    FROM Case
                    WHERE Id = :caseIds
                    AND Type = 'Deactivation'
                    //AND RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId()
            ];

            System.debug('matchingCases = ' + matchingCases);

            for (Case c : matchingCases) {

                Datetime caseCreatedDatetime = c.CreatedDate;
                Date newCaseCreatedDate = Date.newInstance(caseCreatedDatetime.year(), caseCreatedDatetime.month(), caseCreatedDatetime.day());

                if (c.DeactivationRequestDate__c == null) {
                    c.DeactivationRequestDate__c = newCaseCreatedDate;
                }
            }
            update matchingCases;

            if (retentionOpps.size() > 0) {

                for (Opportunity o : retentionOpps) {

                    optyIds.add(o.Id);
                }
            }

            List<Opportunity> retentionDeactivations = [
                    SELECT Id, StageName, Result__c, Account.BillingState, Term_Start_Date__c, CreatedDate, AccountId, Eligible_for_Deactivation__c, Account.Status__c,
                            DeactivationRequestDate__c, Midterm_Opportunity__c, Account.BillingCountry, Renewal_Date__c
                    FROM Opportunity
                    WHERE Name = 'Deactivation Request'
                    AND RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId()
                    AND StageName = 'Open'
                    AND Id = :optyIds
            ];

            for (Opportunity opp : retentionDeactivations) {

                if (opp.Midterm_Opportunity__c == true) {

                    Datetime originalCreatedDatetime = opp.CreatedDate;
                    Date newCreatedDate = Date.newInstance(originalCreatedDatetime.year(), originalCreatedDatetime.month(), originalCreatedDatetime.day());

                    System.debug(' ** Request Date = ' + opp.DeactivationRequestDate__c);
                    System.debug(' ** newCreatedDate Date = ' + newCreatedDate);

                    if (opp.DeactivationRequestDate__c == Date.today() || opp.DeactivationRequestDate__c == newCreatedDate) {

                        deactOpptys.add(opp);
                    }

                } else if (opp.DeactivationRequestDate__c == Date.today()) {

                    deactOpptys.add(opp);
                }

            }
            System.debug('deactOpptys.size = ' + deactOpptys.size());

            if (deactOpptys.size() > 0) {

                List<Id> AccountIds = new List<Id>();

                for (Opportunity o : deactOpptys) {

                    if (!AccountIds.contains(o.AccountId)) {

                        AccountIds.add(o.AccountId);
                    }
                }
                System.debug(' ** AccountIds = ' + AccountIds);

                List<Account> oppAccounts = [
                        SELECT Name, BillingCountry, BillingState
                        FROM Account
                        WHERE RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId()
                        AND Id = :AccountIds
                ];
                System.debug(' ** OPP ACCOUNTS = ' + oppAccounts);

                for (Opportunity opp : deactOpptys) {

                    Datetime DatetimeMinus30Days = Date.today().addDays(-30);
                    Datetime DatetimePlus30Days = Date.today().addDays(30);

                    Map<Id, Account> acctMap = new Map<Id, Account>();

                    for (Account acc : oppAccounts) {

                        acctMap.put(acc.Id, acc);
                    }
                    System.debug(' ** ACCOUNT MAP = ' + acctMap);

                    SIT_Settings__c SITSettings = SIT_Settings__c.getInstance('General SIT');
                    Id sitId = SITSettings.Default_Opportunity_Owner__c;

                    if (opp.StageName == 'Open') {

                        if (acctMap.get(opp.AccountId).BillingCountry != 'United States'
                                && acctMap.get(opp.AccountId).BillingCountry  != 'US'
                                && acctMap.get(opp.AccountId).BillingCountry  != 'Australia'
                                && acctMap.get(opp.AccountId).BillingCountry  != 'AU'
                                && acctMap.get(opp.AccountId).BillingCountry  != 'United Kingdom'
                                && acctMap.get(opp.AccountId).BillingCountry  != 'UK'
                                && acctMap.get(opp.AccountId).BillingCountry  != 'Great Britain'
                                && acctMap.get(opp.AccountId).BillingCountry  != 'GB'
                                && acctMap.get(opp.AccountId).BillingCountry  != 'Ireland'
                                && acctMap.get(opp.AccountId).BillingCountry  != 'IE'
                                && (acctMap.get(opp.AccountId).BillingCountry != 'Canada' || (acctMap.get(opp.AccountId).BillingCountry == 'Canada' && acctMap.get(opp.AccountId).BillingState == 'Quebec'))
                                && (acctMap.get(opp.AccountId).BillingCountry != 'CA' || (acctMap.get(opp.AccountId).BillingCountry == 'CA' && acctMap.get(opp.AccountId).BillingState == 'Quebec'))) {

                            System.debug(' ** OPPS = ' + opp);
                            System.debug(' ** ACCOUNT BILLING COUNTRY = ' + opp.Account.BillingCountry);

                            if (opp.Renewal_Date__c >= DatetimeMinus30Days && opp.Renewal_Date__c <= DatetimePlus30Days) {

                                opp.StageName = 'Ready For Deactivation';
                                opp.Result__c = 'Cancelled';
                                opp.OwnerId = sitId;
                            }

                            List<Zuora__Payment__c> zuoraAccountPayments = [
                                    SELECT Id, Zuora__Account__c, Zuora__CreatedDate__c, Zuora__Invoice__c, Zuora__Status__c, Zuora__SubmittedOn__c
                                    FROM Zuora__Payment__c
                                    WHERE Zuora__Account__c = :AccountIds
                            ];
                            System.debug(' ** Zuora__Payment__c = ' + zuoraAccountPayments);

                            for (Zuora__Payment__c accInvoicePayment : zuoraAccountPayments) {

                                Date renewalDatePlus90Days  = opp.Renewal_Date__c.addDays(90);
                                Date renewalDateMinus30Days = opp.Renewal_Date__c.addDays(-30);

                                if (opp.Renewal_Date__c >= DatetimeMinus30Days && opp.Renewal_Date__c <= DatetimePlus30Days) {

                                    //Determine if a payment status is "processed" or is "processing" within this 60day window. If so add it to the refundOptyList
                                    if (accInvoicePayment.Zuora__Status__c == 'Processed' || accInvoicePayment.Zuora__Status__c == 'Processing') {

                                        if (accInvoicePayment.Zuora__SubmittedOn__c > renewalDateMinus30Days && accInvoicePayment.Zuora__SubmittedOn__c < renewalDatePlus90Days) {

                                            opp.StageName = 'Ready For Deactivation - Refund';
                                            opp.Result__c = 'Cancelled';
                                            opp.OwnerId = sitId;
                                        }
                                    }
                                }
                            }
                        }
                    }
/*                    if (opp.Midterm_Opportunity__c == true) {
                        update opp;
                    }*/
                }
                addRunCount();
                update deactOpptys;
            }
        }
    }
}