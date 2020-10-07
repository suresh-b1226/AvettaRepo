/*
 * Created by Dallin Wasden 2.1.19.
 * Populates 'Related Client Account' field on Case by running logic on Related Client Cases objects. If there is only
 * one supplier in the list, that supplier becomes the Related Client Account on the case. If more than one supplier
 * exists in the list, then the list is searched for a 'Global Parent' account and that account is listed as the
 * Related Client Account on the case. This will account for cases that have 50 related clients from the same corporate
 * account (ie: Amazon). Once the Related Client Account field has been filled, this logic will no longer run.
 */

public class Supplier_CS_Case_RelatedAccount {
    private static boolean firstRun = true;

    //Method to set recursion variable to false
    public static void setFirstRunFalse() {
        firstRun = False;
        System.debug('setFirstRun false');
    }

    public void Supplier_CS_Case_RelatedAccount(List<Related_Client_Case__c> newTrigger) {

        if (firstRun == True) {
            List<Case> relatedClientUpdates = new List<Case>();
            System.debug('enter Supplier_CS_Case_RelatedAccount');

            List<Id> relatedClientCaseIds = new List<Id>();
            for(Related_Client_Case__c relatedClient : newTrigger) {
                relatedClientCaseIds.add(relatedClient.Related_Case__c);
            }

            List<Case> relatedCase = [
                    SELECT Id, Type, Related_Client_Account__c, (SELECT Id, Related_Client__c, Related_Client__r.Global_Parent__c, Related_Case__c FROM Related_Clients__r)
                    FROM Case
                    WHERE Id in : relatedClientCaseIds
            ];

            for (Related_Client_Case__c relClient : relatedCase[0].Related_Clients__r) {
                System.debug(relClient);
            }

            for (Case updatedCase : relatedCase) {
                if (updatedCase.Related_Client_Account__c == null) {

                    Case soqlCase;
                    for (Case caseRelatedClient : relatedCase) {
                        System.debug(caseRelatedClient);
                        System.debug(updatedCase.Id);
                        System.debug(updatedCase.Id == caseRelatedClient.Id);
                        if (caseRelatedClient.Id == updatedCase.Id) {
                            soqlCase = caseRelatedClient;
                        }
                    }

                    List<Id> caseRelatedClients = new List<Id>();
                    for (Related_Client_Case__c relatedAccount : soqlCase.Related_Clients__r) {
                        caseRelatedClients.add(relatedAccount.Related_Client__c);
                    }

                    if (updatedCase.Type == 'insureGuard') {

                        if (caseRelatedClients.size() == 1) {
                            soqlCase.Related_Client_Account__c = caseRelatedClients[0];
                            relatedClientUpdates.add(soqlCase);
                        } else if (caseRelatedClients.size() > 1) {

                            Id caseGlobalParent;
                            Integer count = 0;

                            do {
                                if (soqlCase.Related_Clients__r[count].Related_Client__r.Global_Parent__c != null) {
                                    caseGlobalParent = soqlCase.Related_Clients__r[count].Related_Client__r.Global_Parent__c;
                                }
                                count++;
                            } while (count < soqlCase.Related_Clients__r.size() && caseGlobalParent == null);

                            soqlCase.Related_Client_Account__c = caseGlobalParent;
                            relatedClientUpdates.add(soqlCase);
                        }
                    }
                }

                if (relatedClientUpdates != null) {

                    setFirstRunFalse();
                    update relatedClientUpdates;
                }
            }
        }
    }
}