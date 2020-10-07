/* Created by Jason McGrew on 6.25.2019.
* Class will update the OpportunityContactRole(OCR) and make sure that the Primary Contact field is populated based on the
* OCR Primary Contact. If here is not a primary contact it will find the newest created OCR and make them the Primary Contact.
* If there are not any OCR's on the Opportunity, it will look up to the Account and populate the Opportunity Primary Contact with the Account Primary Contact.
* It will also create an OCR based on the Account Primary contact.
*/

public class updateContactRole {

    private static Boolean firstRun = true;

    //Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug(' ** isFirstRun returned ' + firstRun);
        return firstRun;
    }

    public static void setFirstRunFalse() {
        firstRun = false;
        System.debug(' ** setFirstRunFalse run');
    }

    public void updateContactRoleHandler(List<Opportunity> newTrigger) {
        System.debug(' ** Enter UpdateContactRoleTrigger');

        if (updateContactRole.isFirstRun() == true) {
            List<Opportunity> triggeredOpps = new List<Opportunity>();

            for (Opportunity opp : newTrigger) {

                //Only run class if record type is 'Supplier'
                if (opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() && opp != null  && opp.StageName != 'Mailed') {
                    System.debug(' ** oppToUpdate = ' + opp);
                    triggeredOpps.add(opp);
                }
            }
            if (triggeredOpps.size() > 0) {

                List<Id> oppIds = new List<Id>();
                List<Id> oppAccId = new List<Id>();

                for (Opportunity opp : triggeredOpps) {
                    oppIds.add(opp.Id);
                }
                System.debug(' ** oppIds = ' + oppIds);

                for (Opportunity opp : triggeredOpps) {
                    oppAccId.add(opp.AccountId);
                }
                System.debug(' ** oppContactId = ' + oppAccId);

                //Instantiates list of the opportunities pulled from the database
                List<Opportunity> oppsToUpdate = [
                        SELECT Id, AccountId, Priority__c
                        FROM Opportunity
                        WHERE Opportunity.Id <> NULL
                        AND Opportunity.Id = :oppIds
                ];
                
                //Instantiates list of primary contacts with associated opportunity ID
                List<OpportunityContactRole> opportunityContactList = [
                        SELECT Contact.Id, Contact.Email, Opportunity.Id, CreatedDate, Opportunity.Primary_Contact_Email__c,IsPrimary,Opportunity.AccountId
                        FROM OpportunityContactRole
                        WHERE Opportunity.Id <> NULL
                        AND Opportunity.Id = :oppIds
                ];
                System.debug(' ** opportunityContactList = ' + opportunityContactList);

                //Instantiates list of Accounts with associated opportunity ID
                List<Account> accContact = [
                        SELECT Id, Name, Primary_Contact__c
                        FROM Account
                        WHERE Account.Id <> NULL
                        AND Account.Id = :oppAccId
                ];
                System.debug(' ** ACCOUNT CONTACT = ' + accContact);
                System.debug(' ** ACCOUNT CONTACT LIST SIZE=  ' + accContact.size());

                //Instantiates a Map of Accounts that have matching Opportunity ID.
                Map<Id, Account> optyAcctMap = new Map<Id, Account>();
                for(Opportunity opty : oppsToUpdate) {
                    for(Account acct : accContact) {
                        if(acct.Id == opty.AccountId){
                        	optyAcctMap.put(opty.Id, acct);
                        }
                    }
                }
                //Instantiates list of Contacts with associated Opportunity ID.
                List<Contact> con = [
                        SELECT Id, Name, AccountId, Primary_PICS_Organizer_User__c, CreatedDate
                        FROM Contact
                        WHERE Contact.Id <> NULL
                        AND Contact.AccountId = :oppAccId
                ];
                System.debug(' ** CONTACT LIST = ' + con);

                //Instantiates list of Contacts with associated Opportunity ID.
                List<Contact> mostRecentCon = [
                        SELECT Id, Name, AccountId, Primary_PICS_Organizer_User__c, CreatedDate
                        FROM Contact
                        WHERE Contact.Id <> NULL
                        AND Contact.AccountId = :oppAccId
                        ORDER BY CreatedDate DESC
                        LIMIT 1
                ];
                System.debug(' ** mostRecentCon = ' + mostRecentCon);

                List<OpportunityContactRole> accountContactList = new List<OpportunityContactRole>();
                List<OpportunityContactRole> updated_OCR_List = new List<OpportunityContactRole>();
                List<Contact> contactsToUpdate = new List<Contact>();

                for (Opportunity opp : oppsToUpdate) {

                    Boolean oppPrimaryContExists = false;

                    //Loop through the OCR and if it's not the primary contact, make it the primary contact.
                    //Scenario: There is only 1 OCR on Opty
                    for (OpportunityContactRole oppCont : opportunityContactList) {
                        if (opp.Id == oppCont.OpportunityId) {
                            if (opportunityContactList.size() == 1) {
                                if (oppCont.IsPrimary == false) {
                                    oppCont.IsPrimary = true;
                                    opp.Primary_Contact__c = oppCont.Contact.Id;
                                    updated_OCR_List.add(oppCont);
                                } else if (oppCont.IsPrimary == true) {
                                    opp.Primary_Contact__c = oppCont.Contact.Id;
                                    updated_OCR_List.add(oppCont);
                                }
                            }
                        }
                        System.debug(' ** updated_OCR_List-1 ' + updated_OCR_List);
                        System.debug(' ** updated opportunityContactList ');
                    }
                    //Loop through all OCR's, if there is a OCR Primary Contact, make them the Opty Primary Contact.
                    //Scenario: There are more than 1 OCR on Opty
                    if (opportunityContactList.size() > 1) {

                        OpportunityContactRole primaryContact;
                        for (OpportunityContactRole primaryOppContact : opportunityContactList) {
                            if (opp.Id == primaryOppContact.OpportunityId) {
                                if (primaryOppContact.IsPrimary == true) {
                                    primaryContact = primaryOppContact;
                                    oppPrimaryContExists = true;
                                }
                            }
                        }
                        if (oppPrimaryContExists == true) {
                            opp.Primary_Contact__c = primaryContact.Contact.Id;
                            primaryContact.IsPrimary = true;
                        }
                    }
                    if (oppPrimaryContExists == false) {
                        OpportunityContactRole newestContactRole;
                        System.debug(' ** newestContactRole = ' + newestContactRole);
                        //Loop through all OCR's, if there is not an OCR Primary Contact, find the newest created OCR and make them the OCR Primary contact
                        //as well as the Opty Primary Contact.
                        //Scenario: There are more than 1 OCR on Opty
                        for (OpportunityContactRole ocrContactRole : opportunityContactList) {
                            if (opp.Id == ocrContactRole.OpportunityId) {
                                if (ocrContactRole.IsPrimary == true) {
                                } else if (ocrContactRole.IsPrimary == false) {
                                    if (newestContactRole == null || ocrContactRole.CreatedDate > newestContactRole.CreatedDate) {
                                        newestContactRole = ocrContactRole;
                                        opp.Primary_Contact__c = ocrContactRole.Contact.Id;
                                        ocrContactRole.IsPrimary = true;
                                        updated_OCR_List.add(ocrContactRole);
                                        System.debug(' ** newestContactRole = ' + newestContactRole);
                                        System.debug('*Error Here');
                                    }
                                }
                            }
                            System.debug(' ** updated_OCR_List-2 ' + updated_OCR_List);
                        }
                        newestContactRole = null;
                    }
                    oppPrimaryContExists = null;
                    //If there are zero OCR's on the Opty, then look up to the Account Primary Contact. The Account Primary Contact
                    //will then become the OCR Primary Contact as well as the Opty Primary Contact.
                    List<OpportunityContactRole> thisOpportunityContactList = new List<OpportunityContactRole>();

                    Contact mostRecentContact;

                    for (OpportunityContactRole oc : opportunityContactList) {
                        if (opp.AccountId == oc.Opportunity.AccountId) {
                            thisOpportunityContactList.add(oc);
                        }
                    }
                    if (thisOpportunityContactList.isEmpty() == true) {
                        if (opp.Priority__c == 'Registration Request') {
                            for (Contact newestCon : mostRecentCon ) {
                                if (newestCon.AccountId == opp.AccountId) {
                                    accountContactList.add(new OpportunityContactRole(ContactId = newestCon.Id, OpportunityId = opp.Id, IsPrimary = true));
                                    opp.Primary_Contact__c = newestCon.Id;
                                }
                            }
                        } else {

                            for (Contact c : con) {
                                if (c.AccountId == opp.AccountId) {
                                    if (c.Id == optyAcctMap.get(opp.Id).Primary_Contact__c) {
                                        accountContactList.add(new OpportunityContactRole(ContactId = c.Id, OpportunityId = opp.Id, IsPrimary = true));
                                        opp.Primary_Contact__c = c.Id;
                                    }
                                }
                            }
                        }
                    }
                    System.debug(' ** accountContactList ' + accountContactList);

                    for (Contact ct: con) {
                        for (OpportunityContactRole oc: updated_OCR_List){
                            if (ct.Id == oc.Id && oc.IsPrimary == true) {
                                ct.Primary_PICS_Organizer_User__c = true;
                                contactsToUpdate.add(ct);

                            }
                        }
                    }
                }
                setFirstRunFalse();
                insert accountContactList;
                update updated_OCR_List;
                update oppsToUpdate;
                update contactsToUpdate;

            }
        }
    }
}