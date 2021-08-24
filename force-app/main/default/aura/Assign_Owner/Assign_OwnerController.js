({
    assignToMe : function(component, event, helper) {        
        
        helper.doAssignToMe(component,event,helper);

    },
    
     closeModel: function(component, event, helper) {
         
         var record = component.get("v.recordId");
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isClosed", false);
        // Close the action panel
        $A.get('e.force:closeQuickAction').fire();
       // Get the Lightning event that opens a record in a new tab
        var redirect = $A.get("e.force:navigateToSObject");
         
         console.log('redirect to .' +record);
        
        // Pass the record ID to the event
        redirect.setParams({
            "recordId": record
        });
        
        // Open the record
        redirect.fire();
         
    }

})