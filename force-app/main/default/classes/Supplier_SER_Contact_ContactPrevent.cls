public class Supplier_SER_Contact_ContactPrevent {
    // Created by: Emmon Chow
    // Created on 1/22/2019
    // Modified last: 1/22/2019
    // Description: This creates a validation rule when a new contact is updated/inserted/upserted. It prevents new primary email addresses not ending in
    // @avetta.com to be added to the Salesforce sandbox. After the contact is created with the correct primary email address, any edits made on the Contact
    // will also prevent secondary addresses from not ending in @avetta.com as well.
    //
    // Notes
    // (1) The code is triggered when an update/upsert/insert is made which is coded in Contact_Trigger.apxt
    // (2) Read process how to use this correctly
    // 
    // Process:
    // (1) If you haven't done so already, you MUST COMMENT OUT both contact triggers in Contact_Trigger.apxt. 
    // 	   If you don't, the appending methods in Supplier_SER_Contact_ContactRemover will not work. This is because the appending methods are considered update
    // 	   triggers. Even when Supplier_SER_Contact_ContactRemover appends an 'xxx' to an email not from '@avetta.com', it is still considered non '@avetta.com' by
    // 	   Supplier_SER_Contact_ContactPrevent's validation rule.
    // 	   
    // (2) Run Supplier_SER_Contact_ContactRemover.AppendNonAvettaPrimaryEmails() and Supplier_SER_Contact_ContactRemover.AppendNonAvettaSecondaryEmails() first
    // 	   This removes appends any non '@avetta.com'emails in the system.
    // 	   
    // (3) UN-COMMENT OUT both contact triggers in Contact_Trigger, so that the validation rule holds and prevents any new non '@avetta.com' email address 
    // 	   (primary and secondary).
    

    
    
        public static Boolean runningInASandbox() {
          Boolean bCheck = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
          return bCheck;
        }
        
        public static void PreventInsertUpdate(List<Contact> NewContacts) {
            Boolean brunningInASandbox = runningInASandbox();
            //Loop through every contact passed into the method
            if(!Test.isRunningTest()) {

                if (brunningInASandbox = True) {
                    for (Contact parsedContacts: NewContacts) {
                        
                        //If the email address is not blank and it does not contain '@avetta.com', also it has to be in a sandbox
                        if ((parsedContacts.Email != null) && (!parsedContacts.Email.containsIgnoreCase('@avetta.com'))) {
                            //Throw an error in GUI and prevent them from adding a non '@avetta.com' email address
                            parsedContacts.addError('Check "Email" field: Contacts that are created in the sandbox, must have an email address that contains @avetta.com');
                        }
                        else { //If running in production, We check for environment here instead of before for loop because of code coverage.
                            System.debug('Be careful, you cannot run this in production.');
                        }
                        
                        
                        //We want to be thorough. Email2__c is the secondary email address. We are fixing these as well
                        if ((parsedContacts.Email2__c != null) && (!parsedContacts.Email2__c.containsIgnoreCase('@avetta.com'))) {
                            parsedContacts.addError('Check "Alt Email" field: Contacts that are created in the sandbox, must have an email address that contains @avetta.com');
                        }
                        else { //If running in production
                            System.debug('Be careful, you cannot run this in production.');
                        }
                        
                    }  
                }
            }
    
        }
    
 

}