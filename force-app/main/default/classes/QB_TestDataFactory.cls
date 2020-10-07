@isTest
public class QB_TestDataFactory {
    private static integer previous = 0;
    
    public static List<Supplier_Staging__c> createSupplierRecords(Integer count, Boolean isInsert, Id accountId, Id contactId, Id ownerId, Id campaignId) {
        List<Supplier_Staging__c> supplierRecords = new List<Supplier_staging__c>();
        for (Integer i = 0; i < count; i++) {
            supplierRecords.add(
                new Supplier_Staging__c(
                    Name = 'test' + i,
                    Company__c = 'Supplier Company Name',
                    Street__c = '123 Test Street Address',
                    City__c = 'TEST City',
                    State__c = 'State TEsting',
                    Postal_Zip_Code__c = '92071',
                    Country__c = 'USA',
                    First_Name__c = 'ConFime',
                    Last_Name__c = 'ConLame',
                    Email__c = 'test@mail.com',
                    Phone__c = '123-456-7890',
                    Website__c = 'www.website.com',
                    Additional_information__c = 'This is a test Class',
                    Priority__c = 'High',
                    Account_ID__c = accountId,
                    Contact_ID__c = contactId,
                    Campaign__c = campaignId,
                    Owner_ID__c = ownerId)
            );
        }
        if (isInsert) {
            insert supplierRecords;
        }
        return supplierRecords;
    }
    
    public static List<Campaign> createCampaignRecordsWithClientId(Integer count, Boolean isInsert, Id clientId) {
        List<Campaign> campaignRecords = new List<Campaign>();
        for (Integer i = 0; i < count; i++) {
            campaignRecords.add(
                new Campaign(
                    Name = 'EBL.EXT25823580Contractors',
                    type = 'email',
                    IsActive = true,
                    StartDate = Date.today() + 5,
                    Client_Account__c = clientId,
                    BudgetedCost = 1000 + i
                )
            );
        }
        if (isInsert) {
            insert campaignRecords;
        }
        return campaignRecords;
    }
    
    public static List<Campaign> createCampaignRecords(Integer count, Boolean isInsert) {
        List<Campaign> campaignRecords = new List<Campaign>();
        for (Integer i = 0; i < count; i++) {
            campaignRecords.add(
                new Campaign(
                    Name = 'test' + i,
                    type = 'email',
                    IsActive = true,
                    StartDate = Date.today() + 5,
                    BudgetedCost = 1000 + i
                )
            );
        }
        if (isInsert) {
            insert campaignRecords;
        }
        return campaignRecords;
    }
    
    public static List<Account> createAccountRecordsWithOutPrimaryContact(Integer count, Boolean isInsert) {
        List<Account> accountRecords = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accountRecords.add(
                new Account(
                    Name = 'test account' + i,
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(),
                    //Vetify_Position__c = 'Client Opt In',
                    Status__c = 'Prospect',
                    Organizer_ID__c = '11111' + i
                )
            );
        }
        if (isInsert) {
            insert accountRecords;
        }
        return accountRecords;
    }
    
    public static Account createAndInsertAccountRecord(Boolean isInsert)
    {
        System.debug(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        Account accountRecord = new Account();
        accountRecord.Name = 'test account';
        accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        accountRecord.Status__c = 'Active';
        accountRecord.Organizer_ID__c = String.valueOf(98435183);
        accountRecord.BillingCountry = 'United States';
        if(isInsert){
            insert accountRecord;
        }
        return accountRecord;
    }
    
    public static Account createAndInsertSpanishAccountRecord(Boolean isInsert)
    {
        System.debug(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        Account accountRecord = new Account();
        accountRecord.Name = 'test account';
        accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        accountRecord.Status__c = 'Active';
        accountRecord.Organizer_ID__c = String.valueOf(98435183);
        accountRecord.BillingCountry = 'MX';
        if(isInsert){
            insert accountRecord;
        }
        return accountRecord;
    }    
   
    public static Account createAndInsertPortugueseAccountRecord(Boolean isInsert)
    {
        System.debug(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        Account accountRecord = new Account();
        accountRecord.Name = 'test account';
        accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        accountRecord.Status__c = 'Active';
        accountRecord.Organizer_ID__c = String.valueOf(98435183);
        accountRecord.BillingCountry = 'BR';
        if(isInsert){
            insert accountRecord;
        }
        return accountRecord;
    }    
    
    public static Account createAndInsertGermanAccountRecord(Boolean isInsert)
    {
        System.debug(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        Account accountRecord = new Account();
        accountRecord.Name = 'test account';
        accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        accountRecord.Status__c = 'Active';
        accountRecord.Organizer_ID__c = String.valueOf(98435183);
        accountRecord.BillingCountry = 'AT';
        if(isInsert){
            insert accountRecord;
        }
        return accountRecord;
    }    

    public static Account createAndInsertDutchAccountRecord(Boolean isInsert)
    {
        System.debug(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        Account accountRecord = new Account();
        accountRecord.Name = 'test account';
        accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        accountRecord.Status__c = 'Active';
        accountRecord.Organizer_ID__c = String.valueOf(98435183);
        accountRecord.BillingCountry = 'NL';
        if(isInsert){
            insert accountRecord;
        }
        return accountRecord;
    }    

    public static Account createAndInsertGenericAccountRecord_Unique(Integer i, Boolean isInsert, String country)
    {
        system.debug(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        Account accountRecord = new Account();
        accountRecord.Name = 'test account' + i;
        accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        //Vetify_Position__c = 'Client Opt In',
        accountRecord.Status__c = 'Active';
        accountRecord.Organizer_ID__c = String.valueOf(98435183 + i);
        accountRecord.BillingCountry = country;

        if (isInsert) {
            upsert accountRecord;
        }
        return accountRecord;
    }

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
    
    public static List<Account> createAccountRecordsWithCountry(Integer count, Boolean isInsert, String country)
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
                    BillingCountry = country
                )
            );
        }
        previous = count + previous;
        if(isInsert){
            insert accountRecords;
        }
        return accountRecords;
    }
    
    public static List<Case> createCaseRecords(Integer count, Boolean isInsert, Id accountId) {
        count = previous + count;
        List<Case> caseRecords = new List<Case>();
        for (Integer i = 0; i < count; i++) {
            caseRecords.add(
                new Case(
                    Subject = 'test case' + i,
                    RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Connect').getRecordTypeId(),
                    AccountId = accountId,
                    Status = 'New',
                    Type = 'docuGuard'
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
    
    public static List<Case> createCaseRecords(Integer count, Boolean isInsert, Id accountId, Id contactId) {
        count = previous + count;
        List<Case> caseRecords = new List<Case>();
        for (Integer i = 0; i < count; i++) {
            caseRecords.add(
                new Case(
                    Subject = 'test case' + i,
                    RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Connect').getRecordTypeId(),
                    AccountId = accountId,
                    Status = 'New',
                    Type = 'insureGuard',
                    ContactId = contactId
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
    
    public static List<Case> createAnnualUpdateCaseRecords(Integer count, Boolean isInsert, Id accountId, Id contactId, String setStatus) {
        count = previous + count;
        List<Case> caseRecords = new List<Case>();
        for (Integer i = 0; i < count; i++) {
            caseRecords.add(
                new Case(
                    Subject = '2018 Annual Update' + i,
                    RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Connect').getRecordTypeId(),
                    AccountId = accountId,
                    Status = setStatus,
                    Type = 'docuGuard',
                    ContactId = contactId
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
    
    public static List<Account> createClientProspectAccountRecords(Integer count, Boolean isInsert) {
        List<Account> accountRecords = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accountRecords.add(
                new Account(
                    Name = 'test account' + i,
                    Type = 'Operator',
                    Vetify_Position__c = 'Client Opt In',
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(),
                    Status__c = 'Prospect'
                )
            );
        }
        if (isInsert) {
            insert accountRecords;
        }
        return accountRecords;
    }
    
    public static List<Account> createClientAccountRecords(Integer count, Boolean isInsert) {
        List<Account> accountRecords = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accountRecords.add(
                new Account(
                    Name = 'global test account' + i,
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
    
    public static List<Account> createClientAccountRecords(Integer count, Boolean isInsert, Id globalParent) {
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
                    Supplier_is_also_a_client__c = FALSE,
                    Global_Parent__c = globalParent
                )
            );
        }
        if (isInsert) {
            insert accountRecords;
        }
        return accountRecords;
    }
    
    public static List<Account> createClientAccountRecordsEmailCadence(Integer count, Boolean isInsert, Boolean isUnitedStates) {
        List<Account> accountRecords = new List<Account>();
        if (isUnitedStates == True) {
            for (Integer i = 0; i < count; i++) {
                accountRecords.add(
                    new Account(
                        Name = 'test account' + i,
                        Type = 'Operator',
                        Vetify_Position__c = 'Client Opt In',
                        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(),
                        Status__c = 'Active',
                        BillingCountry = 'United States'
                    )
                );
            }
        } else if (isUnitedStates == False) {
            for (Integer i = 0; i < count; i++) {
                accountRecords.add(
                    new Account(
                        Name = 'test account' + i,
                        Type = 'Operator',
                        Vetify_Position__c = 'Client Opt In',
                        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(),
                        Status__c = 'Active',
                        BillingCountry = 'Canada'
                    )
                );
            }
        }
        if (isInsert) {
            insert accountRecords;
        }
        return accountRecords;
    }
    
    public static List<Account> createClientAccountRecordsEmailCadence(Integer count, Boolean isInsert, Boolean isUnitedStates, Boolean isUpdate) {
        List<Account> accountRecords = new List<Account>();
        if (isUnitedStates == True) {
            for (Integer i = 0; i < count; i++) {
                accountRecords.add(
                    new Account(
                        Name = 'test account' + i,
                        Type = 'Operator',
                        Vetify_Position__c = 'Client Opt In',
                        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(),
                        Status__c = 'Active',
                        BillingCountry = 'United States'
                    )
                );
            }
        } else if (isUnitedStates == False) {
            for (Integer i = 0; i < count; i++) {
                accountRecords.add(
                    new Account(
                        Name = 'test account' + i,
                        Type = 'Operator',
                        Vetify_Position__c = 'Client Opt In',
                        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(),
                        Status__c = 'Active',
                        BillingCountry = 'India'
                    )
                );
            }
        }
        if (isInsert) {
            insert accountRecords;
        }
        return accountRecords;
    }
    
    public static List<Contact> createContactRecords(Integer count, Boolean isInsert, Id accountId) {
        return QB_TestDataFactory.createContactRecords(count, isInsert, accountId, 'test@test.com');
        
    }
    
    public static Contact createAndInsertContactRecord(Boolean isInsert, Id accountId, String email) {
        Contact contactRecord = new Contact();
        contactRecord.AccountId = accountId;
        contactRecord.FirstName = 'One';
        contactRecord.LastName = 'test contact';
        contactRecord.Account_Type__c = 'Contractor';
        contactRecord.CurrencyIsoCode = 'USD';
        contactRecord.Phone = '619-000-0001';
        contactRecord.Email = email;
        contactRecord.Organizer_isActive__c = 'Yes';
        contactRecord.Primary_PICS_Organizer_User__c = True;
        if (isInsert) {
            insert contactRecord;
        }
        return contactRecord;
    }
    
    public static List<Contact> createContactRecords(Integer count, Boolean isInsert, Id accountId, String email) {
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
        if (isInsert) {
            insert contactRecords;
        }
        return contactRecords;
    }
    
    public static List<Contact> createContactRecords(Integer count, Boolean isInsert, Id accountId, String email, String firstName, String lastName) {
        List<Contact> contactRecords = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            contactRecords.add(
                new Contact(
                    AccountId = accountId,
                    FirstName = firstName,
                    LastName = lastName,
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
    
    public static List<Opportunity> createRetentionOptyRecords(Integer count, Boolean isInsert, Id accountId) {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    Type = 'Reactivation',
                    StageName = 'Open',
                    Result__c = 'Not Contacted',
                    CurrencyIsoCode = 'USD'
                )
            );
        }
        if (isInsert) {
            insert opportunityRecords;
        }
        return opportunityRecords;
    }
    
    public static List<Opportunity> createCollectionOptyRecord(Integer collectionsCount, Boolean isInsert, Id accountId, List<Zuora__ZInvoice__c> invoiceRecords, Id contactId)
    {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for(Integer i = 0; i < collectionsCount; i++){
            opportunityRecords.add(
                new Opportunity(
                    Name =  'collections test Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                    CloseDate = Date.today()+5,
                    Type = 'Collection Renewal',
                    StageName = 'Open',
                    CreatedDate = Date.today()
                    //Primary_Contact__c = contactId,
                    //Sent_Email_1__c = True
                )
            );
        }
        
        if(isInsert){
            insert opportunityRecords;
        }
        return opportunityRecords;
    }
    
    //Automated email creation test for Opportunities with a record type of 'Collections '
    public static List<Opportunity> createCollectionOptyRecordEmailTester(Integer collectionsCount, Boolean isInsert, Id accountId, List<Zuora__ZInvoice__c> invoiceRecords, Id contactId, Boolean email1, Boolean email2, Boolean email3, Boolean email4, Boolean email5, Boolean isIndia)
    {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for(Integer i = 0; i < collectionsCount; i++){
            if(email1 == TRUE && isIndia == FALSE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        //Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06'
                    )
                );
            }
            else if(email2 == TRUE && isIndia == FALSE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        Sent_Email_1__c = True,
                        Send_Email_1__c = Date.today(),
                        OwnerId = '0050g000005yF06'
                    )
                );
            }
            else if(email3 == TRUE && isIndia == FALSE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today()
                        //Send_Email_3__c = Date.today()
                    )
                );
            }
            else if(email4 == TRUE && isIndia == FALSE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                        //Send_Email_4__c = Date.today()
                    )
                );
            }
             else if(email5 == TRUE && isIndia == FALSE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Sent_Email_4__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today(),
                        Send_Email_4__c = Date.today()
                    )
                );
            }
            else if(email1 == TRUE && isIndia == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections  INDIAtest Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        //Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Country__c = 'IN'
                    )
                );
            }
            else if(email2 == TRUE && isIndia == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections INDIA test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        Sent_Email_1__c = True,
                        Send_Email_1__c = Date.today(),
                        OwnerId = '0050g000005yF06',
                        Country__c = 'IN'
                    )
                );
            }
            else if(email3 == TRUE && isIndia == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections INDIA test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Country__c = 'IN'
                        //Send_Email_3__c = Date.today()
                    )
                );
            }
            else if(email4 == TRUE && isIndia == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections INDIA test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today(),
                        Country__c = 'IN'
                        //Send_Email_4__c = Date.today()
                    )
                );
            }
            else if(email5 == TRUE && isIndia == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections INDIA test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Collections').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Sent_Email_4__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today(),
                        Country__c = 'IN',
                        Send_Email_4__c = Date.today()
                    )
                );
            }
            if(isInsert){
                insert opportunityRecords;
            }
        }
        return opportunityRecords;
    }
    
    public static List<Opportunity> createRetentionOptyRecord(Integer retentionCount, Boolean isInsert, Id accountId, Id contactId)
    {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for(Integer i = 0; i < retentionCount; i++){
            opportunityRecords.add(
                new Opportunity(
                    Name =  'retention test Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId(),
                    CloseDate = Date.today()+5,
                    Type = 'Registration',
                    StageName = 'Open',
                    Result__c = 'Not Contacted',
                    CurrencyIsoCode = 'USD',
                    Renewal_Date__c = Date.today()+10,
                    Eligible_for_Deactivation__c = True,
                    CreatedDate = Date.today(),
                    Primary_Contact__c = contactId
                )
            );
        }
        if(isInsert){
            insert opportunityRecords;
        }
        return opportunityRecords;
    }
    
    public static List<Opportunity> createOpportunityRecords(Integer count, Boolean isInsert, Id accountId) {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    Type = 'Registration',
                    StageName = 'Mailed',
                    Result__c = 'Not Contacted',
                    CurrencyIsoCode = 'USD'
                )
            );
        }
        if (isInsert) {
            insert opportunityRecords;
        }
        return opportunityRecords;
    }
    
    public static Opportunity createAndInsertOpportunityRecord(Boolean isInsert, Id accountId, String OppName, String oppType, String oppStageName, String oppResult) {
        Opportunity opportunityRecord = new Opportunity ();
        opportunityRecord.Name = OppName;
        opportunityRecord.AccountId = accountId;
        opportunityRecord.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        opportunityRecord.CloseDate = Date.today() + 5;
        opportunityRecord.Type = oppType;
        opportunityRecord.StageName = oppStageName;
        opportunityRecord.Result__c = oppResult;
        opportunityRecord.CurrencyIsoCode = 'USD';
        //opportunityRecord.Primary_Contact__r = ;
        if (isInsert) {
            insert opportunityRecord;
        }
        return opportunityRecord;
    }
    
    public static List<Opportunity> createOpportunityRecordsWithClientId(Integer count, Boolean isInsert, Id accountId, Id ClientAccountId) {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test Opportunity' + i,
                    AccountId = accountId,
                    Client_Account__c = ClientAccountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    Type = 'Registration',
                    StageName = 'Mailed',
                    CurrencyIsoCode = 'USD',
                    Priority__c = 'High'
                )
            );
        }
        if (isInsert) {
            insert opportunityRecords;
        }
        return opportunityRecords;
    }
    
    public static OpportunityContactRole createAndInsertOpportunityContactRole(Boolean isInsert, Id contactId, Id opportunityId){
        OpportunityContactRole opportunityContactRecord = new OpportunityContactRole();
        opportunityContactRecord.ContactId = contactId;
        opportunityContactRecord.OpportunityId = opportunityId;
        opportunityContactRecord.IsPrimary = true;
        if (isInsert) {
            insert opportunityContactRecord;
        }
        return opportunityContactRecord;
    }
    
    public static List<OpportunityContactRole> createOpportunityContactRole(Integer count, Boolean isInsert, Id contactId, Id opportunityId) {
        List<OpportunityContactRole> opportunityContactRecords = new List<OpportunityContactRole>();
        for (Integer i = 0; i < count; i++) {
            opportunityContactRecords.add(
                new OpportunityContactRole(
                    contactId = contactId,
                    opportunityId = opportunityId,
                    isPrimary = TRUE
                )
            );
        }
        if (isInsert) {
            insert opportunityContactRecords;
        }
        return opportunityContactRecords;
    }
    
    public static List<Opportunity> createRetentionOpportunitiesRecord(Integer count, Boolean isInsert, Id accountId) {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    Type = 'Registration',
                    StageName = 'Open',
                    Result__c = 'Not Contacted',
                    CurrencyIsoCode = 'USD'
                )
            );
        }
        if (isInsert) {
            insert opportunityRecords;
        }
        return opportunityRecords;
    }
    
    //Automated email creation test for Opportunities with a record type of 'Collections'
    public static List<Opportunity> createRetentionOptyRecordEmailTester(Integer collectionsCount, Boolean isInsert, Id accountId, List<Zuora__ZInvoice__c> invoiceRecords, Id contactId, Boolean email1, Boolean email2, Boolean email3, Boolean email4)
    {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for(Integer i = 0; i < collectionsCount; i++){
            if(email1 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Reactivation',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        //Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06'
                        
                    )
                );
            }
            else if(email2 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Reactivation',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        Sent_Email_1__c = True,
                        Send_Email_1__c = Date.today(),
                        OwnerId = '0050g000005yF06'
                    )
                );
            }
            else if(email3 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Reactivation',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today()
                        //Send_Email_3__c = Date.today()
                    )
                );
            }
            else if(email4 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Reactivation',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                        //Send_Email_4__c = Date.today()
                    )
                );
            }
            else {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'collections test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retention').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        Type = 'Reactivation',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '00570000003Ecpc',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                        //Send_Email_4__c = Date.today()
                    )
                );
            }
            if(isInsert){
                insert opportunityRecords;
            }
        }
        return opportunityRecords;
    }
    
    //Automated email creation test for Opportunities with a record type of 'Saves Downgrade'
    public static List<Opportunity> createSavesDowngradeOptyRecordEmailTester(Integer collectionsCount, Boolean isInsert, Id accountId, List<Zuora__ZInvoice__c> invoiceRecords, Id contactId, Boolean email1, Boolean email2, Boolean email3, Boolean email4)
    {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for(Integer i = 0; i < collectionsCount; i++){
            if(email1 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'Saves Downgrade test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        //Type = '',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        //Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06'
                    )
                );
            }
            else if(email2 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'Saves Downgrade test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        //Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        Sent_Email_1__c = True,
                        Send_Email_1__c = Date.today(),
                        OwnerId = '0050g000005yF06'
                        
                    )
                );
            }
            else if(email3 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'Saves Downgrade test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        //Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today()
                        //Send_Email_3__c = Date.today()
                    )
                );
            }
            else if(email4 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'Saves Downgrade test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        //Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                        //Send_Email_4__c = Date.today()
                    )
                );
            }
            else {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'Retention test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Saves Downgrade').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        //Type = 'Collection Upgrade',
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Primary_Contact__c = contactId,
                        OwnerId = '00570000003Ecpc',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                        //Send_Email_4__c = Date.today()
                    )
                );
            }
            if(isInsert){
                insert opportunityRecords;
            }
        }
        return opportunityRecords;
    }
    
    public static List<Opportunity> createOpportunityRecordsWithCampaign(Integer count, Boolean isInsert, Id accountId, Id campaignId) {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for (Integer i = 0; i < count; i++) {
            opportunityRecords.add(
                new Opportunity(
                    Name = 'test Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(),
                    CloseDate = Date.today() + 5,
                    Type = 'Registration',
                    StageName = 'Mailed',
                    Result__c = 'Not Contacted',
                    CurrencyIsoCode = 'USD',
                    CampaignId = campaignId
                )
            );
        }
        if (isInsert) {
            insert opportunityRecords;
        }
        return opportunityRecords;
    }
    
    public static List<Operator_Contractor__c> createOperatorContractorRecords(Integer count, Boolean isInsert, Id accountOperatorId, Id accountContractorId) {
        List<Operator_Contractor__c> operatorContractorRecords = new List<Operator_Contractor__c>();
        for (Integer i = 0; i < count; i++) {
            operatorContractorRecords.add(
                new Operator_Contractor__c(
                    Contractor__c = accountContractorId,
                    Start_Date__c = Date.today(),
                    Operator__c = accountOperatorId,
                    /*Contractor_Status__c = 'Test Contractor Status',*/
                    Initial_Payment_Made__c = FALSE,
                    CurrencyIsoCode = 'USD'
                )
            );
        }
        if (isInsert) {
            insert operatorContractorRecords;
        }
        return operatorContractorRecords;
    }
    
    public static Task createAndInsertTaskRecord(Boolean isInsert, String taskType, String taskSubject, Id oppId) {
        Task taskRecord = new Task();
        taskRecord.Type = taskType;
        taskRecord.Subject = taskSubject;
        taskRecord.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        taskRecord.WhatId = oppId;
        if (isInsert) {
            insert taskRecord;
        }
        return taskRecord;
    }
    
    public static List<Task> createTaskRecord(Integer count, Boolean isInsert, String taskType, String taskSubject, Id oppId) {
        List<Task> taskRecords = new List<Task>();
        for (Integer i = 0; i < count; i++) {
            taskRecords.add(
                new Task(
                    Type = taskType,
                    Subject = taskSubject,
                    RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Admin').getRecordTypeId(),
                    WhatId = oppId
                )
            );
        }
        if (isInsert) {
            insert taskRecords;
        }
        return taskRecords;
    }
    
    public static List<Task> createTaskRecordWithAccount(Integer count, Boolean isInsert, String taskType, String taskSubject, Id accountId) {
        List<Task> taskRecords = new List<Task>();
        for (Integer i = 0; i < count; i++) {
            taskRecords.add(
                new Task(
                    Type = taskType,
                    Subject = taskSubject,
                    RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Admin').getRecordTypeId(),
                    WhatId = accountId
                )
            );
        }
        if (isInsert) {
            insert taskRecords;
        }
        return taskRecords;
    }
    
    public static List<Task> createTaskRecordOnLead(Integer count, Boolean isInsert, String taskType, String taskSubject, Id leadId) {
        List<Task> taskRecords = new List<Task>();
        for (Integer i = 0; i < count; i++) {
            taskRecords.add(
                new Task(
                    Type = taskType,
                    Subject = taskSubject,
                    RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Admin').getRecordTypeId(),
                    WhoId = leadId
                )
            );
        }
        if (isInsert) {
            insert taskRecords;
        }
        return taskRecords;
    }
    
    public static List<Lead> createLeads(Integer count, Boolean isInsert) {
        List<Lead> leadRecords = new List<Lead>();
        for (Integer i = 0; i < count; i++) {
            leadRecords.add(
                new Lead(
                    Status = 'Attempting',
                    LastName = 'Test Lead',
                    Company = 'Lead Company',
                    Email = 'test@avetta.com',
                    Calls_Made__c = 1,
                    Emails_Sent__c = 1,
                    Country = 'US'
                )
            );
        }
        if (isInsert) {
            insert leadRecords;
        }
        return leadRecords;
    }
    
    public static List<Lead> createLeads(Integer count, Boolean isInsert, List<String> stateList, List<String> countryHQ, Id ownerId,List<String> country, List<String> countryCode) {
        List<Lead> leadRecords = new List<Lead>();
        for (Integer i = 0; i < count; i++) {
            leadRecords.add(
                new Lead(
                    RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Field Sales').getRecordTypeId(),
                    Status = 'Urgent',
                    LastName = 'Test Lead',
                    Named_Lead__c = false,
                    Company = 'Lead Company ' + i,
                    Email = 'test@avetta.com' + i,
                    Calls_Made__c = 1,
                    Emails_Sent__c = 1,
                    CompanyHQState__c = stateList[i],
                    Company_HQ_Country__c = countryHQ[i],
                    State = 'Utah',
                    OwnerId = ownerId,
                    Country = country[i],
                    Country_Code__c = countryCode[i]
                )
            );
        }
        if (isInsert) {
            insert leadRecords;
        }
        return leadRecords;
    }

    public static List<Lead> createNoramLeads(Integer count, Boolean isInsert, List<String> stateList, List<String> countryHQ, Id ownerId,List<String> country, List<String> countryCode) {
        List<Lead> leadRecords = new List<Lead>();
        for (Integer i = 0; i < count; i++) {
            leadRecords.add(
                    new Lead(
                            RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Field Sales').getRecordTypeId(),
                            Status = 'Urgent',
                            LastName = 'Test NORAM Lead',
                            Named_Lead__c = false,
                            Company = 'Lead Company ' + i,
                            Email = 'test@avetta.com' + i,
                            Calls_Made__c = 1,
                            Emails_Sent__c = 1,
                            CompanyHQState__c = stateList[i],
                            Company_HQ_Country__c = countryHQ[i],
                            State = 'Utah',
                            OwnerId = ownerId,
                            Country = country[i],
                            Country_Code__c = countryCode[i]

                    )
            );
        }
        if (isInsert) {
            insert leadRecords;
        }
        return leadRecords;
    }

    public static List<Lead> createAPACLeads(Integer count, Boolean isInsert, List<String> countryHQ, Id ownerId,List<String> country, List<String> countryCode) {
        List<Lead> leadRecords = new List<Lead>();
        for (Integer i = 0; i < count; i++) {
            leadRecords.add(
                    new Lead(
                            RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Field Sales').getRecordTypeId(),
                            Status = 'Urgent',
                            LastName = 'Test APAC Lead',
                            Named_Lead__c = false,
                            Company = 'Lead Company ' + i,
                            Email = 'test@avetta.com' + i,
                            Calls_Made__c = 1,
                            Emails_Sent__c = 1,
                            Company_HQ_Country__c = countryHQ[i],
                            OwnerId = ownerId,
                            Country = country[i],
                            Country_Code__c = countryCode[i]

                    )
            );
        }
        if (isInsert) {
            insert leadRecords;
        }
        return leadRecords;
    }
    
    public static List<Related_Client_Case__c> createRelatedClientCases(Integer count, Boolean isInsert, List<Account> clientAccounts, Id caseId) {
        List<Related_Client_Case__c> relatedClientCaseRecords = new List<Related_Client_Case__c>();
        for (Integer i = 0; i < count; i++) {
            relatedClientCaseRecords.add(
                new Related_Client_Case__c(
                    CurrencyIsoCode = 'USD',
                    Related_Client__c = clientAccounts[i].Id,
                    Related_Case__c = caseId
                )
            );
            System.debug('******** inside insert');
        }
        System.debug('relatedClientCaseRecords = ' + relatedClientCaseRecords);
        if (isInsert) {
            insert relatedClientCaseRecords;
            System.debug('insert relatedClientCaseRecords');
        }
        return relatedClientCaseRecords;
    }
    
    public static List<Zuora__ZInvoice__c> createInvoiceRecord(Integer count, Boolean isInsert, Id accountId, Id billingAccountId) {
        List<Zuora__ZInvoice__c> invoiceRecords = new List<Zuora__ZInvoice__c>();
        for (Integer i = 0; i < count; i++) {
            invoiceRecords.add(
                new Zuora__ZInvoice__c(
                    Zuora__Account__c = accountId,
                    Zuora__BillingAccount__c = billingAccountId,
                    Zuora__Balance2__c = roundRobinOpportunity.getRandomNumber(100000) + 1
                )
            );
        }
        if (isInsert) {
            insert invoiceRecords;
        }
        return invoiceRecords;
    }
    
    public static List<Zuora__CustomerAccount__c> createBillingAccountRecord(Integer count, Boolean isInsert, Id accountId) {
        List<Zuora__CustomerAccount__c> billingAccountRecord = new List<Zuora__CustomerAccount__c>();
        for (Integer i = 0; i < count; i++) {
            billingAccountRecord.add(
                new Zuora__CustomerAccount__c(
                    Zuora__Account__c = accountId
                )
            );
        }
        if (isInsert) {
            insert billingAccountRecord;
        }
        return billingAccountRecord;
    }
    
    public static List<User> createUserRecords(Integer count, Boolean isInsert) {
        List<User> owner = new List<User>();
        for (Integer i = 0; i < count; i++) {
            owner.add(
                new User(
                    LastName = 'test user' + i,
                    Alias = 'tuser' + i,
                    Email = 'test@email123.com' + i,
                    Username = 'test@email123.com' + i,
                    CommunityNickname = 'test@email123.com',
                    UserRoleId = '00E70000001A0wA',
                    ProfileId = '00e70000001974L',
                    EmailEncodingKey = 'UTF-8',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US',
                    DefaultCurrencyIsoCode = 'USD',
                    isActive = TRUE
                )
            );
        }
        if (isInsert) {
            insert owner;
        }
        return owner;
    }
    
    public static List<User> createUserRecords(Integer count, Boolean isInsert, String name) {
        List<User> owner = new List<User>();
        for (Integer i = 0; i < count; i++) {
            owner.add(
                new User(
                    LastName = name,
                    Alias = 'tuser' + i,
                    Email = 'test@email123.com' + i,
                    Username = 'test@email123.com' + i,
                    CommunityNickname = 'test@email123.com',
                    UserRoleId = '00E70000001A0wA',
                    ProfileId = '00e70000001974L',
                    EmailEncodingKey = 'UTF-8',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US',
                    DefaultCurrencyIsoCode = 'USD',
                    isActive = TRUE
                )
            );
        }
        if (isInsert) {
            insert owner;
        }
        return owner;
    }
    
    public static List<User> createUserRecords(Integer count, Boolean isInsert, Id profileId, Id userRoleId) {
        List<User> owner = new List<User>();
        for (Integer i = 0; i < count; i++) {
            owner.add(
                new User(
                    LastName = 'test user' + i,
                    Alias = 'tuser' + i,
                    Email = 'test@email123.com' + i,
                    Username = 'test@email123.com' + i,
                    CommunityNickname = 'test@email123.com' + i,
                    UserRoleId = userRoleId,
                    ProfileId = profileId,
                    EmailEncodingKey = 'UTF-8',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US',
                    DefaultCurrencyIsoCode = 'USD',
                    IsActive = TRUE

                )
            );
        }
        if (isInsert) {
            insert owner;
        }
        return owner;
    }
    
    public static List<Rep__c> createRepRecords(Integer count, Boolean isInsert, List<Region__c> regionList, List<User> userList) {
        List<Rep__c> rep = new List<Rep__c>();
        Integer r = 0;
        for (Integer i = 0; i < count; i++) {
            if(r > regionList.size() - 1) {
                r = 0;
            }
            rep.add(
                new Rep__c(
                    Distribution_Weight__c = 1,
                    Name = userList[i].Name,
                    Out_Of_Office__c = FALSE,
                    RecordTypeId = Schema.SObjectType.Rep__c.getRecordTypeInfosByName().get('SDR').getRecordTypeId(),
                    Region__c = regionList[r].Id,
                    User__c = userList[i].Id
                )
            );
            r++;
        }
        if (isInsert) {
            insert rep;
        }
        return rep;
    }
    
    public static List<Region__c> createRegionRecords(Integer count, Boolean isInsert, List<String> regionNames) {
        List<Region__c> regions = new List<Region__c>();
        for (Integer i = 0; i < count; i++) {
            regions.add(
                new Region__c(
                    Name = regionNames[i],
                    Round_Robin_Variable__c = 0,
                    global_Region__c = 'NORAM'
                )
            );
        }
        if (isInsert) {
            insert regions;
        }
        return regions;
    }
    
    public static List<State__c> createSDRStateRecords(Integer count, Boolean isInsert, List<String> abbreviationList, List<String> stateNameList, List<Region__c> regionList) {
        List<State__c> states = new List<State__c>();
        for (Integer i = 0; i < count; i++) {
            states.add(
                new State__c(
                    Abbreviation__c = abbreviationList[i],
                    Name = stateNameList[i],
                    Region__c = regionList[i].Id
                )
            );
        }
        if (isInsert) {
            insert states;
        }
        return states;
    }
    
    //Automated email creation test for Opportunities with a record type of 'MYM'
    public static List<Opportunity> createMYMOptyRecordEmailTester(Integer collectionsCount, Boolean isInsert, Id accountId, List<Zuora__ZInvoice__c> invoiceRecords, Id contactId, Boolean email1, Boolean email2, Boolean email3, Boolean email4)
    {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for(Integer i = 0; i < collectionsCount; i++){
            if(email1 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'MYM test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MYM').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        //Primary_Contact__c = contactId,
                        OwnerId = '0050g000005yF06'
                        
                    )
                );
            }
            else if(email2 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'MYM test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MYM').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        Sent_Email_1__c = True,
                        Send_Email_1__c = Date.today(),
                        OwnerId = '0050g000005yF06'
                    )
                );
            }
            else if(email3 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'MYM test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MYM').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today()
                        //Send_Email_3__c = Date.today()
                    )
                );
            }
            else if(email4 == TRUE) {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'MYM test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MYM').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        OwnerId = '0050g000005yF06',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                        //Send_Email_4__c = Date.today()
                    )
                );
            }
            else {
                opportunityRecords.add(
                    new Opportunity(
                        Name =  'MYM test Opportunity' + i,
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MYM').getRecordTypeId(),
                        CloseDate = Date.today()+5,
                        StageName = 'Open',
                        CreatedDate = Date.today(),
                        OwnerId = '00570000003Ecpc',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                        //Send_Email_4__c = Date.today()
                    )
                );
            }
            if(isInsert){
                insert opportunityRecords;
            }
        }
        return opportunityRecords;
    }
    
    public static List<Opportunity> createMYMOpportunityRecords(Integer count, Boolean isInsert, Id accountId, Id clientAccountId)
    {
        List<Opportunity> opportunityRecords = new List<Opportunity>();
        for(Integer i = 0; i < count; i++){
            opportunityRecords.add(
                new Opportunity(
                    Name =  'test Opportunity' + i,
                    AccountId = accountId,
                    RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MYM').getRecordTypeId(),
                    CloseDate = Date.today()+5,
                    StageName = 'Commit',
                    MYM_Discount__c = 5,
                    Price_Quoted__c = 1,
                    Term_Length__c = '3 Year'
                )
            );
        }
        if(isInsert){
            insert opportunityRecords;
        }
        return opportunityRecords;
    }
    
    public static List<talkdesk__Talkdesk_Activity__c> createTalkDeskActivityRecord(Integer count, Boolean isInsert, Id accountId, Id caseId, Id contactId)
    {
        List<talkdesk__Talkdesk_Activity__c> talkdeskActivitiesRecord = new List<talkdesk__Talkdesk_Activity__c>();
        for(Integer i = 0; i < count; i++){
            talkdeskActivitiesRecord.add(
                new talkdesk__Talkdesk_Activity__c(
                    Name = 'Test Activity',
                    talkdesk__Account__c = accountId,
                    talkdesk__Case__c = caseId,
                    talkdesk__Contact__c = contactId,
                    talkdesk__Talkdesk_Id__c = '123495259'
                )
            );
        }
        if(isInsert){
            insert talkdeskActivitiesRecord;
        }
        return talkdeskActivitiesRecord;
    }

    public static List<EmailMessage> createEmailMessage(Integer count, Boolean isInsert, Id caseId, Id accountId)
    {
        List<EmailMessage> emailMessage = new List<EmailMessage>();
        for(Integer i = 0; i < count; i++) {
            emailMessage.add(
                    new EmailMessage(
                        RelatedToId = accountId,
                        NewCase__c = caseId                    
                    )
            );
        }
     
        return emailMessage;
    }

    public static List<LiveChatTranscript> createChatTranscriptRecord(Integer count, Boolean isInsert, Id caseId, Id accountId, Id contactId)
    {
        List<LiveChatTranscript> chatTranscriptRecord = new List<LiveChatTranscript>();
        for(Integer i = 0; i < count; i++) {
            chatTranscriptRecord.add(
                    new LiveChatTranscript(
                        CaseId    = caseId,
                        AccountId = accountId,
                        ContactId = contactId
                    )
            );
        }
        if(isInsert){
            insert chatTranscriptRecord;
        }
        return chatTranscriptRecord;
    }

    public static List<LiveChatVisitor> createChatVisitorRecord(Integer count, Boolean isInsert){
        List<LiveChatVisitor> chatVisitorRecord = new List<LiveChatVisitor>();
        for(Integer i = 0; i < count; i++) {
            chatVisitorRecord.add(
                    new LiveChatVisitor(
                            CreatedDate = Datetime.now()
                    )
            );
        }
        if(isInsert){
            insert chatVisitorRecord;
        }
        return chatVisitorRecord;
    }

    public static List<talkdesk__Talkdesk_Activity__c> createTalkDeskActivityRecordOnLead(Integer count, Boolean isInsert, Id leadId)
    {
        List<talkdesk__Talkdesk_Activity__c> talkdeskActivitiesRecord = new List<talkdesk__Talkdesk_Activity__c>();
        for(Integer i = 0; i < count; i++){
            talkdeskActivitiesRecord.add(
                new talkdesk__Talkdesk_Activity__c(
                    Name = 'Test Activity',
                    talkdesk__Lead__c = leadId,
                    talkdesk__Talkdesk_Id__c = '123495259',
                    talkdesk__Type__c = 'Outbound'
                )
            );
        }
        if(isInsert){
            insert talkdeskActivitiesRecord;
        }
        return talkdeskActivitiesRecord;
    }
    
    public static List<Case> createVetifyCaseRecordEmailTester(Integer count, Boolean isInsert, Id accountId, Id contactId, Boolean email1, Boolean email2, Boolean email3, Boolean email4, Boolean email5, Boolean vetifyLegacy)
    {
        List<Case> caseRecords = new List<Case>();
        for(Integer i = 0; i < count; i++){
            if(email1 == TRUE && vetifyLegacy == FALSE) {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        //ContactId = contactId
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone'
                    )
                );
            }
            else if(email2 == TRUE && vetifyLegacy == FALSE) {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        ContactId = contactId,
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone',
                        Send_Email_1__c = Date.today(),
                        Sent_Email_1__c = TRUE
                    )
                );
            }
            else if(email3 == TRUE && vetifyLegacy == FALSE) {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        ContactId = contactId,
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today()
                    )
                );
            }
            else if(email4 == TRUE && vetifyLegacy == FALSE) {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        ContactId = contactId,
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                    )
                );
            }
            else if(email5 == TRUE && vetifyLegacy == FALSE) {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        ContactId = contactId,
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Sent_Email_4__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today(),
                        Send_Email_4__c = Date.today()
                    )
                );
            }
            else if(email1 == TRUE && vetifyLegacy == TRUE) {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        ContactId = contactId,
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone',
                        Vetify_Legacy__c = TRUE
                    )
                );
            }
            else if(email2 == TRUE && vetifyLegacy == TRUE) {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        ContactId = contactId,
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone',
                        Vetify_Legacy__c = TRUE,
                        Send_Email_1__c = Date.today(),
                        Sent_Email_1__c = TRUE
                    )
                );
            }
            else if(email3 == TRUE && vetifyLegacy == TRUE) {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        ContactId = contactId,
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone',
                        Vetify_Legacy__c = TRUE,
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today()
                    )
                );
            }
            else if(email4 == TRUE && vetifyLegacy == TRUE) {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        ContactId = contactId,
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Vetify_Legacy__c = TRUE,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                    )
                );
            }
            else {
                caseRecords.add(
                    new Case(
                        AccountId = accountId,
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vetify').getRecordTypeId(),
                        ContactId = contactId,
                        Type = 'Fulfillment',
                        Status = 'Pending',
                        Origin = 'Phone',
                        Sent_Email_1__c = True,
                        Sent_Email_2__c = True,
                        Sent_Email_3__c = True,
                        Send_Email_1__c = Date.today(),
                        Send_Email_2__c = Date.today(),
                        Send_Email_3__c = Date.today()
                        //Send_Email_4__c = Date.today()
                    )
                );
            }
            if(isInsert){
                insert caseRecords;
            }
        }
        return caseRecords;
    }
    
    public static List<User> getUsersByProfile(String profileName) {
        List<User> user = [select id from user where Profile.Name = :profileName];
        
        return user;
    }
    
    public static List<Supplier_Staging_Convert__mdt> createMetadata(Boolean isInsert) {
        List<Supplier_Staging_Convert__mdt> data = new List<Supplier_Staging_Convert__mdt>();
        data = [
            Select FromFieldName__c, FromObjectName__c, ToFieldName__c, ToObjectName__c
            From Supplier_Staging_Convert__mdt
        ] ;
        
        
        return data;
        
    }
    
    public static SIT_Settings__c createSITCustomSetting(Boolean isInsert) {
        SIT_Settings__c sitSetting = new SIT_Settings__c();
        sitSetting =
            new SIT_Settings__c(
                Name = 'General SIT',
                Default_Opportunity_Owner__c = [select id from User where IsActive = TRUE AND UserType != 'Guest' limit 1].id,
                Num_Days_For_Commission__c = 14,
                Batch_Size__c = 50
            );
        
        
        if (isInsert) {
            insert sitSetting;
        }
        return sitSetting;
    }
}