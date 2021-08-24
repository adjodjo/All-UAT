({
	doOpenBuyout : function(component, event, helper) {
		 
        var  P_items;
         var msg;
         var locale = $A.get("$Locale.language");
        
        var P_action = component.get("c.BuildLink");
        P_action.setCallback(this, function(P_response) {
            P_items = JSON.parse(P_response.getReturnValue());
            
               console.log('p_items   '+P_response.getReturnValue());
            
             var urlEvent = $A.get("e.force:navigateToURL");
        
          if(P_items.sfdcOrg == 'PROD'){
                                  urlEvent.setParams({
                                  "url": P_items.eipLink+'index.html'
                         });
                       	urlEvent.fire();
                             
                             
                         }
                                            else{
                                                console.log('p_items    '+P_items);
                                                if( P_items.sfdcOrg =='CS66'){
                                                    console.log('p_items 111   '+P_items);
                                                     urlEvent.setParams({
                                  "url": P_items.eipLink+'index.html'
                         });
                       	urlEvent.fire();
                                                    
                                                }
                                                else {
                                                    //if(P_items.sfdcOrg =='CS69'){
                                                    console.log('p_items 222   '+P_items);
                                                      urlEvent.setParams({
                                            "url": P_items.eipLink+'index.html'
                                                         
                         });
                       	urlEvent.fire();
                                                  
                                                }
                                                  /*   else {
                                        
                                        if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                        // msg = 'Nouvelle copie de buyout envoyée...';
                                        console.log('message 2 '+msg);
                                        component.set("v.isOpen", true);
                                        component.set("v.message", msg );
                                    }*/
                                                
                                            }
        }),
             
            $A.enqueueAction(P_action);
	},
    
    
    
    doOpenCreateLetter: function(component, event, helper) {
           
        var  P_items;
        
        console.log('testtt   '+P_items);
        var P_action = component.get("c.BuildLink");
        P_action.setCallback(this, function(P_response) {
           P_items = JSON.parse(P_response.getReturnValue());
            
               console.log('P_items   '+P_response.getReturnValue());
            
            
             var urlEvent = $A.get("e.force:navigateToURL");
        
          if(P_items.sfdcOrg == 'PROD'){
                                  urlEvent.setParams({
                                  "url": P_items.eipLink+'letters/'
                         });
                       	urlEvent.fire();
                             
                             
                         }
                                            else{
                                                console.log('p_items    '+P_items);
                                                if( P_items.sfdcOrg =='CS66'){
                                                    console.log('p_items 111   '+P_items);
                                                     urlEvent.setParams({
                                  "url": P_items.eipLink+'letters/'
                         });
                       	urlEvent.fire();
                                                    
                                                }
                                                else {
                                                   // if( P_items.sfdcOrg =='CS69'){
                                                    console.log('p_items 222   '+P_items);
                                                      urlEvent.setParams({
                                            "url": P_items.eipLink+'letters/'
                         });
                       	urlEvent.fire();
                                                  
                                                }
                                            /*    else {
                                        
                                        if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                        // msg = 'Nouvelle copie de buyout envoyée...';
                                        console.log('message 2 '+msg);
                                        component.set("v.isOpen", true);
                                        component.set("v.message", msg );
                                    }*/
                                            }
            
        }),
        
             $A.enqueueAction(P_action);
        
    },
    
    doOpenContractLetter: function(component, event, helper) {
       
        var  P_items;
        console.log('testtt 2  '+P_items);
        var P_action = component.get("c.BuildLink");
        P_action.setCallback(this, function(P_response) {
            P_items = JSON.parse(P_response.getReturnValue());
            
               console.log('p_items   '+P_response.getReturnValue());
                        
             var urlEvent = $A.get("e.force:navigateToURL");
        
          if(P_items.sfdcOrg == 'PROD'){
                                  urlEvent.setParams({
                                  "url": P_items.eipLink+'contracts/'
                         });
                       	urlEvent.fire();
                             
                             
                         }
                                            else{
                                                console.log('p_items    '+P_items);
                                                if( P_items.sfdcOrg =='CS66'){
                                                    console.log('p_items 111   '+P_items);
                                                     urlEvent.setParams({
                                  "url": P_items.eipLink+'contracts/'
                         });
                       	urlEvent.fire();
                                                    
                                                }
                                                else {
                                                  //  if(P_items.sfdcOrg =='CS69'){
                                                    console.log('p_items 222   '+P_items);
                                                      urlEvent.setParams({
                                            "url": P_items.eipLink+'contracts/'
                         });
                       	urlEvent.fire();
                                                  
                                                }
                                            /*    else {
                                        
                                        if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                        // msg = 'Nouvelle copie de buyout envoyée...';
                                        console.log('message 2 '+msg);
                                        component.set("v.isOpen", true);
                                        component.set("v.message", msg );
                                    }*/
                                                
                                            }
            
        }),
        
             $A.enqueueAction(P_action);
     
    },
    
    doOpenopenBatchLetter: function(component, event, helper) {
        
        var  P_items;
        console.log('testtt  3 '+P_items);
        var P_action = component.get("c.BuildLink");
        P_action.setCallback(this, function(P_response) {
            P_items = JSON.parse(P_response.getReturnValue());
            
               console.log('p_items   '+P_response.getReturnValue());
            
            
             var urlEvent = $A.get("e.force:navigateToURL");
        
          if(P_items.sfdcOrg == 'PROD'){
                                  urlEvent.setParams({
                                  "url": P_items.eipLink+'letters/'
                         });
                       	urlEvent.fire();
                             
                             
                         }
                                            else{
                                                console.log('p_items    '+P_items);
                                                if( P_items.sfdcOrg =='CS66'){
                                                    console.log('p_items 111   '+P_items);
                                                     urlEvent.setParams({
                                  "url": P_items.eipLink+'letters/'
                         });
                       	urlEvent.fire();
                                                    
                                                }
                                                else {
                                                  //  if( P_items.sfdcOrg =='CS69'){
                                                    console.log('p_items 222   '+P_items);
                                                      urlEvent.setParams({
                                            "url": P_items.eipLink+'letters/'
                         });
                       	urlEvent.fire();
                                                  
                                                }
                                             /*   else {
                                        
                                        if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                        // msg = 'Nouvelle copie de buyout envoyée...';
                                        console.log('message 2 '+msg);
                                        component.set("v.isOpen", true);
                                        component.set("v.message", msg );
                                    }*/
                                            }
        }),
        
             $A.enqueueAction(P_action);
        
    },
    
    
})