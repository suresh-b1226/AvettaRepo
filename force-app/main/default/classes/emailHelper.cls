//Written by Dallin Wasden 4.26.2018
//Global helper class used to automate email sending.
global class emailHelper {
    private static Boolean firstRun = true;
    private static Integer iCount = 0;

    //Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////		COLLECTIONS EMAIL SEND		///////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Used to send automated original collection email as well as the follow-up collection emails (This also sends for Deactivation/Downgrade requests)
    public static Messaging.SingleEmailMessage sendCollectionEmail(Opportunity opp, EmailTemplate template, List<Contact> ccContactList, Id fromId, Boolean onlyPrimary) {
        System.debug('sendCollectionEmail run ' + iCount + 'times');

        Integer count = 0;

        if(isFirstRun() == true) {

            Id primaryContact;
            List<String> ccEmailList = new List<String>();

            	//Iterate over CC contacts to determine which one is Primary Contact
                for (Contact ccContact: ccContactList) {
                    if(opp.Primary_Contact__c == ccContact.Id){
                        primaryContact = ccContact.Id;
                        break;
                    }
                    else if(ccContact.Primary_PICS_Organizer_User__c == true) {
                        primaryContact = ccContact.Id;
                        break;
                    }
                    else{
                        primaryContact = ccContact.Id;
                    }

                }

            //Only add "Active" Organizer users to CC email list that have an email and limit the number of CC contacts to 3
            for(Contact oppContact : ccContactList) {
                if(String.valueOf(oppContact.Organizer_isActive__c) == 'Yes'
                   && oppContact.Id != primaryContact
                   && oppContact.Email != null
                   && oppContact.Email.trim() != ''
                   && count < 2) {
                    ccEmailList.add(String.valueOf(oppContact.Email));
                    System.debug('$$$$$$$$$$$$$$$$ CC Contacts: ' + ccEmailList);
                    count++;
                }
            }
            System.debug('ccEmailList = ' + ccEmailList.size());


            //New instance of a single email message
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            System.debug('$$$$$$$$$$$$$$$ Primary Contact: ' + primaryContact);

            //Set "To" field
            mail.setTargetObjectId(primaryContact);

            //Link to opportunity
            mail.setWhatId(opp.Id);

            //Set email template
            mail.setTemplateId(template.Id);

            //Set CC list
            if(ccEmailList.size() > 0 && onlyPrimary == FALSE) {
                mail.setCcAddresses(ccEmailList);
            }

            //Sets from equal to the org-wide email ID from previous class
            mail.setOrgWideEmailAddressId(fromId);

            //Set reply to equal to the new opportunity owner
            //mail.setReplyTo(opp.Owner.Email);

            mail.setTreatTargetObjectAsRecipient(true);
            mail.setSaveAsActivity(true);


            	return mail;

        }
        return null;
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////		MYM EMAIL SEND		///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Used to send automated original MYM email as well as the follow-up MYM emails
    public static Messaging.SingleEmailMessage sendMYMEmail(Opportunity opp, EmailTemplate template, Contact oppContact, Id fromId, List<Id> accountIds) {
        System.debug('sendMYMEmail run ' + iCount + 'times');

        Integer count = 0;
        count = count++;

        if(isFirstRun() == true) {
            	//Iterate over CC contacts to determine which one is Primary Contact
                /*for (Contact ccContact: ccContactList) {
                    if(ccContact.No_Marketing_to_this_Contact__c != true 
                       && ccContact.HasOptedOutOfEmail != true 
                       && opp.Primary_Contact__c == ccContact.Id){
                        primaryContact = ccContact.Id;
                        break;
                    }
                    else if(ccContact.No_Marketing_to_this_Contact__c != true 
                            && ccContact.HasOptedOutOfEmail != true 
                            && ccContact.Primary_PICS_Organizer_User__c == true) {
                        primaryContact = ccContact.Id;
                        break;
                    }
                    else if(ccContact.No_Marketing_to_this_Contact__c != true 
                            && ccContact.HasOptedOutOfEmail != true){
                        primaryContact = ccContact.Id;
                    }
                    
                }*/

            //Add CC contacts (don't add primaryContact as a CC contact)
            /*for(Contact oppContact : ccContactList) {
                if(String.valueOf(oppContact.Organizer_isActive__c) == 'Yes' 
                   && oppContact.Id != primaryContact 
                   && oppContact.No_Marketing_to_this_Contact__c != true
                   && oppContact.Email != null
                   && oppContact.Email.trim() != ''
                   && count < 2) {
                    ccEmailList.add(String.valueOf(oppContact.Email));
                    count++;
                }
            }
            System.debug('ccEmailList = ' + ccEmailList.size());*/

            //New instance of a single email message
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            //Set "To" field
            mail.setTargetObjectId(oppContact.Id);

            //Link to opportunity
            mail.setWhatId(opp.Id);

            //Set email template
            mail.setTemplateId(template.Id);

            //Sets 'from' equal to the org-wide email ID from MYM_FollowUp class
            mail.setOrgWideEmailAddressId(fromId);

            //Other mail settings
            mail.setTreatTargetObjectAsRecipient(true);
            mail.setSaveAsActivity(true);
			system.debug('mail:: ' + mail);
            return mail;

        }
        return null;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////		DEACTIVATION EMAIL SEND		///////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Used to send automated contractor account deactivation email
    public static Messaging.SingleEmailMessage sendDeactivationEmail(Account acct, EmailTemplate template, List<Contact> ccContactList, Id fromId, Opportunity opty, Boolean onlyPrimary) {
        System.debug('sendDeactivationEmail run ' + iCount + 'times');
        if(isFirstRun() == true) {
            Id primaryContact;
            List<String> ccEmailList = new List<String>();
            Integer count = 0;

            //Iterate over CC contacts to determine which one is Primary Contact
                for (Contact ccContact: ccContactList) {
                    if(acct.Primary_Contact__c == ccContact.Id){
                        primaryContact = ccContact.Id;
                        break;
                    }
                    else if(ccContact.Primary_PICS_Organizer_User__c == true) {
                        primaryContact = ccContact.Id;
                        break;
                    }
                    else{
                        primaryContact = ccContact.Id;
                    }

                }

            //Remove Primary Contact from list of CC contacts so they aren't emailed twice
                Integer iCount = 0;
                for(Contact ccContact: ccContactList) {
                    if(ccContact.Id == primaryContact) {
                        ccContactList.remove(iCount);
                        break;
                    }
                    if (ccContact.Email != null && ccContact.Email.trim() != '') {
                        iCount = iCount + 1;
                    }
                }
            System.debug('ccContact list' + ccContactList);

            //Only add "Active" Organizer users to CC email list
            for(Contact oppContact : ccContactList) {
                if(String.valueOf(oppContact.Organizer_isActive__c) == 'Yes'
                  && oppContact.Email != null
                  && oppContact.Email.trim() != ''
                  && count < 2) {
                    ccEmailList.add(String.valueOf(oppContact.Email));
                      count++;
                }
            }
            System.debug('ccEmailList = ' + ccEmailList.size());

            //New instance of a single email message
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            //Set "To" field
            if(primaryContact != null) {
                mail.setTargetObjectId(primaryContact);
            } else {
                System.debug('return null');
                return null;
            }

            //Link to Collection/Deactivation opportunity (allows opty merge fields in email template)
            if(opty != null){
            	mail.setWhatId(opty.Id);
            }		
            else{
            	mail.setWhatId(acct.Id);
            }
            //Set email template
            mail.setTemplateId(template.Id);

            //Set CC list
            if(ccEmailList.size() > 0 && onlyPrimary == FALSE) {
                mail.setCcAddresses(ccEmailList);
            }

            //Sets from equal to the org-wide email ID from previous class
            mail.setOrgWideEmailAddressId(fromId);

            //Set reply to equal to the new opportunity owner
            //mail.setReplyTo(opp.Owner.Email);

            mail.setTreatTargetObjectAsRecipient(true);
            mail.setSaveAsActivity(true);

            //System.debug('mail = ' + mail);
            return mail;
        }
        return null;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////		VETIFY EMAIL SEND		////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Used to send automated Vetify email
    public static Messaging.SingleEmailMessage sendVetifyEmail(Case singleCase, EmailTemplate template, Id fromId, List<Contact> ccContactList) {
        if(isFirstRun() == true) {
            System.debug('ccContactList = ' + ccContactList);
            Id primaryContact;
            List<String> ccEmailList = new List<String>();
            Integer count = 0;

            //New instance of a single email message
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            //If the opportunity does not have a linked Primary Contact, then iterate over CC contacts to determine which one is Primary Contact
            if(singleCase.ContactId == null) {
                for (Contact ccContact: ccContactList) {
                    if(ccContact.Primary_PICS_Organizer_User__c == true) {
                        primaryContact = ccContact.Id;
                    }
                }
            } else {
                primaryContact = singleCase.ContactId;

            }

            //Remove Primary Contact from list of CC contacts so they aren't emailed twice
            Integer iCount = 0;
            for(Contact ccContact: ccContactList) {
                if(ccContact.Id == primaryContact) {
                    ccContactList.remove(iCount);
                    break;
                }
                if (ccContact.Email != null && ccContact.Email.trim() != '') {
                    iCount = iCount + 1;
                }
            }
            System.debug('ccContact list' + ccContactList);

            //Set "To" field
            mail.setTargetObjectId(primaryContact);

            //Link to case
            mail.setWhatId(singleCase.Id);

            //Set email template
            mail.setTemplateId(template.Id);

            //Only add "Active" Organizer users to CC email list
            for(Contact ccContact : ccContactList) {
                if(String.valueOf(ccContact.Organizer_isActive__c) == 'Yes'
                    && ccContact.Email != null
                    && ccContact.Email.trim() != ''
                    && count < 2) {
                    ccEmailList.add(String.valueOf(ccContact.Email));
                        count++;
                }
            }

            //Set CC list
            if(ccEmailList.size() > 0) {
                mail.setCcAddresses(ccEmailList);
            }

            //Sets from equal to the org-wide email ID from previous class
            mail.setOrgWideEmailAddressId(fromId);

            mail.setTreatTargetObjectAsRecipient(true);
            mail.setSaveAsActivity(true);

            //System.debug('mail = ' + mail);
            return mail;
        }
        return null;
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////		CS WAITING EMAIL SEND		////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        public static Messaging.SingleEmailMessage sendCSWaitingEmail(Case waitingCase, EmailTemplate template, List<Contact> ccContactList, Id fromId) {
        System.debug('sendCSWaitingEmail run ' + iCount + 'times');
        if(isFirstRun() == true) {
            Id primaryContact;
            List<String> ccEmailList = new List<String>();
            Boolean primaryContactInList = FALSE;
            Date mostRecentLogin;
            Id emergencyPrimaryContact;

            //Written by Emmon on 2/1/2019 - Patches previous ccEmails. Purpose: Rather than sending to multiple ccEmails, we want to send the 
            //email to the email on the case. If not valid, send to the primary contact. If more than one primary contact, send to the primary contact
            //that has logged in first. 	

            //Use the contact's email on the case first, this is the preferred contact
            if(waitingCase.ContactEmail != null) {
                primaryContact = waitingCase.ContactId;
            } else {
				for(Contact filterPrimary: ccContactList) {

            //If there is no contact on the case, make sure they are active users that are also Primary Organizer users
            if((filterPrimary.Primary_PICS_Organizer_User__c == true) && (filterPrimary.Organizer_isActive__c == 'Yes')) {

                //If Last Login is not blank, then check for the most recent login of the primary users on the acccount associated with the case
                if(filterPrimary.Organizer_Last_Login__c != NULL
                   && (mostRecentLogin == NULL || filterPrimary.Organizer_Last_Login__c > mostRecentLogin)) {
                    mostRecentLogin = filterPrimary.Organizer_Last_Login__c;
                    primaryContact = filterPrimary.Id;

                    //If the primary users have never logged in, then we just save them as an emergency contact
                   	} else if (filterPrimary.Organizer_Last_Login__c == NULL) {
                    emergencyPrimaryContact = filterPrimary.Id;

     				}
     		}
      }
                if(primaryContact == null) { //If all primary users have never logged in, then use the emergency contact
                    primaryContact = emergencyPrimaryContact;
                }
            }

            //New instance of a single email message
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            //Set "To" field
            if(primaryContact != null) {
                mail.setTargetObjectId(primaryContact);
            } else {
                System.debug('return null');
                return null;
            }

            //Link to opportunity
            //mail.setWhatId(opty.Id);
            //Link to account
            mail.setWhatId(waitingCase.AccountId);

            //Set email template
            mail.setTemplateId(template.Id);

            //Set CC list
            if(ccEmailList.size() > 0) {
                mail.setCcAddresses(ccEmailList);
            }

            //Sets from equal to the org-wide email ID from previous class
            mail.setOrgWideEmailAddressId(fromId);

            //Set reply to equal to the new opportunity owner
            //mail.setReplyTo(opp.Owner.Email);

            mail.setTreatTargetObjectAsRecipient(true);
            mail.setSaveAsActivity(true);

            //System.debug('mail = ' + mail);
            return mail;
        }
        return null;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////		SER EMAIL AUTOMATION		///////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    //Used to send the SET Call task logged automated emails in the the supplier_SER_Opty_EmailAutomation class
    public static Messaging.SingleEmailMessage ser_SendEmail(Opportunity opp, EmailTemplate serEmailTemp, Contact OptyContact, Id fromId, ContentVersion attachment) {
        System.debug(opp);

        //New instance of a single email message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        //Set "To" field
        email.setTargetObjectId(OptyContact.Id);
        
        //Link to opportunity
        email.setWhatId(opp.Id);
        
        //Set email template
        if (serEmailTemp != NULL) {
            email.setTemplateId(serEmailTemp.Id);
        } else {
            return NULL;
        }
        
        //Sets from equal to the org-wide email ID from previous class
        email.setOrgWideEmailAddressId(fromId);

        email.setTreatTargetObjectAsRecipient(true);
        email.setSaveAsActivity(true);

        //Sets attachment
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        if(opp.Attach_Client_Letter__c == TRUE && attachment != NULL) {
            System.debug('attachment = ' + attachment);
            efa.setFileName(attachment.PathOnClient);
            efa.setBody(attachment.VersionData);
            //efa.setContentType('application/pdf');
            fileAttachments.add(efa);
        }

        if(fileAttachments.size() > 0) {
            email.setFileAttachments(fileAttachments);
        }

        return email;
    }
}