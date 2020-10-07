/****************************************************************************************
 * © Avetta, LLC                                                                        *
 *                                                                                      *
 * AUTHOR: Jeff DeGraw                                                                  *
 * DATE:   02/26/2020                                                                   *
 *                                                                                      *
 * SUMMARY:                                                                             *
 * Created to handle changes on CCP_Pricing_Price_Group_Trigger records                 *
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

trigger CCP_Pricing_Price_Group_Trigger on CCP_Pricing_Price_Group__c (after insert, after update) {
//    if (Trigger.isInsert && Trigger.isAfter) {
//        CCP_Pricing_Price_Group_Handler handler = new CCP_Pricing_Price_Group_Handler(Trigger.new);
//        Database.executeBatch(handler);
//    }

    if (Trigger.isUpdate && Trigger.isAfter) {
        CCP_Pricing_Price_Group_Handler handler = new CCP_Pricing_Price_Group_Handler(Trigger.new);
        Database.executeBatch(handler);
    }
}