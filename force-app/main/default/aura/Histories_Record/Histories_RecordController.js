({
	init : function(component, event, helper) {
        
        var locale = $A.get("$Locale.language");
         console.log('la lang est   '+locale);
        component.set("v.isLang",locale);
		
	}
})