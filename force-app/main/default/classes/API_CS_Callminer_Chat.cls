/******************************************************************************************************************************************
*
* Created by Jason McGrew on 02.14.2020 For SF Case 01800177
*
* SUMMARY OF USAGE:
* CallMiner is a platform used for call, chat, and email analytics. It is capable of transcribing phone calls to text and analyzing those
* interactions between our reps and customers. This class is designed to be triggered upon the update of a LiveChatTranscript and to
* specific ChatButtons.
*
* This class was written to integrate Salesforce with CallMiner's ingestion API. Here is a list of steps the class uses to form the integration:
*   1) A JWT token is passed through for authentication purposes to allow access
*   2) A map is created to translate data from salesforce to be sent to callminer
*   3) The chat body comes in as an String HTML body and is parsed into individual lines
*	4) The data is then sent via post request to callminer
*
******************************************************************************************************************************************/

public class API_CS_Callminer_Chat  {

    public class chatTranscriptHeader {
        public String chatStarted;
        public String chatOrigin;
        public String agent;
    }

    public class chatTranscript {
        public String chatBody;
        public String chatTimeString;
        public Integer speaker;
        public String textInformation;
        public String timeSpanStamp;
    }

    public class timeSpan {
        public Integer hours;
        public Integer minutes;
        public Integer seconds;
    }
    // This Method gets the Automation switch to be able to turn on/off the LiveChatTranscript trigger via UI.
    public Boolean getCallminerChatSwitchStatus() {
        Automation_Switch__mdt CS_Callminer_Chat_API = [
                SELECT On_Off__c
                FROM Automation_Switch__mdt
                WHERE Label = 'CS: Callminer Chat API'
        ];
        return CS_Callminer_Chat_API.On_Off__c;
    }

    // This method populates the Metadata to pass via API from the LiveChatTranscript Object. Querys for the jwt token as well as
    // which ChatButton the class will trigger on.
    public void generateChatTranscriptJSON(List<LiveChatTranscript> chatList) {

        if(getCallminerChatSwitchStatus() == true) {

            String jwtToken = [
                    SELECT Token__c
                    FROM CallMiner_JWT_Token__mdt
            ][0].Token__c;

            List<Id> accountIds = new List<Id>();
            for(LiveChatTranscript chats : chatList) {
                accountIds.add(chats.AccountId);
            }
            
            Map<Id, Account> accountMap = new Map<Id, Account> ([SELECT Id, Name, BillingState, BillingCountry
                                                                 FROM Account
                                                                 Where Id in: accountIds]);
            
            List<Id> caseIds = new List<Id>();
            for(LiveChatTranscript chats : chatList) {
                caseIds.add(chats.CaseId);
            }
            
            Map<Id, Case> caseMap = new Map<Id, Case> ([SELECT Id, CaseNumber
                                                        FROM Case
                                                        Where Id in: caseIds]);

            List <LiveChatButton> chatButtonIdList = [
                    SELECT Id, DeveloperName
                    FROM LiveChatButton
                    WHERE DeveloperName = 'CSR_English'
                    OR DeveloperName    = 'CSR_English_Client'
                    OR DeveloperName    = 'CSR_English_Supplier'
            ];
            System.debug('chatButtonIdList = ' + chatButtonIdList);

            Map<String, Id> buttonIdMap = new Map<String, Id>();
            for (LiveChatButton lbc : chatButtonIdList) {
                if ( chatButtonIdList != null) {
                    if (lbc.DeveloperName == 'CSR_English') {
                        buttonIdMap.put(lbc.DeveloperName, lbc.Id);
                    } else if (lbc.DeveloperName == 'CSR_English_Client') {
                        buttonIdMap.put(lbc.DeveloperName, lbc.Id);
                    } else if (lbc.DeveloperName == 'CSR_English_Supplier') {
                        buttonIdMap.put(lbc.DeveloperName, lbc.Id);
                    }
                }
            }
            
            System.debug('buttonIdMap = ' + buttonIdMap);

            List<Id> userIds = new List<Id>();
            for(LiveChatTranscript chats : chatList) {
                userIds.add(chats.OwnerId);
            }
            
            Map<Id, User> teamLeadMap = new Map<Id, User> ([SELECT Id, Name, Team_Lead__c, Team_Lead__r.Name
                                                        FROM User
                                                        WHERE Id in: userIds]);
            
            List<Id> chatUserIdList = new List<Id>();
            for(LiveChatTranscript cl : chatList) {
                chatUserIdList.add(cl.OwnerId);
            }

            Map<Id, User> userMap = new Map<Id, User>([
                    SELECT Name
                    FROM User
                    WHERE Id IN: chatUserIdList]);

            System.debug('USER MAP: ' + teamLeadMap.size());
            System.debug('USER: ' + teamLeadMap);
    
            for (LiveChatTranscript lct : chatList) {
                if(chatList != null && lct.Status == 'Completed' && lct.Body != null && userMap.get(lct.OwnerId).Name != 'Automated Process'){
                    if (lct.LiveChatButtonId == buttonIdMap.get('CSR_English') ||
                            lct.LiveChatButtonId == buttonIdMap.get('CSR_English_Client') ||
                            lct.LiveChatButtonId == buttonIdMap.get('CSR_English_Supplier')) {

                        Map<String, String> chatDTOMap = new Map<String, String>();

                        chatDTOMap.put('ClientCaptureDate', String.valueOf(lct.StartTime));
                        chatDTOMap.put('ClientID', lct.LiveChatVisitorId);
                        
                        if(accountMap.size() == 0) {
                        }
                                
                        else {            
                        	chatDTOMap.put('Location', accountMap.get(lct.AccountId).BillingState + ' ' + accountMap.get(lct.AccountId).BillingCountry);
                        }
                                
                        if(userMap.size() == 0) {
                        }
                                
                        else {
                                
                        	chatDTOMap.put('Agent', userMap.get(lct.OwnerId).Name);
                        }
                                    
                        chatDTOMap.put('CustomerAccount', lct.AccountId);
                        chatDTOMap.put('Subject', lct.Name);
                        chatDTOMap.put('Description', lct.Body);
                        chatDTOMap.put('ReferrerURL', lct.ReferrerUri);
                        chatDTOMap.put('ExitStatus', lct.Status);
                        chatDTOMap.put('WaitTimeSeconds', String.valueOf(lct.WaitTime));
                     
                        if(caseMap.size() == 0) {
                        }
                                
                        else {
                                
                        	chatDTOMap.put('UDF_text_03', caseMap.get(lct.CaseId).CaseNumber);
                        }
                                
                        chatDTOMap.put('CreateDate', String.valueOf(lct.CreatedDate));
                        chatDTOMap.put('UDF_Date_01', String.valueOf(lct.EndTime));
                        chatDTOMap.put('UDF_Date_02', String.valueOf(lct.RequestTime));
                        chatDTOMap.put('UDF_Int_02', String.valueOf(lct.MaxResponseTimeVisitor));
                        chatDTOMap.put('UDF_Int_03', String.valueOf(lct.AverageResponseTimeVisitor));
                        chatDTOMap.put('UDF_Int_04', String.valueOf(lct.ChatDuration));
                        chatDTOMap.put('UDF_Int_05', String.valueOf(lct.OperatorMessageCount));
                        chatDTOMap.put('UDF_Int_06', String.valueOf(lct.MaxResponseTimeOperator));
                        chatDTOMap.put('UDF_Int_07', String.valueOf(lct.AverageResponseTimeOperator));
                        chatDTOMap.put('UDF_Int_08', String.valueOf(lct.Abandoned));                             
                        chatDTOMap.put('AgentGroup', teamLeadMap.get(lct.OwnerId).Team_Lead__r.Name);                        
                              	
                                
                        chatDTOMap.put('UDF_text_06', 'https://avetta.lightning.force.com/' + lct.Id);
                                
                        System.debug('chatDTOMap = ' + chatDTOMap);
                        System.debug('LiveChatButtonId = ' + lct.LiveChatButtonId);
                        chatBodyParser(chatDTOMap, lct.Body, jwtToken);
                    }
                }
            }
        }
    }
    // This Method will parse the chat transcript body into 2 different classes, ChatTranscriptHeader(CTH) and ChatTranscript(CT).
    // The CTH populates 3 fields and the CT populate the actual chat and data that comes with it.
    public static void chatBodyParser (Map<String, String> cTranscript, String chatBody, String jwtToken) {

        Boolean chatBot_Chat = false;
        String chatBot_Body;
        String body_Minus_ChatBot_Body;
        String body;
        chatBody = chatBody;

        if (chatBody.contains('Avetta Virtual Assistant')) {

            chatBot_Chat = true;
            System.debug('Is this a chatBot_Chat? = ' + chatBot_Chat);
            chatBot_Body = chatBody.substringBetween('Chat Started:','Chat Started:');
            body_Minus_ChatBot_Body = chatBody.remove(chatBot_Body);
            body = body_Minus_ChatBot_Body;

        } else {
            chatBot_Chat = false;
            body = chatBody;
        }

        System.debug('Is this a chatBot_Chat? = ' + chatBot_Chat);
        System.debug('body = ' + body);
        System.debug('chatBot_Body = ' + chatBot_Body);
        System.debug('body_Minus_chatBot_Body = ' + body_Minus_ChatBot_Body);

        String removeHTMLTags = '<[^>]*>';
        chatTranscriptHeader cth = new chatTranscriptHeader();
        List<chatTranscript> ctList = new List<chatTranscript>();
        Map<String, String> allCTH = new Map<String, String>();
        Map<String, String> allCT = new Map<String, String>();
        List<String> chatTimesStamp = new List<String>();
        List<String> chatStartedTime = new List<String>();


        List<String> chatBodyList = new List<String>();
        List<Integer> speakerList = new List<Integer>();
        List<String> textInformationList = new List<String>();
        List<String> timeSpanStampList = new List<String>();

        List<String> bodyHeaderLines = body.split('</p>');
        String bodyStrings = bodyHeaderLines[3];
        bodyHeaderLines.remove(3);
        System.debug('bodyHeaderLines = ' + bodyHeaderLines);
        System.debug('bodyStrings = ' + bodyStrings);

        List<String> bhlStrings = new List<String>();

        for (String bhl : bodyHeaderLines) {
            if (bodyHeaderLines != null) {
                bhl = bhl.replaceAll(removeHTMLTags, '');
                bhlStrings.add(bhl);
            }
        }
        System.debug('bhlStrings = ' + bhlStrings);

        if (chatBot_Chat == true) {
            cth.chatStarted = bhlStrings[0].remove('Chat Started:Chat Started: ');
        } else if (chatBot_Chat == false) {
            cth.chatStarted = bhlStrings[0].remove('Chat Started: ');
        }
        allCTH.put('Chat Started:', cth.chatStarted);
        chatStartedTime.add(cth.chatStarted);

        cth.chatOrigin = bhlStrings[1].remove('Chat Origin: ');
        allCTH.put('Chat Origin:', cth.chatOrigin);

        if (chatBot_Chat == true) {
            cth.agent = bhlStrings[2].remove('Chat Transferred From Avetta Virtual Assistant - Supplier To ');
        } else if (chatBot_Chat == false) {
            cth.agent = bhlStrings[2].remove('Agent ');
        }
        allCTH.put('Agent', cth.agent);

        System.debug('cth.chatStarted = ' + cth.chatStarted);
        System.debug('cth.chatOrigin  = ' + cth.chatOrigin);
        System.debug('cth.agent       = ' + cth.agent);
        System.debug('allCTH MAP      = ' + allCTH);

        List<String> bodyLines = bodyStrings.split('<br>');
        System.debug('bodyLines = ' + bodyLines);
        String previousTimeString;
        Integer previousSpeaker;
        String speaker;
        for (String bLine : bodyLines) {
            if (bodyLines != null && bLine != '') {

                System.debug('bLine = ' + bLine);

                chatTranscript ct = new chatTranscript();

                ct.chatTimeString = bLine.substringBetween('( ', ' ) ');
                String test = bLine.substringBetween('( ', ' ) ');
                if (test == null) {
                    ct.chatTimeString = previousTimeString;
                } else {
                    previousTimeString = ct.chatTimeString;
                }

                chatTimesStamp.add(ct.chatTimeString);
                ct.timeSpanStamp = convertStringToTime(cth.chatStarted, chatTimesStamp);
                timeSpanStampList.add(ct.timeSpanStamp);

                ct.chatBody = bLine.substringAfter(': ');

                if (String.isBlank(ct.chatBody)) {
                    ct.chatBody = bLine;
                }
                //System.debug('bodyLineString = ' + bodyLineString);
                System.debug('ct.chatBody = ' + ct.chatBody);
                chatBodyList.add(ct.chatBody);
                speaker = bLine.substringBetween(') ', ': ');

                if (speaker == null) {
                    ct.speaker = previousSpeaker;
                }
                if (speaker == cth.agent || ct.speaker == 0) {
                    ct.speaker = 0;
                    System.debug('agentSpeaker = ' + ct.speaker);
                    ct.textInformation = cth.agent;
                    speakerList.add(ct.speaker);
                    previousSpeaker = ct.speaker;
                    if (ct.textInformation == null) {
                        ct.textInformation = 'Agent:';
                    } else {
                        textInformationList.add(ct.textInformation);
                    }

                    System.debug('ct.textInformation = ' + ct.textInformation);
                } else {
                    ct.speaker = 1;
                    System.debug('visitorSpeaker = ' + ct.speaker);
                    ct.textInformation = 'Customer:';
                    speakerList.add(ct.speaker);
                    previousSpeaker = ct.speaker;
                    System.debug('ct.textInformation = ' + ct.textInformation);
                    textInformationList.add(ct.textInformation);
                }
            }
        }

        System.debug('chatTimesStamp = ' + chatTimesStamp);

        chatMetadataToCallminer(cTranscript, allCTH, jwtToken, chatBodyList, speakerList, textInformationList, timeSpanStampList);
    }

    // This method will take the chat time from the above method and covert it to a DateTime. It will then take each 'time span' number from each chat line and
    // create a chat span time stamp that gets passed over with each chat text line so you know the time of each chat text line.
    public static String convertStringToTime(String stringDate, List<String> timeToAdd) {

        Map <String, Integer> monthNames = new Map <String, Integer> {'January'=>1, 'February'=>2, 'March'=>3, 'April'=>4, 'May'=>5, 'June'=>6, 'July'=>7, 'August'=>8, 'September'=>9, 'October'=>10, 'November'=>11, 'December'=>12};

        List<String> sList = new List<String>();
        List<String> stringParts = stringDate.split(' ');
        for (String s : stringParts) {
            if (stringParts != null) {
                s = s.remove(',');
                sList.add(s);
            }
        }
        System.debug('sList = ' + sList);

        Integer timeZone = Integer.valueOf(sList[5].substringBetween('(',')'));
        System.debug('timeZone = ' + timeZone);
        Integer i = 0100;
        Integer convertedTZ = timeZone/i;

        System.debug('convertedTZ = ' + convertedTZ);

        List<String> timeParts = sList[4].split(':');


        System.debug('stringParts = ' + stringParts);
        Datetime convertedString = Datetime.newInstanceGmt(Integer.valueOf(sList[3]), monthNames.get(sList[1]), Integer.valueOf(sList[2]), Integer.valueOf(timeParts[0]), Integer.valueOf(timeParts[1]), Integer.valueOf(timeParts[2]));
        Datetime convertedTimeZoneDT = convertedString.addHours(convertedTZ);
        System.debug('convertedString = ' + convertedString);
        System.debug('convertedTimeZoneDT = ' + convertedTimeZoneDT);
        System.debug('timeToAdd = ' + timeToAdd);

        List<String> t = new List<String>();
        for (String s : timeToAdd) {
            if (timeToAdd != null) {
                s = s.trim();
                t.add(s);
            }
        }
        System.debug('t = ' + t);

        Boolean noHours   = false;
        Boolean noMinutes = false;
        String timeStamp;
        List<timeSpan> timeSpanList = new List<timeSpan>();
        String removeCharacters = '[a-z]';

        for (String sToSplit : t ) {
            if (t != null) {
                timeSpan ts = new timeSpan();

                if (sToSplit.contains('h') == true) {
                    noHours = false;

                    sToSplit = sToSplit.replaceAll(removeCharacters, '');

                    String secondsValue = sToSplit.substringAfterLast(' ');
                    ts.seconds = Integer.valueOf(secondsValue);

                    String hourValue = sToSplit.substringBefore(' ');
                    ts.hours = Integer.valueOf(hourValue);

                    String minuteValue = sToSplit.substringBetween(' ');
                    ts.minutes = Integer.valueOf(minuteValue);

                } else if (sToSplit.containsNone('h') == true && sToSplit.contains('m') == true) {
                    noHours = true;
                    sToSplit = sToSplit.replaceAll(removeCharacters, '');

                    String minuteValue = sToSplit.substringBefore(' ');
                    ts.minutes = Integer.valueOf(minuteValue);

                    String secondsValue = sToSplit.substringAfter(' ');
                    ts.seconds = Integer.valueOf(secondsValue);

                } else if (sToSplit.containsNone('h') == true && sToSplit.containsNone('m') == true && sToSplit.contains('s') == true) {
                    noHours = true;
                    noMinutes = true;
                    sToSplit = sToSplit.replaceAll(removeCharacters, '');

                    String secondsValue = sToSplit;
                    ts.seconds = Integer.valueOf(secondsValue);
                }
                timeSpanList.add(ts);
            }
        }
        System.debug('timeSpanList    = ' + timeSpanList);

        for(timeSpan ts : timeSpanList){
            if (timeSpanList != null) {
                if (noHours == false) {

                    Datetime addHrs = convertedTimeZoneDT.addHours(ts.hours);
                    Datetime addMin = addHrs.addMinutes(ts.minutes);
                    Datetime totalTimeSpan = addMin.addSeconds(ts.seconds);
                    timeStamp = String.valueOfGmt(totalTimeSpan);

                } else if (noHours == true && noMinutes == false) {
                    Datetime addMin = convertedTimeZoneDT.addMinutes(ts.minutes);
                    Datetime totalTimeSpan = addMin.addSeconds(ts.seconds);
                    timeStamp = String.valueOfGmt(totalTimeSpan);

                } else if (noHours == true && noMinutes == true) {
                    Datetime totalTimeSpan = convertedTimeZoneDT.addSeconds(ts.seconds);
                    timeStamp = String.valueOfGmt(totalTimeSpan);

                }
            }
        }
        return timeStamp;
    }
    /* Takes the data from the triggered call, uses the data mapping above, and sends the metadata in a POST call
    * to CallMiner's ingestion API.
    * Included also is a JSON generator that dynamically writes JSON based on the specified fields that are available on
    * the object (not null). Refer to the CallMiner Ingestion API documentation for more information on how this body was formed.
    * A successful POST call will return a Session ID as a response from CallMiner.
    */
    @Future(Callout=true)
    public static void chatMetadataToCallminer(Map<String, String> cTranscript, Map<String, String> allCTH, String jwtToken, List<String> chatBodyList, List<Integer>speakerList, List<String>textInformationList, List<String>timeSpanStampList){

        //Instantiates request and sets endpoint, method, and headers
        HttpRequest req = new HttpRequest();

        req.setEndpoint('https://ingestion.callminer.net/api/transcript');
        req.setMethod('POST');

        req.setHeader('Authorization', jwtToken);
        req.setHeader('Content-Type', 'application/json');

        //Uses JSON generator to form request body with data as mapped above
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();

        gen.writeFieldName('Metadata');
        gen.writeStartArray();

        for (String key : cTranscript.keySet()) {
            if (cTranscript.get(key) != null) {
                gen.writeStartObject();
                gen.writeStringField('Key', key);
                gen.writeStringField('Value', String.valueOf(cTranscript.get(key)));
                gen.writeEndObject();
            }
        }
        gen.writeEndArray();
        gen.writeStringField('MediaType', 'chat');
        gen.writeStringField('SourceId', 'avetta_text');
        gen.writeStringField('ClientCaptureDate', cTranscript.get('ClientCaptureDate'));
        gen.writeStringField('CorrelationId', cTranscript.get('ClientID'));

        gen.writeFieldName('Transcript');
        gen.writeStartArray();
        Integer i = 0;
        for (String headerKey : allCTH.keySet()) {
            if (allCTH.get(headerKey) != null) {
                gen.writeStartObject();
                gen.writeStringField('Key', headerKey);
                gen.writeStringField('Value', String.valueOf(allCTH.get(headerKey)));
                gen.writeEndObject();
            }
        }

        if (speakerList != null && chatBodyList != null && timeSpanStampList != null && textInformationList != null) {
            for (i = 0; i < speakerList.size(); i++) {
                gen.writeStartObject();
                gen.writeNumberField('Speaker', speakerList[i]);
                gen.writeStringField('Text', chatBodyList[i]);
                gen.writeStringField('PostDateTime', timeSpanStampList[i]);
                gen.writeStringField('TextInformation', textInformationList[i]);
                gen.writeEndObject();
                System.debug('gen = ' + gen.toString());
            }
        }

        gen.writeEndArray();
        gen.writeEndObject();

        System.debug('TEAM LEAD: ' + cTranscript.get('AgentGroup'));

        
        
        System.debug(gen.getAsString());

        req.setBody(gen.getAsString());

        Http http = new Http();
        HttpResponse response;

        if(!Test.isRunningTest()) {
            response = http.send(req);
            System.debug('Response ' + response.getBody());
        }
        else {
            response = API_CS_Callminer_Chat_Test.Respond(req);
        }
    }
}