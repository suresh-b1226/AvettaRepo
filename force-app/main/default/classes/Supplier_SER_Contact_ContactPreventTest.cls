@isTest
global class Supplier_SER_Contact_ContactPreventTest
{
   	@isTest 
    // Created by: Emmon Chow
    // Created on 1/22/2019
    // Modified last: 1/22/2019
    // Description: This tests the validation rule created in the class: Supplier_SER_Contact_EmailChecker. The test runs if you comment out
    // insert/upsert/update newPrimaryNoAvetta; or insert/upsert/update because the validation rule will not allow any email addresses other than @avetta.com to be added in.
    // 
    // MAKE SURE YOU TURN ON update and insert TRIGGERS in Contact_Trigger.apxt before running this.
    // 
    // If you uncomment:
    // 			newNoSecondary.Email2__c = 'insert@prolook.com'; 
    // 			newNoPrimary.Email = 'insert@prolook.com'; 
    // 															out, it will throw an exception:
    // (1) For Primary Email addresses it will state: 'Check "Email" field: Contacts that are created in the sandbox, must have an email address that contains @avetta.com'
    // (2) For Secondary Email addresses it will state: 'Check "Alt Email" field: Contacts that are created in the sandbox, must have an email address that contains @avetta.com'

  
    global static void testPrimaryContacts()
    {
        List<Account> accountRecords = new List<Account>();
		accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        
        Id avettaId = accountRecords[0].Id;
                
        QB_TestDataFactory.createContactRecords(1, TRUE, avettaId,  'abcdefg@avetta.com');
       
        
        //Test case with Contact.Email No Avetta domain name
        Contact newPrimaryNoAvetta = new Contact();
            newPrimaryNoAvetta.Email = 'yahoo@tesla.com';
            newPrimaryNoAvetta.LastName = 'PrimaryNOAvetta';
        	newPrimaryNoAvetta.AccountId = avettaId;

        //Test case No Contact.Email
        Contact newNoPrimary = new Contact();
            newNoPrimary.LastName = 'NOPrimary';
        	newNoPrimary.AccountId = avettaId;
        
        //insert newPrimaryNoAvetta;
        //^^^Meant to be commented out, the test will fail if not commented. But if it fails, it means it works because it prevented you
        //from inserting or updating a non '@avetta.com' email address.
        
        //insert newNoPrimary;
        
		
        //newNoPrimary.Email = 'insert@prolook.com'; 
        //^^^Same with this
        
        
        //Try adding a primary email address and updating an existingaccount to test the logic
    }

    @isTest
    public static void testSecondaryContacts()
    {
        
        List<Account> accountRecords = new List<Account>();
		accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        
        Id avettaId = accountRecords[0].Id;
        
        QB_TestDataFactory.createContactRecords(1, TRUE, avettaId,  'gaffican@avetta.com');

        
        //Test case with Contact.Email No Avetta domain name
        Contact newSecondaryNoAvetta = new Contact();
            newSecondaryNoAvetta.Email2__c = 'elon@tesla.com';
            newSecondaryNoAvetta.LastName = 'SecondaryNOAvetta';
        	newSecondaryNoAvetta.AccountId = avettaId;	

            
        //Test case No Contact.Email
        Contact newNoSecondary = new Contact();
            newNoSecondary.LastName = 'NOSecondary';
        	newNoSecondary.AccountId = avettaId;	

        
        //insert newSecondaryWithAvetta;
        //insert newSecondaryNoAvetta;
        //^^^Meant to be commented out, the test will fail if not commented. But if it fails, it means it works because it prevented you
        //from inserting or updating a non '@avetta.com' email address.
        
        //insert newNoSecondary;

        //newNoSecondary.Email2__c = 'insert@prolook.com';
        //^^^Same with this
        
        //update newNoSecondary;
        
        //Try adding a Secondary email address and updating an existingaccount to test the logic
        //upsert newNoSecondary;
    }

}