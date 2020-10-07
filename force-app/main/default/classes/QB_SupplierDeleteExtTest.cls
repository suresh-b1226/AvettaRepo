@isTest
private class QB_SupplierDeleteExtTest {
	

@isTest static void testdeleteSuppliersNoCampaignId() {
		

		//Create dummy data for test purposes.
		List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(200, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);
       
        System.debug('******************Inserting the test Supplier_Staging__c record...');

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(supplierRecords);
                
        Test.startTest();
        QB_SupplierDeleteExt supDelExt = new QB_SupplierDeleteExt (sc);
        //supDelExt.campaignId = campaigns[0].id; 

        
       
       supDelExt.deleteSupplier();                   
       Test.stopTest();


List<Apexpages.Message> msgs = ApexPages.getMessages(); 
boolean b = false; 
for(Apexpages.Message msg:msgs){ 
 System.debug('ApexPages message1.........' + msg);
    if (msg.getDetail().contains('An error has occured while trying to remove supplier records: Campaign Id cannot be blank')) 
    b = true; 
} 
system.assert(b); 

	}

		@isTest static void testdeleteSuppliersInvalidCampaignId() {
		

		//Create dummy data for test purposes.
		List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(200, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);
       
        System.debug('******************Inserting the test Supplier_Staging__c record...');

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(supplierRecords);
                
        Test.startTest();
        QB_SupplierDeleteExt supDelExt = new QB_SupplierDeleteExt (sc);
        supDelExt.campaignId = '0000000000000000'; 

        
       
       supDelExt.deleteSupplier();                   
       Test.stopTest();


List<Apexpages.Message> msgs = ApexPages.getMessages(); 
boolean b = false; 
for(Apexpages.Message msg:msgs){ 
 System.debug('ApexPages message1.........' + msg);
    if (msg.getDetail().contains('An error has occured while trying to remove supplier records: Campaign Id is not a valid Id')) 
    b = true; 
} 
system.assert(b); 

}


		@isTest static void testdeleteSuppliersSuccess() {
		
		integer numSuppliersDeleted;

		//Create dummy data for test purposes.
		List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(20, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);
        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE); 

		numSuppliersDeleted = QB_SuppliersService.deleteSuppliers(new Set<string>{campaigns[0].id});
        

        System.debug('******************Inserting the test Supplier_Staging__c record...');

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(supplierRecords);
                
        Test.startTest();
        QB_SupplierDeleteExt supDelExt = new QB_SupplierDeleteExt (sc);
        supDelExt.campaignId = campaigns[0].id; 
        
       
       supDelExt.deleteSupplier();                   
       Test.stopTest();


List<Apexpages.Message> msgs = ApexPages.getMessages(); 
boolean b = false; 
for(Apexpages.Message msg:msgs){ 
 System.debug('ApexPages message1.........' + msg);
    if (msg.getDetail().contains('A total of ' +  numSuppliersDeleted + ' Supplier Staging records have successfully been deleted.')) 
    b = true; 
} 
//system.assert(b);

}

	
}