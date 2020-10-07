({
    //method is called by dragging a rep/state on a different region column
    allowDrop: function(component, event, helper) {
        event.preventDefault();
    },
    //method is called by dropping a rep/state on a different region column
	onDrop: function(component, event, helper) {
        event.preventDefault();
        var regionChangeEvent = component.getEvent('regionChange');
        regionChangeEvent.setParams({
            'region': component.get('v.region'),
            'state': JSON.parse(event.dataTransfer.getData('text')),
        });
        regionChangeEvent.fire();
    },
    //method is called by clicking the 'delete icon' next to each Region
    removeRegion: function(component, event, helper){
        var region = component.get("v.region");
        var states = component.get("v.states");
        var reps = component.get("v.reps");
        var hasState = false;
        var hasRep = false;
        var regionReps;
        
        for(var iCount = 0; iCount < states.length; iCount++){
            if(region.Id == states[iCount].Region__c){
                hasState = true;
                break;
            }
        }
        for(var i = 0; i < reps.length; i++){
            if(region.Id == reps[i].Region__c){
                hasRep = true;
                break;
            }
        }
        if(hasState == true && hasRep == true){
            alert("Reassign the state(s) -and- rep(s) to a different region before deleting the " + region.Name + " region.");
            return false;
        }
        else if(hasState == true && hasRep == false){
            alert("Reassign the -state(s)- to a different region before deleting the " + region.Name + " region.");
            return false;
        }
        else if (hasState == false && hasRep == true){
            alert("Reassign the -rep(s)- to a different region before deleting the " + region.Name + " region.");
           	return false;
        }
        else if(confirm("Are you sure you want to delete the " + region.Name + " region?") == true){
            var action = component.get("c.deleteRegion");
            action.setParams({region : region})
            action.setCallback(this,function(response){
            var state = response.getState();
              $A.log(response);
            if(state == "SUCCESS"){
                component.set("v.regions",response.getReturnValue());
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    	}
        else{
            return false;
        }
    },
    //Method gets called by 'edit icon' link next to each Region
    editRegion : function(component,event,helper){
       var region = component.get('v.region');
     	//navigate to Region detail page     
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": region.Id,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
})