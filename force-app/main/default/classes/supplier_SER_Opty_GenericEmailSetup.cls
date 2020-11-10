/****************************************************************************************
 * © Avetta, LLC                                                                        *
 *                                                                                      *
 * AUTHOR: Jeff DeGraw                                                                  *
 * DATE:   10/18/2019                                                                   *
 *                                                                                      *
 * SUMMARY:                                                                             *
 * This is a class that will hold the data needed to configure english                  *
 * email templates to eventually send out to account contacts that                      *
 * require email instructions to be in the english language.                            *
 * This class is a component of the language email automation class                     *
 * in which an email template object is established and converted to                    *
 * english. Once this process is complete, the newly formed english                     *
 * email template will be sent back to the language email template                      *
 * class to be sent to the end user.                                                    *
 *                                                                                      *
 * Languages supported: (must be capitalized)                                           *
 * - English                                                                            *
 * - Spanish                                                                            *
 * - Portuguese                                                                         *
 * - German                                                                             *
 * - Dutch                                                                              *
 *                                                                                      *
 * METRICS:                                                                             *
 * NEED INFO                                                                            *
 *                                                                                      *
 * SALESFORCE CASE:                                                                     *
 * 01361779                                                                             *
 *                                                                                      *
 * REVISION HISTORY:                                                                    *
 * 10/18/2019 - Jeff DeGraw - Initial version                                           *
 * 12/02/2019 - Jeff DeGraw - Add error messages to UI                                  *
 ****************************************************************************************/

public with sharing class supplier_SER_Opty_GenericEmailSetup {
    // @AuraEnabled
    // If this method is called, an email template list is generated. The email templates are instatiated and then
    // set depending on whichever email template name has been used in salesforce. This method will only be executed 
    // in the case of the country language set to English
    
    public Boolean ConfigureGenericEmailTemplate(Opportunity opp, List<Contact> optyContact, ID fromId, List<Id> accountId, String language, ContentVersion attachment) {


        List<EmailTemplate> templateList = [
                SELECT Id, DeveloperName
                FROM EmailTemplate
                WHERE DeveloperName Like :('%Registration_Automation%_' + language)
        ];

        // Check that language is supported
        if (templateList.size() < 1) {
            // Log the error
            System.debug('*** ERROR: You requested an email automation template for a currently unsupported language: ' + language);
            return false;
        }

        EmailTemplate regProspect1;
        EmailTemplate regProspect2;
        EmailTemplate regProspect3;
        EmailTemplate regProspect4;
        EmailTemplate regProspect5Plus;
        EmailTemplate reactProspect1;
        EmailTemplate reactProspect2;
        EmailTemplate reactProspect3;
        EmailTemplate reactProspect4;
        EmailTemplate reactProspect5Plus;
        EmailTemplate regInProgress1;
        EmailTemplate regInProgress2;
        EmailTemplate regInProgress3;
        EmailTemplate regInProgress4;
        EmailTemplate regInProgress5Plus;
        EmailTemplate reactInProgress1;
        EmailTemplate reactInProgress2;
        EmailTemplate reactInProgress3;
        EmailTemplate reactInProgress4;
        EmailTemplate reactInProgress5Plus;
        EmailTemplate closedLostBadData;
        EmailTemplate closedLostNoResponse;
        EmailTemplate closedLostDeclined;
        EmailTemplate closedLostNotWorkingForClient;
        EmailTemplate closedLostEscalateToClient;
        EmailTemplate stageCommit;
        EmailTemplate serEmailTemp;

        for (EmailTemplate template : templateList) {

            if (template.DeveloperName == 'Registration_Automation_1_0_' + language) {
                regProspect1 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_2_0_' + language) {
                regProspect2 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_3_0_' + language) {
                regProspect3 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_4_0_' + language) {
                regProspect4 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_5_0_' + language){
                regProspect5Plus = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_1_1_' + language) {
                reactProspect1 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_2_1_' + language) {
                reactProspect2 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_3_1_' + language) {
                reactProspect3 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_4_1_' + language) {
                reactProspect4 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_5_1_' + language) {
                reactProspect5Plus = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_1_2_' + language) {
                regInProgress1 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_2_2_' + language) {
                regInProgress2 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_3_2_' + language) {
                regInProgress3 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_4_2_' + language) {
                regInProgress4 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_5_2_' + language) {
                regInProgress5Plus = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_1_3_' + language) {
                reactInProgress1 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_2_3_' + language) {
                reactInProgress2 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_3_3_' + language) {
                reactInProgress3 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_4_3_' + language) {
                reactInProgress4 = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_5_3_' + language) {
                reactInProgress5Plus = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_6_0_' + language) {
                closedLostBadData = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_6_1_' + language) {
                closedLostNoResponse = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_6_2_' + language) {
                closedLostDeclined = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_6_3_' + language) {
                closedLostNotWorkingForClient = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_6_4_' + language) {
                closedLostEscalateToClient = template;
            }

            else if (template.DeveloperName == 'Registration_Automation_7_0_Commit_' + language) {
                stageCommit = template;
            }
        }

        if(optyContact != NULL && optyContact.size() > 0) {

            if (opp.Type == 'Registration') {

                if (opp.StageName == 'Prospect') {

                    if (opp.Current_Calls_Made__c == 1) {
                        serEmailTemp = regProspect1;
                        opp.Contact__c = optyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 2) {
                        serEmailTemp = regProspect2;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 3) {
                        serEmailTemp = regProspect3;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 4) {
                        serEmailTemp = regProspect4;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c >= 5) {
                        serEmailTemp = regProspect5Plus;
                        opp.Contact__c = OptyContact[0].Id;
                    }
                }

                else if (opp.StageName == 'In Progress') {

                    if (opp.Current_Calls_Made__c == 1) {
                        serEmailTemp = regInProgress1;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 2) {
                        serEmailTemp = regInProgress2;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 3) {
                        serEmailTemp = regInProgress3;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 4) {
                        serEmailTemp = regInProgress4;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c >= 5) {
                        serEmailTemp = regInProgress5Plus;
                        opp.Contact__c = OptyContact[0].Id;
                    }
                }

                else if (opp.StageName == 'Closed Lost') {

                    if (opp.Result__c == 'Bad Data') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostBadData;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }

                    else if (opp.Result__c == 'No Response') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostNoResponse;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }

                    else if (opp.Result__c == 'Declined') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostDeclined;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }

                    else if (opp.Result__c == 'Not Working For Client') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostNotWorkingForClient;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }

                    else if (opp.Result__c == 'Escalate To Client') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostEscalateToClient;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }
                }

                else if (opp.StageName == 'Commit') {

                    if (opp.Current_Calls_Made__c >= 1) {
                        serEmailTemp = stageCommit;
                        opp.Contact__c = OptyContact[0].Id;
                    }
                }
            }

            else if (opp.Type == 'Reactivation') {

                if (opp.StageName == 'Prospect') {

                    if (opp.Current_Calls_Made__c == 1) {
                        serEmailTemp = reactProspect1;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 2) {
                        serEmailTemp = reactProspect2;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 3) {
                        serEmailTemp = reactProspect3;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 4) {
                        serEmailTemp = reactProspect4;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c >= 5) {
                        serEmailTemp = reactProspect5Plus;
                        opp.Contact__c = OptyContact[0].Id;
                    }
                }

                else if (opp.StageName == 'In Progress') {

                    if (opp.Current_Calls_Made__c == 1) {
                        serEmailTemp = reactInProgress1;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 2) {
                        serEmailTemp = reactInProgress2;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 3) {
                        serEmailTemp = reactInProgress3;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c == 4) {
                        serEmailTemp = reactInProgress4;
                        opp.Contact__c = OptyContact[0].Id;
                    }

                    else if (opp.Current_Calls_Made__c >= 5) {
                        serEmailTemp = reactInProgress5Plus;
                        opp.Contact__c = OptyContact[0].Id;
                    }
                }

                else if (opp.StageName == 'Closed Lost') {

                    if (opp.Result__c == 'Bad Data') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostBadData;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }

                    else if (opp.Result__c == 'No Response') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostNoResponse;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }

                    if (opp.Result__c == 'Declined') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostDeclined;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }

                    if (opp.Result__c == 'Not Working For Client') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostNotWorkingForClient;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }

                    if (opp.Result__c == 'Escalate To Client') {

                        if (opp.Current_Calls_Made__c >= 1) {
                            serEmailTemp = closedLostEscalateToClient;
                            opp.Contact__c = OptyContact[0].Id;
                        }
                    }
                }

                else if (opp.StageName == 'Commit') {

                    if (opp.Current_Calls_Made__c >= 1) {
                        serEmailTemp = stageCommit;
                        opp.Contact__c = OptyContact[0].Id;
                    }
                }
            }

            supplier_SER_Opty_LanguageEmailTemplate emailTemplate = new supplier_SER_Opty_LanguageEmailTemplate();
            emailTemplate.SendEmail(opp, serEmailTemp, OptyContact, fromId, attachment);
        }
        return true;
    }
}