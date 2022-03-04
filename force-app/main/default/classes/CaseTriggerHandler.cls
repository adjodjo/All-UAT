public class CaseTriggerHandler {
    
    static final String message_14 = 'message_14';
    static final String message_15 = 'message_15';
    static final String message_16 = 'message_16';
     static final String message_17 = 'message_17';
    
    public static void OnBefore(Case[] caseObjects, Map<Id, Case> oldObjectMap){
        
        String userLanguage = UserInfo.getLanguage();
        String errMsg, cId, cOwnerId, cStatus, cType;
        List<Case> Cases = new List<Case>();
        Case caseObject;
         Case oldObject;
        String cAcc, cCont;
        Map<String, Object> response;
        // Map<Id, Case> mapCase = new Map<Id, Case>([SELECT CaseNumber, Owner.Name from Case where Status = 'Pending' and id in:caseObjects]);
        
        try{    
            List<Case> caseList = new List<Case>();
            
            for(case c : caseObjects){
                
                caseObject = c;
                cOwnerId = userinfo.getUserId();
            }
             if( caseObject.status != 'Closed' || caseObject.status != 'New' || caseObject.status != 'Escalated'){
                
               // Case emailCase = new Case(Id = cId);
                caseList = [Select id from Case Where (Origin = 'Email' OR Origin = 'EIP') AND Status = 'Pending' AND OwnerId = :caseObject.OwnerId];
             }
                system.debug('oldObjectMap---'+oldObjectMap+ '   caseObject Id---'+caseObject);
                
                if (oldObjectMap!=null){
                        oldObject = oldObjectMap.get(caseObject.Id);
              
            system.debug('test cStatus---'+caseObject.Status+ '---- la precedenete est --- '+oldObject.Status);
            
            if( caseObject.status != 'Closed' || caseObject.status != 'New' || caseObject.status != 'Escalated'){ // Waiting for Customer  Waiting For Support
         /*   if( caseObject.status == 'Pending' || caseObject.status == 'On Hold' || caseObject.status == 'Resolved' 
               || caseObject.status == 'Waiting for Customer'  || caseObject.status == 'Waiting For Support'){*/
               
                system.debug('test case 222---'+caseList.size());
                
                           
                system.debug('Le case status de changement est ---'+caseObject.Status);
                
                // Check personnal queue and manage case status eccepte when communication is from or to customer
                
                Manage_Number_Of_Case__c numberOfCase = Manage_Number_Of_Case__c.getOrgDefaults();
                
            if((caseList.size() > numberOfCase.Number_Of_Pending_Case__c &&  numberOfCase.Hard_Stop__c == true)
                && ((caseObject.status != 'Pending' && oldObject.Status == caseObject.status)
                                            || (caseObject.status != 'Pending' && (oldObject.Status != 'Pending' ))           
                                           )){
                                               system.debug('Le case status de changement est 2---'+caseObject.status);
                                               if(oldObject.Status != 'Waiting For Costomer' && caseObject.status != 'Waiting For Support' && caseList.size() > 3){
                                                   
                                                   
                                                   for(case caseO : caseObjects){
                                                       system.debug('test case 25---'+caseList);
                                                       errMsg = MessageUtils.ErrorMessage(userLanguage, message_14);
                                                       caseO.addError(errMsg);
                                                   }
                                               }
                                           }
                else {
                    
             
                }  
            }
            else{
           
                Integer intValue = ControllingPicklist.getFieldDependencies('Case', 'Type', 'Sub_Type__c', caseObject.Sub_Type__c);    //= 0; // = PicklistValueCheck.getPicklistValues(field);

                
                if(caseObject.Type == null  || (caseObject.Sub_Type__c == null && intValue > 0)){
             
                    for(case caseO : caseObjects){
                        
                        errMsg = MessageUtils.ErrorMessage(userLanguage, message_15);
                        //errMsg = 'You can not Closed Case without Case Type';
                        caseO.addError(errMsg);
                    }             
                }                
              
            }
        }
            
            
        }catch(Exception ex){
            
            If (ex.getMessage() != null){
                system.debug('======='+ex.getMessage());
             
                caseObjects[0].addError(MessageUtils.ErrorMessage(userLanguage, message_16));
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    public static void OnAfeterUpdate(Case[] caseObjects){
        String cOwnerId, cId, cAd;
         for(case c : caseObjects){
            cId = c.Id;
            cOwnerId = c.OwnerId;
             cAd = c.ActiveDirectory_Username__c;
            }
        List<Group> sys = [select id, Name from Group where id = :cOwnerId];
        
        if(sys.size() > 0){
            
          user u = [Select Id from user where EIP_Login_User__c =:cAd limit 1];
            
          Case cas = new Case(Id = cId, OwnerId = u.Id);
            
            upsert cas;
        }
        
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
  
}