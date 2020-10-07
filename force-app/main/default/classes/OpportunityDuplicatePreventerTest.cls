@isTest 
public class OpportunityDuplicatePreventerTest {
    
    static testMethod void CreateAccounts() {
    Id ContractorRecordTypeId;
    Id OperatorRecordTypeId;
    Id SupplierOptyRecordTypeId;
    Date Closing = Date.Today();

    ContractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
    OperatorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
    SupplierOptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();      
    
    
        
	Test.startTest();
   		// Setup test data
      // This code runs as the system user
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='EmailAddresssarentimportant@avetta.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='TorrenisAwesome@avetta.com'); 
      
    System.runAs(u){   
        Account Supplier = new Account();
            Supplier.RecordTypeId=ContractorRecordTypeId;
            Supplier.Name ='Supplier Account of Wonder and Awe';
            Supplier.status__c = 'Prospect';
        Account Operator1 = new Account();
            Operator1.RecordTypeId=OperatorRecordTypeId;
            Operator1.Name='3rd Eye Consulting';
            Operator1.status__c = 'Prospect';
         Account Operator2 = new Account();
            Operator2.RecordTypeId=OperatorRecordTypeId;
            Operator2.Name='Some really great Account';
            Operator2.status__c = 'Prospect';
        Database.insert(Supplier);
        Database.insert(Operator1); 
        Database.insert(Operator2);
      
        Opportunity Opty1 = new Opportunity();    
            Opty1.Name ='First Opty';
            Opty1.AccountId=Supplier.Id;
            Opty1.Type='Registration';
            Opty1.CloseDate=Closing;
            Opty1.Client_Account__c=Operator1.Id;
            Opty1.StageName='In Progress';
            Opty1.RecordTypeId=SupplierOptyRecordTypeId;
        	Opty1.Result__c='Result';
        Database.insert(Opty1);
        Opportunity Opty2 = new Opportunity();    
            Opty2.Name='Second Opty';
            Opty2.AccountId=Supplier.Id;
            Opty2.Type='Registration';
            Opty2.CloseDate=Closing;
            Opty2.Client_Account__c=Operator2.Id;
            Opty2.StageName='In Progress';
            Opty2.RecordTypeId=SupplierOptyRecordTypeId;
        	Opty2.Result__c='Result\'s matter';
        Database.insert(Opty2);
        
                Test.stopTest();}
}
   /* This needs to be finished for this test class to be done, but we wanted to get something out. 
     static testMethod void DuplicateOptys(){
        
        
        Opportunity Opty1 = new Opportunity();    
        	Name='First ';
            Account='';
            Type='';
            CloseDate='';
            ClientAccount='';
            StageName='';
        Database.insert(Operator2);
        Opportunity Opty2 = new Opportunity();    
        	Name='First ';
            Account='';
            Type='';
            CloseDate='';
            ClientAccount='';
            StageName='';
        Database.insert(Operator2);
        
    }
   
    */
            
            
}