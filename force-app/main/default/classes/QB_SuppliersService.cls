public class QB_SuppliersService
{
    private static integer totalAcc = 0; 
    private static integer totalOpp = 0; 
    private static integer totalCon = 0; 
    
    public static SIT_Settings__c sitSettings ;
    
   public static String getDefaultOpportunityOwner ()
    { 
        if(sitSettings == Null
           
          ) {
              sitSettings = SIT_Settings__c.getInstance('General SIT');    
          } 
        
        return sitSettings.Default_Opportunity_Owner__C;
    }
    
    
   public static void validateCampaigns(Set<String> campaignIds)
    {
        try
        {
            // Query for campaigns based on provided campaign ids
            Map<Id, Campaign> campaignsMap = new Map<Id, Campaign>([
                SELECT Id, Client_Account__c
                FROM Campaign
                WHERE Id IN :campaignIds
            ]);
            
            for(String campaignId : campaignIds)
            {
                if(campaignId == null)
                    throw new QB_SupplierConvertionException('Campaign Id cannot be blank');
                
                campaignId = String.escapeSingleQuotes(campaignId);
                if((campaignId.length() != 15 && campaignId.length() != 18) || !Pattern.matches('^[a-zA-Z0-9]*$', campaignId)){
                    throw new QB_SupplierConvertionException('This Campaign ID is invalid. Please provide a valid Salesforce Campaign ID : ' + campaignId);
                }
                // Validate campaign exists in database
                Campaign campaign = campaignsMap.get((Id)campaignId);
                if(campaign == null)
                {
                    throw new QB_SupplierConvertionException('This Campaign does not have a client associated to it.' +
                                                    ' The Campaign must have an associated Client before this list is uploaded : ' + campaignId);
                }
                // Validate if campaign has a client account
                if(campaign.Client_Account__c == NULL)
                {
                    throw new QB_SupplierConvertionException('This campaign does not have a client account: ' + campaignId);
                }
            }
        }
        catch(Exception e)
        {
            throw e;
        }
    }
    
   /* public static Map<Id, List<Supplier_Staging__c>> validateIfCampaignInStagingTable(Set<Id> campaignIds)
    {
        Map<Id, List<Supplier_Staging__c>> stagingByCampaignIds = new Map<Id, List<Supplier_Staging__c>>();
        try
        {
            List<Supplier_Staging__c> supplierStagings = [
                SELECT Id, Campaign__c
                FROM Supplier_Staging__c
                WHERE Campaign__c IN :campaignIds
            ];
            
            for(Supplier_Staging__c supplierStaging : supplierStagings)
            {
                if(stagingByCampaignIds.containsKey(supplierStaging.Campaign__c))
                {
                    List<Supplier_Staging__c> supplierStagingList = stagingByCampaignIds.get(supplierStaging.Campaign__c);
                    supplierStagingList.add(supplierStaging);
                    stagingByCampaignIds.put(supplierStaging.Campaign__c, supplierStagingList);
                }
                else
                {
                    stagingByCampaignIds.put(supplierStaging.Campaign__c, new List<Supplier_Staging__c>{supplierStaging});
                }
                
            }
        }
        catch(Exception e)
        {
            throw e;
        }
        return stagingByCampaignIds;
    }*/

    /*public static List<Supplier_Staging__c> loadSuppliersFromCSV(Map<Id, Map<String, Blob>> csvBlobsByFileNameByCampaignIds)
    {

        List<Supplier_Staging__c> supplierStagings = new List<Supplier_Staging__c>();
        
        Set<Id> campaignIds = csvBlobsByFileNameByCampaignIds.keySet();
        system.debug('Log CampaignId' + CampaignIds);
        try
        {
            // Loop through given campaigns
            for(Id campaignId : csvBlobsByFileNameByCampaignIds.keySet())
            {
                system.debug('Log CampaignId' + CampaignIds);
                // Get our filename and csv blob and convert to supplier staging records
                Map<String, Blob> csvByFileName = csvBlobsByFileNameByCampaignIds.get(campaignId);
                for(String fileName : csvByFileName.keySet())
                {
                    Blob csvFileBody = csvByFileName.get(fileName);
                    system.debug('Log CampaignId' + CampaignId);
                    supplierStagings.addAll(convertCSVBlobToSupplierStaging(campaignId, csvFileBody));
                }
            }
            insert supplierStagings;
        }
        catch(Exception e)
        {
            throw e;
        }
        
        return supplierStagings;
    }*/
    
    public static integer deleteSuppliers(Set<String> campaignIds) {
        List<Supplier_Staging__C> staginglist = [ SELECT Id  FROM Supplier_Staging__C WHERE Campaign__c = :campaignIds];
        try { delete staginglist ; }
        catch(DMLexception e)
        { throw e; }
        return staginglist.size();
    }
    /*
    private static List<Supplier_Staging__c> convertCSVBlobToSupplierStaging(String campaignId, Blob csvFileBody)
    {
        String csvAsString = csvFileBody.toString();
        //System.debug(csvFileLines.size()+' --- after toString');
        
        List<List<String>> csvParsedResult = CSVReader.readIETFRFC4180CSVFile(csvFileBody);
        
        String[] csvFileLines = csvAsString.split('r\n');
        
        System.debug(csvFileLines.size() + ' --- after split');
        
        //Map<Integer, String> headersMap = getHeaderMap(csvFileLines.get(0));
        //Newly added for the new CSV Parser
        Map<Integer, String> headersMap = new Map<Integer, String>();
        
        for(integer i =0;  i< csvParsedResult[0].size(); i++)
        {
            headersMap.put(i, csvParsedResult[0][i]);
        }
        
        //HeaderMap {0->'Name', 1->'Id', 2->'City'}
        System.debug('===> HeadersMap = ' + headersMap);
        System.debug('===> csvFileLines = ' + csvFileLines);
        List<Supplier_Staging__C> stagList = new List<Supplier_Staging__C>();
        
        for(Integer i = 1; i < csvParsedResult.size(); i++)
        {
            System.debug('File Size: ' + csvFileLines.size() );
            Supplier_Staging__C stagObj = new Supplier_Staging__c();
            //System.debug('===> csvFileLines[i] = ' + csvFileLines[i]);
            // Map<String, String> rowMap = getRowMap(headersMap, csvFileLines[i]);
            
            //Newly added fro the new csv parser
            Map<String, String> rowMap = new Map<String, String> ();
            
            Boolean isEmptyRow = true;
            for(Integer j=0; j< csvParsedResult[i].size(); j++)
            {
                if( !String.isBlank(csvParsedResult[i][j]))
                    isEmptyRow = false;
            } 
            
            if(isEmptyRow)
                continue;
            
            for(Integer j=0; j< csvParsedResult[i].size(); j++)
            {
                rowMap.put(headersMap.get(j), csvParsedResult[i][j]);               
            }
            
            
            //rowMap {'Name'->'Test', 'Id'->'1', 'City'->'Irvine'} This is an example of what will happen
            System.debug('===> rowMap = ' + rowMap);
            
            
            
            stagObj.Company__c = rowMap.get('Supplier Company Name');
            stagObj.Street__c = rowMap.get('Street Address');
            stagObj.City__c = rowMap.get('City');
            stagObj.State__c = rowMap.get('State');
            stagObj.Postal_Zip_Code__c = rowMap.get('Postal/Zip Code');
            stagObj.Country__c = rowMap.get('Country');
            stagObj.First_Name__c = rowMap.get('Contact First Name');
            stagObj.Last_Name__c = rowMap.get('Contact Last Name');
            stagObj.Email__c = rowMap.get('Contact Email Address');
            stagObj.Phone__c = rowMap.get('Contact Phone Number');
            stagObj.Website__c = rowMap.get('Website');
            stagObj.Account_Type__c = 'Contractor';
            stagObj.Additional_information__c = rowMap.get('Additional Information');
            stagObj.Priority__c = rowMap.get('Priority');
            
            if(rowMap.get('Match_1_AccountId__c') != null)
            {
                stagObj.Match_1_AccountId__c  = rowMap.get('Match_1_AccountId__c');
            }
            
            
            if(rowMap.get('Match_1_Id') != null)
            {
                stagObj.Match_1_Id__c = rowMap.get('Match_1_Id');
            }

            //stagObj.Client_Organizer_ID__c = rowMap.get('Client Organizer ID');
            if(rowMap.get('Client_Organizer_ID__c') != null)
            {
                stagObj.Client_Organizer_ID__c  = rowMap.get('Client Organizer ID');
            }
            //stagObj.Campaign_ID__c = rowMap.get('Campaign ID');
            stagObj.Campaign__c = campaignId;
            //stagObj.Owner_ID__c = rowMap.get('Owner ID');
            if(rowMap.get('Owner ID') != null && rowMap.get('Owner ID').trim()!= '')
            {
                system.debug(logginglevel.info,'ownerId = ' + rowMap.get('Owner ID'));
                stagObj.Owner_ID__c = rowMap.get('Owner ID');
            }
            //System.debug(csvFileLines.size()+'2');
            
            staglist.add(stagObj);
        }
        return stagList;
    }
    
    private static Map<Integer, String> getHeaderMap(String headerRowStr)
    {
        List<String> headerValues = headerRowStr.split(',');
        Map<Integer, String> headerMap = new Map<Integer, String>();
        for(Integer i = 0; i < headerValues.size(); i++)
        {
            headerMap.put(i, headerValues.get(i));
        }
        System.debug ('headermap' + headerMap);
        return headerMap;
    }
    
    private static Map<String, String> getRowMap(Map<Integer, String> headerMap, String rowStr)
    {
        System.debug('rowStr' + rowStr);
        List<String> rowValues = rowStr.split(',');
        system.debug('rowValues' + rowValues);
        Map<String, String> rowMap = new Map<String, String>();
        
        for(Integer i = 0; i < rowValues.size(); i++)
        {
            if(headerMap.get(i) != null && rowValues.get(i) != null)
            {
                rowMap.put(headerMap.get(i), rowValues.get(i));
                system.debug('rowMap' + rowMap);
            }
        }
        system.debug('rowMap' + rowMap);
        return rowMap;
    }
*/    
    // class SupplierLoadException extends Exception{}
    
    /*
* * Method that converts the suppliers
* */
    
  /*  public static void convertSuppliers(Id campaignId)
    
    {
        Campaign c = new Campaign();
        
        
        Map<Id, Supplier_Staging__c> stagData = new Map<Id,Supplier_Staging__c>([SELECT Account_ID__c,Additional_information__c,Campaign__c,City__c,Organizer_ID__c,Contact_ID__c,
                                                                                 Company__c,Country__c,Email__c, First_Name__c,IsDeleted, Converted__c, Last_Name__c,Owner_ID__c,Name,Phone__c,
                                                                                 Postal_Zip_Code__c,Priority__c,State__c,Street__c,Tax_Id__c,Website__c 
                                                                                 FROM Supplier_Staging__c
                                                                                 WHERE Campaign__c =:campaignId]);
        c = [SELECT  id, Client_Account__c from Campaign where id = :campaignId] ;
        
        Set<Id> accountIds = new Set<id>();
        Set<Id> contactsIds = new Set<id>();
        Set<Id> opportunityIds = new Set<id>();
        
        for(Supplier_Staging__c supplier : stagData.values())
        {
            if(supplier.Account_ID__c  != NULL)
            {
                accountIds.add(supplier.Account_ID__c );
            }
            
            //do this for all account field and all contact fields
            if(supplier.Contact_ID__c  != NULL)
            {
                contactsIds.add(supplier.Contact_ID__c );

            }
        }
        
        //Query all Accounts - All fields to query
        Map<Id, Account> accountsMap = new Map<Id, Account>([Select id, Name from Account where Id IN :accountIds]);
        
        //Query all Contacts - All fields to query
        Map<Id, Contact> contactsMap;
        
        Map<Id, Account> supplierIdToAccountMap = new Map<Id, Account>();
        Map<Id, Contact> supplierIdToContactMap = new Map<Id, Contact>();
        Map<Id, Opportunity> supplierIdToOpportunityMap = new Map<Id, Opportunity>();
        List<OppToContactWrapper> opportunityToContact = new  List<OppToContactWrapper>();
        
        for(Supplier_Staging__c supplier : stagData.values()){
            Account acc;
            Contact con;
            Opportunity opp = new Opportunity();
            totalOpp ++; 
            
            //assume that account1 always equals account2, account3
            if(supplier.Account_ID__c  != NULL){
                //Get the account from the Map
                acc = accountsMap.get(supplier.Account_ID__c );
            }
            else{//account id is null, create new account
                acc = new Account(OwnerId=UserInfo.getUserId());
                totalAcc ++;
            }
            
            //assume that countact1 always equals contact2
            if(supplier.Contact_ID__c  != NULL){
                //Get the account from the Map
                con = contactsMap.get(supplier.Contact_ID__c);
            }
            else{//account id is null, create new contact
                con = new Contact(OwnerId=UserInfo.getUserId());
                totalCon ++;
            }
            
            //Here we have acc and con
            
            //Here we assign/update fields on acc and con. From Supplier -> on acc and con
            List<Supplier_Staging_Convert__mdt> mappingTable = [SELECT Id, FromFieldName__c, 	FromObjectName__c, 	ToFieldName__c, ToObjectName__c
                                                                FROM Supplier_Staging_Convert__mdt
                                                               ];
            
            Map<String, sObject> mapObjects = convertStageRecordToOtherRecords(acc, con, opp, mappingTable, supplier);    
            acc = (Account)mapObjects.get('account');
            system.debug('acc = ' + acc);
            if(acc.OwnerId == null){
                acc.OwnerId = getDefaultOpportunityOwner();
                acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(); 
                acc.Status__c = 'Prospect';
            }
            if(acc.Type == null){
                acc.Type = 'Contractor';
            }
            //if(acc.CampaignId == null){
            //acc.CampaignId = 'Contractor';
            //}
            
            
            //put acc in supplierIdToAccountMap 
            supplierIdToAccountMap.put(supplier.Id, acc);
            
            con = (Contact)mapObjects.get('contact');
            if (con != null){
                if(con.OwnerId == null){
                    con.OwnerId = getDefaultOpportunityOwner();
                }
                if(con.LastName == null){
                    con.LastName = 'Unknown';
                }
                con.Account = acc;
                //put con in supplierIdToContactMap 
                supplierIdToContactMap.put(supplier.Id, con);
            }
            
            opp = (Opportunity)mapObjects.get('Opportunity');  
            if (opp != null){
                if(opp.OwnerId == null){
                    opp.OwnerId = getDefaultOpportunityOwner();
                }
                opp.Account = acc;
                opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(); 
                opp.Client_Account__c = c.Client_Account__c;
                opp.CloseDate = Date.today() +30;
                opp.CampaignId = campaignId;
                opp.StageName = 'Mailed';
                if (con != null){
                    opportunityToContact.add(
                        new OppToContactWrapper(
                            opp, con
                        ) 
                    );
                }
                //put opp in supplierIdToContMap 
                supplierIdToOpportunityMap.put(supplier.Id, opp);
            }
            
        }
        SavePoint sp = Database.setSavepoint();
        try{
            upsert supplierIdToAccountMap.values();
            
            for (Contact con: supplierIdToContactMap.values()){
                if (con.Account != Null){
                    con.AccountId = con.Account.Id;
                }
            }   
            upsert supplierIdToContactMap.values();
            
            for (Opportunity opp: supplierIdToOpportunityMap.values()){
                if (opp.Account != Null){
                    opp.AccountId = opp.Account.Id;
                }
            }
            upsert supplierIdToOpportunityMap.values();
            
            }
        catch(Exception e)
        {
            throw e;
        }
            
            List<OpportunityContactRole> oppContactRoles = new List<OpportunityContactRole>();
            for(OppToContactWrapper wrapper: opportunityToContact){
                oppContactRoles.add(
                    New OpportunityContactRole(
                        isPrimary = true,
                        OpportunityId = wrapper.opp.Id,
                        ContactId = wrapper.con.Id,
                        Role = 'Client Provided Contact'   
                        
                    ) 
                );
            }
            insert oppContactRoles;
           
        try{
            List<Supplier_Staging__c> suppliersToBeUpdated = new List<Supplier_Staging__c>();
            
            //Link that account/Contact with the supplier so that we can maintain the relation
            for(Id supplierId: supplierIdToAccountMap.keySet()){            
                //Get the supplier
                Supplier_Staging__c supplier = stagData.get(supplierId);
                
                //Get the Account
                Account acc = supplierIdToAccountMap.get(supplierId);
                
                //Set the supplier Account
                if(supplier.Account_ID__c == null){
                    supplier.Account_ID__c = acc.Id;
                    //supplier.Match_2_AccountId__c = acc.Id;
                    //Do this for all account fields, set all acc fields
                    
                    suppliersToBeUpdated.add(supplier);
                }
            } 
            
            //update suppliersToBeUpdated;
            
            //Update Supplier Staging Results with the amount of records that were created.
            Staging_Results__c res = new Staging_Results__c();   
            res.Number_of_Accounts_Converted__c = totalAcc;
            res.Number_of_Contacts_Converted__c = totalCon;
            res.Number_of_Opportunities_Converted__c = totalOpp;
            res.Conversion_Executed_by__c = UserInfo.getUserId();
            res.Campaign__c = campaignId; 
            
            insert res; 
            
        } catch (exception e){
            Database.rollback(sp);    
        } 
        
        
        
        //Do top for loop for contacts
    }*/

 public static Map<String, sObject> convertStageRecordToOtherRecords(Account acc, Contact con, Opportunity opp, List<Supplier_Staging_Convert__mdt> mappingTable, Supplier_Staging__c record) 
    {
        Map<String, sObject> objectsToReturn = new Map <String, sObject>();
        
        for(Supplier_Staging_Convert__mdt mapRecord : mappingTable)
        {
            string fromTableValue = (string) record.get(mapRecord.FromFieldName__c);
            if(mapRecord.ToObjectName__c == 'Account')
            {
                acc.put(mapRecord.ToFieldName__c, fromTableValue);
            }
            else if(con != null && mapRecord.ToObjectName__c == 'Contact')
            {
                con.put(mapRecord.ToFieldName__c, fromTableValue);
            }
            else if(opp != null && mapRecord.ToObjectName__c == 'Opportunity')
            {
                opp.put(mapRecord.ToFieldName__c, fromTableValue);
            }
        }
        objectsToReturn.put('account', acc);
        objectsToReturn.put('contact', con);
        objectsToReturn.put('Opportunity', opp);
        return objectsToReturn;
    }   
    
    /*public class OppToContactWrapper
    {
        public Opportunity opp {get;set;}
        public Contact con {get;set;}
        
        public OppToContactWrapper(Opportunity opp, Contact con){
            this.opp = opp; 
            this.con = con;
        } 
        
    } */
}