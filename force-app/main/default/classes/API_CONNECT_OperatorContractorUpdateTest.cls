@IsTest
public with sharing class API_CONNECT_OperatorContractorUpdateTest {

    static testMethod void testUpdateLinkedClientSites() {
        System.debug('START: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');


        // ARRANGE
        QB_TestDataFactory.createSITCustomSetting(TRUE);

        Account contractorAccount = QB_TestDataFactory.createAccountRecords(1, false)[0];
        contractorAccount.Organizer_ID__c = '1234';
        contractorAccount.Status__c = 'Active';
        upsert contractorAccount;
        Account[] operatorAccounts = QB_TestDataFactory.createAccountRecords(3, false);

        for (Integer i = 0; i < operatorAccounts.size(); i++) {
            operatorAccounts[i].Organizer_ID__c = '0987' + i;
            operatorAccounts[i].Status__c = 'Active';
            operatorAccounts[i].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        }
        upsert operatorAccounts;

        operatorAccounts[0].Billable_Entity__c = operatorAccounts[2].Id;

        update operatorAccounts[0];


        Operator_Contractor__c[] operatorContractors = new List<Operator_Contractor__c>();

        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[0].Id, contractorAccount.Id)[0];
        operatorContractor.Contractor_Status__c = 'Active';
        operatorContractor.Organizer_Key__c = operatorAccounts[0].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor;

        Operator_Contractor__c operatorContractor2 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[1].Id, contractorAccount.Id)[0];
        operatorContractor2.Contractor_Status__c = 'Active';
        operatorContractor2.Organizer_Key__c = operatorAccounts[1].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor2;

        Operator_Contractor__c operatorContractor3 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[2].Id, contractorAccount.Id)[0];
        operatorContractor3.Contractor_Status__c = 'Active';
        operatorContractor3.Organizer_Key__c = operatorAccounts[2].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor3;

        List<Id> ids = new List<Id>();

        ids.add(contractorAccount.Id);


        // ACT
        Test.startTest();


        API_CONNECT_OperatorContractorUpdate.updateFields(ids);
        Test.stopTest();

        Account resultAccount = [
                SELECT
                        Id,
                        Paying_Facilities_Audit__c,
                        Linked_Client_Sites_Audit__c


                FROM
                        Account
                WHERE
                        Id = :contractorAccount.Id
        ];

        // ASSERT
        System.assertEquals(2, resultAccount.Paying_Facilities_Audit__c);
        System.assertEquals(3, resultAccount.Linked_Client_Sites_Audit__c);

        System.debug('END: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');
    }

    static testMethod void testUpdatePayingFacilities() {
        System.debug('START: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');


        // ARRANGE
        QB_TestDataFactory.createSITCustomSetting(TRUE);

        Account contractorAccount = QB_TestDataFactory.createAccountRecords(1, false)[0];
        contractorAccount.Organizer_ID__c = '1234';
        contractorAccount.Status__c = 'Active';
        upsert contractorAccount;
        Account[] operatorAccounts = QB_TestDataFactory.createAccountRecords(3, false);

        for (Integer i = 0; i < operatorAccounts.size(); i++) {
            operatorAccounts[i].Organizer_ID__c = '0987' + i;
            operatorAccounts[i].Status__c = 'Active';
            operatorAccounts[i].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        }
        upsert operatorAccounts;

        operatorAccounts[0].Billable_Entity__c = operatorAccounts[2].Id;

        update operatorAccounts[0];


        Operator_Contractor__c[] operatorContractors = new List<Operator_Contractor__c>();

        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[0].Id, contractorAccount.Id)[0];
        operatorContractor.Contractor_Status__c = 'Active';
        operatorContractor.Organizer_Key__c = operatorAccounts[0].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor;

        Operator_Contractor__c operatorContractor2 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[1].Id, contractorAccount.Id)[0];
        operatorContractor2.Contractor_Status__c = 'Active';
        operatorContractor2.Organizer_Key__c = operatorAccounts[1].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor2;

        Operator_Contractor__c operatorContractor3 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[2].Id, contractorAccount.Id)[0];
        operatorContractor3.Contractor_Status__c = 'Active';
        operatorContractor3.Organizer_Key__c = operatorAccounts[2].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;

        update operatorContractor3;

        List<Id> ids = new List<Id>();

        ids.add(contractorAccount.Id);


        // ACT
        Test.startTest();


        API_CONNECT_OperatorContractorUpdate.updateFields(ids);


        Test.stopTest();

        Account resultAccount = [
                SELECT
                        Id,
                        Paying_Facilities_Audit__c,
                        Linked_Client_Sites_Audit__c
                FROM
                        Account
                WHERE
                        Id = :contractorAccount.Id
        ];

        // ASSERT
        System.assertEquals(2, resultAccount.Paying_Facilities_Audit__c);
        System.assertEquals(3, resultAccount.Linked_Client_Sites_Audit__c);


        System.debug('END: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');
    }

    static testMethod void testUpdatePayingFacilitiesDontCountSitesNamedLowercaseAvetta() {
        System.debug('START: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');


        // ARRANGE
        QB_TestDataFactory.createSITCustomSetting(TRUE);

        Account contractorAccount = QB_TestDataFactory.createAccountRecords(1, false)[0];
        contractorAccount.Organizer_ID__c = '1234';
        contractorAccount.Status__c = 'Active';
        upsert contractorAccount;
        Account[] operatorAccounts = QB_TestDataFactory.createAccountRecords(3, false);


        operatorAccounts[2].Name = 'avetta';
        for (Integer i = 0; i < operatorAccounts.size(); i++) {
            operatorAccounts[i].Organizer_ID__c = '0987' + i;
            operatorAccounts[i].Status__c = 'Active';
            operatorAccounts[i].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();

        }
        upsert operatorAccounts;

        operatorAccounts[0].Billable_Entity__c = operatorAccounts[2].Id;

        update operatorAccounts[0];


        Operator_Contractor__c[] operatorContractors = new List<Operator_Contractor__c>();

        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[0].Id, contractorAccount.Id)[0];
        operatorContractor.Contractor_Status__c = 'Active';
        operatorContractor.Organizer_Key__c = operatorAccounts[0].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor;

        Operator_Contractor__c operatorContractor2 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[1].Id, contractorAccount.Id)[0];
        operatorContractor2.Contractor_Status__c = 'Active';
        operatorContractor2.Organizer_Key__c = operatorAccounts[1].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor2;

        Operator_Contractor__c operatorContractor3 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[2].Id, contractorAccount.Id)[0];
        operatorContractor3.Contractor_Status__c = 'Active';
        operatorContractor3.Organizer_Key__c = operatorAccounts[2].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;

        update operatorContractor3;

        List<Id> ids = new List<Id>();

        ids.add(contractorAccount.Id);


        // ACT
        Test.startTest();


        API_CONNECT_OperatorContractorUpdate.updateFields(ids);


        Test.stopTest();

        Account resultAccount = [
                SELECT
                        Id,
                        Paying_Facilities_Audit__c
                FROM
                        Account
                WHERE
                        Id = :contractorAccount.Id
        ];

        // ASSERT
        System.assertEquals(2, resultAccount.Paying_Facilities_Audit__c);


        System.debug('END: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');
    }

    static testMethod void testUpdatePayingFacilitiesDontCountSitesNamedUppercaseAvetta() {
        System.debug('START: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');


        // ARRANGE
        QB_TestDataFactory.createSITCustomSetting(TRUE);

        Account contractorAccount = QB_TestDataFactory.createAccountRecords(1, false)[0];
        contractorAccount.Organizer_ID__c = '1234';
        contractorAccount.Status__c = 'Active';
        upsert contractorAccount;
        Account[] operatorAccounts = QB_TestDataFactory.createAccountRecords(3, false);


        operatorAccounts[2].Name = 'Avetta';
        for (Integer i = 0; i < operatorAccounts.size(); i++) {
            operatorAccounts[i].Organizer_ID__c = '0987' + i;
            operatorAccounts[i].Status__c = 'Active';
            operatorAccounts[i].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();

        }
        upsert operatorAccounts;

        operatorAccounts[0].Billable_Entity__c = operatorAccounts[2].Id;

        update operatorAccounts[0];


        Operator_Contractor__c[] operatorContractors = new List<Operator_Contractor__c>();

        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[0].Id, contractorAccount.Id)[0];
        operatorContractor.Contractor_Status__c = 'Active';
        operatorContractor.Organizer_Key__c = operatorAccounts[0].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor;

        Operator_Contractor__c operatorContractor2 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[1].Id, contractorAccount.Id)[0];
        operatorContractor2.Contractor_Status__c = 'Active';
        operatorContractor2.Organizer_Key__c = operatorAccounts[1].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor2;

        Operator_Contractor__c operatorContractor3 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[2].Id, contractorAccount.Id)[0];
        operatorContractor3.Contractor_Status__c = 'Active';
        operatorContractor3.Organizer_Key__c = operatorAccounts[2].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;

        update operatorContractor3;

        List<Id> ids = new List<Id>();

        ids.add(contractorAccount.Id);


        // ACT
        Test.startTest();


        API_CONNECT_OperatorContractorUpdate.updateFields(ids);


        Test.stopTest();

        Account resultAccount = [
                SELECT
                        Id,
                        Paying_Facilities_Audit__c
                FROM
                        Account
                WHERE
                        Id = :contractorAccount.Id
        ];

        // ASSERT
        System.assertEquals(2, resultAccount.Paying_Facilities_Audit__c);


        System.debug('END: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');
    }


    static testMethod void testUpdatePayingFacilitiesWithDupeIds() {
        System.debug('START: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');


        // ARRANGE
        QB_TestDataFactory.createSITCustomSetting(TRUE);

        Account contractorAccount = QB_TestDataFactory.createAccountRecords(1, false)[0];
        contractorAccount.Organizer_ID__c = '1234';
        contractorAccount.Status__c = 'Active';
        upsert contractorAccount;
        Account[] operatorAccounts = QB_TestDataFactory.createAccountRecords(3, false);

        for (Integer i = 0; i < operatorAccounts.size(); i++) {
            operatorAccounts[i].Organizer_ID__c = '0987' + i;
            operatorAccounts[i].Status__c = 'Active';
            operatorAccounts[i].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        }
        upsert operatorAccounts;

        operatorAccounts[0].Billable_Entity__c = operatorAccounts[2].Id;

        update operatorAccounts[0];


        Operator_Contractor__c[] operatorContractors = new List<Operator_Contractor__c>();

        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[0].Id, contractorAccount.Id)[0];
        operatorContractor.Contractor_Status__c = 'Active';
        operatorContractor.Organizer_Key__c = operatorAccounts[0].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor;

        Operator_Contractor__c operatorContractor2 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[1].Id, contractorAccount.Id)[0];
        operatorContractor2.Contractor_Status__c = 'Active';
        operatorContractor2.Organizer_Key__c = operatorAccounts[1].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;
        update operatorContractor2;

        Operator_Contractor__c operatorContractor3 = QB_TestDataFactory.createOperatorContractorRecords(1, true, operatorAccounts[2].Id, contractorAccount.Id)[0];
        operatorContractor3.Contractor_Status__c = 'Active';
        operatorContractor3.Organizer_Key__c = operatorAccounts[2].Organizer_ID__c + '-' + contractorAccount.Organizer_ID__c;

        update operatorContractor3;

        List<Id> ids = new List<Id>();

        ids.add(contractorAccount.Id);
        ids.add(contractorAccount.Id);
        ids.add(contractorAccount.Id);


        // ACT
        Test.startTest();


        API_CONNECT_OperatorContractorUpdate.updateFields(ids);


        Test.stopTest();

        Account resultAccount = [
                SELECT
                        Id,
                        Paying_Facilities_Audit__c
                FROM
                        Account
                WHERE
                        Id = :contractorAccount.Id
        ];

        // ASSERT
        System.assertEquals(2, resultAccount.Paying_Facilities_Audit__c);


        System.debug('END: API_CONNECT_OperatorContractorUpdateTest.testUpdatePayingFacilities');
    }

}