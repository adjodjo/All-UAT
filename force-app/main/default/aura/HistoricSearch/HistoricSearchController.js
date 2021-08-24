({
	searchBuyout : function(component, event, helper) {
		
        helper.doSearchBuyout(component,event,helper);
	},
    
    resetsearch : function(component, event, helper) {
		
        //$A.get('e.force:refreshView').fire();
        
        component.set("v.historycontact", null);
        component.set("v.historyaccount", null);
        component.set("v.historyamount", null);
        component.set("v.historyvariance", null);
        component.set("v.historystartdate", null);
        component.set("v.historyenddate", null);
        component.set("v.historyBuyoutNum", null);
         component.set("v.historycontract", null);
        
        
        component.set("v.HistoriesBuyout.lenght",  1);
        component.set("v.HistoriesBuyout",  null);
        component.set("v.historyinvoice",  false);
        
        
       
	},
    
    SetSearchLang : function(component, event, helper) {
        
        var locale = $A.get("$Locale.language");
        
        component.set("v.isLang",locale);
        
        console.log('ceci est init '+locale);
        
    }
})