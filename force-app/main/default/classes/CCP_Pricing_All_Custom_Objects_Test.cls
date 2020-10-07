@isTest
private class CCP_Pricing_All_Custom_Objects_Test {
    @isTest
    static void testCCP_Pricing_Contractor_Distribution() {
        setupData_EMEA();
        CCP_Pricing_Contractor_Distribution__c[] dists = [
                SELECT C0__c
                FROM CCP_Pricing_Contractor_Distribution__c
        ];

        dists[0].C0__c = 100;
        update dists;
    }

    @isTest
    static void CCP_Pricing_Global_Assumption() {
        setupData_EMEA();
        CCP_Pricing_Global_Assumption__c[] assumps = [
                SELECT Rate__c
                FROM CCP_Pricing_Global_Assumption__c
        ];

        assumps[0].Rate__c = 100;
        assumps[1].Rate__c = 100;
        update assumps;
    }

    @isTest
    static void CCP_Pricing_Price_Group() {
        setupData_EMEA();
        CCP_Pricing_Price_Group__c[] prices = [
                SELECT C1__c
                FROM CCP_Pricing_Price_Group__c
                WHERE Currency__c = 'EUR'
            		AND Product_Risk__c = 'High Risk'
        ];

        prices[0].C1__c = 10000;
        update prices;
    }

    @isTest
    static void CCP_Pricing_Supplier_Conversion_Rate() {
        setupData_EMEA();
        CCP_Pricing_Supplier_Conversion_Rate__c[] rates = [
                SELECT New_Supplier_Percent__c
                FROM CCP_Pricing_Supplier_Conversion_Rate__c
        ];

        rates[0].New_Supplier_Percent__c = 100;
        update rates;
    }

    private static Opportunity setupData_EMEA() {
        // DATA SET UP -------------------------------------------------------------------------------------------------

        // CCP Pricing Global Assumption
        setupAssumptions();

        // CCP Pricing Supplier Conversion Rate
        setupConversionRates_EMEA();

        // CCP Pricing Price Groups
        setupPrices_EMEA();

        // CCP Pricing Contractor Distribution
        setupDistributions_EMEA();

        // Opportunity
        Opportunity[] opps = setupOpp_EMEA();
        // END DATA SET UP ---------------------------------------------------------------------------------------------

        return opps[0];
    }

    // Assumptions Helper Function
    private static void setupAssumptions() {
        List<CCP_Pricing_Global_Assumption__c> rates = new List<CCP_Pricing_Global_Assumption__c>();
        CCP_Pricing_Global_Assumption__c enrichment = new CCP_Pricing_Global_Assumption__c();
        enrichment.Name = 'ENRICHMENT LIST REDUCTION RATE';
        enrichment.Rate__c = 40.0;
        CCP_Pricing_Global_Assumption__c proration = new CCP_Pricing_Global_Assumption__c();
        proration.Name = 'PRORATION ASSUMPTION RATE';
        proration.Rate__c = 50.0;

        rates.add(enrichment);
        rates.add(proration);
        insert rates;
    }


    private static Opportunity[] setupOpp_EMEA() {
        Opportunity opp = new Opportunity();
        opp.Name = 'testOpp_Closed_UnsupportedCountry';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        opp.CloseDate = Date.valueOf('2019-09-19 00:00:00');
        opp.Client_Fee__c = 0.0;
        opp.StageName = 'Closed Won - Mailed';
        opp.Country__c = 'France';
        opp.Region__c = 'EMEA';
        opp.Number_of_Contractors__c = 212.0;
        opp.Type = 'Relaunch';
        opp.CurrencyIsoCode = 'EUR';
        opp.Reason_Won__c = 'abcdefghijklmnopqrstuvwxyz';
        opp.Amount = 36498;
        opp.DocuGUARD__c = true;
        opp.InsureGUARD__c = true;
        opp.AuditGUARD__c = true;
        opp.EmployeeGUARD__c = false;

        // Needed to set Registration_Fee_Rev_New__c
        opp.Registration_Fee_Percent__c = 100;
        opp.Conversion_Rate_Percent__c = 32;
        opp.PICS_Overlap_Percent__c = 40;

        insert opp;

        Opportunity[] opps = [
                SELECT CCP_Amount__c
                FROM Opportunity
                WHERE Name='testOpp_Closed_UnsupportedCountry'
        ];

        return opps;
    }

    private static void setupConversionRates_EMEA() {
        CCP_Pricing_Supplier_Conversion_Rate__c rate = new CCP_Pricing_Supplier_Conversion_Rate__c();
        rate.Name = 'testRate0';
        rate.Opp_Type__c = 'Relaunch';
        rate.Country__c = 'EMEA';
        rate.Country_Code__c = 'EMEA';
        rate.New_Supplier_Percent__c = 98.3985;
        rate.New_Supplier_Conversion_Rate__c = 4.5573;
        rate.Existing_Supplier_Percent__c = 1.6015;
        rate.Existing_Supplier_Conversion_Rate__c = 55.9524;

        insert rate;
    }

    private static void setupPrices_EMEA() {
        List<CCP_Pricing_Price_Group__c> prices = new List<CCP_Pricing_Price_Group__c>();

        CCP_Pricing_Price_Group__c price0 = new CCP_Pricing_Price_Group__c();
        price0.Currency__c = 'EUR';
        price0.C0__c = 123;
        price0.C1__c = 234;
        price0.C2__c = 345;
        price0.C3__c = 456;
        price0.C4__c = 567;
        price0.C5__c = 678;
        price0.New_Supplier__c = 900;
        price0.Product_Risk__c = 'High Risk';
        prices.add(price0);

        CCP_Pricing_Price_Group__c price1 = new CCP_Pricing_Price_Group__c();
        price1.Currency__c = 'EUR';
        price1.C0__c = 123;
        price1.C1__c = 234;
        price1.C2__c = 345;
        price1.C3__c = 456;
        price1.C4__c = 567;
        price1.C5__c = 678;
        price1.New_Supplier__c = 900;
        price1.Product_Risk__c = 'Medium Risk';
        prices.add(price1);

        CCP_Pricing_Price_Group__c price2 = new CCP_Pricing_Price_Group__c();
        price2.Currency__c = 'EUR';
        price2.C0__c = 123;
        price2.C1__c = 234;
        price2.C2__c = 345;
        price2.C3__c = 456;
        price2.C4__c = 567;
        price2.C5__c = 678;
        price2.New_Supplier__c = 900;
        price2.Product_Risk__c = 'SP+SA';
        prices.add(price2);

        CCP_Pricing_Price_Group__c price3 = new CCP_Pricing_Price_Group__c();
        price3.C0__c = 123;
        price3.C1__c = 234;
        price3.C2__c = 345;
        price3.C3__c = 456;
        price3.C4__c = 567;
        price3.C5__c = 678;
        price3.New_Supplier__c = 900;
        price3.Product_Risk__c = 'Profiles';
        price3.Currency__c = 'EUR';
        prices.add(price3);

        CCP_Pricing_Price_Group__c price4 = new CCP_Pricing_Price_Group__c();
        price4.Currency__c = 'EUR';
        price4.C0__c = 123;
        price4.C1__c = 234;
        price4.C2__c = 345;
        price4.C3__c = 456;
        price4.C4__c = 567;
        price4.C5__c = 678;
        price4.New_Supplier__c = 900;
        price4.Product_Risk__c = 'Profiles+';
        prices.add(price4);

        insert prices;
    }

    private static void setupDistributions_EMEA() {
        CCP_Pricing_Contractor_Distribution__c dist = new CCP_Pricing_Contractor_Distribution__c();
        dist.Name = 'a3E0q0000006dYK';
        dist.Country_Code__c = 'EMEA';
        dist.Country_Name__c = 'EMEA';
        dist.C0__c = 2.660836977;
        dist.C1__c = 71.38038726;
        dist.C2__c = 12.22985634;
        dist.C3__c = 6.121174266;
        dist.C4__c = 4.097439101;
        dist.C5__c = 3.510306059;

        insert dist;
    }

}