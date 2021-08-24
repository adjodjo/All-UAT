({
    /*
    	getCaseData : function(component,event,helper) {
              var record = component.get("v.recordId");
            console.log('recordId-----------'+record);
            
		var action = component.get("c.getCaseRecord");
          
        action.setParams({
            "recordId" : record
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                if(responseData != null){
                 component.set("v.caseRec",responseData);
                
                console.log('------succes-----------'+responseData);
                }
                 console.log('------echec-----------');
            }
            else{
                console.log('Echec creation task');
            }
         }),
            $A.enqueueAction(action);
    },
    
    
    doHandleOpenEIPApp : function(component, event, helper) {
        
        var caseRecord = component.get("v.caseRec");
        var record = component.get("v.recordId");
        var origine = component.get("v.case.Origin");
        console.log('	Origin '+origine+' record'+record);
        var locale = $A.get("$Locale.language");
        var msg;
        var getLabel = event.getSource().get('v.label');
        var  P_items;
        
        
        var P_action = component.get("c.BuildLink");
        P_action.setCallback(this, function(P_response) {
            P_items = JSON.parse(P_response.getReturnValue());
        }),
            $A.enqueueAction(P_action);
        
        var action = component.get("c.VerifierCaseStatus");
        action.setParams({
            "caseRecord" : caseRecord
           // "caseId":record
        });
        console.log('ceci est le test premier');
        action.setCallback(this, function(response) {
            
            console.log('ceci est le test dexieme');
            var state = response.getState();
           // console.log('resulteat '+state+ ' tems'+responseObj  );
            if (state === "SUCCESS") {
                var  responseObj = JSON.parse(response.getReturnValue());
                
                 console.log('Origin '+responseObj.origin);
                 console.log( 'errMsg '+responseObj.errMsg);
                 console.log( 'etat '+responseObj.etat);
                console.log( 'contract '+responseObj.contract);
                    
                if( responseObj.errMsg !== null){
                    
                     var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": responseObj.errMsg
                        });
                        successtoastEvent.fire();
                     var redirect = $A.get("e.force:navigateToSObject");
                redirect.setParams({
                    "recordId": record
                });
                 redirect.fire(); 
              //   this.closeSubTab();   
                    
                    // component.set("v.isClosed", true);
                    // component.set("v.message", responseObj.errMsg );
                   
                }
                else{
                 console.log('msg est null ');
                if (responseObj.etat === 'Queue'){
                    console.log('success '+responseObj);
                    if(locale == 'en'  )   msg ='Assign you the Case before any action...'; 
                    if(locale == 'fr')  msg ='Assignez vous la requête avant toute action...';
                    
                     var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                   
                 
                }
                else if (responseObj.etat === 'Closed'){
                        console.log('success '+items);
                        if(locale == 'en'  )   msg ='This is close Case...'; 
                        if(locale == 'fr')  msg ='Requête fermée...';
                      
                     var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                   
                    }
                    else if(responseObj.etat === 'Pending'){
                        console.log('etat est null ' );
                                    
                        if(responseObj.origin === 'Email'){   //.../contracts/{contractId}/buyout?accountId={accountId}&caseId={caseId}"
                            console.log('origin est '+ responseObj.origin + ' pour les test' );
                            var urlEvent = $A.get("e.force:navigateToURL");
                            if(P_items.sfdcOrg == 'PROD'){
                                
                                this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                               
                            }
                            else{
                                if( P_items.sfdcOrg =='CS125'){
                                    console.log('ici est uat ' );
                                    
                                    this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                                  
                                }
                                else if( P_items.sfdcOrg =='CS69'){
                                    
                                    
                                    console.log('ceci est test p_items 222   '+P_items.sfdcOrg);
                                    console.log('les paramètres   '+responseObj.account);
                                    
                                    this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                                    
                                    
                                }
                                    else {
                                        
                                        if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                   
                                         var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                                      
                                    }
                            }
                            
                        }
                        else {
                            if(responseObj.origin === 'EIP'){
                            
                            if(record != null){
                                console.log('message 1  '+record);
                                var urlEvent = $A.get("e.force:navigateToURL");
                                if(P_items.sfdcOrg == 'PROD'){
                                    urlEvent.setParams({
                                        "url": P_items.eipLink+'contracts/buyout/case/'+record
                                    });
                                    urlEvent.fire();
                                    helper.redirectToRecord(component,event,helper);
                                }
                                else{
                                    if( P_items.sfdcOrg =='CS125'){
                                        
                                        
                                        urlEvent.setParams({
                                            "url": P_items.eipLink+'contracts/buyout/case/'+record
                                        });
                                        urlEvent.fire();
                                        helper.redirectToRecord(component,event,helper);
                                    }
                                    else if( P_items.sfdcOrg =='CS69'){
                                        console.log('p_items 222   '+P_items);
                                        urlEvent.setParams({
                                            "url": P_items.eipLink+'contracts/buyout/case/'+record
                                        });
                                        urlEvent.fire();
                                        helper.redirectToRecord(component,event,helper);                        
                                    }
                                        else {
                                            
                                            if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                            if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                         
                                             var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                                        }
                                }
                            }
                            else{
                                var urlEvent = $A.get("e.force:navigateToURL");
                                if(P_items.sfdcOrg == 'PROD'){
                                    urlEvent.setParams({
                                        "url": P_items.eipLink+'buyout/'
                                    });
                                    urlEvent.fire();
                                    helper.redirectToRecord(component,event,helper); 
                                }
                                else{
                                    if(  P_items.sfdcOrg =='CS125'){
                                        urlEvent.setParams({
                                            "url": P_items.eipLink+'buyout/'
                                        });
                                        urlEvent.fire();
                                        helper.redirectToRecord(component,event,helper);
                                    }
                                    else if( P_items.sfdcOrg =='CS69'){
                                        console.log('p_items 222   '+P_items);
                                        urlEvent.setParams({
                                            "url": P_items.eipLink+'buyout/'
                                        });
                                        urlEvent.fire();
                                        
                                    }
                                        else {
                                            
                                            if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                            if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                         
                                             var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                                                                                   }
                                }
                            }
                        }
                            else if(responseObj.origin === 'Phone'){
                                                                
                                console.log('Origine est    '+responseObj.origin);
                                
                                 var urlEvent = $A.get("e.force:navigateToURL");
                            if(P_items.sfdcOrg == 'PROD'){
                                
                                this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                               
                            }
                            else{
                                if( P_items.sfdcOrg =='CS125'){
                                    console.log('ici est uat ' );
                                    
                                    this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                                  
                                }
                                else if( P_items.sfdcOrg =='CS69'){
                                    
                                    
                                    console.log('ceci est test p_items 222   '+P_items.sfdcOrg);
                                    console.log('les paramètres   '+responseObj.account);
                                    
                                    this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                                                                        
                                }
                                    else {
                                        
                                        if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                   
                                         var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                                      
                                    }
                            }
                                
                            }
                            else{
                                
                                 if(locale == 'en'  )   msg ='Missing case information record. Please contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Information manquante dans le Case. Contactez l\'Administrateur Système...';
                              
                                 var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                                      
                            }
                    }
                    }
                        else {
                            
                            if(locale == 'en'  )   msg ='Case Status is not Pending...'; 
                        if(locale == 'fr')  msg ='Le Statut du n\'est pas en Tratement...';
                      
                             var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                           
                        }
                }
            
            
            }
            else{
                if(locale == 'en'  )   msg ='Can not open Buyout Application. Contact System Administrator...'; 
                if(locale == 'fr')  msg ='Imposible d\'ouvrir l\'application Buyout. Contactez l\'Administrateur Système...';
              
                 var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                
               
            }
        }),
            console.log('ceci la fin');
        $A.enqueueAction(action);
       // $A.get('e.force:refreshView').fire();
    },
    
    
    redirectToRecord : function(record){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": record,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    
    buildURL: function(record,contract,account, P_items){
        console.log('record  '+record);
        console.log('contract  '+contract);
        console.log('account  '+account);
        console.log('link  '+P_items.eipLink);        
        console.log('p_items 222   '+P_items);
        console.log( 'contract '+contract);
        
        var urlEvent = $A.get("e.force:navigateToURL");
        
        if(contract !== null && account !== null){
            console.log( 'account 11 '+account);
            urlEvent.setParams({
                
                "url": P_items.eipLink+'/case/'+record+'?sfAccountId='+account+'&contractId='+contract,
                    "target": "_self"
                //'contracts/'+responseObj.contract+'/buyout?accountId='+responseObj.account+'&caseId='+record
            });
            urlEvent.fire();
            this.redirectToRecord(record);
        }
        else 
            if(contract == null && account !== null){
                var s = P_items.eipLink+'/case/'+record+'?sfAccountId='+account;
                
              //  window.open(s,'_top');
                
                urlEvent.setParams({
                    
                    "url": P_items.eipLink+'/case/'+record+'?sfAccountId='+account,
                    "target": "_self"
                    //'contracts/'+responseObj.contract+'/buyout?accountId='+responseObj.account+'&caseId='+record
                });
                urlEvent.fire();  
                this.redirectToRecord(record);
                
                
            }
            else if(contract !== null && account == null){
                 urlEvent.setParams({
                    
                    "url": P_items.eipLink+'/case/'+record+'?contractId='+contract,
                    "target": "_self"
                    //'contracts/'+responseObj.contract+'/buyout?accountId='+responseObj.account+'&caseId='+record
                });
                urlEvent.fire();
                this.redirectToRecord(record);
            }
            else{
                console.log( 'account 22'+account);
                urlEvent.setParams({
                    
                    "url": P_items.eipLink+'/case/'+record
                });
               // this.closeFocusedTab()
                urlEvent.fire();
                this.redirectToRecord(record);
                
            }
        //}
    },
   /* 
    closeSubTab : function(component, event, helper){
        console.log('This is an error 1 --- >');
   		sforce.console.getEnclosingTabId(
        $A.getCallback(function(result) {
        sforce.console.closeSubTab(result.id);
        console.log('This is an error --- >'+result.id);
      })
   );
        
        console.log('This is an error 2 --- >');
}
    */
   /* 
  
    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeSubTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    }
    */

    
})