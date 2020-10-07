/*
    Name:        QB_UpdateContact
    
    Description: The purpose of this API is to keep Salesforce Contacts in sync with Organizer Users.  Today this
                 API is called by Boomi which does batch updates. It could also be called real-time.
                 
                 This API was created so that we can have more sohpisticated logic when sending updates to Salesforce.
                 This API includes both upsert and fuzzy logic matching so that if a user already exists in 
                 salesforce as a contact, we an find that matching contact by email or name.  This prevents duplicate
                 contacts from being created in salesforce when the contact is created in salesforce before the user
                 is created in organizer.                 
                 
                 This API starts by looking for a matching contact with the same organizer user id. If a match is found
                 that record will be updated.  If a match is not found the fuzzy logic starts by trying to find a contact 
                 that has not yet been linked to an organizer user id, which has the same email address.  If it finds no
                 contacts with a matching email address, it creates a new contact.  If the fuzzy logic finds only one contact
                 with an email address that matches, the match succeeds and that contact record will be updated with
                 the organizer user id and all other information about that user from organizer.  If the match finds more
                 than one account without an organizer user id and with the same email address, it looks at the first and
                 last names until it finds just one matching record.  If it cannot narrow the match down to one, it gives
                 up and throws an error.
                                
                 Another important detail of this API is that it will reparent a contact.  The goal of this API is
                 to keep Organizer and Salesforce in sync.  Within Organizer, a user can be moved from one account
                 to another.  To match that functionality, we also move contacts as they move in organizer.
*/

@RestResource(urlMapping='/avetta/contact/*')
global class QB_UpdateContact {

    global class ContactLight {
        global String connectUserId { get; set; }
        global String connectId { get; set; }
        global String accountId { get; set; }
        global String department { get; set; }
        global String email { get; set; }
        global String firstName { get; set; }
        global String lastName { get; set; }
        global String language { get; set; }
        global Date connectCreateDate { get; set; }
        global Date connectLastLogin { get; set; }
        global String connectUsername { get; set; }
        global String connectIsActive { get; set; }
        global String phone { get; set; }
        global boolean isPrimary { get; set; }
        global String timezone { get; set; }
        global String title { get; set; }
        global String street { get; set; }
        global String city { get; set; }
        global String state { get; set; }
        global String country { get; set; }
        global String postalCode { get; set; }
        global Boolean connectDisconnected { get; set; }

        // additional fields are fields which can be configured to update any defined field for the given type
        global String additionalText1 { get; set; }
        global String additionalText2 { get; set; }
        global String additionalDate1 { get; set; }
        global boolean additionalBoolean1 { get; set; }
    }

    static Contact ct;
    static Contractor_Match__c contractorMatch;
    static Id recordTypeId;
    static boolean foundTheContact;
    static Boolean matchUpdated;
    static API_Settings__c APISettings;
    static Account parentAccount = new Account();

    private static void updateContact(Contact c, ContactLight cl) {
        System.debug ('updating the contact:' + c);

        // update the organizer user id only if it is null
        if (c.Organizer_User_ID__c == NULL) c.Organizer_User_ID__c = cl.connectUserId;

        // update the parent account of the contact
        c.AccountId = parentAccount.id;

        // for all other fields, only update if the incoming value is not null
        if (cl.connectId != NULL) c.MongoDB_ID__C = cl.connectId;
        if (cl.department != NULL) c.Department = cl.department;
        
        //5.1.20 Added by Dallin Wasden as per Case #02313368
        if (cl.email != NULL) {
            if(URL.getSalesforceBaseUrl().getHost() == 'avetta.my.salesforce.com' || 
               (URL.getSalesforceBaseUrl().getHost() != 'avetta.my.salesforce.com' && cl.email.contains('@avetta.com'))) {
            	c.Email = cl.email;
            } else {
                c.Email = '';
            }
        }
        //
        if (cl.firstName != NULL) c.FirstName = cl.firstName;
        if (cl.lastName != NULL) c.LastName = cl.lastName;
        if (cl.language != NULL) c.Language__c = cl.language;
        if (cl.connectCreateDate != NULL) c.Organizer_Create_Date__c = cl.connectCreateDate;
        if (cl.connectLastLogin != NULL) c.Organizer_Last_Login__c = cl.connectLastLogin;
        if (cl.connectisActive != NULL) c.Organizer_isActive__c = cl.connectIsActive;
        if (cl.isPrimary != NULL) c.Primary_PICS_Organizer_User__c = cl.isPrimary;
        if (cl.phone != NULL) c.Phone = cl.phone;
        if (cl.timezone != NULL) c.Timezone__c = cl.timezone;
        if (cl.title != NULL) c.Title = cl.title;
        if (cl.street != NULL) c.MailingStreet = cl.street;
        if (cl.city != NULL) c.MailingCity = cl.city;
        if (cl.state != NULL) c.MailingState = cl.state;
        if (cl.country != NULL) c.MailingCountry = cl.country;
        if (cl.postalCode != NULL) c.MailingPostalCode = cl.postalCode;
        if (cl.connectDisconnected != NULL) c.Connect_Disconnected__c = cl.connectDisconnected;

        if (cl.additionalText1 != Null) c.put(APISettings.additionalText1__c, cl.additionalText1);
        if (cl.additionalText2 != Null) c.put(APISettings.additionalText2__c, cl.additionalText2);
        if (cl.additionalDate1 != Null) c.put(APISettings.additionalDate1__c, Date.valueOf(cl.additionalDate1));
        if (cl.additionalBoolean1 != Null) c.put(APISettings.additionalBoolean1__c, Boolean.valueOf(cl.additionalBoolean1));

        System.debug ('updating the contact:' + c);
        Database.update (c);
    }

    private static Contact insertContact(ContactLight cl) {
        Contact c = new Contact();

        c.Organizer_User_ID__c = cl.connectUserId;
        c.AccountId = parentAccount.id;
        c.Department = cl.department;
        //5.1.20 Added by Dallin Wasden as per Case #02313368
        if (cl.email != NULL) {
            if(URL.getSalesforceBaseUrl().getHost() == 'avetta.my.salesforce.com' || 
               (URL.getSalesforceBaseUrl().getHost() != 'avetta.my.salesforce.com' && cl.email.contains('@avetta.com'))) {
            	c.Email = cl.email;
            } else {
                c.Email = '';
            }
        }
        
        // for all other fields, only update if the incoming value is not null
        if (cl.connectId != NULL) c.MongoDB_ID__C = cl.connectId;
        
        //
        c.FirstName = cl.firstName;
        c.LastName = cl.lastName;
        c.Language__c = cl.language;
        c.Organizer_Create_Date__c = cl.connectCreateDate;
        c.Organizer_Last_Login__c = cl.connectLastLogin;
        c.Organizer_isActive__c = cl.connectIsActive;
        c.Phone = cl.phone;
        c.Timezone__c = cl.timezone;
        c.Title = cl.title;
        c.MailingStreet = cl.street;
        c.MailingCity = cl.city;
        c.MailingState = cl.state;
        c.MailingCountry = cl.country;
        c.MailingPostalCode = cl.postalCode;
        if (cl.connectDisconnected != NULL) c.Connect_Disconnected__c = cl.connectDisconnected;

        // the check for null for boolean has to be there even for insert
        if (cl.isPrimary != Null) c.Primary_PICS_Organizer_User__c = cl.isPrimary;

        if (cl.additionalText1 != Null) c.put(APISettings.additionalText1__c, cl.additionalText1);
        if (cl.additionalText2 != Null) c.put(APISettings.additionalText2__c, cl.additionalText2);
        if (cl.additionalDate1 != Null) c.put(APISettings.additionalDate1__c, Date.valueOf(cl.additionalDate1));
        if (cl.additionalBoolean1 != Null) c.put(APISettings.additionalBoolean1__c, Boolean.valueOf(cl.additionalBoolean1));

        System.debug ('Inserting a contact:' + c);
        Database.insert (c);
        return c;
    }

    @HttpPut
    global static void SFDC_UpdateContact(ContactLight contactInfo) {
        foundTheContact = false;
        matchUpdated = false;
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        List<Contact> cts = new List<Contact> ();
        List<Account> acts = new List<Account> ();
        APISettings = API_Settings__c.getInstance('UpdateContact API');
        response.statusCode = 200;

        if (contactInfo.accountId == null) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('ERROR: Required Field accountId is missing. ');
            System.debug (response);
        }

        if (response.statusCode == 200 && contactInfo.connectUserId == null) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('ERROR: Required Field organizerUserId is missing. ');
            System.debug (response);
        }

        if (response.statusCode == 200 && contactInfo.additionalText1 != NULL && APISettings.AdditionalText1__c == NULL) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('ERROR: AdditionalText1 passed, but not set in the APISettings');
        }

        if (response.statusCode == 200 && contactInfo.additionalText2 != NULL && APISettings.AdditionalText2__c == NULL) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('ERROR:  AdditionalText2 passed, but not set in the APISettings');
        }

        if (response.statusCode == 200 && contactInfo.additionalDate1 != NULL && APISettings.additionalDate1__c == NULL) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('ERROR:  additionalDate1 passed, but not set in the APISettings');
        }

        if (response.statusCode == 200 && contactInfo.additionalBoolean1 != NULL && APISettings.additionalBoolean1__c == NULL) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('ERROR:  additionalBoolean1 passed, but not set in the APISettings');
        }

        try {
            // retrieve the salesforce account id for the contact via organizer id
            if (response.statusCode == 200) {
                acts = [
                        SELECT id
                        FROM Account
                        WHERE organizer_id__c = :contactInfo.accountId
                        LIMIT 1
                ];


                if (acts.size() == 0) {


                    // If the Contact is not found check the Contactor Matches for the Account organizer Id and if found add contact information
                    // to the Contractor Match and do not create a new contact

                    try {
                        contractorMatch = [
                                SELECT Id
                                FROM Contractor_Match__c
                                WHERE OrganizerId__c = :contactInfo.accountId
                                LIMIT 1
                        ];
                    } catch (Exception e) {

                    }

                    if (contractorMatch != null) {

                        contractorMatch.email__c = contactInfo.email;
                        contractorMatch.firstName__c = contactInfo.firstName;
                        contractorMatch.lastName__c = contactInfo.lastName;
                        contractorMatch.phone_Number__c = contactInfo.phone;
                        contractorMatch.preferredLang__c = contactInfo.language;
                        contractorMatch.Contact_Organizer_Id__c = contactInfo.connectUserId;

                        update contractorMatch;
                        matchUpdated = true;

                    }

                    if (matchUpdated == false) {
                        response.statusCode = 400;
                        response.responseBody = Blob.valueOf('ERROR: Invalid Account Id: Account Not found: ' + contactInfo.accountId);
                    }
                } else
                        parentAccount = acts[0];
            }

            // look for contact record with the organizer user id
            if (response.statusCode == 200) {

                cts = [
                        SELECT Id, name, Organizer_User_ID__c
                        FROM Contact
                        WHERE Organizer_User_ID__c = :contactInfo.connectUserId
                        LIMIT 1
                ];

                if (cts.size() == 1) {
                    ct = cts[0];
                    foundTheContact = true;
                }
            }


            // begin fuzzy logic if no contact exists with the organizer user id
            // fuzzy logic will continue until a single match is found

            // TODO: currently this code will continue to query the database until it finds the best match
            // this is not a best practice and what we should do instead is walk through the records
            // from the previous query to find the best match.  for now, since this multiple contacts 
            // for an account having the same email isn't very frequent, we can make this change later
            // if we find that these updates begin to exceed the alloted transaction size

            // fuzzy logic match based on just email
            if (response.statusCode == 200 && !foundTheContact) {
                cts = [
                        SELECT id, name, Organizer_User_ID__c
                        FROM Contact
                        WHERE
                        Organizer_User_ID__c = NULL
                        AND email = :contactInfo.email
                        AND account.Organizer_ID__c = :contactInfo.accountId
                ];

                if (cts.size() == 1) {
                    ct = cts[0];
                    foundTheContact = true;
                }
            }

            // if fuzzy logic on email returns more than one row, search for the best match
            // by adding variations of last and first name
            if (response.statusCode == 200 && !foundTheContact && cts.size() > 1) {
                // try match on email, last name, and first name
                if (contactInfo.lastName != Null && contactInfo.firstName != Null) {
                    cts = [
                            SELECT id, name, Organizer_User_ID__c
                            FROM Contact
                            WHERE
                            Organizer_User_ID__c = NULL
                            AND email = :contactInfo.email
                            AND lastname = :contactInfo.lastName
                            AND firstname = :contactInfo.firstName
                            AND account.Organizer_ID__c = :contactInfo.accountId
                    ];

                    if (cts.size() == 1) {
                        ct = cts[0];
                        foundTheContact = true;
                    }
                }

                // try match on email and last name
                if (!foundTheContact && contactInfo.lastName != Null) {
                    cts = [
                            SELECT id, name, Organizer_User_ID__c
                            FROM Contact
                            WHERE
                            Organizer_User_ID__c = NULL
                            AND email = :contactInfo.email
                            AND lastname = :contactInfo.lastName
                            AND account.Organizer_ID__c = :contactInfo.accountId
                    ];

                    if (cts.size() == 1) {
                        ct = cts[0];
                        foundTheContact = true;
                    }
                }

                // try match on email and first name
                if (!foundTheContact && contactInfo.firstName != Null) {
                    cts = [
                            SELECT id, name, Organizer_User_ID__c
                            FROM Contact
                            WHERE
                            Organizer_User_ID__c = NULL
                            AND email = :contactInfo.email
                            AND firstname = :contactInfo.firstName
                            AND account.Organizer_ID__c = :contactInfo.accountId
                    ];

                    if (cts.size() == 1) {
                        ct = cts[0];
                        foundTheContact = true;
                    }
                }

                // give up if fuzzy match can not be narrowed down to one contact based on email, last name, and first name               
                if (!foundTheContact) {
                    response.statusCode = 400 ;
                    response.responseBody = Blob.valueOf ('ERROR: Fuzzy match on email could not match to a contact.  Consider merging these contacts for this account or manually update one of the contacts with the below organizerUserId');
                }
            }

            if (response.statusCode == 200) {
                if (foundTheContact) {
                    updateContact(ct, contactInfo);
                    response.responseBody = Blob.valueOf(JSON.serialize(ct));
                } else if (matchUpdated) {
                    response.responseBody = Blob.valueOf(JSON.serialize(contractorMatch));
                } else {

                    ct = insertContact (contactInfo);
                    response.responseBody = Blob.valueOf(JSON.serialize(ct));
                }
            }
        } catch (Exception e) {
            response.statusCode = 500;
            response.responseBody = Blob.valueOf('Database Error during UpdateContact API: ' + e.getMessage());
            System.debug ('500 here 2');
            System.debug(e);
        }

        if (response.statusCode == 200)
            response.addHeader('Content-Type', 'application/json'); else
                response.addHeader('Content-Type', 'text/plain');
    }

}