/**
* Created by MarkSimpson on 6/9/2020.
* Test for move to Dev environment
*/

@isTest
public with sharing class Supplier_SER_Opty_RoundRobinTest {

    @isTest
    public static void Supplier_SER_Opty_RoundRobin_SetUp() {

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {

            integer languagePriority = 1;

            List<Campaign> serCampaign = new List<Campaign>();
            List<Rep__c> firstPriorityReps = new List<Rep__c>();
            List<Account> rrAccounts = new List<Account>();
            List<Id> userIds = new List<Id>();
            List<Id> CampaignIds = new List<Id>();
            List<Id> accountIds = new List<Id>();
            List<Id> oppAccountIds = new List<Id>();
            List<Opportunity> optyList = new List<Opportunity>();
            List<Id> oppIds = new List<Id>();

            Date closeDate = date.newInstance(2020, 6, 10);

            Datetime campaignDate = Datetime.newInstance(2020, 6, 9);
            List<User> users = QB_TestDataFactory.createUserRecords(8, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');
            //Account account = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);

            for (Integer i = 0; i < 2; i++) {
                Campaign c = new Campaign(
                        Name = 'Test Campaign ' + i,
                        Round_Robin_Status__c = 'GO'
                );

                serCampaign.add(c);
            }

            for(Integer i = 0; i < 1; i++) {
                Campaign c = new Campaign(
                  Name = 'INVALID TEST CAMPAIGN ' + i,
                        Round_Robin_Status__c = 'ON HOLD'
                );

                serCampaign.add(c);
            }

            insert serCampaign;

            for (Campaign campaign : serCampaign) {
                CampaignIds.add(campaign.Id);
            }

            System.debug('CAMPAIGN: ' + serCampaign);

            for (Integer i = 0; i < 3; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        Language_Priority_c__c = languagePriority,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = 'English',
                        Language_2__c = '',
                        Language_3__c = '',
                        SER_Region_Language__c = 'NORAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            for (Integer i = 0; i < 5; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        Language_Priority_c__c = languagePriority,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        Language_1__c = 'English',
                        Language_2__c = '',
                        Language_3__c = '',
                        SER_Region_Language__c = 'NORAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            for (Integer i = 0; i < 2; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        Language_Priority_c__c = languagePriority,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        Language_1__c = 'German',
                        Language_2__c = 'English',
                        Language_3__c = '',
                        SER_Region_Language__c = 'EMEA'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            insert firstPriorityReps;
            System.debug('REPS: ' + firstPriorityReps);

            for (Opportunity optyAccountIds : optyList) {
                oppAccountIds.add(optyAccountIds.AccountId);
            }

            for(integer i = 0; i < 1; i++) {
                Account a = new Account(
                        Name = 'Test Account: ',
                        BillingCountry = 'US'
                );

                System.debug('ACCOUNT: ' + rrAccounts);
                rrAccounts.add(a);
            }

            for(integer i = 0; i < 1; i++) {
                Account a = new Account(
                        Name = 'Test Account: ',
                        BillingCountry = 'UK'
                );

                System.debug('ACCOUNT: ' + rrAccounts);
                rrAccounts.add(a);
            }

            for(integer i = 0; i < 1; i++) {
                Account a = new Account(
                        Name = 'New Test Account',
                        BillingCountry = 'US'
                );
                  rrAccounts.add(a);
            }


            System.debug('RRACCOUNT: ' + rrAccounts);
            insert rrAccounts;

            System.debug('RRACCOUNT2: ' + rrAccounts);
            System.debug('NAME: ' + rrAccounts[0].Name);

            List<Account> accountList = [SELECT Id, Name, CountryLanguage__c, Region__c FROM Account WHERE Id = :rrAccounts[0].Id];
            List<Account> secondAccountList = [SELECT Id, Name, CountryLanguage__c, Region__c FROM Account WHERE Id = :rrAccounts[0].Id];

            System.debug('INSERTED ACCOUNT: ' + accountList);

            for (Account accounts : rrAccounts) {
                accountIds.add(accounts.Id);
            }

            RecordType recordType = new RecordType();
            recordType.Name = 'Supplier';

            for (Integer i = 0; i < 5; i++) {
                Opportunity o = new Opportunity(
                        Name = 'Test Opp: ' + i,
                        StageName = 'Mailed',
                        Type = 'Registration',
                        //RecordType = recordType,
                        //LastModifiedDate = lastActivityDate,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        CampaignId = serCampaign[0].Id,
                        AccountId = accountList[0].Id,
                        CloseDate = closeDate
                );

                System.debug('CURRENT OPP: ' + o);
                optyList.add(o);
            }

            insert optyList;

            for (Opportunity optyAccountIds : optyList) {
                oppAccountIds.add(optyAccountIds.AccountId);
            }

            System.debug('OPPORTUNITY ' + optyList);
            System.debug('OPTY LIST: ' + optyList);

            roundRobinVariable__c rrv = new roundRobinVariable__c();
            rrv.Name = 'SER';
            rrv.roundRobinID__c = 0;
            rrv.OwnerId = thisUser.Id;
            insert rrv;

            System.debug('ROUND ROBIN VARIABLE: ' + rrv);
            System.debug('NAME: ' + rrv.Name);
            System.debug('VARIABLE: ' + rrv.roundRobinID__c);
            System.debug('OWNERID: ' + rrv.OwnerId);

            System.debug(campaignIds);
            System.debug(oppIds);
            System.debug(userIds);
            System.debug(firstPriorityReps);
            System.debug(serCampaign);
            System.debug(optyList);
            System.debug(oppAccountIds);
            System.debug(rrAccounts);
            System.debug(accountIds);

            Supplier_SER_Opty_RoundRobin supplier_ser_opty_roundrobin = new Supplier_SER_Opty_RoundRobin();
            supplier_ser_opty_roundrobin.Supplier_SER_Opty_RoundRobin_Handler(campaignIds, oppIds, userIds, firstPriorityReps, serCampaign, optyList, oppAccountIds, accountList, accountIds);
        }
    }

    @isTest
    public static void Supplier_SER_Opty_RoundRobin_ExecuteTest() {

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {

            SchedulableContext exe;

            Supplier_SER_Opty_RoundRobin supplier_ser_opty_roundrobin = new Supplier_SER_Opty_RoundRobin();
            supplier_ser_opty_roundrobin.execute(exe);
        }
    }
}