({
	createRegion : function(component, event, helper) {
    	var createRegionEvent = $A.get("e.force:createRecord");
		createRegionEvent.setParams({
        	"entityApiName": "Region__c"
    	});
    	createRegionEvent.fire();
	},
    createState : function(component, event, helper) {
    	var createRepEvent = $A.get("e.force:createRecord");
		createRepEvent.setParams({
        	"entityApiName": "State__c"
    	});
    	createRepEvent.fire();
	}
})