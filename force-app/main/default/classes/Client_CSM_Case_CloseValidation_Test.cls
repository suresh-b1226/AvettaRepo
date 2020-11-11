/**
 * Created by JasonMcGrew on 10/21/2020.
 */

@IsTest
private class Client_CSM_Case_CloseValidation_Test {
    @IsTest
    static void caseValidationTest() {

        List<Account> testAccount = QB_TestDataFactory.createClientAccountRecords(1,true);

        Case testCase1 = new Case();
            testCase1.Subject = 'test case 1';
            testCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Client').getRecordTypeId();
            testCase1.AccountId = testAccount[0].Id;
            testCase1.Status = 'Closed';
            testCase1.Type = 'Complaint';
            //testCase1.ContactId = contactId;
        insert testCase1;

        Task testTask1 = new Task();
            testTask1.Type = 'Complaint';
            testTask1.Subject = 'Test Complaint';
            testTask1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CSM Tasks').getRecordTypeId();
            testTask1.WhatId = testCase1.Id;
            testTask1.Status = 'Completed';

        insert testTask1;

    }
}