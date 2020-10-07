/****************************************************************************************
 * © Avetta, LLC                                                                        *
 *                                                                                      *
 * AUTHOR: Jeff DeGraw                                                                  *
 * DATE:   09/12/2019                                                                   *
 *                                                                                      *
 * SUMMARY:                                                                             *
 * This will class simply calls the deactivateOldUsers class from the                   *
 * Communities_User_Deactivator_Batch class. This should be scheduled to run weekly.    *                                                                            *
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

global class Communities_User_Deactivator_Schedulable implements Schedulable {
    
    // It is much easier to test this functionality by making the separate class 
    // Communities_User_Deactivator_Batch and calling the method here.
    global void execute(SchedulableContext ctx) {
        Communities_User_Deactivator_Batch b = new Communities_User_Deactivator_Batch();
        if(!Test.isRunningTest()) {
            Database.executeBatch(b, 100);
        }
    }
}