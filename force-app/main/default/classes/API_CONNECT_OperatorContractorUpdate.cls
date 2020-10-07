/**
 * Created by brett on 2/28/18.
 */

public with sharing class API_CONNECT_OperatorContractorUpdate {

    //API_CONNECT_OperatorContractorUpdate

    @InvocableMethod
    public static void updateFields(List<Id> ids) {
        System.debug('START: API_CONNECT_OperatorContractorUpdate.updateFields');

        Set<Id> duplicateRemover = new Set<Id>();
        List<Id> result = new List<Id>();
        duplicateRemover.addAll(ids);
        result.addAll(duplicateRemover);

        updateLinkedClientSites(ids);
        updatePayingFacilities(result);

        System.debug('END: API_CONNECT_OperatorContractorUpdate.updateFields');
    }


    static void updatePayingFacilities(List<Id> ids) {
        System.debug('START: API_CONNECT_OperatorContractorUpdate.updatePayingFacilities');


        Account[] accounts = New List<Account>();

        for (Id accountId : ids) {

            //get all Operator_Contractor__c that don't have a Billable_Entity__c
            Operator_Contractor__c[] billables = [
                    SELECT
                            Operator__r.Billable_Entity__c,
                            Operator__c,
                            Operator__r.Name
                    FROM
                            Operator_Contractor__c
                    WHERE
                    Contractor__c = :accountId

                    AND
                    Contractor_Status__c = 'Active'
                    AND
                    (NOT Operator__r.Name like '%avetta')
            ];

            System.debug(billables);

            Set<Id> keys = new Set<Id>();

            // Make a unique set of the billable Ids
            for (Operator_Contractor__c operatorContractor : billables) {
//                String name = operatorContractor.Operator__r.Name;
//                String lowerCaseName = name.toLowerCase();
//                Boolean doesIt = lowerCaseName.contains('avetta');
//
//                if (doesIt == false) {

                if (operatorContractor.Operator__r.Billable_Entity__c != null) {
                    keys.add(operatorContractor.Operator__r.Billable_Entity__c);
                } else {
                    keys.add(operatorContractor.Operator__c);

                }
//                }
            }

            System.debug(keys);


            Integer count = keys.size();

            System.debug(count);

            Account account = new Account(Id = accountId);

            account.Paying_Facilities_Audit__c = count;

            System.debug(account);


            accounts.add(account);
        }


        update accounts;

        System.debug('END: API_CONNECT_OperatorContractorUpdate.updatePayingFacilities');
    }

    static void updateLinkedClientSites(List<Id> ids) {
        System.debug('START: API_CONNECT_OperatorContractorUpdate.updateLinkedClientSites');


        Map<Id, Account> accounts = New Map<Id, Account>();

        for (Id accountId : ids) {


            Integer count = [
                    SELECT COUNT()
                    FROM Operator_Contractor__c
                    WHERE Contractor__c = :AccountId
                    AND Contractor_Status__c = 'Active'
            ];

            System.debug(count);

            Account account = new Account(ID = accountId);

            account.Linked_Client_Sites_Audit__c = count;
            System.debug(account);

            accounts.put(account.Id, account);
        }


        update accounts.values();

        System.debug('END: API_CONNECT_OperatorContractorUpdate.updateLinkedClientSites');
    }


}