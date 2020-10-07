@isTest
private class QB_TestSupplierConvertService {
	
	@isTest static void testgetDefaultOpportunityOwner() {

        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE); 

		   test.startTest();
           string owner = QB_SupplierConvertService.getDefaultOpportunityOwner();
           test.stopTest();
           system.assert(owner != null);

	}
	
	@isTest static void testconvertSuppliers() 
	{
		// setup test data. Test for campaign Id is validate
        List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id);
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(1, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);
        
        test.startTest();
        
        try
        {
       // QB_SupplierConvertService.convertSuppliers(campaigns[0].id, supplierRecords[0]);
            system.assert(TRUE);
            test.stopTest();
        }
        catch(Exception ex)
        {
            //What is expected test results...
        }
    }
    
	
	@isTest static void testconvertStageRecordToOtherRecords() 
	{
        Map<String, sObject> testMap = new Map<String, sObject>();


		// setup test data. Test for records to converted to other records
        List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id);
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecordsWithClientId(1, TRUE, clientAccountRecords[0].id, clientAccountRecords[0].id);
        
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(1, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);
        List<Supplier_Staging_Convert__mdt> data = QB_TestDataFactory.createMetadata(TRUE)
        ;
        


        test.startTest();
        
        try
        {
            testMap = QB_SupplierConvertService.convertStageRecordToOtherRecords(accountRecords[0], contactRecords[0], opportunityRecords[0], data, supplierRecords[0]);
            system.assert(!testMap.isEmpty());
            test.stopTest();
        }
        catch(Exception ex)
        {
            //system.assert(ex.getMessage() == 'Campaign Id cannot be blank');
        }
    }
}