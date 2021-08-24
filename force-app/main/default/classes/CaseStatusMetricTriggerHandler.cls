public class CaseStatusMetricTriggerHandler {
    
     static final String message_16 = 'message_16';
    static final String message_14 = 'message_14';
    
    public static void OnAfterInsert(Case[] newCase){
        
        List<Case_Status_Metric__c> statusChanges = new List<Case_Status_Metric__c>();
        statusChanges.addAll(createCaseStatus(newCase, null));
        
        
        
        insert statusChanges;
    }
    
    private static List<Case_Status_Metric__c> createCaseStatus(Case[] caseObjects, Map<Id, Case> oldObjectMap){
        
        List<Case_Status_Metric__c> statusChanges = new List<Case_Status_Metric__c>();
        String ownerId;
        Map<Id, Case> cases = new Map<Id, Case>([SELECT CaseNumber, Owner.Name from Case where id in:caseObjects]);
        for (Case caseObject: caseObjects) {
            Case_Status_Metric__c  statusChange = null;
            
            if (cases.size()>0) {
                
                //this is the update case, check if the status has changed or not, if changed
                //a new case status change record is created 
                if (oldObjectMap!=null){
                    Case oldObject = oldObjectMap.get(caseObject.Id);
                    if (caseObject.Status != oldObject.Status) { 
                        
                        statusChange = new Case_Status_Metric__c();
                        statusChange.Previous_Case_Status__c  = oldObject.Status;
                        statusChange.Name = cases.get(caseObject.id).CaseNumber+' from '+oldObject.Status +' to '+caseObject.Status;
                    }
                    
                }
                // this is the new case, the first case status change record is created
                else{
                    statusChange = new Case_Status_Metric__c();
                    statusChange.Name = cases.get(caseObject.id).CaseNumber+' status: '+caseObject.Status;                 
                }
                //populate the rest of fields, add it to the result list to return 
                if (statusChange!=null) {
                    
                    
                    statusChange.Case__c = caseObject.Id;
                    statusChange.Case_Status__c = caseObject.Status;
                    statusChange.Owner_Case__c = cases.get(caseObject.id).Owner.Name;
                    statusChange.Status_Start_Time__c = Datetime.now();
                    statusChanges.add(statusChange);
                    
                }  
            }
        }
        
        return statusChanges;
        
    }
    
    public static void OnAfterUpdate(Case[] updatedObjects, Map<Id, Case> oldObjectMap){
        
        List<Case_Status_Metric__c> statusChanges = new List<Case_Status_Metric__c>();
        List<Case_Status_Metric__c> statusChangesToUpdate = new List<Case_Status_Metric__c>();
        List<String> oldStatuses = new List<String>();
        List<Id> caseIds = new List<Id>();
        
        statusChanges.addAll(createCaseStatus(updatedObjects, oldObjectMap));
        
        //construct old status List and Ids to retrieve old case status changes to update the business hours
        for (Case_Status_Metric__c statusChange: statusChanges) {
            
            oldStatuses.add(statusChange.Previous_Case_Status__c);
            caseIds.add(statusChange.Case__c);            
        }
        
        if (caseIds.size()>0 && oldStatuses.size()>0) {
            
            List<Case_Status_Metric__c> oldStatusChanges = [select Id, Name, Status_Start_Time__c from Case_Status_Metric__c where Case_Status__c IN :oldStatuses and Case__c IN :caseIds and Status_End_Time__c=null];
            BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
            
            for (Case_Status_Metric__c oldStatusChange: oldStatusChanges) {
                
                // calculate business hours               
                oldStatusChange.Status_End_Time__c = Datetime.now();
                Double milliseconds = BusinessHours.diff(bh.Id, oldStatusChange.Status_Start_Time__c, oldStatusChange.Status_End_Time__c);                 
                oldStatusChange.Status_Time__c = (Decimal.valueOf(milliseconds)).Divide((60*60*1000), 2);
                // oldStatusChange.Age__c = getAge(milliseconds);
                statusChangesToUpdate.add(oldStatusChange);
            }
        }
        insert statusChanges;
        update statusChangesToUpdate;
        
     //   UpdateOwner(updatedObjects);        
    }
    
    /*
    
    Private static void UpdateOwner(Case[] caseObjects){
        
        String userLanguage = UserInfo.getLanguage();
        String cStatus, cOwnerId, cId, cType;
        Case oldObject;
        Case cas;
        try{
            List<Case> Cases = new List<Case>();
            List<Case> caseList = new List<Case>();
             List<Group> LCOwner = [Select OwnerId, Type, Name, DeveloperName, Id From Group Where Id = :caseObjects[0].OwnerId AND Type = 'Queue' ];
            for(case caseObject : caseObjects){
                cId = caseObject.Id;
                cOwnerId = caseObject.OwnerId;
                cStatus = caseObject.Status;
                cType = caseObject.Type;
            }
            caseList = [Select id, type from Case Where Origin = 'Email' AND Status = 'Pending' AND OwnerId = :cOwnerId];
         system.debug('test case 222 et plus ---'+caseList.size());
        if(caseList.size() > 3){
            
            for(case caseObject : caseObjects){
                system.debug('test case 25---'+caseList);
               
                caseObject.addError(MessageUtils.ErrorMessage(userLanguage, message_14));
            }
            
        }
            else{
                system.debug('test case 33---'+caseList);
                  if (cStatus == 'Escalated' || cType != 'Redirect To'){
                 cas = new Case(Id = cId, Status = 'Pending', Type = cType,  OwnerId = UserInfo.getUserId(), Pending_Start_Date__c = System.now());
                    system.debug('test 33---'+caseList);
                         cases.add(cas);
                         system.debug('case 33---'+cases);
                	}
                
                if(cases.size() > 0){
                 //   upsert cases;
                }
              
            }
            
            
         
        }catch(Exception ex){
            
            If (ex.getMessage() != null){
                system.debug('test case 1===='+ex.getMessage());
                for(case caseObject : caseObjects){                  
                    caseObject.addError(MessageUtils.ErrorMessage(userLanguage, message_16));
                }
            }
        }
    }
    */
    
    /* 
private static String getAge(Double milliseconds) {

Double duration = milliseconds;
Double d = Math.floor(duration/86400000); //Get whole days
duration -= d*86400000;
Double h = Math.floor(duration/3600000); //Get whole hours
duration -= h*3600000;
Double m = Math.floor(duration/60000);
duration -= m*60000;
Double s = Math.floor(duration/1000);
return d.format()+' days '+h.format()+' hours '+ m.format() + ' minutes ' + s.format() +' seconds';
}

*/
}