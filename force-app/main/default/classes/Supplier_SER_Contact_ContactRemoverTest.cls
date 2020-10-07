@isTest
global class Supplier_SER_Contact_ContactRemoverTest 
{
    global static Boolean runningInASandbox() {
      Boolean bCheck = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
      return bCheck;
    }
    
    global static Boolean runningInA2Sandbox() {
      Boolean bCheck = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
      return bCheck;
    }
    
    @isTest
    public static void testPrimaryContacts()
    {
        Supplier_SER_Contact_ContactRemover.runningInASandbox();
        
        List<Account> accountRecords = new List<Account>();
		accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        
        Id avettaId = accountRecords[0].Id;
        
        QB_TestDataFactory.createContactRecords(1, TRUE, avettaId,  'abcdefg@avetta.com');
        
        System.debug('Start PRIMARY Contact testing: ');
        QB_TestDataFactory.createContactRecords(1, TRUE, avettaId,  'xxxabc@avetta.com');
        
        
        /*Test case with 'xxx' in front of the email NO domain name
        Contact newPrimaryXXXNoAvetta = new Contact();
        newPrimaryXXXNoAvetta.Email = 'xxxabc@gmail.com';
        newPrimaryXXXNoAvetta.LastName = 'XXXWithAvetta';*/
        
        /*Test case with Contact.Email No Avetta domain name
        Contact newPrimaryNoAvetta = new Contact();
        newPrimaryNoAvetta.Email = 'yahoo@tesla.com';
        newPrimaryNoAvetta.LastName = 'PrimaryNOAvetta';*/

        
        //insert newPrimaryXXXNoAvetta;
        //insert newPrimaryNoAvetta;
        

        
        System.debug('We have inserted all of the accounts');
            
        //Should return 'yahoo@tesla.com' which is the target of the query and the class
        Contact[] nonxxxEmailAfter =
            [
                SELECT Id, Email 
                FROM Contact 
                WHERE ((NOT Email LIKE 'xxx%')
                       AND (NOT Email LIKE '%@avetta.com')
                       AND (NOT Email LIKE 'xxx%@avetta.com') 
                       AND (NOT Email = null))
            ];            
        
        System.debug('Query after Insert, but before Update all non xxx' + nonxxxEmailAfter);
        System.debug('Time to start appending');
        
        //Appends 'xxx' to non '@avetta.com' domain names
        Supplier_SER_Contact_ContactRemover.AppendNonAvettaPrimaryEmails();
        
        
        //This query should be blank after appending
        nonxxxEmailAfter =
            [
                SELECT Id, Email 
                FROM Contact 
                WHERE ((NOT Email LIKE 'xxx%')
                       AND (NOT Email LIKE '%@avetta.com')
                       AND (NOT Email LIKE 'xxx%@avetta.com') 
                       AND (NOT Email = null))
            ];       
        
        System.debug('Query after Insert AND Update all non xxx. Should be blank' + nonxxxEmailAfter);

        //All emails that are not '@avetta.com' should start in xxx now
        Contact[] xxxEmailAfter =
            [
                SELECT Id, Email 
                FROM Contact 
                WHERE NOT Email LIKE '%avetta.com'
            ]; 
        
        System.debug('Query with all emails not from Avetta. Should all be \'xxx\' ' + xxxEmailAfter);
        
           
        Contact[] AllEmails =
            [
                SELECT Id, Email 
                FROM Contact 
                WHERE Email LIKE 'xxx%'
            ]; 
        
        System.debug('Query with all xxx' + AllEmails);

    }
    
    @isTest
    public static void testSecondaryContacts()
    {
        Supplier_SER_Contact_ContactRemover.runningInA2Sandbox();

                
        List<Account> accountRecords = new List<Account>();
		accountRecords = QB_TestDataFactory.createAccountRecords(1, TRUE);
        
        Id avettaId = accountRecords[0].Id;
        
        
        List<Contact> newSecondaryWithAvetta = new List<Contact>();
            
        newSecondaryWithAvetta = QB_TestDataFactory.createContactRecords(1, FALSE, avettaId,  'sample@avetta.com');
        newSecondaryWithAvetta[0].Email2__c = 'abcdefg@avetta.com';
        
        insert newSecondaryWithAvetta;
        

        System.debug('Start PRIMARY Contact testing: ');
        
        List<Contact> newSecondaryXXXWithAvetta = new List<Contact>();

        newSecondaryXXXWithAvetta = QB_TestDataFactory.createContactRecords(1, FALSE, avettaId,  'sample@avetta.com');
        newSecondaryXXXWithAvetta[0].Email2__c = 'xxxabc@avetta.com';

        insert newSecondaryXXXWithAvetta;

        
        //This is just a direct copy of testPrimaryContacts() with all the same logic, except it is for Secondary contacts
        System.debug('Start SECONDARY Contact testing: ');

        
        /*Test case with 'xxx' in front of the Email2__c NO domain name
        Contact newSecondaryXXXNoAvetta = new Contact();
        newSecondaryXXXNoAvetta.Email2__c = 'xxxabc@gmail.com';
        newSecondaryXXXNoAvetta.LastName = 'XXXWithAvetta'; */
        
        /*Test case with Contact.Email2__c2__c No Avetta domain name
        Contact newSecondaryNoAvetta = new Contact();
        newSecondaryNoAvetta.Email2__c = 'yahoo@tesla.com';
        newSecondaryNoAvetta.LastName = 'SecondaryNOAvetta';*/
       
        

        //insert newSecondaryXXXNoAvetta;
        //insert newSecondaryNoAvetta;

        
        System.debug('We have inserted all of the accounts');
        
        Contact[] nonxxxEmailAfter =
            [
                SELECT Id, Email2__c 
                FROM Contact 
                WHERE ((NOT Email2__c LIKE 'xxx%')
                       AND (NOT Email2__c LIKE '%@avetta.com')
                       AND (NOT Email2__c LIKE 'xxx%@avetta.com') 
                       AND (NOT Email2__c = null))
            ];            
        
        System.debug('Query after Insert, but before Update all non xxx' + nonxxxEmailAfter);
        System.debug('Time to start appending...');
        
        Supplier_SER_Contact_ContactRemover.AppendNonAvettaSecondaryEmails();
        
        
        nonxxxEmailAfter =
            [
                SELECT Id, Email2__c 
                FROM Contact 
                WHERE ((NOT Email2__c LIKE 'xxx%')
                       AND (NOT Email2__c LIKE '%@avetta.com')
                       AND (NOT Email2__c LIKE 'xxx%@avetta.com') 
                       AND (NOT Email2__c = null))
            ];       
        
        System.debug('Query after Insert AND Update all non xxx. Should be blank' + nonxxxEmailAfter);

        
        Contact[] xxxEmailAfter =
            [
                SELECT Id, Email2__c 
                FROM Contact 
                WHERE NOT Email2__c LIKE '%avetta.com'

            ]; 
        
        System.debug('Query with all emails not from Avetta. Should all be \'xxx\' ' + xxxEmailAfter);
        
        Contact[] AllEmails =
            [
                SELECT Id, Email2__c 
                FROM Contact 
            ]; 
        
        System.debug('Query all Secondary emails' + AllEmails);
        
    }
    
}