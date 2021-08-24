({
    buyoutSend : function(component, event, helper) {        
        
        helper.doSendBuyout(component,event,helper);

    },

    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isNotSend", false);
        // Close the action panel
        $A.get('e.force:closeQuickAction').fire();
        // Refresh the record detail page
    $A.get('e.force:refreshView').fire();
    }
})