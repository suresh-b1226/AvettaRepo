@isTest public class Client_SDR_Mapping_ApexControllerTest {
    
    @isTest static void getStatesTest() {
        Client_SDR_Mapping_ApexController.getStates();
    }
    
    @isTest static void getRegionsTest() {
        Client_SDR_Mapping_ApexController.getRegions();
        Client_SDR_Mapping_ApexController.getNORAMRegions();
        Client_SDR_Mapping_ApexController.getEMEARegions();
        Client_SDR_Mapping_ApexController.getAPACRegions();
        Client_SDR_Mapping_ApexController.getLATAMRegions();


    }
    
    @isTest static void getRepsTest() {
        Client_SDR_Mapping_ApexController.getReps();
        Client_SDR_Mapping_ApexController.getNORAMReps();
        Client_SDR_Mapping_ApexController.getEMEAReps();
        Client_SDR_Mapping_ApexController.getAPACReps();
        Client_SDR_Mapping_ApexController.getLATAMReps();

    }
    @isTest static void getRegionRepsTest() {
        List<String> regionStrings = new List<String>{'West'};
        List<Region__c> region = QB_TestDataFactory.createRegionRecords(1, TRUE, regionStrings);
        Client_SDR_Mapping_ApexController.getRegionReps(region[0].Id);

    }
    
    @isTest static void saveStateTest() {
        List<String> regionStrings = new List<String>{'West'};
            List<Region__c> region = QB_TestDataFactory.createRegionRecords(1, TRUE, regionStrings);
        List<String> abbreviation = new List<String>{'ID'};
            List<String> name = new List<String>{'Idaho'};
                List<State__c> state = QB_TestDataFactory.createSDRStateRecords(1, TRUE, abbreviation, name, region);
        Client_SDR_Mapping_ApexController.saveState(state[0]);
    }
    
    @isTest static void saveRepTest() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        Id profileId = [SELECT Id
						FROM Profile
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        Id userRoleId = [SELECT Id
						FROM UserRole
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        System.runAs ( thisUser ) {
            List<String> regionStrings = new List<String>{'West'};
                List<Region__c> region = QB_TestDataFactory.createRegionRecords(1, TRUE, regionStrings);
            List<User> user = QB_TestDataFactory.createUserRecords(1, TRUE, profileId, userRoleId);
            List<Rep__c> rep = QB_TestDataFactory.createRepRecords(1, TRUE, region, user);
            Client_SDR_Mapping_ApexController.SaveRep(rep[0]);
        }
    }
    
    @isTest static void saveRepDetailsTest() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        Id profileId = [SELECT Id
						FROM Profile
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        Id userRoleId = [SELECT Id
						FROM UserRole
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;
        
        System.runAs ( thisUser ) {
            List<String> regionStrings = new List<String>{'West'};
                List<Region__c> region = QB_TestDataFactory.createRegionRecords(1, TRUE, regionStrings);
            List<User> user = QB_TestDataFactory.createUserRecords(1, TRUE, profileId, userRoleId);
            List<Rep__c> reps = QB_TestDataFactory.createRepRecords(1, TRUE, region, user);
            List<Rep__c> updatedReps = Client_SDR_Mapping_ApexController.SaveRepDetails(reps);
        }
    }
}