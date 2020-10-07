@RestResource(UrlMapping='/avetta/V1/SupplierRequest/*')
global class API_CONNECT_SupplierRequest {
    
    global class externalIds {
        public String externalId { get; set; }
        public String externalIdType { get; set; }
        public String corpClientId { get; set; }
    }

    //HERE
    
    global class SupplierRequestLite {
        public String accountName { get; set; }
        public String address { get; set; }
        public String address2 { get; set; }
        public String city { get; set; }
        //added 3.10.2020 by Dallin Wasden
        public String country { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String email { get; set; }
        public String phoneNumber { get; set; }
        public String language { get; set; }
        public String requestSummary { get; set; }

        public String requestBy { get; set; }  // Avetta Id //removing
        public String requestedByClientId { get; set; }

        public Date deadline { get; set; }
        public String webUrl { get; set; }
        public String matchId { get; set; }
        public String externalId { get; set; }

        public String submittingUserId { get; set; } //removing
        public String submittedByUserId { get; set; }

        public String requestedByUserName { get; set; } //removing
        public String requestedByContact { get; set; }
        public String requesterEmail { get; set; }
        
        public List<String> preRegistrationTags { get; set; }
        public List<externalIds> externalIds { get; set; }

        //HERE
        
        public SupplierRequestLite() {
        }

        public SupplierRequestLite(
                String accountName,
                String address,
                String address2,
                String city,
                String country,
                String firstName,
                String lastName,
                String email,
                String phoneNumber,
                String language,
                String requestSummary,
            	String requestBy,
                String requestedByClientId,    // Avetta Id
                Date deadline,
                String webUrl,
                String matchId,
                String externalId,
            	String submittingUserId,
                String submittedByUserId,
                String requestedByUserName,
            	String requestedByContact,
            	String requesterEmail,
            	List<String> preRegistrationTags,
            	List<externalIds> externalIds //HERE
        ) {

            this.accountName = accountName;
            this.address = address;
            this.address2 = address2;
            this.city = city;
            this.country = country;
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
            this.phoneNumber = phoneNumber;
            this.language = language;
            this.requestSummary = requestSummary;
            this.requestBy = requestBy;
            this.requestedByClientId = requestedByClientId;
            this.deadline = deadline;
            this.webUrl = webUrl;
            this.matchId = matchId;
            this.externalId = externalId;
            this.submittingUserId = submittingUserId;
            this.submittedByUserId = submittedByUserId;
            this.requestedByUserName = requestedByUserName;
            this.requestedByContact = requestedByContact;
            this.requesterEmail = requesterEmail;
            this.preRegistrationTags = preRegistrationTags;
            this.externalIds = externalIds; //HERE

        }

        /*
        public Contractor_Match__c mapToContractorMatch() {
            Contractor_Match__c match = new Contractor_Match__c();

            match.accountName__c = this.accountName;
            match.Name = this.accountName;
            match.street__c = this.address;
            match.address_Line_2__c = this.address2;
            match.City__c = this.city;
            match.firstName__c = this.firstName;
            match.lastName__c = this.lastName;
            match.email__c = this.email;
            match.phone_Number__c = this.phoneNumber;
            match.preferredLang__c = this.language;
            match.requestSummary__c = this.requestSummary;
            match.requestedBy__c = this.requestBy;
            match.deadline__c = this.deadline;
            match.webUrl__c = this.webUrl;


            return match;
        }
         */

    }

    /*
    private static String getAccountIdsfromAccounts(Account[] accounts) {

        String accountIds = '';

        for (Integer i = 0; i < accounts.size(); i++) {

            accountIds += accounts[i].Id + ',';
        }

        return accountIds;
    }

     */

////// TODO: do we need a Get?
//    @HttpGet
//    global static SupplierRequestLite[] getSupplierRequestById() {
//        System.debug('START API_CONNECT_SupplierRequest.getSupplierRequestById');
//
//        RestRequest request = RestContext.request;
//// grab the operatorContractorId from the end of the URL
//        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
//
//
//        Map <String, String> params;
//
//        RestResponse response = RestContext.response;
//        response.statusCode = 200;
//        params = request.params;
//        System.debug('params: ' + params);
//
//
//        System.debug(id);
//
//
////System.debug(operatorContractor);
//
//        SupplierRequestLite[] returnObject = new List<SupplierRequestLite>();
//
//        returnObject.add(new SupplierRequestLite());
//
//        returnObject[0].accountName = id;
//
//        System.debug(returnObject);
//
//
//        System.debug('END API_CONNECT_SupplierRequest.getSupplierRequestById');
//        return returnObject;
//    }


/*
    @HttpPost
    global static ID createOperatorContractor(String recordTypeId, String connectFormType, String connectFormId, String connectUrl, String status, String origin, String priority, String organizerUserId) {

    }
*/

    @HttpPut
    global static SupplierRequestLite[] upsertSupplierRequest(
            String accountName,
            String address,
            String address2,
            String city,
            String country,
            String firstName,
            String lastName,
            String email,
            String phoneNumber,
            String language,
            String requestSummary,
            String requestBy,
            String requestedByClientId,    // Avetta Id
            Date deadline,
            String webUrl,
            String matchId,
            String externalId,
            String submittingUserId,
            String submittedByUserId,
            String requestedByUserName,
            String requestedByContact,
        	String requesterEmail,
        	List<String> preRegistrationTags, 
        	List<externalIds> externalIds //HERE
    ) {
//
        System.debug('START API_CONNECT_SupplierRequest.upsertSupplierRequest');

        SupplierRequestLite supplierRequest = new SupplierRequestLite(
                accountName,
                address,
                address2,
                city,
                country,
                firstName,
                lastName,
                email,
                phoneNumber,
                language,
                requestSummary,
                requestBy,
                requestedByClientId,    // Avetta Id
                deadline,
                webUrl,
                matchId,
                externalId,
            	submittingUserId,
                submittedByUserId,
                requestedByUserName,
            	requestedByContact,
            	requesterEmail,
            	preRegistrationTags,
            	externalIds //HERE
        );

        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();

//      Account[] accountMatches = findContactorAccounts(supplierRequest.accountName, supplierRequest.city, supplierRequest.phoneNumber, supplierRequest.webUrl);

        //Dallin Wasden 4.25.19 ~ SFDC Support Case 00509381
        //Bypass Zinovo fuzzy matching logic and match only on exact account name match when only one match exists.
        //In cases of 0 or many matches, insert new account.
        //Account[] accountMatches = QB_Utils.QB_FindProspectAccount(recordTypeId, supplierRequest.accountName, supplierRequest.city, supplierRequest.phoneNumber, supplierRequest.webUrl);

        Account[] accountMatches = [
                SELECT Id, Organizer_ID__c, Name, Website, BillingCity, Phone
                FROM Account
                WHERE Name =: supplierRequest.accountName
        ];

        //Dallin Wasden 2.19.2020 ~ SFDC Support Case 01867625
        Contact[] submittingUserMatches = [
                SELECT Id, MongoDB_ID__c
        	    FROM Contact
        	    WHERE  (MongoDB_ID__c != 'NULL' OR MongoDB_ID__c != '') AND (MongoDB_ID__c =: submittedByUserId OR Name = 'Avetta User')
        ];

        //Dallin Wasden 4.25.19 ~ SFDC Support Case 00509381
        //Bypass contractor match object
        /*
        Contractor_Match__c match = supplierRequest.mapToContractorMatch();
        match.Match_Type__c = 'Supplier Request';
        match.accountRecordTypeId__c = recordTypeId;


        Integer accountMatchSize = accountMatches.size();


        if (accountMatchSize > 0) {
            match.Account__c = accountMatches[0].Id;

            match.All_Matches__c = getAccountIdsfromAccounts(accountMatches);
        }

        try {
            upsert match;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }


        supplierRequest.matchId = match.Id;
        */

        SupplierRequestLite[] returnObject = new List<SupplierRequestLite>();

        returnObject.add(supplierRequest);

        Integer accountMatchSize = accountMatches.size();

        API_CONNECT_Helpers.insertOpportunityFromAccount(accountMatches, submittingUserMatches, supplierRequest);

        /*
        try {
            delete match;
        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
            throw e;
        }
         */
 

        System.debug(returnObject);


        System.debug('END API_CONNECT_SupplierRequest.upsertSupplierRequest');

        return returnObject;
    }

/*
    @HttpDelete
    global static void deleteOperatorContractor() {

    }
*/
/*
    @HttpPatch
    global static ID updateOperatorContractorFields() {

    }
*/


}