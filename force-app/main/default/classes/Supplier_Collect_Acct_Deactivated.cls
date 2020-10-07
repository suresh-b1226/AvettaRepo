//Written by Dallin Wasden 6.5.2018
//Sends email to all contacts on an account upon deactivation of an account with record type 'contractor'.

/**
* Updated on 02.06.2020 by Jason McGrew
*
* The deactivation email will no longer be sent from the Collection's Team and will now be sent from the Registration Team.
* Email From Address will be based on the region that the account is located in:
*
* Display Name: Avetta Notifications
* APAC - APACregistrations@avetta.com
* EMEA - EMEAregistrations@avetta.com
* NORAM - NORAMregistrations@avetta.com
* LATAM - LATAMregistro@avetta.com
*
* */


public class Supplier_Collect_Acct_Deactivated {
    private static Boolean firstRun = true;
    
    //Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }
    
    //Method to set recursion variable to false
    public static void setFirstRunFalse() {
        firstRun = false;
        System.debug('setFirstRunFalse run');
    }
    
    public void Supplier_Collect_Acct_DeactivatedHandler( List<Account> newTrigger, List<Account> oldTrigger ) {
        List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
        String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
        
        if(profileName != 'Bizable User') {
            
            List<Account> deactAcct = new List<Account>();
            List<Account> contractorAccount = new List<Account>();
            Set<String> applicableCountries = new Set<String>();
            
            //Countries to pass through class
            applicableCountries.add('Canada');
            applicableCountries.add('CA');
            applicableCountries.add('United States');
            applicableCountries.add('US');
            applicableCountries.add('United Kingdom');
            applicableCountries.add('UK');
            applicableCountries.add('GB');
            applicableCountries.add('Australia');
            applicableCountries.add('AU');
            
            //Instantiate handler
            Supplier_Collect_Acct_Deactivated handler = new Supplier_Collect_Acct_Deactivated();
            
            //Check to ensure at least one account in trigger is of record type 'contractor'
            for (Account acct : newTrigger) {
                if (acct.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId()) {
                    contractorAccount.add(acct);
                }
            }
            
            //Prevents recursion and unnecessary running of class
            if (Supplier_Collect_Acct_Deactivated.isFirstRun() == true &&
                contractorAccount.size() > 0) {
                    for (Account acct : newTrigger) {
                        Account matchingOldAccount;
                        
                        for (Account oldAcct : oldTrigger) {
                            if (oldAcct.Id == acct.Id) {
                                matchingOldAccount = oldAcct;
                            }
                        }
                        //Determines whether account status has been changed from 'Active' to 'Deactivated' and for correct country
                        if (acct.Status__c == 'Deactivated' &&
                            matchingOldAccount.Status__c == 'Active' &&
                            applicableCountries.contains(acct.BillingCountry)) {
                                if (acct.BillingState != 'Quebec') {
                                    deactAcct.add(acct);
                                }
                            }
                        
                        System.debug('matchingOldAccount = ' + matchingOldAccount);
                        System.debug('acct = ' + acct);
                    }
                    
                    //If one of the triggered accounts was changed from 'Sent_Deactivation_Notification__c == False' to 
                    //'Sent_Deactivation_Notification__c == True' then run class and necessary logic
                    if (deactAcct.size() > 0) {
                        
                        //SOQL query to retrieve email template ID
                        EmailTemplate template = [
                            SELECT Id, DeveloperName
                            FROM EmailTemplate
                            WHERE DeveloperName = 'Collections_System_Email_Account_Deactivated'
                            LIMIT 1
                        ];
                        System.debug('template = ' + template);
                        
                        Automation_Switch__mdt deactivationSwitch = [
                            SELECT Id, Label, On_Off__c
                            FROM Automation_Switch__mdt
                            WHERE Label = 'Collection: Deactivation'
                        ];
                        System.debug('deactivationSwitch = ' + deactivationSwitch);
                        
                        /*                //SOQL query all users with role 'Collections'
List<User> collectionRoleUsers = [
SELECT Id, Name, Email, LocaleSidKey
FROM User
WHERE UserRole.Name = 'Collections'
];

List<User> retentionRoleUsers = [
SELECT Id, Name, Email, LocaleSidKey
FROM User
WHERE (UserRole.Name = 'Saves (Deactivation)' OR UserRole.Name = 'Saves (Downgrade)')
];
*/
                        
                        //SOQL query to retrieve all linked opportunities
                        List<Opportunity> linkedOptys = [
                            SELECT Id, Type, Owner.Name, Owner.Email, AccountId, RecordType.Name, StageName, Opp_Owner_Email__c,Region__c
                            FROM Opportunity
                            WHERE AccountId = :deactAcct
                            ORDER BY CreatedDate ASC
                        ];
                        System.debug('linkedOptys = ' + linkedOptys);
                        
                        
                        //SOQL query to retrieve all linked client sites
                        List<Operator_Contractor__c> linkedOptyCont = [
                            SELECT Operator__r.Name, Contractor__r.Id
                            FROM Operator_Contractor__c
                            WHERE Contractor__c = :deactAcct
                            AND (NOT Operator__r.Name LIKE '%Avetta%')
                            //Changed from 'Is_Active = True' to 'Active' by JMcGrew for Case# 00560783 on 4.25.19
                            AND Status__c = 'Active'
                        ];
                        System.debug('linkedOptyCont = ' + linkedOptyCont);
                        
                        //Uses custom metadata automation switch to turn trigger on/off
                        if (deactivationSwitch.On_Off__c == true) {
                            List<Id> exemptAccountIds = new List<Id>();
                            
                            for (Opportunity linkedOpty : linkedOptys) {
                                if (linkedOpty.Type == 'Collection Upgrade' ||
                                    (linkedOpty.RecordType.Name == 'Retention' &&
                                     (linkedOpty.StageName == 'Open' ||
                                      linkedOpty.StageName == 'Attempted' ||
                                      linkedOpty.StageName == 'In Progress' ||
                                      linkedOpty.StageName == 'Ready for Deactivation' ||
                                      linkedOpty.StageName == 'Ready for Deactivation - Refund' ||
                                      linkedOpty.StageName == 'Deactivated'))) {
                                          exemptAccountIds.add(linkedOpty.AccountId);
                                      }
                                
                                //Revised 10/1/18 as per Tharon's request to make any Supplier linked only to JLL site exempt from automated email communications.
                                Boolean jllOpty = false;
                                for (Operator_Contractor__c optyCont : linkedOptyCont) {
                                    if (optyCont.Contractor__r.Id == linkedOpty.AccountId &&
                                        (optyCont.Operator__r.Name.contains('JLL'))) {
                                            jllOpty = true;
                                        } else if (optyCont.Contractor__r.Id == linkedOpty.AccountId &&
                                                   jllOpty == true) {
                                                       jllOpty = false;
                                                   }
                                }
                                if (jllOpty == true) {
                                    exemptAccountIds.add(linkedOpty.AccountId);
                                }
                            }
                            System.debug('Exemptions = ' + exemptAccountIds);
                            
                            //Instantiates list specifying which accounts should actually be sent the deactivation email
                            List<Account> validDeactivations = new List<Account>();
                            for (Account act : deactAcct) {
                                if (exemptAccountIds.contains(act.Id) == false) {
                                    validDeactivations.add(act);
                                }
                            }
                            System.debug('validdeactivations' + validDeactivations);
                            
                            //Populate list of email addresses that will be used in SOQL query below to determine the org-wide email ID associated with the user email address
                            /*                    List<String> collectionEmails = new List<String>();
for (User collectionUser : collectionRoleUsers) {
collectionEmails.add(collectionUser.Email);
}
List<String> retentionEmails = new List<String>();
for (User retentionUser : retentionRoleUsers){
retentionEmails.add(retentionUser.Email);
}*/
                            
                            
                            /*                    //SOQL query all users with role 'Collections'
List<OrgWideEmailAddress> orgWideEmails = [
SELECT Id, Address, DisplayName
FROM OrgWideEmailAddress
WHERE Address =: collectionEmails
OR Address =: retentionEmails

];
System.debug('orgwideEmails = ' + orgWideEmails);*/
                            
                            //SOQL query all users with role 'Collections'
                            List<OrgWideEmailAddress> orgWideEmails = [
                                SELECT Id, Address, DisplayName
                                FROM OrgWideEmailAddress
                                WHERE Address NOT IN ('notifications@avetta.com')
                                AND DisplayName = 'Avetta Notifications'
                                
                            ];
                            System.debug('orgwideEmails = ' + orgWideEmails);
                            
                            List<Opportunity> oppStatusUpdate = new List<Opportunity>();
                            List<Id> emailListAccountIds = new List<Id>();
                            List<Messaging.SingleEmailMessage> mailList = new List< Messaging.SingleEmailMessage >();
                            
                            //Instantiates list of related AccountIds
                            List<Id> accountIds = new List<Id>();
                            for (Account acct : deactAcct) {
                                accountIds.add(acct.Id);
                            }
                            
                            //SOQL query to populate list of all associated CC email addresses
                            List<Contact> ccContactList = [
                                SELECT Email, Organizer_isActive__c, Primary_PICS_Organizer_User__c, AccountId
                                FROM Contact
                                WHERE AccountId = :accountIds
                                AND Email != NULL
                            ];
                            System.debug('ccContactList = ' + ccContactList);
                            
                            Map<String, Id> OrgWideEmailAddress_Map = new Map<String, Id>();
                            //Avetta Notifications
                            for(Account a : deactAcct) {
                                if (a.Region__c != null) {
                                    for (OrgWideEmailAddress owa : orgWideEmails) {
                                        if (owa.Address == 'APACregistrations@avetta.com' && a.Region__c == 'APAC') {
                                            OrgWideEmailAddress_Map.put(a.Region__c, owa.Id);
                                            continue;
                                        } else if (owa.Address ==  'EMEAregistrations@avetta.com' && a.Region__c == 'EMEA') {
                                            OrgWideEmailAddress_Map.put(a.Region__c, owa.Id);
                                            continue;
                                        } else if (owa.Address == 'NORAMregistrations@avetta.com' && a.Region__c == 'NORAM') {
                                            OrgWideEmailAddress_Map.put(a.Region__c, owa.Id);
                                            continue;
                                        } else if (owa.Address == 'LATAMregistro@avetta.com' && a.Region__c == 'LATAM') {
                                            OrgWideEmailAddress_Map.put(a.Region__c, owa.Id);
                                        }
                                    }
                                }
                            }
                            System.debug('OrgWideEmailAddress_Map = ' + OrgWideEmailAddress_Map);
                            
                            Integer randNum = Integer.valueOf((Math.random() * orgWideEmails.size()));
                            String fromId = orgWideEmails[randNum].Id;
                            //Iterate through accounts and org-wide emails to find ID of the org-wide email address corresponding to the opportunity owner's email address
                            //and then set the fromId
                            //This loop also sets the 'whatOpty' to the correct opty. This is used in setWhatId in the emailHelper class
                            //If there is no deactivation or collection opty - the 'fromId' is set to a random collection role rep. (per Tharon's request)
                            for (Account acct : deactAcct) {
                                //String fromId = orgWideEmails[randNum].Id;
                                System.debug('GOT HERE 1');
                                if (acct.Region__c == 'APAC') {
                                    System.debug('GOT HERE 2');
                                    fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                    
                                } else if (acct.Region__c == 'EMEA') {
                                    System.debug('GOT HERE 3');
                                    fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                    
                                } else if (acct.Region__c == 'NORAM') {
                                    System.debug('GOT HERE 4');
                                    System.debug('fromId = ' + fromId);
                                    fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                    System.debug('fromId = ' + fromId);
                                    System.debug('GOT HERE 4.1');
                                    
                                } else if (acct.Region__c == 'LATAM') {
                                    System.debug('GOT HERE 5');
                                    fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                }
                                Opportunity whatOpty = null;
                                
                                System.debug('fromId = ' + fromId);
                                
                                //Set the 'fromId' to the orgWideAddressUser that is connected with the linked Deactivation or Collection opty owner
                                //First checks for any retention optys on the account, then c 
                                for(Opportunity opp: linkedOptys){
                                    if(acct.Id == opp.AccountId 
                                       && opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId()
                                      ) {
                                          whatOpty = opp;
                                          for(OrgWideEmailAddress orgWideAddressUser: orgWideEmails){
                                              /*                                    if (opp.Opp_Owner_Email__c == orgWideAddressUser.Address){
fromId = orgWideAddressUser.Id;
}*/
                                              if (acct.Region__c == 'APAC') {
                                                  fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                                  continue;
                                              } else if (acct.Region__c == 'EMEA') {
                                                  fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                                  continue;
                                              } else if (acct.Region__c == 'NORAM') {
                                                  fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                                  continue;
                                              } else if (acct.Region__c == 'LATAM') {
                                                  fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                              }
                                          }
                                          break;   
                                      }
                                    else if(acct.Id == opp.AccountId 
                                            && opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId()){
                                                whatOpty = opp;
                                                for(OrgWideEmailAddress orgWideAddressUser: orgWideEmails){
                                                    /*                                       if(opp.Opp_Owner_Email__c == orgWideAddressUser.Address){
fromId = orgWideAddressUser.Id;   
}*/
                                                    if (acct.Region__c == 'APAC') {
                                                        fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                                        continue;
                                                    } else if (acct.Region__c == 'EMEA') {
                                                        fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                                        continue;
                                                    } else if (acct.Region__c == 'NORAM') {
                                                        fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                                        continue;
                                                    } else if (acct.Region__c == 'LATAM') {
                                                        fromId = OrgWideEmailAddress_Map.get(acct.Region__c);
                                                    }
                                                }
                                            }
                                }
                                
                                //Find opportunity's associated CC email addresses
                                List<Contact> optyCCContacts = new List<Contact>();
                                for (Contact ccContact : ccContactList) {
                                    System.debug('ccContact.AccountId = ' + ccContact.AccountId);
                                    if (ccContact.AccountId == acct.Id) {
                                        if (ccContact.Email != null) {
                                            optyCCContacts.add(ccContact);
                                        }
                                    }
                                }
                                System.debug('optyCCContacts = ' + optyCCContacts);
                                
                                //Set the account's 'sent_deactivation_notification' field
                                acct.Sent_Deactivation_Notification__c = Datetime.now();
                                
                                //Added logic to send email only to primary contact on account (for Clients who also have Supplier account)
                                if(!optyCCContacts.isEmpty()){
                                    if(acct.Supplier_is_also_a_client__c == false) {
                                        mailList.add(emailHelper.sendDeactivationEmail(acct, template, optyCCContacts, fromId, whatOpty, false));
                                    } else {
                                        mailList.add(emailHelper.sendDeactivationEmail(acct, template, optyCCContacts, fromId, whatOpty, true));
                                    }
                                }
                            }
                            
                            //Send batch of emails
                            System.debug('mailList = ' + mailList);
                            if (mailList.size() > 0) {
                                Messaging.sendEmail(mailList);
                            }
                        }
                    }
                }
        }
    }
}