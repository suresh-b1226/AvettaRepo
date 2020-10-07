({
	init : function(component, event, helper) {
		helper.callGetArticleInfo(component,event,helper);
	},
    handleCloneClick : function(component, event, helper) {
        var articleInfo = component.get('v.articleInfo');
        var newTitle = component.get('v.newTitle');
        var newUrlName = component.get('v.newUrlName');
        
        if($A.util.isEmpty(newTitle) || $A.util.isEmpty(newUrlName))
        {
            helper.showToast(component,'error','ERROR','Title and UrlName are both required.', 'dismiss');
        }
        else if(newTitle === articleInfo.article.Title)
        {
            helper.showToast(component,'error','ERROR','Title must not match source article Title.', 'dismiss');
        }
        else if(newUrlName === articleInfo.article.UrlName)
        {
            helper.showToast(component,'error','ERROR','UrlName must not match source article UrlName.', 'dismiss');
        }
        else
        {
            component.set("v.showSpinner",true);
        	helper.callCloneArticle(component,event,helper);
        }
        
    },
    
    handleTitleOnBlur : function(component,event,helper) {
        var newTitle = component.get('v.newTitle');
        var newUrlName = component.get('v.newUrlName');
        if($A.util.isEmpty(newUrlName))
        {
        	newUrlName = newTitle.replace(/\s+/g, '-');
            newUrlName = newUrlName.replace(/[^\w-]+/g, '');
            component.set('v.newUrlName',newUrlName);
        }
        
    }
})