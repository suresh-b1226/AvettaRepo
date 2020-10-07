//Server-side controller class for the SDR Mapping lightning components
public class Client_SDR_Mapping_ApexController {
    
     //populates the states on the SDR Mapping lightning component
    @AuraEnabled
    public static List<State__c> getStates() {
        return [SELECT Id, Name, Region__c FROM State__c];

    }

    //populates the regions on the SDR Mapping lightning component
    @AuraEnabled
    public static List<Region__c> getRegions() {
        return [SELECT Id, Name FROM Region__c ORDER BY Name ASC];
    }

    @AuraEnabled
    public static List<Region__c> getNORAMRegions() {
        return [SELECT Id, Name FROM Region__c WHERE Global_Region__c = 'NORAM' ORDER BY Name ASC];
    }

    @AuraEnabled
    public static List<Region__c> getEMEARegions() {
        return [SELECT Id, Name FROM Region__c WHERE Global_Region__c = 'EMEA' ORDER BY Name ASC];
    }

    @AuraEnabled
    public static List<Region__c> getAPACRegions() {
        return [SELECT Id, Name FROM Region__c WHERE Global_Region__c = 'APAC'  ORDER BY Name ASC];
    }

    @AuraEnabled
    public static List<Region__c> getLATAMRegions() {
        return [SELECT Id, Name FROM Region__c WHERE Global_Region__c = 'LATAM' ORDER BY Name ASC];
    }


     //populates the reps on the SDR Mapping lightning component
    @AuraEnabled
    public static List<Rep__c> getReps() {

        return [SELECT Id, Rep_Name__c, Name, Region__c, Out_Of_Office__c, Distribution_Weight__c, Region_Name__c, Region__r.Name FROM Rep__c WHERE RecordType.Name = 'SDR' ORDER BY Region__r.Name ASC];
    }

     @AuraEnabled
     public static List<Rep__c> getNORAMReps() {
         List<Region__c> NORAM_Reps = [
                 SELECT Id, Name, global_Region__c
                 FROM Region__c
                 WHERE global_Region__c = 'NORAM'
         ];
        return [SELECT Id, Rep_Name__c, Name, Region__c, Out_Of_Office__c, Distribution_Weight__c, Region_Name__c, Region__r.Name FROM Rep__c WHERE RecordType.Name = 'SDR' AND Region__c =: NORAM_Reps ORDER BY Region__r.Name ASC];
     }

    @AuraEnabled
    public static List<Rep__c> getEMEAReps() {
        List<Region__c> EMEA_Reps = [
                SELECT Id, Name, global_Region__c
                FROM Region__c
                WHERE global_Region__c = 'EMEA'
        ];
        return [SELECT Id, Rep_Name__c, Name, Region__c, Out_Of_Office__c, Distribution_Weight__c, Region_Name__c, Region__r.Name FROM Rep__c WHERE RecordType.Name = 'SDR' AND Region__c =: EMEA_Reps ORDER BY Region__r.Name ASC];
    }

    @AuraEnabled
    public static List<Rep__c> getAPACReps() {
        List<Region__c> APAC_Reps = [
                SELECT Id, Name, global_Region__c
                FROM Region__c
                WHERE global_Region__c = 'APAC'
        ];
        return [SELECT Id, Rep_Name__c, Name, Region__c, Out_Of_Office__c, Distribution_Weight__c, Region_Name__c, Region__r.Name FROM Rep__c WHERE RecordType.Name = 'SDR' AND Region__c =: APAC_Reps ORDER BY Region__r.Name ASC];
    }

    @AuraEnabled
    public static List<Rep__c> getLATAMReps() {
        List<Region__c> LATAM_Reps = [
                SELECT Id, Name, global_Region__c
                FROM Region__c
                WHERE global_Region__c = 'LATAM'
        ];
        return [SELECT Id, Rep_Name__c, Name, Region__c, Out_Of_Office__c, Distribution_Weight__c, Region_Name__c, Region__r.Name FROM Rep__c WHERE RecordType.Name = 'SDR' AND Region__c =: LATAM_Reps ORDER BY Region__r.Name ASC];
    }
    //Updates a state's region when it is changed via the SDR Mapping lightning component
    @AuraEnabled
    public static void saveState(State__c state){
        update state;

    }

    //Updates a rep when the region is changed via the SDR Mapping lightning component
    @AuraEnabled
    public static void saveRep(Rep__c rep){
        update rep;

    }

    //Updates the 'Out of Office' field for a rep when changed via the SDR Mapping lightning component
    @AuraEnabled
    public static List<Rep__c> saveRepDetails(List<Rep__c> reps){
        upsert reps;
        return reps;
    }

    //Delete an SDR Region on click of a button in SDR Mapping Lightning component
    @AuraEnabled
    public static void deleteRegion(Region__c region){
        delete region;
    }

    @AuraEnabled
    public static List<Rep__c> getRegionReps(Id region){
        return [SELECT Id FROM Rep__c WHERE Region__c =: region];
    }

}