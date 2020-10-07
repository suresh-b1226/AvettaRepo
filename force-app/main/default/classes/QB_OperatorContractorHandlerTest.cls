@isTest
private class QB_OperatorContractorHandlerTest {
	
	@isTest static void testuppdatOperactorContractor() {


        QB_TestDataFactory.createSITCustomSetting(TRUE);
		System.debug('') ;       
        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, TRUE);
        
        QB_TestDataFactory.createSITCustomSetting(TRUE);
		System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;  
        accountRecords[0].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(); 
        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(); 
        accountRecords[1].Vetify_Position__c = 'Client Opt In';
        
        update accountRecords; 
		System.debug('after updating account record type') ;
        List<Operator_Contractor__c> operatorContractorRecords = QB_TestDataFactory.createOperatorContractorRecords(1, TRUE, accountRecords[1].id, accountRecords[0].id);
		System.debug('after creating opps in QB_TestDataFactory.createOperatorContractorRecords') ;
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecordsWithClientId(1, TRUE, accountRecords[0].id, accountRecords[1].id);

        //opportunityRecords[0].Client_Account__c = accountRecords[1].id;

        //update opportunityRecords;
		System.debug('after updating opportunitys in test method') ;        
        System.debug('****************** Insert Account and Operator Contractor record...');
        
        List<Account>  acc = new List<Account>(); 
        
        Test.startTest();

        operatorContractorRecords[0].Initial_Payment_Made__c = TRUE;
        
        update operatorContractorRecords;

        System.debug('****************** Operator Contractor Record update...');

        //Operator_Contractor__c testOpCon = [Select Id, Initial_Payment_Made__c From Operator_Contractor__c WHERE Id =: accountRecords[0].id];
        //system.assert(testOpCon.Initial_Payment_Made__c != FALSE);
        //system.assert(!String.isBlank(testOpp.Client_Account__c)); 
        
        
        List<Opportunity>  opp = [Select Id, Client_Account__c From Opportunity WHERE Client_Account__c =: accountRecords[1].id]; 
        //system.assert(opp.size() == 0); 
        
        Test.stopTest();
	}
	
	@isTest static void testSEREnabledStatus() {


        QB_TestDataFactory.createSITCustomSetting(TRUE);
		System.debug('') ;       

        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, TRUE);
        List<Case> caseRecord = QB_TestDataFactory.createCaseRecords(1, TRUE, accountRecords[0].id);
        List<Contact> contactRecord = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id);
        
        QB_TestDataFactory.createSITCustomSetting(TRUE);
		System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;  
        accountRecords[0].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(); 
        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(); 
        accountRecords[1].Vetify_Position__c = 'Client Opt In';
        
        update accountRecords; 

		// Create an opportunity
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecordsWithClientId(1, TRUE, accountRecords[0].id, accountRecords[1].id);
        
        //Create Talkdesk Activity
        List<talkdesk__Talkdesk_Activity__c> talkdeskRecord = QB_TestDataFactory.createTalkDeskActivityRecord(1, TRUE, accountRecords[0].id, caseRecord[0].id, contactRecord[0].id);
        
		// Make a call to the supplier
		Task callTask = new Task( 
			whatid = opportunityRecords[0].id,
			type = 'call',
            subject = 'call'
		);
		insert callTask;
		
        talkdesk__Talkdesk_Activity__c talkActivity = new talkdesk__Talkdesk_Activity__c(
        	talkdesk__Talkdesk_Id__c = talkdeskRecord[0].id,
            talkdesk__Opportunity__c = opportunityRecords[0].id,
        	talkdesk__Type__c = 'call');
		
		insert talkActivity;        
		        
		// Supplier makes a connection	
        List<Operator_Contractor__c> operatorContractorRecords = QB_TestDataFactory.createOperatorContractorRecords(1, TRUE, accountRecords[1].id, accountRecords[0].id);

		// this should make the opportunity  SER enabled
		// Updated to include account by mark simpson 4/6/2020		
		opportunityRecords = [SELECT id, Self_Registered_Status__c from Opportunity where id = :opportunityRecords[0].id];
		accountRecords = [SELECT id, Last_Self_Registered_Status__c from Account where id = :accountRecords[0].id];
        
        system.debug ('self registration status: ' + opportunityRecords[0].Self_Registered_Status__c);
		System.assert (opportunityRecords[0].Self_Registered_Status__c == 'SER enabled');
        System.assert (accountRecords[0].Last_Self_Registered_Status__c == 'SER enabled');
	} 
	@isTest static void testSelfRegistrationStatus() {


        QB_TestDataFactory.createSITCustomSetting(TRUE);
		System.debug(' ') ;       

        //Create dummy data for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(2, TRUE);
        QB_TestDataFactory.createSITCustomSetting(TRUE);
		System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;  
        accountRecords[0].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(); 
        accountRecords[1].RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(); 
        accountRecords[1].Vetify_Position__c = 'Client Opt In';
        
        update accountRecords; 

		// opportunity created
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecordsWithClientId(1, TRUE, accountRecords[0].id, accountRecords[1].id);

		// followed by a connection
        List<Operator_Contractor__c> operatorContractorRecords = QB_TestDataFactory.createOperatorContractorRecords(1, TRUE, accountRecords[1].id, accountRecords[0].id);
		System.debug('the opp should now be set to SER Enabled') ;		

		// this should make the opportunity  self-registered
		opportunityRecords = [SELECT id, Self_Registered_Status__c from Opportunity where id = :opportunityRecords[0].id];
		system.debug ('self registration status: ' + opportunityRecords[0].Self_Registered_Status__c);

		System.assert (opportunityRecords[0].Self_Registered_Status__c ==  'Self-Registered');
	} 	
}