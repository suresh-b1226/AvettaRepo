@isTest
private class unsubscribeTest {
    // The following test methods provide adequate code coverage 
    // for the unsubscribe email class.
    // There are two methods, one that does the testing
    // with a valid "unsubcribe" in the subject line
    // and one that does not contain "unsubscribe" in the
    // subject line.        
    static testMethod void testUnsubscribe() {
    
       // Create a new email and envelope object.
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
       //Create account so that the contact can be created
       Account a = new Account(name='AccountTest', 
                billingcity='New York', billingcountry='US', Organizer_Id__c='123', CurrencyIsoCode = 'USD', Status__c='Active');
       insert a;
        
       // Create a new test contact and insert it in the test method.
       Contact c = new Contact(firstName='john', 
                    lastName='smith', 
                    Email='user@acme.com', 
                    No_Marketing_to_this_Contact__c=false,
                    AccountId = a.Id);
       insert c;
       
       // Test with the subject that matches the unsubscribe statement.
       email.subject = 'test unsubscribe test';
       env.fromAddress = 'user@acme.com';
       
       // Call the class and test it with the data in the testMethod.
       EmailUnsubscribe unsubscribeObj = new EmailUnsubscribe();
       unsubscribeObj.handleInboundEmail(email, env );
                            
    }
     
    static testMethod void testUnsubscribe2() {
    
       // Create a new email and envelope object.
       Messaging.InboundEmail email = new Messaging.InboundEmail();
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    
        //Create account so that the contact can be created
       Account a = new Account(name='AccountTest', 
                billingcity='New York', billingcountry='US', Organizer_Id__c='123', CurrencyIsoCode = 'USD', Status__c='Active');
       insert a;
        
       // Create a new test contact and insert it in the test method.    
       Contact c = new Contact(firstName='john', 
                    lastName='smith', 
                    Email='user@acme.com', 
                    No_Marketing_to_this_Contact__c=false,
                    AccountId = a.Id);
       insert c;
       
       // Test with a subject that does not contain "unsubscribe."
       email.subject = 'test';
       env.fromAddress = 'user@acme.com';
    
       // Call the class and test it with the data in the test method.
       EmailUnsubscribe unsubscribeObj = new EmailUnsubscribe();
       unsubscribeObj.handleInboundEmail(email, env );                      
    }     
}