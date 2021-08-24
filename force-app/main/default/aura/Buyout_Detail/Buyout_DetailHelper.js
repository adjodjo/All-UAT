({
	doOpenBuyoutDetail : function(component, event, helper) {
        
         var record = component.get("v.recordId");
        var locale = $A.get("$Locale.language");
        
         var  P_items;
        
        var P_action = component.get("c.BuildLink");
        P_action.setCallback(this, function(P_response) {
            P_items = JSON.parse(P_response.getReturnValue());
            
            console.log('p_items   '+P_response.getReturnValue());
            var urlEvent = $A.get("e.force:navigateToURL");
            if(P_items.sfdcOrg == 'PROD'){
                                  urlEvent.setParams({
                                  "url": P_items.eipLink+'contracts/buyout/history/'+record
                         });
                       	urlEvent.fire();
                 $A.get("e.force:closeQuickAction").fire();
                             
                             
                         }
             else{
                                                console.log('p_items    '+P_items);
                                                if( P_items.sfdcOrg =='CS125'){
                                                    console.log('p_items 111   '+P_items);
                                                     urlEvent.setParams({
                                  "url": P_items.eipLink+'contracts/buyout/history/'+record
                         });
                       	urlEvent.fire();
                                                     $A.get("e.force:closeQuickAction").fire();
                                                    
                                                }
                 else {
                                                //    if( P_items.sfdcOrg =='CS69'){
                                                    console.log('p_items 222   '+P_items);
                                                      urlEvent.setParams({
                                            "url": P_items.eipLink+'contracts/buyout/history/'+record
                         });
                       	urlEvent.fire();
                                      $A.get("e.force:closeQuickAction").fire();             
                                                }
                                          /*      else {
                                        
                                        if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                        // msg = 'Nouvelle copie de buyout envoyée...';
                                        console.log('message 2 '+msg);
                                        component.set("v.isClosed", true);
                                        component.set("v.message", msg );
                                    }*/

                                            }
            
            
        }),
             $A.enqueueAction(P_action);
		
	}
})