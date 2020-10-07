({
    createRep : function(component, event, helper) {
        var createRepEvent = $A.get("e.force:createRecord");
        createRepEvent.setParams({
            "entityApiName": "Rep__c"
        });
        createRepEvent.fire();
    }
})