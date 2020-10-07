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

global class CCP_Pricing_Global_Assumption_Handler implements Database.Batchable<SObject>, Database.Stateful {

    private List<CCP_Pricing_Global_Assumption__c> records;

    public CCP_Pricing_Global_Assumption_Handler(List<CCP_Pricing_Global_Assumption__c> records) {
        this.records = records;
    }

    public Iterable<SObject> start(Database.BatchableContext param1) {
        return (Iterable<SObject>) records;
    }

    public void execute(Database.BatchableContext param1, List<CCP_Pricing_Global_Assumption__c> records) {
        // FIXME: I think this it's okay to this stuff in a loop, because there are only 2 global assumptions

        System.debug(' ** Enter CCP_Pricing_Global_Assumption');

        for (CCP_Pricing_Global_Assumption__c rate : records) {
            if (rate.Name == 'ENRICHMENT LIST REDUCTION RATE') {
                System.debug('Running enrichment');
                recalculateOppsEnrichment();
            }

            else if (rate.Name == 'PRORATION ASSUMPTION RATE') {
                System.debug('Running proration');
                recalculateOppsProration();
            }
        }
    }

    public void finish(Database.BatchableContext param1) {
    }

    private void recalculateOppsProration() {
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
                Product_Risk__c!='PROFILES' /*AND
                IsClosed=FALSE*/
        ];
        CCP_Pricing_Opportunity_Model model = new CCP_Pricing_Opportunity_Model(opps);
        model.calculateTotalCCPAllOpps();
        upsert opps;
    }

    private void recalculateOppsEnrichment() {
        Id clientId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client').getRecordTypeId();

        List<Opportunity> opps = [
                SELECT Amount,
                        Country__c,
                        Region__c,
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
                /*IsClosed=FALSE AND*/
                IsWon=FALSE
        ];
        CCP_Pricing_Opportunity_Model model = new CCP_Pricing_Opportunity_Model(opps);
        model.calculateTotalCCPAllOpps();
        upsert opps;
    }

}