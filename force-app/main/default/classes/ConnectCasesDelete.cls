/**
 * Created by brett on 9/10/18.
 */

@RestResource(urlMapping='/avetta/formvalidation/delete/*')
global with sharing class ConnectCasesDelete {

    global class DeleteCasesResponse {
        public Boolean success { get; set; }
        public String message { get; set; }

        DeleteCasesResponse() {
            this.message = '';
        }
    }

    @HttpPost
    global static ConnectCasesDelete.DeleteCasesResponse deleteCasesFromConnectFormId(String[] connectFormIds) {

        DeleteCasesResponse results = new DeleteCasesResponse();
        results.success = true;

        try {
            Case[] casesToDelete = [
                    SELECT
                            Id
                    FROM Case
                    WHERE Connect_Form_ID__c in :connectFormIds
            ];


            delete casesToDelete;

        } catch (Exception e) {
            API_CONNECT_Helpers.logException(e);

            results.success = false;
            results.message = e.getMessage();

        }


        return results;
    }

}