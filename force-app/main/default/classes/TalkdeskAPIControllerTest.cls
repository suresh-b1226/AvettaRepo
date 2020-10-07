@istest
public class TalkdeskAPIControllerTest {
	   @istest static void testPostCalloutSupport() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User u = new user();
        u.isActive = TRUE;
        u.LastName = 'Test Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'test+avetta@talkdesk.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = profileId.id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        
       	User p =[SELECT ID,isActive,username FROM User WHERE username='test+avetta@talkdesk.com' and isActive=TRUE];
        System.debug('USER-- '+u);
        System.debug('USER-- '+p.username);
        
        Account a = new Account();
        a.name = 'Test 1';
        a.Organizer_ID__c='12345';
        a.ownerID=p.ID;
        insert a;
        System.debug('Account Owner --- '+a.ownerID);
        
    
        Test.startTest();      
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/talkdeskAPI';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        TalkdeskAPIController.getEmailFromID('support','12345');
        Test.stopTest();  
     }
    @istest static void testPostCalloutRegistration() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User u = new user();
        u.isActive = TRUE;
        u.LastName = 'Test Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'test+avetta@talkdesk.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = profileId.id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        
       	User p =[SELECT ID,isActive,username FROM User WHERE username='test+avetta@talkdesk.com' and isActive=TRUE];
        System.debug('USER-- '+u);
        System.debug('USER-- '+p.username);
        
        Account a = new Account();
        a.name = 'Test 1';
        a.Organizer_ID__c='12345';
        a.ownerID=p.ID;
        insert a;
        Account d = [SELECT ID from Account where name='Test 1'];
        
     	system.debug('WILL NOW CREATE THE OPPORTUNITY');
        Id rtname = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.type = 'Registration';
        opp.StageName = 'Prospect';
        opp.CloseDate = date.parse('01/01/2019');
        opp.AccountId = d.ID;
        opp.Name = 'Test';
        opp.OwnerId = p.ID;
        opp.RecordtypeID = rtname;
        insert opp;
     	//opp.CurrencyIsoCode = 'USD';
      	
		
        
        system.debug('OPPORTUNITY CREATED');
        
        Test.startTest();      
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/talkdeskAPI';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        TalkdeskAPIController.getEmailFromID('registration','12345');
        Test.stopTest();  
     }
     @istest static void testPostCalloutRegistrationandemail() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'SER' LIMIT 1];
	
        User u = new user();
        u.isActive = TRUE;
        u.LastName = 'Test Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'test+avetta@talkdesk.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = profileId.id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.UserRole=[select Id,Name from UserRole where Name='Registration' limit 1][0];
        insert u;
         
         system.Debug('USER ROLE -----'+u.UserRole.Name) ;
   
       	User p =[SELECT ID,isActive,username FROM User WHERE username='test+avetta@talkdesk.com' and isActive=TRUE];
        System.debug('USER-- '+u);
        System.debug('USER-- '+p.username);
        
        Account a = new Account();
        a.name = 'Test 1';
        a.Organizer_ID__c='12345';
        a.ownerID=p.ID;
        insert a;
        Account d = [SELECT ID from Account where name='Test 1'];

        Id rtname = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.type = 'Registration';
        opp.StageName = 'Prospect';
        opp.CloseDate = date.parse('01/01/2019');
        opp.AccountId = d.ID;
        opp.Name = 'Test';
        opp.OwnerId =u.ID;
        opp.RecordtypeID = rtname;
        insert opp;
         
        Task t = new Task();
        t.WhatId = opp.id;
        t.Subject = 'Activity '+ opp.Id;
        t.Status = 'Completed';
        t.Description = 'test notes';
        t.Type = 'Call';
        t.ActivityDate = system.date.today();
        insert t;
         
        

		system.debug('last activity date ---- ' + opp.LastActivityDate);         
        system.debug('OPP RIGHT HERE---- '+ opp);
        Test.startTest();      
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/talkdeskAPI';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        TalkdeskAPIController.getEmailFromID('registration','12345');
        TalkdeskAPIController.getEmailFromID('registration','');
        Test.stopTest();  
     }
}