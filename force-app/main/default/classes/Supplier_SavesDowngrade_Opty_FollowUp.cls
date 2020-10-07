/**
* Created by parker brown on 10/12/2018. This class sends 4 emails to account contacts in a Saves Downgrade opty. The emails are triggered by the Supplier_All_SendEmail Batch apex daily jobs
* The opty owners are 'round robined' by the 'SavesDowngrade_RoundRobin' apex trigger. The number of emails are counted and kept track of in the 
* Sends email to the big 4 (UK, CA, US, AU) -> does not send email to India
* Update: This class now sends email to all countries (excluding those with the state of 'Quebec')
*
* Update: 8.7.2019 - Changed the user role of 'Retention' to 'Saves (Downgrade)' SF Ticket:
*/

public with sharing class Supplier_SavesDowngrade_Opty_FollowUp {
    private static Boolean firstRun = true;
    
    //--Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }
    
    //--Method to set recursion variable to false
    public static void setFirstRunFalse() {
        firstRun = false;
        System.debug('setFirstRunFalse run');
    }
    
    //--Method to return a random Integer between 0 and passed through integer
    public static Integer getRandomNumber( Integer size ) {
        Double d = Math.random() * size;
        return d.intValue();
    }
    
    public void Supplier_SavesDowngrade_Opty_FollowUp_Handler( List<Opportunity> newTrigger, List<Opportunity> oldTrigger ) {
        
        //--Instantiate handler
        Supplier_SavesDowngrade_Opty_FollowUp handler = new Supplier_SavesDowngrade_Opty_FollowUp();
        List<Opportunity> savesDowngradeOpty = new List<Opportunity>();
        
        //--Check all opportunities in trigger to ensure at least one of Record Type 'Saves Downgrade' exists
        for (Opportunity opty : newTrigger) {
            Integer iCount = 0;
            if (opty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId()
                && (opty.Send_Email_1__c != oldTrigger[iCount].Send_Email_1__c 
               	  || opty.Send_Email_2__c != oldTrigger[iCount].Send_Email_2__c
                  || opty.Send_Email_3__c != oldTrigger[iCount].Send_Email_3__c
                  || opty.Send_Email_4__c != oldTrigger[iCount].Send_Email_4__c)) {
                savesDowngradeOpty.add(opty);
            }
        }
        
        //--Prevents recursion and ensures at least one of opportunities in trigger is of Record Type 'Saves Downgrade' to ensure trigger and class are necessary
        if (Supplier_SavesDowngrade_Opty_FollowUp.isFirstRun() == true &&
            newTrigger != null &&
            savesDowngradeOpty.size() > 0) {
                
                List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        		String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
                
                if (profileName != 'Bizable User') {
                
                List<Opportunity> firstEmailList = new List<Opportunity>();
                List<Opportunity> secondEmailList = new List<Opportunity>();
                List<Opportunity> thirdEmailList = new List<Opportunity>();
                List<Opportunity> fourthEmailList = new List<Opportunity>();
                
                //++SOQL query to retrieve email template IDs
                List<EmailTemplate> templateList = [
                    SELECT Id, DeveloperName
                    FROM EmailTemplate
                    WHERE DeveloperName = 'Saves_Downgrade_System_Email_1'
                    OR DeveloperName = 'Saves_Downgrade_System_Email_2'
                    OR DeveloperName = 'Saves_Downgrade_System_Email_3'
                    OR DeveloperName = 'Saves_Downgrade_System_Email_4'
                ];
                System.debug('template ID = ' + templateList);
                
                //--SOQL query all users with role 'Retention'
                List<User> userList = [
                    SELECT Id, Name, Email
                    FROM User
                    WHERE UserRole.Name = 'Saves (Downgrade)'
                    AND IsActive = TRUE
                ];
                System.debug('userList =' + userList);
                
                //--SOQL query automation switch
                Automation_Switch__mdt savesDowngradeFUSwitch = [
                    SELECT Id, Label, On_Off__c
                    FROM Automation_Switch__mdt
                    WHERE Label = 'Saves Downgrade: Follow-up'
                ];
                System.debug('savesDowngradeFUSwitch = ' + savesDowngradeFUSwitch);
                
                //--List all AccountIds linked to opportunities in trigger
                List<Id> accountIds = new List<Id>();
                for (Opportunity opty : newTrigger) {
                    accountIds.add(opty.AccountId);
                }
                
                //--SOQL query all existing opportunities linked to AccountIds
                List<Opportunity> linkedOptyList = [
                    SELECT Id, Name, StageName, AccountId, RecordTypeId, Account.Status__c
                    FROM Opportunity
                    WHERE AccountId = :accountIds
                ];
                System.debug('linkedOptyList =' + linkedOptyList);
                
                //++Identifies which triggered opportunities should be exempt from Renewal Saves Emails due to another opportunity on its account 
                //with an outstanding deactivation request OR on a deactivated account
                List<String> exemptOpty = new List<String>();
                for(Opportunity opty: newTrigger){
                    for(Opportunity associatedOpty: linkedOptyList) {
                        if(associatedOpty.AccountId == opty.AccountId &&
                        (associatedOpty.Account.Status__c == 'Deactivated' ||
                        (associatedOpty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId() &&
                        (associatedOpty.StageName == 'Open' ||
                        associatedOpty.StageName == 'Attempted' ||
                        associatedOpty.StageName == 'In Progress' ||
                        associatedOpty.StageName == 'Ready for Deactivation' ||
                        associatedOpty.StageName == 'Ready for Deactivation - Refund' ||
                        associatedOpty.StageName == 'Deactivated')))) {
                        exemptOpty.add(String.valueOf(opty.AccountId));
                        System.debug('added exemption = ' + opty);
                        }
                    }
                }
                
                //--Populate list of email addresses that will be used in SOQL query below to determine the org-wide email ID associated with the user email address
                List<String> savesDowngradeEmails = new List<String>();
                for (User RetentionUser : userList) {
                    savesDowngradeEmails.add(RetentionUser.Email);
                }
                
                //--SOQL query all users with role 'Retention'
                List<OrgWideEmailAddress> orgWideEmails = [
                    SELECT Id, Address
                    FROM OrgWideEmailAddress
                    WHERE Address = :savesDowngradeEmails
                ];

                //SOQL query account to determine if supplier is also a client
               List<Account> linkedAccounts = [
                       SELECT Id, Supplier_is_also_a_client__c, HasOptedOutOfEmail__c
                       FROM Account
                       WHERE Id IN: accountIds ];
                
                //--If retention follow-up switch is turned on
                if (savesDowngradeFUSwitch.On_Off__c == true) {
                    //--Test all updated opportunities in trigger to verify appropriate conditions are met according to auto-email cadence. Adds all opportunities matching criteria to a list.
                    for (Opportunity opp : newTrigger) {
                        Opportunity matchingOpportunity;
                         
                        Boolean supplierIsClient;
                        Boolean emailOptOut;
                       for (Account linkedAcct : linkedAccounts) {
                           if(linkedAcct.Id == opp.AccountId) {
                               supplierIsClient = linkedAcct.Supplier_is_also_a_client__c;
                               emailOptOut = linkedAcct.HasOptedOutOfEmail__c;
                           }
                       }
                        
                        System.debug('oldTrigger = ' + oldTrigger);
                        for (Opportunity opty : oldTrigger) {
                            if (opty.Id == opp.Id) {
                                matchingOpportunity = opty;
                            }
                        }
                        
                        System.debug('Triggers = ' + newTrigger + '!!!!!!!!!!' + oldTrigger);
                        System.debug('opp.AccountId ' + opp.AccountId);
                        if (/*exemptOpty.contains(String.valueOf(opp.AccountId)) == false &&*/
                            opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId() &&
                            (opp.StageName != 'Commit' &&
                             opp.StageName != 'Retained' &&
                             opp.StageName != 'Removed Client Connection' &&
                             opp.StageName != 'Request Cancelled' &&
                             opp.StageName != 'Deactivated' &&
                             opp.StageName != 'Finalize Downgrade' &&
                           supplierIsClient == false &&
                            emailOptOut == false)) {
                                 System.debug('*****1');
                                 System.debug('opp.Send_Email_1__c = ' + opp.Send_Email_1__c);
                                 System.debug('matchingOpportunity.Send_Email_1__c = ' + matchingOpportunity.Send_Email_1__c);
                                 if (opp.Sent_Email_1__c != true &&
                                     opp.Sent_Email_2__c != true &&
                                     opp.Sent_Email_3__c != true &&
                                     opp.Sent_Email_4__c != true &&
                                     opp.Send_Email_1__c != matchingOpportunity.Send_Email_1__c &&
                                     opp.Send_Email_1__c != null) {
                                         System.debug('*****2');
                                         firstEmailList.add(opp);
                                     } else if (opp.Sent_Email_1__c == true &&
                                                opp.Sent_Email_2__c != true &&
                                                opp.Sent_Email_3__c != true &&
                                                opp.Sent_Email_4__c != true &&
                                                opp.Send_Email_2__c != matchingOpportunity.Send_Email_2__c &&
                                                opp.Send_Email_2__c != null) {
                                                    secondEmailList.add(opp);
                                                } else if (opp.Sent_Email_1__c == true &&
                                                           opp.Sent_Email_2__c == true &&
                                                           opp.Sent_Email_3__c != true &&
                                                           opp.Sent_Email_4__c != true &&
                                                           opp.Send_Email_3__c != matchingOpportunity.Send_Email_3__c &&
                                                           opp.Send_Email_3__c != null) {
                                                               thirdEmailList.add(opp);
                                                           } else if (opp.Sent_Email_1__c == true &&
                                                                      opp.Sent_Email_2__c == true &&
                                                                      opp.Sent_Email_3__c == true &&
                                                                      opp.Sent_Email_4__c != true &&
                                                                      opp.Send_Email_4__c != matchingOpportunity.Send_Email_4__c &&
                                                                      opp.Send_Email_4__c != null) {
                                                                          fourthEmailList.add(opp);
                                                                      }
                             }
                    }
                    System.debug('firstEmailList = ' + firstEmailList);
                    System.debug('secondEmailList = ' + secondEmailList);
                    System.debug('thirdEmailList = ' + thirdEmailList);
                    System.debug('fourthEmailList = ' + fourthEmailList);
                    
                    //--SOQL query to return additional necessary fields
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
                        Send_Email_1__c,
                        Send_Email_2__c,
                        Send_Email_3__c,
                        Send_Email_4__c,
                        Account.BillingCountry,
                        Account.BillingState,
                        Eligible_for_Deactivation__c
                        FROM Opportunity
                        WHERE Id = :firstEmailList
                        OR Id = :secondEmailList
                        OR Id = :thirdEmailList
                        OR Id = :fourthEmailList
                    ];
                    
                    //--Instantiate new lists to populate with additional fields
                    List<Opportunity> enrichedFirst = new List<Opportunity>();
                    List<Opportunity> enrichedSecond = new List<Opportunity>();
                    List<Opportunity> enrichedThird = new List<Opportunity>();
                    List<Opportunity> enrichedFourth = new List<Opportunity>();
                    
                    //--Loop through all opportunities ready for email and match with additional fields from previous SOQL query
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
                    }
                    System.debug('emailListData = ' + emailListData);
                    
                    //--Instantiates list of related AccountIds
                    List<Id> linkedAccountIds = new List<Id>();
                    for (Opportunity opty : emailListData) {
                        linkedAccountIds.add(opty.AccountId);
                    }
                    
                    //--Pass relevant data to Supplier_SavesDowngrade_Opty_FollowUp_Handler
                    if (emailListData.size() > 0 && Supplier_SavesDowngrade_Opty_FollowUp.isFirstRun() == true) {
                        
                        List<Opportunity> oppStatusUpdate = new List<Opportunity>();
                        List<Messaging.SingleEmailMessage> mailList = new List< Messaging.SingleEmailMessage >();
                        Integer randomNumber = getRandomNumber(userList.size());
                        List<String> userListIds = new List<String>();
                        List<String> userListEmails = new List<String>();
                        
                        for (User retentionUser : userList) {
                            userListIds.add(String.valueOf(retentionUser.Id));
                            userListEmails.add(retentionUser.Email);
                        }
                        
                        //--SOQL query to populate list of all associated CC email addresses
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
                        
                        //--Instantiates email template objects
                        EmailTemplate firstTemplate;
                        EmailTemplate secondTemplate;
                        EmailTemplate thirdTemplate;
                        EmailTemplate fourthTemplate;
                        
                        //--Populates email template objects from previous SOQL query results
                        for (EmailTemplate template : templateList) {
                            if (template.DeveloperName == 'Saves_Downgrade_System_Email_1') {
                                firstTemplate = template;
                            } else if (template.DeveloperName == 'Saves_Downgrade_System_Email_2') {
                                secondTemplate = template;
                            } else if (template.DeveloperName == 'Saves_Downgrade_System_Email_3') {
                                thirdTemplate = template;
                            } else if (template.DeveloperName == 'Saves_Downgrade_System_Email_4') {
                                fourthTemplate = template;
                            }
                        }
                        
                        //Iterate through opportunities and org-wide emails to find ID of the org-wide email address corresponding to the opportunity owner's email address
                        for (Opportunity opty : emailListData) {
                            Id fromId = '00570000004tHnB';
                            
                            //Code below was used to randomize the opty owner. This is no longer needed due to the 'Saves Downgrades round robin' trigger created
                            /*if(!userListIds.contains(String.valueOf(opty.OwnerId))) {
                                System.debug('3****');
                                opty.OwnerId = userListIds[randomNumber];
                                opty.Owner.Email = userListEmails[randomNumber];
                                }*/
                            
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
                            
                            //--Find opportunity's associated CC email addresses
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
                            System.debug('opty.Account.BillingCountry = ' + opty.Account.BillingCountry);
                            //Change proper 'Sent Email' box to true, send proper email template, and increment 'Emails Sent' amount depending on which conditions are met.
                            //Revision 5.25.18 - added functionality to check BillingCountry. If US, then send template focused on ACH promotion. If Canada, Australia, or UK, then send
                            //template focused on Credit Card promotion.
                            //Revision 6.12.18 - added check to ensure Owner was a Collection rep to prevent unassigned emails sending from Eric Olsen or Andy Estep
                            if (opty.Sent_Email_1__c != true &&
                                opty.Sent_Email_2__c != true &&
                                opty.Sent_Email_3__c != true &&
                                opty.Sent_Email_4__c != true &&
                                !optyCCContacts.isEmpty() &&
                                orgWideEmailIds.contains(String.valueOf(fromId)) == true) {
                                    System.debug('Formatting first email with ' + opty + firstTemplate + optyCCContacts + fromId);
                                    if (opty.Account.BillingCountry == 'United States') {
                                        //Add email template to list to be used in a bulk send
                                        System.debug('Mail to US = ' + opty + ' ' + firstTemplate + ' ' + optyCCContacts + ' ' + fromId);
                                        mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplate, optyCCContacts, fromId, false));
                                        opty.Sent_Email_1__c = true;
                                        opty.Emails_Sent__c++;
                                        if (opty != null) {
                                            oppStatusUpdate.add(opty);
                                        }
                                    } else if (opty.Account.BillingState != 'Quebec') {
                                        mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplate, optyCCContacts, fromId, false));
                                        opty.Sent_Email_1__c = true;
                                        opty.Emails_Sent__c++;
                                        if (opty != null) {
                                            oppStatusUpdate.add(opty);
                                        }
                                    } /*else if(opty.Account.BillingCountry == 'India') {
mailList.add(emailHelper.sendCollectionEmail(opty, firstTemplate, optyCCContacts, fromId));
opty.Sent_Email_1__c = true;
opty.Emails_Sent__c ++;
if(opty != null) {
oppStatusUpdate.add(opty);
}
}*/
                                } else if (opty.Sent_Email_1__c == true &&
                                           opty.Sent_Email_2__c != true &&
                                           opty.Sent_Email_3__c != true &&
                                           opty.Sent_Email_4__c != true &&
                                           !optyCCContacts.isEmpty() &&
                                           orgWideEmailIds.contains(String.valueOf(fromId)) == true) {
                                               System.debug('Formatting second email with ' + opty + secondTemplate + optyCCContacts + fromId);
                                               if (opty.Account.BillingCountry == 'United States') {
                                                   //Add email template to list to be used in a bulk send
                                                   System.debug('Mail to US = ' + opty + ' ' + secondTemplate + ' ' + optyCCContacts + ' ' + fromId);
                                                   mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplate, optyCCContacts, fromId, false));
                                                   opty.Sent_Email_2__c = true;
                                                   opty.Emails_Sent__c++;
                                                   if (opty != null) {
                                                       oppStatusUpdate.add(opty);
                                                   }
                                               } else if (opty.Account.BillingState != 'Quebec') {
                                                   mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplate, optyCCContacts, fromId, false));
                                                   opty.Sent_Email_2__c = true;
                                                   opty.Emails_Sent__c++;
                                                   if (opty != null) {
                                                       oppStatusUpdate.add(opty);
                                                   }
                                               }
                                               /*else if(opty.Account.BillingCountry == 'India') {
mailList.add(emailHelper.sendCollectionEmail(opty, secondTemplate, optyCCContacts, fromId));
opty.Sent_Email_2__c = true;
opty.Emails_Sent__c ++;
if(opty != null) {
oppStatusUpdate.add(opty);
}
}*/
                                           } else if (opty.Sent_Email_1__c == true &&
                                                      opty.Sent_Email_2__c == true &&
                                                      opty.Sent_Email_3__c != true &&
                                                      opty.Sent_Email_4__c != true &&
                                                      !optyCCContacts.isEmpty() &&
                                                      orgWideEmailIds.contains(String.valueOf(fromId)) == true) {
                                                          System.debug('Formatting third email with ' + opty + thirdTemplate + optyCCContacts + fromId);
                                                          if (opty.Account.BillingCountry == 'United States') {
                                                              //Add email template to list to be used in a bulk send
                                                              opty.Sent_Email_3__c = true;
                                                              opty.Emails_Sent__c++;
                                                              if (opty != null) {
                                                                  oppStatusUpdate.add(opty);
                                                                  mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplate, optyCCContacts, fromId, false));
                                                                  System.debug('%%%%1');
                                                              }
                                                          } else if (opty.Account.BillingState != 'Quebec') {
                                                              mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplate, optyCCContacts, fromId, FALSE));
                                                              opty.Sent_Email_3__c = true;
                                                              opty.Emails_Sent__c++;
                                                              if (opty != null) {
                                                                  oppStatusUpdate.add(opty);
                                                                  System.debug('%%%%2');
                                                              }
                                                          }
                                                          /*else if(opty.Account.BillingCountry == 'India') {
mailList.add(emailHelper.sendCollectionEmail(opty, thirdTemplate, optyCCContacts, fromId));
opty.Sent_Email_3__c = true;
opty.Emails_Sent__c ++;
if(opty != null) {
oppStatusUpdate.add(opty);
System.debug('%%%%3');
}
}*/
                                                      } else if (opty.Sent_Email_1__c == true &&
                                                                 opty.Sent_Email_2__c == true &&
                                                                 opty.Sent_Email_3__c == true &&
                                                                 opty.Sent_Email_4__c != true &&
                                                                 !optyCCContacts.isEmpty() &&
                                                                 orgWideEmailIds.contains(String.valueOf(fromId)) == true) {
                                                                     System.debug('Formatting fourth email with ' + opty + fourthTemplate + optyCCContacts + fromId);
                                                                     if (opty.Account.BillingCountry == 'United States') {
                                                                         //Add email template to list to be used in a bulk send
                                                                         mailList.add(emailHelper.sendCollectionEmail(opty, fourthTemplate, optyCCContacts, fromId, false));
                                                                         opty.Sent_Email_4__c = true;
                                                                         opty.Emails_Sent__c++;
                                                                         if (opty != null) {
                                                                             oppStatusUpdate.add(opty);
                                                                         }
                                                                     } else if (opty.Account.BillingState != 'Quebec') {
                                                                         mailList.add(emailHelper.sendCollectionEmail(opty, fourthTemplate, optyCCContacts, fromId, false));
                                                                         opty.Sent_Email_4__c = true;
                                                                         opty.Emails_Sent__c++;
                                                                         if (opty != null) {
                                                                             oppStatusUpdate.add(opty);
                                                                         }
                                                                     }
                                                                     /*else if(opty.Account.BillingCountry == 'India') {
                                                                    mailList.add(emailHelper.sendCollectionEmail(opty, fourthTemplate, optyCCContacts, fromId));
                                                                    opty.Sent_Email_4__c = true;
                                                                    opty.Emails_Sent__c ++;
                                                                    if(opty != null) {
                                                                    oppStatusUpdate.add(opty);
                                                                    }
                                                                    }*/
                                                                 }                        
                        }
                        //Calls recursion prevention methods
                        setFirstRunFalse();
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
}