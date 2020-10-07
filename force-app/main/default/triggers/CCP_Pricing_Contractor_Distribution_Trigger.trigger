/****************************************************************************************
 * © Avetta, LLC                                                                        *
 *                                                                                      *
 * AUTHOR: Jeff DeGraw                                                                  *
 * DATE:   02/26/2020                                                                   *
 *                                                                                      *
 * SUMMARY:                                                                             *
 * Created to handle changes on CCP_Pricing_Contractor_Distribution records             *
 *                                                                                      *
 * METRICS:                                                                             *
 * NEED INFO                                                                            *
 *                                                                                      *
 * SALESFORCE CASE:                                                                     *
 * 01796780                                                                             *
 *                                                                                      *
 * REVISION HISTORY:                                                                    *
 * 02/26/2019 - Jeff DeGraw - Initial version                                           *
 ****************************************************************************************/

/* TODO:
- Write tests for 3 new triggers
 */

trigger CCP_Pricing_Contractor_Distribution_Trigger on CCP_Pricing_Contractor_Distribution__c (after insert, after update) {
//    if (Trigger.isInsert && Trigger.isAfter) {
//        CCP_Pricing_Contractor_Dist_Handler handler = new CCP_Pricing_Contractor_Dist_Handler(Trigger.new);
//        Database.executeBatch(handler);
//    }

    if (Trigger.isUpdate && Trigger.isAfter) {
        CCP_Pricing_Contractor_Dist_Handler handler = new CCP_Pricing_Contractor_Dist_Handler(Trigger.new);
        Database.executeBatch(handler);
    }
}