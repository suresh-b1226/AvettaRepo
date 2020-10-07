/**
* Created by JasonMcGrew on 5/1/2019.
*
* This Class will Automate the SER Teams emails after a phone call is 'manually' logged in the task(Activity) section of the opportunity layout.
* Once a call is logged it will Automatically send an email template(Global Supplier Enablement - English) based on the stage the opportunity is in and how many calls have been logged(1 to 5+ calls)
* After the email is sent it will log the email activity in the Task(Activity) opportunity page Layout.
*
* Metrics:
*   - 150,000 clicks saved per month
*   - ESTIMATED 19,000 emails sent automatically a month rather than manually
*   - 200hrs saved a month by Automating this process
*
* Salesforce Case #00945199 - 'Automate emails sent for supplier record type opportunites'
*
*/
public class supplier_SER_Opty_EmailAutomation {
    public static Boolean firstRun = true;
    public static Integer runCount = 0;
    
    public Boolean ser_EmailAutomationHandler(List<Task> newTrigger) {
        
        Boolean success = true;
        
        if ((supplier_SER_Opty_EmailAutomation.runCount == 0 && newTrigger != null) ||
            (Test.isRunningTest() == TRUE && supplier_SER_Opty_EmailAutomation.runCount < 1)) {
                
                List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        		String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
                
                if(profileName != 'Bizable User') {
                    
                    //Instantiate Id list for the task whatId and the accountID for each Opportunity
                    List<Id> OptyIds = new List<Id>();
                    for (Task t : newTrigger) {
                        
                        if (String.valueOf(t.getSObjectType()) == 'Task' &&
                            t.WhatId != NULL &&
                            String.valueOf(t.WhatId.getSobjectType()) == 'Opportunity' &&
                            t.Type == 'Call') {
                                
                                OptyIds.add(t.WhatId);
                            }
                    }
                    
                    
                    //SOQL query automation switch
                    Automation_Switch__mdt Registration_Follow_Up = [
                        SELECT Id, Label, On_Off__c
                        FROM Automation_Switch__mdt
                        WHERE Label = 'Registration: Follow Up'
                    ];
                    
                    //Query the Opportunity with needed requirements
                    List<Opportunity> optyList = new List<Opportunity>();
                    optyList = [
                        SELECT Id,
                        Name,
                        Contact__c,
                        Primary_Contact__r.Name,
                        Primary_Contact__c,
                        Primary_Contact_Email__c,
                        AccountId,
                        OwnerId,
                        RecordTypeId,
                        StageName,
                        Type,
                        Calls_Made__c,
                        Result__c,
                        Rep_E_Mail_Opt_Out__c,
                        CampaignId,
                        Attach_Client_Letter__c
                        FROM Opportunity
                        WHERE Id = :OptyIds
                        AND Type IN ('Reactivation', 'Registration')
                        AND StageName IN ('Prospect', 'In Progress', 'Closed Lost', 'Commit')
                        AND Result__c Not IN ('Aged', 'Duplicate', 'Client Exempt')
                        AND rep_E_Mail_Opt_Out__c = FALSE
                    ];
                    System.debug('optyList = ' + optyList);
                    if(optyList.size() == 0) {
                        return FALSE;
                    }
                    
                    //List for all the opportunity owner IDs
                    //List for all the account IDs from the Opportunitys in the 'optyList' SOQL Query above
                    List<Id> oppOwnerIds = new List<Id>();
                    List<Id> accountIds = new List<Id>();
                    List<Id> primaryCampaignIds = new List<Id>();
                    for (Opportunity opp : optyList) {
                        oppOwnerIds.add(opp.OwnerId);
                        accountIds.add(opp.AccountId);
                        System.debug('opp.CampaignId = ' + opp.CampaignId);
                        if(opp.CampaignId != null) primaryCampaignIds.add(opp.CampaignId);
                    }
                    System.debug('primaryCampaignIds = ' + primaryCampaignIds);
                    //Instantiates the Opportunity Owner that will be sending the email to the 'contactsToEmail' above
                    List<User> oppOwner = new List<User>();
                    oppOwner = [
                        SELECT Id, Name, Email
                        FROM User
                        WHERE Id = :oppOwnerIds
                        AND User.IsActive = TRUE
                        AND UserRole.Name IN ('Registration', 'Administration')
                    ];
                    
                    List<Contact> contactsToEmail = new List<Contact>();
                    contactsToEmail = [
                        SELECT Id, AccountId, Email, Name, Primary_PICS_Organizer_User__c
                        FROM Contact
                        WHERE Email != NULL
                        AND HasOptedOutOfEmail = FALSE
                        AND AccountId = :accountIds
                    ];
                    
                    List<ContentDocumentLink> documentLinkList = new List<ContentDocumentLink>();
                    if(primaryCampaignIds.size() > 0) {
                        documentLinkList = [
                            SELECT
                            ContentDocumentId,
                            LinkedEntityId
                            FROM ContentDocumentLink
                            WHERE LinkedEntityId IN:primaryCampaignIds
                        ];
                    }
                    System.debug('documentLinkList = ' + documentLinkList);
                    List<Id> contentDocumentIdList = new List<Id>();
                    for(ContentDocumentLink cdl : documentLinkList) {
                        contentDocumentIdList.add(cdl.ContentDocumentId);
                    }
                    
                    List<ContentVersion> contentDocumentBodyList = [SELECT
                                                                    ContentDocumentId,
                                                                    PathOnClient,
                                                                    VersionData,
                                                                    Client_Letter__c
                                                                    FROM ContentVersion
                                                                    WHERE ContentDocumentId IN: contentDocumentIdList
                                                                    AND Client_Letter__c = TRUE];
                    Map<Id, ContentVersion> contentDocumentBody = new Map<Id, ContentVersion>();
                    for(ContentVersion cv : contentDocumentBodyList) {
                        contentDocumentBody.put(cv.ContentDocumentId, cv);
                    }
                    
                    System.debug('contentDocumentBody = ' + contentDocumentBody);
                    List<String> RegistrationTeamEmails = new List<String>();
                    for (User RegistrationUser : oppOwner) {
                        RegistrationTeamEmails.add(RegistrationUser.Email);
                    }
                    
                    //SOQL query all orgWideEmail address that have the same e-mail as any users that have a userRole of 'Registration'
                    List<OrgWideEmailAddress> orgWideEmails = [
                        SELECT Id, Address, DisplayName
                        FROM OrgWideEmailAddress
                        WHERE Address =: RegistrationTeamEmails
                    ];
                    
                    Id fromId;
                    for (User oppUser : oppOwner) {
                        
                        for (OrgWideEmailAddress orgEmail : orgWideEmails) {
                            
                            if (oppUser.Email == orgEmail.Address) {
                                fromId = orgEmail.Id;
                            }
                        }
                    }
                    
                    if (Registration_Follow_Up.On_Off__c == true) {
                        
                        for (Opportunity opp : optyList) {
                            EmailTemplate serEmailTemp;
                            ContentVersion attachment;
                            
                            for(ContentDocumentLink cdl : documentLinkList) {
                                if(cdl.LinkedEntityId == opp.CampaignId) {
                                    System.debug('cdl.ContentDocumentId = ' + cdl.ContentDocumentId);
                                    if(contentDocumentBody.get(cdl.ContentDocumentId) != NULL && contentDocumentBody.get(cdl.ContentDocumentId).Client_Letter__c == TRUE) {
                                        attachment = contentDocumentBody.get(cdl.ContentDocumentId);
                                        System.debug('cdl.ContentDocumentId = ' + cdl.ContentDocumentId);
                                    }
                                }
                            }
                            
                            //Instantiates the contact on the opportunity to email
                            List<Contact> OptyContact = new List<Contact>();
                            for (Contact oppContacts : contactsToEmail) {
                                
                                if(contactsToEmail.size() > 0 ) {
                                    
                                    if (oppContacts.AccountId == opp.AccountId) {
                                        
                                        if (oppContacts.Email != null && oppContacts.Primary_PICS_Organizer_User__c == true) {
                                            OptyContact.add(oppContacts);
                                        }
                                    }
                                }
                            }
                            
                            //A class object is created here that will be used to send all the data that is generated in
                            //this inital class over to a new class that will handle the creation, sending, and language
                            //of the emails that will be sent to the contacts that are already generated here. This is done
                            //to enhance readablity and to allow code to be more dynamic and flexible for when new features are
                            //added at a later date

                            Supplier_SER_Opty_LanguageEmailTemplate buildEmailTemplate = new Supplier_SER_Opty_LanguageEmailTemplate();
                            
                            //Calling the new method created in the language email template class to begin the construction and
                            //placement of the data generated here for the email template. In order to do this, the opp,
                            //optycontact and ids must be sent over to leave this process intact. The class logic ends here.
                            success = buildEmailTemplate.DetermineLanguageTemplate(opp, OptyContact, fromID, accountIds, attachment);
                            runCount++;
                        }
                    }
                }
            }
        return success;
    }
    
    
}