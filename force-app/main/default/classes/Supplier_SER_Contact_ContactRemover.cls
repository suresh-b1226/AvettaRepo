global class Supplier_SER_Contact_ContactRemover {
    
    // Created by: Emmon Chow
    // Created on 1/23/2019
    // Modified last: 1/24/2019
    // Description: _ContactRemover is meant to be run before _ContactPrevent. It appends 'xxx' to any EXISTING non '@avetta.com' email addresses in 
    // any desireable sandbox. This way, contractors who are in the Salesforce sandbox aren't emailed when we do tests. 
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
    
    global static Boolean runningInASandbox() {
      Boolean bCheck = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
      System.debug('Are we running in a sandbox ' + bCheck);
      return bCheck;
    }
    
    global static Boolean runningInA2Sandbox() {
      Boolean bCheck = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
      return bCheck;
    }
    
    global static void AppendNonAvettaPrimaryEmails() {
    	List<Contact> consToUpdate = new List<Contact>{};

        //FOR every contact inside the database, don't include ones that have 'xxx' in the beginning of the Primary Email address
        //	AND don't include ones that have '@avetta.com' at the end, nor any blanks
        //	
        //	Result: Give me all Primary Email addresses that don't belong to '@avetta.com' nor email addresses already appended with 'xxx'
        for (Contact nonAvettaEmail: 
                [
                SELECT Id, Email 
                FROM Contact 
                WHERE ((NOT Email LIKE '%@avetta.com')
                       AND (NOT Email LIKE 'xxx%@avetta.com') 
                       AND (NOT Email = null))
                ]) {

                if (!runningInASandbox()) {
					System.debug('Be careful, you should not run this in production');
                }
                else {
                    //Now that we have all the emails that we desire to edit, append 'xxx' to the beginning of it
                    nonAvettaEmail.Email = ''; consToUpdate.add(nonAvettaEmail); //null and '' are different, I chose to use '', so that you can still query for email addresses that have been changed to blank
                    System.debug('We have now appended the aforementioned email address to: ' + nonAvettaEmail.Email);
                }
        }
        
        update consToUpdate;

    }
        

    
    
    global static void AppendNonAvettaSecondaryEmails () {
    	List<Contact> consToUpdate = new List<Contact>{};
        String sEnvironment;
        sEnvironment = String.valueOf(System.URL.getSalesforceBaseUrl().toExternalForm());
            
        //FOR every contact inside the database, don't include ones that have 'xxx' in the beginning of the Secondary Email address
        //	AND don't include ones that have '@avetta.com' at the end, nor any blanks
        //	
        //	Result: Give me all Primary Email addresses that don't belong to '@avetta.com' nor email addresses already appended with 'xxx'

            
        for (Contact nonAvettaSecondaryEmail: 
            [
                SELECT Id, Email2__c 
                FROM Contact 
                WHERE ((NOT Email2__c LIKE '%@avetta.com')
                       AND (NOT Email2__c LIKE 'xxx%@avetta.com') 
                       AND (NOT Email2__c = null))
            ]) {
            if (!runningInA2Sandbox()) {
                System.debug('Be careful, you should not run this in sandboxes');
            }
            else {
                //Now that we have all the emails that we desire to edit, append 'xxx' to the beginning of it
                nonAvettaSecondaryEmail.Email2__c = ''; consToUpdate.add(nonAvettaSecondaryEmail); //null and '' are different, I chose to use '', so that you can still query for email addresses that have been changed to blank
                System.debug('We have now appended the aforementioned email address to: ' + nonAvettaSecondaryEmail.Email2__c);

            }

        }
        
        update consToUpdate;
        	
    }  
}