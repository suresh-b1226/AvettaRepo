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

global class CCP_Pricing_Contractor_Dist_Handler implements Database.Batchable<SObject>, Database.Stateful {

    private List<CCP_Pricing_Contractor_Distribution__c> records;

    public CCP_Pricing_Contractor_Dist_Handler(List<CCP_Pricing_Contractor_Distribution__c> records) {
        this.records = records;
    }

    public Iterable<SObject> start(Database.BatchableContext param1) {
        return (Iterable<SObject>) records;
    }

    public void execute(Database.BatchableContext param1, List<CCP_Pricing_Contractor_Distribution__c> records) {
        System.debug(' ** Enter CCP_Pricing_Contractor_Dist_Handler');
        List<String> countryNames = new List<String>();
        for (CCP_Pricing_Contractor_Distribution__c dist : records) {
            countryNames.add(dist.Country_Name__c);
        }

        recalculateOpps(countryNames);
    }

    public void finish(Database.BatchableContext param1) {
    }

    private void recalculateOpps(List<String> countryNames) {
        Id clientId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client').getRecordTypeId();

        List<Opportunity> opps = [
                SELECT Amount,
                        Country__c,
                        RegionF__c,
                        CurrencyIsoCode,
                        Type,
                        Number_of_Contractors__c,
                        IsWon,
                        Product_Risk__c,
                        Registration_Fee_Rev_New__c,
                        Client_Fee__c,
                        RecordTypeId
                FROM Opportunity
                WHERE RecordTypeId=:(clientId) AND
                    Product_Risk__c!='EG Only' AND
                    Product_Risk__c!='PROFILES' AND
                    Country__c IN :countryNames /*AND
                    IsClosed=FALSE*/
        ];
        CCP_Pricing_Opportunity_Model model = new CCP_Pricing_Opportunity_Model(opps);
        model.calculateTotalCCPAllOpps();
        
        upsert opps;
    }
}