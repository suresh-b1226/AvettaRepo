@IsTest public class Client_SDR_Lead_RoundRobin_Test {
	
    @IsTest static void Client_SDR_Lead_RoundRobin() {
        User thisUser = [ SELECT Id FROM User WHERE Id = :UserInfo.getUserId() ];
		
        System.runAs ( thisUser ) {

		Id profileId = [SELECT Id
						FROM Profile
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;

        Id userRoleId = [SELECT Id
						FROM UserRole
                        WHERE Name = 'SDR'
                       	LIMIT 1][0].Id;


        List<User> userRecords = QB_TestDataFactory.createUserRecords(7, true, profileId, userRoleId);

        System.debug('User Records = ' + userRecords);
            
            User marketingUser = [
                SELECT Name, Id, IsActive, CreatedDate
                FROM User
                WHERE Name = 'Marketing User'
        ];
            
        System.debug('marketingUser = ' + marketingUser);


        Group marketingGroup = [
                SELECT Name, Id
                FROM Group
                WHERE Name = 'Marketing Leads'
        ];
        System.debug('marketingGroup = ' + marketingGroup);
            
        SDR_Settings__c setting = new SDR_Settings__c();
		setting.Name = 'SDR_Lead_Default_Owner_ID__c';
        setting.SDR_Lead_Default_Owner_ID__c = '\'Marketing User OR Marketing Leads\'';

		insert setting;
        System.debug('CUSTOM SETTING = ' + setting);
            
        userRecords.remove(0);

        System.debug('setting.SDR_Lead_Default_Owner_ID__c = ' + setting.SDR_Lead_Default_Owner_ID__c);

        List<String> regionNames = new List<String>{'West', 'Midwest', 'East', 'South Gulf'};
        List<Region__c> regionRecords = QB_TestDataFactory.createRegionRecords(4, true, regionNames);
        System.debug('regionRecords = ' + regionRecords);
        
        List<String> abbreviationList = new List<String>{'WA', 'KA', 'NY', 'FL'};
        List<String> stateNameList = new List<String>{'Washington', 'Kansas', 'New York', 'Florida'};
        List<State__c> stateRecords = QB_TestDataFactory.createSDRStateRecords(4, true, abbreviationList, stateNameList, regionRecords);
        System.debug('stateRecords = ' + stateRecords);
        
        List<Rep__c> repRecords = QB_TestDataFactory.createRepRecords(6, true, regionRecords, userRecords);
        System.debug('repRecords = ' + repRecords);
        
        List<String> leadStateList   = new List<String>{'Washington', 'WA', 'Florida', 'NY', 'KA'};
        List<String> leadHQCountry   = new List<String>{'United States', 'United States', 'United States', 'United States', 'United States' };
        List<String> countryCodeList = new List<String>{'US', 'US', 'AU', 'FR','US'};
        List<String> countryList     = new List<String>{'US', 'US', 'Australia', 'France', 'US' };

        List<String> NORAM_countryList     = new List<String>{'US', 'US', 'United States', 'United States', 'US' };
        List<String> NORAM_countryCodeList = new List<String>{'US', 'US', 'US', 'US', 'US' };

        List<String> APAC_countryList     = new List<String>{'Germany', 'France', 'Italy', 'Belgium'};
        List<String> APAC_countryCodeList = new List<String>{'DE', 'FR', 'IT', 'BE'};
        List<String> APAC_leadHQCountry   = new List<String>{'Germany', 'France', 'Italy', 'United States' };


        List<Lead> leadRecords = QB_TestDataFactory.createLeads(5, true, leadStateList , leadHQCountry, marketingUser.Id, countryList, countryCodeList );
        List<Lead> NORAM_LeadRecords = QB_TestDataFactory.createNoramLeads(5, true, leadStateList , leadHQCountry, marketingUser.Id, NORAM_countryList, NORAM_countryCodeList );
        //List<Lead> APAC_LeadRecords = QB_TestDataFactory.createAPACLeads(4, true, APAC_leadHQCountry, marketingUser.Id, APAC_countryList, APAC_countryCodeList );
            
        System.debug('leadRecords = ' + leadRecords);

        System.debug(leadRecords[0].State);
        System.debug(leadRecords[0].Country);
        System.debug(leadRecords[0].Company_HQ_Country__c);
        System.debug(leadRecords[0].Country_Code__c);
        System.debug(leadRecords[0].Region__c);
        System.debug(leadRecords[0].OwnerId);
        System.debug(repRecords[0].User__c);
        System.debug(repRecords[0].Region__c);
          
            
        //System.assert(leadRecords[0].OwnerId == repRecords[0].User__c || leadRecords[0].OwnerId == repRecords[4].User__c);
            
        }
        
    }
    
}