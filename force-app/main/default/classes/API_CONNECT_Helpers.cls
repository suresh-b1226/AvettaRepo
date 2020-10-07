/**
 * Created by brett on 5/31/18.
 */

public with sharing class API_CONNECT_Helpers {


    public class ApiConnectException extends Exception {
    }


    public static void logException(Exception e) {
        System.debug('Exception type caught: ' + e.getTypeName());
        System.debug('Message: ' + e.getMessage());
        System.debug('Cause: ' + e.getCause());    // returns null
        System.debug('Line number: ' + e.getLineNumber());
        System.debug('Stack trace: ' + e.getStackTraceString());
    }


    public static Contractor_Match__c getContractorMatch(string matchId) {
        System.debug('START: getContractorMatch');
        System.debug(matchId);

        Contractor_Match__c match;

        try {
            match = [
                    SELECT
                            Account__c,
                            accountName__c,
                            accountRecordType__c,
                            accountRecordTypeId__c,
                            accountStatus__c,
                            additionalBoolean1__c,
                            additionalDate1__c,
                            additionalText1__c,
                            additionalText2__c,
                            All_Matches__c,
                            billable__c,
                            billableEntityId__c,
                            City__c,
                            country__c,
                            CurrencyIsoCode,
                            DBAName__c,
                            fax__c,
                            Global_Parent__c,
                            globalAccountId__c,
                            Id,
                            IsDeleted,
                            Name,
                            OrganizerId__c,
                            OwnerId,
                            parentAccountId__c,
                            payingFacilities__c,
                            Phone_Number__c,
                            postalCode__c,
                            preferredLang__c,
                            registrationDate__c,
                            state__c,
                            street__c,
                            SUID__c,
                            taxId__c,
                            webUrl__c,
                            firstName__c,
                            lastName__c,
                            Deadline__c
                    FROM Contractor_Match__c
                    WHERE Id = :matchId
            ];
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }

        System.debug(match);


        System.debug('END: getContractorMatch');
        return match;
    }

    public static Account insertContractorAccount(Contractor_Match__c match) {

        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        Account parentAccount;
        Account globalAccount;
        String suid;
        String OrganizerId;
        Id billableEntityId;

        Account account = new Account();

        API_Settings__c APISettings = API_Settings__c.getInstance('Update Account API');

        String accountName = match.accountName__c;

        if (String.isBlank(accountName)) {
            accountName = match.Name;
        }

        if (String.isBlank(accountName)) {
            accountName = match.OrganizerId__c;
        }

        if (String.isBlank(accountName)) {

            If (String.isBlank(match.firstName__c) == false || String.isBlank(match.lastName__c) == false)
                accountName = match.firstName__c + ' ' + match.lastName__c;
        }

        if (String.isBlank(accountName)) {
            accountName = match.email__c;
        }

        if (String.isBlank(accountName)) {
            accountName = match.webUrl__c;
        }

        if (match.accountRecordType__c == 'Client') {
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        }

        account.Organizer_ID__c = match.OrganizerId__c;
        account.RecordTypeId = recordTypeId;
        account.type = match.accountRecordTypeId__c;
        account.Name = accountName;
        account.phone = match.phone_Number__c;
        account.Website = match.webUrl__c;
        account.Status__c = match.accountStatus__c;
        account.BillingStreet = match.street__c;
        account.BillingCity = match.City__c;
        account.BillingState = match.state__c;
        account.BillingPostalCode = match.postalCode__c;
        account.BillingCountry = match.country__c;
        account.Registration_Date__c = (Date) match.registrationDate__c;
        account.fax = match.fax__c;
        account.DBA_Name__c = match.DBAName__c;
        account.Preferred_Language__c = match.preferredLang__c;
        if (match.accountRecordType__c == 'Client') {
            account.IsBillable__c = match.billable__c;
            if (parentAccount != NULL) account.ParentId = parentAccount.Id;
            if (globalAccount != NULL) account.Global_Parent__c = globalAccount.Id;

        } else {
            account.Paying_Facilities__c = match.payingFacilities__c;
            account.Tax_ID__c = match.taxId__c;
        }

        if (billableEntityId != null) account.Billable_Entity__c = billableEntityId;


        if (match.additionalText1__c != Null) account.put(APISettings.additionalText1__c, match.additionalText1__c);
        if (match.additionalText2__c != Null) account.put(APISettings.additionalText2__c, match.additionalText2__c);
        if (match.additionalDate1__c != Null) account.put(APISettings.additionalDate1__c, Date.valueOf(match.additionalDate1__c));
        if (match.additionalBoolean1__c) account.put(APISettings.additionalBoolean1__c, match.additionalBoolean1__c);

        System.debug ('Inserting the acount:' + account);

        try {
            insert account;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }

        return account;
    }

    public static Contact insertContractorContact(Contractor_Match__c match) {

        Contact c = new Contact();

        c.FirstName = match.firstName__c;
        c.LastName = match.lastName__c;
        c.Email = match.email__c;
        c.Phone = match.phone_Number__c;
        c.AccountId = match.Account__c;
        c.Organizer_User_ID__c = match.Contact_Organizer_Id__c;


        System.debug ('Inserting the contact:' + c);

        try {
            insert c;


            Account a = new Account(Id = match.Account__c, Primary_Contact__c = c.Id);


            upsert a;

//            a.Primary_Contact__r = c;
//            update a;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }

        return c;
    }

    public static void updateAccount(Account a, Contractor_Match__c match) {

        Id recordTypeId;
        Account parentAccount;
        Account globalAccount;
        String suid;
        String OrganizerId;
        Id billableEntityId;

        API_Settings__c APISettings = API_Settings__c.getInstance('Update Account API');

        if (match.accountRecordType__c == 'Supplier') {
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        } else if (match.accountRecordType__c == 'Client') {
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        } else {

            throw new ApiConnectException('ERROR: Invalid Account Type. Expected: Supplier or Client. Received: ' + match.accountRecordType__c);
        }


        // retrieve the Salesforce parentId using the Organizer Id
        if (match.parentAccountId__c != NULL) {
            System.debug('trying to find the parent account id' + match.parentAccountId__c);
            try {
                parentAccount = [
                        SELECT id, Organizer_ID__c
                        FROM Account
                        WHERE organizer_id__c = :match.parentAccountId__c
                ];
                System.debug('found parent account id' + parentAccount);
            } catch (Exception e) {
                API_CONNECT_Helpers.logException(e);
                if (parentAccount == Null) {

                    throw new ApiConnectException('ERROR: Invalid Parent Account Id: Account Not found: ' + match.parentAccountId__c);
                }
            }
        }

        // retrieve the Salesforce globalId using the Organizer Id
        if (match.globalAccountId__c != NULL) {
            System.debug('trying to find the global account id' + match.globalAccountId__c);

            try {
                globalAccount = [
                        SELECT id, Organizer_ID__c
                        FROM Account
                        WHERE organizer_id__c = :match.globalAccountId__c
                ];
                System.debug('found global account id' + globalAccount);
            } catch (Exception e) {
                API_CONNECT_Helpers.logException(e);
                if (globalAccount == Null) {
                    throw new ApiConnectException('ERROR: Invalid Global Account Id: Account Not found: ' + match.globalAccountId__c);
                }
            }
        }

        // retrieve the Salesforce Id odf the Billable Entity using the Organizer Id if provided
        if (match.billableEntityId__c != null) {
            System.debug('trying to find the Billable Entity account id' + match.billableEntityId__c);

            try {
                billableEntityId = [
                        SELECT Id
                        FROM Account
                        WHERE Organizer_ID__c = :match.billableEntityId__c
                ].Id;

                System.debug('found Billable Entity account id' + billableEntityId);
            } catch (Exception e) {
                API_CONNECT_Helpers.logException(e);
                if (billableEntityId == null) {
                    throw new ApiConnectException('ERROR: Invalid Billable Entity Id: Account Not found: ' + match.billableEntityId__c);
                }
            }

        }


        if (match.additionalText1__c != NULL) {
            if (APISettings.additionalText1__c == NULL) {
                throw new ApiConnectException('ERROR: additionalText1 passed, but not set in the APISettings');
            }

        }

        if (match.additionalText2__c != NULL) {
            if (APISettings.additionalText2__c == NULL) {
                throw new ApiConnectException('ERROR:  additionalText2 passed, but not set in the APISettings');
            }
        }

        if (match.additionalDate1__c != NULL) {
            if (APISettings.additionalDate1__c == NULL) {
                throw new ApiConnectException('ERROR:  additionalDate1 passed, but not set in the APISettings');
            }
        }

        if (match.additionalBoolean1__c == true) {
            if (APISettings.additionalBoolean1__c == NULL) {
                throw new ApiConnectException('ERROR:  additionalBoolean1 passed, but not set in the APISettings');
            }
        }


        if (a.Organizer_ID__c == NULL) a.Organizer_ID__c = match.OrganizerId__c;
        if (match.accountName__c != NULL) a.Name = match.accountName__c;
        if (match.phone_Number__c != NULL) a.phone = match.phone_Number__c;
        if (match.webUrl__c != NULL) a.Website = match.webUrl__c;
        if (match.accountStatus__c != NULL) a.Status__c = match.accountStatus__c;
        if (match.street__c != NULL) a.BillingStreet = match.street__c;
        if (match.city__c != NULL) a.BillingCity = match.city__c;
        if (match.state__c != NULL) a.BillingState = match.state__c;
        if (match.postalCode__c != NULL) a.BillingPostalCode = match.postalCode__c;
        if (match.country__c != NULL) a.BillingCountry = match.country__c;
        if (match.registrationDate__c != NULL) a.Registration_Date__c = (Date) match.registrationDate__c;
        if (match.preferredLang__c != NULL) a.Preferred_Language__c = match.preferredLang__c;
        if (match.fax__c != NULL) a.fax = match.fax__c;
        if (match.DBAName__c != NULL) a.DBA_Name__c = match.DBAName__c;
        if (match.AccountRecordType__c == 'Client') {
            if (match.billable__c != NULL) a.IsBillable__c = match.billable__c;
            if (parentAccount != NULL) a.ParentId = parentAccount.Id;
            if (globalAccount != NULL) a.Global_Parent__c = globalAccount.Id;
        } else {
            // Contractor
            if (match.payingFacilities__c != NULL) a.Paying_Facilities__c = match.payingFacilities__c;
            if (match.taxId__c != NULL) a.Tax_ID__c = match.taxId__c;
        }

        if (billableEntityId != null) a.Billable_Entity__c = billableEntityId;


        if (match.additionalText1__c != Null) a.put(APISettings.additionalText1__c, match.additionalText1__c);
        if (match.additionalText2__c != Null) a.put(APISettings.additionalText2__c, match.additionalText2__c);
        if (match.additionalDate1__c != Null) a.put(APISettings.additionalDate1__c, Date.valueOf(match.additionalDate1__c));
        if (match.additionalBoolean1__c == true) a.put(APISettings.additionalBoolean1__c, match.additionalBoolean1__c);


        System.debug ('updating the acount:' + a);

        Database.update (a);
    }

    public static Opportunity insertOpportunityFromMatch(Contractor_Match__c match) {

        Opportunity opportunity = new Opportunity();
        Account requestByAccount;
        try {
            requestByAccount = [
                    SELECT
                            Id,
                            Name
                    From
                            Account
                    WHERE
                    Organizer_ID__c = :match.requestedBy__c
                    AND
                    RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId()
                    LIMIT 1
            ];
        } catch (Exception e) {

        }

        Account opportunityAccount;

        if (match.Account__c == null) {
            opportunityAccount = new Account();
            opportunityAccount.Name = match.accountName__c;
            opportunityAccount.RecordTypeId = match.accountRecordTypeId__c;
            opportunityAccount.Status__c = 'Requested';
        } else {

            opportunityAccount = [
                    SELECT
                            Id,
                            Name
                    From
                            Account
                    WHERE
                            Id = :match.Account__c
                    LIMIT 1
            ];
        }

        upsert opportunityAccount;

        if (match.Contact__c == null) {
            Contact contact = new Contact();
            contact.FirstName = match.firstName__c;
            contact.LastName = match.lastName__c;
            contact.Email = match.Email__c;
            contact.Phone = match.phone_Number__c;
            contact.AccountId = opportunityAccount.Id;

            upsert contact;

            match.Contact__c = contact.Id;
        }
        opportunityAccount.Primary_Contact__c = match.Contact__c;

        upsert opportunityAccount;

        opportunity.Primary_Contact__c = match.Contact__c;
        if (requestByAccount != null) {
            opportunity.Client_Account__c = requestByAccount.Id;
        }
        opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        opportunity.Description = match.requestSummary__c;
        opportunity.Name = opportunityAccount.Name;
        opportunity.AccountId = opportunityAccount.Id;
        opportunity.Type = 'Registration';
        opportunity.Registration_Deadline__c = match.Deadline__c;
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'Prospect';
        opportunity.Result__c = 'Attempted';
        opportunity.Priority__c = 'Registration Request';
        
        String defaultId = String.valueOf(SIT_Settings__c.getInstance('General SIT').Default_Opportunity_Owner__c);
        System.debug('defaultId = ' + defaultId);
        User owner = [
                SELECT Name,
                        Id
                FROM
                        User
                WHERE Id =: defaultId
                LIMIT 1
        ];

        opportunity.OwnerId = owner.Id;


        System.debug ('Inserting the opportunity:' + opportunity);

        try {
            insert opportunity;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }

        return opportunity;
    }

    //Dallin Wasden 4.25.19 ~ SFDC Support Case 00509381
    //API_CONNECT_SupplierRequest uses this method instead of insertOpportunityFromMatch to bypass Contractor Match
    public static Opportunity insertOpportunityFromAccount(Account[] accountMatches, Contact[] submittingUserMatches, API_CONNECT_SupplierRequest.SupplierRequestLite supplierRequest) {

        Opportunity opportunity = new Opportunity();
        Account requestByAccount;
        try {
            requestByAccount = [
                    SELECT
                            Id,
                            Name
                    FROM
                            Account
                    WHERE
                    Organizer_ID__c = :supplierRequest.requestedByClientId
                    AND
                    RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId()
                    LIMIT 1
            ];
        } catch (Exception e) {

        }

        Account opportunityAccount;

        System.debug('^^^^^^accountMatches = ' + accountMatches);
        if (accountMatches.size() == 1) {

            opportunityAccount = [
                    SELECT
                            Id,
                            Name,
                            Primary_Contact__c
                    FROM
                            Account
                    WHERE
                            Id = :accountMatches[0].Id
                    LIMIT 1
            ];

        } else {
            opportunityAccount = new Account();
            opportunityAccount.Name = supplierRequest.accountName;
            opportunityAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
            opportunityAccount.Status__c = 'Requested';
            
            //Added by Dallin Wasden 4.1.2020
            if(supplierRequest.country != NULL) {
                opportunityAccount.BillingCountry = supplierRequest.country;
            }
            //opportunityAccount.Vendor_Id__c = supplierRequest.externalId;

        }

        upsert opportunityAccount;

        List<Contact> contactsList = [
                SELECT Id, FirstName, LastName, Email
                FROM Contact
                WHERE Account.Id =: opportunityAccount.Id
        ];

        System.debug('Contacts List = ' + contactsList);
        
        Contact contactMatch;
        for(Contact cont : contactsList) {
            if(cont.FirstName == supplierRequest.firstName && cont.lastName == supplierRequest.lastName && cont.email == supplierRequest.email) {
                contactMatch = cont;
            }
        }
        System.debug('contactMatch = ' + contactMatch);

        Id supplierRequestContact;
        if (contactMatch == null) {

            Contact contact = new Contact();

            contact.FirstName = supplierRequest.firstName;
            contact.LastName = supplierRequest.lastName;
            contact.Email = supplierRequest.Email;
            contact.Phone = supplierRequest.phoneNumber;
            contact.AccountId = opportunityAccount.Id;
            contact.Language__c = supplierRequest.Language;

            upsert contact;
            System.debug('contact = ' + contact);
            supplierRequestContact = contact.Id;
            System.debug('supplierRequestContact = ' + supplierRequestContact);

        } else {
            supplierRequestContact = contactMatch.Id;
            System.debug('supplierRequestContact = ' + supplierRequestContact);
        }

        if(opportunityAccount.Primary_Contact__c == null){
            opportunityAccount.Primary_Contact__c = supplierRequestContact;
            upsert opportunityAccount;
        }
        
        List<Campaign> primaryCampaign = [
                SELECT Id
                FROM Campaign
                WHERE Name = 'Registration Requests'
        ];

        opportunity.Primary_Contact__c = supplierRequestContact;
        if (requestByAccount != null) {
            opportunity.Client_Account__c = requestByAccount.Id;
        }

        System.debug('opportunity.Primary_Contact__c = ' + opportunity.Primary_Contact__c);
        
        //Added by Dallin Wasden 4.29.19 as per SFDC case #00923692
        if(primaryCampaign.size() == 1){
            opportunity.CampaignId = primaryCampaign[0].Id;
        }
        
        opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        opportunity.Site__c = supplierRequest.requestSummary;
        opportunity.Name = opportunityAccount.Name;
        opportunity.AccountId = opportunityAccount.Id;
        opportunity.Type = 'Registration';
        opportunity.Registration_Deadline__c = supplierRequest.deadline;
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'Prospect';
        opportunity.Result__c = 'Attempted';
        opportunity.Priority__c = 'Registration Request';
        opportunity.Vendor_ID__c = supplierRequest.externalId;
        opportunity.Request_By__c = supplierRequest.requestedByContact;
        opportunity.Requester_Email__c = supplierRequest.requesterEmail;
        if (supplierRequest.preRegistrationTags != NULL) opportunity.Pre_Registration_Tags__c = String.join(supplierRequest.preRegistrationTags, ', ');
        if (supplierRequest.externalIds != NULL) opportunity.External_Ids__c = JSON.serialize(supplierRequest.externalIds);

        User owner = [
                SELECT Name,
                        Id
                FROM
                        User
                WHERE Alias = 'eolse'
                LIMIT 1
        ];

        opportunity.OwnerId = owner.Id;
		
        //Dallin Wasden 2.19.2020 ~ SFDC Support Case 01867625
        for(Contact c : submittingUserMatches){
            if(c.MongoDB_ID__c == supplierRequest.submittedByUserId) {
				opportunity.Submitting_User__c = c.Id;
            }
        }
        
        if(opportunity.Submitting_User__c == NULL) {
            opportunity.Submitting_User__c = submittingUserMatches[0].Id;
        }

        System.debug ('Inserting the opportunity:' + opportunity);

        try {
            insert opportunity;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }

/*        if (contactMatch != null) {

            if (contactMatch.AccountId == opportunity.AccountId && contactMatch.Id == supplierRequestContact) {
                OpportunityContactRole OCR = new OpportunityContactRole();

                OCR.ContactId = supplierRequestContact;
                OCR.IsPrimary = true;
                OCR.OpportunityId = opportunity.Id;
                OCR.Role = 'Client Provided Contact';

                insert OCR;
            }
        } else {

            OpportunityContactRole OCR = new OpportunityContactRole();

            OCR.ContactId = supplierRequestContact;
            OCR.IsPrimary = true;
            OCR.OpportunityId = opportunity.Id;
            OCR.Role = 'Client Provided Contact';

            insert OCR;

        }*/

        return opportunity;
    }

}