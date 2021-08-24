({
	handleOpenBuyoutDetail : function(component, event, helper) {
        
        helper.doOpenBuyoutDetail(component,event,helper);
        
        /*
        
        var record = component.get("v.recordId");
        var locale = $A.get("$Locale.language");
        
         var  P_items;
        
        var P_action = component.get("c.IsProductionOrg");
        P_action.setCallback(this, function(P_response) {
            P_items = P_response.getReturnValue();
            
            console.log('p_items   '+P_response.getReturnValue());
            var urlEvent = $A.get("e.force:navigateToURL");
            if(P_items == 'PROD'){
                                  urlEvent.setParams({
                                  "url": 'http://hcwebservice.hcac1.com:10080/contracts/buyout/history/'+record
                         });
                       	urlEvent.fire();
                 $A.get("e.force:closeQuickAction").fire();
                             
                             
                         }
             else{
                                                console.log('p_items    '+P_items);
                                                if( P_items =='CS125'){
                                                    console.log('p_items 111   '+P_items);
                                                     urlEvent.setParams({
                                  "url": 'http://hcwebservicedev.hcac1.com:10080/contracts/buyout/history/'+record
                         });
                       	urlEvent.fire();
                                                     $A.get("e.force:closeQuickAction").fire();
                                                    
                                                }
                                                else{
                                                    console.log('p_items 222   '+P_items);
                                                      urlEvent.setParams({
                                            "url": 'http://hcwebservicedev.hcac1.com:10090/contracts/buyout/history/'+record
                         });
                       	urlEvent.fire();
                                                     $A.get("e.force:closeQuickAction").fire();
                                                  
                                                }
                                            }
            
            
        }),
             $A.enqueueAction(P_action);
        */
        /*
          if(P_items == 'PROD'){
        var url = 'http://hcwebservice.hcac1.com:10080/contracts/buyout/history/';
        
        console.log('record Id '+ record);
        
        var urlEvent = $A.get("e.force:navigateToURL");
                 urlEvent.setParams({
                    
                 "url":url +record
                     
                });
           console.log('url '+ url+record);
                     
               urlEvent.fire();
             */  
      //  $A.get("e.force:closeQuickAction").fire();
       
    }
})