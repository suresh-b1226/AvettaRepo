Global class EmailUnsubscribe implements Messaging.inboundEmailHandler{

    Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                         Messaging.InboundEnvelope env ) {
    
        // Create an inboundEmailResult object for returning 
        // the result of the email service.
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
         
        // Create contact and lead lists to hold all the updated records.
        List<Contact> lc = new List <contact>();
        List<Lead> ll = new List <lead>();
         
        // Convert the subject line to lower case so the program can match on lower case.
        String mySubject = email.subject.toLowerCase();
        // The search string used in the subject line.
        String s = 'unsubscribe';
         
        // Check the variable to see if the word "unsubscribe" was found in the subject line. 
        Boolean unsubMe;
        // Look for the word "unsubcribe" in the subject line. 
        // If it is found, return true; otherwise, return false.
        unsubMe = mySubject.contains(s);
         
         // If unsubscribe is found in the subject line, enter the IF statement.
         
        if (unsubMe == true) {
            
            try {
               
            // Look up all contacts with a matching email address.
            for (Contact c : [SELECT Id, Name, Email, No_Marketing_to_this_Contact__c
                          FROM Contact
                          WHERE Email = :env.fromAddress
                          AND No_Marketing_to_this_Contact__c = false
                          LIMIT 100]) {
                          
                // Add all the matching contacts into the list.   
                c.No_Marketing_to_this_Contact__c = true;
                lc.add(c);
            }
            // Update all of the contact records.
            update lc;
        }
        catch (System.QueryException e) {
            System.debug('Contact Query Issue: ' + e);
        }   
        
        System.debug('Found the unsubscribe word in the subject line.');
         } 
         else {
            System.debug('No Unsuscribe word found in the subject line.' );
         }
        // Return True and exit.
        // True confirms program is complete and no emails 
        // should be sent to the sender of the unsubscribe request. 
        result.success = true;
        return result;
    }   
}