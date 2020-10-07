/**
 * Created by JasonMcGrew on 9/6/2019.
 * 
 * Apex Test Class for CommunitiesNewUserCreation_Batch.
 * 
 **/

@IsTest private class CommunitiesNewUserCreation_BatchTest {

    @IsTest static void newCommunityUser() {

        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        List<User> userList = new List<User>();

        Profile p = [
                SELECT Id
                FROM Profile
                WHERE Name = 'System Administrator'
        ];

        UserRole portalRole = [
                SELECT Id
                FROM UserRole
                WHERE Name = 'Administration'
                LIMIT 1
        ];

        User u = new User(
                Alias             = 'standt',
                Email             = 'standarduser@testorg.com',
                EmailEncodingKey  = 'UTF-8',
                LastName          = 'Testing',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey      = 'en_US',
                ProfileId         = p.Id,
                TimeZoneSidKey    = 'America/Los_Angeles',
                Username          = 'systemAdminUser@sftest.com',
                UserRoleId        = portalRole.Id

        );
        insert u;

        System.runAs(u) {

/*            Account existingContractorAccount = new Account(
                    Name = 'test existingContractorAccount',
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(),
                    Status__c = 'Active',
                    Organizer_ID__c = String.valueOf(1111119),
                    BillingCountry = 'US',
                    BillingState = 'UT',
                    tz__Timezone_SFDC__c = 'America/Denver'
            );
            accList.add(existingContractorAccount);

            Account existingOperatorAccount = new Account(
                    Name = 'test existingOperatorAccount',
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(),
                    Status__c = 'Active',
                    Organizer_ID__c = String.valueOf(999991),
                    BillingCountry = 'US',
                    BillingState = 'UT',
                    tz__Timezone_SFDC__c = 'America/Denver'
            );
            accList.add(existingOperatorAccount);*/

            Account userAccount1 = new Account(
                    Name = 'test account6',
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(),
                    Status__c = 'Active',
                    Organizer_ID__c = String.valueOf(98435183),
                    BillingCountry = 'US',
                    BillingState = 'UT',
                    tz__Timezone_SFDC__c = 'America/Denver'
            );
            accList.add(userAccount1);

            Account userAccount2 = new Account(
                    Name = 'test account 7',
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(),
                    Status__c = 'Active',
                    Organizer_ID__c = String.valueOf(98435182),
                    BillingCountry = 'US',
                    BillingState = 'UT',
                    tz__Timezone_SFDC__c = 'America/Denver'
            );
            accList.add(userAccount2);

            insert accList;

/*            Contact existingSupplierContact = new Contact(
                    AccountId = existingContractorAccount.Id,
                    FirstName = 'One1',
                    LastName = 'test existingContact',
                    Account_Type__c = 'Contractor',
                    CurrencyIsoCode = 'USD',
                    Phone = '619-000-0001',
                    Email = 'existingSupplierContact@sftest.com',
                    Organizer_isActive__c = 'Yes',
                    Organizer_Last_Login__c = Date.today(),
                    Primary_PICS_Organizer_User__c = true,
                    Organizer_User_ID__c = String.valueOf(1111119)

            );
            conList.add(existingSupplierContact);

            Contact existingOperatorContact = new Contact(
                    AccountId = existingOperatorAccount.Id,
                    FirstName = 'One1',
                    LastName = 'test existingOperatorContact',
                    Account_Type__c = 'Contractor',
                    CurrencyIsoCode = 'USD',
                    Phone = '619-000-0001',
                    Email = 'existingOperatorContact@sftest.com',
                    Organizer_isActive__c = 'Yes',
                    Organizer_Last_Login__c = Date.today(),
                    Primary_PICS_Organizer_User__c = true,
                    Organizer_User_ID__c = String.valueOf(999991)

            );
            conList.add(existingOperatorContact);*/

            Contact accContact1 = new Contact(
                    AccountId = userAccount1.Id,
                    FirstName = 'One1',
                    LastName = 'test contact1.1',
                    Account_Type__c = 'Contractor',
                    CurrencyIsoCode = 'USD',
                    Phone = '619-000-0001',
                    Email = 'test@sftest4.com',
                    Organizer_isActive__c = 'Yes',
                    Organizer_Last_Login__c = Date.today(),
                    Primary_PICS_Organizer_User__c = true,
                    Organizer_User_ID__c = String.valueOf(98435183)
            );
            conList.add(accContact1);

            Contact accContact2 = new Contact(
                    AccountId = userAccount2.Id,
                    FirstName = 'Two2',
                    LastName = 'test contact2.2',
                    Account_Type__c = 'Operator',
                    CurrencyIsoCode = 'USD',
                    Phone = '619-000-0001',
                    Email = 'test@sftest5.com',
                    Organizer_isActive__c = 'Yes',
                    Organizer_Last_Login__c = Date.today(),
                    Primary_PICS_Organizer_User__c = true,
                    Organizer_User_ID__c = String.valueOf(98435182)
            );
            conList.add(accContact2);

            System.debug('***** accList = ' + accList);
            System.debug('***** conList = ' + conList);

            insert conList;

            List<Id> conIds = new List<Id>();

            for (Contact con : conList) {
                conIds.add(con.Id);
            }
            System.debug(' ***conIds = ' + conIds);
/*
            Profile sProfile = [
                    SELECT Id
                    FROM Profile
                    WHERE Name = 'Supplier Community Login'
            ];

            Profile cProfile = [
                    SELECT Id
                    FROM Profile
                    WHERE Name = 'Client Community Login'
            ];

            User existingSupplierUser = new User(
                    LastName          = existingSupplierContact.LastName,
                    FirstName         = existingSupplierContact.FirstName,
                    Alias             = existingSupplierContact.FirstName.left(1) + existingSupplierContact.LastName.left(4),
                    ContactId         = existingSupplierContact.Id,
                    CompanyName       = existingSupplierContact.Account.Name,
                    ProfileId         = sProfile.Id,
                    Username          = existingSupplierContact.Email,
                    TimeZoneSidKey    = 'America/Denver',
                    EmailEncodingKey  = 'UTF-8',
                    IsActive          = false,
                    Email             = existingSupplierContact.Email,
                    CurrencyIsoCode   = 'USD',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey      = 'en_US'
            );
            userList.add(existingSupplierUser);

            User existingClientUser = new User(
                    LastName          = existingOperatorContact.LastName,
                    FirstName         = existingOperatorContact.FirstName,
                    Alias             = existingOperatorContact.FirstName.left(1) + existingOperatorContact.LastName.left(4),
                    ContactId         = existingOperatorContact.Id,
                    CompanyName       = existingOperatorContact.Account.Name,
                    ProfileId         = cProfile.Id,
                    Username          = existingOperatorContact.Email,
                    TimeZoneSidKey    = 'America/Denver',
                    EmailEncodingKey  = 'UTF-8',
                    IsActive          = false,
                    Email             = existingOperatorContact.Email,
                    CurrencyIsoCode   = 'USD',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey      = 'en_US'
            );
            userList.add(existingClientUser);

            System.debug('***** userList = ' + userList.size());

            insert userList;*/

            Test.startTest();
            CommunitiesNewUserCreation_Batch b = new CommunitiesNewUserCreation_Batch();
            Database.executeBatch(b, 10);
            Test.stopTest();

            List<User> newSupplierUser = [
                    SELECT ContactId, LastName
                    FROM User
                    WHERE ContactId =: conIds
                    AND Profile.Name = 'Supplier Community Login'
                    AND IsActive = TRUE
            ];
            System.debug(newSupplierUser);

            List<User> newClientUser = [
                    SELECT ContactId, LastName
                    FROM User
                    WHERE ContactId =: conIds
                    AND Profile.Name = 'Client Community Login'
                    AND IsActive = TRUE
            ];

            System.assertEquals('test contact1.1', newSupplierUser[0].LastName);
            System.assertEquals('test contact2.2', newClientUser[0].LastName);
        }
    }
}