({
	getAppData : function(component,event,helper) {
		var action = component.get("c.getExternalApplicationData");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result != null && result != undefined){
                    var data = [];
                    for(var i=0;i<result.length;i++){
                        data.push({
                            'label' : result[i].applicationName,
                            'value' : result[i].applicationId
                        });
                    }
                    component.set("v.applicationData",data);
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Error",
                    "message": response.getError()[0].message
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
	},
})