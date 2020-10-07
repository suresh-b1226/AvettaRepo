@isTest private class UpdateContactRoleTest {
    
    @isTest static void ContactRoleTest_WithMultipleOCR() {
         //Create account record for test purposes.
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords');

        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords');
        
        //Create opportunity record for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(4, true, accountRecords[0].Id, 'dwasden@avetta.com');
        System.debug('after creating contact in QB_TestDataFactory.createContactRecords') ;

        for (Contact c : contactRecords ) {
            c.Primary_PICS_Organizer_User__c = false;
        }
        update contactRecords;
        
        //Create opportunity record for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecords(1, true, accountRecords[0].Id);
        System.debug('after creating opportunity in QB_TestDataFactory.createOpportunityRecords');
        
        /*
		//Create user record for test purposes.
		List<User> userRecords = QB_TestDataFactory.createUserRecords(1, TRUE);
		System.debug('after creating account in QB_TestDataFactory.createUserRecords') ;  
		*/
        
        //Create opportunity record for test purposes.
        List<OpportunityContactRole> opportunityContactRoleRecords = QB_TestDataFactory.createOpportunityContactRole(3, true, contactRecords[0].Id, opportunityRecords[0].Id);
        System.debug('after creating OpportunityContactRole in QB_TestDataFactory.createOpportunityContactRole');

        
        System.debug('opportunityContactRoleRecords = ' + opportunityContactRoleRecords);
        System.debug('contact = ' + opportunityRecords[0].Primary_Contact__c);


        opportunityRecords[0].StageName = 'Prospect';
        update opportunityRecords[0];
    }

    @isTest static void ContactRoleTest_With_1_OCR() {
        //Create account record for test purposes.
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords');

        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords');

        //Create opportunity record for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecords[0].Id, 'dwasden@avetta.com');
        System.debug('after creating contact in QB_TestDataFactory.createContactRecords') ;

        for (Contact c : contactRecords ) {
            c.Primary_PICS_Organizer_User__c = false;
        }
        update contactRecords;

        //Create opportunity record for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecords(1, true, accountRecords[0].Id);
        System.debug('after creating opportunity in QB_TestDataFactory.createOpportunityRecords');

        /*
		//Create user record for test purposes.
		List<User> userRecords = QB_TestDataFactory.createUserRecords(1, TRUE);
		System.debug('after creating account in QB_TestDataFactory.createUserRecords') ;
		*/

        //Create opportunity record for test purposes.
        List<OpportunityContactRole> opportunityContactRoleRecords = QB_TestDataFactory.createOpportunityContactRole(1, true, contactRecords[0].Id, opportunityRecords[0].Id);
        System.debug('after creating OpportunityContactRole in QB_TestDataFactory.createOpportunityContactRole');


        System.debug('opportunityContactRoleRecords = ' + opportunityContactRoleRecords);
        System.debug('contact = ' + opportunityRecords[0].Primary_Contact__c);


        opportunityRecords[0].StageName = 'Prospect';
        update opportunityRecords[0];
    }

    @isTest static void ContactRoleTest_With_Zero_OCR() {
        //Create account record for test purposes.
        List<Account> clientAccountRecords = QB_TestDataFactory.createClientAccountRecords(1, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords');

        List<Account> accountRecords = QB_TestDataFactory.createAccountRecords(1, true);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords');

        //Create opportunity record for test purposes.
        List<Contact> contactRecords = QB_TestDataFactory.createContactRecords(1, true, accountRecords[0].Id, 'dwasden@avetta.com');
        System.debug('after creating contact in QB_TestDataFactory.createContactRecords') ;

        for (Contact c : contactRecords ) {
            c.Primary_PICS_Organizer_User__c = false;
        }
        update contactRecords;

        //Create opportunity record for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecords(1, true, accountRecords[0].Id);
        System.debug('after creating opportunity in QB_TestDataFactory.createOpportunityRecords');

        /*
		//Create user record for test purposes.
		List<User> userRecords = QB_TestDataFactory.createUserRecords(1, TRUE);
		System.debug('after creating account in QB_TestDataFactory.createUserRecords') ;
		*/

        //Create opportunity record for test purposes.

        System.debug('contact = ' + opportunityRecords[0].Primary_Contact__c);


        opportunityRecords[0].StageName = 'Prospect';
        update opportunityRecords[0];
    }
}