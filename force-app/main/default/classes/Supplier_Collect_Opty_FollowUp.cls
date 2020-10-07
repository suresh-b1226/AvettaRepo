/**

Written by Dallin Wasden 5.21.2018
Checks to see where updated Collections opportunity is in the emailing process. If it is deemed the proper time by the established criteria (facilitated by Spencer's workflow),
then the 2nd, 3rd, and 4th emails are drafted through the emailHelper class and sent through this class. The Sent_Email_2__c, Sent_Email_3__c, and Sent_Email_4__c fields are then
checked accordingly. This trigger and class is intended as a follow-up to the Supplier_Collect_Opty_RoundRobin class.

Edited By Jason McGrew on 10.16.2019 for SF Case 01362319.
- Created a new Automation Switch to shut off the India Email from being sent.
- Switch was placed in it own private method and called in the Handler method.

Updated on 02.12.2020 by Jason McGrew for SF Case 01481300.

*/

public class Supplier_Collect_Opty_FollowUp {
    private static Boolean firstRun = true;
    private static Integer runCount = 0;
    
    //Used to prevent recursion
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
    
    //Method to return a random Integer between 0 and passed through integer
    public static Integer getRandomNumber(Integer size){
        Double d = Math.random() * size;
        return d.intValue();
    }
    
    private Boolean getCollection_Follow_up_India_AutomationSwitchStatus() {
        Automation_Switch__mdt Collection_Follow_up_India = [
            SELECT On_Off__c
            FROM Automation_Switch__mdt
            WHERE Label = 'Collection: Follow-up India'
        ];
        return Collection_Follow_up_India.On_Off__c;
    }
    
    public void Supplier_Collect_Opty_FollowUp_Handler( List<Opportunity> newTrigger, List<Opportunity> oldTrigger ) {
        
        System.debug('RUN YO');
        System.debug('New Trigger: ' + newTrigger);
        System.debug('Old Trigger: ' + oldTrigger);
      
        //Instantiate handler
        Supplier_Collect_Opty_FollowUp handler = new Supplier_Collect_Opty_FollowUp();
        List<Opportunity> collectionsOpty = new List<Opportunity>();
        
        //Check all opportunities in trigger to ensure at least one of Record Type 'Collections' exists
        //Make sure one of the 'send email' fields has been changed.
        for (Opportunity opty : newTrigger) {
            Integer iCount = 0;
            if (opty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId()
                && (opty.Send_Email_1__c != oldTrigger[iCount].Send_Email_1__c
                    || opty.Send_Email_2__c != oldTrigger[iCount].Send_Email_2__c
                    || opty.Send_Email_3__c != oldTrigger[iCount].Send_Email_3__c
                    || opty.Send_Email_4__c != oldTrigger[iCount].Send_Email_4__c
                    || opty.Send_Email_5__c != oldTrigger[iCount].Send_Email_5__c)) {
                        
                        collectionsOpty.add(opty);
                    }
            iCount++;
        }
        
        System.debug('Supplier_Collect_Opty_FollowUp.runCount = ' + Supplier_Collect_Opty_FollowUp.runCount);
        //Prevents recursion and ensures at least one of opportunities in trigger is of Record Type 'Collections' to ensure trigger and class are necessary
        if (Supplier_Collect_Opty_FollowUp.runCount < 5
            && newTrigger != null
            && collectionsOpty.size() > 0) {
                
                List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        		String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
               
                  System.debug('HEY BUDDY GUY');
                
                if (profileName != 'Bizable User') {
                    
                    System.debug('HEY BUDDY GUY 2');
                    
                    List<Opportunity> firstEmailList  = new List<Opportunity>();
                    List<Opportunity> secondEmailList = new List<Opportunity>();
                    List<Opportunity> thirdEmailList  = new List<Opportunity>();
                    List<Opportunity> fourthEmailList = new List<Opportunity>();
                    List<Opportunity> fifthEmailList  = new List<Opportunity>();
                    
                    
                    //SOQL query to retrieve email template IDs
                    List<EmailTemplate> templateList = [
                        SELECT Id, DeveloperName
                        FROM EmailTemplate
                        WHERE DeveloperName = 'Collections_System_Email_1'
                        OR DeveloperName = 'Collections_System_Email_2'
                        OR DeveloperName = 'Collections_System_Email_3'
                        OR DeveloperName = 'Collections_System_Email_4'
                        OR DeveloperName = 'Collections_System_Email_5'
                        OR DeveloperName = 'Collections_System_Email_1_US'
                        OR DeveloperName = 'Collections_System_Email_2_US'
                        OR DeveloperName = 'Collections_System_Email_3_US'
                        OR DeveloperName = 'Collections_System_Email_4_US'
                        OR DeveloperName = 'Collections_System_Email_1_India'
                        OR DeveloperName = 'Collections_System_Email_2_India'
                        OR DeveloperName = 'Collections_System_Email_3_India'
                        OR DeveloperName = 'Collections_System_Email_4_India'
                        OR DeveloperName = 'Collections_System_Email_1_Hindi'
                        OR DeveloperName = 'Collections_System_Email_2_Hindi'
                        OR DeveloperName = 'Collections_System_Email_3_Hindi'
                        OR DeveloperName = 'Collections_System_Email_4_Hindi'
                        OR DeveloperName = 'Collections_System_Email_1_Renewal'
                        OR DeveloperName = 'Collections_System_Email_2_Renewal'
                        OR DeveloperName = 'Collections_System_Email_3_Renewal'
                        OR DeveloperName = 'Collections_System_Email_4_Renewal'
                        OR DeveloperName = 'Collections_System_Email_5_Renewal'
                    ];
                    
                    System.debug('template ID = ' + templateList);
                    
                    //SOQL query all users with role 'Collections'
                    List<User> userList = [
                        SELECT Id, Name, Email
                        FROM User
                        WHERE UserRole.Name = 'Collections'
                    ];
                    System.debug('userList =' + userList);
                    
                    //SOQL query automation switch
                    Automation_Switch__mdt collectionFUSwitch = [
                        SELECT Id, Label, On_Off__c
                        FROM Automation_Switch__mdt
                        WHERE Label = 'Collection: Follow-up'
                    ];
                    System.debug('collectionFUSwitch = ' + collectionFUSwitch);
                    
                    //List all AccountIds linked to opportunities in trigger
                    List<Id> accountIds = new List<Id>();
                    List<Id> invoiceIds = new List<Id>(); //Added by Emmon Chow -  4/24/2019
                    for (Opportunity opty : newTrigger) {
                        accountIds.add(opty.AccountId);
                        invoiceIds.add(opty.Invoice__c);
                    }
                    
                    //System.debug('!!!: invoiceIds list: ' + invoiceIds);
                    
                    //SOQL query all existing opportunities linked to AccountIds
                    List<Opportunity> linkedOptyList = [
                        SELECT Id, Name, StageName, AccountId, RecordTypeId, Account.Status__c, Invoice__c
                        FROM Opportunity
                        WHERE AccountId = :accountIds
                    ];
                    
                    System.debug('linkedOptyList =' + linkedOptyList);
                    
                    //Added by Emmon - 4/24/2019
                    List<Zuora__ZInvoice__c> linkedInvoiceList = [
                        SELECT Id, Zuora__Balance2__c
                        FROM Zuora__ZInvoice__c
                        WHERE Id = :invoiceIds
                    ];
                    
                    //Identifies which triggered opportunities should be exempt from Collections
                    //Emails due to another opportunity on its account with an outstanding deactivation request
                    //OR on a deactivated account
                    //
                    //ADD RENEWAL?
                    List<String> exemptOpty = new List<String>();
                    for (Opportunity opty : newTrigger) {
                        for (Opportunity associatedOpty : linkedOptyList) {
                            System.debug('associatedOpty = ' + associatedOpty);
                           
                            if (associatedOpty.AccountId == opty.AccountId &&
                                (associatedOpty.Account.Status__c == 'Deactivated' ||
                                 
                                 //- - - - - - SAVES DOWNGRADE Exempt Associated Opportunities - - - - - - - - - - - - - //
                                 (associatedOpty.RecordTypeId 	== Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId() &&
                                  (associatedOpty.StageName 	== 'In Progress' ||
                                   associatedOpty.StageName 	== 'Removed Client Connection' ||			//Send if 'Retained',  'Commit'
                                   associatedOpty.StageName 	== 'Request Cancelled')) ||
                                 
                                 // - OR - - - RETENTION Exempt Associated Opportunities - - - - - - - -
                                 (associatedOpty.RecordTypeId 	== Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId() &&
                                  (associatedOpty.StageName 	== 'Open' ||
                                   associatedOpty.StageName 	== 'Attempted' ||
                                   associatedOpty.StageName 	== 'In Progress' ||
                                   associatedOpty.StageName 	== 'Ready for Deactivation' ||
                                   associatedOpty.StageName 	== 'Ready for Deactivation - Refund' ||
                                   associatedOpty.StageName 	== 'Deactivated')))) {
                                       exemptOpty.add(String.valueOf(opty.AccountId));
                                       System.debug('added exemption = ' + opty);
                                   }
                        }
                    }
                    
                    //Populate list of email addresses that will be used in SOQL query below to determine
                    //the org-wide email ID associated with the user email address
                    List<String> collectionEmails = new List<String>();
                    for (User collectionUser : userList) {
                        collectionEmails.add(collectionUser.Email);
                    }
                    
                    //SOQL query all users with role 'Collections'
                    List<OrgWideEmailAddress> orgWideEmails = [
                        SELECT Id, Address
                        FROM OrgWideEmailAddress
                        WHERE Address = :collectionEmails
                    ];
                    
                    //If collections follow-up switch is turned on
                    if (collectionFUSwitch.On_Off__c == true) {
                        //Test all updated opportunities in trigger to verify appropriate conditions are met
                        //according to auto-email cadence. Adds all opportunities matching criteria to a list.
                        for (Opportunity opp : newTrigger) {
                            System.debug('scor opp = ' + opp);
                            System.debug('Triggers = ' + Trigger.new + '!!!!!!!!!!' + Trigger.old);
                            System.debug('exemptOpty = ' + exemptOpty);
                            System.debug('opp.AccountId ' + opp.AccountId);
                            
                            Opportunity matchingOpportunity;
                            
                            System.debug('oldTrigger = ' + oldTrigger);
                            for (Opportunity opty : oldTrigger) {
                                if (opty.Id == opp.Id) {
                                    matchingOpportunity = opty;
                                }
                            }
                            
                            //Added by Emmon 4/4/2019 - Finds the balance of the invoice on the opportunity
                            Boolean owedInvoice = false;
                            for (Opportunity opty : newTrigger) {
                                if (opty.Invoice__c == null) {
                                    owedInvoice = true;
                                    break;
                                } else if (opty.Id == opp.Id) {
                                    for	(Zuora__ZInvoice__c invoice : linkedInvoiceList) {
                                        if ((invoice.Id == opp.Invoice__c)
                                            && (invoice.Zuora__Balance2__c > 0.0)
                                            && (invoice.Zuora__Balance2__c != null)) {
                                                owedInvoice = true;
                                                break;
                                            }
                                    }
                                    break;
                                }
                            }
                            
                            if (exemptOpty.contains(String.valueOf(opp.AccountId)) == false &&
                                opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId() &&
                                (owedInvoice == true) && 							//If balance is over $0.00 - Emmon 4/4/2018
                                (opp.StageName != 'Commit' &&
                                 opp.StageName != 'Collected' &&
                                 opp.StageName != 'Hold' &&
                                 opp.StageName != 'Deactivated' &&
                                 opp.StageName != 'Deactivation Request' &&
                                 opp.StageName != 'Ready for Deactivation' &&
                                 opp.StageName != 'Finalize Downgrade' &&
                                 opp.StageName != 'Removed Client Connection')) {
                                     System.debug('*****1');
                                     System.debug('opp.Send_Email_1__c = ' + opp.Send_Email_1__c);
                                     System.debug('matchingOpportunity.Send_Email_1__c = ' + matchingOpportunity.Send_Email_1__c);
                                     if (opp.Sent_Email_1__c != true &&
                                         opp.Sent_Email_2__c != true &&
                                         opp.Sent_Email_3__c != true &&
                                         opp.Sent_Email_4__c != true &&
                                         opp.Sent_Email_5__c != true &&
                                         opp.Send_Email_1__c != matchingOpportunity.Send_Email_1__c &&
                                         opp.Send_Email_1__c != null) {
                                             System.debug('*****2');
                                             firstEmailList.add(opp);
                                         } else if (opp.Sent_Email_1__c == true &&
                                                    opp.Sent_Email_2__c != true &&
                                                    opp.Sent_Email_3__c != true &&
                                                    opp.Sent_Email_4__c != true &&
                                                    opp.Sent_Email_5__c != true &&
                                                    opp.Send_Email_2__c != matchingOpportunity.Send_Email_2__c &&
                                                    opp.Send_Email_2__c != null) {
                                                        secondEmailList.add(opp);
                                                    } else if (opp.Sent_Email_1__c == true &&
                                                               opp.Sent_Email_2__c == true &&
                                                               opp.Sent_Email_3__c != true &&
                                                               opp.Sent_Email_4__c != true &&
                                                               opp.Sent_Email_5__c != true &&
                                                               opp.Send_Email_3__c != matchingOpportunity.Send_Email_3__c &&
                                                               opp.Send_Email_3__c != null) {
                                                                   thirdEmailList.add(opp);
                                                               } else if (opp.Sent_Email_1__c == true &&
                                                                          opp.Sent_Email_2__c == true &&
                                                                          opp.Sent_Email_3__c == true &&
                                                                          opp.Sent_Email_4__c != true &&
                                                                          opp.Sent_Email_5__c != true &&
                                                                          opp.Send_Email_4__c != matchingOpportunity.Send_Email_4__c &&
                                                                          opp.Send_Email_4__c != null) {
                                                                              fourthEmailList.add(opp);
                                                                          } else if (opp.Sent_Email_1__c == true &&
                                                                                     opp.Sent_Email_2__c == true &&
                                                                                     opp.Sent_Email_3__c == true &&
                                                                                     opp.Sent_Email_4__c == true &&
                                                                                     opp.Sent_Email_5__c != true &&
                                                                                     opp.Send_Email_5__c != matchingOpportunity.Send_Email_5__c &&
                                                                                     opp.Send_Email_5__c != null) {
                                                                                         fifthEmailList.add(opp);
                                                                                     }
                                 }
                        }
                        System.debug('firstEmailList  = ' + firstEmailList);
                        System.debug('secondEmailList = ' + secondEmailList);
                        System.debug('thirdEmailList  = ' + thirdEmailList);
                        System.debug('fourthEmailList = ' + fourthEmailList);
                        System.debug('fifthEmailList  = ' + fifthEmailList);
                        
                        //SOQL query to return additional necessary fields
                        List<Opportunity> emailListData = [
                            SELECT Id,
                            Name,
                            Owner.Email,
                            AccountId,
                            Primary_Contact__c,
                            Emails_Sent__c,
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
                            Account.BillingCountry,
                            Account.BillingState
                            FROM Opportunity
                            WHERE Id = :firstEmailList
                            OR Id = :secondEmailList
                            OR Id = :thirdEmailList
                            OR Id = :fourthEmailList
                            OR Id = :fifthEmailList
                        ];
                        
                        //Instantiate new lists to populate with additional fields
                        List<Opportunity> enrichedFirst  = new List<Opportunity>();
                        List<Opportunity> enrichedSecond = new List<Opportunity>();
                        List<Opportunity> enrichedThird  = new List<Opportunity>();
                        List<Opportunity> enrichedFourth = new List<Opportunity>();
                        List<Opportunity> enrichedFifth  = new List<Opportunity>();
                        
                        //Loop through all opportunities ready for email and match with additional fields from previous SOQL query
                        for (Opportunity opty : emailListData) {
                            for (Opportunity listedOpty : firstEmailList) {
                                if (opty.Id == listedOpty.Id) {
                                    enrichedFirst.add(opty);
                                }
                            }
                            for (Opportunity listedOpty : secondEmailList) {
                                if (opty.Id == listedOpty.Id) {
                                    enrichedSecond.add(opty);
                                }
                            }
                            for (Opportunity listedOpty : thirdEmailList) {
                                if (opty.Id == listedOpty.Id) {
                                    enrichedThird.add(opty);
                                }
                            }
                            for (Opportunity listedOpty : fourthEmailList) {
                                if (opty.Id == listedOpty.Id) {
                                    enrichedFourth.add(opty);
                                }
                            }
                            for (Opportunity listedOpty : fifthEmailList) {
                                if (opty.Id == listedOpty.Id) {
                                    enrichedFifth.add(opty);
                                }
                            }
                        }
                        System.debug('emailListData = ' + emailListData);
                        
                        //Instantiates list of related AccountIds
                        List<Id> linkedAccountIds = new List<Id>();
                        for (Opportunity opty : emailListData) {
                            linkedAccountIds.add(opty.AccountId);
                        }
                        
                        List<Opportunity> oppStatusUpdate = new List<Opportunity>();
                        List<Messaging.SingleEmailMessage> mailList = new List< Messaging.SingleEmailMessage >();
                        Integer randomNumber = getRandomNumber(userList.size());
                        List<String> userListIds = new List<String>();
                        List<String> userListEmails = new List<String>();
                        
                        for (User collectionUser : userList) {
                            userListIds.add(String.valueOf(collectionUser.Id));
                            userListEmails.add(collectionUser.Email);
                        }
                        
                        //SOQL query to populate list of all associated CC email addresses
                        List<Contact> ccContactList = [
                            SELECT Email, Organizer_isActive__c, Primary_PICS_Organizer_User__c, AccountId
                            FROM Contact
                            WHERE AccountId = :accountIds
                            AND Email != NULL
                            AND Organizer_isActive__c = 'Yes'
                            AND IsEmailBounced = FALSE
                        ];
                        System.debug('ccContactList = ' + ccContactList);
                        
                        List<String> orgWideEmailIds = new List<String>();
                        for (OrgWideEmailAddress orgEmail : orgWideEmails) {
                            orgWideEmailIds.add(String.valueOf(orgEmail.Id));
                        }
                        
                        //Instantiates email template objects
                        EmailTemplate firstTemplate;
                        EmailTemplate secondTemplate;
                        EmailTemplate thirdTemplate;
                        EmailTemplate fourthTemplate;
                        EmailTemplate fifthTemplate;
                        EmailTemplate firstTemplateUS;
                        EmailTemplate secondTemplateUS;
                        EmailTemplate thirdTemplateUS;
                        EmailTemplate fourthTemplateUS;
                        EmailTemplate firstTemplateIndia;
                        EmailTemplate secondTemplateIndia;
                        EmailTemplate thirdTemplateIndia;
                        EmailTemplate fourthTemplateIndia;
                        EmailTemplate firstTemplateHindi;
                        EmailTemplate secondTemplateHindi;
                        EmailTemplate thirdTemplateHindi;
                        EmailTemplate fourthTemplateHindi;
                        EmailTemplate firstTemplateRenewal;
                        EmailTemplate secondTemplateRenewal;
                        EmailTemplate thirdTemplateRenewal;
                        EmailTemplate fourthTemplateRenewal;
                        EmailTemplate fifthTemplateRenewal;
                        
                        //Populates email template objects from previous SOQL query results
                        
                        boolean collections = false;
                        
                        for(Opportunity opty : newTrigger) {
                        	if(opty.Type.equals('Collection Renewal'))
                            {
                                collections = true;
                                System.debug('Collection');
                            }
                        }
                        
                        if(collections == true) {
                            for(EmailTemplate template: templateList) {
                            if (template.DeveloperName == 'Collections_System_Email_1_Renewal') {
                                firstTemplateRenewal = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_2_Renewal') {
                                secondTemplateRenewal = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_3_Renewal') {
                                thirdTemplateRenewal = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_4_Renewal') {
                                fourthTemplateRenewal = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_5_Renewal') {
                                fifthTemplateRenewal = template;
                            }
                        }                     
                     }
                     
                        else {
                        
                        for (EmailTemplate template : templateList) {
                            if (template.DeveloperName == 'Collections_System_Email_1') {
                                firstTemplate = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_2') {
                                secondTemplate = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_3') {
                                thirdTemplate = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_4') {
                                fourthTemplate = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_5') {
                                fifthTemplate = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_1_US') {
                                firstTemplateUS = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_2_US') {
                                secondTemplateUS = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_3_US') {
                                thirdTemplateUS = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_4_US') {
                                fourthTemplateUS = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_1_India') {
                                firstTemplateIndia = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_2_India') {
                                secondTemplateIndia = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_3_India') {
                                thirdTemplateIndia = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_4_India') {
                                fourthTemplateIndia = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_1_Hindi') {
                                firstTemplateHindi = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_2_Hindi') {
                                secondTemplateHindi = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_3_Hindi') {
                                thirdTemplateHindi = template;
                            } else if (template.DeveloperName == 'Collections_System_Email_4_Hindi') {
                                fourthTemplateHindi = template;
                            } 
                         }
                      }
                        
                        System.debug('EMAIL TEMPLATE: ' + templateList);
                        
                        //SOQL query account to determine is supplier is also a client
                        List<Account> linkedAccounts = [
                            SELECT Id, Supplier_is_also_a_client__c, HasOptedOutOfEmail__c
                            FROM Account
                            WHERE Id IN: accountIds
                        ];
                        
                        //Iterate through opportunities and org-wide emails to find ID of the org-wide email address
                        //corresponding to the opportunity owner's email address
                        for (Opportunity opty : emailListData) {
                            Id fromId = '00570000004tHnB';
                            
                            
                            Boolean supplierIsClient;
                            Boolean emailOptOut;
                            for (Account linkedAcct : linkedAccounts) {
                                if(linkedAcct.Id == opty.AccountId) {
                                    supplierIsClient = linkedAcct.Supplier_is_also_a_client__c;
                                    emailOptOut = linkedAcct.HasOptedOutOfEmail__c;
                                }
                            }
                            
                            if (!userListIds.contains(String.valueOf(opty.OwnerId))) {
                                System.debug('3****');
                                opty.OwnerId = userListIds[randomNumber];
                                opty.Owner.Email = userListEmails[randomNumber];
                            }
                            
                            System.debug('opty.Owner.Email = ' + opty.Owner.Email);
                            for (OrgWideEmailAddress orgWideEmail : orgWideEmails) {
                                System.debug('orgWideEmail = ' + orgWideEmail);
                                if (orgWideEmail.Address == opty.Owner.Email) {
                                    System.debug('1****');
                                    fromId = orgWideEmail.Id;
                                }
                            }
                            if (fromId == '00570000004tHnB' && orgWideEmails.size() > 0) {
                                System.debug('2****');
                                fromId = orgWideEmails[0].Id;
                            }
                            
                            //Find opportunity's associated CC email addresses
                            List<Contact> optyCCContacts = new List<Contact>();
                            for (Contact ccContact : ccContactList) {
                                if (ccContact.AccountId == opty.AccountId) {
                                    if (ccContact.Email != null) {
                                        optyCCContacts.add(ccContact);
                                    }
                                }
                            }
                            
                            System.debug('optyCCContacts = ' + optyCCContacts);
                            System.debug('opty = ' + opty);
                            System.debug('fromId = ' + fromId);
                            System.debug('orgWideEmailIds = ' + orgWideEmailIds);
                            System.debug('userListIds = ' + userListIds);
                            System.debug('orgWideEmailIds.Contains(String.valueOf(fromId)) = ' + orgWideEmailIds.contains(String.valueOf(fromId)));
                            System.debug('firstTemplateIndia = ' + firstTemplateIndia);
                            System.debug('opty.Account.BillingCountry = ' + opty.Account.BillingCountry);
                            System.debug('thirdTemplateRenewal: ' + thirdTemplateRenewal);
                            System.debug('thirdTemplate: ' + thirdTemplate);
                            
                            //Change proper 'Sent Email' box to true, send proper email template, and increment 'Emails Sent' amount depending on which conditions are met.
                            //Revision 5.25.18 - added functionality to check BillingCountry. If US, then send template focused on ACH promotion. If Canada, Australia, or UK, then send
                            //template focused on Credit Card promotion.
                            //Revision 6.12.18 - added check to ensure Owner was a Collection rep to prevent unassigned emails sending from Eric Olsen or Andy Estep
                            if (opty.Sent_Email_1__c != true &&
                                opty.Sent_Email_2__c != true &&
                                opty.Sent_Email_3__c != true &&
                                opty.Sent_Email_4__c != true &&
                                opty.Sent_Email_5__c != true &&
                                !optyCCContacts.isEmpty() &&
                                orgWideEmailIds.contains(String.valueOf(fromId)) == true) {
                                    System.debug('Formatting first email with ' + opty + firstTemplate + optyCCContacts + fromId);
                                    if (opty.Account.BillingCountry == 'United States' ||
                                        opty.Account.BillingCountry == 'US' ||
                                        opty.Account.BillingCountry == 'Canada' ||
                                        opty.Account.BillingCountry == 'CA' ||
                                        opty.Account.BillingCountry == 'Australia' ||
                                        opty.Account.BillingCountry == 'AU' ||
                                        opty.Account.BillingCountry == 'United Kingdom' ||
                                        opty.Account.BillingCountry == 'UK' ||
                                        opty.Account.BillingCountry == 'Great Britain' ||
                                        opty.Account.BillingCountry == 'GB' ||
                                        opty.Account.BillingCountry == 'India' ||
                                        opty.Account.BillingCountry == 'IN') {
                                            if (opty.Account.BillingCountry == 'United States' || opty.Account.BillingCountry == 'US') {
                                                //Add email template to list to be used in a bulk send
                                                System.debug('Mail to US = ' + opty + ' ' + firstTemplateUS + ' ' + optyCCContacts + ' ' + fromId);
                                                
                                                //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                if(supplierIsClient == false && emailOptOut == false) {
                                                    mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplateUS, optyCCContacts, fromId, false));
                                                } else {
                                                    mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplateUS, optyCCContacts, fromId, true));
                                                }
                                                
                                                opty.Sent_Email_1__c = true;
                                                opty.Emails_Sent__c++;
                                                if (opty != null) {
                                                    oppStatusUpdate.add(opty);
                                                }
                                            } else if (((opty.Account.BillingCountry == 'Canada' ||
                                                         opty.Account.BillingCountry == 'CA') &&
                                                        opty.Account.BillingState != 'Quebec') ||
                                                       opty.Account.BillingCountry == 'Australia' ||
                                                       opty.Account.BillingCountry == 'AU' ||
                                                       opty.Account.BillingCountry == 'United Kingdom' ||
                                                       opty.Account.BillingCountry == 'UK' ||
                                                       opty.Account.BillingCountry == 'Great Britain' ||
                                                       opty.Account.BillingCountry == 'GB') {
                                                           
                                                           //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                           if(supplierIsClient == false && emailOptOut == false) {
                                                               mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplate, optyCCContacts, fromId, false));
                                                           } else {
                                                               mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplate, optyCCContacts, fromId, true));
                                                           }
                                                           
                                                           opty.Sent_Email_1__c = true;
                                                           opty.Emails_Sent__c++;
                                                           if (opty != null) {
                                                               oppStatusUpdate.add(opty);
                                                           }
                                                       } else if (opty.Account.BillingCountry == 'India' || opty.Account.BillingCountry == 'IN' && getCollection_Follow_up_India_AutomationSwitchStatus() == true) {
                                                           
                                                           //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                           if(supplierIsClient == false && emailOptOut == false) {
                                                               mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplateIndia, optyCCContacts, fromId, false));
                                                           } else {
                                                               mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplateIndia, optyCCContacts, fromId, true));
                                                           }
                                                           
                                                           //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                           if(supplierIsClient == false && emailOptOut == false) {
                                                               mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplateHindi, optyCCContacts, fromId, false));
                                                           } else {
                                                               mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplateHindi, optyCCContacts, fromId, true));
                                                           }
                                                           
                                                           opty.Sent_Email_1__c = true;
                                                           opty.Emails_Sent__c++;
                                                           opty.Emails_Sent__c++;
                                                           if (opty != null) {
                                                               oppStatusUpdate.add(opty);
                                                           }
                                                       }
                                        }
                                } else if (opty.Sent_Email_1__c == true &&
                                           opty.Sent_Email_2__c != true &&
                                           opty.Sent_Email_3__c != true &&
                                           opty.Sent_Email_4__c != true &&
                                           opty.Sent_Email_5__c != true &&
                                           !optyCCContacts.isEmpty() &&
                                           orgWideEmailIds.contains(String.valueOf(fromId)) == true) {
                                               System.debug('Formatting second email with ' + opty + secondTemplate + optyCCContacts + fromId);
                                               if (opty.Account.BillingCountry == 'United States' ||
                                                   opty.Account.BillingCountry == 'US' ||
                                                   opty.Account.BillingCountry == 'Canada' ||
                                                   opty.Account.BillingCountry == 'CA' ||
                                                   opty.Account.BillingCountry == 'Australia' ||
                                                   opty.Account.BillingCountry == 'AU' ||
                                                   opty.Account.BillingCountry == 'United Kingdom' ||
                                                   opty.Account.BillingCountry == 'UK' ||
                                                   opty.Account.BillingCountry == 'Great Britain' ||
                                                   opty.Account.BillingCountry == 'GB' ||
                                                   opty.Account.BillingCountry == 'India' ||
                                                   opty.Account.BillingCountry == 'IN') {
                                                       if (opty.Account.BillingCountry == 'United States' || opty.Account.BillingCountry == 'US') {
                                                           //Add email template to list to be used in a bulk send
                                                           System.debug('Mail to US = ' + opty + ' ' + secondTemplateUS + ' ' + optyCCContacts + ' ' + fromId);
                                                           
                                                           //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                           if(supplierIsClient == false && emailOptOut == false) {
                                                               mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplateUS, optyCCContacts, fromId, false));
                                                           } else {
                                                               mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplateUS, optyCCContacts, fromId, true));
                                                           }
                                                           
                                                           opty.Sent_Email_2__c = true;
                                                           opty.Emails_Sent__c++;
                                                           if (opty != null) {
                                                               oppStatusUpdate.add(opty);
                                                           }
                                                       } else if (((opty.Account.BillingCountry == 'Canada' ||
                                                                    opty.Account.BillingCountry == 'CA') &&
                                                                   opty.Account.BillingState != 'Quebec') ||
                                                                  opty.Account.BillingCountry == 'Australia' ||
                                                                  opty.Account.BillingCountry == 'AU' ||
                                                                  opty.Account.BillingCountry == 'United Kingdom' ||
                                                                  opty.Account.BillingCountry == 'UK' ||
                                                                  opty.Account.BillingCountry == 'Great Britain' ||
                                                                  opty.Account.BillingCountry == 'GB'
                                                                 ) {
                                                                     
                                                                     //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                     if(supplierIsClient == false && emailOptOut == false) {
                                                                         mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplate, optyCCContacts, fromId, false));
                                                                     } else {
                                                                         mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplate, optyCCContacts, fromId, true));
                                                                     }
                                                                     
                                                                     opty.Sent_Email_2__c = true;
                                                                     opty.Emails_Sent__c++;
                                                                     if (opty != null) {
                                                                         oppStatusUpdate.add(opty);
                                                                     }
                                                                 } else if (opty.Account.BillingCountry == 'India' || opty.Account.BillingCountry == 'IN' && getCollection_Follow_up_India_AutomationSwitchStatus() == true) {
                                                                     
                                                                     
                                                                     //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                     if(supplierIsClient == false && emailOptOut == false) {
                                                                         mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplateIndia, optyCCContacts, fromId, false));
                                                                     } else {
                                                                         mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplateIndia, optyCCContacts, fromId, true));
                                                                     }
                                                                     
                                                                     //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                     if(supplierIsClient == false && emailOptOut == false) {
                                                                         mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplateHindi, optyCCContacts, fromId, false));
                                                                     } else {
                                                                         mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplateHindi, optyCCContacts, fromId, true));
                                                                     }
                                                                     
                                                                     opty.Sent_Email_2__c = true;
                                                                     opty.Emails_Sent__c++;
                                                                     opty.Emails_Sent__c++;
                                                                     if (opty != null) {
                                                                         oppStatusUpdate.add(opty);
                                                                     }
                                                                 }
                                                   }
                                           } else if (opty.Sent_Email_1__c == true &&
                                                      opty.Sent_Email_2__c == true &&
                                                      opty.Sent_Email_3__c != true &&
                                                      opty.Sent_Email_4__c != true &&
                                                      opty.Sent_Email_5__c != true &&
                                                      !optyCCContacts.isEmpty() &&
                                                      orgWideEmailIds.contains(String.valueOf(fromId)) == true) {
                                                          System.debug('Formatting third email with ' + opty + thirdTemplate + optyCCContacts + fromId);
                                                          if (opty.Account.BillingCountry == 'United States' ||
                                                              opty.Account.BillingCountry == 'US' ||
                                                              opty.Account.BillingCountry == 'Canada' ||
                                                              opty.Account.BillingCountry == 'CA' ||
                                                              opty.Account.BillingCountry == 'Australia' ||
                                                              opty.Account.BillingCountry == 'AU' ||
                                                              opty.Account.BillingCountry == 'United Kingdom' ||
                                                              opty.Account.BillingCountry == 'UK' ||
                                                              opty.Account.BillingCountry == 'Great Britain' ||
                                                              opty.Account.BillingCountry == 'GB' ||
                                                              opty.Account.BillingCountry == 'India' ||
                                                              opty.Account.BillingCountry == 'IN') {
                                                                  if (opty.Account.BillingCountry == 'United States' || opty.Account.BillingCountry == 'US') {
                                                                      //Add email template to list to be used in a bulk send
                                                                      opty.Sent_Email_3__c = true;
                                                                      opty.Emails_Sent__c++;
                                                                      if (opty != null) {
                                                                          oppStatusUpdate.add(opty);
                                                                          
                                                                          //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                          if(supplierIsClient == false && emailOptOut == false) {
                                                                              mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplateUS, optyCCContacts, fromId, false));
                                                                          } else {
                                                                              mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplateUS, optyCCContacts, fromId, true));
                                                                          }
                                                                          
                                                                          System.debug('%%%%1');
                                                                      }
                                                                  } else if (((opty.Account.BillingCountry == 'Canada' ||
                                                                               opty.Account.BillingCountry == 'CA') &&
                                                                              opty.Account.BillingState != 'Quebec') ||
                                                                             opty.Account.BillingCountry == 'Australia' ||
                                                                             opty.Account.BillingCountry == 'AU' ||
                                                                             opty.Account.BillingCountry == 'United Kingdom' ||
                                                                             opty.Account.BillingCountry == 'UK' ||
                                                                             opty.Account.BillingCountry == 'Great Britain' ||
                                                                             opty.Account.BillingCountry == 'GB') {
                                                                                 
                                                                                 //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                                 if(supplierIsClient == false && emailOptOut == false) {
                                                                                     mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplate, optyCCContacts, fromId, false));
                                                                                 } else {
                                                                                     mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplate, optyCCContacts, fromId, true));
                                                                                 }
                                                                                 
                                                                                 opty.Sent_Email_3__c = true;
                                                                                 opty.Emails_Sent__c++;
                                                                                 if (opty != null) {
                                                                                     oppStatusUpdate.add(opty);
                                                                                     System.debug('%%%%2');
                                                                                 }
                                                                             } else if (opty.Account.BillingCountry == 'India' || opty.Account.BillingCountry == 'IN' && getCollection_Follow_up_India_AutomationSwitchStatus() == true) {
                                                                                 
                                                                                 //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                                 if(supplierIsClient == false && emailOptOut == false) {
                                                                                     mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplateIndia, optyCCContacts, fromId, false));
                                                                                 } else {
                                                                                     mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplateIndia, optyCCContacts, fromId, true));
                                                                                 }
                                                                                 
                                                                                 //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                                 if(supplierIsClient == false && emailOptOut == false) {
                                                                                     mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplateHindi, optyCCContacts, fromId, false));
                                                                                 } else {
                                                                                     mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplateHindi, optyCCContacts, fromId, true));
                                                                                 }
                                                                                 
                                                                                 opty.Sent_Email_3__c = true;
                                                                                 opty.Emails_Sent__c++;
                                                                                 opty.Emails_Sent__c++;
                                                                                 if (opty != null) {
                                                                                     oppStatusUpdate.add(opty);
                                                                                     System.debug('%%%%3');
                                                                                 }
                                                                             }
                                                              }
                                                      } else if (opty.Sent_Email_1__c == true &&
                                                                 opty.Sent_Email_2__c == true &&
                                                                 opty.Sent_Email_3__c == true &&
                                                                 opty.Sent_Email_4__c != true &&
                                                                 opty.Sent_Email_5__c != true &&
                                                                 !optyCCContacts.isEmpty() &&
                                                                 orgWideEmailIds.contains(String.valueOf(fromId)) == true) {
                                                                     System.debug('Formatting fourth email with ' + opty + fourthTemplate + optyCCContacts + fromId);
                                                                     if (opty.Account.BillingCountry == 'United States' ||
                                                                         opty.Account.BillingCountry == 'US' ||
                                                                         opty.Account.BillingCountry == 'Canada' ||
                                                                         opty.Account.BillingCountry == 'CA' ||
                                                                         opty.Account.BillingCountry == 'Australia' ||
                                                                         opty.Account.BillingCountry == 'AU' ||
                                                                         opty.Account.BillingCountry == 'United Kingdom' ||
                                                                         opty.Account.BillingCountry == 'UK' ||
                                                                         opty.Account.BillingCountry == 'Great Britain' ||
                                                                         opty.Account.BillingCountry == 'GB' ||
                                                                         opty.Account.BillingCountry == 'India' ||
                                                                         opty.Account.BillingCountry == 'IN') {
                                                                             if (opty.Account.BillingCountry == 'United States' || opty.Account.BillingCountry == 'US') {
                                                                                 //Add email template to list to be used in a bulk send
                                                                                 
                                                                                 //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                                 if(supplierIsClient == false && emailOptOut == false) {
                                                                                     mailList.add(emailHelper.sendCollectionEmail(opty, fourthTemplateUS, optyCCContacts, fromId, false));
                                                                                 } else {
                                                                                     mailList.add(emailHelper.sendCollectionEmail(opty, fourthTemplateUS, optyCCContacts, fromId, true));
                                                                                 }
                                                                                 
                                                                                 opty.Sent_Email_4__c = true;
                                                                                 opty.Emails_Sent__c++;
                                                                                 if (opty != null) {
                                                                                     oppStatusUpdate.add(opty);
                                                                                 }
                                                                             } else if (((opty.Account.BillingCountry == 'Canada' ||
                                                                                          opty.Account.BillingCountry == 'CA') &&
                                                                                         opty.Account.BillingState != 'Quebec') ||
                                                                                        opty.Account.BillingCountry == 'Australia' ||
                                                                                        opty.Account.BillingCountry == 'AU' ||
                                                                                        opty.Account.BillingCountry == 'United Kingdom' ||
                                                                                        opty.Account.BillingCountry == 'UK' ||
                                                                                        opty.Account.BillingCountry == 'Great Britain' ||
                                                                                        opty.Account.BillingCountry == 'GB') {
                                                                                            
                                                                                            //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                                            if(supplierIsClient == false && emailOptOut == false) {
                                                                                                mailList.add(emailHelper.sendCollectionEmail(opty, fourthTemplate, optyCCContacts, fromId, false));
                                                                                            } else {
                                                                                                mailList.add(emailHelper.sendCollectionEmail(opty, fourthTemplate, optyCCContacts, fromId, true));
                                                                                            }
                                                                                            
                                                                                            opty.Sent_Email_4__c = true;
                                                                                            opty.Emails_Sent__c++;
                                                                                            if (opty != null) {
                                                                                                oppStatusUpdate.add(opty);
                                                                                            }
                                                                                        } else if (opty.Account.BillingCountry == 'India' || opty.Account.BillingCountry == 'IN' && getCollection_Follow_up_India_AutomationSwitchStatus() == true) {
                                                                                            
                                                                                            //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                                            //Added logic to prevent errors if there is no email on opty
                                                                                            
                                                                                            if(supplierIsClient == false && emailOptOut == false) {
                                                                                                mailList.add(emailHelper.sendCollectionEmail(opty, fourthTemplateIndia, optyCCContacts, fromId, false));
                                                                                            } else {
                                                                                                mailList.add(emailHelper.sendCollectionEmail(opty, fourthTemplateIndia, optyCCContacts, fromId, true));
                                                                                            }
                                                                                            opty.Sent_Email_4__c = true;
                                                                                            opty.Emails_Sent__c++;
                                                                                            opty.Emails_Sent__c++;
                                                                                            if (opty != null) {
                                                                                                oppStatusUpdate.add(opty);
                                                                                            }
                                                                                        }
                                                                         }
                                                                 } else if (opty.Sent_Email_1__c == true &&
                                                                            opty.Sent_Email_2__c == true &&
                                                                            opty.Sent_Email_3__c == true &&
                                                                            opty.Sent_Email_4__c == true &&
                                                                            opty.Sent_Email_5__c != true &&
                                                                            !optyCCContacts.isEmpty() &&
                                                                            orgWideEmailIds.contains(String.valueOf(fromId)) == true) {
                                                                                System.debug('Formatting fifth email with ' + opty + fifthTemplate + optyCCContacts + fromId);
                                                                                if (opty.Account.BillingCountry == 'United States' ||
                                                                                    opty.Account.BillingCountry == 'US' ||
                                                                                    opty.Account.BillingCountry == 'Canada' ||
                                                                                    opty.Account.BillingCountry == 'CA' ||
                                                                                    opty.Account.BillingCountry == 'Australia' ||
                                                                                    opty.Account.BillingCountry == 'AU' ||
                                                                                    opty.Account.BillingCountry == 'United Kingdom' ||
                                                                                    opty.Account.BillingCountry == 'UK' ||
                                                                                    opty.Account.BillingCountry == 'Great Britain' ||
                                                                                    opty.Account.BillingCountry == 'GB' ||
                                                                                    opty.Account.BillingCountry == 'India' ||
                                                                                    opty.Account.BillingCountry == 'IN') {
                                                                                        if (opty.Account.BillingCountry == 'United States' || opty.Account.BillingCountry == 'US') {
                                                                                            //Add email template to list to be used in a bulk send
                                                                                            //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                                            if(supplierIsClient == false && emailOptOut == false) {
                                                                                                mailList.add(emailHelper.sendCollectionEmail(opty, fifthTemplate, optyCCContacts, fromId, false));
                                                                                            } else {
                                                                                                mailList.add(emailHelper.sendCollectionEmail(opty, fifthTemplate, optyCCContacts, fromId, true));
                                                                                            }
                                                                                            
                                                                                            opty.Sent_Email_5__c = true;
                                                                                            opty.Emails_Sent__c++;
                                                                                            if (opty != null) {
                                                                                                oppStatusUpdate.add(opty);
                                                                                            }
                                                                                        } else if (((opty.Account.BillingCountry == 'Canada' ||
                                                                                                     opty.Account.BillingCountry == 'CA') &&
                                                                                                    opty.Account.BillingState != 'Quebec') ||
                                                                                                   opty.Account.BillingCountry == 'Australia' ||
                                                                                                   opty.Account.BillingCountry == 'AU' ||
                                                                                                   opty.Account.BillingCountry == 'United Kingdom' ||
                                                                                                   opty.Account.BillingCountry == 'UK' ||
                                                                                                   opty.Account.BillingCountry == 'Great Britain' ||
                                                                                                   opty.Account.BillingCountry == 'GB') {
                                                                                                       
                                                                                                       //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                                                       if(supplierIsClient == false && emailOptOut == false) {
                                                                                                           mailList.add(emailHelper.sendCollectionEmail(opty, fifthTemplate, optyCCContacts, fromId, false));
                                                                                                       } else {
                                                                                                           mailList.add(emailHelper.sendCollectionEmail(opty, fifthTemplate, optyCCContacts, fromId, true));
                                                                                                       }
                                                                                                       
                                                                                                       opty.Sent_Email_5__c = true;
                                                                                                       opty.Emails_Sent__c++;
                                                                                                       if (opty != null) {
                                                                                                           oppStatusUpdate.add(opty);
                                                                                                       }
                                                                                                   } else if (opty.Account.BillingCountry == 'India' || opty.Account.BillingCountry == 'IN' && getCollection_Follow_up_India_AutomationSwitchStatus() == true) {
                                                                                                       
                                                                                                       //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                                                                                       //Added logic to prevent errors if there is no email on opty
                                                                                                       
                                                                                                       if(supplierIsClient == false && emailOptOut == false) {
                                                                                                           mailList.add(emailHelper.sendCollectionEmail(opty, fifthTemplate, optyCCContacts, fromId, false));
                                                                                                       } else {
                                                                                                           mailList.add(emailHelper.sendCollectionEmail(opty, fifthTemplate, optyCCContacts, fromId, true));
                                                                                                       }
                                                                                                       opty.Sent_Email_5__c = true;
                                                                                                       opty.Emails_Sent__c++;
                                                                                                       opty.Emails_Sent__c++;
                                                                                                       if (opty != null) {
                                                                                                           oppStatusUpdate.add(opty);
                                                                                                       }
                                                                                                   }
                                                                                    }
                                                                            }
                        }
                        
                        //Calls recursion prevention methods
                        addRunCount();
                        updateEmailCallCount.setFirstRunFalse();
                        //Supplier_Collect_Opty_RoundRobin.setFirstRunFalse();
                        
                        //Bulk update all opportunities with new attributes
                        update oppStatusUpdate;
                        
                        //Bulk send all email templates
                        if(!mailList.isEmpty()){
                            Messaging.sendEmail(mailList);
                        }
                        
                        System.debug('FU mailList = ' + mailList);
                        System.debug('emailListData = ' + emailListData);
                    }
                }
            }
    }
}