/****************************************************************************************
* © Avetta, LLC                                                                        *
*                                                                                      *
* AUTHOR: Jeff DeGraw                                                                  *
* DATE:   02/13/2020                                                                   *
*                                                                                      *
* SUMMARY:                                                                             *
* Created to calculate the Total CCP on an opportunity                                 *
*                                                                                      *
* METRICS:                                                                             *
* NEED INFO                                                                            *
*                                                                                      *
* SALESFORCE CASE:                                                                     *
* 01796780                                                                             *
*                                                                                      *
* REVISION HISTORY:                                                                    *
* 02/13/2019 - Jeff DeGraw - Initial version                                           *
****************************************************************************************/

public with sharing class CCP_Pricing_Opportunity_Model {
    private static Boolean firstRun = true;
    
    //Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }
    
    //Method to set recursion variable to false
    public static void setFirstRunFalse() {
        firstRun = false;
        System.debug('setFirstRunFalse run');
    }
    
    private Double ENRICHMENT_LIST_REDUCTION_RATE;
    private Double PRORATION_ASSUMPTION_RATE;
    
    //5.28.2020 - Added by Dallin Wasden as per Case #02371557
    private Double newSupplierConversions { get; set; }
    private Double newSupplierAmount { get; set; }
    private Decimal existingSupplierUpgrades { get; set; }
    private Double existingSupplierAmount { get; set; }
    //
    
    private List<Opportunity> opportunities;
    
    private Map<String, String> countryCodes;
    private Map<String, CCP_Pricing_Supplier_Conversion_Rate__c> conversionRates;
    private Map<String, CCP_Pricing_Price_Group__c> priceGroups;
    private Map<String, CCP_Pricing_Contractor_Distribution__c> contractorDistributions;
    
    // SETUP ----------------------------------------------------------------------------
    public CCP_Pricing_Opportunity_Model(List<Opportunity> opportunities) {
        this.opportunities = opportunities;
        countryCodes = new Map<String, String>();
        conversionRates = new Map<String, CCP_Pricing_Supplier_Conversion_Rate__c>();
        priceGroups = new Map<String, CCP_Pricing_Price_Group__c>();
        contractorDistributions = new Map<String, CCP_Pricing_Contractor_Distribution__c>();
    }
    
    private void setAssumptionRates() {
        List<CCP_Pricing_Global_Assumption__c> assumps = [
            SELECT Rate__c,
            Name
            FROM CCP_Pricing_Global_Assumption__c
        ];
        System.debug(assumps);
        Map<String, Double> rates = new Map<String, Double>();
        for (CCP_Pricing_Global_Assumption__c assump : assumps) {
            rates.put(assump.Name, assump.Rate__c);
        }
        
        this.ENRICHMENT_LIST_REDUCTION_RATE = rates.get('ENRICHMENT LIST REDUCTION RATE');
        this.PRORATION_ASSUMPTION_RATE = rates.get('PRORATION ASSUMPTION RATE');
    }
    
    private void setNewSupplierConversions(double newSupplierConversions) {
        this.newSupplierConversions = newSupplierConversions;
        System.debug(this.newSupplierConversions);
        System.debug(newSupplierConversions);
    }
    
    private void setNewSupplierAmount(double newSupplierAmount) {
        this.newSupplierAmount = newSupplierAmount;
    }
    
    private void setExistingSupplierUpgrades(decimal ExistingSupplierUpgrades) {
        this.ExistingSupplierUpgrades = ExistingSupplierUpgrades;
    }
    
    private void setExistingSupplierAmount(double existingSupplierAmount) {
        this.existingSupplierAmount = existingSupplierAmount;
    }
    
    public void calculateTotalCCPAllOpps () {
        if(isFirstRun()) {
            setFirstRunFalse();
            setupAllData();

            for (Opportunity opp : opportunities) {
                Double amount = calculateTotalCCP(opp);
                opp.Opp_Valuation_Model__c = calculateOppValuationModel(calculateProductRisk(opp));
                opp.Product_Risk__c = calculateProductRisk(opp);
                if (amount != null) {
                    opp.CCP_Amount__c = amount;
                    opp.Forecasted_New_Supplier_Conversions__c = newSupplierConversions;
                    opp.Forecasted_New_Supplier_Amount__c = newSupplierAmount;
                    opp.Forecasted_Existing_Supplier_Upgrades__c = existingSupplierUpgrades;
                    opp.Forecasted_Existing_Supplier_Amount__c = existingSupplierAmount;
                    opp.Total_Opportunity_Value__c = calculateTotalOpportunityValue(opp);
                }
                else {
                    opp.CCP_Amount__c = 0;
                    opp.Forecasted_New_Supplier_Conversions__c = 0;
                    opp.Forecasted_New_Supplier_Amount__c = 0;
                    opp.Forecasted_Existing_Supplier_Upgrades__c = 0;
                    opp.Forecasted_Existing_Supplier_Amount__c = 0;
                    opp.Total_Opportunity_Value__c = calculateTotalOpportunityValue(opp);
                }
                System.debug('Setting opp.CCP_Amount__c amount to ' + amount);
                System.debug('opp.Forecasted_New_Supplier_Conversions__c = ' + opp.Forecasted_New_Supplier_Conversions__c);
            }
        }
    }
    
    private Double calculateTotalCCP(Opportunity opportunity) {
        System.debug('calculateOppValuationModel(calculateProductRisk(opportunity)) = ' + calculateOppValuationModel(calculateProductRisk(opportunity)));
        // Error checking ---------------------------------------------------------------
        if (opportunity.RecordTypeId != Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client')
            .getRecordTypeId()) {
                System.debug('WARNING in CCP_Pricing_Opportunity_Model: Only Client record types are supported.');
                return null;
            }
        
        /*
        else if (calculateProductRisk(opportunity) == 'EG Only' ||
                 calculateProductRisk(opportunity) == 'PROFILES') {
                     System.debug('ERROR in CCP_Pricing_Opportunity_Model: Product Risk types "EG Only" and "PROFILES" are ' +
                                  'not supported!');
                     return null;
                 }
        */
        
        else if (opportunity.Country__c == null ||
                 opportunity.RegionF__c == null ||
                 opportunity.CurrencyIsoCode == null ||
                 opportunity.Type == null ||
                 opportunity.Number_of_Contractors__c == null ||
                 opportunity.IsWon == null ||
                 calculateProductRisk(opportunity) == null ||
                 opportunity.Registration_Fee_Rev_New__c == null ||
                 opportunity.Client_Fee__c == null) {
                     System.debug('ERROR in CCP_Pricing_Opportunity_Model: One or more required opportunity fields are NULL!');
                     return null;
                 }
        
        else if (opportunity.Type != 'Existing Client Launch' &&
                 opportunity.Type != 'New Client Launch' &&
                 opportunity.Type != 'Relaunch' &&
                 opportunity.Flow_Type__c != 'CIA') {
                     System.debug('ERROR in CCP_Pricing_Opportunity_Model: Unsupported opportunity type.');
                     return null;
                 }
        
        else if (opportunity.CCP_Country_Code__c == null) {
            System.debug('ERROR in CCP_Pricing_Opportunity_Model: The opportunity\'s country (' +
                         opportunity.Country__c + ') is not supported!');
            return null;
        }
        
        else if (ENRICHMENT_LIST_REDUCTION_RATE == null ||
                 PRORATION_ASSUMPTION_RATE == null) {
                     System.debug('ERROR in CCP_Pricing_Opportunity_Model: An assumption was null!');
                     return null;
                 }
        
        else if (calculateOppValuationModel(calculateProductRisk(opportunity)) != 'CCP Model') {
            return null;
        }
        // Done error checking ----------------------------------------------------------
        
        else {
            Double answer = calculateProductFees(opportunity);
            //opportunity.Registration_Fee_Rev_New__c +
            //opportunity.Client_Fee__c;
            System.debug('FINAL ANSWER: ' + answer);
            
            return answer;
        }
    }
    
    private void setupAllData() {
        setAllCountryCodes();
        setAllCCPCountryCodes();
        setConversionRates();
        setPriceGroups();
        setContractorDistributions();
        setAssumptionRates();
    }
    
    private void setAllCCPCountryCodes() {
        for (Opportunity opp : opportunities) {
            opp.CCP_Country_Code__c = getCountryCode(opp);
        }
    }
    
    private void setAllCountryCodes() {
        List<String> countriesAndRegions = new List<String>();
        for (Opportunity opp : opportunities) {
            countriesAndRegions.add(opp.Country__c);
            countriesAndRegions.add(opp.RegionF__c);
        }
        
        List<CCP_Pricing_Supplier_Conversion_Rate__c> rates = [
            SELECT Country_Code__c,
            Country__c
            FROM CCP_Pricing_Supplier_Conversion_Rate__c
            WHERE Country__c IN :countriesAndRegions
        ];
        
        System.debug('Rates: ' + rates);
        
        Map<String, String> countryNameToCode = new Map<String, String>();
        for (CCP_Pricing_Supplier_Conversion_Rate__c rate : rates) {
            countryNameToCode.put(rate.Country__c, rate.Country_Code__c);
        }
        
        
        System.debug('Codes: ' + countryNameToCode);
        
        for (Opportunity opp : opportunities) {
            if (countryNameToCode.keySet().contains(opp.Country__c)) {
                countryCodes.put(opp.Country__c, countryNameToCode.get(opp.Country__c));
            }
            else if (countryNameToCode.keySet().contains(opp.RegionF__c)) {
                countryCodes.put(opp.Country__c, countryNameToCode.get(opp.RegionF__c));
            }
            else {
                countryCodes.put(opp.Country__c, null);
            }
        }
        
        for (String key : countryCodes.keySet()) {
            System.debug(key + ': ' + countryCodes.get(key));
        }
    }
    
    private String getCountryCode(Opportunity opportunity) {
        return countryCodes.get(opportunity.Country__c);
    }
    
    private void setConversionRates() {
        List<String> oppTypes = new List<String>();
        List<String> countryCodes = new List<String>();
        for (Opportunity opp : opportunities) {
            if(opp.Flow_Type__c == 'CIA') {
                oppTypes.add(opp.Flow_Type__c);
            } else {
                oppTypes.add(opp.Type);
            }
            countryCodes.add(opp.CCP_Country_Code__c);
        }
        
        List<CCP_Pricing_Supplier_Conversion_Rate__c> rates = [
            SELECT New_Supplier_Percent__c, 
            New_Supplier_Conversion_Rate__c,
            Existing_Supplier_Percent__c,
            Existing_Supplier_Conversion_Rate__c,
            Country_Code__c, 
            Opp_Type__c
            FROM CCP_Pricing_Supplier_Conversion_Rate__c
            WHERE Opp_Type__c IN :oppTypes AND
            Country_Code__c IN :countryCodes
        ];
        
        for (CCP_Pricing_Supplier_Conversion_Rate__c rate : rates) {
            conversionRates.put(rate.Country_Code__c + rate.Opp_Type__c, rate);
        }
        
        System.debug('conversionRates = ' + conversionRates);
    }
    
    private void setPriceGroups() {
        List<String> currencies = new List<String>();
        for (Opportunity opp : opportunities) {
            currencies.add(opp.CurrencyIsoCode);
        }
        
        List<CCP_Pricing_Price_Group__c> prices = [
            SELECT Product_Risk__c,
            Currency__c,
            New_Supplier__c,
            C0__c,
            C1__c,
            C2__c,
            C3__c,
            C4__c,
            C5__c
            FROM CCP_Pricing_Price_Group__c
            WHERE Currency__c IN :currencies
        ];
        
        for (CCP_Pricing_Price_Group__c price : prices) {
            priceGroups.put(price.Currency__c + price.Product_Risk__c, price);
        }
        
        System.debug('PriceGroups: ' + priceGroups);
    }
    
    private void setContractorDistributions() {
        List<String> countryCodesTemp = new List<String>();
        for (Opportunity opp : opportunities) {
            countryCodesTemp.add(opp.CCP_Country_Code__c);
        }
        
        List<CCP_Pricing_Contractor_Distribution__c> dists = [
            SELECT Country_Code__c,
            C0__c,
            C1__c,
            C2__c,
            C3__c,
            C4__c,
            C5__c
            FROM CCP_Pricing_Contractor_Distribution__c
            WHERE Country_Code__c IN :countryCodesTemp
        ];
        
        for (CCP_Pricing_Contractor_Distribution__c dist : dists) {
            contractorDistributions.put(dist.Country_Code__c, dist);
        }
    }
    
    private Double calculateProductFees(Opportunity opportunity) {
        return calculateProductMixTotal(opportunity) + calculateConnectionTotal(opportunity);
    }
    
    // STEP 1 ---------------------------------------------------------------------------
    private Double calculateProductMixTotal(Opportunity opportunity) {
        Double answer = calculateEnrichmentListReduction(opportunity);
        
        System.debug('enrichmentListReduction: ' + answer);
        answer = calculateNewSuppliers(answer, opportunity);
        
        System.debug('newSuppliers: ' + answer);
        answer = calculateConverts(answer, opportunity);
        //5.28.2020 - Added by Dallin Wasden as per Case #02371557
        setNewSupplierConversions(answer);
        
        System.debug('converts: ' + answer);
        answer = calculateConnectionPrice(answer, opportunity);
        
        System.debug('connectionPrice: ' + answer);
        //5.28.2020 - Added by Dallin Wasden as per Case #02371557
        setNewSupplierAmount(answer);
        
        return answer;
    }
    
    private Double calculateEnrichmentListReduction(Opportunity opportunity) {
        Double assumption = ENRICHMENT_LIST_REDUCTION_RATE / 100;
        
        if (opportunity.IsWon || 
            opportunity.StageName == 'Commit' || 
            opportunity.StageName == 'Commercial Discussion and Acceptance' ||
            opportunity.StageName == 'Client Kickoff' ||
            opportunity.StageName == 'Technical Config' ||
            opportunity.StageName == 'UAT & Mailing') {
                assumption = 0.0;
            }
        
        return (1 - assumption) * opportunity.Number_of_Contractors__c;
    }
    
    private Double calculateNewSuppliers(Double enrichmentListReduction, Opportunity opportunity) {
        Double newSuppliers;
        Double pctNewSuppliers;
        
        String optyType = opportunity.Flow_Type__c == 'CIA' ? opportunity.Flow_Type__c : opportunity.Type;
        
        //5.28.2020 - Added by Dallin Wasden as per Case #02371557
        String key = opportunity.CCP_Country_Code__c + optyType;
        CCP_Pricing_Supplier_Conversion_Rate__c rate = conversionRates.get(key);
        
        if(opportunity.Suppliers_in_Network__c == NULL) {
            pctNewSuppliers = rate.New_Supplier_Percent__c / 100;
        } else {
            pctNewSuppliers = 1 - opportunity.Suppliers_in_Network__c / 100;
        }
        
        return enrichmentListReduction * pctNewSuppliers;
    }
    
    private Double calculateConverts(Double newSuppliers, Opportunity opportunity) {
        Double newSupplierConversionRate;
        
        //5.28.2020 - Added by Dallin Wasden as per Case #02371557
        if(opportunity.New_Supplier_Conversion_Rate__c == NULL) {
            String optyType = opportunity.Flow_Type__c == 'CIA' ? opportunity.Flow_Type__c : opportunity.Type;
            
            String key = opportunity.CCP_Country_Code__c + optyType;
            System.debug('key = ' + key);
            CCP_Pricing_Supplier_Conversion_Rate__c rate = conversionRates.get(key);
            newSupplierConversionRate = rate.New_Supplier_Conversion_Rate__c;
        } else {
            newSupplierConversionRate = opportunity.New_Supplier_Conversion_Rate__c;
        }
        
        return newSuppliers * (newSupplierConversionRate / 100);
    }
    
    private Double calculateConnectionPrice(Double converts, Opportunity opportunity) {
        System.debug('productRisk = ' + calculateProductRisk(opportunity));
        CCP_Pricing_Price_Group__c price = priceGroups.get(opportunity.CurrencyIsoCode + calculateProductRisk(opportunity));
        System.debug('Opty = ' + opportunity);
        System.debug('priceGroup = ' + price);
        Double total = price.New_Supplier__c;
        return converts * total;
    }
    
    // STEP 2 ---------------------------------------------------------------------------
    private Double calculateConnectionTotal(Opportunity opportunity) {
        Double answer = calculateEnrichmentListReduction(opportunity);
        System.debug('enrichmentListReduction: ' + answer);
        answer = calculateExistingSuppliers(answer, opportunity);
        System.debug('existingSuppliers: ' + answer);
        answer = calculateUpgrades(answer, opportunity);
        System.debug('upgrades: ' + answer);
        answer = calculateConnectionSubTotals(answer, opportunity);
        System.debug('connectionSubTotals: ' + answer);
        answer = answer * (1 - (PRORATION_ASSUMPTION_RATE / 100));
        System.debug('afterProrationAssumption: ' + answer);
        
        //5.28.2020 - Added by Dallin Wasden as per Case #02371557
        setExistingSupplierAmount(answer);
        return answer;
    }
    
    private Double calculateExistingSuppliers(Double enrichmentListReduction, Opportunity opportunity) {
        Double percentSuppliersExistingInNetwork;
        Double answer;
        
        //5.28.2020 - Added by Dallin Wasden as per Case #02371557
        if(opportunity.Suppliers_in_Network__c == NULL) {
            String optyType = opportunity.Flow_Type__c == 'CIA' ? opportunity.Flow_Type__c : opportunity.Type;
            
            String key = opportunity.CCP_Country_Code__c + optyType;
            CCP_Pricing_Supplier_Conversion_Rate__c rate = conversionRates.get(key);
            percentSuppliersExistingInNetwork = rate.Existing_Supplier_Percent__c;
        } else {
            percentSuppliersExistingInNetwork = opportunity.Suppliers_in_Network__c;
        }
        
        if(opportunity.Suppliers_in_Network__c == NULL) {
            answer = enrichmentListReduction * (percentSuppliersExistingInNetwork / 100);
        } else {
            answer = enrichmentListReduction * (opportunity.Suppliers_in_Network__c / 100);
        }
        
        return answer;
    }
    
    private Double calculateUpgrades(Double existingSuppliers, Opportunity opportunity) {
        Decimal answer;
        String optyType = opportunity.Flow_Type__c == 'CIA' ? opportunity.Flow_Type__c : opportunity.Type;
        
        String key = opportunity.CCP_Country_Code__c + optyType;
        CCP_Pricing_Supplier_Conversion_Rate__c rate = conversionRates.get(key);        
        
        if(opportunity.Existing_Supplier_Conversion_Rate__c == NULL) {
            System.debug('existing_supplier_rate = ' + rate.Existing_Supplier_Conversion_Rate__c / 100);
            answer = existingSuppliers * (rate.Existing_Supplier_Conversion_Rate__c / 100);
        } else {
            System.debug('existingSuppliers = ' + existingSuppliers);
            System.debug('opportunity.Existing_Supplier_Conversion_Rate__c = ' + opportunity.Existing_Supplier_Conversion_Rate__c);
            answer = existingSuppliers * (opportunity.Existing_Supplier_Conversion_Rate__c / 100);
        }
        setExistingSupplierUpgrades(answer);
        return answer;
    }
    
    private Double calculateConnectionSubTotals(Double upgrades, Opportunity opportunity) {
        Double total = 0.0;
        CCP_Pricing_Contractor_Distribution__c dist = contractorDistributions.get(opportunity.CCP_Country_Code__c);
        
        total += calculateConnectionSubTotal(upgrades, 'C0', dist, opportunity);
        total += calculateConnectionSubTotal(upgrades, 'C1', dist, opportunity);
        total += calculateConnectionSubTotal(upgrades, 'C2', dist, opportunity);
        total += calculateConnectionSubTotal(upgrades, 'C3', dist, opportunity);
        total += calculateConnectionSubTotal(upgrades, 'C4', dist, opportunity);
        total += calculateConnectionSubTotal(upgrades, 'C5', dist, opportunity);
        
        return total;
    }
    
    private Double calculateConnectionSubTotal(Double upgrades, String connectionTier,
                                               CCP_Pricing_Contractor_Distribution__c contractorDistribution, Opportunity opportunity) {
                                                   switch on connectionTier {
                                                       when 'C0' {
                                                           Double numConnections = upgrades * (contractorDistribution.C0__c / 100);
                                                           return calculatePriceTier(numConnections, connectionTier, opportunity);
                                                       }
                                                       when 'C1' {
                                                           Double numConnections = upgrades * (contractorDistribution.C1__c / 100);
                                                           return calculatePriceTier(numConnections, connectionTier, opportunity);
                                                       }
                                                       when 'C2' {
                                                           Double numConnections = upgrades * (contractorDistribution.C2__c / 100);
                                                           return calculatePriceTier(numConnections, connectionTier, opportunity);
                                                       }
                                                       when 'C3' {
                                                           Double numConnections = upgrades * (contractorDistribution.C3__c / 100);
                                                           return calculatePriceTier(numConnections, connectionTier, opportunity);
                                                       }
                                                       when 'C4' {
                                                           Double numConnections = upgrades * (contractorDistribution.C4__c / 100);
                                                           return calculatePriceTier(numConnections, connectionTier, opportunity);
                                                       }
                                                       when 'C5' {
                                                           Double numConnections = upgrades * (contractorDistribution.C5__c / 100);
                                                           return calculatePriceTier(numConnections, connectionTier, opportunity);
                                                       }
                                                       // This should never happen, but needed to compile
                                                       when else {
                                                           return 0.0;
                                                       }
                                                   }
                                               }
    
    private Double calculatePriceTier(Double numConnections, String connectionTier, Opportunity opportunity) {
        //String productRisk = determineProductRisk(opportunity);
        
        String key = opportunity.CurrencyIsoCode + calculateProductRisk(opportunity);
        CCP_Pricing_Price_Group__c priceGroup = priceGroups.get(key);
        
        // Incremental level corresponds to product risk
        Double price;
        if(connectionTier == 'C0') {
            price = priceGroup.C0__c;
        } else if(connectionTier == 'C1') {
            price = priceGroup.C1__c;
        } else if(connectionTier == 'C2') {
            price = priceGroup.C2__c;
        } else if(connectionTier == 'C3') {
            price = priceGroup.C3__c;
        } else if(connectionTier == 'C4') {
            price = priceGroup.C4__c;
        } else if(connectionTier == 'C5') {
            price = priceGroup.C5__c;
        } else {
            price = 0;
        }
        
        
        return numConnections * price;
    }
    
    private String calculateProductRisk(Opportunity opty) {
        if(opty.Flow_Type__c == 'Flow Registration') {
            return 'Flow Registration';
        } else if(opty.DocuGUARD__c == TRUE && opty.InsureGUARD__c == TRUE && opty.AuditGUARD__c == TRUE && 
                  opty.Profiles_Profiles_Plus__c == FALSE && opty.ProfilePlus__c == FALSE) {
                      return 'High Risk';
                  } else if(opty.DocuGUARD__c == TRUE && opty.InsureGUARD__c == TRUE && opty.AuditGUARD__c == FALSE && 
                            opty.Profiles_Profiles_Plus__c == FALSE && opty.ProfilePlus__c == FALSE) {
                                return 'Medium Risk';
                            } else if(opty.DocuGUARD__c == FALSE && opty.InsureGUARD__c == FALSE && opty.AuditGUARD__c == FALSE && 
                                      opty.Profiles_Profiles_Plus__c == TRUE && opty.ProfilePlus__c == FALSE) {
                                          return 'Profiles';
                                      } else if(opty.DocuGUARD__c == FALSE && opty.InsureGUARD__c == FALSE && opty.AuditGUARD__c == FALSE && 
                                                opty.Profiles_Profiles_Plus__c == FALSE && opty.ProfilePlus__c == TRUE) {
                                                    return 'Profiles+';
                                                } else if(opty.DocuGUARD__c == TRUE && opty.InsureGUARD__c == FALSE && opty.AuditGUARD__c == TRUE && 
                                                          opty.Profiles_Profiles_Plus__c == FALSE && opty.ProfilePlus__c == FALSE) {
                                                              return 'SP+SA';
                                                          } else if(opty.DocuGUARD__c == FALSE && opty.InsureGUARD__c == FALSE && opty.AuditGUARD__c == FALSE && opty.EmployeeGUARD__c == TRUE && 
                                                                    opty.Profiles_Profiles_Plus__c == FALSE && opty.ProfilePlus__c == FALSE) {
                                                                        return 'Worker Mgt';
                                                                    } else {
                                                                        return 'Unknown Products';
                                                                    }
    }
    
    private String calculateOppValuationModel(String productRisk) {
        if(productRisk == 'Flow Registration') {
            return 'Flow Registration';
        } else if(productRisk == 'Worker Mgt') {
            return 'Worker Mgt Model';
        } else {
            return 'CCP Model';
        }
    }
    
    private Double calculateTotalOpportunityValue(Opportunity opp) {
        Double totalOpportunityValue = 0;

        if(opp.Flow_Type__c == 'Flow Registration') {
            return opp.Flow_Value__c;
        } else {
            totalOpportunityValue = opp.CCP_Amount__c == NULL ? totalOpportunityValue : totalOpportunityValue + opp.CCP_Amount__c;
            totalOpportunityValue = calculateRegistrationFeeAmount(opp) == NULL ? totalOpportunityValue : totalOpportunityValue + calculateRegistrationFeeAmount(opp);
            totalOpportunityValue = opp.Client_Fee__c == NULL ? totalOpportunityValue : totalOpportunityValue + opp.Client_Fee__c;
            totalOpportunityValue = opp.ImplementationFees__c == NULL ? totalOpportunityValue : totalOpportunityValue + opp.ImplementationFees__c;
            totalOpportunityValue = opp.Worker_Management_Amount__c == NULL ? totalOpportunityValue : totalOpportunityValue + opp.Worker_Management_Amount__c;
            totalOpportunityValue = opp.Experian_Amount__c == NULL ? totalOpportunityValue : totalOpportunityValue + opp.Experian_Amount__c;

            return totalOpportunityValue;
        }
    }

    private Double calculateRegistrationFeeAmount(Opportunity opp) {
        if(opp.Opp_Valuation_Model__c == 'CCP Model' ) {
           opp.Registration_Fee_Amount__c = opp.Forecasted_New_Supplier_Conversions__c * opp.Registration_Fee_Paid_Unit_Price__c;

        } else {
            opp.Registration_Fee_Amount__c = null;
        }
        return opp.Registration_Fee_Amount__c;
    }

}