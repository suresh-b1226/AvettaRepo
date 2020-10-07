/**
 * Created by brett on 2/26/18.
 */
@RestResource(urlMapping='/avetta/V1/OperatorContractor/*')
Global class API_CONNECT_OperatorContractor {

    /**
     * Data transfer object for Connect to consume
     */
    global class OperatorContractorLight {

        global String contractorKey { get; set; }
        global String operatorKey { get; set; }
        global String status { get; set; }
        global String name { get; set; }


        /**
         * Empty Constructor
         */
        public OperatorContractorLight() {
        }

        /**
         * Constructor that fills properties with the Operator_Contractor__c equivalent from the provided parameter
         *
         * @param operatorContractor
         */
        global OperatorContractorLight(Operator_Contractor__c operatorContractor) {
            this.contractorKey = operatorContractor.Contractor__r.Organizer_ID__c;
            this.status = operatorContractor.Status__c;

            this.name = operatorContractor.Name;
            this.operatorKey = operatorContractor.Operator__r.Organizer_ID__c;

        }

        public Operator_Contractor__c toCustomObject(Operator_Contractor__c returnObject) {

            returnObject.Status__c = this.status;
            returnObject.Organizer_Key__c = this.getConnectionKey();


            if (returnObject.Contractor__c == null) {
                returnObject.Contractor__r = [SELECT Id, Organizer_ID__c, Status__c From Account Where Organizer_ID__c = :this.contractorKey LIMIT 1];
                returnObject.Contractor__c = returnObject.Contractor__r.Id;
            }

            if (returnObject.Operator__c == null) {
                returnObject.Operator__r = [SELECT Id, Organizer_ID__c FROM Account WHERE Organizer_ID__c = :this.operatorKey LIMIT 1];
                returnObject.Operator__c = returnObject.Operator__r.Id;
            }

            return returnObject;
        }

        public String getConnectionKey() {
            return this.operatorKey + '-' + this.contractorKey;
        }
    }


    @HttpGet
    global static OperatorContractorLight[] getOperatorContractorById() {
        System.debug('START API_CONNECT_OperatorContractor.getOperatorContractorById');

        RestRequest request = RestContext.request;
        // grab the operatorContractorId from the end of the URL
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);


        Map <String, String> params;
//        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.statusCode = 200;
        params = request.params;
        System.debug('params: ' + params);
//        string id = params.get('id');
//        string id = '12347-12343';//params.get('id');
//        OrganizerId = params.get('orgid');


        System.debug(id);
//        System.debug('OrganizerId:' + OrganizerId);

        Operator_Contractor__c operatorContractor = [
                SELECT
                        Contractor__c,
                        Contractor__r.Organizer_ID__c,
                        Id,
                        Initial_Payment_Made__c,
                        Name,
                        Status__c,
                        Operator__c,
                        Operator__r.Organizer_ID__c,
                        Organizer_Key__c
                FROM Operator_Contractor__c
                WHERE
                        Organizer_Key__c = :id
        ];

        System.debug(operatorContractor);

        OperatorContractorLight[] returnObject = new List<OperatorContractorLight>();

        returnObject.add(new OperatorContractorLight(operatorContractor));

        System.debug(returnObject);


        System.debug('END API_CONNECT_OperatorContractor.getOperatorContractorById');
        return returnObject;

    }

/*
    @HttpPost
    global static ID createOperatorContractor(String recordTypeId, String connectFormType, String connectFormId, String connectUrl, String status, String origin, String priority, String organizerUserId) {

    }
*/

    @HttpPut
    global static OperatorContractorLight[] upsertOperatorContractor(OperatorContractorLight operatorContractor) {

        System.debug('START API_CONNECT_OperatorContractor.upsertOperatorContractor');


        RestResponse response = RestContext.response;
        response.statusCode = 200;

        Operator_Contractor__c operatorContractorIds;


        try {

            operatorContractorIds = [
                    SELECT
                            Id,
                            Contractor__c,
                            Contractor__r.Organizer_ID__c,
                            Operator__c,
                            Operator__r.Organizer_ID__c,
                            Status__c
                    FROM Operator_Contractor__c
                    WHERE Organizer_Key__c = :operatorContractor.getConnectionKey()
            ];
        } catch (Exception e) {


            if (operatorContractorIds == null) {
                operatorContractorIds = new Operator_Contractor__c();
            }
        }

        System.debug(operatorContractorIds);

        Operator_Contractor__c operatorContractorToUpsert = operatorContractor.toCustomObject(operatorContractorIds);

        System.debug(operatorContractorToUpsert);

        try {
            upsert operatorContractorToUpsert;
        } catch (Exception e) {
            System.debug(e);

        }
        OperatorContractorLight[] returnObject = new List<OperatorContractorLight>();

        returnObject.add(new OperatorContractorLight(operatorContractorToUpsert));


        System.debug(returnObject);


        System.debug('END API_CONNECT_OperatorContractor.upsertOperatorContractor');

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