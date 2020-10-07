@isTest(SeeAllData=true) private class updateOCStatusFromAccountTest {
    
    @isTest(SeeAllData=true) static void testOCStatusChange() {
        
        //Create contactor record for test purposes.
        List<Account> contractorRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        	System.debug('after creating account in QB_TestDataFactory.createAccountRecords') ;  
        
        //Create operator record for test purposes.
        List<Account> operatorRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);
        	System.debug('after creating account in QB_TestDataFactory.createAccountRecords');
        	
        System.debug(contractorRecords[0]);    
        System.debug(operatorRecords[0]);    
        
        //Create operator contractor linked to previously created accounts
        List<Operator_Contractor__c> operatorContractorRecords = QB_TestDataFactory.createOperatorContractorRecords(1, TRUE, operatorRecords[0].id, contractorRecords[0].id);
	
        System.debug('Operator Contractor Created ' + operatorContractorRecords[0]);
        System.debug('****************** Insert Account and Operator Contractor record...');
    
        System.debug('Contractor status before' + contractorRecords[0].Status__c);
        contractorRecords[0].Status__c = 'Demo';
        System.debug('Contractor status after' + contractorRecords[0].Status__c);
        update contractorRecords[0];
        
        System.debug('New OC Status = ' + operatorContractorRecords[0]);
    }
}