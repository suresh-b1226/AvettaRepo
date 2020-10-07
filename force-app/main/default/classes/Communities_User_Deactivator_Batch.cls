/****************************************************************************************
 * © Avetta, LLC                                                                        *
 *                                                                                      *
 * AUTHOR: Jeff DeGraw                                                                  *
 * DATE:   09/12/2019                                                                   *
 *                                                                                      *
 * SUMMARY:                                                                             *
 * Every week, inactive Avetta Help Center users need to be deactivated. This process   *
 * hass been handled manually by the Salesforce Admins. This class automates that       *
 * process.                                                                             *
 *                                                                                      *
 * METRICS:                                                                             *
 * This will save the Salesforce Admins ~30 minutes per week.                           *
 *                                                                                      *
 * SALESFORCE CASE:                                                                     *
 * 01285024                                                                             *
 *                                                                                      *
 * REVISION HISTORY:                                                                    *
 * 09/12/2019 - Jeff DeGraw - Initial version                                           *
 ****************************************************************************************/

global class Communities_User_Deactivator_Batch implements Database.Batchable<sObject> {

    // This SOQL query will grab all of the inactive help center users and deactivate them.
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT IsActive ' +
                       'FROM User ' +
                       'WHERE (IsActive=true ' +
                           'AND Account.Status__c!=\'Active\'' +
                           'AND Account.Status__c!=\'Pending\'' +
                           'AND UserType=\'CSPLitePortal\'' +
                           ')';
        return Database.getQueryLocator(query);
    }
    
    // It is not desireable to delete the user, as they may become active again.
    // Instead, just set IsActive to false.
    global void execute(Database.BatchableContext BC, List<User> usersToDeactivate) {    
        for (User user : usersToDeactivate) {
            user.IsActive=false;
        }

        try {
            update usersToDeactivate;
        } 
        
        catch(Exception e) {
            System.debug(e);
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    	// execute any post-processing operations
    }
}