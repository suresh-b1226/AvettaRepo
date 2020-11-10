@isTest
public class QB_UpdateContactTest {

    static RestRequest req = new RestRequest();
    static RestResponse res = new RestResponse();
    static blob b;

    static Contact orgC = new Contact();
    static Contact boeingC = new Contact();
    static Contact SlalomC = new Contact();
    static Contact boeing2 = new Contact();
    static Account a2WithOrgId = new Account();
    static Account boeing = new Account();
    static Account slalom = new Account();

    static private void setupData() {
        // setup the request 
        req.httpMethod = 'PUT';
        req.requestURI = '/services/apexrest/avetta/Contact';
        RestContext.request = req;
        RestContext.response = res;
        Id recordTypeId;
        Id CrecordTypeId;

        recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        CrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();

        // setup the settings
        System.Debug ('setting data');
        API_Settings__c setting = new API_Settings__c();
        setting.admin_id__c = UserInfo.getUserId();
        setting.name = 'UpdateContact API';

        setting.additionalText2__c = 'Designations__c';
        setting.additionalDate1__c = 'Date_MQL__c';
        setting.additionalBoolean1__c = 'Sync_with_Marketo__c';
        Database.insert(setting);


        a2withOrgId.name = 'OrgId:1234';
        a2withOrgId.Organizer_Id__c = '1234';
        a2withOrgId.RecordTypeId = CrecordTypeId;
        a2withOrgId.status__c = 'Active';

        boeing.name = 'boeing Inc';
        boeing.RecordTypeId = CrecordTypeId;
        boeing.Organizer_Id__c = '2222';
        boeing.status__c = 'Prospect';

        slalom.Website = 'www.slalom.com';
        slalom.name = 'slalom';
        slalom.RecordTypeId = recordTypeId;
        slalom.status__c = 'Prospect';

        Database.insert(a2WithOrgId);
        Database.insert(boeing);
        Database.insert(slalom);


        orgC.LastName = 'OrgId:1234 Contact';
        orgC.AccountId = a2WithOrgId.id;
        orgC.email = 'orgid@orgid.com';
        orgC.Organizer_User_ID__c = '1';

        boeingC.LastName = 'Boeing Contact';
        boeingC.AccountId = boeing.Id;
        boeingC.email = 'boeing@boeing.com';
        boeingC.Organizer_User_ID__c = '2';

        SlalomC.LastName = 'Slalom Contact';
        SlalomC.AccountId = slalom.Id;
        SlalomC.email = 'Slalom@slalom.com';

        // used for email match. No user id
        boeing2.LastName = 'Slalom Contact';
        boeing2.AccountId = boeing.Id;
        boeing2.email = 'email@email.com';

        Database.insert(orgC);
        Database.insert(boeingC);
        Database.insert(slalomC);
        Database.insert(boeing2);
    }

    static testmethod void updateContactErrors() {
        // setup data for offices
        setupData();
        System.debug('TEST #1... ERROR CASES ');
        //pass the req and resp objects to the method     

        QB_UpdateContact.ContactLight cl = new QB_UpdateContact.ContactLight();

        // no account id passed
        QB_UpdateContact.SFDC_UpdateContact(cl);
        System.assertEquals(res.statusCode, 400);
        system.debug ('respone' + res);
        b = res.responseBody;
        System.debug('b.toString: ' + b.toString());
        System.assert(b.toString().contains('accountId is missing'));

        // no organizer id passed
        cl.accountId = '1234';
        QB_UpdateContact.SFDC_UpdateContact(cl);
        System.assertEquals(res.statusCode, 400);
        system.debug ('respone' + res);
        b = res.responseBody;
        System.debug('b.toString: ' + b.toString());
        System.assert(b.toString().contains('organizerUserId is missing'));

        // account id, orgnizer id is passed but account id is invalid
        cl.accountId = '9';  // invalid account number
        cl.connectUserId = '1234';
        QB_UpdateContact.SFDC_UpdateContact(cl);
        System.assertEquals(res.statusCode, 400);
        system.debug ('respone' + res);
        b = res.responseBody;
        System.debug('b.toString: ' + b.toString());
        System.assert(b.toString().contains('Invalid Account Id: Account Not found'));
    }

    static testmethod void InsertContactWithOrgId() {
        // setup data for offices
        setupData();

        System.debug('TEST #2... INSERT CONTACT ');
        //pass the req and resp objects to the method     

        // match on a2withOrgid
        QB_UpdateContact.ContactLight cl = new QB_UpdateContact.ContactLight();
        cl.accountId = '1234';
        cl.connectUserId = '10';
        cl.department = 'new department';
        cl.email = 'new@new.com';
        cl.firstName = 'new contact';
        cl.lastName = 'new last name';
        cl.language = 'en';
        cl.connectCreateDate = System.today();
        cl.connectLastLogin = System.today();
        cl.connectUsername = 'goodone';
        cl.connectisActive = 'true';
        cl.phone = '111-111-1111';
        cl.timezone = 'PST';
        cl.title = 'Doctor';
        cl.street = '1 Coloma';
        cl.city = 'Irvine';
        cl.state = 'CA';
        cl.country = 'USA';
        cl.postalCode = '92602';
        //cl.primaryPICS = false;


        cl.additionalText2 = '	Designations__c';
        cl.additionalDate1 = '2011-2-19';
        cl.additionalBoolean1 = true;

        QB_UpdateContact.SFDC_UpdateContact(cl);
        b = res.responseBody;
        System.debug('res.responseBody:');
        System.debug(b);
        String bString = b.toString();
        Contact c = (Contact) JSON.deserialize(bString, Contact.class);
        system.debug('Contact:' + c);
        System.assert(c.lastName.contains('new last name'));
        System.assertEquals(200, res.statusCode);
    }

    static testmethod void updateContactWithOrgId() {
        // setup data for offices
        setupData();

        System.debug('TEST #3... UPDATE CONTACT');
        //pass the req and resp objects to the method     

        // match on a2withOrgid
        QB_UpdateContact.ContactLight cl = new QB_UpdateContact.ContactLight();
        cl.accountId = '1234';
        cl.connectUserId = '1';
        cl.department = 'good department';
        cl.email = 'good@good.com';
        cl.firstName = 'good contact';
        cl.lastName = 'good last name';
        cl.language = 'en';
        cl.connectCreateDate = System.today();
        cl.connectLastLogin = System.today();
        cl.connectUsername = 'goodone';
        cl.connectIsActive = 'true';
        cl.phone = '111-111-1111';
        cl.timezone = 'PST';
        cl.title = 'Doctor';
        cl.street = '1 Coloma';
        cl.city = 'Irvine';
        cl.state = 'CA';
        cl.country = 'USA';
        cl.postalCode = '92602';

        cl.additionalText2 = '	Designations__c';
        cl.additionalDate1 = '2011-2-19';
        cl.additionalBoolean1 = true;

        QB_UpdateContact.SFDC_UpdateContact(cl);
        b = res.responseBody;
        Contact c = (Contact) JSON.deserialize(b.toString(), Contact.class);
        system.debug('Contact:' + c);
        System.assert(c.LastName.contains('good last name'));
        System.assertEquals(200, res.statusCode);
        Contact c1 = [select id, FirstName, LastName, Name from Contact where id = :c.id];
        System.debug('new contact after update:' + c1);
    }

    static testmethod void updateContactWithEmail() {
        // setup data for offices
        setupData();

        System.debug('TEST #4... UPDATE CONTACT with email match');
        //pass the req and resp objects to the method     

        // match on a2withOrgid
        QB_UpdateContact.ContactLight cl = new QB_UpdateContact.ContactLight();
        cl.accountId = '2222';
        cl.connectUserId = '7';
        cl.department = 'good department';
        cl.email = 'email@email.com';
        cl.firstName = 'boeing contact';
        cl.lastName = 'boeing last name';
        cl.language = 'en';
        cl.connectCreateDate = System.today();
        cl.connectLastLogin = System.today();
        cl.connectUsername = 'boeinguserid';
        cl.connectIsActive = 'true';
        cl.phone = '111-111-1111';
        cl.timezone = 'PST';
        cl.title = 'Doctor';
        cl.street = '1 Coloma';
        cl.city = 'Irvine';
        cl.state = 'CA';
        cl.country = 'USA';
        cl.postalCode = '92602';

        cl.additionalText2 = '	Designations__c';
        cl.additionalDate1 = '2011-2-19';
        cl.additionalBoolean1 = true;

        QB_UpdateContact.SFDC_UpdateContact(cl);
        b = res.responseBody;
        Contact c = (Contact) JSON.deserialize(b.toString(), Contact.class);
        system.debug('Contact:' + c);
        //System.assert(c.Email.contains('email@email.com'));
        System.assertEquals(200, res.statusCode);
        Contact c1 = [select id, FirstName, LastName, Name from Contact where id = :c.id];
        System.debug('new contact after update:' + c1);
    }


    static testmethod void UpdateContractMatch() {
        System.debug('START: UpdateContractMatch');
        setupData();

        Contractor_Match__c match = new Contractor_Match__c(OrganizerId__c = 'account' + Date.today());

        insert match;


        QB_UpdateContact.ContactLight contactLight = new QB_UpdateContact.ContactLight();

        contactLight.firstName = 'first';
        contactLight.lastName = 'last';
        contactLight.email = 'email@test.org';
        contactLight.accountId = match.OrganizerId__c;
        contactLight.connectUserId = 'user' + Date.today();

        QB_UpdateContact.SFDC_UpdateContact(contactLight);

        Contractor_Match__c results = [
                SELECT

                        email__c,

                        firstName__c,
                        Id,

                        lastName__c,

                        Name,
                        OrganizerId__c

                FROM Contractor_Match__c
                WHERE Id = :match.Id
        ];

        System.assertEquals(contactLight.email, results.email__c);
        System.assertEquals(contactLight.firstName, results.firstName__c);
        System.assertEquals(contactLight.lastName, results.lastName__c);
        System.assertEquals(contactLight.accountId, results.OrganizerId__c);
//        System.assertEquals(contactLight.organizerUserId, results.?);


        System.debug('END: UpdateContractMatch');
    }

}