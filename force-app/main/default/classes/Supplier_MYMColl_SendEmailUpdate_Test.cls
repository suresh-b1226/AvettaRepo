//Created 2/22/2019 by Parker Brown
//Test Class for the 'Supplier_MYMColl_SendEmailUpdate_Batch' class.

@isTest
public class Supplier_MYMColl_SendEmailUpdate_Test {	
	
    //method to setup the test environment
    @testSetup 
    static void setup() {
        DateTime DatToday = date.today();
        DateTime DatNew = DatToday.addHours(2);
        List<Account> accounts = new List<Account>();
        List<Opportunity> opps = new List<Opportunity>();
        List<roundRobinVariable__c> roundRobin = new List<roundRobinVariable__c>(); 
        
        //insert 1 roundRobin variable
        for (Integer i=0;i<1;i++) {
            roundRobin.add(new roundRobinVariable__c(name='MYM', 
                roundRobinID__c=i));
        }
        insert roundRobin;
        
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='US', Organizer_Id__c='123'+i, CurrencyIsoCode = 'USD', Status__c='Active'));
        }
        insert accounts;
		
        //insert 10 opportunities
        for (Account account : [select id from account where id =: accounts]) {
            opps.add(new Opportunity(accountid=account.id,name='MYMtest1', closedate=date.today(),
                                     StageName='Open',
                                     RecordTypeId='0120g000000YTz4AAG', Start_Automated_Email_Send__c=DatNew,
                                     Sent_Email_1__c =True,Sent_Email_2__c=True, Sent_Email_3__c=True));
            opps.add(new Opportunity(accountid=account.id,name='MYMtest2', closedate=date.today(),
                                     StageName='Open',
                                     RecordTypeId='0120g000000YTz4AAG', Start_Automated_Email_Send__c=DatNew ));
            opps.add(new Opportunity(accountid=account.id,name='MYMtest3', closedate=date.today(), Start_Automated_Email_Send__c=DatNew,Sent_Email_1__c =True,
                                     StageName='Open',
                                     RecordTypeId='0120g000000YTz4AAG' ));
            opps.add(new Opportunity(accountid=account.id,name='MYMtest4', closedate=date.today(), Start_Automated_Email_Send__c=DatNew,Sent_Email_1__c =True,
                                     Sent_Email_2__c=True,
                                     StageName='Open',
                                     RecordTypeId='0120g000000YTz4AAG' ));
        }
        insert opps;

    	}
    
     //method to test the schedule class called 'Supplier_MYMColl_SendEmail_FieldUpdate'
     public static testMethod void testschedule() {
        Test.StartTest();
        Supplier_MYMColl_SendEmail_FieldUpdate sh1 = new Supplier_MYMColl_SendEmail_FieldUpdate();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test MYMColl update', sch, sh1); 
        Test.stopTest(); 
     }
    
    
    //method to execute the batch apex test
    static testmethod void test() {        
        Test.startTest();
        Supplier_MYMColl_SendEmailUpdate_Batch bMYMColl = new Supplier_MYMColl_SendEmailUpdate_Batch();
        Database.executeBatch(bMYMColl);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(40, [select count() from Opportunity]);
    }
     
}