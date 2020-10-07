/**
 * Created by brett on 3/17/18.
 */

public with sharing class API_CONNECT_Invoice_TriggerHandler {


    private boolean m_isExecuting = false;

    private Id[] getListOfIds(Zuora__ZInvoice__c[] invoices) {
        System.debug('START: API_CONNECT_Invoice_TriggerHandler.getListOfIds');
        Id[] ids = new List<Id>();

        for (Zuora__ZInvoice__c invoice : invoices) {

            if (invoice.Zuora__Account__c != null) {
                ids.add(invoice.Zuora__Account__c);
            }
        }

        System.debug('END: API_CONNECT_Invoice_TriggerHandler.getListOfIds');
        return ids;
    }

    private Account[] setLastInvoiceDateOnAccounts(Zuora__ZInvoice__c[] invoices, Account[] accounts) {
        System.debug('START: API_CONNECT_Invoice_TriggerHandler.setLastInvoiceDateOnAccounts');

        for (Account account : accounts) {
            if (account.Last_Invoice_Date__c == null || account.Last_Invoice_Date__c < invoices[0].CreatedDate) {
                account.Last_Invoice_Date__c = invoices[0].CreatedDate;
            }
        }

        System.debug('END: API_CONNECT_Invoice_TriggerHandler.setLastInvoiceDateOnAccounts');

        return accounts;
    }


    public API_CONNECT_Invoice_TriggerHandler(boolean isExecuting) {
        m_isExecuting = isExecuting;
    }

//    public void OnBeforeInsert(Zuora__ZInvoice__c[] newObjects) {
//        // EXECUTE BEFORE INSERT LOGIC
//    }

    public void OnAfterInsert(Zuora__ZInvoice__c[] invoices) {
        // EXECUTE AFTER INSERT LOGIC
        System.debug('START: API_CONNECT_Invoice_TriggerHandler.OnAfterInsert');

        Id[] accountIds = getListOfIds(invoices);

        Account[] accounts = [
                SELECT
                        Id,
                        Last_Invoice_Date__c
                FROM
                        Account
                WHERE
                        Id in :accountIds
        ];

        Account[] updatedAccounts = setLastInvoiceDateOnAccounts(invoices, accounts);

        update updatedAccounts;
        System.debug('START: API_CONNECT_Invoice_TriggerHandler.OnAfterInsert');
    }
//
//    public void OnBeforeUpdate(Zuora__ZInvoice__c[] oldObjects, Zuora__ZInvoice__c[] updatedObjects, Map<Id, Zuora__ZInvoice__c> MapObjectMap) {
//        // BEFORE UPDATE LOGIC
//    }

    public void OnAfterUpdate(Zuora__ZInvoice__c[] oldInvoices, Zuora__ZInvoice__c[] updatedInvoices, Map<Id, Zuora__ZInvoice__c> MapObjectMap) {
        // AFTER UPDATE LOGIC
        System.debug('START: API_CONNECT_Invoice_TriggerHandler.OnAfterUpdate');

        Id[] contractorIds = getListOfIds(updatedInvoices);

        Operator_Contractor__c[] operatorContractorsSet = [
                SELECT
                        Id,
                        Contractor__c,
                        Operator__c,
                        Days_Since_Created__c,
                        CreatedDate
                FROM
                        Operator_Contractor__c
                WHERE
                        Contractor__c in :contractorIds
        ];

        Map<Id, Operator_Contractor__c> operatorContractorsByAccountId = new Map<Id, Operator_Contractor__c>();
        ID[] operatorIds = new List<Id>();
        for (Operator_Contractor__c operatorContractor : operatorContractorsSet) {
            operatorContractorsByAccountId.put(operatorContractor.Contractor__c, operatorContractor);
            operatorIds.add(operatorContractor.Operator__c);
        }


        Map<Id, Account> accountsMap = new Map<Id, Account>([
                SELECT
                        Id, Last_Invoice_Date__c
                FROM
                        Account
                WHERE
                        Id IN :contractorIds
        ]);

//        Opportunity[] opportunitiesSet = [
//                SELECT
//                        Id, StageName, Client_Account__c, AccountId, Type, Free_Connection__c
//                FROM
//                        Opportunity
//                WHERE
//                AccountId IN :accountIds
//                AND
//                (
//
//
//                        StageName = 'Closed Won'
//
//                        OR
//                        IsClosed = true
////                        (
////                                StageName = 'Closed Won'
////                                AND
////                                Campaign_Aged__c = false
////                        )
////                        OR
////                        IsClosed = false
//                )
//                AND
//                Type <> 'Vetify'
//                AND
//                RecordTypeId = '01270000000cebq'
//        ];


        Opportunity[] opportunitiesSet = [
                SELECT
                        Id,
                        StageName,
                        Client_Account__c,
                        AccountId,
                        Type,
                        Free_Connection__c
                FROM
                        Opportunity
                WHERE
                AccountId IN :contractorIds
                AND
                Client_Account__c IN :operatorIds

        ];

        Map<Id, Opportunity> opportunitiesByAccountId = new Map<Id, Opportunity>();
        for (Opportunity opportunity : opportunitiesSet) {
            opportunitiesByAccountId.put(opportunity.AccountId, opportunity);
        }


        Operator_Contractor__c[] updatedOperatorContractors = new List<Operator_Contractor__c>();

        // Go through each Invoice
        for (Zuora__ZInvoice__c invoice : updatedInvoices) {

            Boolean updateInitialPaymentMade = false;

            Operator_Contractor__c operatorContractor = operatorContractorsByAccountId.get(invoice.Zuora__Account__c);

            Opportunity opportunity = opportunitiesByAccountId.get(invoice.Zuora__Account__c);

            Account account = accountsMap.get(invoice.Zuora__Account__c);

            if (opportunity != null && invoice.Zuora__PaymentAmount__c > 0 && invoice.Zuora__Balance__c <= 0) {


                if (opportunity.Type == 'Registration' || opportunity.Type == 'Reactivation') {

                    updateInitialPaymentMade = true;

                } else if (opportunity.Type == 'Upgrade' && opportunity.Free_Connection__c == true) {

                    updateInitialPaymentMade = true;

                } else if ((opportunity.Type == 'Upgrade' && opportunity.Free_Connection__c == false) || opportunity.Type == null) {

                    if (operatorContractor.Days_Since_Created__c > 10 || account.Last_Invoice_Date__c >= operatorContractor.CreatedDate) {

                        updateInitialPaymentMade = true;
                    }

                }

                if (updateInitialPaymentMade) {

                    operatorContractor.Initial_Payment_Made__c = true;
                    updatedOperatorContractors.add(operatorContractor);
                }

            }

            if (updatedOperatorContractors.size() > 0) {
                update updatedOperatorContractors;
            }
            System.debug('START: API_CONNECT_Invoice_TriggerHandler.OnAfterUpdate');

        }
    }

//    public void OnBeforeDelete(Zuora__ZInvoice__c[] ObjectsToDelete, Map<Id, Zuora__ZInvoice__c> MapObjectMap) {
//        // BEFORE DELETE LOGIC
//    }
//
//    public void OnAfterDelete(Zuora__ZInvoice__c[] deletedObjects, Map<Id, Zuora__ZInvoice__c> MapObjectMap) {
//        // AFTER DELETE LOGIC
//    }
//
//    public void OnUndelete(Zuora__ZInvoice__c[] restoredObjects) {
//        // AFTER UNDELETE LOGIC
//    }

    public boolean IsTriggerContext {
        get {
            return m_isExecuting;
        }
    }
}