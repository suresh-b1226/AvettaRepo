public with sharing class ccp_cloneKnowledgeArticleController {
    
    @AuraEnabled
    public static String getArticleInfo(String recordId){
        Map<String,Object> mapOfObjects = new Map<String,Object>();
        try {
            if(System.String.isEmpty(recordId))
            {
                mapOfObjects.put('isCompatible',false);
                mapOfObjects.put('errorMsg', 'No recordId found.');
            }
            else
            {
                Boolean isCompatible = checkCompatibility(recordId);
                mapOfObjects.put('isCompatible',isCompatible);
                if(isCompatible)
                {
                    DescribeSObjectResult dsr = describeSobjectByRecordIdPrefix(recordId);
                    if(!dsr.isAccessible())
                    {
                        mapOfObjects.put('errorMsg', 'User does not have permission to query object.');
                        return System.JSON.serialize(mapOfObjects);
                    }
                    
                    SObject article = getArticleByRecordId(recordId);
                    if(article != null)
                    {
                        mapOfObjects.put('article',article);
                    }
                    
                }
            }
            
            
        } catch(Exception e){
            mapOfObjects.put('errorMsg', e.getMessage());
        }
        
        return System.JSON.serialize( mapOfObjects );
    }
    
    private static Boolean checkCompatibility(String recordId){
        try {
            
            if(System.String.isEmpty(recordId))
            {
                return false;
            }
            
            DescribeSObjectResult dsr = describeSobjectByRecordIdPrefix(recordId);
            
            if(dsr == null)
            {
                return false;
            }
            
            String objectName = dsr.getName();
            
            if(System.String.isEmpty(objectName))
            {
                return false;
            }
            else if(objectName.endsWithIgnoreCase('__kav'))
            {
                return true;
            }
            else
            {
                return false;
            }
            
            
        } catch(Exception e) {
            return false;
        }
    }
    
    @AuraEnabled
    public static String cloneArticle(String recordId, String Title, String UrlName){
        Map<String,Object> mapOfObjects = new Map<String,Object>();
        try {
            if(System.String.isEmpty(recordId))
            {
                mapOfObjects.put('errorMsg', 'No recordId found.');
                return System.JSON.serialize( mapOfObjects );
            }
            
            DescribeSObjectResult dsr = describeSobjectByRecordIdPrefix(recordId);
            
            if(dsr == null)
            {
                mapOfObjects.put('errorMsg', 'Invalid recordId.');
                return System.JSON.serialize(mapOfObjects);
            }
            else if(!dsr.isAccessible())
            {
                mapOfObjects.put('errorMsg', 'User does not have permission to query object.');
                return System.JSON.serialize(mapOfObjects);
            }
            else if(!dsr.isCreateable())
            {
                mapOfObjects.put('errorMsg', 'User does not have permission to create object.');
                return System.JSON.serialize(mapOfObjects);
            }
            
            String objectName = dsr.getName();
            
            if(System.String.isEmpty(objectName))
            {
                mapOfObjects.put('errorMsg', 'Object Name not found.');
                return System.JSON.serialize( mapOfObjects );
            }
            else if(objectName.endsWithIgnoreCase('__kav'))
            {
                
            }
            else
            {
                mapOfObjects.put('errorMsg', 'Record is not an Article type.');
                return System.JSON.serialize( mapOfObjects );
            }
            
            SObject article = getArticleByRecordId(recordId);
            
            if(article == null)
            {
                mapOfObjects.put('errorMsg', 'Record query did not return a result.');
                return System.JSON.serialize( mapOfObjects );
            }
            
            article = article.clone(false, false, false, false);
            article.put('Title', Title);
            article.put('UrlName', UrlName);
            insert article;
            mapOfObjects.put('newRecordId',article.Id);
            
        } catch(Exception e) {
            mapOfObjects.put('errorMsg', e.getMessage());
        }
        return System.JSON.serialize( mapOfObjects );
    }
    
    private static SObject getArticleByRecordId(String recordId){
        SObject article;
        DescribeSObjectResult dsr = describeSobjectByRecordIdPrefix(recordId);
        
        String objectName = (dsr != null ) ? dsr.getName() : '';
        Set<String> fieldNameSet = getSObjectFieldNames(objectName);
        
        String articleFields = System.String.join(new List<String>(fieldNameSet),',');
        
        String query = 'SELECT ' + articleFields + ' FROM ' + objectName;
        query += ' WHERE Id = \'' + recordId + '\'';
        
        List<SObject> articleList = System.Database.query(query);
        
        if(articleList == null || articleList.size() == 0)
        {
            return null;
        }
        else
        {
            return articleList[0];
        }
    }
    
    private static describeSObjectResult describeSobjectByRecordIdPrefix(String recordIdOrPrefix){
        DescribeSObjectResult dsr;
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
            
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
            
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                //System.debug('Prefix is ' + prefix);
                
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    dsr = r;
                    //System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return dsr;
    }
    
    private static Set<String> getSObjectFieldNames(String objectName){
        SObjectType sobjectType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = sobjectType.getDescribe().fields.getMap();
        Set<String> fieldNameSet = new Set<String>();
        
        for(Schema.SObjectField field : mfields.values())
        {
            fieldNameSet.add(field.getDescribe().getName());
        }
        
        return fieldNameSet;
    }
    
}