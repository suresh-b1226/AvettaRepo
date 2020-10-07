@isTest
public class QB_Utils_Test
{
    
    static RestRequest req = new RestRequest(); 
    static RestResponse res = new RestResponse();
    static blob b;
    static string pid;
    static Id recordTypeId;
    static Id CrecordTypeId;
    
    static private void setupData()
    {
        // setup the request 
        req.httpMethod = 'PUT';
        req.requestURI = '/services/apexrest/avetta/account';   
        RestContext.request = req;
        RestContext.response = res;        
        
        recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        CrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        
        // setup the settings
        System.Debug ('setting data');
        API_Settings__c setting = new API_Settings__c();
        setting.name = 'Update API';
        setting.Insert_Account_When_Not_Found__c = false;
        setting.admin_id__c = UserInfo.getUserId();
        setting.additionalText1__c = 'DunsNumber';
        setting.additionalText2__c = 'sic';
        setting.additionalDate1__c = 'Health_Modified_Date__c';
        setting.additionalBoolean1__c = 'IsBillable__c';
        Database.insert(setting);
        
        Contact contact1 = new Contact();
        contact1.FirstName = 'Dallin';
        contact1.LastName = 'Wasden';
        contact1.Email = 'test@slalom.com';
        Database.insert(contact1);

        Contact contact2 = new Contact();
        contact2.FirstName = 'Dallin';
        contact2.LastName = 'Wasden';
        contact2.Email = 'test@avetta.com';
        Database.insert(contact2);
        
        Account a1WithSuid  = new Account();
        Account a2WithOrgId = new Account();
        Account boeing      = new Account();
        Account slalom      = new Account();
        Account ph1111      = new Account();
        Account domainMatch = new Account();

        a1WithSuid.name = 'withSUID';
        a1WithSuid.RecordTypeId = recordTypeId;
        a1WithSuid.status__c = 'Prospect';
        a1WithSuid.BillingCity = 'Orem';
        a1WithSuid.BillingCountry = 'US';
        a1WithSuid.BillingState = 'Utah';
        a1WithSuid.BillingPostalCode = '84097';
        a1WithSuid.BillingStreet = '123 Easy Way';
        //a1WithSuid.Pre_Registration_Tags__c = '235265326';
        //a1WithSuid.ExternalIds__c = '3463636';
        
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
        slalom.Primary_Contact__c = contact1.Id;
        
        ph1111.name = '111-111-1111';
        ph1111.phone = '111-111-1111';
        ph1111.RecordTypeId = recordTypeId;
        ph1111.status__c = 'Prospect';

        domainMatch.name = 'Test Test Domain';
        domainMatch.Primary_Contact__c = contact2.Id;
        domainMatch.RecordTypeId = recordTypeId;
        domainMatch.status__c = 'Prospect';
        domainMatch.BillingCountry = 'US';
        domainMatch.BillingState = 'UT';

        Database.insert(a1WithSuid);
        Database.insert(a2WithOrgId);  
        Database.insert(boeing);
        Database.insert(slalom);
        Database.insert(ph1111);
        Database.insert(domainMatch);
        
        a1WithSuid = [select id, name, PID__c from account where id = :a1WithSuid.id];
        pid = a1WithSuid.PID__c;
        
        system.debug ('a1WithSuid' + a1WithSuid.PID__c);
        system.debug ('a2WithOrgId' + a2WithOrgId);
        system.debug ('boeing' + boeing);
        system.debug ('slalom' + slalom);
        system.debug ('ph1111' + ph1111);
        system.debug ('domainMatch' + domainMatch);
    }
    
    static testmethod void testCreateTask () 
    {
    String oneAccount;
    
    setupData();
    
    oneAccount = QB_Utils.QB_FindExactAccount (pid, NULL );
    system.debug ('Exact pid  Match' + oneAccount);      
    //QB_Utils.createTask ( oneAccount, 'Test Task', UserInfo.getUserId());
    }
    
    static testmethod void testFindAccount () 
    {
        List<Account> a = new List<account>();
        String oneAccount;
        
        setupData();
        
        //(Id recordTypeId, string name, string email, string city, string state, string country, string pnumber, string url, string domain)
        
        a = QB_Utils.QB_FindProspectAccount (crecordTypeId, 'BOEING INC', 'IRVINE', NULL, NULL, NULL, NULL, NULL, NULL);
        system.debug ('name match' + a);
        
        a = QB_Utils.QB_FindProspectAccount (recordTypeId, NULL, NULL, '(111)111-1111', NULL, NULL, NULL, NULL, NULL);
        system.debug ('phone match' + a);
        
        a = QB_Utils.QB_FindProspectAccount (recordTypeId, 'Big&^Sky. Pilots', 'test@slalom.com', 'IRVINE', 'CA', 'US', '(111)111-1111', 'www.slalom.com', 'test@slalom.com');
        system.debug ('URL Match' + a);

        a = QB_Utils.QB_FindProspectAccount (recordTypeId, null, 'test1@avetta.com', 'Orem', 'UT', 'US',  null, null, 'test@avetta.com');
        system.debug ('Domain Match' + a);

        oneAccount = QB_Utils.QB_FindExactAccount (NULL, '1234' );
        system.debug ('Exact organizer id Match' + oneAccount);

        oneAccount = QB_Utils.QB_FindExactAccount (pid, NULL );
        system.debug ('Exact suid  Match' + oneAccount);         
    }

    static testmethod void testFindTwoMatches () 
    {
        recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        Contact contact1 = new Contact();
        contact1.FirstName = 'Dallin';
        contact1.LastName = 'Wasden';
        contact1.Email = 'test@slalom.com';
        Database.insert(contact1);
        
        Account slalom = new Account();
        
        slalom.Website = 'www.slalom.com';
        slalom.name = 'slalom2';
        slalom.RecordTypeId = recordTypeId;
        slalom.status__c = 'Prospect';
        slalom.Primary_Contact__c = contact1.Id;
        slalom.BillingCity = 'Orem';
        slalom.BillingCountry = 'US';
        slalom.BillingState = 'Utah';
        slalom.BillingPostalCode = '84097';
        slalom.BillingStreet = '123 Easy Way';
        
        Database.insert(slalom);
        
        List<Account> a = new List<account>();
        String oneAccount;
        
        setupData();
        
        //(Id recordTypeId, string name, string email, string city, string state, string country, string pnumber, string url, string domain)
        
        a = QB_Utils.QB_FindProspectAccount (crecordTypeId, 'BOEING INC', 'IRVINE', NULL, NULL, NULL, NULL, NULL, NULL);
        system.debug ('name match' + a);
        
        a = QB_Utils.QB_FindProspectAccount (recordTypeId, NULL, NULL, '(111)111-1111', NULL, NULL, NULL, NULL, NULL);
        system.debug ('phone match' + a);
        
        a = QB_Utils.QB_FindProspectAccount (recordTypeId, 'Big&^Sky. Pilots', 'test@slalom.com', 'IRVINE', 'CA', 'US', '(111)111-1111', 'www.slalom.com', 'test@slalom.com');
        system.debug ('URL Match' + a); 

        oneAccount = QB_Utils.QB_FindExactAccount (NULL, '1234' );
        system.debug ('Exact organizer id Match' + oneAccount);

        oneAccount = QB_Utils.QB_FindExactAccount (pid, NULL );
        system.debug ('Exact pid  Match' + oneAccount);         
    }
}