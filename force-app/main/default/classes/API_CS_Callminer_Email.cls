/************************************************************************************************************************************************
* Created by MarkSimpson on 2/14/2020.
*
* SUMMARY OF USAGE:
* CallMiner is a platform used for call, chat, and email analytics. It is capable of transcribing phone calls to text and analyzing those
* interactions between our reps and customers. This class is triggered on the insertion of a email message.
*
* This class was written to integrate Salesforce with CallMiner's ingestion API. Here is a list of steps the class uses to form the integration:
*   1) A JWT token is passed through for authentication purposes to allow access 
*   2) A map is created to translate data from salesforce to be sent to callminer
*	3) The data is then sent via post request to callminer
*************************************************************************************************************************************************/

public class API_CS_Callminer_Email {
    
/*******************************************************************************
*The purpose of the below method is to assign and map variables that are
* used in the api for an email message text call. The JWT token is first
* found and assigned by a soql query that is already located in the system
* this allows proper authentication to take place. Once this is done,
* a map assigned to the EmailMessage object is created and all the required
* api fields are mapped to their corresponding fields inside of the email
* message object. The finalized map values and jwt token are sent to callminer
*******************************************************************************/
    public void generateEmailJson(list<EmailMessage> emailList) {
        
        String jwtToken = [
            SELECT Token__c
            FROM CallMiner_JWT_Token__mdt][0].Token__c;
        
        Automation_Switch__mdt emailSwitch = [
            SELECT Id, Label, On_Off__c
            FROM Automation_Switch__mdt
            WHERE Label = 'CS: Callminer Email API'
        ];
        
        List<Id> relatedToIds = new List<Id>();
        for(EmailMessage email : emailList) {
            
            if(email.RelatedToId == null) {
            }
            
            else {
                
                if (email.RelatedToId.getSObjectType() == Schema.Opportunity.getSObjectType()) {
                    relatedToIds.add(email.RelatedToId);
                }
            }
        }
        
        Map<Id, Opportunity> relatedToMap = new Map<Id, Opportunity> ([SELECT Id, AccountId
                                                                       FROM Opportunity
                                                                       WHERE Id in: relatedToIds]);
        
        List<Id> userIds = new List<Id>();
        for(EmailMessage email : emailList) {
            userIds.add(email.CreatedById);
        }
        
        List<Id> nameUserIds = new List<Id>();
        for(EmailMessage email : emailList) {
            nameUserIds.add(email.CreatedById);
        }
        
        List<Id> caseIds = new List<Id>();
        for(EmailMessage email : emailList) {
            
            
            
            if(email.RelatedToId == null) {
            }
            
            else {
                
                if(email.RelatedToId.getSObjectType() == Schema.Case.getSObjectType()) {
                    caseIds.add(email.RelatedToId);
                }
            }
        }
        
        List<Id> optyIds = new List<Id>();
        for(EmailMessage email : emailList) {
            
            if(email.RelatedToId == null) {
            }
            
            else {
                
                if(email.RelatedToId.getSobjectType() == Schema.Opportunity.getSObjectType()) {
                    optyIds.add(email.RelatedToId);
                }
            }
        }
        
        Map<Id, Case> caseMap = new Map<Id, Case> ([SELECT Id, AccountId, CaseNumber
                                                    FROM Case
                                                    WHERE Id in: caseIds]);
        
        Map<Id, Opportunity> optyMap = new Map<Id, Opportunity> ([SELECT Id, AccountId
                                                                  FROM Opportunity
                                                                  WHERE Id in: optyIds]);
        
        List<Id> accountIds = new List<Id>();
        for(EmailMessage email : emailList) {
            
            if(email.RelatedToId == null) {                
            }
            
            else {
                
                if(email.RelatedToId.getSObjectType() == Schema.Account.getSObjectType()) {
                    accountIds.add(email.RelatedToId);
                }
                
                else if (email.RelatedToId.getSObjectType() == Schema.Opportunity.getSObjectType()) {
                    accountIds.add(relatedToMap.get(email.RelatedToId).AccountId);
                }
                
                else if (email.RelatedToId.getSObjectType() == Schema.Case.getSObjectType()) {
                    accountIds.add(caseMap.get(email.RelatedToId).AccountId);
                }
                
                else if (email.RelatedToId.getSobjectType() == Schema.Opportunity.getSObjectType()) {
                    optyIds.add(optyMap.get(email.RelatedToId).AccountId);
                }
            }
        }
        
        Map<Id, User> userMap = new Map<Id, User> ([SELECT Id, Name, Team_Lead__r.Name
                                                    FROM User
                                                    WHERE Id in: nameUserIds]);
        
        Map<Id, User> profileMap = new Map<Id, User> ([SELECT Id, Profile.Name
                                                       FROM User
                                                       WHERE Id in: userIds]);
        
        Map<Id, Account> accountMap = new Map<Id, Account> ([SELECT Id, Name, BillingState, BillingCountry
                                                             FROM Account
                                                             Where Id in: accountIds]);
        
        System.debug('CASES:' + caseMap);
        System.debug('EMAIL LIST: ' + emailList);
        System.debug('profileMap = ' + profileMap);
        System.debug('Account map= ' + accountMap);
        System.debug('Account map size=  ' + accountMap.size());
        
        if(emailSwitch.On_Off__c == TRUE) {
            
            for (EmailMessage email : emailList) {
                System.debug('NAME ' + profileMap.get(email.CreatedById));
                System.debug('ID ' + profileMap.get(email.CreatedById).Profile.Name);
                If (profileMap.get(email.CreatedById).Profile.Name != NULL &&
                    (profileMap.get(email.CreatedById).Profile.Name.containsIgnoreCase('CSR')
                     || (profileMap.get(email.CreatedById).Profile.Name.containsIgnoreCase('SSP Leadership'))
                     || (profileMap.get(email.CreatedById).Profile.Name.containsIgnoreCase('SSP High Value')) 
                     || (profileMap.get(email.CreatedById).Profile.Name.containsIgnoreCase('SER'))
                     || (profileMap.get(email.CreatedById).Profile.Name.containsIgnoreCase('Premium Support User'))
                     || (profileMap.get(email.CreatedById).Profile.Name.containsIgnoreCase('vetify'))
                     || (profileMap.get(email.CreatedById).Profile.Name.containsIgnoreCase('CSR/SER Hybrid')) 
                     || (profileMap.get(email.CreatedById).Profile.Name.containsIgnoreCase('System Administrator'))))
                {
                    Map<String, String> emailDTO = new Map<String, String>();
                    System.debug('profile name: ' + profileMap.get(email.CreatedById).Profile.Name);
                    if (accountMap.size() == 0) {
                    }
                    
                    else {
                        
                        if (email.RelatedToId.getSObjectType() == Schema.Account.getSObjectType()) {
                            
                            emailDTO.put('Location', accountMap.get(email.RelatedToId).BillingState + ' ' + accountMap.get(email.RelatedToId).BillingCountry);
                        }
                        
                        else if (email.RelatedToId.getSObjectType() == Schema.Opportunity.getSObjectType()) {
                            
                            emailDTO.put('Location', accountMap.get(optyMap.get(email.RelatedToId).AccountId).BillingState + ' ' + accountMap.get(optyMap.get(email.RelatedToId).AccountId).BillingCountry);
                        }
                        
                        else if (email.RelatedToId.getSObjectType() == Schema.Case.getSObjectType()) {
                            
                            emailDTO.put('Location', accountMap.get(caseMap.get(email.RelatedToId).AccountId).BillingState + ' ' + accountMap.get(caseMap.get(email.RelatedToId).AccountId).BillingCountry);
                        }
                    }
                    
                    if(userMap.size() == 0) {
                    }
                    
                    else {
                        emailDTO.put('Agent', userMap.get(email.CreatedById).Name);
                    }
                    
                    emailDTO.put('Description', String.ValueOf(email.TextBody));
                    
                    if (accountMap.size() == 0) {
                    }
                    
                    else {
                        
                        if (email.RelatedToId.getSObjectType() == Schema.Account.getSObjectType()) {
                            
                            emailDTO.put('CustomerAccount', accountMap.get(email.RelatedToId).Id);
                        }
                        
                        else if (email.RelatedToId.getSObjectType() == Schema.Opportunity.getSObjectType()) {
                            
                            emailDTO.put('CustomerAccount', accountMap.get(optyMap.get(email.RelatedToId).AccountId).Id);
                        }
                        
                        else if (email.RelatedToId.getSObjectType() == Schema.Case.getSObjectType()) {
                            
                            emailDTO.put('CustomerAccount', accountMap.get(caseMap.get(email.RelatedToId).AccountId).Id);
                        }
                    }
                    
                    emailDTO.put('Subject', String.ValueOf(email.Subject));
                    emailDTO.put('ClientCaptureDate', String.ValueOf(email.CreatedDate));
                    
                    if (caseMap.size() == 0) {
                    }
                    
                    else {
                        
                        if (email.RelatedToId.getSObjectType() == Schema.Case.getSObjectType()) {
                            
                            emailDTO.put('UDF_text_03', caseMap.get(email.RelatedToId).CaseNumber);
                        }
                    }
                    
                    emailDTO.put('CreateDate', String.ValueOf(email.MessageDate));
                    emailDTO.put('ClientId', email.Id);
                    emailDTO.put('Speaker', String.ValueOf(email.CreatedById));
                    emailDTO.put('TextInformation', email.FromAddress);
                    
                    if(userMap.size() == 0) {
                    }
                    
                    else {
                        emailDTO.put('AgentGroup', userMap.get(email.CreatedById).Team_Lead__r.Name);
                    }
                    
                    emailDTO.put('UDF_text_06', 'https://avetta.lightning.force.com/' + email.Id);
                    
                    if(email.EmailTemplateId == NULL) {
                        emailDataToCallminer(emailDTO, jwtToken);
                    }
                    
                    else {
                        System.debug('Automated Email Detected '  + email.EmailTemplateId);
                    }
                }
            }
        }
    }
    
    /************************************************************************************
*This method is similar to the audio transcript with the exception that it is meant
* to send a call containing data related to the emailmessage object. First the endpoint
* is assigned to be a transcript. Next the proper authorization and headers are assigned
* Lastly, a json generator is created that takes all the required values of the api
* and translates them to recognizable json. The array and loop section is meant to
* go through the part of the request that is assigned as an array and contains the email
* body itself. Finally, the json body is finalized and sent to callminer
************************************************************************************/
    
    @future(callout=TRUE)
    public Static void emailDataToCallminer(Map<String, String> email, string jwtToken) {
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://ingestion.callminer.net/api/transcript');
        req.setMethod('POST');
        
        req.setHeader('Authorization', jwtToken);
        req.setHeader('Content-Type', 'application/json');
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        if (email.get('ClientID') != NULL) {
            gen.writeStringField('CorrelationId', email.get('ClientID'));
        }
        
        gen.writeFieldName('Metadata');
        gen.writeStartArray();
        
        for (String key : email.keySet()) {
            if (email.get(key) != NULL) {
                gen.writeStartObject();
                gen.writeStringField('Key', key);
                gen.writeStringField('Value', String.ValueOf(email.get(key)));
                gen.writeEndObject();
            }
        }
        
        gen.writeEndArray();
        
        gen.writeStringField('MediaType', 'Email');
        gen.writeStringField('ClientCaptureDate', email.get('ClientCaptureDate'));
        gen.writeStringField('SourceId', 'avetta_text');
        gen.writeStringField('CorrelationId', email.get('ClientId'));
        
        gen.writeFieldName('Transcript');
        gen.writeStartArray();
        gen.writeStartObject();
        
        gen.writeStringField('Text', email.get('Description'));
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        
        req.setBody(gen.getAsString());
        
        Http http = new Http();
        HTTPResponse response;
        
        if(!Test.isRunningTest()) {
            response = http.send(req);
            system.debug('Response ' + response.getBody());
        } 
        
        else {
            response = API_CS_Callminer_Email_Test.Respond(req);
        }
    }
}