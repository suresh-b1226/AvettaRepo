/******************************************************************************************************************************************
*
* WRITTEN BY: Dallin Wasden 2.12.2020
*
* SUMMARY OF USAGE:
* CallMiner is a platform used for call, chat, and email analytics. It is capable of transcribing phone calls to text and analyzing those
* interactions between our reps and customers. This class is designed to be triggered upon the end of each inbound Talkdesk phone call for the
* specified ring groups (on insert of Talkdesk_Activity).
*
* This class was written to integrate Salesforce with CallMiner's ingestion API. Here is a list of steps the class uses to form the integration:
*   1) Using a JWT Token (which was given to us by CallMiner) to authenticate, the class first POSTs the phone call metadata to the ingestion API.
*   2) The ingestion API then creates a session and responds with a session id.
*   3) We make a GET call using the Talkdesk recording URL to retrieve the audio file and convert it to a binary data file.
*   4) Then we use the previously retrieved session id and make a second POST call to send the audio file of the phone call. The ingestion
*       API then takes the metadata and the audio file and saves it in its database.
*
******************************************************************************************************************************************/

public class API_CS_Callminer_Audio {

    //Data mapping logic to match Talkdesk activity fields with their corresponding fields in CallMiner
    public void generateTalkDeskJSON(List<talkdesk__Talkdesk_Activity__c> taList) {
        //SOQL query automation switch
        Automation_Switch__mdt audioSwitch = [
                SELECT Id, Label, On_Off__c
                FROM Automation_Switch__mdt
                WHERE Label = 'CS: Talkdesk Audio API'
        ][0];

        if(audioSwitch.On_Off__c == TRUE) {
            String jwtToken = [SELECT Token__c
            					FROM CallMiner_JWT_Token__mdt][0].Token__c;


            List<Id> activityList = new List<Id>();
            for(talkdesk__Talkdesk_Activity__c act : taList) {
                activityList.add(act.talkdesk__User__c);
            }

            List<Id> accountIds = new List<Id>();
            for(talkdesk__Talkdesk_Activity__c act : taList) {
                accountIds.add(act.talkdesk__Account__c);
            }

            List<Id> caseIds = new List<Id>();
            for(talkdesk__Talkdesk_Activity__c act : taList) {
                caseIds.add(act.talkdesk__Case__c);
            }

            List<Id> userIds = new List<Id>();
            for(talkdesk__Talkdesk_Activity__c act : taList) {
                userIds.add(act.talkdesk__User__c);
            }

            Map<Id, User> activityMap = new Map<Id, User>([SELECT Name
                                                           FROM User
                                                           WHERE Id IN: activityList]);

            Map<Id, Account> accountMap = new Map<Id, Account> ([SELECT Id, Name, BillingState, BillingCountry
                                                            FROM Account
                                                            Where Id in: accountIds]);

            Map<Id, Case> caseMap = new Map<Id, Case> ([SELECT Id, CaseNumber
                                                        FROM Case
                                                        Where Id in: caseIds]);

            Map<Id, User> userMap = new Map<Id, User> ([SELECT Id, Name, Team_Lead__c, Team_Lead__r.Name
                                                        FROM User
                                                        WHERE Id in: userIds]);

			System.debug('activtyMap = ' + activityMap);
            for (talkdesk__Talkdesk_Activity__c ta : taList) {
                System.debug('ta = ' + ta);
            
            //Limiting which Talkdesk calls are passed to Callminer
            if(ta.talkdesk__Type__c == 'Outbound' || ta.talkdesk__Type__c == 'Inbound') {
                 
                if(ta.talkdesk__Recording__c != NULL &&
                   		ta.talkdesk__Type__c != NULL && (
                        ta.talkdesk__Ring_Groups__c != NULL && (
                        ta.talkdesk__Ring_Groups__c.containsIgnoreCase('CSR') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('CHD') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('SER') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('SDR') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('MYM') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('retention') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('premium support') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('uk premium support') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('rejection solution line') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('vetify') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('verification') ||
                                ta.talkdesk__Ring_Groups__c.containsIgnoreCase('agents')))) {

                    //Mapping of Talkdesk fields to Callminer's receiving data fields
                    //Any fields added here will be dynamically added elsewhere (view Callminer documentation to see which fields are available)
                    Map<String, String> tdDTOMap = new Map<String, String>();
                     
                    if (accountMap.size() == 0) {    
                    }            
                                    
                    else {                
                    
                        tdDTOMap.put('Location', accountMap.get(ta.talkdesk__Account__c).BillingState + ' ' + accountMap.get(ta.talkdesk__Account__c).BillingCountry);
                    }
                                    
                    tdDTOMap.put('ClientCaptureDate', String.ValueOf(ta.talkdesk__Start_Time__c));
                    tdDTOMap.put('AudioFileLocation', ta.talkdesk__Recording__c);
                    tdDTOMap.put('ClientID', ta.talkdesk__Talkdesk_Id__c);
                    
                    if(activityMap.size() == 0) {                    
                    }
                                    
                    else {
                                    
                    	tdDTOMap.put('Agent', activityMap.get(ta.talkdesk__User__c).Name);
                    }
                     
                    if(userMap.size() == 0) {                
                    }
                                    
                    else {
                   		
                        tdDTOMap.put('AgentGroup', userMap.get(ta.talkdesk__User__c).Team_Lead__r.Name);                
                    }
                                    
                    tdDTOMap.put('CustomerAccount', ta.talkdesk__Account__c);
                    tdDTOMap.put('TotalHoldSeconds', String.ValueOf(ta.talkdesk__Hold_Time_sec__c));
                    tdDTOMap.put('Subject', ta.Name);
                    tdDTOMap.put('Description', ta.talkdesk__Notes__c);
                    tdDTOMap.put('ExitStatus', ta.talkdesk__Disposition_Code__c);
                    tdDTOMap.put('WaitTimeSeconds', String.ValueOf(ta.talkdesk__Wait_Time_sec__c));
                    tdDTOMap.put('UDF_text_01', ta.talkdesk__Contact_Phone__c);
                    tdDTOMap.put('UDF_text_02', ta.talkdesk__Talkdesk_Phone_Number__c);

                    if(caseMap.size() == 0) {                    
                    }
                                    
                    else {
                                    
                    	tdDTOMap.put('UDF_text_03', caseMap.get(ta.talkdesk__Case__c).CaseNumber);
                    }
                                    
                    tdDTOMap.put('CreateDate', String.ValueOf(ta.CreatedDate));
                    tdDTOMap.put('UDF_text_06', 'https://avetta.lightning.force.com/' + ta.Id);
                    tdDTOMap.put('UDF_Int_01', String.ValueOf(ta.talkdesk__Talk_Time_sec__c));

                    metadataToCallminer(tdDTOMap, ta.talkdesk__Recording__c, jwtToken);
                }
              }
           }
        }
    }

    /* Takes the data from the triggered call, uses the data mapping above, and sends the metadata in a POST call
    * to CallMiner's ingestion API.
    * Included also is a JSON generator that dynamically writes JSON based on the specified fields that are available on
    * the object (not null). Refer to the CallMiner Ingestion API documentation for more information on how this body was formed.
    * A successful POST call will return a Session ID as a response from CallMiner.
    */
    @future(callout=TRUE)
    public Static void metadataToCallminer(Map<String, String> td, String audioURL, String jwtToken) {

        //Included this audio file retrieval here because the audio file size is needed for both POST calls in the 'TotalMediaLength' field
        Blob audioBlob = getAudioFileFromURL(audioURL);

        //Instantiates request and sets endpoint, method, and headers
        HttpRequest req = new HttpRequest();

        req.setEndpoint('https://ingestion.callminer.net/api/session/metadatamedia');
        req.setMethod('POST');

        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', jwtToken);

        //Uses JSON generator to form request body with data as mapped above
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();

        gen.writeStringField('MediaType', 'audio/mp3');
        gen.writeStringField('SourceId', 'avetta_audio');
        if (audioBlob.size() != NULL) gen.writeStringField('TotalMediaLength', String.ValueOf(audioBlob.size()));
        if (td.get('ClientCaptureDate') != NULL) gen.writeStringField('ClientCaptureDate', td.get('ClientCaptureDate'));
        if (td.get('ClientID') != NULL) gen.writeStringField('CorrelationId', td.get('ClientID'));

        gen.writeFieldName('Metadata');
        gen.writeStartArray();
        System.debug('td.keySet() = ' + td.keySet());

        for (String k : td.keySet()) {

            if (td.get(k) != NULL) {
                gen.writeStartObject();
                gen.writeStringField('Key', k);
                gen.writeStringField('Value', String.ValueOf(td.get(k)));
                gen.writeEndObject();
            }
        }
        gen.writeEndArray();
        gen.writeEndObject();
        System.debug(gen.getAsString());

        req.setBody(gen.getAsString());

        Http http = new Http();
        HTTPResponse response;

        if(!Test.isRunningTest()) {
            response = http.send(req);
        } else {
            response = API_CS_Callminer_Audio_Test.Respond(req);
        }

        parseSessionIdFromResponse(response, audioBlob, jwtToken);
    }

    /* This method simply parses the Session ID from CallMiner's response in preparation for making the second POST call
    * with the audio file.
    */
    public Static Void parseSessionIdFromResponse(HTTPResponse response, Blob audioBlob, String jwtToken) {
        System.debug('response = ' + response.getBody());
        String body = response.getBody();

        //Parses JSON to retrieve SessionId
        JSONParser parser = JSON.createParser(body);
        parser.nextToken();
        parser.nextValue();
        String sessionId = parser.getText();
        System.debug('sessionId = ' + sessionId);
        audioFileToCallminer(sessionId, audioBlob, jwtToken);
    }

    /* Takes the previously retrieved SessionId and bundles it with the binary data audio file and POSTs them to the CallMiner
    * Ingestion API.
    */
    public Static Void audioFileToCallminer(String sessionId, Blob audioBlob, String jwtToken) {

        //Instantiates request and sets endpoint, method, and headers
        HttpRequest req = new HttpRequest();

        req.setEndpoint('https://ingestion.callminer.net/api/media/' + sessionId);
        req.setMethod('POST');

        req.setHeader('Content-Type', 'audio/mp3');
        req.setHeader('Authorization', jwtToken);
        req.setHeader('Content-Length', String.ValueOf(audioBlob.size()));

        req.setBodyAsBlob(audioBlob);

        Http http = new Http();
        HTTPResponse response;

        if(!Test.isRunningTest()) {
            response = http.send(req);
            System.debug('response = ' + response);
        } else {
            response = API_CS_Callminer_Audio_Test.Respond(req);
        }
    }

    /* Takes the audio url and makes a GET call to retrieve the file. I had some issues with the Talkdesk links redirecting
    * to an AWS server where the file was actually stored, so I included a while loop to successfully handle the redirects
    * until the call landed at the proper location. Then, the response is retrieved as a binary media file in preparation
    * to make the second POST request to CallMiner.
    */
    public static Blob getAudioFileFromURL(String audioURL) {

        HttpRequest req = new HttpRequest();

        req.setEndpoint(audioURL);
        req.setTimeout(60000);
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse response;

        if(!Test.isRunningTest()) {
            response = http.send(req);
        } else {
            response = API_CS_Callminer_Audio_Test.Respond(req);
        }
        System.debug('response = ' + response);

        //Helps handle redirects
        while (response.getStatusCode() == 302) {
            req.setEndpoint(response.getHeader('Location'));
            response = new Http().send(req);
        }

        Blob body = response.getBodyAsBlob();
        return(body);
    }
}