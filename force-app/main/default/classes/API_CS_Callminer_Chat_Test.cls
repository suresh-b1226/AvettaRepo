/**
 * Created by JasonMcGrew on 3/4/2020.
 */

@IsTest public class API_CS_Callminer_Chat_Test implements HttpCalloutMock {

    @IsTest static void Callminer_API_Chat_Test() {

        User thisUser = [ SELECT Id FROM User WHERE Id = :UserInfo.getUserId() ];

        System.runAs ( thisUser ) {
            //Set up conditions to send email
            List<Account> accounts = QB_TestDataFactory.createAccountRecords(1, TRUE);
            List<Case> cases = QB_TestDataFactory.createCaseRecords(1, TRUE, accounts[0].Id);
            List<Contact> contacts = QB_TestDataFactory.createContactRecords(1, TRUE, accounts[0].Id);
            List<LiveChatVisitor> chatVisitors = QB_TestDataFactory.createChatVisitorRecord(1,True);
            List<LiveChatTranscript> chatTranscript = QB_TestDataFactory.createChatTranscriptRecord(1, FALSE, cases[0].Id, accounts[0].Id, contacts[0].Id);
            List<User> users = QB_TestDataFactory.createUserRecords(1, TRUE, '00e70000001974LAAQ', '00E70000001IdIYEA0');

            chatTranscript[0].CreatedBy = users[0];
            chatTranscript[0].CreatedDate = Datetime.now();
            chatTranscript[0].AverageResponseTimeOperator = 19;
            chatTranscript[0].MaxResponseTimeOperator = 27;
            chatTranscript[0].OperatorMessageCount = 5;
            chatTranscript[0].LiveChatButtonId = '57370000000blJsAAI';
            chatTranscript[0].LiveChatVisitorId = chatVisitors[0].Id;
            chatTranscript[0].LiveChatDeploymentId = '57270000000blJYAAY';
            chatTranscript[0].StartTime = Datetime.now();
            chatTranscript[0].EndTime = chatTranscript[0].StartTime.addSeconds(167);
            chatTranscript[0].EndedBy = 'Agent';
            chatTranscript[0].OwnerId = users[0].Id;
            chatTranscript[0].Status = 'Completed';
            chatTranscript[0].VisitorMessageCount = 4;

            System.debug('**chatTranscript** ' + chatTranscript[0]);


            insert chatTranscript[0];
            System.debug('**chatTranscript ID** ' + chatTranscript[0].Id);
            System.assert(chatTranscript[0].Id != NULL);

            chatTranscript[0].Body ='<p align="center">Chat Started: Friday, April 03, 2020, 08:28:52 (+0000)</p>( 8s ) Avetta Virtual Assistant - Supplier: Hello!<br>I am your Avetta Virtual Assistant.<br>( 10s ) Avetta Virtual Assistant - Supplier: How may I help you today?<br><br>Please pick from the list or type a question.<br>( 13s ) Avetta Virtual Assistant - Supplier: {ChatWindowButton:Canada - Annual update questions,United States - Annual Updates questions,Password Reset,Transfer To Agent,End Chat}<br>( 39s ) Gav: can&#39;t complete requirements<br>( 45s ) Avetta Virtual Assistant - Supplier: I didn&#39;t understand the request, I&#39;m still learning.<br>( 47s ) Avetta Virtual Assistant - Supplier: Would you like me to try again?<br>( 49s ) Avetta Virtual Assistant - Supplier: {ChatWindowButton:Yes,No}<br>( 52s ) Gav: No<br>( 55s ) Avetta Virtual Assistant - Supplier: Let me get you to an Avetta Professional right away. I know they will be able to help you.<br><p align="center">Agent Chatbot successfully transferred the chat to button ButtonId CSR English - Supplier</p><p align="center">Chat Started: Friday, April 03, 2020, 08:29:46 (+0000)</p><p align="center">Chat Origin: CSR English - Supplier</p><p align="center">Chat Transferred From Avetta Virtual Assistant - Supplier To Daniela D</p>( 57s ) Daniela D: Hello. My name is Daniela. How can I help you?<br>( 1m 48s ) Gav: Hi Daniela. I am trying to complete COVID-19 Pandemic Information for an Avetta client but I don&#39;t seem to be able to get past 83% completness<br>( 2m 20s ) Gav: I&#39;ve filled everything in but it won&#39;t let me submit<br>( 3m 34s ) Daniela D: let me check, one moment<br>( 6m 20s ) Daniela D: I believe two of the freetext fields haven&#39;t been saved and this is probably because of your spell checker. Please disable the spell checker and try filling in the fields again and you should be able to submit. Alternatively let me know what they should say and I can input the text for you<br>( 8m 22s ) Gav: That did the job. Many thanks<br>( 8m 30s ) Gav: Have a lovely day<br>( 9m 6s ) Daniela D: perfect<br>( 9m 11s ) Daniela D: thank you, ave a lovely day too!<br>( 9m 14s ) Daniela D: bye for now<br>'

                
                /*'<p align="center">Chat Started: Wednesday, November 08, 2017, 02:41:50 (-0800)</p><p align="center">Chat Origin: CSR English</p><p ' +
                    'align="center">Agent Beatrice S</p>( 1h 1m 44s ) Beatrice S: Hello. My name is Beatrice. How can I help you?<br>( 2m 16s ) Michelle Perry: good morning i was hoping you could tell me how i can download the Avetta logo ?<br>' +
                    '( 2m 44s ) Beatrice S: i can send you our logo by email. is michelle@ccsjeweltone.com  the best email address to which to send it, please?<br>' +
                    '( 3m 15s ) Michelle Perry: no i have recently taken over the roll of compliance manager so if you could please send to<br>( 3m 41s ) Michelle Perry: david@ccsjeweltone.com<br>' +
                    '( 3m 56s ) Beatrice S: thank you. email has been sent to david@ccsjeweltone.com<br>( 4m 1s ) Beatrice S: Is there anything further I can assist you with today?<br>' +
                    '( 4m 14s ) Michelle Perry: many thanks have a good day<br>( 4m 28s ) Beatrice S: You are welcome. Thank you for chatting with Avetta and enjoy your day!<br>'*/ ;
            update chatTranscript[0];

            System.assert(chatTranscript[0].Body != NULL);
        }
    }
    public static HttpResponse respond(HttpRequest req) {
        //mock response callout here
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"CorrelationId":"50c30fce-3c2a-48c5-b5f1-ee37a61108fa","MiningId":"f7a9c469-fa1a-4a8f-bd2d-0170a676aece"}');
        res.setStatusCode(200);
        return res;
    }
}