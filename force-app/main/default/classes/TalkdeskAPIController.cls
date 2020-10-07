@RestResource(urlMapping='/talkdeskAPI/*')
global class TalkdeskAPIController {
    @HttpPost
    global static void getEmailFromID(String action_type, String orgID){
        
        JSONGenerator gen = JSON.createGenerator(true);
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        //Variables
        String response = 'failure';
		String pAccount = 'No Account Found';
        String accID    = 'No Account Found';
	    String pEmail   = 'No Owner Listed on Account';
        String oEmail   = 'No Opportunity Owner';
        String oId   = 'No Opportunity Id';
        
        //Checks Payload
        if ((action_type.equals('support')||action_type.equals('registration'))&& string.isNotEmpty(orgID)){
            
            System.debug('Org ID -- '+orgID);
            System.debug('Action Type -- '+action_type);
            List <Account> a = new List <Account>();
            List <Opportunity> opp = new List <Opportunity>();
            
            a=[SELECT ID, Name, ownerID 
               FROM Account 
               WHERE organizer_ID__c=:orgID Limit 1];

            if(a.size()>0){
                System.debug('Account -- '+a[0].Name);
                if(a[0].ownerID !=NULL){
                    User u =[SELECT ID, Name, Email 
                             FROM User 
                             WHERE ID=:a[0].ownerID];
                    System.debug('User -- '+u.Name);
                    pEmail = u.Email; 
                }
                response = 'success';
                pAccount = a[0].Name;
                accID = a[0].id;
            }
            if (action_type.equals('registration')&& string.isNotEmpty(orgID) && a.size()>0){
               opp =[SELECT ID, Name, LastActivityDate, StageName , Type, RecordType.Name, OwnerID, Owner.Name, Opp_Owner_Email__c 
                      FROM Opportunity 
                      WHERE AccountID =:a[0].id AND StageName NOT IN ('Closed Won', 'Commit') AND LastActivityDate >=: system.today()-7 AND (Type='Registration' OR Type='Reactivation') AND RecordType.Name ='Supplier' Limit 1];
                }
                if(opp.size()>0){
                    oId = opp[0].id; 
                    List<User> u2 =[SELECT ID, Name, Email, UserRole.Name
                              		FROM User WHERE ID=:opp[0].ownerID LIMIT 1];
                    system.Debug('SOQL RESULT ----- '+ u2);
                    if(u2.size()>0){
                        oEmail = u2[0].Email;
                    }
                }
                    
        }
        System.debug('');
        // Write JSON Body
        gen.writeStartObject();
        gen.writeStringField('Status', response);
        gen.writeStringField('AccountName' , pAccount);
        gen.writeStringField('AccountID', accID );
        if(string.isEmpty(orgID)){
            orgID = 'No Org ID Entered';
        }
        gen.writeStringField('Org', orgID );
        if(oEmail.equals('No Opportunity Owner')){
           gen.writeStringField('OwnerEmail', pEmail);
        }
        else{
           gen.writeStringField('OwnerEmail', oEmail); 
        }
        gen.writeStringField('OppID', oId);
        gen.writeEndObject();
         
        // Get the JSON string.
        String pretty = gen.getAsString();
         
        // Send Body
        res.responseBody = Blob.valueOf(pretty);
       
    }

}