({
    doInit : function(component,event,helper) {
        var actionNORAMRegions = component.get("c.getNORAMRegions");
        actionNORAMRegions.setCallback(this,function(response){
            var state = response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                component.set("v.NORAMregions",response.getReturnValue());
            }
        });
        $A.enqueueAction(actionNORAMRegions);

        var actionEMEARegions = component.get("c.getEMEARegions");
        actionEMEARegions.setCallback(this,function(response){
            var state = response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                component.set("v.EMEAregions",response.getReturnValue());
            }
        });
        $A.enqueueAction(actionEMEARegions);

        var actionAPACRegions = component.get("c.getAPACRegions");
        actionAPACRegions.setCallback(this,function(response){
            var state = response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                component.set("v.APACregions",response.getReturnValue());
            }
        });
        $A.enqueueAction(actionAPACRegions);

        var actionLATAMRegions = component.get("c.getLATAMRegions");
        actionLATAMRegions.setCallback(this,function(response){
            var state = response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                component.set("v.LATAMregions",response.getReturnValue());
            }
        });
        $A.enqueueAction(actionLATAMRegions);

        var actionStates = component.get("c.getStates");
        actionStates.setCallback(this,function(response){
            var state = response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                component.set("v.states",response.getReturnValue());
            }
        });
        $A.enqueueAction(actionStates);



        var actionReps = component.get("c.getNORAMReps");
        actionReps.setCallback(this,function(response){
            var state = response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                var rows = response.getReturnValue();
                //flatten the data so the SDR_Region_Name__c is visible in the datatable
                for(var i=0; i < rows.length; i++){
                    var row = rows[i];
                    if (row.Region__c != null){
                        row.Region_Name__c = row.Region__r.Name;
                    }
                }
                component.set('v.reps', rows);
            }
        });
        $A.enqueueAction(actionReps);

        var actionEMEAReps = component.get("c.getEMEAReps");
        actionEMEAReps.setCallback(this,function(response){
            var state = response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                var rows = response.getReturnValue();
                //flatten the data so the SDR_Region_Name__c is visible in the datatable
                for(var i=0; i < rows.length; i++){
                    var row = rows[i];
                    if (row.Region__c != null){
                        row.Region_Name__c = row.Region__r.Name;
                    }
                }
                component.set('v.EMEA_Reps', rows);
            }
        });
        $A.enqueueAction(actionEMEAReps);

        var action_APAC_Reps = component.get("c.getAPACReps");
        action_APAC_Reps.setCallback(this,function(response){
            var state = response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                var rows = response.getReturnValue();
                //flatten the data so the SDR_Region_Name__c is visible in the datatable
                for(var i=0; i < rows.length; i++){
                    var row = rows[i];
                    if (row.Region__c != null){
                        row.Region_Name__c = row.Region__r.Name;
                    }
                }
                component.set('v.APAC_Reps', rows);
            }
        });
        $A.enqueueAction(action_APAC_Reps);

        var action_LATAM_Reps = component.get("c.getLATAMReps");
        action_LATAM_Reps.setCallback(this,function(response){
            var state = response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                var rows = response.getReturnValue();
                //flatten the data so the SDR_Region_Name__c is visible in the datatable
                for(var i=0; i < rows.length; i++){
                    var row = rows[i];
                    if (row.Region__c != null){
                        row.Region_Name__c = row.Region__r.Name;
                    }
                }
                component.set('v.LATAM_Reps', rows);
            }
        });
        $A.enqueueAction(action_LATAM_Reps);


    },
    onRegionChanged: function(component, event, helper) {
        var singleRegion = event.getParam("region");
        var singleState = event.getParam("state");
        var allStates = component.get("v.states");
        var allReps = component.get("v.reps");
        var actualState = allStates.find(function(el) {
            return el.Name == singleState;
        });
        var actualRep = allReps.find(function(el){
            return el.Name == singleState;
        })
        if (actualState) {
            actualState.Region__c = singleRegion.Id;
            var tempSaveAction = component.get("c.saveState");
            tempSaveAction.setParams({state : actualState});

            $A.enqueueAction(tempSaveAction);
            component.set("v.states", allStates);
        }
        else if(actualRep){
            actualRep.Region__c = singleRegion.Id;
            var tempSaveAction = component.get("c.saveRep");
            tempSaveAction.setParams({rep : actualRep});

            $A.enqueueAction(tempSaveAction);
            component.set("v.reps", allReps);
        }
        else {
            console.log("Could not find state ", singleState, " in list ", allStates);
        }
    },
    handleSetActiveSectionA: function (cmp) {
        cmp.find("accordion").set('v.activeSectionName', 'A');
    },
    handleSetActiveSectionB: function (cmp) {
        cmp.find("accordion").set('v.activeSectionName', 'B');
    },
    handleSetActiveSectionC: function (cmp) {
        cmp.find("accordion").set('v.activeSectionName', 'C');
    },
    handleSetActiveSectionD: function (cmp) {
        cmp.find("accordion").set('v.activeSectionName', 'D');
    }
});

/*
({
	doInit : function(component,event,helper) {
       var actionRegions = component.get("c.getRegions");
        actionRegions.setCallback(this,function(response){
            var state = response.getState();
              $A.log(response);
            if(state == "SUCCESS"){
                component.set("v.regions",response.getReturnValue());
            }
        });
        $A.enqueueAction(actionRegions);
        
        var actionStates = component.get("c.getStates");
        actionStates.setCallback(this,function(response){
            var state = response.getState();
              $A.log(response);
            if(state == "SUCCESS"){
                component.set("v.states",response.getReturnValue());
            }
        });
        $A.enqueueAction(actionStates); 
        
        var actionReps = component.get("c.getReps");
        actionReps.setCallback(this,function(response){
            var state = response.getState();
              $A.log(response);
            if(state == "SUCCESS"){
                var rows = response.getReturnValue();
                //flatten the data so the SDR_Region_Name__c is visible in the datatable
                for(var i=0; i < rows.length; i++){
                    var row = rows[i];
                    if (row.Region__c != null){
						row.Region_Name__c = row.Region__r.Name;
                    }
                }
                component.set('v.reps', rows);
            }
        });
        $A.enqueueAction(actionReps);
    
        
    },
    onRegionChanged: function(component, event, helper) {
        var singleRegion = event.getParam("region");
        var singleState = event.getParam("state");
        var allStates = component.get("v.states");
        var allReps = component.get("v.reps");
        var actualState = allStates.find(function(el) {
          return el.Name == singleState;
        });
        var actualRep = allReps.find(function(el){
            return el.Name == singleState;
        })
        if (actualState) {
          actualState.Region__c = singleRegion.Id;
          var tempSaveAction = component.get("c.saveState");
          tempSaveAction.setParams({state : actualState});
          
          $A.enqueueAction(tempSaveAction);
		  component.set("v.states", allStates);
        }
        else if(actualRep){
            actualRep.Region__c = singleRegion.Id;
            var tempSaveAction = component.get("c.saveRep");
            tempSaveAction.setParams({rep : actualRep});
            
            $A.enqueueAction(tempSaveAction);
            component.set("v.reps", allReps);
		}
        else {
          console.log("Could not find state ", singleState, " in list ", allStates);
        }
  },
   
})*/