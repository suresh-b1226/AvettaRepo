({
    callGetArticleInfo : function(component,event,helper) {
        var action = component.get("c.getArticleInfo");
        
        action.setParams({
            recordId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS")
            {
                
                var response = JSON.parse(response.getReturnValue());
                
                if(!$A.util.isEmpty(response.errorMsg))
                {
                    helper.showToast(component,'error','ERROR',response.errorMsg, 'dismiss');
                }
                else if(!$A.util.isEmpty(response))
                {
                    component.set("v.articleInfo",response);
                    if(!$A.util.isEmpty(response.article))
                    {
                        if(!$A.util.isEmpty(response.article.UrlName))
                        {
                            component.set("v.newUrlName",response.article.UrlName);
                        }
                        if(!$A.util.isEmpty(response.article.Title))
                        {
                            component.set("v.newTitle",response.article.Title);
                        }
                    }
                    
                    component.set("v.isCompatible",response.isCompatible);
                }
                
            }
            else
            {
                component.set("v.isCompatible",false);
            }
            
            component.set("v.readyToDisplay",true);
        });
        
        $A.enqueueAction(action);
    },
    
    callCloneArticle : function(component,event,helper) {
        var action = component.get("c.cloneArticle");
        var newTitle = component.get('v.newTitle');
        var newUrlName = component.get('v.newUrlName');
        
        action.setParams({
            recordId : component.get("v.recordId"),
            Title : newTitle,
            UrlName : newUrlName
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === "SUCCESS")
            {
                
                var response = JSON.parse(response.getReturnValue());
                
                if(!$A.util.isEmpty(response.errorMsg))
                {
                    helper.showToast(component,'error','ERROR',response.errorMsg, 'dismiss');
                }
                else if(!$A.util.isEmpty(response) && !$A.util.isEmpty(response.newRecordId))
                {
                    helper.navigateToNewRecord(component,event,helper,response.newRecordId);
                }
                
            }
            else
            {
                helper.showToast(component,'error','ERROR','Error completing action! Please check debug logs.');
            }
            
            component.set("v.readyToDisplay",true);
            component.set("v.showSpinner",false);
        });
        
        $A.enqueueAction(action);
    },
    
    navigateToNewRecord : function (component, event, helper, recordId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
        });
        navEvt.fire();
    },
    
    navigateToNewRecordEdit : function(component, event, helper, recordId){
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": recordId
        });
        editRecordEvent.fire();  
    },
    
    showToast : function(component,type,title,message, mode){
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type,
            "mode" : mode,
            "duration" : 8000
            
        });
        toastEvent.fire();        
    }
    
})