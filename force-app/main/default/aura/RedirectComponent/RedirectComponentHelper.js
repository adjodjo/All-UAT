({
    
       // CALL EIP MODULE FUNCTION 
    // ////    GO TO EIP BUTTON
    
    doCallEIPModule : function(component, event, helper) {
        
        var caseRecord = component.get("v.caseRec");
        var record = component.get("v.recordId");
        var origine = component.get("v.case.Origin");
        console.log('	Origin '+origine+' record'+record);
        var locale = $A.get("$Locale.language");
        var msg;
        var getLabel = event.getSource().get('v.label');
        var  P_items;
        
        
        var P_action = component.get("c.doBuildLink");
        P_action.setCallback(this, function(P_response) {
            P_items = JSON.parse(P_response.getReturnValue());
        }),
            $A.enqueueAction(P_action);
        
        var action = component.get("c.doVerifierCaseStatus");
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
                            console.log('origin est '+ responseObj.origin + ' pour les test'+ '-- Organisation---'+P_items.sfdcOrg);
                            var urlEvent = $A.get("e.force:navigateToURL");
                            if(P_items.sfdcOrg == 'PROD'){
                                
                                this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                               
                            }
                            else{
                                if( P_items.sfdcOrg =='CS66'){
                                    console.log('ici est uat ' );
                                    
                                    this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                                  
                                }
                                else {
                                  //  if( P_items.sfdcOrg =='CS69'){
                                    
                                    
                                    console.log('ceci est test p_items 222   '+P_items.sfdcOrg);
                                    console.log('les paramètres   '+responseObj.account);
                                    
                                    this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                                  
                               // }
                                   /* else {
                                        
                                        if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                   
                                         var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                                      */
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
                                    if( P_items.sfdcOrg =='CS66'){
                                        
                                        
                                        urlEvent.setParams({
                                            "url": P_items.eipLink+'contracts/buyout/case/'+record
                                        });
                                        urlEvent.fire();
                                        helper.redirectToRecord(component,event,helper);
                                    }
                                    else {
                                      //  if( P_items.sfdcOrg =='CS69'){
                                        console.log('p_items 222   '+P_items);
                                        urlEvent.setParams({
                                            "url": P_items.eipLink+'contracts/buyout/case/'+record
                                        });
                                        urlEvent.fire();
                                        helper.redirectToRecord(component,event,helper);                        
                                  //  }
                                     /*   else {
                                            
                                            if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                            if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                         
                                             var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                                            */
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
                                    if(  P_items.sfdcOrg =='CS66'){
                                        urlEvent.setParams({
                                            "url": P_items.eipLink+'buyout/'
                                        });
                                        urlEvent.fire();
                                        helper.redirectToRecord(component,event,helper);
                                    }
                                    else {
                                      //  if( P_items.sfdcOrg =='CS69'){
                                        console.log('p_items 222   '+P_items);
                                        urlEvent.setParams({
                                            "url": P_items.eipLink+'buyout/'
                                        });
                                        urlEvent.fire();
                                        
                                  //  }
                                      /*  else {
                                            
                                            if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                            if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                         
                                             var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                                                                      */            } 
                                }
                            }
                        }
                           if(responseObj.origin === 'Phone'){
                                                                
                                console.log('Origine est    '+responseObj.origin);
                                
                                 var urlEvent = $A.get("e.force:navigateToURL");
                            if(P_items.sfdcOrg == 'PROD'){
                                
                                this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                               
                            }
                            else{
                                if( P_items.sfdcOrg =='CS66'){
                                    console.log('ici est uat ' );
                                    
                                    this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                                  
                                }
                                else 
                                    //if( P_items.sfdcOrg =='CS69'){
                                    
                                    
                                    console.log('ceci est test p_items 222   '+P_items.sfdcOrg);
                                    console.log('les paramètres   '+responseObj.account);
                                    
                                    this.buildURL(record,responseObj.contract,responseObj.account,P_items );
                                                                        
                               // }
                                  /*  else {
                                        
                                        if(locale == 'en'  )   msg ='Doesn\'t get access for Buyout Application. Contact your System Administrator...'; 
                                        if(locale == 'fr')  msg ='Vous n\'avez pas les autorisations pour l\'application Buyout. Contactez l\'Administrateur Système...';
                                   
                                         var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": msg
                        });
                        successtoastEvent.fire();
                                      
                                    }*/
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
                        if(locale == 'fr')  msg ='Le Statut du n\'est pas en Traitement...';
                      
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
       },
    
    
    
    
    // CASE ASSIGN FUNCTION TO CURRENT USER 
    // ////    ASSIGN TO ME BUTTON
    
    doAssignToMe : function(component,event,helper){
        
        var caseRecord = component.get("v.caseRec");
        var record = component.get("v.recordId");
        var sObjectType = component.get("v.sobjecttype");
         console.log('objet est '+sObjectType);
        var action = component.get("c.doAssignCase");
        action.setParams({
            "caseRecord":caseRecord,
            "sObjectN":sObjectType,
            "cStatuts":'Pending',
        });
          action.setCallback(this, function(response) {
            var state = response.getState();
              var responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                
                    var responseData = response.getReturnValue();
                 console.log(' -- CECI le status --'+ responseData.status);
                if(responseData.status == 'Success'){
                    
                    var redirect = $A.get("e.force:navigateToSObject");
                redirect.setParams({
                    "recordId": record
                });
                
                this.doCreateTask(component);
                console.log('Assignation réussit');//' parsed 2'+value+' '+Key
                redirect.fire();
                $A.get('e.force:refreshView').fire();
                    
                 /*
                    console.log(' -- CECI le msg --'+ responseData.msg);
                var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "success",
                            "message": responseData.msg
                        });  
                  
                        successtoastEvent.fire();
                    */ 
                }           
             console.log(' -- CECI le new status --'+ responseData.status);
                if(responseData.status == 'warning'){
                    console.log(' -- CECI le msg --'+ responseData.msg);
                    var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "warning",
                            "message": responseData.msg
                        });
                        successtoastEvent.fire();
                    var redirect = $A.get("e.force:navigateToSObject");
                redirect.setParams({
                    "recordId": record
                });
                
                this.doCreateTask(component);
                console.log('Assignation réussit');//' parsed 2'+value+' '+Key
                redirect.fire();
                $A.get('e.force:refreshView').fire();
                    
                    
                }
                 if(responseData.status == 'Error'){
                var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": responseData.msg
                        });
                        successtoastEvent.fire();
                      var redirect = $A.get("e.force:navigateToSObject");
                        redirect.setParams({
                            "recordId": record
                        });
                         redirect.fire(); 
                   
                 }
                
                
               /* 
                 var  responseObj = JSON.parse(response.getReturnValue());
                
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
                 
                }
                else{
                
                var redirect = $A.get("e.force:navigateToSObject");
                redirect.setParams({
                    "recordId": record
                });
                
                this.doCreateTask(component);
                console.log('Assignation réussit');//' parsed 2'+value+' '+Key
                redirect.fire();
                $A.get('e.force:refreshView').fire();
               
                
            }
            */
            }
            else{
                console.log('Echec Assignation');
            }
            
        }),
            // Invoke the service
            $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
        
    },
    /////////////////////////////////////////////////////////////////////////
    //        CREATE NEW TASK
    //        /////////////////////////////////////////////////////////////////////
    
    
    doCreateTask : function(component) {
        
        var record = component.get("v.recordId");
        
        var action = component.get("c.doCreateNewTask");
        action.setParams({
            "caseId":record
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var taskId = response.getReturnValue()
                console.log('Task Id '+ taskId);
                
            }
            else{
                console.log('Echec creation task');
            }
         }),
            // Invoke the service
            $A.enqueueAction(action);
        
    },
    
    
    
	getCaseData : function(component,event,helper) {
		var action = component.get("c.getCaseRecord");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                if(responseData != null){
                 component.set("v.caseRec",responseData);
                 var caseData = component.get("v.caseRec");
                   if(caseData.Status == 'Closed'){
                        component.set("v.isCaseClose",false);
                        component.set("v.isCaseAssign",false);
                       component.set("v.isCaseRelated",false);
                       
                    }else{
                        component.set("v.isCaseClose",true);
                        component.set("v.isCaseAssign",true);
                    }   
                }
                console.log('------succes-----------'+caseData.Previous_Close_Case_User__c);
                       
                		if(caseData.Previous_Close_Case_User__c != null){
                           component.set("v.isCaseRelated",false);
                      	 }
                
                 console.log('------succes-----------');
            }
            else{
                console.log('Echec creation task');
            }
         }),
            $A.enqueueAction(action);
    },
    
    ////////////////////////////////////////////////////////////////////////////////
    
    saveCaseData : function(component,event,helper){
        
      var caseRecord = component.get("v.caseRec");
      var caseStatus = component.get('v.statusCase');
        console.log(' -- caseRecord --'+ caseRecord);
        console.log(' -- statusCase --'+ caseStatus);
      var action = component.get("c.saveCaseRecord");
        console.log(' -- statusCase 2 --'+ caseStatus);
        action.setParams({
            "caseRecord" : caseRecord,
            "caseStatus" : caseStatus
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                if(responseData.status == 'Success'){
                var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "success",
                            "message": responseData.msg
                        });  
                    console.log(' -- CECI est le STATUS CLOSED --'+ caseStatus);
                    
                    if(caseStatus === 'Closed'){
                        this.closeFocusedTab(component, event, helper);
                    }
                    
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": component.get("v.recordId"),
                            "slideDevName": "Detail"
                        });
                        navEvt.fire();
                     $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
                    successtoastEvent.fire();
                }
                else if(responseData.status == 'Error'){
                   var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": responseData.msg
                        });
                        successtoastEvent.fire(); 
                }
            }
            else{
                var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": JSON.stringify(response.getError())
                        });
                        successtoastEvent.fire();
            }
            
             
         }),
            $A.enqueueAction(action); 
     
    },
    
    ///////////////////////////////////////////////////////////////////////
    ////  GET RESOLUTION PICKLIST VALUE  /////////////////////////////////
    //
     getResolution : function(component, event, helper)
    {
        var action = component.get("c.getPickListValuesIntoList");
        component.set("v.sObjectName","Case");
        component.set("v.fieldName","Resolution__c");
         action.setParams({
            objectType: component.get("v.sObjectName"),
            selectedField: component.get("v.fieldName")
        });
        action.setCallback(this, function(response) {
            debugger;
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
        })
        $A.enqueueAction(action);
    },
    
    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////  OPEN RELATED CASE //////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    openRelatedCase : function(component, event, helper)
    {
        
        var caseRecord = component.get("v.caseRec");
        var caseStatus = component.get('v.statusCase');
        console.log(' -- caseRecord de new --'+ caseRecord);
        
        var action = component.get("c.GenarateRelatedCase");
        console.log(' -- statusCase 2 --'+ caseStatus);
        action.setParams({
            "caseRecord" : caseRecord
        });
        
         action.setCallback(this, function(response) {
            var state = response.getState();
              console.log(' -- CECI le response --'+ response.getReturnValue());
            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                 console.log(' -- CECI le status --'+ responseData.status);
                if(responseData.status == 'Success'){
                    console.log(' -- CECI le msg --'+ responseData.msg);
                var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "success",
                            "message": responseData.msg
                        });  
                  
                        successtoastEvent.fire();
                    
                    this.closeFocusedTab(component, event, helper);
                    this.openTab(component,responseData.OpenCase);
                  //  this.redirectToRecord(responseData.OpenCase);
                     
                }           
             console.log(' -- CECI le new status --'+ responseData.status);
                if(responseData.status == 'warning'){
                    console.log(' -- CECI le msg --'+ responseData.msg);
                    var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "warning",
                            "message": responseData.msg
                        });
                        successtoastEvent.fire();
                    
                     this.closeFocusedTab(component, event, helper);
                     this.openTab(component,responseData.OpenCase);
                     //this.redirectToRecord(responseData.OpenCase);
                    
                }
                 if(responseData.status == 'Error'){
                     console.log(' -- CECI est icic --'+ responseData.msg);
                var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": responseData.msg
                        });
                        successtoastEvent.fire();
           
                 }
            }
                else{
                     var successtoastEvent = $A.get("e.force:showToast");
                        successtoastEvent.setParams({
                            "title": "",
                            "type": "Error",
                            "message": responseData.msg
                        });
                        successtoastEvent.fire();
                }
         }),
            $A.enqueueAction(action); 
        
        
         },
    
    
    
    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    
    
    openTab : function(component, newCaseId) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            recordId:newCaseId ,
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                  tabId: response
            }).then(function(tabInfo) {
            console.log("The url for this tab is: " + tabInfo.url);
            });
        })
        .catch(function(error) {
               console.log(error);
        });
    },


})