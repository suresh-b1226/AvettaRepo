/****************************************************************************************
 * © Avetta, LLC                                                                        *
 *                                                                                      *
 * AUTHOR: Jeff DeGraw                                                                  *
 * DATE:   02/27/2020                                                                   *
 *                                                                                      *
 * SUMMARY:                                                                             *
 * Created to handle changes on CCP_Pricing_Global_Assumption records                   *
 *                                                                                      *
 * METRICS:                                                                             *
 * NEED INFO                                                                            *
 *                                                                                      *
 * SALESFORCE CASE:                                                                     *
 * 01796780                                                                             *
 *                                                                                      *
 * REVISION HISTORY:                                                                    *
 * 02/27/2019 - Jeff DeGraw - Initial version                                           *
 ****************************************************************************************/

trigger CCP_Pricing_Global_Assumption_Trigger on CCP_Pricing_Global_Assumption__c (after insert, after update) {
//    if (Trigger.isInsert && Trigger.isAfter) {
//        CCP_Pricing_Global_Assumption_Handler handler = new CCP_Pricing_Global_Assumption_Handler(Trigger.new);
//        Database.executeBatch(handler);
//    }

    if (Trigger.isUpdate && Trigger.isAfter) {
        CCP_Pricing_Global_Assumption_Handler handler = new CCP_Pricing_Global_Assumption_Handler(Trigger.new);
        Database.executeBatch(handler);
    }
}