/**
 * Created by brett on 4/12/18.
 */

public with sharing class API_CONNECT_ContractorMatchController {

    public class DTOoptions {
        public Integer page;
        public Integer pageSize;
        public String orderBy;

        public Integer getOffset() {
            return this.page * this.pageSize;
        }
    }

    @AuraEnabled
    public static Integer getContractorMatchesCount() {

        Integer results = [
                SELECT COUNT()
                FROM Contractor_Match__c
        ];

        return results;

    }

    @AuraEnabled
    public static Map<String, String> getAccountTypesMap() {


        String contractor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        string operator = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();

        Map<String, String> results = new Map<String, String>();
        results.put(contractor, 'Contractor');
        results.put(operator, 'Operator');

        return results;

    }

    @AuraEnabled
    public static Contractor_Match__c[] getContractorMatches(String dto) {

        System.debug(dto);

        API_CONNECT_ContractorMatchController.DTOoptions options = (API_CONNECT_ContractorMatchController.DTOoptions) JSON.deserialize(dto, API_CONNECT_ContractorMatchController.DTOoptions.class);


        System.debug(options);
        String query = 'SELECT Id, Name, City__c, Phone_Number__c, webUrl__c, Account__r.Name, Account__c, accountRecordType__c, Match_Type__c, accountRecordTypeId__c, email__c, street__c, address_line_2__c, country__c, postalCode__c, state__c, firstName__c, lastName__c  FROM Contractor_Match__c ORDER BY ' + options.orderBy + ' LIMIT ' + options.pageSize + ' OFFSET ' + options.getOffset();

        System.debug(query);

        Contractor_Match__c[] results = Database.query(query);
        System.debug(results);

        return results;

    }


    @AuraEnabled
    public static Account[] accountSearch(String searchText) {

        String searchsString = '%' + searchText + '%';

        Account[] results = [
                SELECT
                        Name,
                        Id,
                        RecordTypeId,
                        Status__c,
                        IsBillable__c,
                        Billable_Entity__c,
                        BillingCity,
                        BillingCountry,
                        DBA_Name__c,
                        Fax,
                        Global_Parent__c,
                        Organizer_ID__c,
                        Paying_Facilities__c,
                        Phone,
                        BillingPostalCode,
                        Preferred_Language__c,
                        Registration_Date__c,
                        BillingState,
                        BillingAddress,
                        SUID__c,
                        Tax_ID__c,
                        Primary_Contact_Email__c
                FROM
                        Account
                WHERE Organizer_ID__c LIKE :searchsString
                OR Name LIKE :searchsString
                OR Primary_Contact_Email__c LIKE :searchsString
                ORDER BY Name ASC
                LIMIT 100
        ];

        System.debug(results);
        return results;

    }


    @AuraEnabled
    public static Contact[] contactSearch(String searchText) {

        String searchsString = '%' + searchText + '%';

        Contact[] results = [
                SELECT
                        Name,
                        Id,
                        Email
                FROM
                        Contact
                WHERE Email LIKE :searchsString
                OR Name LIKE :searchsString
                LIMIT 100
        ];

        System.debug(results);
        return results;

    }

    @AuraEnabled
    public static Account accountFetch(String searchId) {


        Account results = [
                SELECT
                        Name,
                        Id,
                        RecordTypeId,
                        Status__c,
                        IsBillable__c,
                        Billable_Entity__c,
                        BillingCity,
                        BillingCountry,
                        DBA_Name__c,
                        Fax,
                        Global_Parent__c,
                        Organizer_ID__c,
                        Paying_Facilities__c,
                        Phone,
                        BillingPostalCode,
                        Preferred_Language__c,
                        Registration_Date__c,
                        BillingState,
                        BillingAddress,
                        SUID__c,
                        Tax_ID__c,
                        Primary_Contact_Email__c,
                        Website
                FROM Account
                WHERE Id = :searchId
        ];

        System.debug(results);
        return results;

    }

    @AuraEnabled
    public static Contractor_Match__c clearAccountMatch(String matchId) {

        Contractor_Match__c match = new Contractor_Match__c(Id = matchId, Account__c = null);

        update match;

        return match;


    }

    @AuraEnabled
    public static Contractor_Match__c saveAccountMatch(String matchId, String accountId) {

        Contractor_Match__c match = new Contractor_Match__c(Id = matchId, Account__c = accountId);

        update match;

        return match;
    }

    @AuraEnabled
    public static Contact contactFetch(String searchId) {


        Contact results = [
                SELECT
                        Name,
                        Id,
                        Phone,
                        Email

                FROM Contact
                WHERE Id = :searchId
        ];

        System.debug(results);
        return results;

    }

    @AuraEnabled
    public static Contractor_Match__c clearContactMatch(String matchId) {

        Contractor_Match__c match = new Contractor_Match__c(Id = matchId, Contact__c = null);

        update match;

        return match;


    }

    @AuraEnabled
    public static Contractor_Match__c saveContactMatch(String matchId, String contactId) {

        Contractor_Match__c match = new Contractor_Match__c(Id = matchId, Contact__c = contactId);

        update match;

        return match;
    }

    @AuraEnabled
    public static void approveMatch(String matchId, String accountId) {


        Contractor_Match__c match = API_CONNECT_Helpers.getContractorMatch(matchId);

        Account account = [
                SELECT
                        Id,
                        Organizer_ID__c
                FROM
                        Account
                WHERE
                        Id = :accountId
        ];

        try {
            API_CONNECT_Helpers.updateAccount(account, match);

            delete match;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }
    }

    @AuraEnabled
    public static void deleteMatch(String matchId) {


        Contractor_Match__c match = API_CONNECT_Helpers.getContractorMatch(matchId);

        try {
            delete match;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }
    }

    @AuraEnabled
    public static void createAccountFromMatch(String matchId) {

        Contractor_Match__c match = API_CONNECT_Helpers.getContractorMatch(matchId);

        try {
            match.Account__c = API_CONNECT_Helpers.insertContractorAccount(match).Id;
            API_CONNECT_Helpers.insertContractorContact(match);

            delete match;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }
    }

    @AuraEnabled
    public static void createOpportunityFromMatch(String matchId) {

        Contractor_Match__c match = API_CONNECT_Helpers.getContractorMatch(matchId);

        try {

            if (match.Account__c == null) {
                match.Account__c = API_CONNECT_Helpers.insertContractorAccount(match).Id;
            }

            if (match.Contact__c == null) {
                match.Contact__c = API_CONNECT_Helpers.insertContractorContact(match).Id;
            }

            API_CONNECT_Helpers.insertOpportunityFromMatch(match);

            delete match;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }
    }


}