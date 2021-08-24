({
    doInit : function(component,event,helper){
        
       var locale = $A.get("$Locale.language");
        component.set("v.isLang",locale);
        
      helper.getCaseData(component, event, helper);
      helper.getResolution(component, event, helper);
    },
    
	callAssignComponent : function(component, event, helper) {
	
        helper.doAssignToMe(component,event,helper); 
	},
    
    callEIPModule : function(component, event, helper) {
      
         helper.doCallEIPModule(component,event,helper);
	},
    
    
    openPopupClosed : function(component,event,helper){
      component.set("v.isPopupShowClosed",true);
        component.set("v.statusCase","Closed");
        
        $A.get("e.force:closeQuickAction").fire();
    },
   
    openPopup : function(component,event,helper){
      component.set("v.isPopupShow",true); 
        component.set("v.statusCase","Resolved");
    },
   
    
    openPopupHold : function(component,event,helper){
        
         console.log(' -- statusCase 1  --');
        component.set("v.statusCase","On Hold");
            helper.saveCaseData(component,event,helper); 
         console.log(' -- statusCase 1  --'+ component.get("v.statusCase"));
    },
    
    closeModel : function(component,event,helper){
        component.set("v.isPopupShow",false);
        component.set("v.isPopupShowClosed",false);
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "related"
        });
        navEvt.fire();
        $A.get('e.force:refreshView').fire();
       
    },
    submitDetails : function(component,event,helper){
      console.log(' -- statusCase 1  --'+ component.get("v.statusCase"));
      helper.saveCaseData(component,event,helper);  
        $A.get("e.force:closeQuickAction").fire();
    },
    
    
    openRelatedCase : function(component,event,helper){
       helper.getCaseData(component, event, helper);
         helper.openRelatedCase(component, event, helper);        
      //  $A.get("e.force:closeQuickAction").fire();
    },
    
    
})