/**
 * Created by JasonMcGrew on 4/22/2020.
 var flow = component.find("flow");
 flow.startFlow("Salesforce_Support_Requests");
 */

({
    doInit : function(component, event, helper) {
        component.set('v.isOpen', false);
    },
    clickButton : function(component) {
        component.set('v.isOpen', true);
        var flow = component.find('flow');
        flow.startFlow('Salesforce_Support_Requests');
    },
    closeFlowModal : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    closeModalOnFinish : function(component, event, helper) {
        if(event.getParam('status') === "FINISHED") {
            component.set("v.isOpen", false);
        }
    }
})