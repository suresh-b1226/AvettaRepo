@isTest public class API_CS_Callminer_Email_Test implements HttpCalloutMock {
    
    @isTest static void Callminer_API_Email_Test() {
        User thisUser = [ SELECT Id FROM User WHERE Id = :UserInfo.getUserId() ];
		
        System.runAs ( thisUser ) {
        //Set up conditions to send email
        List<Account> accounts = QB_TestDataFactory.createAccountRecords(1, TRUE);        
        List<Case> cases = QB_TestDataFactory.createCaseRecords(1, TRUE, accounts[0].Id);
        List<Contact> contacts = QB_TestDataFactory.createContactRecords(1, TRUE, accounts[0].Id);
        List<EmailMessage> email = QB_TestDataFactory.createEmailMessage(1, FALSE, cases[0].Id, accounts[0].Id); 
        List<User> users = QB_TestDataFactory.createUserRecords(1, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');
        
        email[0].CreatedBy = users[0];
        email[0].ToAddress = 'tester@test.com';
        email[0].TextBody = 'test email here';
        email[0].FromAddress = 'test@test.com';
		system.debug('PRINT ' + email); 
        
        insert email[0];            
            
        System.assert(email[0].Id != NULL);
        }
    }

    public static HTTPResponse respond(HTTPRequest req) {
        //mock response callout here
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"CorrelationId":"02s0q000000vUuhAAE","MiningId":"70c5a3a3-83d6-4e70-b827-01706996dedf"}');
        res.setStatusCode(200);
        return res;
    }
}