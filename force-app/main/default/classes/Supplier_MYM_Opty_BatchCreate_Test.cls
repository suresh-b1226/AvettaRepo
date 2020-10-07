//Created by Parker Brown 1/4/2019
//This is a test class for 'Supplier_MYM_Opty_BatchCreate' class.


@isTest 
public class Supplier_MYM_Opty_BatchCreate_Test 
{

    @testSetup 
    static void setup() {
        Date Dat60 = date.today().adddays(60);
        List<Account> accounts = new List<Account>();
  		List<Zuora__Subscription__c> subs = new List<Zuora__Subscription__c>();
        List<MYM_Blacklisted_Account__c> blAccts = new List<MYM_Blacklisted_Account__C>();
        List<User> users = new List<User>();
        List<roundRobinVariable__c> roundrobin = new List <roundRobinVariable__c>();
        List<Profile> profiles = new List<Profile>();
        List<Contact> contacts = new List<Contact>();
        
        //insert 1 round robin object
        for(Integer i=0;i<1;i++){
        	roundrobin.add(new roundRobinVariable__c(roundRobinID__c=i, name = 'MYM'));    
        }
        insert roundrobin;
        
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='US', CurrencyIsoCode = 'USD', Status__c='Active'));
        }
        insert accounts;
		
        //insert 10 subscriptions
        for (Account account : [select id from account]) {
            subs.add(new Zuora__Subscription__c(Zuora__Account__c=account.id, 
                Zuora__NextRenewalDate__c=Dat60, Zuora__Status__c='Active'));
        }
        insert subs;
        
        //insert 10 blacklisted accounts (doesn't matter the number)
        for (Account account : [select id from account]) {
            blAccts.add(new MYM_Blacklisted_Account__C(name='JLL North America', Account__c = account.id));
        }
        insert blAccts;
    }
    static testmethod void test() {        
        Test.startTest();
        Supplier_MYM_Opty_BatchCreate b = new Supplier_MYM_Opty_BatchCreate();
        Database.executeBatch(b);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        //System.assertEquals(5, [select count() from Opportunity]);
    }
    

}