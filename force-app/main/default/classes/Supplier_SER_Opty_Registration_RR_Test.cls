/**
 * Created by MarkSimpson on 8/25/2020..
 */

@isTest
public with sharing class Supplier_SER_Opty_Registration_RR_Test {

    @isTest
    public static void Supplier_SER_Opty_RR_Test_Setup() {

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {

            List<Rep__c> firstPriorityReps = new List<Rep__c>();
            List<Account> rrAccounts = new List<Account>();
            List<Id> userIds = new List<Id>();
            List<Id> accountIds = new List<Id>();
            List<Id> oppAccountIds = new List<Id>();
            List<Id> oppIds = new List<Id>();
            List<Opportunity> optyList = new List<Opportunity>();

            List<User> users = QB_TestDataFactory.createUserRecords(8, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
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

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = 'Spanish',
                        Language_2__c = '',
                        Language_3__c = '',
                        SER_Region_Language__c = 'LATAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            insert firstPriorityReps;
            System.debug('REPS: ' + firstPriorityReps);

            for (integer i = 0; i < 3; i++) {
                Account a = new Account(
                        Name = 'Test Account: ',
                        BillingCountry = 'US'
                );

                System.debug('ACCOUNT: ' + rrAccounts);
                rrAccounts.add(a);
            }

            System.debug('RRACCOUNT: ' + rrAccounts);
            insert rrAccounts;

            List<Account> accountList = [SELECT Id, Name, CountryLanguage__c, Region__c FROM Account WHERE Id = :rrAccounts[0].Id];

            for (Account accounts : rrAccounts) {
                accountIds.add(accounts.Id);
            }

            Opportunity o = new Opportunity(
                    Name = 'Test Opp: ',
                    StageName = 'Mailed',
                    Type = 'Registration',
                    //RecordType = recordType,
                    //LastModifiedDate = lastActivityDate,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    AccountId = accountList[0].Id
            );

            optyList.add(o);

            RecordType recordType = new RecordType();
            recordType.Name = 'Supplier';

            roundRobinVariable__c rrv = new roundRobinVariable__c();
            rrv.Name = 'SER';
            rrv.roundRobinID__c = 0;
            rrv.OwnerId = thisUser.Id;
            insert rrv;

            System.debug('ROUND ROBIN VARIABLE: ' + rrv);
            System.debug('NAME: ' + rrv.Name);
            System.debug('VARIABLE: ' + rrv.roundRobinID__c);
            System.debug('OWNERID: ' + rrv.OwnerId);

            System.debug(oppIds);
            System.debug(userIds);
            System.debug(firstPriorityReps);
            System.debug(oppAccountIds);
            System.debug(rrAccounts);
            System.debug(accountIds);

            Supplier_SER_Opty_Registration_RR supplier_ser_rr = new Supplier_SER_Opty_Registration_RR();
            supplier_ser_rr.QueryRegistrationOpportunity(optyList);
        }
    }


    @isTest
    public static void Supplier_SER_Opty_RoundRobin_SecondLanguageTest() {

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {

            List<Rep__c> firstPriorityReps = new List<Rep__c>();
            List<Account> rrAccounts = new List<Account>();
            List<Id> userIds = new List<Id>();
            List<Id> accountIds = new List<Id>();
            List<Id> oppAccountIds = new List<Id>();
            List<Id> oppIds = new List<Id>();
            List<Opportunity> optyList = new List<Opportunity>();

            List<User> users = QB_TestDataFactory.createUserRecords(8, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = '',
                        Language_2__c = 'Spanish',
                        Language_3__c = '',
                        SER_Region_Language__c = 'LATAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = '',
                        Language_2__c = 'Spanish',
                        Language_3__c = '',
                        SER_Region_Language__c = 'LATAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            insert firstPriorityReps;
            System.debug('REPS: ' + firstPriorityReps);

            for (integer i = 0; i < 3; i++) {
                Account a = new Account(
                        Name = 'Test Account: ',
                        BillingCountry = 'MX'
                );

                System.debug('ACCOUNT: ' + rrAccounts);
                rrAccounts.add(a);
            }

            System.debug('RRACCOUNT: ' + rrAccounts);
            insert rrAccounts;

            List<Account> accountList = [SELECT Id, Name, CountryLanguage__c, Region__c FROM Account WHERE Id = :rrAccounts[0].Id];

            for (Account accounts : rrAccounts) {
                accountIds.add(accounts.Id);
            }

            Opportunity o = new Opportunity(
                    Name = 'Test Opp: ',
                    StageName = 'Mailed',
                    Type = 'Registration',
                    //RecordType = recordType,
                    //LastModifiedDate = lastActivityDate,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    AccountId = accountList[0].Id
            );

            optyList.add(o);

            RecordType recordType = new RecordType();
            recordType.Name = 'Supplier';

            roundRobinVariable__c rrv = new roundRobinVariable__c();
            rrv.Name = 'SER';
            rrv.roundRobinID__c = 0;
            rrv.OwnerId = thisUser.Id;
            insert rrv;

            System.debug('ROUND ROBIN VARIABLE: ' + rrv);
            System.debug('NAME: ' + rrv.Name);
            System.debug('VARIABLE: ' + rrv.roundRobinID__c);
            System.debug('OWNERID: ' + rrv.OwnerId);

            System.debug(oppIds);
            System.debug(userIds);
            System.debug(firstPriorityReps);
            System.debug(oppAccountIds);
            System.debug(rrAccounts);
            System.debug(accountIds);

            Supplier_SER_Opty_Registration_RR supplier_ser_rr = new Supplier_SER_Opty_Registration_RR();
            supplier_ser_rr.QueryRegistrationOpportunity(optyList);
        }
    }

    @isTest
    public static void Supplier_SER_Opty_RoundRobin_ThirdLanguageTest() {

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {

            List<Rep__c> firstPriorityReps = new List<Rep__c>();
            List<Account> rrAccounts = new List<Account>();
            List<Id> userIds = new List<Id>();
            List<Id> accountIds = new List<Id>();
            List<Id> oppAccountIds = new List<Id>();
            List<Id> oppIds = new List<Id>();
            List<Opportunity> optyList = new List<Opportunity>();

            List<User> users = QB_TestDataFactory.createUserRecords(8, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = '',
                        Language_2__c = '',
                        Language_3__c = 'Spanish',
                        SER_Region_Language__c = 'LATAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = '',
                        Language_2__c = '',
                        Language_3__c = 'Spanish',
                        SER_Region_Language__c = 'LATAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            insert firstPriorityReps;
            System.debug('REPS: ' + firstPriorityReps);

            for (integer i = 0; i < 3; i++) {
                Account a = new Account(
                        Name = 'Test Account: ',
                        BillingCountry = 'MX'
                );

                System.debug('ACCOUNT: ' + rrAccounts);
                rrAccounts.add(a);
            }

            System.debug('RRACCOUNT: ' + rrAccounts);
            insert rrAccounts;

            List<Account> accountList = [SELECT Id, Name, CountryLanguage__c, Region__c FROM Account WHERE Id = :rrAccounts[0].Id];

            for (Account accounts : rrAccounts) {
                accountIds.add(accounts.Id);
            }

            Opportunity o = new Opportunity(
                    Name = 'Test Opp: ',
                    StageName = 'Mailed',
                    Type = 'Registration',
                    //RecordType = recordType,
                    //LastModifiedDate = lastActivityDate,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    AccountId = accountList[0].Id
            );

            optyList.add(o);

            RecordType recordType = new RecordType();
            recordType.Name = 'Supplier';

            roundRobinVariable__c rrv = new roundRobinVariable__c();
            rrv.Name = 'SER';
            rrv.roundRobinID__c = 0;
            rrv.OwnerId = thisUser.Id;
            insert rrv;

            System.debug('ROUND ROBIN VARIABLE: ' + rrv);
            System.debug('NAME: ' + rrv.Name);
            System.debug('VARIABLE: ' + rrv.roundRobinID__c);
            System.debug('OWNERID: ' + rrv.OwnerId);

            System.debug(oppIds);
            System.debug(userIds);
            System.debug(firstPriorityReps);
            System.debug(oppAccountIds);
            System.debug(rrAccounts);
            System.debug(accountIds);

            Supplier_SER_Opty_Registration_RR supplier_ser_rr = new Supplier_SER_Opty_Registration_RR();
            supplier_ser_rr.QueryRegistrationOpportunity(optyList);
        }
    }

    @isTest
    public static void Supplier_SER_Opty_RoundRobin_RegionTest() {

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {

            List<Rep__c> firstPriorityReps = new List<Rep__c>();
            List<Account> rrAccounts = new List<Account>();
            List<Id> userIds = new List<Id>();
            List<Id> accountIds = new List<Id>();
            List<Id> oppAccountIds = new List<Id>();
            List<Id> oppIds = new List<Id>();
            List<Opportunity> optyList = new List<Opportunity>();

            List<User> users = QB_TestDataFactory.createUserRecords(8, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = 'Spanish',
                        Language_2__c = '',
                        Language_3__c = '',
                        SER_Region_Language__c = 'LATAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = 'Spanish',
                        Language_2__c = '',
                        Language_3__c = '',
                        SER_Region_Language__c = 'LATAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = 'Spanish',
                        Language_2__c = '',
                        Language_3__c = '',
                        SER_Region_Language__c = 'NORAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            insert firstPriorityReps;
            System.debug('REPS: ' + firstPriorityReps);

            for (integer i = 0; i < 3; i++) {
                Account a = new Account(
                        Name = 'Test Account: ',
                        BillingCountry = 'US'
                );

                System.debug('ACCOUNT: ' + rrAccounts);
                rrAccounts.add(a);
            }

            System.debug('RRACCOUNT: ' + rrAccounts);
            insert rrAccounts;

            List<Account> accountList = [SELECT Id, Name, CountryLanguage__c, Region__c FROM Account WHERE Id = :rrAccounts[0].Id];

            for (Account accounts : rrAccounts) {
                accountIds.add(accounts.Id);
            }

            Opportunity o = new Opportunity(
                    Name = 'Test Opp: ',
                    StageName = 'Mailed',
                    Type = 'Registration',
                    //RecordType = recordType,
                    //LastModifiedDate = lastActivityDate,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    AccountId = accountList[0].Id
            );

            optyList.add(o);

            RecordType recordType = new RecordType();
            recordType.Name = 'Supplier';

            roundRobinVariable__c rrv = new roundRobinVariable__c();
            rrv.Name = 'SER';
            rrv.roundRobinID__c = 0;
            rrv.OwnerId = thisUser.Id;
            insert rrv;

            System.debug('ROUND ROBIN VARIABLE: ' + rrv);
            System.debug('NAME: ' + rrv.Name);
            System.debug('VARIABLE: ' + rrv.roundRobinID__c);
            System.debug('OWNERID: ' + rrv.OwnerId);

            System.debug(oppIds);
            System.debug(userIds);
            System.debug(firstPriorityReps);
            System.debug(oppAccountIds);
            System.debug(rrAccounts);
            System.debug(accountIds);

            Supplier_SER_Opty_Registration_RR supplier_ser_rr = new Supplier_SER_Opty_Registration_RR();
            supplier_ser_rr.QueryRegistrationOpportunity(optyList);
        }
    }

    @isTest
    public static void Supplier_SER_Opty_Registration_ExistingOptyTest() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {

            List<Rep__c> firstPriorityReps = new List<Rep__c>();
            List<Account> rrAccounts = new List<Account>();
            List<Id> userIds = new List<Id>();
            List<Id> accountIds = new List<Id>();
            List<Id> oppAccountIds = new List<Id>();
            List<Id> oppIds = new List<Id>();
            List<Opportunity> optyList = new List<Opportunity>();
            List<Integer> repOptyCount = new List<Integer>();

            List<User> users = QB_TestDataFactory.createUserRecords(2, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = 'Spanish',
                        Language_2__c = 'English',
                        Language_3__c = '',
                        SER_Region_Language__c = 'NORAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = 'Spanish',
                        Language_2__c = '',
                        Language_3__c = '',
                        SER_Region_Language__c = 'LATAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            insert firstPriorityReps;
            System.debug('REPS: ' + firstPriorityReps);

            for (integer i = 0; i < 1; i++) {
                Account a = new Account(
                        Name = 'Test Account: ',
                        BillingCountry = 'US'
                );

                Account a1 = new Account(
                        Name = 'Test Account2: ',
                        BillingCountry = 'MX'
                );

                System.debug('ACCOUNT: ' + rrAccounts);
                rrAccounts.add(a);
                rrAccounts.add(a1);
            }

            System.debug('RRACCOUNT: ' + rrAccounts);
            insert rrAccounts;

            List<Account> accountList = [SELECT Id, Name, CountryLanguage__c, Region__c FROM Account WHERE Id = :rrAccounts[1].Id];

            for (Account accounts : rrAccounts) {
                accountIds.add(accounts.Id);
            }

            Opportunity o = new Opportunity(
                    Name = 'Test Opp: ',
                    StageName = 'Mailed',
                    Type = 'Registration',
                    //RecordType = recordType,
                    //LastModifiedDate = lastActivityDate,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    AccountId = accountList[0].Id
            );

            optyList.add(o);

            Opportunity o1 = new Opportunity(
                    Name = 'Test Opp: ',
                    StageName = 'Mailed',
                    Type = 'Registration',
                    //RecordType = recordType,
                    //LastModifiedDate = lastActivityDate,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    AccountId = accountList[0].Id
            );

            optyList.add(o1);

            RecordType recordType = new RecordType();
            recordType.Name = 'Supplier';

            roundRobinVariable__c rrv = new roundRobinVariable__c();
            rrv.Name = 'SER';
            rrv.roundRobinID__c = 5;
            rrv.OwnerId = thisUser.Id;
            insert rrv;

            repOptyCount.add(3);
            repOptyCount.add(4);

            System.debug('ROUND ROBIN VARIABLE: ' + rrv);
            System.debug('NAME: ' + rrv.Name);
            System.debug('VARIABLE: ' + rrv.roundRobinID__c);
            System.debug('OWNERID: ' + rrv.OwnerId);

            System.debug(oppIds);
            System.debug(userIds);
            System.debug(firstPriorityReps);
            System.debug(oppAccountIds);
            System.debug(rrAccounts);
            System.debug(accountIds);

            Supplier_SER_Opty_Registration_RR supplier_ser_rr = new Supplier_SER_Opty_Registration_RR();
            supplier_ser_rr.QueryRegistrationOpportunity(optyList);
        }
    }

    @isTest
    public static void Supplier_SER_Opty_Registration_LanguageTest() {

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {

            List<Rep__c> firstPriorityReps = new List<Rep__c>();
            List<Account> rrAccounts = new List<Account>();
            List<Id> userIds = new List<Id>();
            List<Id> accountIds = new List<Id>();
            List<Id> oppAccountIds = new List<Id>();
            List<Id> oppIds = new List<Id>();
            List<Opportunity> optyList = new List<Opportunity>();
            List<Opportunity> existingOptyList = new List<Opportunity>();
            List<Integer> repOptyCount = new List<Integer>();
            List<User> users = QB_TestDataFactory.createUserRecords(2, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');

            for (Integer i = 0; i < 1; i++) {
                Rep__c r = new Rep__c(
                        Name = 'Rep ' + i,
                        User__c = users[i].Id,
                        //RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SER').getRecordTypeId(),
                        Language_1__c = 'Portuguese',
                        Language_2__c = 'English',
                        Language_3__c = '',
                        SER_Region_Language__c = 'LATAM'
                );

                System.debug('CURRENT REP: ' + r);
                firstPriorityReps.add(r);
            }

            insert firstPriorityReps;
            System.debug('REPS: ' + firstPriorityReps);

            for (integer i = 0; i < 1; i++) {
                Account a = new Account(
                        Name = 'Test Account: ',
                        BillingCountry = 'BR'
                );

                Account a1 = new Account(
                        Name = 'Test Account2: ',
                        BillingCountry = 'MX'
                );

                System.debug('ACCOUNT: ' + rrAccounts);
                rrAccounts.add(a);
                rrAccounts.add(a1);
            }

            System.debug('RRACCOUNT: ' + rrAccounts);
            insert rrAccounts;

            List<Account> accountList = [SELECT Id, Name, CountryLanguage__c, Region__c FROM Account WHERE Id = :rrAccounts[0].Id];
            List<Account> accountList2 = [SELECT Id, Name, CountryLanguage__c, Region__c FROM Account WHERE Id = :rrAccounts[1].Id];

            for (Account accounts : rrAccounts) {
                accountIds.add(accounts.Id);
            }

            Opportunity o = new Opportunity(
                    Name = 'Test Opp: ',
                    StageName = 'Mailed',
                    Type = 'Registration',
                    //RecordType = recordType,
                    //LastModifiedDate = lastActivityDate,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    AccountId = accountList[0].Id
            );

            optyList.add(o);

            Opportunity o1 = new Opportunity(
                    Name = 'Test Opp: ',
                    StageName = 'Mailed',
                    Type = 'Registration',
                    //RecordType = recordType,
                    //LastModifiedDate = lastActivityDate,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    AccountId = accountList[0].Id
            );

            optyList.add(o1);

            for(Integer i = 0; i < 6; i++) {
                Opportunity oppty = new Opportunity(
                        Name = 'Test Opp: ',
                        StageName = 'Mailed',
                        Type = 'Registration',
                        //RecordType = recordType,
                        //LastModifiedDate = lastActivityDate,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                        AccountId = accountList2[0].Id
                );

                existingOptyList.add(oppty);
            }

            //insert existingOptyList;

            RecordType recordType = new RecordType();
            recordType.Name = 'Supplier';

            roundRobinVariable__c rrv = new roundRobinVariable__c();
            rrv.Name = 'SER';
            rrv.roundRobinID__c = 5;
            rrv.OwnerId = thisUser.Id;
            insert rrv;

            repOptyCount.add(3);
            repOptyCount.add(4);

            System.debug('ROUND ROBIN VARIABLE: ' + rrv);
            System.debug('NAME: ' + rrv.Name);
            System.debug('VARIABLE: ' + rrv.roundRobinID__c);
            System.debug('OWNERID: ' + rrv.OwnerId);

            System.debug(oppIds);
            System.debug(userIds);
            System.debug(firstPriorityReps);
            System.debug(oppAccountIds);
            System.debug(rrAccounts);
            System.debug(accountIds);

            Supplier_SER_Opty_Registration_RR supplier_ser_rr = new Supplier_SER_Opty_Registration_RR();
            supplier_ser_rr.QueryRegistrationOpportunity(optyList);
        }
    }
}