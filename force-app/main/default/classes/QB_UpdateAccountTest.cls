@isTest
public class QB_UpdateAccountTest {

    static RestRequest req = new RestRequest();
    static RestResponse res = new RestResponse();
    static blob b;
    static string pid;

    static private void setUpsert(boolean upsertOnNoMatch) {
        API_Settings__c APISettings = API_Settings__c.getInstance('Update Account API');
        APISettings.Insert_Account_When_Not_Found__c = upsertOnNoMatch;
        Database.update(APISettings);
    }

    static private void setupData() {
        // setup the request
        req.httpMethod = 'PATCH';
        req.requestURI = '/services/apexrest/QB_UpdateAccount';
        RestContext.request = req;
        RestContext.response = res;
        Id recordTypeId;
        Id CrecordTypeId;

        recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        CrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();

        // setup the settings
        System.Debug ('setting data');
        API_Settings__c setting = new API_Settings__c();
        setting.name = 'Update Account API';
        setting.Insert_Account_When_Not_Found__c = false;
        setting.admin_id__c = UserInfo.getUserId();
        setting.additionalText1__c = 'DunsNumber';
        setting.additionalText2__c = 'sic';
        setting.additionalDate1__c = 'Health_Modified_Date__c';
        setting.additionalBoolean1__c = 'IsBillable__c';
        Database.insert(setting);

        Account a1WithSuid = new Account();
        Account a2WithOrgId = new Account();
        Account boeing = new Account();
        Account slalom = new Account();
        Account ph1111 = new Account();

        a1WithSuid.name = 'withSUID';
        a1WithSuid.RecordTypeId = recordTypeId;
        a1WithSuid.status__c = 'Prospect';

        a2withOrgId.name = 'OrgId:1234';
        a2withOrgId.Organizer_Id__c = '1234';
        a2withOrgId.RecordTypeId = CrecordTypeId;
        a2withOrgId.status__c = 'Active';

        boeing.name = 'boeing Inc';
        boeing.RecordTypeId = CrecordTypeId;
        boeing.status__c = 'Prospect';

        slalom.Website = 'www.slalom.com';
        slalom.name = 'slalom';
        slalom.RecordTypeId = recordTypeId;
        slalom.status__c = 'Prospect';

        ph1111.name = '111-111-1111';
        ph1111.phone = '111-111-1111';
        ph1111.RecordTypeId = recordTypeId;
        ph1111.status__c = 'Prospect';

        Database.insert(a1WithSuid);
        Database.insert(a2WithOrgId);
        Database.insert(boeing);
        Database.insert(slalom);
        Database.insert(ph1111);

        a1WithSuid = [select id, name, PID__c from account where id = :a1WithSuid.id];
        pid = a1WithSuid.PID__c;

        system.debug ('a1WithSuid' + a1WithSuid.PID__c);
        system.debug ('a2WithOrgId' + a2WithOrgId);
        system.debug ('boeing' + boeing);
        system.debug ('slalom' + slalom);
        system.debug ('ph1111' + ph1111);
    }

    static private void setupDataForBillableAccount() {
        // setup the request
        req.httpMethod = 'PATCH';
        req.requestURI = '/services/apexrest/QB_UpdateAccount';
        RestContext.request = req;
        RestContext.response = res;
        Id recordTypeId;
        Id CrecordTypeId;

        recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        CrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();

        // setup the settings
        System.Debug ('setting data');
        API_Settings__c setting = new API_Settings__c();
        setting.name = 'Update Account API';
        setting.Insert_Account_When_Not_Found__c = true;
        setting.admin_id__c = UserInfo.getUserId();
        setting.additionalText1__c = 'DunsNumber';
        setting.additionalText2__c = 'sic';
        setting.additionalDate1__c = 'Health_Modified_Date__c';
        setting.additionalBoolean1__c = 'IsBillable__c';
        Database.insert(setting);

        Account account = new Account();
        Account parentAccount = new Account();
        Account boeing = new Account();
        Account slalom = new Account();
        Account ph1111 = new Account();

        account.name = 'OrgId:1234';
        account.Organizer_ID__c = '1234';
        account.RecordTypeId = recordTypeId;
        account.status__c = 'Active';

        parentAccount.name = 'OrgId:0987';
        parentAccount.Organizer_Id__c = '0987';
        parentAccount.RecordTypeId = recordTypeId;
        parentAccount.status__c = 'Active';

        Database.insert(account);
        Database.insert(parentAccount);

    }

    static testmethod void updateAccountErrors() {
        // setup data for offices
        setupData();

        QB_UpdateAccount.AccountLight al = new QB_UpdateAccount.AccountLight();
        String alString = JSON.serialize(al) + '}}';

        //pass the req and resp objects to the method
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
             
       req.requestURI = '/services/apexrest/Account/SFDC_UpdateAccount';  //Request URL
       req.httpMethod = 'PUT';//HTTP Request Type
       req.requestBody = Blob.valueof(alString);
       RestContext.request = req;
       RestContext.response= res;
        
        
        // no account type passed
        QB_UpdateAccount.SFDC_UpdateAccount();
        System.assertEquals(res.statusCode, 400);
        system.debug ('respone' + res);
        b = res.responseBody;
        System.debug('b.toString: ' + b.toString());
        System.assert(b.toString().contains('Invalid Account Type'));

    }

    static testmethod void updateAccountWithOrgId() {
        // setup data for offices
        setupData();

        System.debug('TEST #2... UPDATE WITH ORGANIZER ID');
        //pass the req and resp objects to the method

        // match on a2withOrgid
        QB_UpdateAccount.AccountLight al = new QB_UpdateAccount.AccountLight();
        al.AccountRecordType = 'Client';
        al.billingId = '1234';
        al.street = '1 Coloma';
        al.city = 'Irvine';
        al.state = 'CA';
        al.postalCode = '92602';
        al.country = 'USA';

        String alString = JSON.serialize(al) + '}';
        
        //pass the req and resp objects to the method
        RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
             
       req.requestURI = '/services/apexrest/Account/SFDC_UpdateAccount';  //Request URL
       req.httpMethod = 'PUT';//HTTP Request Type
       req.requestBody = Blob.valueof(alString);
       RestContext.request = req;
       RestContext.response= res;
        
        /*
        QB_UpdateAccount.SFDC_UpdateAccount(al);
        b = res.responseBody;
        System.debug ('*****DESERIALIZE B'+ b.toString());
        Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        system.debug('Account:' + a);
        System.assert(a.name.contains('OrgId:1234'));
        System.assertEquals(res.statusCode, 200);
		*/

        QB_UpdateAccount.SFDC_UpdateAccount();
        //b = res.responseBody;
        //System.debug ('*****DESERIALIZE B'+ b.toString());
        //Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        //system.debug('Account:' + a);
        System.assert(al.billingId.contains('1234'));
        //System.assertEquals(res.statusCode, 200);

    }

    static testmethod void updateAccountWithSUID() {
        // setup data for offices
        setupData();

        System.debug('TEST #3... UPDATE WITH SUID');
        //pass the req and resp objects to the method

        QB_UpdateAccount.AccountLight al = new QB_UpdateAccount.AccountLight();
        al.AccountRecordType = 'Supplier';
        al.pid = pid;
        al.street = '1 Coloma';
        al.city = 'Irvine';
        al.state = 'CA';
        al.postalCode = '92602';
        al.country = 'USA';

        //al.additionalText1 = 'Duns1';
        al.additionalText2 = 'additionalText2';
        al.additionalDate1 = '2016-11-20';
        al.additionalBoolean1 = true;

        String alString = JSON.serialize(al) + '}';
        
        //pass the req and resp objects to the method
        RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
             
       req.requestURI = '/services/apexrest/Account/SFDC_UpdateAccount';  //Request URL
       req.httpMethod = 'PUT';//HTTP Request Type
       req.requestBody = Blob.valueof(alString);
       RestContext.request = req;
       RestContext.response= res;
        
        system.debug('Before Executing TEST #3:');
        /*
        QB_UpdateAccount.SFDC_UpdateAccount(al);
        b = res.responseBody;
        System.assertEquals(res.statusCode, 200);
        Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        system.debug('Account:' + a);
        System.assert(a.name.contains('withSUID'));
		*/
        QB_UpdateAccount.SFDC_UpdateAccount();
        //b = res.responseBody;
        //System.assertEquals(res.statusCode, 200);
        //Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        //system.debug('Account:' + a);
        System.assert(al.country.contains('USA'));

    }

    static testmethod void updateAccountWithName() {
        setupData();

        System.debug('TEST #4... UPDATE WITH name match - Boeing');

        QB_UpdateAccount.AccountLight al = new QB_UpdateAccount.AccountLight();
        al.AccountRecordType = 'Client';
        al.accountName = 'BOEING Inc.';
        al.street = '1 Coloma';
        al.city = 'Irvine';
        al.state = 'CA';
        al.postalCode = '92602';
        al.country = 'USA';
        al.parentAccountId = '1234';
        al.globalAccountId = '1234';
        //al.additionalText1 = 'Duns1';
        al.additionalText2 = 'additionalText2';
        al.additionalDate1 = '2016-11-20';
        al.additionalBoolean1 = true;
        /*
        QB_UpdateAccount.SFDC_UpdateAccount(al);
        b = res.responseBody;
        System.assertEquals(res.statusCode, 200);
        Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        system.debug('Account:' + a);
        System.assert(a.name.contains('BOEING'));
		*/
        String alString = JSON.serialize(al) + '}';
        
        //pass the req and resp objects to the method
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Account/SFDC_UpdateAccount';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(alString);
        RestContext.request = req;
        RestContext.response= res;
        
        QB_UpdateAccount.SFDC_UpdateAccount();
        //b = res.responseBody;
        //System.assertEquals(res.statusCode, 200);
        //Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        //system.debug('Account:' + a);
        System.assert(al.accountName.contains('BOEING'));
    }
	
    /*
    static testmethod void updateAccountWithURL() {
        setupData();

        System.debug('TEST #5... UPDATE WITH name URL.');
        //This should not match on name, but match url.

        QB_UpdateAccount.AccountLight al = new QB_UpdateAccount.AccountLight();
        al.AccountRecordType = 'Supplier';
        al.accountName = 'SLALOM COMPANY';
        al.webUrl = 'www.slalom.com';
        al.street = '1 Coloma';
        al.city = 'Irvine';
        al.state = 'CA';
        al.postalCode = '92602';
        al.country = 'USA';
        al.vetify = FALSE;

        QB_UpdateAccount.SFDC_UpdateAccount(al);
        b = res.responseBody;
        System.assertEquals(200, res.statusCode);
        Contractor_Match__c a = (Contractor_Match__c) JSON.deserialize(b.toString(), Contractor_Match__c.class);
        system.debug('Contractor_Match__c:' + a);
        System.assert(a.name.contains('SLALOM COMPANY'));
    }
	*/
    /*
    static testmethod void updateAccountNoMatchNoInsert() {
        setupData();
        setUpsert (false);

        System.debug('TEST #6... No match and no Insert.');
        //This should not match on name, but match url.

        QB_UpdateAccount.AccountLight al = new QB_UpdateAccount.AccountLight();
        al.AccountRecordType = 'Supplier';
        al.accountName = 'NO MATCH';
        al.webUrl = 'www.slalom.com';
        al.street = '1 Coloma';
        al.city = 'Irvine';
        al.state = 'CA';
        al.postalCode = '92602';
        al.country = 'USA';
        al.vetify = FALSE;

        QB_UpdateAccount.SFDC_UpdateAccount(al);
        System.assertEquals(200, res.statusCode);
    }
	*/
    static testmethod void updateSupplierAccountNoMatchWithInsert() {
        setupData();
        setUpsert (true);

        System.debug('TEST #7... No match but Insert.');
        //This should not match on name, and do insert

        QB_UpdateAccount.AccountLight al = new QB_UpdateAccount.AccountLight();
        al.AccountRecordType = 'Supplier';
        al.accountName = 'NO MATCH SUPPLIER';
        al.webUrl = 'www.nomatchsupplier.com';
        al.street = '1 Coloma';
        al.city = 'Irvine';
        al.state = 'CA';
        al.postalCode = '92602';
        al.country = 'USA';
        al.billable = true;
        //al.additionalText1 = 'Duns1';
        al.additionalText2 = 'additionalText2';
        al.additionalDate1 = '2016-11-20';
        al.additionalBoolean1 = true;

        String alString = JSON.serialize(al) + '}';
        System.debug(alString);
        //pass the req and resp objects to the method
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Account/SFDC_UpdateAccount';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(alString);
        RestContext.request = req;
        RestContext.response= res;
        
        /*
        QB_UpdateAccount.SFDC_UpdateAccount(al);
        b = res.responseBody;
        System.assertEquals(res.statusCode, 200);
        Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        system.debug('Account:' + a);
        System.assert(a.name.contains('NO MATCH'));
		*/
        QB_UpdateAccount.SFDC_UpdateAccount();
        //b = res.responseBody;
        //System.assertEquals(res.statusCode, 200);
        //Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        //system.debug('Account:' + a);
        System.assert(al.accountName.contains('NO MATCH'));
    }

    static testmethod void updateClientAccountNoMatchWithInsert() {
        setupData();
        setUpsert (true);

        System.debug('TEST #8... No match but Insert Client.');
        //This should not match on name, and do insert

        QB_UpdateAccount.AccountLight al = new QB_UpdateAccount.AccountLight();
        al.AccountRecordType = 'Client';
        al.accountName = 'NO MATCH Client';
        al.webUrl = 'www.nomatchClient.com';
        al.street = '1 Coloma';
        al.city = 'Irvine';
        al.state = 'CA';
        al.postalCode = '92602';
        al.country = 'USA';
        al.billable = true;
        al.parentAccountId = '1234';
        al.globalAccountId = '1234';
        //al.additionalText1 = 'Duns1';
        al.additionalText2 = 'additionalText2';
        al.additionalDate1 = '2016-11-20';
        al.additionalBoolean1 = true;
        
        String alString = JSON.serialize(al) + '}';
        
        //pass the req and resp objects to the method
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Account/SFDC_UpdateAccount';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(alString);
        RestContext.request = req;
        RestContext.response= res;
        
        /*
        QB_UpdateAccount.SFDC_UpdateAccount(al);
        b = res.responseBody;
        System.assertEquals(res.statusCode, 200);
        Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        system.debug('Account:' + a);
        System.assert(a.name.contains('NO MATCH'));
        System.assertEquals(res.statusCode, 200);
		*/
        QB_UpdateAccount.SFDC_UpdateAccount();
        //b = res.responseBody;
        //System.assertEquals(res.statusCode, 200);
        //Account a = (Account) JSON.deserialize(b.toString(), Account.class);
        //system.debug('Account:' + a);
        System.assert(al.accountName.contains('NO MATCH'));
        //System.assertEquals(res.statusCode, 200);
    }

    static testmethod void GetAccountInfoTest() {
        setupData();

        req = new RestRequest();
        res = new RestResponse();

        req.httpMethod = 'GET';
        req.requestURI = '/services/apexrest/account?';
        RestContext.request = req;
        RestContext.response = res;

        QB_UpdateAccount.GetAccountInfo();
        //System.assertEquals(400, res.statusCode);

        req.addParameter ('orgid', '1234');
        QB_UpdateAccount.GetAccountInfo();
        //System.assertEquals(200, res.statusCode);


    }

    // Billable Entity Id


    static testmethod void createAccountWithBillableEntityId() {
        System.debug('START: QB_UpdateAccountTest.createAccountWithBillableEntityId');

        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id = :profileId].Name;
        system.debug('ProfileName' + profileName);

        //ARRANGE - setup request like the external system would....
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();


        // setup data for offices
        setupDataForBillableAccount();


        Account[] accounts = [
                SELECT Id, Organizer_ID__c
                FROM Account
                LIMIT 100
        ];


        System.debug(accounts);

        //pass the req and resp objects to the method


        String urlToCall = Url.getSalesforceBaseUrl() + '/services/apexrest/avetta/account/';


        System.debug(urlToCall);


        QB_UpdateAccount.AccountLight payload = new QB_UpdateAccount.AccountLight();
        payload.AccountRecordType = 'Supplier';
        payload.billingId = '1234';
        payload.street = '1 Coloma';
        payload.city = 'Irvine';
        payload.state = 'CA';
        payload.postalCode = '92602';
        payload.country = 'USA';
        payload.billableEntityId = '0987';
        payload.accountName = 'test';


        req.requestURI = urlToCall;
        //req.addParameter('operatorContractorToUpdate', );

        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(JSON.serialize(payload) + '}');


        RestContext.request = req;
        RestContext.response = res;


        Test.startTest();
        QB_UpdateAccount.SFDC_UpdateAccount();
        Test.stopTest();

        Blob responseBody = res.responseBody;
        System.debug('responseBody');
        System.debug(responseBody.toString());


        Account results = [
                SELECT
                        Id,
                        Billable_Entity__c,
                        Organizer_ID__c
                FROM
                        Account
                WHERE
                        Organizer_ID__c = '1234'
        ];

        System.assertEquals(200, res.statusCode);

        System.assertEquals('1234', results.Organizer_ID__c);


        Id billibleAccountId = [SELECT Id FROM Account WHERE Organizer_ID__c = '0987'].Id;
        System.assertEquals(billibleAccountId, results.Billable_Entity__c);


        System.debug('END: QB_UpdateAccountTest.createAccountWithBillableEntityId');
    }

    static testmethod void updateAccountWithBillableEntityId() {
        System.debug('START: QB_UpdateAccountTest.updateAccountWithOrgId');

        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id = :profileId].Name;
        system.debug('ProfileName' + profileName);

        //ARRANGE - setup request like the external system would....
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();


        // setup data for offices
        setupDataForBillableAccount();

        //pass the req and resp objects to the method


        String urlToCall = Url.getSalesforceBaseUrl() + '/services/apexrest/avetta/account/';


        System.debug(urlToCall);


        QB_UpdateAccount.AccountLight payload = new QB_UpdateAccount.AccountLight();
        payload.AccountRecordType = 'Supplier';
        payload.billingId = '1234';
        payload.street = '1 Coloma';
        payload.city = 'Irvine';
        payload.state = 'CA';
        payload.postalCode = '92602';
        payload.country = 'USA';
        payload.billableEntityId = '0987';

        Id billibleAccountId = [
                SELECT
                        Id
                FROM
                        Account
                WHERE
                        Organizer_ID__c = '0987'
        ].Id;


        req.requestURI = urlToCall;
        //req.addParameter('operatorContractorToUpdate', JSON.serialize(payload));

        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(JSON.serialize(payload) + '}');


        RestContext.request = req;
        RestContext.response = res;


        Test.startTest();
        QB_UpdateAccount.SFDC_UpdateAccount();
        Test.stopTest();

        Account results = [
                SELECT
                        Id,
                        Billable_Entity__c,
                        Organizer_ID__c
                FROM
                        Account
                WHERE
                        Organizer_ID__c = '1234'
        ];

        System.assertEquals(200, res.statusCode);

        System.assertEquals('1234', results.Organizer_ID__c);
        System.assertEquals(billibleAccountId, results.Billable_Entity__c);


        System.debug('END: QB_UpdateAccountTest.updateAccountWithOrgId');
    }

    static testmethod void updateAccountWithToo200MatchesDoesntThrowError() {

        System.debug('START: QB_UpdateAccountTest.updateAccountWithOrgId');


        Id profileId = userinfo.getProfileId();

        String profileName = [Select Id,Name from Profile where Id = :profileId].Name;

        system.debug('ProfileName' + profileName);


        //ARRANGE - setup request like the external system would....

        RestRequest req = new RestRequest();

        RestResponse res = new RestResponse();


        //Create account record

        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);

        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);


        //Create opportunity records

        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id);

        System.debug('after creating contacts in QB_TestDataFactory.createContactRecords' + contactRecords);


        // setup data for offices

        setupDataForBillableAccount();

        //pass the req and resp objects to the method


        String urlToCall = Url.getSalesforceBaseUrl() + '/services/apexrest/avetta/account/';


        System.debug(urlToCall);


        QB_UpdateAccount.AccountLight payload = new QB_UpdateAccount.AccountLight();
        payload.AccountRecordType = 'Supplier';

        //payload.vetify = FALSE;

        payload.accountName = 'test account';

        req.requestURI = urlToCall;
        //req.addParameter('operatorContractorToUpdate', JSON.serialize(payload));

        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(JSON.serialize(payload) + '}');


        RestContext.request = req;
        RestContext.response = res;


        Test.startTest();
        QB_UpdateAccount.SFDC_UpdateAccount();
        Test.stopTest();

        Blob bodyBlob = res.responseBody;


        String bodyBlobString = bodyBlob.toString();
        Boolean success = false;
        Contractor_Match__c responseResults;
        try {
            responseResults = (Contractor_Match__c) JSON.deserialize(bodyBlobString, Contractor_Match__c.class);
            success = true;

        } catch (Exception e) {

        }

        //System.assert(success);

        System.debug('END: QB_UpdateAccountTest.updateAccountWithOrgId');
    }


    static testmethod void createAccountWithVetifyNull() {
        System.debug('START: QB_UpdateAccountTest.createAccountWithBillableEntityId');

        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id = :profileId].Name;
        system.debug('ProfileName' + profileName);

        //ARRANGE - setup request like the external system would....
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();


        // setup data for offices
        setupDataForBillableAccount();


        Account[] accounts = [
                SELECT Id, Organizer_ID__c
                FROM Account
                LIMIT 100
        ];


        System.debug(accounts);

        //pass the req and resp objects to the method


        String urlToCall = Url.getSalesforceBaseUrl() + '/services/apexrest/avetta/account/';


        System.debug(urlToCall);


        QB_UpdateAccount.AccountLight payload = new QB_UpdateAccount.AccountLight();
        payload.AccountRecordType = 'Supplier';
        payload.billingId = '1234';
        payload.street = '1 Coloma';
        payload.city = 'Irvine';
        payload.state = 'CA';
        payload.postalCode = '92602';
        payload.country = 'USA';
        payload.billableEntityId = '0987';
        payload.accountName = 'test';

        //payload.vetify = null;


        req.requestURI = urlToCall;
        //req.addParameter('operatorContractorToUpdate', JSON.serialize(payload));

        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(JSON.serialize(payload) + '}');


        RestContext.request = req;
        RestContext.response = res;


        Test.startTest();
        QB_UpdateAccount.SFDC_UpdateAccount();
        Test.stopTest();

        Blob responseBody = res.responseBody;
        System.debug('responseBody');
        System.debug(responseBody.toString());


        Account results = [
                SELECT
                        Id,
                        Billable_Entity__c,
                        Organizer_ID__c
                FROM
                        Account
                WHERE
                        Organizer_ID__c = '1234'
        ];

        System.assertEquals(200, res.statusCode);

        System.assertEquals('1234', results.Organizer_ID__c);


        Id billibleAccountId = [SELECT Id FROM Account WHERE Organizer_ID__c = '0987'].Id;
        System.assertEquals(billibleAccountId, results.Billable_Entity__c);


        System.debug('END: QB_UpdateAccountTest.createAccountWithBillableEntityId');
    }


    static testmethod void updateAccountWithVetifyNull() {
        System.debug('START: QB_UpdateAccountTest.updateAccountWithOrgId');

        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id = :profileId].Name;
        system.debug('ProfileName' + profileName);

        //ARRANGE - setup request like the external system would....
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();


        // setup data for offices
        setupDataForBillableAccount();

        //pass the req and resp objects to the method


        String urlToCall = Url.getSalesforceBaseUrl() + '/services/apexrest/avetta/account/';


        System.debug(urlToCall);


        QB_UpdateAccount.AccountLight payload = new QB_UpdateAccount.AccountLight();
        payload.AccountRecordType = 'Supplier';
        payload.billingId = '1234';
        payload.street = '1 Coloma';
        payload.city = 'Irvine';
        payload.state = 'CA';
        payload.postalCode = '92602';
        payload.country = 'USA';
        payload.billableEntityId = '0987';

        //payload.vetify = null;

        Id billibleAccountId = [
                SELECT
                        Id
                FROM
                        Account
                WHERE
                        Organizer_ID__c = '0987'
        ].Id;


        req.requestURI = urlToCall;
        //req.addParameter('operatorContractorToUpdate', JSON.serialize(payload));

        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(JSON.serialize(payload) + '}');


        RestContext.request = req;
        RestContext.response = res;


        Test.startTest();
        QB_UpdateAccount.SFDC_UpdateAccount();
        Test.stopTest();

        Account results = [
                SELECT
                        Id,
                        Billable_Entity__c,
                        Organizer_ID__c
                FROM
                        Account
                WHERE
                        Organizer_ID__c = '1234'
        ];

        System.assertEquals(200, res.statusCode);

        System.assertEquals('1234', results.Organizer_ID__c);
        System.assertEquals(billibleAccountId, results.Billable_Entity__c);


        System.debug('END: QB_UpdateAccountTest.updateAccountWithOrgId');
    }

    /*
    static testMethod void insertMatch(){


        QB_UpdateAccount.AccountLight payload = new QB_UpdateAccount.AccountLight();
        payload.accountRecordType = '01270000000MRzn';
//        payload.OrganizerId = '1234';
        payload.street = '1 Coloma';
        payload.city = 'Irvine';
        payload.state = 'CA';
        payload.postalCode = '92602';
        payload.country = 'USA';
        payload.billableEntityId = '0987';
        payload.accountName = 'test';
        payload.vetify = true;


        Account match = QB_UpdateAccount.insertAccountMatch(payload, new List<Account>());

        System.assertEquals(payload.accountName, match.Name);
        System.assertEquals(payload.city, match.BillingCity);
        System.assertEquals(payload.state, match.BillingState);
        System.assertEquals(payload.postalCode, match.BillingPostalCode);


    }
	*/
}