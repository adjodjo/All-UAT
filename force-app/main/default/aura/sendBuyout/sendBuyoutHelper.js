({
    doSendBuyout : function(component,event,helper) {
        
        var locale = $A.get("$Locale.language");
        console.log('melang   '+locale);
        var msg;
        var action = component.get("c.BuyoutEmail");
        action.setParams({
            "RecordId": component.get("v.recordId")
        });

        var items;

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            
                items = response.getReturnValue();
               // console.log('item  '+items);
                var parsed = JSON.stringify(items);
                var parsed2 = JSON.parse(items);
console.log('ID  '+parsed2.Id);
                
                 console.log('etat '+parsed2.Id);
                if (parsed2.Id == 'Queue'){
                     console.log('success '+items);
                     if(locale == 'en'  )   msg ='Assign you the Case before any action...'; 
                    if(locale == 'fr')  msg ='Assignez vous la requête avant toute action...';
               // msg = 'Nouvelle copie de buyout envoyée...';
                    console.log('message 2 '+msg);
                    component.set("v.isNotSend", true);
                    component.set("v.message", msg );
                    
                }
                
                else{ 
                     if (parsed2.Id == 'Closed'){
                                     console.log('success '+items);
                                     if(locale == 'en'  )   msg ='This is close Case...'; 
                                    if(locale == 'fr')  msg ='Requête fermée...';
                               // msg = 'Nouvelle copie de buyout envoyée...';
                                    console.log('message 2 '+msg);
                                    component.set("v.isClosed", true);
                                    component.set("v.message", msg );
                    
                }
                    
                    
                    else{
                
                
                if(parsed2.Id == null){

                    if(locale == 'en'  )   msg ='Send missing... ' + parsed2.API_Error_Msg ; //+parsed2.API_Error_Msg; Check sending parameters or Contact System Administrator.
                    if(locale == 'fr')  msg ='Echec d\'envoi... '+ parsed2.API_Error_Msg ; ///+parsed2.API_Error_Msg; Vérifiez les paramètres d\'envoi ou contactez l\'Administrateur Système. test

                   //'Echec d\'envoi...'+parsed2.API_Error_Msg;
                    console.log('message 1  '+msg);
                    component.set("v.isNotSend", true);
                    component.set("v.message", msg );
                    this.doupdateHistoric(component)
              
                }
                else{
                    if(locale == 'en'  )   msg ='New send buyout email...'; 
                    if(locale == 'fr')  msg ='Nouvelle copie de buyout envoyée...';
               // msg = 'Nouvelle copie de buyout envoyée...';
                    console.log('message 2 '+msg);
                    component.set("v.isNotSend", true);
                    component.set("v.message", msg );
                this.doupdateHistoric(component)
                
                }
                          }
            }
        }
            
            
            
            else {

                if(locale == 'en'  )    msg ='Send missing... Check sending parameters or Contact System Administrator.' ; // +parsed2.API_Error_Msg; 
                if(locale == 'fr')  msg ='Echec d\'envoi... Vérifiez les paramètres d\'envoi ou contactez l\'Administrateur Système. test 1' ; // +parsed2.API_Error_Msg;
                //msg = 'Echec d\'envoi...';
                console.log('message 3 '+msg);
                component.set("v.isNotSend", true);
                component.set("v.message", msg);
                this.doupdateHistoric(component)
            }
        });
        // Invoke the service
        $A.enqueueAction(action);

        
    },
    
    doupdateHistoric : function(component) {
        
        var action = component.get("c.updateBuyout");
        action.setParams({
            "RecordId": component.get("v.recordId"),
            "msg": component.get("v.message")
        });
        var items;

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('envoie...'+msg)
            }
        
    });
        // Invoke the service
        $A.enqueueAction(action);
    }

})