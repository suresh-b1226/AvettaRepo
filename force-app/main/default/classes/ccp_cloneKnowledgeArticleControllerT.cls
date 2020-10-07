@isTest
public class ccp_cloneKnowledgeArticleControllerT {

    
    public static testMethod void test_success_getArticleInfo()
    {
        Schema.SObjectType sobjectType = getArticleSObjectType();
        System.assertNotEquals(null, sobjectType);
        SObject article = sobjectType.newSObject();
        article.put('Title','testTitle');
        article.put('UrlName','testTitle');
        article.put('Article_Approval_Queue__c','Training');
        insert article;
        
        Map<String,Object> mapOfObjectsArticleInfo = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_cloneKnowledgeArticleController.getArticleInfo(article.Id)
            );
        Boolean isCompatible = (Boolean) mapOfObjectsArticleInfo.get('isCompatible');
        System.assertEquals(true,isCompatible);
    }
    
    public static testMethod void test_success_cloneArticle()
    {
        Schema.SObjectType sobjectType = getArticleSObjectType();
        System.assertNotEquals(null, sobjectType);
        SObject article = sobjectType.newSObject();
        article.put('Title','testTitle');
        article.put('UrlName','testTitle');
        article.put('Article_Approval_Queue__c','Training');
        insert article;
        
        Map<String,Object> mapOfObjectsCloneArticle = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_cloneKnowledgeArticleController.cloneArticle(article.Id,'testTitle2','testTitle2')
            );
        String newRecordId = (String) mapOfObjectsCloneArticle.get('newRecordId');
        //System.assertNotEquals(null, newRecordId);
    }
    
    public static testMethod void test_fail_getArticleInfo()
    {
        Map<String,Object> mapOfObjectsArticleInfo = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_cloneKnowledgeArticleController.getArticleInfo(System.UserInfo.getUserId())
            );
        Boolean isCompatible = (Boolean) mapOfObjectsArticleInfo.get('isCompatible');
        System.assertEquals(false,isCompatible);
    }
    
    public static testMethod void test_fail_getArticleInfo2()
    {
        Map<String,Object> mapOfObjectsArticleInfo = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_cloneKnowledgeArticleController.getArticleInfo('bogusrecordid')
            );
        Boolean isCompatible = (Boolean) mapOfObjectsArticleInfo.get('isCompatible');
        System.assertEquals(false,isCompatible);
    }
    
    public static testMethod void test_fail_getArticleInfo3()
    {
        Map<String,Object> mapOfObjectsArticleInfo = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_cloneKnowledgeArticleController.getArticleInfo(null)
            );
        Boolean isCompatible = (Boolean) mapOfObjectsArticleInfo.get('isCompatible');
        System.assertEquals(false,isCompatible);
    }
    
    public static testMethod void test_fail_cloneArticle()
    {
        Map<String,Object> mapOfObjectsCloneArticle = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_cloneKnowledgeArticleController.cloneArticle(System.UserInfo.getUserId(), null, null)
            );
        System.debug('mapOfObjectsCloneArticle: ' + mapOfObjectsCloneArticle);
        String errorMsg = (String) mapOfObjectsCloneArticle.get('errorMsg');
        System.assertNotEquals(null, errorMsg);
    }
    
    public static testMethod void test_fail_cloneArticle2()
    {
        Map<String,Object> mapOfObjectsCloneArticle = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_cloneKnowledgeArticleController.cloneArticle('bogusrecordid', null, null)
            );
        System.debug('mapOfObjectsCloneArticle: ' + mapOfObjectsCloneArticle);
        String errorMsg = (String) mapOfObjectsCloneArticle.get('errorMsg');
        System.assertNotEquals(null, errorMsg);
    }
    
    public static testMethod void test_fail_cloneArticle3()
    {
        Map<String,Object> mapOfObjectsCloneArticle = (Map<String,Object>) System.JSON.deserializeUntyped(
            ccp_cloneKnowledgeArticleController.cloneArticle(null, null, null)
            );
        System.debug('mapOfObjectsCloneArticle: ' + mapOfObjectsCloneArticle);
        String errorMsg = (String) mapOfObjectsCloneArticle.get('errorMsg');
        System.assertNotEquals(null, errorMsg);
    }
    
    private static Schema.SObjectType getArticleSObjectType()
    {
        Schema.SObjectType result;
        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
            
        //Loop through all the sObject types returned by Schema
        for(Schema.SObjectType stype : gd.values()){
            Schema.DescribeSObjectResult r = stype.getDescribe();
            String sobjectName = r.getName();
            if(sobjectName.endsWithIgnoreCase('__kav'))
            {
                result = stype;
                return result;
            }
            
        }
        
        return result;
        
    }
    
}