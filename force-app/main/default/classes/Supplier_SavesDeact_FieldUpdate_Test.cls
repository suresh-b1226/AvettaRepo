//Created 2/22/2019 by Parker Brown
//Test Class for the 'Supplier_SavesDeact_FieldUpdate_Batch' class.

@isTest
public class Supplier_SavesDeact_FieldUpdate_Test {

    @IsTest /*(SeeAllData = true)*/
    static void setup() {
        SIT_Settings__c sitSetting  = QB_TestDataFactory.createSITCustomSetting(TRUE);

        List<Account> insideAccounts = new List<Account>();
        List<Opportunity> insideOpps = new List<Opportunity>();

        List<Account> outsideAccounts = new List<Account>();
        List<Opportunity> outsideOpps = new List<Opportunity>();

        List<roundRobinVariable__c> roundRobin = new List<roundRobinVariable__c>(); 
        
        //insert 1 round robin variable
        for (Integer i=0; i<1; i++) {
            roundRobin.add(new roundRobinVariable__c(
                    Name            = 'Saves Deactivation',
                    roundRobinID__c = i));
        }
        insert roundRobin;
        
        // insert 10 accounts
        for (Integer i=0; i<10; i++) {
            insideAccounts.add(new Account(
                    Name            = 'Account '+i,
                    BillingCity     = 'New York',
                    BillingCountry  = 'US',
                    Organizer_ID__c = '991199'+i,
                    CurrencyIsoCode = 'USD',
                    Status__c       = 'Active'));
        }
        insert insideAccounts;

        for (Account account : [
                SELECT Id
                FROM Account
                WHERE Id =: insideAccounts
        ]) {
            insideOpps.add(new Opportunity(
                    AccountId                    = account.Id,
                    Name                         = 'Deactivation Request',
                    CloseDate                    = Date.today(),
                    Eligible_for_Deactivation__c = false,
                    StageName                    = 'Open',
                    Result__c                    = null,
                    Renewal_Date__c              = Date.today(),
                    Term_Start_Date__c           = Date.today().addDays(-15),
                    RecordTypeId                 = '01270000000cebpAAA',
                    Membership_Level_Offered__c  = 'Full Membership'
                    ));

        }
        insert insideOpps;

        for (Integer i=0; i<10; i++) {
            outsideAccounts.add(new Account(
                    Name            = 'Account '+i,
                    BillingCity     = 'Lima',
                    BillingCountry  = 'PE',
                    Organizer_ID__c = '991111'+i,
                    CurrencyIsoCode = 'USD',
                    Status__c       = 'Active'));
        }
        insert outsideAccounts;

        for (Account account : [
                SELECT Id
                FROM Account
                WHERE Id =: outsideAccounts
        ]) {
            outsideOpps.add(new Opportunity(
                    AccountId                    = account.Id,
                    Name                         = 'Deactivation Request',
                    CloseDate                    = Date.today(),
                    Eligible_for_Deactivation__c = false,
                    StageName                    = 'Open',
                    Result__c                    = 'Pending Deactivation',
                    Renewal_Date__c              = Date.today(),
                    Term_Start_Date__c           = Date.today().addDays(50),
                    RecordTypeId                 = '01270000000cebpAAA',
                    Membership_Level_Offered__c  = 'Full Membership'
                    ));

        }
        insert outsideOpps;

        //System.debug('opps :: ' + opps);
        //System.debug('opps size :: ' + opps.size());

        Test.startTest();
        Supplier_SavesDeact_FieldUpdate_Batch bDeact = new Supplier_SavesDeact_FieldUpdate_Batch();
        Database.executeBatch(bDeact);
        Test.stopTest();

        insideOpps = [
                SELECT Name, StageName, Id
                FROM Opportunity
                WHERE AccountId =: insideAccounts
        ];

        System.assertEquals(10, insideOpps.size());

        outsideOpps = [
                SELECT Name, StageName, Id
                FROM Opportunity
                WHERE AccountId =: outsideAccounts
        ];

        System.assertEquals(10, outsideOpps.size());


    }

    //method to test the schedule class called 'Supplier_SavesDeact_Opty_EligibleUpdate'
     public static testMethod void testschedule() {
        Test.startTest();
        Supplier_SavesDeact_Opty_EligibleUpdate sh1 = new Supplier_SavesDeact_Opty_EligibleUpdate();
        String sch = '0 0 23 * * ?'; 
        System.schedule('Test Eligible for Deact update', sch, sh1);
        Test.stopTest(); 
     }
    

}