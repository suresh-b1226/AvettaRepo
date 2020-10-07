({
     //method is called on load of page/component
	init : function(component, event, helper) {
        var actions = [{ label: 'Show details', name: 'show_details' }];

		component.set('v.columns', [
            { type: 'action', typeAttributes: {rowActions: actions}},
            {label: 'Name', fieldName: 'Rep_Name__c', type: 'text', sortable: true},
            {label: 'Region', fieldName: 'Region_Name__c', type: 'text', sortable: true},
            {label: 'Out Of Office', fieldName: 'Out_Of_Office__c', type: 'boolean', editable: true},
            {label: 'Lead Distribution Weight', fieldName: 'Distribution_Weight__c', type: 'number', editable: true, cellAttributes: { alignment: 'left' },sortable: true}
        ]);

        var action = component.get("c.getNORAMReps");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.reps",response.getReturnValue());
                helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);

        var EMEA_Action = component.get("c.getEMEAReps");
        EMEA_Action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.reps",response.getReturnValue());
                helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(EMEA_Action);

        var APAC_Action = component.get("c.getAPACReps");
        APAC_Action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.reps",response.getReturnValue());
                helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(APAC_Action);

        var LATAM_Action = component.get("c.getLATAMReps");
        LATAM_Action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.reps",response.getReturnValue());
                helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(LATAM_Action);
	},
    
    //Method is called when the table is edited and the user clicks 'Save'
    SaveRepDetail : function(component, event, helper){
    	var drafts = event.getParam("draftValues");
        console.log("drafts:: ", drafts[0]);
        var tempSaveAction = component.get("c.saveRepDetails");
        tempSaveAction.setParams({"reps": drafts});
        tempSaveAction.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } 
                else {
                    console.log(response.getReturnValue());
                }
            }
        });  
        $A.enqueueAction(tempSaveAction);
    },
     //Method gets called by onsort action
    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortedBy",sortBy);
        component.set("v.sortedDirection",sortDirection);
        //call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    },
    //Method gets called by 'Show Details' link on Rep in Detail table
    handleRowAction : function(component,event,helper){
       var action = event.getParam('action');
       var row = event.getParam('row');
     	//navigate to Rep detail page     
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": row.Id,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },

})