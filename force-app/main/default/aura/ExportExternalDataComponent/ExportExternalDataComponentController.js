({
    doInit : function(component, event, helper) {
        helper.getAppData(component,event,helper);
    },
    
    backOnRecord : function(component,event,helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "Detail"
        });
        navEvt.fire();  
    },
    exportData : function(component,event,helper){
        var appValue = component.get("v.selectedApp");
        if(appValue == '' || appValue == null || appValue == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "Error",
                "title": "Error!",
                "message": "Please select application."
            });
            toastEvent.fire();
            return false;
        }
        component.set("v.spinner",true);
        var action = component.get("c.getDataFromExternalApp");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "applicationId" : appValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result != null && result != undefined){
                    if(result.status == 'Success'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "Success",
                            "message": result.message
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                    }else if(result.status == 'Error'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "Error",
                            "message": result.message
                        });
                        toastEvent.fire();
                    }
                    component.set("v.spinner",false);
                }
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Error",
                    "message": response.getError()[0].message
                });
                toastEvent.fire();
            component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
    },
})