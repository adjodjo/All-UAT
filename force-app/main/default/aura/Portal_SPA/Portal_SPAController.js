({

    //Open URL in New Browser Tab
    openActionWindow : function(component, event, helper) {
        
         helper.doOpenBuyout(component,event,helper);
    
    },
    
    
    openCreateLetter : function(component, event, helper) {
        
         helper.doOpenCreateLetter(component,event,helper);
 
    },
    
        openContractLetter : function(component, event, helper) {
            
            helper.doOpenContractLetter(component,event,helper);
        
    },
    
     openBatchLetter : function(component, event, helper) {
         
         helper.doOpenopenBatchLetter(component,event,helper);
         
    },
    
    SetPortalEIPApp : function(component, event, helper) {
        
        var locale = $A.get("$Locale.language");
        
        component.set("v.isLang",locale);
        
    },    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        // Close the action panel
        $A.get('e.force:closeQuickAction').fire();
        // Refresh the record detail page
    $A.get('e.force:refreshView').fire();
    }
    
    
})