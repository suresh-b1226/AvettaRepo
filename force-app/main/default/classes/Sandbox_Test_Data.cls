//Written by Dallin Wasden 1.7.19.
//Data factory to be used for Sandbox refresh data creation

public class Sandbox_Test_Data {
    private static integer previous = 0;
    
    public static List<Account> createAccountRecords(Integer count, Boolean isInsert)
    {
        system.debug(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        count = previous + count;
        List<Account> accountRecords = new List<Account>();
        for(Integer i = 0; i < count; i++){
            accountRecords.add(
                new Account(
                    Name='test account' + i,
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(),
                    //Vetify_Position__c = 'Client Opt In',
                    Status__c = 'Active',
                    Organizer_ID__c = String.valueOf(98435183 + i),
                    BillingCountry = 'United States'
                )
            );
        }
        previous = count + previous;
        if(isInsert){
            insert accountRecords;
        }
        return accountRecords;
    }
    
    public static List<Account> createClientAccountRecords(Integer count, Boolean isInsert) {
        List<Account> accountRecords = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accountRecords.add(
                new Account(
                    Name = 'test account' + i,
                    Type = 'Operator',
                    Vetify_Position__c = 'Client Opt In',
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(),
                    Status__c = 'Active',
                    BillingCountry = 'United States',
                    Supplier_is_also_a_client__c = FALSE
                )
            );
        }
        if (isInsert) {
            insert accountRecords;
        }
        return accountRecords;
    }
    
    public static List<Contact> createContactRecords(Integer count, Boolean isInsert, Id accountId, Id clientAccountId, String email) {
        List<Contact> contactRecords = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            contactRecords.add(
                new Contact(
                    AccountId = accountId,
                    FirstName = 'One',
                    LastName = 'test contact' + i,
                    Account_Type__c = 'Contractor',
                    CurrencyIsoCode = 'USD',
                    Phone = '619-000-0001',
                    Email = email,
                    Organizer_isActive__c = 'Yes',
                    Primary_PICS_Organizer_User__c = True
                )
            );
        }
        
        for (Integer i = 0; i < count; i++) {
            contactRecords.add(
                new Contact(
                    AccountId = clientAccountId,
                    FirstName = 'One',
                    LastName = 'test contact' + i,
                    Account_Type__c = 'Contractor',
                    CurrencyIsoCode = 'USD',
                    Phone = '619-000-0001',
                    Email = email,
                    Organizer_isActive__c = 'Yes',
                    Primary_PICS_Organizer_User__c = True
                )
            );
        }
        if (isInsert) {
            insert contactRecords;
        }
        return contactRecords;
    }
    
    public static List<Opportunity> createOpportunityRecords(Integer count, Boolean isInsert, Id accountId, Id clientAccountId, Id contactId) {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test supplier Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    Type = 'Registration',
                    StageName = 'Mailed',
                    Result__c = 'Not Contacted',
                    CurrencyIsoCode = 'USD',
                    Primary_Contact__c = contactId
                )
            );
        }
        
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test collections Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    Type = 'Collection Renewal',
                    StageName = 'Open',
                    CurrencyIsoCode = 'USD',
                    Primary_Contact__c = contactId
                )
            );
        }
        
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test mym Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MYM').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    StageName = 'Open',
                    CurrencyIsoCode = 'USD',
                    Primary_Contact__c = contactId
                )
            );
        }
        
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test retention Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    StageName = 'Open',
                    CurrencyIsoCode = 'USD',
                    Primary_Contact__c = contactId
                )
            );
        }
        
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test saves downgrade Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    StageName = 'In Progress',
                    CurrencyIsoCode = 'USD',
                    Primary_Contact__c = contactId
                )
            );
        }
        
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test vetify Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    Type = 'Registration',
                    StageName = 'Mailed',
                    Result__c = 'Not Contacted',
                    CurrencyIsoCode = 'USD',
                    Client_Account__c = clientAccountId,
                    Primary_Contact__c = contactId
                )
            );
        }
        if (isInsert) {
            insert opportunityRecords;
        }
        return opportunityRecords;
    }
    
    public static List<Case> createCaseRecords(Integer count, Boolean isInsert, Id accountId, Id contactId) {
        count = previous + count;
        List<Case> caseRecords = new List<Case>();
        for (Integer i = 0; i < count; i++) {
            caseRecords.add(
                new Case(
                    Subject = 'test case' + i,
                    RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    AccountId = accountId,
                    ContactId = contactId,
                    Description = 'test',
                    Status = 'New',
                    Type = 'Audit',
                    Origin = 'Phone'
                )
            );
        }
        System.debug('caseRecords = ' + caseRecords);
        previous = count + previous;
        if (isInsert) {
            insert caseRecords;
        }
        return caseRecords;
    }
    
    public static List<roundRobinVariable__c> createRoundRobinRecords() {
        List<roundRobinVariable__c> roundRobinRecords = new List<roundRobinVariable__c>();
        
        roundRobinRecords.add(
            new roundRobinVariable__c(
                Name = 'MYM',
                roundRobinID__c = 1
            )
        );
        
        roundRobinRecords.add(
            new roundRobinVariable__c(
                Name = 'Vetify Fulfillment',
                roundRobinID__c = 1
            )
        );
        
        roundRobinRecords.add(
            new roundRobinVariable__c(
                Name = 'Saves Downgrade',
                roundRobinID__c = 1
            )
        );
        
        System.debug('roundRobinRecords = ' + roundRobinRecords);
        
        insert roundRobinRecords;
        
        return roundRobinRecords;
    }
}