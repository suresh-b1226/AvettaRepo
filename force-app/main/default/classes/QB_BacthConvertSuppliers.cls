global class QB_BacthConvertSuppliers implements Database.Batchable<sObject> {
	
	String soqlQuery;
	public String convertCampaignId;
	
	global QB_BacthConvertSuppliers() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String soqlQuery = ' SELECT Account_ID__c,Additional_information__c,Campaign__c,Converted__c, City__c, ' +
                           ' Company__c,Country__c,Email__c, First_Name__c,IsDeleted,Last_Name__c, '+
                           ' Owner_ID__c, Phone__c, Postal_Zip_Code__c,Priority__c,State__c,Street__c, Free_Connection__c, '+
                           ' Tax_Id__c,Website__c, Contact_ID__c, Organizer_ID__c, Vendor_ID__c, Site__c '+ 
                      	   ' FROM Supplier_Staging__c '+
                      	   ' WHERE Campaign__c = :convertCampaignId AND Converted__c = FALSE';
		
		system.debug ('soqlQuery: ' + soqlQuery);
		return Database.getQueryLocator(soqlQuery);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		
   		system.debug ('execute. Number of records: ' + scope.size());
   		List<Supplier_Staging__c> myStagingRecords = (List<Supplier_Staging__c>)scope;
		QB_SupplierConvertService.convertSuppliers (myStagingRecords, convertCampaignId );
		   		system.debug ('Converted one batch: ' + scope.size());
		
	}
	
	global void finish(Database.BatchableContext BC) {

		/*
		 // Update Supplier Staging Results with the amount of records that were created and BatchURL.
            Staging_Results__c res = new Staging_Results__c();   
            res.Number_of_Accounts_Converted__c = 0;
            res.Number_of_Contacts_Converted__c = -1;
            res.Number_of_Opportunities_Converted__c = -1;
            res.Batch_Result_Url__c = '*****Batch Request Completed*****';
            res.Conversion_Executed_by__c = UserInfo.getUserId();
            res.Campaign__c = convertCampaignId; 
            
            insert res; */
		
	}
	
	     
}