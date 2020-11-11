/*QB
    Name:        QB_UpdateAccount

    Description: The purpose of this API is to keep Salesforce Accounts in sync with Organizer Accounts.  Today this
                 API is called by Boomi which does batch updates. It could also be called real-time.

                 This API has both a Get and a Put.  The Get is in place to allow a real-time API call to get account
                 information from Salesforce.  The Put allows for Salesforce records to be upated.

                 This API was created so that we can have more sohpisticated logic when sending updates to Salesforce.
                 It allows for accounts to be upserted based on Organizer ID or PID.  The PID is a unique identifier
                 assigned to each record for the purpose of identifying a registration and the corresponding Salesforce
                 account.  The expectation is that most, if not all, new supplier accounts are first
                 targeted by a campaign that originates in Salesforce. That means that most, if not all, records
                 coming in through this API should be updates.

                 When a PID is not provided and the Organizer ID does not exist in Salesforce, then fuzzy logic
                 will be used to find the corresponding Salesforce account if one exists.  This prevents duplicate
                 accounts from being created in salesforce when the account is created in salesforce before the account
                 is created in organizer.  The fuzzy logic lives in QB_FindProspectAccount.  The fuzzy logic uses the
                 account name, city, phone number, and url to look for a matching account in Salesforce.

                 Since most accounts should be updates, when an account cannot be found by Organizer ID, PID, or
                 the fuzzy logic, we then have the option to create a task to investigate why the new Organizer
                 account could not be in Salesforce.  In some cases this could be valid.  But if it is not valid, we
                 want to (1) merge the Salesforce account is the fuzzy logic failed to find the account and (2) investigate
                 how we can improve the fuzzy logic to catch the missed match.

                 This API was written during a transition time of terminologies.  Accounts in Salesforce are still
                 categorized as Operators or Contractors.  Moving forward, Operators will be called Clients and Contractors
                 will be called Suppliers.
*/

@RestResource(urlMapping='/avetta/account/*')
global class QB_UpdateAccount {
    global class AccountLight {
        global String accountRecordType { get; set; }                  // required field input only
        global String accountType { get; set; }                        // optional input field – Used for finding account
        global String pid { get; set; }                               // optional input field – Used for finding account
        global String billingId { get; set; }                        // optional input field – Used for finding account
        global String primaryEmail { get; set; }                       // optional input field – Used for finding account

        // Common fields for both Clients and Suppliers
        global String accountName { get; set; }
        global String connectId { get; set; }
        global String phoneNumber { get; set; }
        global String webUrl { get; set; }                              // URL URL
        global String accountStatus { get; set; }                       // Status__c picklist
        global String street { get; set; }
        global String city { get; set; }
        global String state { get; set; }
        global String postalCode { get; set; }
        global String country { get; set; }
        global Date registrationDate { get; set; }
        global String fax { get; set; }                                 // fax, fax
        global String DBAName { get; set; }                             // DBA_Name__c, String
        global String preferredLang { get; set; }
        global String billableEntityId { get; set; }                     // Billable_Entity__c
        global String membershipType { get; set; }						//11.12.2019 Added by Dallin Wasden
        global Boolean smallBusiness { get; set; }						//4.29.2020 Added by Dallin Wasden
        global Date membershipDate { get; set; }						//5.27.2020 Added by Dallin Wasden

        // Client Specific fields
        global String globalAccountId { get; set; }                     // Global_Parent__c, lookup Account
        global String parentAccountId { get; set; }                     // Parent, lookup Account
        global String parentMongoId { get; set; }
        global String corporateMongoId { get; set; }
        global boolean billable { get; set; }                           // IsBillable__c, boolean
        global String primaryIndustry { get; set; }
        global List<String> secondaryIndustries { get; set; }

        // Supplier Specific fields
        global String taxId { get; set; }
        global Integer payingFacilities { get; set; }
        
        	
        global Boolean vetify { get; set; }
        
        //Added by Dallin Wasden 2.5.19
        global Integer billableSites { get; set; }

        // additional fields are fields which can be configured to update any defined field for the given type
        global String additionalText1 { get; set; }
        global String additionalText2 { get; set; }
        global String additionalDate1 { get; set; }
        global boolean additionalBoolean1 { get; set; }
    }
    
    global class accountInfo {
        global AccountLight accountInfo;
    }


    static Account act;
    static Account contractorMatch;
    static Id recordTypeId;
    static boolean foundTheAccount = false;
    static boolean foundFuzzyMatch = false;
    static Account parentAccount;
    static Account globalAccount;
    static String parentMongoId;
    static String corporateMongoId;
    static API_Settings__c APISettings;
    static boolean dupFound;
    static String pid;
    static String OrganizerId;
    static Id billableEntityId;


    private static void updateAccount(Account a, AccountLight al) {
        if (a.Organizer_ID__c == NULL) a.Organizer_ID__c = al.billingId;
        //Added by Dallin Wasden 11.25.19
        if (al.connectId != NULL) a.AccountMongoID__c = al.connectId;
        if (al.accountName != NULL) a.Name = al.accountName;
        if (al.phoneNumber != NULL) a.phone = al.phoneNumber;
        if (al.webUrl != NULL) a.Website = al.webUrl;
        if (al.accountStatus != NULL) a.Status__c = al.accountStatus;
        if (al.street != NULL) a.BillingStreet = al.street;
        if (al.city != NULL) a.BillingCity = al.city;
        if (al.state != NULL) a.BillingState = al.state;
        if (al.postalCode != NULL) a.BillingPostalCode = al.postalCode;
        if (al.country != NULL) a.BillingCountry = al.country;
        if (al.registrationDate != NULL) a.Registration_Date__c = (Date) al.registrationDate;
        if (al.membershipDate != NULL) a.membershipDate__c = (Date) al.membershipDate;
        if (al.preferredLang != NULL) a.Preferred_Language__c = al.preferredLang;
        if (al.fax != NULL) a.fax = al.fax;
        if (al.DBAName != NULL) a.DBA_Name__c = al.DBAName;
        if (al.smallBusiness != NULL) a.Small_Business__c = al.smallBusiness;
        
        //Added by Dallin Wasden 11.25.19
        if (al.membershipType != NULL) {        
            if(al.membershipType == 'Premium') {
                a.Membership_Type__c = 'Member - Premium';
                    } else {
                        a.Membership_Type__c = 'Member - Basic';
                    }
        }
            
        if (al.AccountRecordType == 'Client') {
            if (al.billable != NULL) a.IsBillable__c = al.billable;
            if (parentAccount != NULL) a.ParentId = parentAccount.Id;
            if (globalAccount != NULL) a.Global_Parent__c = globalAccount.Id;
            //Added by Dallin Wasden 9.25.2019
            a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
            if (al.parentMongoId != NULL) a.Parent_Mongo_Id__c = al.parentMongoId;
            if (al.corporateMongoId != NULL) a.Corporate_Mongo_Id__c = al.corporateMongoId;
            if (al.primaryIndustry != NULL) a.Industry = al.primaryIndustry;
        } else {
            // Contractor
            if (al.payingFacilities != NULL) a.Paying_Facilities__c = al.payingFacilities;
            if (al.taxId != NULL) a.Tax_ID__c = al.taxId;
            
            if (al.vetify == true) {
                //a.vetify__c = true;
            } else {
                //a.vetify__c = false;
            }
            
            //Added by Dallin Wasden 2.5.19
            if (al.billableSites != null) {
                a.Billable_Sites__c = al.billableSites;
            }
            //Added by Dallin Wasden 9.25.2019
            a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        }

        if (billableEntityId != null) a.Billable_Entity__c = billableEntityId;


        if (al.additionalText1 != Null) a.put(APISettings.additionalText1__c, al.additionalText1);
        if (al.additionalText2 != Null) a.put(APISettings.additionalText2__c, al.additionalText2);
        if (al.additionalDate1 != Null) a.put(APISettings.additionalDate1__c, Date.valueOf(al.additionalDate1));
        if (al.additionalBoolean1 != Null) a.put(APISettings.additionalBoolean1__c, al.additionalBoolean1);
       
        
        System.debug ('updating the acount:' + a);

        Database.update (a);
    }

    private static Account insertAccount(AccountLight al) {
        Account a = new Account();

        a.Organizer_ID__c = al.billingId;
        a.RecordTypeId = recordTypeId;
        a.type = al.accountType;
        a.Name = al.accountName;
        a.phone = al.phoneNumber;
        a.Website = al.webUrl;
        a.Status__c = al.accountStatus;
        a.BillingStreet = al.street;
        a.BillingCity = al.city;
        a.BillingState = al.state;
        a.BillingPostalCode = al.postalCode;
        a.BillingCountry = al.country;
        a.Registration_Date__c = (Date) al.registrationDate;
        a.MembershipDate__c = (Date) al.membershipDate;
        a.fax = al.fax;
        a.DBA_Name__c = al.DBAName;
        a.Preferred_Language__c = al.preferredLang;
        //Added by Dallin Wasden 2.5.19
        a.Billable_Sites__c = al.billableSites;
        //Added by Dallin Wasden 11.19.19
        a.AccountMongoID__c = al.connectId;
        //Added by Dallin Wasden 4.29.20
        a.Small_Business__c = al.smallBusiness;
        if(al.smallBusiness != NULL) {
            a.Small_Business__c = al.smallBusiness;
        } else {
        	a.Small_Business__c = FALSE;
        }
        
        //Added by Dallin Wasden 11.12.19
        if(al.membershipType == 'Premium') {
            a.Membership_Type__c = 'Member - Premium';
                } else {
                    a.Membership_Type__c = 'Member - Basic';
                }
        
        if (al.AccountRecordType == 'Client') {
            a.IsBillable__c = al.billable;
            if (parentAccount != NULL) a.ParentId = parentAccount.Id;
            if (globalAccount != NULL) a.Global_Parent__c = globalAccount.Id;
            if (al.parentMongoId != NULL) a.Parent_Mongo_Id__c = al.parentMongoId;
            if (al.corporateMongoId != NULL) a.Corporate_Mongo_Id__c = al.corporateMongoId;
            if (al.primaryIndustry != NULL) a.Industry = al.primaryIndustry;

        } else {
            a.Paying_Facilities__c = al.payingFacilities;
            a.Tax_ID__c = al.taxId;
        }

        if (billableEntityId != null) a.Billable_Entity__c = billableEntityId;


        if (al.additionalText1 != Null) a.put(APISettings.additionalText1__c, al.additionalText1);
        if (al.additionalText2 != Null) a.put(APISettings.additionalText2__c, al.additionalText2);
        if (al.additionalDate1 != Null) a.put(APISettings.additionalDate1__c, Date.valueOf(al.additionalDate1));
        if (al.additionalBoolean1 != Null) a.put(APISettings.additionalBoolean1__c, al.additionalBoolean1);
        
        System.debug ('Inserting the acount:' + a);

        Database.insert (a);
        return a;
    }

	/*
    @TestVisible
    private static Account insertAccountMatch(AccountLight al, Account[] matches) {
	
        System.debug('al = ' + al);
        
        Account match;
        try {

            match = [
                    SELECT
                            Id,
                            Organizer_ID__c
                    FROM Account
                    WHERE Organizer_ID__c = :al.OrganizerId
            ][0];

        } catch (Exception e) {

        }

        if (match == null) {
            match = new Account();
            match.Organizer_ID__c = al.OrganizerId;
        }

        //match.Match_Type__c = 'Update Account';

		System.debug('al.AccountRecordType = ' + al.AccountRecordType);
        //match.RecordTypeId = recordTypeId;
        match.RecordTypeId = al.AccountRecordType;
        match.Name = al.accountName;
        match.Phone = al.phoneNumber;
        match.Website = al.webUrl;
        match.Status__c = al.accountStatus;
        match.BillingStreet = al.street;
        match.BillingCity = al.city;
        match.BillingState = al.state;
        match.BillingPostalCode = al.postalCode;
        match.BillingCountry = al.country;
        match.Registration_Date__c = (Date) al.registrationDate;
        match.Fax = al.fax;
        match.DBA_Name__c = al.DBAName;
        match.Preferred_Language__c = al.preferredLang;
        //match.email__c = al.contactEmail;
        if (al.AccountRecordType == 'Client') {
            match.IsBillable__c = al.billable;
            if (parentAccount != NULL) match.ParentId = parentAccount.Id;
            if (globalAccount != NULL) match.Global_Parent__c = globalAccount.Id;

        } else {
            match.Paying_Facilities__c = al.payingFacilities;
            match.Tax_ID__c = al.taxId;
            match.vetify__c = al.vetify;
        }

        if (billableEntityId != null) match.Billable_Entity__c = billableEntityId;


        if (al.additionalText1 != Null) match.put(APISettings.additionalText1__c, al.additionalText1);
        if (al.additionalText2 != Null) match.put(APISettings.additionalText2__c, al.additionalText2);
        if (al.additionalDate1 != Null) match.put(APISettings.additionalDate1__c, Date.valueOf(al.additionalDate1));
        if (al.additionalBoolean1 != Null) match.put(APISettings.additionalBoolean1__c, al.additionalBoolean1);

        String allMatchIds = '';

        Integer maxNumberIdsToSave = matches.size();
        if (maxNumberIdsToSave > 10) {
            maxNumberIdsToSave = 10;
        }

        for (Integer i = 0; i < maxNumberIdsToSave; i++) {
            allMatchIds += matches[i].Id + ',';
        }

        //match.All_Matches__c = allMatchIds;

        System.debug ('Inserting the match:' + match);

        Upsert match;
        return match;
    }
	*/

    // Lookup Salesforce Account Data via PID or Organizer ID Lookup
    @HttpGet
    global static void GetAccountInfo() {
        System.debug('In GetAccount Info');
        Map <String, String> params;
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.statusCode = 200;
        params = request.params;
        System.debug('params: ' + params);
        pid = params.get('pid');
        OrganizerId = params.get('orgid');
        System.debug('OrganizerId:' + OrganizerId);

        if (pid == null && OrganizerId == null) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('ERROR: please provide either organizer id OR pid. ');
        }

        if (response.statusCode == 200) {
            try {
                String a = QB_Utils.QB_FindExactAccount(pid, organizerId);
                System.debug('found account: ' + a);
                response.responseBody = Blob.valueOf(a);
            } catch (Exception e) {
                response.statusCode = 500;
                response.responseBody = Blob.valueOf('ERROR: Internal Error in Salesforce:  ' + e.getMessage());
            }
        }

        if (response.statusCode == 200)
            response.addHeader('Content-Type', 'application/json'); else
                response.addHeader('Content-Type', 'text/plain');

    }

    @HttpPut
    global static void SFDC_UpdateAccount() {
		String accountJSON = RestContext.request.requestBody.toString();        
        accountJSON = accountJSON.replace('{"accountInfo":', '');
        accountJSON = accountJSON.removeEnd('}');
        
        foundTheAccount = false;
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        List<Account> acts = new List<Account>();
        APISettings = API_Settings__c.getInstance('Update Account API');
        System.debug('APISettings.Insert_Account_When_Not_Found__c');
        System.debug(APISettings.Insert_Account_When_Not_Found__c);
        String ids;

        AccountLight accountInfo = (AccountLight) JSON.deserialize(accountJSON, AccountLight.Class);
		System.debug(accountInfo);

        response.statusCode = 200;

        if (response.statusCode == 200) {
            if (accountInfo.accountRecordType != NULL && accountInfo.accountRecordType == 'Supplier') {
                recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
            } else if (accountInfo.accountRecordType != NULL && accountInfo.AccountRecordType == 'Client') {
                recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
            } else {
                response.statusCode = 400;
                response.responseBody = Blob.valueOf('ERROR: Invalid Account Type. Expected: Supplier or Client. Received: ' + accountInfo.AccountRecordType);
            }
        }

        // retrieve the Salesforce parentId using the Organizer Id
        if (response.statusCode == 200 && accountInfo.parentAccountId != NULL) {
            System.debug('trying to find the parent account id' + accountInfo.parentAccountId);
            try {
                parentAccount = [
                        SELECT id, Organizer_ID__c
                        FROM Account
                        WHERE organizer_id__c = :accountInfo.parentAccountId
                ];
                System.debug('found parent account id' + parentAccount);
            } catch (Exception e) {
                if (parentAccount == Null) {
                    response.statusCode = 400;
                    response.responseBody = Blob.valueOf('ERROR: Invalid Parent Account Id: Account Not found: ' + accountInfo.parentAccountId);
                }
            }
        }

        // retrieve the Salesforce globalId using the Organizer Id
        if (response.statusCode == 200 && accountInfo.globalAccountId != NULL) {
            System.debug('trying to find the global account id' + accountInfo.globalAccountId);

            try {
                globalAccount = [
                        SELECT id, Organizer_ID__c
                        FROM Account
                        WHERE organizer_id__c = :accountInfo.globalAccountId
                ];
                System.debug('found global account id' + globalAccount);
            } catch (Exception e) {
                if (globalAccount == Null) {
                    response.statusCode = 400;
                    response.addHeader('Content-Type', 'application/json');
                    response.responseBody = Blob.valueOf('ERROR: Invalid Global Account Id: Account Not found: ' + accountInfo.globalAccountId);
                }
            }
        }

        // retrieve the Salesforce Id odf the Billable Entity using the Organizer Id if provided
        if (response.statusCode == 200 && accountInfo.billableEntityId != null) {
            System.debug('trying to find the Billable Entity account id' + accountInfo.billableEntityId);

            try {
                billableEntityId = [
                        SELECT Id
                        FROM Account
                        WHERE Organizer_ID__c = :accountInfo.billableEntityId
                ].Id;

                System.debug('found Billable Entity account id' + billableEntityId);
            } catch (Exception e) {
                if (billableEntityId == null) {
                    response.statusCode = 400;
                    response.addHeader('Content-Type', 'application/json');
                    response.responseBody = Blob.valueOf('ERROR: Invalid Billable Entity Id: Account Not found: ' + accountInfo.billableEntityId);
                }
            }

        }


/*        if (response.statusCode == 200 && accountInfo.additionalText1 != NULL) {
            if (APISettings.additionalText1__c == NULL) {
                response.statusCode = 400;
                response.responseBody = Blob.valueOf('ERROR: additionalText1 passed, but not set in the APISettings');
            }

        }*/

        if (response.statusCode == 200 && accountInfo.additionalText2 != NULL) {
            if (APISettings.additionalText2__c == NULL) {
                response.statusCode = 400;
                response.responseBody = Blob.valueOf('ERROR:  additionalText2 passed, but not set in the APISettings');
            }
        }

        if (response.statusCode == 200 && accountInfo.additionalDate1 != NULL) {
            if (APISettings.additionalDate1__c == NULL) {
                response.statusCode = 400;
                response.responseBody = Blob.valueOf('ERROR:  additionalDate1 passed, but not set in the APISettings');

            }
        }

        if (response.statusCode == 200 && accountInfo.additionalBoolean1 != NULL) {
            if (APISettings.additionalBoolean1__c == NULL) {
                response.statusCode = 400;
                response.responseBody = Blob.valueOf('ERROR:  additionalBoolean1 passed, but not set in the APISettings');

            }
        }

        if (response.statusCode == 200) {
            try {
                // Lookup Account by Organizer ID
                if (accountInfo.billingId != null) {
                    // retrieve the salesforce account id via organizer id
                    acts = [
                            SELECT Id, Name, Organizer_ID__c
                            FROM Account
                            WHERE Organizer_ID__c = :accountInfo.billingId
                            //Modified by Dallin Wasden 9.25.2019
                        	//AND recordTypeId = :recordTypeId
                    ];
                    System.debug('found accounts = ' + acts);
                    if (acts.size() == 1) {
                        act = acts[0];
                        foundTheAccount = true;
                    } else if (acts.size() > 1) {
                        response.statusCode = 400;
                        response.responseBody = Blob.valueOf('ERROR: More than one match on Organizer id');
                    }
                }

                // Use PID to lookup a new account registration
                System.debug('pid = ' + accountInfo.pid);
                if (response.statusCode == 200 && !foundTheAccount) {
                    if (accountInfo.pid != null) {
                        acts = [
                                SELECT Id, Name, Organizer_ID__c
                                FROM Account
                                WHERE PID__c = :accountInfo.pid
                                AND RecordTypeId = :recordTypeId
                        ];
                        if (acts.size() != 1) {
                            response.statusCode = 400;
                            response.responseBody = Blob.valueOf('ERROR: pid not found: ' + accountInfo.pid);
                        } else if (acts.size() == 1) {
                            act = acts[0];
                            foundTheAccount = true;
                        } else if (acts.size() > 1) {
                            response.statusCode = 500;
                            response.responseBody = Blob.valueOf('ERROR: More then one account found with pid: ' + accountInfo.pid);
                        }
                    }
                }

                // Use fuzzy matching logic if no account exists with the Organizer ID or PID.
                // If fuzzy matching finds more than one match, the first account is selected. If
                // no matches are found a new record is created and a task is also created to
                // verify that there are no matches.  Task creation can be disabled through account
                // custom setting.
                if (response.statusCode == 200 && !foundTheAccount) {
                    //12.17.2019 added by Jason M.-- Added the 'primaryEmail' parameter.
                    acts = QB_Utils.QB_FindProspectAccount (recordTypeId, accountInfo.accountName, accountInfo.primaryEmail, accountInfo.city, accountInfo.state, accountInfo.country, accountInfo.phoneNumber, accountInfo.webUrl, accountInfo.primaryEmail);

                    Integer accountCount = acts.size();

                    System.debug('***** ACTS LIST SIZE ***** = ' + accountCount);

                    if (accountCount == 1) {
                        act = acts[0];
                        foundTheAccount = true;
                    } else if (accountCount > 1) {

                        //contractorMatch = insertAccountMatch(accountInfo, acts);
                        foundFuzzyMatch = true;
                    }
                }

                //System.debug('***** ACTS ***** = ' + acts[0]);

                // Update the Salesforce account if found, otherwise insert the account if the option to insert is enabled
                if (response.statusCode == 200) {
                    if (foundTheAccount) {
                        updateAccount(act, accountInfo);
                        response.responseBody = Blob.valueOf(JSON.serialize(act));
                    } else if (foundFuzzyMatch) {
                        act = insertAccount (accountInfo);
                        createTask(act, 'UpdateAccount API inserted account. Evaluate for merging. Account Id; ' + act.Id);
                        
                        // TODO: Should a task be created
                        //createTask(act, 'UpdateAccount API inserted account. Evaluate for merging. Account Id; ' + act.id);
                        response.responseBody = Blob.valueOf(JSON.serialize(contractorMatch));
                    } else if (APISettings.Insert_Account_When_Not_Found__c) {
                        act = insertAccount (accountInfo);
                        createTask(act, 'UpdateAccount API inserted account. Evaluate for merging. Account Id; ' + act.Id);
                        response.responseBody = Blob.valueOf(JSON.serialize(act));
                    } else {
                        response.statusCode = 400;
                        response.responseBody = Blob.valueOf('No Matching account was found to update and inserts are disabled. Change Salesforce custom setting to enable accounts to be inserted');
                    }
                }
            } catch (Exception e) {
                response.statusCode = 500;
                String message = e.getMessage();
                response.responseBody = Blob.valueOf('Database Error during UpdateAccount API: ' + message);
            }
        }

        if (response.statusCode == 200)
            response.addHeader('Content-Type', 'application/json'); else
                response.addHeader('Content-Type', 'text/plain');


        System.debug ('response' + response);
        System.debug ('response' + response.toString());

    }

    // Create task
    private static void createTask(Account a, String subj) {
        if (APISettings.Admin_Id__c != null) {
            QB_Utils.createTask (a, subj, APISettings.Admin_Id__c);
        }
    }
}