public class QB_SupplierConvertService{
    public static integer totalAcc = 0; 
    public static integer totalOpp = 0; 
    public static integer totalCon = 0; 
    
    public static SIT_Settings__c sitSettings ;
    
    public static String getDefaultOpportunityOwner (){ 
        if(sitSettings == Null){
              sitSettings = SIT_Settings__c.getInstance('General SIT');    
          } 
        
        return sitSettings.Default_Opportunity_Owner__C;
    }

    public static String setOpportunityStageName (){ 
        if(sitSettings == Null) {
              sitSettings = SIT_Settings__c.getInstance('General SIT');    
          } 
        
        return sitSettings.Opportunity_Stage__c;
    }
    
    class SupplierLoadException extends Exception{}
    
/*
* * Method that converts the suppliers
* */
    
public static void convertSuppliers(List<Supplier_Staging__c> stageDateList, Id campaignId){
        
        System.debug('in convertSuppliers called from Batch');
        
        List<Campaign> campList = new List<Campaign>();
        campList = [SELECT  id, Client_Account__c from Campaign where id = :campaignId] ;
        
        Map<Id, Supplier_Staging__c> stagData = new Map<Id, Supplier_Staging__c>(stageDateList) ; 
        
        Set<Id> accountIds = new Set<id>();
        Set<Id> contactsIds = new Set<id>();
        Set<Id> opportunityIds = new Set<id>();
        Set<Id> vendorIds = new Set<id>();
    
        Set<String> ExistingOptys = new Set<String>();
    
        for(Supplier_Staging__c supplier : stagData.values()){
            if(supplier.Account_ID__c != NULL)
            {
                accountIds.add(supplier.Account_ID__c);
            }

            //for all 5 account fields and all 3 contact fields
            if(supplier.Contact_ID__c != NULL)
            {
                contactsIds.add(supplier.Contact_ID__c);
            }

           
        }
        
        //Query all Accounts - All fields to query
        Map<Id, Account> accountsMap = new Map<Id, Account>([Select id, OwnerId, Name, Status__c from Account where Id IN :accountIds]);
        
        //Query all Contacts - All fields to query
        Map<Id, Contact> contactsMap = new Map<Id, Contact>([Select id, Name from Contact where Id IN :contactsIds]);
        
        //Query for existing Opty associated to Accounts
        //add by Torren Phillips June 2017
        //Added 5/2/2019 - Vendor_ID__C to the optys Query
        List<Opportunity> optys = [select AccountId,id, Client_Account__c,StageName from Opportunity 
                                  where AccountId IN :accountIds and Client_Account__c  = :campList[0].Client_Account__c And  StageName <> 'Closed Lost' And Type = 'Registration' AND RecordTypeId ='01270000000cebq'];        
        System.debug('Optys Found is ' + optys.size());
        //Load the List so we can compareit
        List<Opportunity> existingopty = new List<Opportunity>();
        //
        System.debug('Campaign id is :' + campaignId);
        For(Opportunity Loopit : optys){
            if(Loopit.AccountId!=Null && Loopit.Id!=Null && campaignId != NULL){
                IF(Loopit.StageName <> 'Closed Won'){
            existingopty.add(new Opportunity (Id = Loopit.Id, CampaignId = campaignId));
            }
            //Change the Campaign
            ExistingOptys.add(Loopit.AccountId);
            }
        }
        update existingopty;
        System.debug('Existing Optys updated is ' + existingopty.size());
    
        Map<Id, Account> supplierIdToAccountMap = new Map<Id, Account>();
        Map<Id, Contact> supplierIdToContactMap = new Map<Id, Contact>();
        Map<Id, Opportunity> supplierIdToOpportunityMap = new Map<Id, Opportunity>();
        List<OppToContactWrapper> opportunityToContact = new  List<OppToContactWrapper>();

        //Here we assign/update fields on acc and con From Supplier -> on acc and con
        List<Supplier_Staging_Convert__mdt> mappingTable = [SELECT Id, FromFieldName__c,    FromObjectName__c,  ToFieldName__c, ToObjectName__c FROM Supplier_Staging_Convert__mdt];
        
        // Update Supplier Staging Results with the amount of records that were created and BatchURL.
        Staging_Results__c res = new Staging_Results__c();   
        System.debug('staging results' + res);
            res.Number_of_Accounts_Converted__c = 0;
            res.Number_of_Contacts_Converted__c = 0;
            res.Number_of_Opportunities_Converted__c = 0;
            res.Conversion_Executed_by__c = UserInfo.getUserId();
            res.Campaign__c = campaignId; 
            
            insert res; 
            
    
        System.debug('***staging results***' + res);
        
        for(Supplier_Staging__c supplier : stagData.values()){
            Id recordOwnerId;
            Account acc;
            Contact con;
            Opportunity opp;
            String venId;

            //determine the owner id of all the new records. Either coming from stagerecord or custom setting
            if (supplier.Owner_ID__c != NULL)
                recordOwnerId = supplier.Owner_ID__c;
            else
                recordOwnerId = getDefaultOpportunityOwner();

            //Added by Torren Phillips June 2017
            //Copied the logic from below
            if(ExistingOptys.contains(supplier.Account_ID__c)&&supplier.Account_ID__c != NULL){
                //Decided to the Opty Changes for existing Optys somewhere else - See line 86
            }
            else{
                opp = new Opportunity(OwnerId=recordOwnerId);
            }                

            System.debug('-----right after ' + opp);
            totalOpp ++; 
       
            //assume that account1 always equals account2, account3
            if(supplier.Account_ID__c != NULL  && accountsMap.containsKey(supplier.Account_ID__c)){
                //Get the account from the Map
                acc = accountsMap.get(supplier.Account_ID__c);             
            }
            else{//account id is null, create new account
                acc = new Account(OwnerId=recordOwnerId, Status__c = 'Prospect');
                acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();                
                acc.Type = 'Contractor';
                totalAcc ++;
            }
            
            
            //assume that countact1 always equals contact2
            if(supplier.Contact_ID__c != NULL && contactsMap.containsKey(supplier.Contact_ID__c)){
                //Get the account from the Map
                con = contactsMap.get(supplier.Contact_ID__c);
            }
            else{//account id is null, create new contact
                con = new Contact(OwnerId=recordOwnerId);
                totalCon ++;
            }
            
            
            Map<String, sObject> mapObjects = convertStageRecordToOtherRecords(acc, con, opp, mappingTable, supplier);    
            System.debug('-----right afeter the mapping call' + opp);            
            acc = (Account)mapObjects.get('account');
            system.debug('acc = ' + acc);
            
            //put acc in supplierIdToAccountMap 
            supplierIdToAccountMap.put(supplier.Id, acc);
            
            con = (Contact)mapObjects.get('contact');
            if (con != null){
                
                if(con.LastName == null){
                    con.LastName = 'Unknown';
                }
                con.Account = acc;
                con.Account_Type__c = 'Contractor';
                
                //put con in supplierIdToContactMap 
                supplierIdToContactMap.put(supplier.Id, con);
            }
            opp = (Opportunity)mapObjects.get('Opportunity'); 
            System.debug('-----right after the map.objects.get opportunity' + opp);    
            if (opp != null){
                opp.Account = acc;
                
                System.debug('Supplier Vendor ID_C ');
                //Added by Emmon - 5/2/2019
                opp.Vendor_ID__c = supplier.Vendor_ID__c;
                opp.Site__c = supplier.Site__c;
                //Create new upgrade opp if the account already exist

                if(acc.id !=null && acc.Status__c == 'Active'){
                    opp.Type = 'Upgrade';
                    System.debug (accountsMap + '*****convertOpps123*****');
                    System.debug (opp.OwnerId + '*****convertOpportunity*****');
                    opp.StageName = setOpportunityStageName();
                    
                    //Commented out by Dallin Wasden 5.3.19 as per sfdc case #00939724
                    //opp.Result__c = 'Not Contacted';
                    opp.Free_Connection__c = supplier.Free_Connection__c;
                }
                else
                {
                if (acc.Status__c == 'Pending' || acc.Status__c == 'Requested'  
                || acc.Status__c == 'Prospect' || acc.Status__c == 'Declined') 
                    opp.Type = 'Registration';
                else if (acc.Status__c == 'Deactivated')
                    opp.Type = 'Reactivation';
                else 
                    opp.Type = Null;
                    
                opp.StageName = 'Mailed';
                opp.Free_Connection__c = supplier.Free_Connection__c;
                }
                
                System.debug('-----right afeter setting opp.type' + opp);
                opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(); 
                 if (!campList.isEmpty() ){
                     opp.Client_Account__c = campList[0].Client_Account__c;
                 }
                opp.CloseDate = Date.today() +30;
                opp.CampaignId = campaignId;
                System.debug('Opp info ' + opp.SystemModstamp + '<' + system.now());
                //former if *opp.SystemModstamp  < system.now()*
                if (true){
                    opportunityToContact.add(
                        new OppToContactWrapper(
                            opp, con));              
                }
                //put opp in supplierIdToContMap 
                supplierIdToOpportunityMap.put(supplier.Id, opp);   
            }
            System.debug('Account Count: ' + supplierIdToAccountMap.Size());
            System.debug('Contacts Count: ' + supplierIdToContactMap.Size());
            System.debug('Opty Count: ' + supplierIdToOpportunityMap.Size());
            System.debug('Opty Mapped to Contacts Count: ' + opportunityToContact.Size());
        }
        SavePoint sp = Database.setSavepoint();
        try{
            List<Account> accounts = new List<Account>(); 
            
            for(Account acc: supplierIdToAccountMap.values())
            {
                if (acc.id == Null){
                    accounts.add(acc);
                }
                
            }
            insert accounts;
            
            //upsert supplierIdToAccountMap.values();
            List<Contact> contacts = new List<Contact>();

            for (Contact con: supplierIdToContactMap.values()){
                                if (con.id == Null){
            //
                    if (con.Account != Null){
                    con.AccountId = con.Account.Id;
                }
                    contacts.add(con);
                }
            }   
            // To avoid depulicate  contact in list
            insert contacts;
             //upsert new List<Contact>(setofContacttoUpsert); 
            //upsert supplierIdToContactMap.values();
           
            
            for (Opportunity opp: supplierIdToOpportunityMap.values()){
                if (opp.Account != Null){
                    opp.AccountId = opp.Account.Id;
                }
            }
            insert supplierIdToOpportunityMap.values();
            
        } 
        catch(Exception e)
        {
            throw e;
        }
        
        //This is where the Contact Role is Created
        List<OpportunityContactRole> oppContactRoles = new List<OpportunityContactRole>();
        for(OppToContactWrapper wrapper: opportunityToContact){
            oppContactRoles.add(
                New OpportunityContactRole(
                    isPrimary = true,
                    OpportunityId = wrapper.opp.Id,
                    ContactId = wrapper.con.Id,
                    Role = 'Client Provided Contact'));
        }
        insert oppContactRoles;
        System.debug('Opty and Contacts Count: ' + oppContactRoles.Size()); 
        try{
            List<Supplier_Staging__c> suppliersToBeUpdated = new List<Supplier_Staging__c>();
            
            //Link that account/Contact with the supplier so that we can maintain the relation
            for(Id supplierId: supplierIdToAccountMap.keySet()){            

                //Get the supplier
                Supplier_Staging__c supplier = stagData.get(supplierId);                
                supplier.Converted__c = true;                

                Account acc = supplierIdToAccountMap.get(supplierId);
                //Set the supplier Account
                if(supplier.Account_ID__c == null){
                    supplier.Account_ID__c = acc.Id;                   
                }
                
                //Get the Contact
                Contact con = supplierIdToContactMap.get(supplierId);                
                if(supplier.Contact_ID__c == null){
                    supplier.Contact_ID__c = con.Id;
                }
                
                suppliersToBeUpdated.add(supplier);                
            }

            update suppliersToBeUpdated;
            
            // Update Supplier Staging Results with the amount of records that were created and BatchURL.
             
            res.Number_of_Accounts_Converted__c = totalAcc;
            res.Number_of_Contacts_Converted__c = totalCon;
            res.Number_of_Opportunities_Converted__c = totalOpp;
           
            
            update res; 
            
        } catch (exception e){
            Database.rollback(sp);    
        }
         
        //Do top for loop for contacts
}
public static Map<String, sObject> convertStageRecordToOtherRecords(Account acc, Contact con, Opportunity opp, List<Supplier_Staging_Convert__mdt> mappingTable, Supplier_Staging__c record) {
        Map<String, sObject> objectsToReturn = new Map <String, sObject>();
        
        for(Supplier_Staging_Convert__mdt mapRecord : mappingTable){
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
    
public class OppToContactWrapper{
        public Opportunity opp {get;set;}
        public Contact con {get;set;}
        public OppToContactWrapper(Opportunity opp, Contact con){
            this.opp = opp; 
            this.con = con;
        }  
    }
}