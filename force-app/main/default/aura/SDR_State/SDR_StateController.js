({
    onDragStart : function(component, event, helper) {
         event.dataTransfer.dropEffect = "move";
         var state = component.get('v.state');
         var stateName = state.Name;
         console.log("State Name:: " + stateName);
         event.dataTransfer.setData('text', JSON.stringify(stateName));
     },

})