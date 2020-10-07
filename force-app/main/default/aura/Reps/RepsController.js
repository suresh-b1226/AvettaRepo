({
	onDragStart : function(component, event, helper) {
         event.dataTransfer.dropEffect = "move";
         var rep = component.get('v.rep');
         var repName = rep.Rep_Name__c;
         console.log("Rep Name:: " + repName);
         event.dataTransfer.setData('text', JSON.stringify(repName));
     },
})