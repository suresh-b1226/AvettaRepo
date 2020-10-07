@isTest
private class QB_SupplierConvertExtTest {

	
	@isTest static void testconvertSuppliersNoCampaignId() {
		

		//Create dummy data for test purposes.
		List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(200, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);
       
        System.debug('******************Inserting the test Supplier_Staging__c record...');

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(supplierRecords);
                
        Test.startTest();
        QB_SupplierConvertExt supConvExt = new QB_SupplierConvertExt (sc);
        //supConvExt.campaignId = campaigns[0].id; 

        
       
       supConvExt.convertSuppliers();                   
       Test.stopTest();


List<Apexpages.Message> msgs = ApexPages.getMessages(); 
boolean b = false; 
for(Apexpages.Message msg:msgs){ 

    if (msg.getDetail().contains('An error has occured while trying to convert supplier records: Campaign Id cannot be blank')) 
    b = true; 
} 
system.assert(b); 

	}

		@isTest static void testconvertSuppliersInvalidCampaignId() {
		

		//Create dummy data for test purposes.
		List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(200, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);
       
        System.debug('******************Inserting the test Supplier_Staging__c record...');

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(supplierRecords);
                
        Test.startTest();
        QB_SupplierConvertExt supConvExt = new QB_SupplierConvertExt (sc);
        supConvExt.campaignId = '0000000000000000'; 

        
       
       supConvExt.convertSuppliers();                   
       Test.stopTest();


List<Apexpages.Message> msgs = ApexPages.getMessages(); 
boolean b = false; 
for(Apexpages.Message msg:msgs){ 

    if (msg.getDetail().contains('An error has occured while trying to convert supplier records: Campaign Id is not a valid Id')) 
    b = true; 
} 
system.assert(b); 

}


		@isTest static void testconvertSuppliersSuccess() {
		

		//Create dummy data for test purposes.
		List<Campaign> campaigns = QB_TestDataFactory.createCampaignRecords(1, TRUE);
        List<User>     owner = QB_TestDataFactory.getUsersByProfile('System Administrator');
        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, TRUE, accountRecords[0].id, 'test@avetta.com');
        List<Supplier_Staging__c> supplierRecords = QB_TestDataFactory.createSupplierRecords(20, TRUE, accountRecords[0].id, contactRecords[0].id, owner[0].id, campaigns[0].id);
        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE); 

        System.debug('******************Inserting the test Supplier_Staging__c record...');

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(supplierRecords);
                
        Test.startTest();
        QB_SupplierConvertExt supConvExt = new QB_SupplierConvertExt (sc);
        supConvExt.campaignId = campaigns[0].id; 
        
       
       supConvExt.convertSuppliers();                   
       Test.stopTest();


List<Apexpages.Message> msgs = ApexPages.getMessages(); 
boolean b = false; 
for(Apexpages.Message msg:msgs){ 

    if (msg.getDetail().contains('Supplier Staging records have been converted successfully. Please see Staging Results for more details')) 
    b = true; 
} 
//system.assert(b); Message may get change by Sheida S during the week of 03/27/17

}

}