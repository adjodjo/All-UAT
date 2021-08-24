({/*
    doAssignToMe : function(component, event, helper) {        
        
        var record = component.get("v.recordId");
        var sObjectType = component.get("v.sobjecttype");
         console.log('objet est '+sObjectType);
        var action = component.get("c.AssignCaseToMe");
        action.setParams({
            "caseId":record,
            "sObjectN":sObjectType,
            "cStatuts":'Pending',
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
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
                 console.log('CECI EST UN TEST 1');
                }
                else{
                
                var redirect = $A.get("e.force:navigateToSObject");
                redirect.setParams({
                    "recordId": record
                });
                
                      $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                    
                this.doCreateTask(component);
                console.log('Assignation réussit');//' parsed 2'+value+' '+Key
                redirect.fire();
               
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
            }
            }
            else{
                console.log('Echec Assignation');
            }
          
        }),
            // Invoke the service
            $A.enqueueAction(action);
        console.log('CECI EST UN TEST 2');
     //  $A.get('e.force:refreshView').fire();
     //   $A.get('e.force:refreshView').fire();
       // $A.get("e.force:closeQuickAction").fire();
    },
    
    
    doCreateTask : function(component) {
        
        var record = component.get("v.recordId");
        
        var action = component.get("c.CreateNewTask");
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
    
    
/*    refreshFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.refreshTab({
                      tabId: focusedTabId,
                      includeAllSubtabs: true
             });
        })
        .catch(function(error) {
            console.log(error);
        });
    }

    */
})