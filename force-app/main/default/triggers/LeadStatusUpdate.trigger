trigger LeadStatusUpdate on Task (after insert) {
    
    List<Profile> currentProfile = [Select Id, Name from Profile where Id=: userInfo.getProfileId()];
    String profileName = currentProfile.size() > 0 ? currentProfile[0].Name : NULL;
    
    if(profileName != 'Bizable User') {
        
        boolean doUpdate = false;
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String,String> keyPrefixMap = new Map<String,String>{};
            Set<String> keyPrefixSet = gd.keySet();
        for(String sObj : keyPrefixSet){
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            String tempName = r.getName();
            String tempPrefix = r.getKeyPrefix();
            keyPrefixMap.put(tempPrefix,tempName);
        }
        
        for(Task t : Trigger.new){
            System.debug('task:' + t);
            
            // check for valid WhoID
            if(t.WhoId != null && !String.isBlank(t.Subject) && t.Subject.contains('Call') ) {
                System.debug('CALL TASK FOR LEAD FOUND');
                String tPrefix = t.WhoId;
                tPrefix = tPrefix.subString(0,3);
                System.debug('Task Id[' + t.id + '] is associated to Object of Type: ' + keyPrefixMap.get(tPrefix));
                
                System.debug('call type' + t.CallType);
                
                // check for Lead as associated object
                if (keyPrefixMap.get(tPrefix) == 'Lead') {
                    // update the dial out/in count
                    
                    System.debug('LEAD FOUND');
                    Lead lead = [SELECT Name, Id, Status, Inbound_Calls__c, Outbound_Calls__c FROM Lead WHERE Id =: t.WhoId LIMIT 1];
                    
                    if (lead.Status == 'Open') {
                        // get all calls associated with the given lead that aren't the one that was just made
                        List<Task> leadTasks = [SELECT Subject, Id, WhoId FROM Task WHERE WhoId =: lead.Id AND Subject = 'Call'];
                        if (leadTasks.size() <= 1) {
                            System.debug('FIRST TASK LOGGED');
                            lead.Status = 'Working - Contacted';
                            doUpdate = true;
                            System.debug(lead.Status);
                        } else {
                            System.debug('OTHER TASKS FOUND');
                        }
                    }
                    
                    
                    // these outbound/inbound are new fields for the cisco dialer
                    if (t.CallType == 'Outbound') {
                        doUpdate = true;
                        lead.Outbound_Calls__c = lead.Outbound_Calls__c == null ? 1 : lead.Outbound_Calls__c + 1;
                    } else if (t.CallType == 'Inbound') {
                        System.debug('incrementing inbound');
                        doUpdate = true;
                        lead.Inbound_Calls__c = lead.Inbound_Calls__c == null ? 1 : lead.Inbound_Calls__c + 1;
                    }
                    if (doUpdate) update lead;
                    
                } else if (keyPrefixMap.get(tPrefix) == 'Contact') {
                    System.debug('CONTACT FOUND');
                    Contact ct = [SELECT Id, Inbound_Calls__c, Outbound_Calls__c  FROM Contact WHERE Id =: t.WhoId LIMIT 1];
                    // these outbound/inbound are new fields for the cisco dialer
                    
                    if (t.CallType == 'Outbound') {
                        doUpdate = true;
                        ct.Outbound_Calls__c = ct.Outbound_Calls__c == null ? 1 : ct.Outbound_Calls__c + 1;
                    } else if (t.CallType == 'Inbound') {
                        System.debug('incrementing inbound');
                        
                        doUpdate = true;
                        ct.Inbound_Calls__c = ct.Inbound_Calls__c == null ? 1 : ct.Inbound_Calls__c + 1;       		              	
                    }
                    
                    if (doUpdate) update ct;
                }
            }
        }
    }   
}