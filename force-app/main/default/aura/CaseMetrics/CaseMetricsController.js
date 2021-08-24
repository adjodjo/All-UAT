({
	doInit : function(component, event, helper) {
         var locale = $A.get("$Locale.language");
        component.set("v.isLang",locale);
        console.log( component.get("v.isLang"))
          console.log("locale", locale)
       // component.set("v.recordId",component.get("v.recordId"));
        
        helper.getCaseData(component, event, helper);
        helper.getCaseAssignedTime(component, event, helper);
        helper.getCasePendingTime(component, event, helper);
	}, 
    
      
})