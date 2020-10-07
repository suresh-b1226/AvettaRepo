/**
 * Created by brett on 2/26/18.
 */

@IsTest
public with sharing class API_CONNECT_OperatorContractorTest {


    static testMethod void testGet() {

        System.debug('START: API_CONNECT_OperatorContractorTest.testGet');

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact') ;
        accountRecords[0].Organizer_ID__c = '12343';
        accountRecords[1].Organizer_ID__c = '12347';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];
        operatorContractor.Organizer_Key__c = accountRecords[1].Organizer_ID__c + '-' + accountRecords[0].Organizer_ID__c;
        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
//        API_CONNECT_OperatorContractor classToTest = new API_CONNECT_OperatorContractor();
        String urlToCall = Url.getSalesforceBaseUrl() + '/services/apexrest/avetta/V1/OperatorContractor/' + operatorContractor.Organizer_Key__c;


        System.debug(urlToCall);

        req.requestURI = urlToCall;
//        req.addParameter('id','12347-12343');

        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'GET';
        req.requestBody = Blob.valueof('{}');

        RestContext.request = req;
        RestContext.response = res;

        //ACT - make the request from inside the test execution context, rather than from the external system
        Test.startTest();
        API_CONNECT_OperatorContractor.OperatorContractorLight[] results = API_CONNECT_OperatorContractor.getOperatorContractorById();
        Test.stopTest();

        //ASSERT - verify that you got what you expected...
        System.assertEquals(200, res.statusCode);
        System.assert(results.size() > 0);
        System.assertEquals(results[0].getConnectionKey(), operatorContractor.Organizer_Key__c);
        System.assertEquals(results[0].status, operatorContractor.Status__c);
//        System.assertEquals(200, res.getStatusCode());


        System.debug('START: API_CONNECT_OperatorContractorTest.testGet');

    }

    static testMethod void testPutUpdate() {

        System.debug('START: API_CONNECT_OperatorContractorTest.testPut');
        //ARRANGE - setup request like the external system would....
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
//        API_CONNECT_OperatorContractor classToTest = new API_CONNECT_OperatorContractor();
        String urlToCall = Url.getSalesforceBaseUrl() + '/services/apexrest/avetta/V1/OperatorContractor/';


        System.debug(urlToCall);

        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact') ;
        accountRecords[0].Organizer_ID__c = '12343';
        accountRecords[1].Organizer_ID__c = '12347';

        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accountRecords[1].Vetify_Position__c = 'Client Opt In';

        insert accountRecords;
        System.debug('after updating account record type') ;
        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accountRecords[1].id, accountRecords[0].id)[0];
        operatorContractor.Organizer_Key__c = accountRecords[1].Organizer_ID__c + '-' + accountRecords[0].Organizer_ID__c;
        operatorContractor.Operator__r = accountRecords[1];
        operatorContractor.Contractor__r = accountRecords[0];
        operatorContractor.CreatedDate = Date.today().addDays(-11);
        insert operatorContractor;

        API_CONNECT_OperatorContractor.OperatorContractorLight payload = new API_CONNECT_OperatorContractor.OperatorContractorLight(operatorContractor);
        payload.status = 'Deactivated';


        req.requestURI = urlToCall;
        req.addParameter('operatorContractorToUpdate', JSON.serialize(payload));

        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof('{}');

        RestContext.request = req;
        RestContext.response = res;

        //ACT - make the request from inside the test execution context, rather than from the external system
        Test.startTest();
        API_CONNECT_OperatorContractor.OperatorContractorLight[] results = API_CONNECT_OperatorContractor.upsertOperatorContractor(payload);
        Test.stopTest();

        //ASSERT - verify that you got what you expected...
        System.debug(results);
        Blob responseBody = res.responseBody;
        System.debug('responseBody');
        System.debug(responseBody);
//        String expectedValue = '{ "status" : "success" }'; //from your @HttpGet method above....


        System.assertEquals(200, res.statusCode);
        System.assert(results.size() > 0);
        System.assertEquals(results[0].getConnectionKey(), payload.getConnectionKey());
        System.assertEquals(results[0].status, payload.status);
//        System.assertEquals(results.contractorId, payload.contractorId);
//        System.assertEquals(results.operatorId, payload.operatorId);


//        System.assertEquals(200, res.getStatusCode());


        System.debug('START: API_CONNECT_OperatorContractorTest.testPut');

    }

    static testMethod void testPutInsert() {

        System.debug('START: API_CONNECT_OperatorContractorTest.testPut');
        //ARRANGE - setup request like the external system would....
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
//        API_CONNECT_OperatorContractor classToTest = new API_CONNECT_OperatorContractor();
        String urlToCall = Url.getSalesforceBaseUrl() + '/services/apexrest/avetta/V1/OperatorContractor/';


        System.debug(urlToCall);


        System.debug('') ;
        //Create dummy data for test purposes.
        List<Account> accounts = QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact(2, false);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
        System.debug('after creating account in QB_TestDataFactory.createAccountRecordsWithOutPrimaryContact');
        accounts[0].Organizer_ID__c = '12343';
        accounts[0].Status__c = 'Active';
        accounts[1].Organizer_ID__c = '12347';

        accounts[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        accounts[1].Vetify_Position__c = 'Client Opt In';

        insert accounts;

        Operator_Contractor__c operatorContractor = QB_TestDataFactory.createOperatorContractorRecords(1, false, accounts[1].id, accounts[0].id)[0];
        operatorContractor.Organizer_Key__c = accounts[1].Organizer_ID__c + '-' + accounts[0].Organizer_ID__c;
        operatorContractor.Operator__r = accounts[1];
        operatorContractor.Contractor__r = accounts[0];
        operatorContractor.Organizer_Key__c = accounts[1].Organizer_ID__c + '-' + accounts[0].Organizer_ID__c;
        operatorContractor.CreatedDate = Date.today().addDays(-11);

        API_CONNECT_OperatorContractor.OperatorContractorLight payload = new API_CONNECT_OperatorContractor.OperatorContractorLight(operatorContractor);
        payload.status = 'Deactivated';


        req.requestURI = urlToCall;
        req.addParameter('operatorContractorToUpdate', JSON.serialize(payload));

        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof('{}');

        RestContext.request = req;
        RestContext.response = res;

        //ACT - make the request from inside the test execution context, rather than from the external system
        Test.startTest();
        API_CONNECT_OperatorContractor.OperatorContractorLight[] results = API_CONNECT_OperatorContractor.upsertOperatorContractor(payload);
        Test.stopTest();

        //ASSERT - verify that you got what you expected...
        System.debug(results);
        Blob responseBody = res.responseBody;
        System.debug('responseBody');
        System.debug(responseBody);
//        String expectedValue = '{ "status" : "success" }'; //from your @HttpGet method above....
        System.assertEquals(200, res.statusCode);
        System.assert(results.size() > 0);
        System.assertEquals(results[0].getConnectionKey(), payload.getConnectionKey());
        System.assertEquals(results[0].status, payload.status);


        System.debug('START: API_CONNECT_OperatorContractorTest.testPut');

    }


    //////helpers


}