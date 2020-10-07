@isTest public class API_CS_Callminer_Audio_Test implements HttpCalloutMock {
    
    @isTest static void Callminer_API_Test() {
        User thisUser = [ SELECT Id FROM User WHERE Id = :UserInfo.getUserId() ];
		
        System.runAs ( thisUser ) {
        List<Account> accts = QB_TestDataFactory.createAccountRecords(1, TRUE);
        List<Case> cases = QB_TestDataFactory.createCaseRecords(1, TRUE, accts[0].Id);
        List<Contact> contacts = QB_TestDataFactory.createContactRecords(1, TRUE, accts[0].Id);
        List<talkdesk__Talkdesk_Activity__c> ta = QB_TestDataFactory.createTalkDeskActivityRecord(1, FALSE, accts[0].Id, cases[0].Id, contacts[0].Id);
        List<User> users = QB_TestDataFactory.createUserRecords(1, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');
        
        //ta[0].talkdesk__Start_Date__c = System.Today();
        ta[0].talkdesk__Recording__c = 'https://www2.cs.uic.edu/~i101/SoundFiles/CantinaBand3.wav';
        //ta[0].talkdesk__Talkdesk_Id__c);
        ta[0].talkdesk__User__c = Users[0].Id;
        ta[0].talkdesk__Ring_Groups__c = 'verification';
        //ta[0].talkdesk__Account__c = '11111';
        ta[0].talkdesk__Hold_Time_sec__c = 26;
        ta[0].Name = 'Inbound call';
        ta[0].talkdesk__Notes__c = 'Question about annual update';
        ta[0].talkdesk__Disposition_Code__c = 'Successful';
        ta[0].talkdesk__Wait_Time_sec__c = 90;
        ta[0].talkdesk__Contact_Phone__c = '5555555555';
        ta[0].talkdesk__Talkdesk_Phone_Number__c = '18002342222';
        ta[0].talkdesk__UserEmail__c = 'test@avetta.com';
        ta[0].talkdesk__Talk_Time_sec__c = 10;
        ta[0].talkdesk__Type__c = 'Inbound';
        
        insert ta[0];
        
        System.assert(ta[0].Id != NULL);
        }
    }
    
	public static HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"SessionId": "63a6049e-4fd2-44bb-9f66-dfb98bfa963f", "CorrelationId": "CA1c96b2f651442270894a291f2b28b775"}');
        res.setStatusCode(200);
        return res;
    }
    
}