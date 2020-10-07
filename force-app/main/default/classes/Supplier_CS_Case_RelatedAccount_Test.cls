/**
 * Created by dwasden on 2/1/2019.
 */

@isTest public with sharing class Supplier_CS_Case_RelatedAccount_Test {
    @isTest(SeeAllData=true) static void Supplier_CS_Case_RelatedAcc_Single_Supplier() {

        //Create account record for test purposes.
        List<Account> globalParentAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.globalParentAccountRecords' + globalParentAccountRecords);

        //Create account record for test purposes.
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE, globalParentAccountRecords[0].Id);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + clientAccountRecords);

        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);

        //Create  opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);

        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createCaseRecords(0, TRUE, accountRecords[0].id, contactRecords[0].id);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.caseRecords' + caseRecords);

        //Create collections opportunity records for test purposes.
        List<Related_Client_Case__c> relatedClientCases = QB_TestDataFactory.createRelatedClientCases(1, TRUE, clientAccountRecords, caseRecords[0].id);
        System.debug('after creating related client case in QB_TestDataFactory.caseRecords' + relatedClientCases[0]);

    } 

    @isTest(SeeAllData=true) static void Supplier_CS_Case_RelatedAcc_Corporate_Suppliers() {

        //Create account record for test purposes.
        List<Account> globalParentAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.globalParentAccountRecords' + globalParentAccountRecords);

        //Create account record for test purposes.
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(3, TRUE, globalParentAccountRecords[0].Id);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + clientAccountRecords);

        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);

        //Create  opportunity records for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);

        //Create case records for test purposes.
        List<Case> caseRecords = QB_TestDataFactory.createCaseRecords(0, TRUE, accountRecords[0].id, contactRecords[0].id);
        System.debug('after UPDATING opportunities in QB_TestDataFactory.caseRecords' + caseRecords);

        //Create collections opportunity records for test purposes.
        List<Related_Client_Case__c> relatedClientCases = QB_TestDataFactory.createRelatedClientCases(3, TRUE, clientAccountRecords, caseRecords[0].id);
        System.debug('after creating related client case in QB_TestDataFactory.caseRecords' + relatedClientCases);

    }
}