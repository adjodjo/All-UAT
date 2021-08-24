({
    getCaseData : function(component,event,helper) {
        
        var items;
        var metric;
        var record = component.get("v.recordId");
        //var action = component.get("c.ConvertComputationDelay");
        var action = component.get("c.getcaseCreatedTime");
        
        
        console.log("record--------", record)
        // component.set("v.recordId", "5002D000006ZzmkQAC");
        action.setParams({
            "recordId" : record
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            //alert(state);
            console.log("state--------", state)
            console.log("items--------", response.getReturnValue())
            if (state === "SUCCESS") {
                
                //items = JSON.parse(response.getReturnValue())
                //console.log("items", response.getReturnValue())
                
                //console.log('AssignTime '+items.assignTime);
                //console.log('pendingTime '+items.pendingTime);
                
                //alert(items.assignTime);
                
                component.set("v.createdTime",response.getReturnValue());
                //component.set("v.createdTime",items.createdTime);
                //component.set("v.assignTime",items.assignTime);
                //component.set("v.pendingTime",items.pendingTime);
            }
        }),
            $A.enqueueAction(action);
        
    },
    getCaseAssignedTime : function(component,event,helper){
        var record = component.get("v.recordId");
        var action = component.get("c.getcaseAssignedTime");
        action.setParams({
            "recordId" : record
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('AssignTimeState'+state);
                component.set("v.assignTime",response.getReturnValue());
            }
        }),
            $A.enqueueAction(action);
        
    },
    
    getCasePendingTime : function(component,event,helper){
        var record = component.get("v.recordId");
        var action = component.get("c.getcasePendingTime");
        action.setParams({
            "recordId" : record
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('AssignTimeState'+state);
                component.set("v.pendingTime",response.getReturnValue());
            }
        }),
            $A.enqueueAction(action);
        
    }
    
})