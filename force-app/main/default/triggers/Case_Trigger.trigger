trigger Case_Trigger on Case (after insert, after update, before insert, before update) {
    /*
if(Trigger.isInsert && Trigger.isAfter){
CaseStatusMetricTriggerHandler.OnAfterInsert(Trigger.new);
} 
else if (Trigger.isUpdate && Trigger.isAfter) {
CaseStatusMetricTriggerHandler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
}

*/
    if(system.isFuture()) return;
    
    if(Trigger.isBefore){
        
        CaseTriggerHandler.OnBefore(Trigger.new, Trigger.oldMap);
       // CaseTriggerHandler.OnBeforeOnOwner(Trigger.new);
    } 
    
    if(Trigger.isAfter){
        if (Trigger.isUpdate ) {
            CaseStatusMetricTriggerHandler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
         // CaseTriggerHandler.OnAfeterUpdate(Trigger.new);
           
            List<Case> lc = Trigger.new;
            system.debug(' le escalated status -- '+lc[0].Status);
            if(lc[0].Status == 'Escalated'){
                
                if (Trigger.oldMap !=null){
                    
                    CaseRedirectToTriggerHandler.RedirectToDepartment(lc, Trigger.oldMap);
                    
                    Case oldObject = Trigger.oldMap.get(lc[0].Id);
                    if (lc[0].Status != oldObject.Status) {
                         system.debug(' les cases value  -- '+lc[0].Status+ ' -- '+oldObject.OwnerId);
                         CaseOwnerAfterEscalated.UpdateOwner(lc[0].Id, lc[0].Status, oldObject.OwnerId);
                    }
                }
                
                
                
            }
      
        }
        if(Trigger.isInsert ){
            CaseStatusMetricTriggerHandler.OnAfterInsert(Trigger.new);
        } 
    }
}