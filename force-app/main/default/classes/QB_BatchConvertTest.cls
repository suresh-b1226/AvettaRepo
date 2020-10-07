@isTest
private class QB_BatchConvertTest {
	
	@isTest static void testBacthConvertSuppliers() 
    {
        // Create Custom Settings
        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE);
        List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);  // client
		campaigns[0].Client_Account__c = clientAccountRecords[0].id;
        update campaigns;
            
        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');        
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);   // supplier        
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id);
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecordsWithClientId(1, TRUE, AccountRecords[0].id, clientAccountRecords[0].id);

        //List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecords(1, TRUE, accountRecords[0].id);
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(5, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);


        
        Test.startTest();

            QB_BacthConvertSuppliers obj = new QB_BacthConvertSuppliers();
            obj.convertCampaignId = campaigns[0].id;
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }	
    
	@isTest static void TestingIsGood() 
    {
        // Create Custom Settings
        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE);
        List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);  // client
		campaigns[0].Client_Account__c = clientAccountRecords[0].id;
        update campaigns;
        
        //Creating Upload without Accounts and Contacts
        List<User> owner = QB_TestDataFactory.getUsersByProfile('System Administrator');        
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(3, TRUE, null, null, owner[0].id, campaigns[0].id);

        Test.startTest();
            QB_BacthConvertSuppliers obj = new QB_BacthConvertSuppliers();
            obj.convertCampaignId = campaigns[0].id;
            DataBase.executeBatch(obj); 
        	//need to get this working
        	//List<Opportunity> CheckOpty = [Select ID,AccountId,Client_Account__c from Opportunity where Client_Account__c = :clientAccountRecords[0].id];    
        	//System.assertEquals(CheckOpty[0].Client_Account__c,clientAccountRecords[0].id);
        	//System.assertEquals(CheckOpty.Size(),3);
        Test.stopTest();
    }
    @isTest static void TestingIsimportant() 
    {
        // Create Custom Settings
        SIT_Settings__c sitSetting  = Null;
        List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);  // client
		
        campaigns[0].Client_Account__c = clientAccountRecords[0].id;
        update campaigns;
        
        //Creating Upload without Accounts and Contacts
        List<User> owner = QB_TestDataFactory.getUsersByProfile('System Administrator');        
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(3, TRUE, null, null, owner[0].id, campaigns[0].id);
        
        Test.startTest();
            QB_BacthConvertSuppliers obj = new QB_BacthConvertSuppliers();
            obj.convertCampaignId = campaigns[0].id;
            DataBase.executeBatch(obj); 
        	//Need to get this working
          	//List<Opportunity> CheckOpty = [Select ID,AccountId,Client_Account__c from Opportunity where Client_Account__c = :clientAccountRecords[0].id];
       		//System.assertEquals(CheckOpty[0].Client_Account__c,clientAccountRecords[0].id);
        	//System.assertEquals(CheckOpty.Size(),3);
        	
        Test.stopTest();
        
    }	
}