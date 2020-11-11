@RestResource(urlMapping='/avetta/formvalidation/*')
global with sharing class ConnectCases {

    global class CaseLite {

        public String recordTypeId { get; set; }
        public String caseNumber { get; set; }
        public String subject { get; set; }
        public String type { get; set; }
        public String subType { get; set; }
        public String avettaId { get; set; }
        public String connectFormId { get; set; }
        public String connectUrl { get; set; }
        public String status { get; set; }
        public Datetime lastStatusChange { get; set; }
        public CaseCommentsLite[] comments { get; set; }
        public CaseHistoryLite[] statusHistory { get; set; }
        //public CaseRelatedClientsLite[] relatedClients { get; set; }
        public Date validStartDate { get; set; }
        public Date validEndDate { get; set; }
        public Date hiddenForm { get; set; }
        public String userEmail { get; set; }

        public caseLite() {
        }

        public caseLite(Case baseCase) {
            this.addComments(baseCase.CaseComments);
            //this.addRelatedClientAccounts(relatedClients);

            this.recordTypeId = baseCase.RecordTypeId;
            this.caseNumber = baseCase.CaseNumber;
            this.subject = baseCase.Subject;
            this.type = baseCase.Type;
            this.subType = baseCase.Sub_Type__c;
            this.avettaId = baseCase.Organizer_ID__c;
            this.connectFormId = baseCase.Connect_Form_ID__c;
            this.connectUrl = baseCase.Connect_URL__c;
            this.status = baseCase.Status;
            this.lastStatusChange = baseCase.Last_Status_Change__c;
            //            this.validEndDate = baseCase.Valid_End_Date__c;  //    Valid End Date
            //            this.validStartDate = baseCase.Valid_Start_Date__c;  ///             Valid Start Date

            this.populateStatusHistory(baseCase.Id);
        }

        public void addComments(CaseComment[] commentsToAdd) {
            if (this.comments == null) {
                this.comments = new List<CaseCommentsLite>();
            }
            for (CaseComment comment : commentsToAdd) {
                this.comments.add(new CaseCommentsLite(comment));
            }
        }

        /*
public void addRelatedClientAccounts(CaseRelatedClientsLite[] clientAccountsToAdd) {
if (this.relatedClients == null) {
this.relatedClients = new List<CaseRelatedClientsLite>();
}
for (Id relatedClient : clientAccountsToAdd) {
this.relatedClients.add(new CaseRelatedClientsLite(relatedClient));
}
}
*/


        @TestVisible
        private void populateStatusHistory(Id id) {

            CaseHistory[] history;


            try {

                history = [
                        SELECT

                                CreatedDate,
                                Field,
                                NewValue,
                                OldValue,
                                CreatedBy.Id,
                                CreatedBy.Name,
                                CreatedBy.Email
                        FROM CaseHistory
                        WHERE CaseId = :id
                        AND Field = 'Status'
                ];
            } catch (Exception e) {
                API_CONNECT_Helpers.logException(e);
            }

            if (history != null) {
                if (this.statusHistory == null) {
                    this.statusHistory = new List<CaseHistoryLite>();
                }
                for (CaseHistory h : history) {
                    this.statusHistory.add(new CaseHistoryLite(h));
                }
            }

        }
    }

    public class CaseHistoryLite {

        public String field { get; set; }
        public String newValue { get; set; }
        public String oldValue { get; set; }
        public Datetime createdDate { get; set; }
        public String createdByName { get; set; }
        public String createdByAvettaId { get; set; }
        public String createdByEmail { get; set; }


        public CaseHistoryLite() {

        }
        public CaseHistoryLite(CaseHistory baseHistory) {

            if (baseHistory.Field != null) {
                this.field = baseHistory.Field;
            } else {
                this.field = '';
            }
            if (baseHistory.NewValue != null) {
                this.newValue = baseHistory.NewValue.toString();
            } else {
                this.newValue = '';
            }
            if (baseHistory.OldValue != null) {
                this.oldValue = baseHistory.OldValue.toString();
            } else {
                this.OldValue = '';
            }


            if (baseHistory.CreatedDate != null) {
                this.createdDate = baseHistory.CreatedDate;
            }

            if (baseHistory.CreatedBy != null && baseHistory.CreatedBy.Name != null) {

                this.createdByName = baseHistory.CreatedBy.Name;
            } else {
                this.createdByName = '';
            }

            if (baseHistory.CreatedBy != null && baseHistory.CreatedBy.Email != null) {
                this.createdByEmail = baseHistory.CreatedBy.Email;
            } else {
                this.createdByEmail = '';
            }


            if (baseHistory.CreatedBy != null && baseHistory.CreatedBy.Id != null) {

                try {

                    this.createdByAvettaId = [
                            SELECT
                                    Id,
                                    Organizer_User_ID__c
                            FROM
                                    Contact
                            WHERE
                                    Id = :baseHistory.CreatedBy.Id
                    ].Organizer_User_ID__c;

                } catch (Exception e) {
                    API_CONNECT_Helpers.logException(e);
                    this.createdByAvettaId = '';
                }
            } else {
                this.createdByAvettaId = '';
            }

        }


    }

    public class CaseCommentsLite {

        public String id {
            get;
            set;
        }
        public String parentId {
            get;
            set;
        }
        public String commentBody {
            get;
            set;
        }
        public String createdByName {
            get;
            set;
        }
        public String createdByAvettaId {
            get;
            set;
        }
        public String createdByEmail {
            get;
            set;
        }

        public Datetime createdDate { get; set; }


        public caseCommentsLite() {
        }

        public caseCommentsLite(CaseComment baseComment) {
            this.id = baseComment.Id;
            this.parentId = baseComment.ParentId;
            this.commentBody = baseComment.CommentBody;
            this.createdDate = baseComment.CreatedDate;
            this.createdByName = baseComment.CreatedBy.Name;
            this.createdByEmail = baseComment.CreatedBy.Email;
            try {
                this.createdByAvettaId = [
                        SELECT
                                Id,
                                Organizer_User_ID__c
                        FROM
                                Contact
                        WHERE
                                id = :baseComment.CreatedBy.Id
                ].Organizer_User_ID__c;

            } catch (Exception e) {
                API_CONNECT_Helpers.logException(e);
            }
        }

    }

    public class CaseRelatedClientsLite {

        public String id {
            get;
            set;
        }

        public CaseRelatedClientsLite() {
        }

        public CaseRelatedClientsLite(Id clientId) {
            this.id = clientId;
        }

    }

    @HttpGet
    global static caseLite[] getCaseById() {
        System.debug('getCaseById Call');
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String caseId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1);
        Case[] result;

        try {
            result = [
                    SELECT
                            recordtypeid,
                            CaseNumber,
                            Subject,
                            Type,
                            Sub_Type__C,
                            Organizer_Id__C,
                            Connect_Form_ID__c,
                            Connect_URL__c,
                            Status,
                            Last_Status_Change__c,
                            Valid_End_Date__c,
                            Valid_Start_Date__c,
                            Related_Supplier_Account__c,(
                            SELECT
                                    Id,
                                    ParentId,
                                    CommentBody,
                                    CreatedDate,
                                    CreatedBy.Id,
                                    CreatedBy.Name,
                                    CreatedBy.Email
                            FROM CaseComments
                            WHERE IsPublished = true
                            ORDER BY CreatedDate ASC
                    ), (
                            SELECT
                                    Id,
                                    Related_Case__c,
                                    Related_Client__c,
                                    CreatedDate
                            FROM Related_Clients__r
                    )
                    FROM Case
                    WHERE Connect_Form_ID__c = :caseId
                    //                    AND CreatedDate = LAST_N_MONTHS:6
            ];

        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);
        }

        CaseLite[] cases = new List<CaseLite>();

        for (Case c : result) {
            cases.add(new CaseLite(c));
        }

        return cases;
    }


    @HttpPut
    global static ID upsertCase (String supplierId, String connectUserId, String connectFormId, String connectFormType, String connectFormName, String connectUrl, String origin, String connectCrmId, String validStartDate, String validEndDate, List<String> relatedSiteIds, Boolean hiddenForm, String userEmail) {

        System.debug('upsertCase Call');
        System.debug('supplierId:');
        System.debug(supplierId);
        System.debug('connectUserId:');
        System.debug(connectUserId);
        System.debug('connectFormId:');
        System.debug(connectFormId);
        System.debug('connectFormType:');
        System.debug(connectFormType);
        System.debug('connectFormName:');
        System.debug(connectFormName);
        System.debug('origin:');
        System.debug(origin);
        System.debug('connectCrmId:');
        System.debug(connectCrmId);
        System.debug('validStartDate:');
        System.debug(validStartDate);
        System.debug('validEndDate:');
        System.debug(validEndDate);
        System.debug('relatedSiteIds');
        System.debug(relatedSiteIds);
        System.debug('hiddenForm');
        System.debug(hiddenForm);

        String recordNameId = null;
        list<RecordType> recordTypeName = new List<RecordType>([SELECT Id FROM RecordType WHERE SObjectType = 'Case' and Name = 'Connect']);
        if (recordTypeName.size() > 0) {
            system.debug('recordTypeName : ' + recordTypeName[0].Id);
            recordNameID = recordTypeName[0].Id;
        } else {
            recordNameId = null;
        }

        String AccountNameId = null;
        list<Account> accountName = new List<Account>([select Id from account where organizer_id__c = :supplierID]);
        if (accountName.size() > 0) {
            system.debug('accountName : ' + accountName[0].Id);
            accountNameId = accountName[0].Id;

        } else {
            accountNameId = null;
        }

        String contactNameId = null;
        String connectUserName = null;

        List<Contact> contactName = new List<Contact>([select Id, organizer_user_id__c from contact where organizer_user_id__c = :connectUserId]);
        if (contactName.size() > 0) {
            system.debug('contactName : ' + contactName[0].id);
            contactNameId = contactName[0].id;
            connectUserName = contactName[0].organizer_user_id__c;
        } else {
            contactNameId = null;
            connectUserName = null;
        }

        String existingCaseID = null;
        String existingCaseContact = null;
        String existingCasePriority = null;
        String existingCaseStatus = null;

        Case[] existingCase = [
                SELECT
                        Id,
                        contactId,
                        Priority,
                        Status,
                        OwnerId
                FROM
                        Case
                WHERE
                        connect_form_id__c = :connectFormId
        ];

        If (existingCase.size() > 0) {
            system.debug('ExistingCase : ' + existingCase[0].id);
            existingCaseId = existingCase[0].id;
            existingCaseContact = existingCase[0].contactId;
            existingCaseStatus = existingCase[0].status;
            //connectUserName = existingCase[0].organizer_user_id__c;
        } else {
            existingCaseId = null;
            existingCaseContact = null;
            existingCaseStatus = null;
            //connectUserName = null;
        }


        if (existingCase.size() > 0 && existingCaseContact != null) {
            system.debug('Existing Contact Name is : ' + existingCaseContact);
            existingCaseContact = existingCase[0].contactId;
        } else {
            system.debug('Existing Contact Name is Null');
            existingCaseContact = ContactNameId;

        }

        //Added by Dallin Wasden 1.18.19 to correct case priority bug (Jira PD-94)
        if (existingCase.size() > 0) {
            existingCasePriority = existingCase[0].Priority;
            system.debug('Existing Case Priority is : ' + existingCasePriority);
        } else {
            existingCasePriority = 'None';
            system.debug('Existing Case Priority is Null');
        }

        String statusToUse;
        if (connectFormName == 'Manual Audit' && existingCaseID == null) {
            statusToUse = 'Pending';
        } else if (connectFormName == 'Manual Audit' && connectCrmId == 'New' && existingCaseStatus == 'Pending') {
            statusToUse = 'Pending';
        } else if (connectFormName == 'Manual Audit' && connectCrmId == 'New' && existingCaseStatus == 'New') {
            statusToUse = 'New';
        }

        if (connectCrmId == 'new' && (connectFormName != 'Manual Audit')) {
            statusToUse = 'New';
        }
        if (connectCrmId == 'waitingOnSupplier') {
            statusToUse = 'Waiting on Supplier';
        }
        if (connectCrmId == 'waitingOnAvetta') {
            statusToUse = 'Waiting on Avetta';
        }
        if (connectCrmId == 'waitingOnClient') {
            statusToUse = 'Waiting on Client';
        }
        if (connectCrmId == 'waitingOnVariance') {
            statusToUse = 'Waiting on Variance';
        }
        if (connectCrmId == 'closed') {
            statusToUse = 'Closed';
        }

        if (connectCrmId == 'pending') {
            statusToUse = 'Pending';
        }

        if (hiddenForm == NULL) {
            hiddenForm = FALSE;
        }

        Id sfUser;
        if((connectFormType == 'docuGuard' || connectFormType == 'insureGuard') && existingCase.size() > 0 && statusToUse != existingCase[0].Status && userEmail != 'tester@avetta.com') {
        try {
            sfUser = [SELECT Id FROM User WHERE email =: userEmail AND UserType = 'Standard'][0].Id;
        } catch (Exception e) {
            if(existingCase.size() > 0) {
                sfUser = existingCase[0].OwnerId;
            } else {
                sfUser = [SELECT Id FROM User WHERE Name = 'Integration User'][0].Id;
            }
        }
        } else if(existingCase.size() > 0) {
            sfUser = existingCase[0].OwnerId;
        } else {
            sfUser = [SELECT Id FROM User WHERE Name = 'Integration User'][0].Id;
        }

        Datetime startDate;
        Datetime endDate;

        try {
            startDate = (Datetime) JSON.deserialize('"' + validStartDate + '"', Datetime.class);
        } catch (Exception e) {

        }

        try {
            endDate = (Datetime) JSON.deserialize('"' + validEndDate + '"', Datetime.class);
        } catch (Exception e) {

        }

        //1.31.20 added to fix auto-assignment rules that are defaulting to off
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;

        Case thisCase = new Case(
                RecordTypeId = recordNameId,
                AccountId = accountNameID,
                //ContactId = contactNameId,
                ContactId = existingCaseContact,
                Connect_Form_ID__C = connectFormId,    // Need this field to determine existing or new case
                Type = connectFormType,
                Subject = connectFormName,
                Connect_URL__C = connectUrl,
                Status = statusToUse,
                //Priority = 'None',
                //Priority = existingCasePriority,
                Origin = origin,
                //Id = existingCaseId,
                Valid_Start_Date__c = startDate,
                Valid_End_Date__c = endDate,
                HiddenForm__c = hiddenForm,
                OwnerId = sfUser
        );

        //1.31.20 added to fix auto-assignment rules that are defaulting to off
        thisCase.setOptions(dmo);

        //2.21.19 Changed to upsert based on external id
        Database.UpsertResult srList = Database.upsert(thisCase, Case.Connect_Form_ID__c, false);

        System.debug('thisCase = ' + thisCase);
        System.debug('relatedSiteIds = ' + relatedSiteIds);

        //Added by Dallin Wasden 1.29.19 to upsert Related Client objects
        if(relatedSiteIds != null && thisCase != null) {

            Id relatedCase;
            if(srList.getId() == NULL) {
                Case insertedCase = [select Id
                from Case
                where Connect_Form_ID__c =: connectFormId
                for update];
                relatedCase = insertedCase.Id;
                System.debug('srList == Null; relatedCase = ' + relatedCase);
            } else {
                relatedCase = srList.getId();
                System.debug('srList != Null; relatedCase = ' + relatedCase);
            }

            //Used to compare existing SFDC related clients to Connect related clients
            List<Related_Client_Case__c> existingRelatedClients = [
                    SELECT Id, Related_Client__r.Organizer_ID__c
                    FROM Related_Client_Case__c
                    WHERE Related_Case__c = :thisCase.Id
            ];

            System.debug('existingRelatedClients = ' + existingRelatedClients);

            //For querying related clients to retrieve Avetta ID
            List<String> existingClientIds = new List<String>();
            for(Related_Client_Case__c existingRelatedClient : existingRelatedClients) {
                existingClientIds.add(existingRelatedClient.Related_Client__r.Organizer_ID__c);
            }

            System.debug('existingClientIds = ' + existingClientIds);

            //Used to match related client account Connect id to the corresponding SFDC id
            List<Account> clientAccounts = [
                    SELECT Id, Organizer_ID__c
                    FROM Account
                    WHERE Organizer_ID__c = :relatedSiteIds
                    for update
            ];

            System.debug('clientAccounts = ' + clientAccounts);

            //Creates list of related client junction objects
            List<Related_Client_Case__c> relatedClientsList = new List<Related_Client_Case__c>();
            for (String clientId : relatedSiteIds) {
                if(existingClientIds.contains(clientId) == False) {
                    Account matchingAccount;
                    for (Account clientAccount : clientAccounts) {
                        if (String.valueOf(clientAccount.Organizer_ID__c) == clientId) {
                            matchingAccount = clientAccount;
                            System.debug('matchingAccount = ' + matchingAccount);
                        }
                    }
                    try {
                        Related_Client_Case__c thisRelatedClient = new Related_Client_Case__c(
                                Related_Client__c = matchingAccount.Id,
                                Related_Case__c = relatedCase
                                //Related_Case__c = insertedCase.Id
                        );
                        relatedClientsList.add(thisRelatedClient);
                    } catch (Exception e) {
                        API_CONNECT_Helpers.logException(e);
                    }
                }
            }

            System.debug('relatedClientsList = ' + relatedClientsList);
            if(relatedClientsList != null) {
                upsert relatedClientsList;
            }

            //If related clients list was already populated, check to see if any related client objects have been deleted in Connect and also delete in SFDC
            System.debug('relatedSiteIds = ' + relatedSiteIds);
            if (existingRelatedClients != null) {
                List<Related_Client_Case__c> deleteExistingClients = new List<Related_Client_Case__c>();
                for (Related_Client_Case__c existingRelatedClient : existingRelatedClients) {
                    System.debug('existingRelatedClient = ' + existingRelatedClient);
                    if (relatedSiteIds.contains(String.valueOf(existingRelatedClient.Related_Client__r.Organizer_ID__c)) == FALSE) {
                        deleteExistingClients.add(existingRelatedClient);
                    }
                }

                System.debug('deleteExistingClients = ' + deleteExistingClients);
                delete deleteExistingClients;
            } else {
                List<Related_Client_Case__c> deleteRelatedClients = [
                        SELECT Id
                        FROM Related_Client_Case__c
                        WHERE Related_Case__c = :thisCase.Id
                ];
                delete deleteRelatedClients;
            }
        }

        // Return the case ID.
        return thisCase.Id;
    }

    @HttpPost
    global static Id[] createCaseComment(String connectFormId, String commentBody) {

        integer i = 0;

        Case connectCase;
        while (i < 15 && connectCase == NULL) {
            try {
                connectCase = [
                        SELECT Id
                        FROM Case
                        WHERE Connect_Form_ID__c = :connectFormId
                        FOR UPDATE
                ];

            } catch (Exception e) {
                API_CONNECT_Helpers.logException(e);
            }
            System.debug('connectCase = ' + connectCase);
            ApexUtil.wait(500);
            i++;
        }


        if (connectCase == null) {
            connectCase = new Case();
            connectCase.Connect_Form_ID__c = connectFormId;

            Database.upsert(connectCase, case.Connect_Form_ID__c, false);
        }

        System.debug('insert caseComment = ' + 'connectCase.Id = ' + connectCase.Id + 'commentBody = ' + commentBody);
        CaseComment comment = new CaseComment(ParentId = connectCase.Id, CommentBody = commentBody, IsPublished = true);

        insert comment;

        Id[] returnId = new List<Id>();
        returnId.add(comment.Id);

        return returnId;
    }

    /*
@HttpPatch
global static ID updateCaseFields() {
System.debug('updateCaseFields Call');
RestRequest request = RestContext.request;
String caseId = request.requestURI.substring(
request.requestURI.lastIndexOf('/')+1);
Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
// Deserialize the JSON string into name-value pairs
Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
// Iterate through each parameter field and value
for(String fieldName : params.keySet()) {
// Set the field and value on the Case sObject
thisCase.put(fieldName, params.get(fieldName));
}
update thisCase;
return thisCase.Id;
}
*/


}