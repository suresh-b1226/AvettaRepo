//Written by Dallin Wasden 7.20.2018
//Runs on update to Vetify fulfillment case. If it is deemed the proper time by the established criteria (facilitated by Paul's workflows),
//then the 2nd, 3rd, 4th, and 5th emails are drafted through the emailHelper class and sent through this class. The Sent_Email_2__c, Sent_Email_3__c, Sent_Email_4__c, 
//and Sent_Email_5__c fields are then marked as 'true'. This trigger and class is intended as a follow-up to the Supplier_Vetify_Case_RoundRobin class.

public class Supplier_Vetify_Case_FollowUp {
    private static Boolean firstRun = true;
    private static Integer runCount = 0;
    
    //--Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }
    
    //Method to set recursion variable to false
    public static void setRunCountZero() {
        runCount = 0;
        System.debug('setRunCountZero run');
    }
    
    //Method to set recursion variable to false
    public static void addRunCount() {
        runCount = runCount + 1;
        System.debug('runCount = ' + runCount);
    }
    
    //Method to set recursion variable to true
    public static void setFirstRunTrue() {
        firstRun = true;
        System.debug('setFirstRunTrue run');
    }
    
    public void Supplier_Vetify_Case_FollowUp_Handler( List<Case> newTrigger, List<Case> oldTrigger ) {
        
        List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
        
        //Instantiate handler
        Supplier_Vetify_Case_FollowUp handler = new Supplier_Vetify_Case_FollowUp();
        List<Case> vetifyOpty = new List<Case>();
        
        //Check all cases in trigger to ensure at least one of Record Type 'Vetify' exists
        for (Case singleCase : newTrigger) {
            if (singleCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId() && 
                singleCase.Send_Fulfillment_Emails__c == TRUE) {
                vetifyOpty.add(singleCase);
            }
        }
        
        //Prevents recursion and ensures at least one of opportunities in trigger is of Record Type 'Vetify' to ensure trigger and class are necessary
        if (profileName != 'Bizable User' && Supplier_Vetify_Case_FollowUp.runCount < 3 &&
            newTrigger != null &&
            vetifyOpty.size() > 0) {
                
                List<Case> firstEmailList = new List<Case>();
                List<Case> secondEmailList = new List<Case>();
                List<Case> thirdEmailList = new List<Case>();
                List<Case> fourthEmailList = new List<Case>();
                List<Case> fifthEmailList = new List<Case>();
                List<Case> activeEmailList = new List<Case>();
                List<Id> accountIds = new List<Id>();
                
                /*Vetify Legacy Accounts. Replaced 1.11.19 to use similar logic for Vetify Annual Update emailing
                //SOQL query to retrieve email template IDs
                //*****Add the Legacy templates to the templateList once the templates are created
                List<EmailTemplate> templateList = [
                SELECT Id, DeveloperName
                FROM EmailTemplate
                WHERE DeveloperName = 'Vetify_Fulfillment_1_Canada'
                OR DeveloperName = 'Vetify_Fulfillment_2_Canada'
                OR DeveloperName = 'Vetify_Fulfillment_3_Canada'
                OR DeveloperName = 'Vetify_Fulfillment_4_Canada'
                OR DeveloperName = 'Vetify_Fulfillment_5_Canada'
                OR DeveloperName = 'Vetify_Fulfillment_1_US'
                OR DeveloperName = 'Vetify_Fulfillment_2_US'
                OR DeveloperName = 'Vetify_Fulfillment_3_US'
                OR DeveloperName = 'Vetify_Fulfillment_4_US'
                OR DeveloperName = 'Vetify_Fulfillment_5_US'
                OR DeveloperName = 'Vetify_Fulfillment_Active'
                OR DeveloperName = 'Vetify_Fulfillment_Legacy_1'
                OR DeveloperName = 'Vetify_Fulfillment_Legacy_2'
                OR DeveloperName = 'Vetify_Fulfillment_Legacy_3'
                OR DeveloperName = 'Vetify_Fulfillment_Legacy_4'
                OR DeveloperName = 'Vetify_Fulfillment_Active_Legacy'
                ];
                System.debug('template ID = ' + templateList);
                */
                
                //SOQL query to retrieve email template IDs
                //*****Add the Legacy templates to the templateList once the templates are created
                List<EmailTemplate> templateList = [
                    SELECT Id, DeveloperName
                    FROM EmailTemplate
                    WHERE DeveloperName = 'Vetify_Fulfillment_1_Canada'
                    OR DeveloperName = 'Vetify_Fulfillment_2_Canada'
                    OR DeveloperName = 'Vetify_Fulfillment_3_Canada'
                    OR DeveloperName = 'Vetify_Fulfillment_4_Canada'
                    OR DeveloperName = 'Vetify_Fulfillment_5_Canada'
                    OR DeveloperName = 'Vetify_Fulfillment_1_US'
                    OR DeveloperName = 'Vetify_Fulfillment_2_US'
                    OR DeveloperName = 'Vetify_Fulfillment_3_US'
                    OR DeveloperName = 'Vetify_Fulfillment_4_US'
                    OR DeveloperName = 'Vetify_Fulfillment_5_US'
                    OR DeveloperName = 'Vetify_Fulfillment_Active'
                    OR DeveloperName = 'Vetify_AU_US_1'
                    OR DeveloperName = 'Vetify_AU_US_2'
                    OR DeveloperName = 'Vetify_AU_US_3'
                    OR DeveloperName = 'Vetify_AU_US_4'
                    OR DeveloperName = 'Vetify_AU_US_5'
                    OR DeveloperName = 'Vetify_AU_Canada_1'
                    OR DeveloperName = 'Vetify_AU_Canada_2'
                    OR DeveloperName = 'Vetify_AU_Canada_3'
                    OR DeveloperName = 'Vetify_AU_Canada_4'
                    OR DeveloperName = 'Vetify_AU_Canada_5'
                    OR DeveloperName = 'Vetify_AU_Active'
                ];
                System.debug('template ID = ' + templateList);
                
                //SOQL query all users with role 'Vetify Fulfillment'
                List<User> userList = [
                    SELECT Id, Name, Email
                    FROM User
                    WHERE UserRole.Name = 'Vetify Fulfillment'
                ];
                System.debug('userList =' + userList);
                
                //SOQL query to retrieve orgWideEmail ID for the 'info@vetify.com' email address
                List<OrgWideEmailAddress> orgWideEmails = [
                    SELECT Id, Address
                    FROM OrgWideEmailAddress
                    WHERE Address = :'info@vetify.com' or Address = :'documents@vetify.com'
                ];
                
                OrgWideEmailAddress infoEmail;
                OrgWideEmailAddress documentEmail;
                for(OrgWideEmailAddress orgwideEmail : orgWideEmails) {
                    if(orgwideEmail.Address == 'info@vetify.com') {
                        infoEmail = orgwideEmail;
                    } else if(orgwideEmail.Address == 'documents@vetify.com') {
                        documentEmail = orgwideEmail;
                    }
                }
                
                Automation_Switch__mdt vetifySwitch = [
                    SELECT Id, Label, On_Off__c
                    FROM Automation_Switch__mdt
                    WHERE Label = 'Vetify: Email'
                ];
                System.debug('vetifySwitch = ' + vetifySwitch);
                
                if (vetifySwitch.On_Off__c == true) {
                    //Test all updated cases in trigger to verify appropriate conditions are met according to auto-email cadence. Adds all opportunities matching criteria to a list.
                    for (Case singleCase : newTrigger) {
                        Case matchingOldCase;

                        if(singleCase.Send_Fulfillment_Emails__c) {
                        
                            for (Case oldCase : oldTrigger) {
                                if (oldCase.Id == singleCase.Id) {
                                    matchingOldCase = oldCase;
                                }
                            }
                            
                            System.debug('scor singleCase = ' + singleCase);
                            System.debug('matchingOldCase = ' + matchingOldCase);
                            
                            //List all AccountIds linked to opportunities in trigger
                            accountIds.add(singleCase.AccountId);
                            
                            //Cases to receive first email (exception handler when old trigger is null)
                            if (singleCase.Id != null &&
                                singleCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId() &&
                                singleCase.Type == 'Fulfillment' &&
                                singleCase.Status == 'Pending') {
                                    if (singleCase.Sent_Email_1__c != true &&
                                        singleCase.Sent_Email_2__c != true &&
                                        singleCase.Sent_Email_3__c != true &&
                                        singleCase.Sent_Email_4__c != true &&
                                        singleCase.Sent_Email_5__c != true &&
                                        matchingOldCase == null &&
                                        singleCase.Send_Email_1__c != null) {
                                            firstEmailList.add(singleCase);
                                        }
                                    
                                    //Cases to receive first email
                                    else if (singleCase.Sent_Email_1__c != true &&
                                             singleCase.Sent_Email_2__c != true &&
                                             singleCase.Sent_Email_3__c != true &&
                                             singleCase.Sent_Email_4__c != true &&
                                             singleCase.Sent_Email_5__c != true &&
                                             singleCase.Send_Email_1__c != matchingOldCase.Send_Email_1__c &&
                                             singleCase.Send_Email_1__c != null) {
                                                 firstEmailList.add(singleCase);
                                             }
                                    
                                    //Cases to receive second email
                                    else if (singleCase.Sent_Email_1__c == true &&
                                             singleCase.Sent_Email_2__c != true &&
                                             singleCase.Sent_Email_3__c != true &&
                                             singleCase.Sent_Email_4__c != true &&
                                             singleCase.Sent_Email_5__c != true &&
                                             singleCase.Send_Email_2__c != matchingOldCase.Send_Email_2__c &&
                                             singleCase.Send_Email_2__c != null) {
                                                 secondEmailList.add(singleCase);
                                             }
                                    
                                    //Cases to receive third email
                                    else if (singleCase.Sent_Email_1__c == true &&
                                             singleCase.Sent_Email_2__c == true &&
                                             singleCase.Sent_Email_3__c != true &&
                                             singleCase.Sent_Email_4__c != true &&
                                             singleCase.Sent_Email_5__c != true &&
                                             singleCase.Send_Email_3__c != matchingOldCase.Send_Email_3__c &&
                                             singleCase.Send_Email_3__c != null) {
                                                 thirdEmailList.add(singleCase);
                                             }
                                    
                                    //Cases to receive fourth email
                                    else if (singleCase.Sent_Email_1__c == true &&
                                             singleCase.Sent_Email_2__c == true &&
                                             singleCase.Sent_Email_3__c == true &&
                                             singleCase.Sent_Email_4__c != true &&
                                             singleCase.Sent_Email_5__c != true &&
                                             singleCase.Send_Email_4__c != matchingOldCase.Send_Email_4__c &&
                                             singleCase.Send_Email_4__c != null) {
                                                 fourthEmailList.add(singleCase);
                                             }
                                    
                                    //Cases to receive fifth email
                                    else if (singleCase.Sent_Email_1__c == true &&
                                             singleCase.Sent_Email_2__c == true &&
                                             singleCase.Sent_Email_3__c == true &&
                                             singleCase.Sent_Email_4__c == true &&
                                             singleCase.Sent_Email_5__c != true &&
                                             singleCase.Send_Email_5__c != matchingOldCase.Send_Email_5__c &&
                                             singleCase.Send_Email_5__c != null) {
                                                 fifthEmailList.add(singleCase);
                                             }
                                }
                            
                            //Cases to receive active welcome email
                            else if (oldTrigger != null &&
                                     singleCase.Id != null &&
                                     singleCase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId() &&
                                     singleCase.Status == 'Active' &&
                                     singleCase.Status != matchingOldCase.Status) {
                                         activeEmailList.add(singleCase);
                                     }
                        }
                    }
                    System.debug('firstEmailList = ' + firstEmailList);
                    System.debug('secondEmailList = ' + secondEmailList);
                    System.debug('thirdEmailList = ' + thirdEmailList);
                    System.debug('fourthEmailList = ' + fourthEmailList);
                    System.debug('fifthEmailList = ' + fifthEmailList);
                    System.debug('activeEmailList = ' + activeEmailList);
                    
                    //SOQL query to return additional necessary fields
                    List<Case> emailListData = [
                        SELECT Id,
                        Owner.Email,
                        Account.BillingCountry,
                        Account.BillingState,
                        ContactId,
                        Contact.Name,
                        ContactEmail,
                        Status,
                        Sent_Email_1__c,
                        Sent_Email_2__c,
                        Sent_Email_3__c,
                        Sent_Email_4__c,
                        Sent_Email_5__c,
                        Send_Email_1__c,
                        Send_Email_2__c,
                        Send_Email_3__c,
                        Send_Email_4__c,
                        Send_Email_5__c,
                        Vetify_Legacy__c
                        FROM Case
                        WHERE Id = :firstEmailList
                        OR Id = :secondEmailList
                        OR Id = :thirdEmailList
                        OR Id = :fourthEmailList
                        OR Id = :fifthEmailList
                        OR Id = :activeEmailList
                    ];
                    
                    List<Case> singleCaseStatusUpdate = new List<Case>();
                    List<Messaging.SingleEmailMessage> mailList = new List< Messaging.SingleEmailMessage >();
                    
                    //Originially instantiated list of type ID, but had to change to type string due to SFDC bug
                    List<String> userListIds = new List<String>();
                    for (User vetifyUser : userList) {
                        userListIds.add(String.valueOf(vetifyUser.Id));
                    }
                    
                    //SOQL query to populate list of all case-associated CC email addresses as a lookup from the account
                    List<Contact> ccContactList = [
                        SELECT Email, Organizer_isActive__c, Primary_PICS_Organizer_User__c, AccountId
                        FROM Contact
                        WHERE AccountId = :accountIds
                        AND Email != NULL
                    ];
                    System.debug('ccContactList = ' + ccContactList);
                    
                    //Instantiates email template objects
                    EmailTemplate firstTemplateCanada;
                    EmailTemplate secondTemplateCanada;
                    EmailTemplate thirdTemplateCanada;
                    EmailTemplate fourthTemplateCanada;
                    EmailTemplate fifthTemplateCanada;
                    EmailTemplate firstTemplateUS;
                    EmailTemplate secondTemplateUS;
                    EmailTemplate thirdTemplateUS;
                    EmailTemplate fourthTemplateUS;
                    EmailTemplate fifthTemplateUS;
                    EmailTemplate activeTemplate;
                    EmailTemplate firstUSLegacyTemplate;
                    EmailTemplate secondUSLegacyTemplate;
                    EmailTemplate thirdUSLegacyTemplate;
                    EmailTemplate fourthUSLegacyTemplate;
                    EmailTemplate fifthUSLegacyTemplate;
                    EmailTemplate firstCanadaLegacyTemplate;
                    EmailTemplate secondCanadaLegacyTemplate;
                    EmailTemplate thirdCanadaLegacyTemplate;
                    EmailTemplate fourthCanadaLegacyTemplate;
                    EmailTemplate fifthCanadaLegacyTemplate;
                    EmailTemplate activeLegacyTemplate;
                    
                    /*Replaced 1.11.19 to use for Annual Update
                    //Instantiates email template objects
                    EmailTemplate firstTemplateCanada;
                    EmailTemplate secondTemplateCanada;
                    EmailTemplate thirdTemplateCanada;
                    EmailTemplate fourthTemplateCanada;
                    EmailTemplate fifthTemplateCanada;
                    EmailTemplate firstTemplateUS;
                    EmailTemplate secondTemplateUS;
                    EmailTemplate thirdTemplateUS;
                    EmailTemplate fourthTemplateUS;
                    EmailTemplate fifthTemplateUS;
                    EmailTemplate activeTemplate;
                    EmailTemplate firstLegacyTemplate;
                    EmailTemplate secondLegacyTemplate;
                    EmailTemplate thirdLegacyTemplate;
                    EmailTemplate fourthLegacyTemplate;
                    EmailTemplate activeLegacyTemplate;
					*/
                    
                    //Populates email template objects from previous SOQL query results
                    //*****Add the new Legacy templates once they are created and added to SOQL query in Trigger
                    for (EmailTemplate template : templateList) {
                        if (template.DeveloperName == 'Vetify_Fulfillment_1_Canada') {
                            firstTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_2_Canada') {
                            secondTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_3_Canada') {
                            thirdTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_4_Canada') {
                            fourthTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_5_Canada') {
                            fifthTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_1_US') {
                            firstTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_2_US') {
                            secondTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_3_US') {
                            thirdTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_4_US') {
                            fourthTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_5_US') {
                            fifthTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_Active') {
                            activeTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_US_1') {
                            firstUSLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_US_2') {
                            secondUSLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_US_3') {
                            thirdUSLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_US_4') {
                            fourthUSLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_US_5') {
                            fifthUSLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_Canada_1') {
                            firstCanadaLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_Canada_2') {
                            secondCanadaLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_Canada_3') {
                            thirdCanadaLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_Canada_4') {
                            fourthCanadaLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_AU_Canada_5') {
                            fifthCanadaLegacyTemplate = template;
                        }  else if (template.DeveloperName == 'Vetify_AU_Active') {
                            activeLegacyTemplate = template;
                        }
                    }
                    
                    /*Changed on 1.11.19 to adapt Vetify Legacy logic to apply to Annual Update emails
                    //Populates email template objects from previous SOQL query results
                    //*****Add the new Legacy templates once they are created and added to SOQL query in Trigger
                    for (EmailTemplate template : templateList) {
                        if (template.DeveloperName == 'Vetify_Fulfillment_1_Canada') {
                            firstTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_2_Canada') {
                            secondTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_3_Canada') {
                            thirdTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_4_Canada') {
                            fourthTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_5_Canada') {
                            fifthTemplateCanada = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_1_US') {
                            firstTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_2_US') {
                            secondTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_3_US') {
                            thirdTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_4_US') {
                            fourthTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_5_US') {
                            fifthTemplateUS = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_Active') {
                            activeTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_Legacy_1') {
                            firstLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_Legacy_2') {
                            secondLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_Legacy_3') {
                            thirdLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_Legacy_4') {
                            fourthLegacyTemplate = template;
                        } else if (template.DeveloperName == 'Vetify_Fulfillment_Active_Legacy') {
                            activeLegacyTemplate = template;
                        }
                    }
                    */
                    System.debug('emailListData = ' + emailListData);
                    
                    //Iterate through cases to create emails
                    for (Case singleCase : emailListData) {
                        
                        Id fromId;
                        if(singleCase.Vetify_Legacy__c == TRUE) {
                        	//fromId = documentEmail.Id;
                        	//Changed by Dallin Wasden 2.18.2020
                            fromId = infoEmail.Id;
                        } else {
                            fromId = infoEmail.Id;
                        }
                        
                        //If 'Legacy' is checked in case, send Legacy email information.
                        if (singleCase.Vetify_Legacy__c == True) {
                            //Find opportunity's associated CC email addresses
                            List<Contact> caseCCContactsLegacy = new List<Contact>();
                            List<String> ccContactEmailsLegacy = new List<String>();
                            for (Contact ccContact : ccContactList) {
                                if (ccContact.AccountId == singleCase.AccountId) {
                                    if (ccContact.Id != singleCase.ContactId &&
                                        ccContact.Email != singleCase.ContactEmail &&
                                        ccContactEmailsLegacy.contains(ccContact.Email) == false) {
                                            caseCCContactsLegacy.add(ccContact);
                                            ccContactEmailsLegacy.add(ccContact.Email);
                                        }
                                }
                            }
                            
                            System.debug('singleCase = ' + singleCase);
                            System.debug('fromId = ' + fromId);
                            System.debug('orgWideEmails = ' + orgWideEmails);
                            System.debug('caseCCContacts = ' + caseCCContactsLegacy);
                            
                            //Change proper 'Sent Email' box to true and send proper email template depending on which conditions are met. Also checks to ensure Owner is a Vetify
                            //rep to prevent unassigned emails sending non-Vetify users
                            
                            //Creates welcome email from active template
                            if (singleCase.Status == 'Active' &&
                                userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                    System.debug('Mail to Legacy Account = ' + singleCase + ' ' + activeLegacyTemplate + ' ' + ' ' + fromId);
                                    mailList.add(emailHelper.sendVetifyEmail(singleCase, activeLegacyTemplate, fromId, caseCCContactsLegacy));
                                }
                            
                            //Creates email from first template
                            else if (singleCase.Sent_Email_1__c != true &&
                                     singleCase.Sent_Email_2__c != true &&
                                     singleCase.Sent_Email_3__c != true &&
                                     singleCase.Sent_Email_4__c != true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         //System.debug('Formatting first email with ' + singleCase + firstLegacyTemplate + fromId);
                                         if (singleCase.Account.BillingCountry == 'US' || singleCase.Account.BillingCountry == 'United States') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, firstUSLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_1__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, firstCanadaLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_1__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                            
                            //Creates email from second template
                            else if (singleCase.Sent_Email_1__c == true &&
                                     singleCase.Sent_Email_2__c != true &&
                                     singleCase.Sent_Email_3__c != true &&
                                     singleCase.Sent_Email_4__c != true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         //System.debug('Formatting second email with ' + singleCase + secondLegacyTemplate + fromId);
                                         if (singleCase.Account.BillingCountry == 'US' || singleCase.Account.BillingCountry == 'United States') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, secondUSLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_2__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, secondCanadaLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_2__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                            
                            //Creates email from third template
                            else if (singleCase.Sent_Email_1__c == true &&
                                     singleCase.Sent_Email_2__c == true &&
                                     singleCase.Sent_Email_3__c != true &&
                                     singleCase.Sent_Email_4__c != true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         //System.debug('Formatting third email with ' + singleCase + thirdLegacyTemplate + fromId);
                                         if (singleCase.Account.BillingCountry == 'US' || singleCase.Account.BillingCountry == 'United States') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, thirdUSLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_3__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, thirdCanadaLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_3__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                            
                            //Creates email from fourth template
                            else if (singleCase.Sent_Email_1__c == true &&
                                     singleCase.Sent_Email_2__c == true &&
                                     singleCase.Sent_Email_3__c == true &&
                                     singleCase.Sent_Email_4__c != true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         //System.debug('Formatting fourth email with ' + singleCase + fourthLegacyTemplate + fromId);
                                         if (singleCase.Account.BillingCountry == 'US' || singleCase.Account.BillingCountry == 'United States') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, fourthUSLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_4__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, fourthCanadaLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_4__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                            else if (singleCase.Sent_Email_1__c == true &&
                                     singleCase.Sent_Email_2__c == true &&
                                     singleCase.Sent_Email_3__c == true &&
                                     singleCase.Sent_Email_4__c == true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         //System.debug('Formatting fourth email with ' + singleCase + fourthLegacyTemplate + fromId);
                                         if (singleCase.Account.BillingCountry == 'US' || singleCase.Account.BillingCountry == 'United States') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, fifthUSLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_5__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             //System.debug('Mail to Legacy Account = ' + singleCase + ' ' + firstLegacyTemplate + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, fifthCanadaLegacyTemplate, fromId, caseCCContactsLegacy));
                                             singleCase.Sent_Email_5__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                        }
                        //If Legacy is not checked, send emails from non-Legacy account templates
                        else if (singleCase.Vetify_Legacy__c == False) {
                            //Find opportunity's associated CC email addresses
                            List<Contact> caseCCContacts = new List<Contact>();
                            List<String> ccContactEmails = new List<String>();
                            for (Contact ccContact : ccContactList) {
                                if (ccContact.AccountId == singleCase.AccountId) {
                                    if (ccContact.Id != singleCase.ContactId &&
                                        ccContact.Email != singleCase.ContactEmail &&
                                        ccContactEmails.contains(ccContact.Email) == false) {
                                            caseCCContacts.add(ccContact);
                                            ccContactEmails.add(ccContact.Email);
                                        }
                                }
                            }
                            
                            System.debug('singleCase = ' + singleCase);
                            System.debug('fromId = ' + fromId);
                            System.debug('orgWideEmails = ' + orgWideEmails);
                            System.debug('caseCCContacts = ' + caseCCContacts);
                            
                            //Change proper 'Sent Email' box to true and send proper email template depending on which conditions are met. Also checks to ensure Owner is a Vetify
                            //rep to prevent unassigned emails sending non-Vetify users
                            
                            //Creates welcome email from active template
                            if (singleCase.Status == 'Active' &&
                                userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                    System.debug('Mail to Canada = ' + singleCase + ' ' + activeTemplate + ' ' + ' ' + fromId);
                                    mailList.add(emailHelper.sendVetifyEmail(singleCase, activeTemplate, fromId, caseCCContacts));
                                }
                            
                            //Creates email from first template
                            else if (singleCase.Sent_Email_1__c != true &&
                                     singleCase.Sent_Email_2__c != true &&
                                     singleCase.Sent_Email_3__c != true &&
                                     singleCase.Sent_Email_4__c != true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         System.debug('Formatting first email with ' + singleCase + firstTemplateUS + fromId);
                                         if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             System.debug('Mail to Canada = ' + singleCase + ' ' + firstTemplateCanada + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, firstTemplateCanada, fromId, caseCCContacts));
                                             singleCase.Sent_Email_1__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if (singleCase.Account.BillingCountry == 'United States' || singleCase.Account.BillingCountry == 'US') {
                                             System.debug('Mail to US = ' + singleCase + ' ' + firstTemplateUS + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, firstTemplateUS, fromId, caseCCContacts));
                                             singleCase.Sent_Email_1__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                            
                            //Creates email from second template
                            else if (singleCase.Sent_Email_1__c == true &&
                                     singleCase.Sent_Email_2__c != true &&
                                     singleCase.Sent_Email_3__c != true &&
                                     singleCase.Sent_Email_4__c != true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         System.debug('Formatting second email with ' + singleCase + secondTemplateCanada + fromId);
                                         if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             System.debug('Mail to Canada = ' + singleCase + ' ' + secondTemplateCanada + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, secondTemplateCanada, fromId, caseCCContacts));
                                             singleCase.Sent_Email_2__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if (singleCase.Account.BillingCountry == 'United States' || singleCase.Account.BillingCountry == 'US') {
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, secondTemplateUS, fromId, caseCCContacts));
                                             singleCase.Sent_Email_2__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                            
                            //Creates email from third template
                            else if (singleCase.Sent_Email_1__c == true &&
                                     singleCase.Sent_Email_2__c == true &&
                                     singleCase.Sent_Email_3__c != true &&
                                     singleCase.Sent_Email_4__c != true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         System.debug('Formatting third email with ' + singleCase + thirdTemplateCanada + fromId);
                                         if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             System.debug('Mail to Canada = ' + singleCase + ' ' + thirdTemplateCanada + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, thirdTemplateCanada, fromId, caseCCContacts));
                                             singleCase.Sent_Email_3__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if (singleCase.Account.BillingCountry == 'United States' || singleCase.Account.BillingCountry == 'US') {
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, thirdTemplateUS, fromId, caseCCContacts));
                                             singleCase.Sent_Email_3__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                            
                            //Creates email from fourth template
                            else if (singleCase.Sent_Email_1__c == true &&
                                     singleCase.Sent_Email_2__c == true &&
                                     singleCase.Sent_Email_3__c == true &&
                                     singleCase.Sent_Email_4__c != true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         System.debug('Formatting fourth email with ' + singleCase + fourthTemplateCanada + fromId);
                                         if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             System.debug('Mail to Canada = ' + singleCase + ' ' + fourthTemplateCanada + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, fourthTemplateCanada, fromId, caseCCContacts));
                                             singleCase.Sent_Email_4__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if (singleCase.Account.BillingCountry == 'United States' || singleCase.Account.BillingCountry == 'US') {
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, fourthTemplateUS, fromId, caseCCContacts));
                                             singleCase.Sent_Email_4__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                            
                            //Creates email from fifth template
                            else if (singleCase.Sent_Email_1__c == true &&
                                     singleCase.Sent_Email_2__c == true &&
                                     singleCase.Sent_Email_3__c == true &&
                                     singleCase.Sent_Email_4__c == true &&
                                     singleCase.Sent_Email_5__c != true &&
                                     userListIds.contains(String.valueOf(singleCase.OwnerId)) == true) {
                                         System.debug('Formatting fourth email with ' + singleCase + fourthTemplateCanada + fromId);
                                         if ((singleCase.Account.BillingCountry == 'Canada' || singleCase.Account.BillingCountry == 'CA') && singleCase.Account.BillingState != 'Quebec') {
                                             //Add email template to list to be used in a bulk send
                                             System.debug('Mail to Canada = ' + singleCase + ' ' + fifthTemplateCanada + ' ' + ' ' + fromId);
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, fifthTemplateCanada, fromId, caseCCContacts));
                                             singleCase.Sent_Email_5__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         } else if (singleCase.Account.BillingCountry == 'United States' || singleCase.Account.BillingCountry == 'US') {
                                             mailList.add(emailHelper.sendVetifyEmail(singleCase, fifthTemplateUS, fromId, caseCCContacts));
                                             singleCase.Sent_Email_5__c = true;
                                             if (singleCase != null) {
                                                 singleCaseStatusUpdate.add(singleCase);
                                             }
                                         }
                                     }
                        }
                    }
                    
                    //Calls recursion prevention methods
                    addRunCount();
                    
                    //Bulk update all cases with new attributes
                    update singleCaseStatusUpdate;
                    
                    System.debug('mailList = ' + mailList);
                    System.debug('emailListData = ' + emailListData);
                    
                    //Bulk send all email templates if they exist
                    if (mailList != null) {
                        Messaging.sendEmail(mailList);
                    }
                }
            }
    }
}