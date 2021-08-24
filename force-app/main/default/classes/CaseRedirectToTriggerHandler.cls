public class CaseRedirectToTriggerHandler {
    
    public static void RedirectToDepartment(List<Case> lCase, Map<Id, Case> oldObjectMap){
        
        String caseId, eId, cSubject, cTexte, eFromAdd, eToAdd, cOwner, cQueueEmail, oldOwner ;
        List<String> lem = new List<String>();
        List<EmailMessage> LEMessage = new List<EmailMessage>();
        
        List<ContentVersion> contentV  = new List<ContentVersion>();
        
        
        try{
            for(Case currentCase : lCase){
                caseId = currentCase.Id;
                cOwner = currentCase.OwnerId;
                cSubject = currentCase.Subject;
                cTexte = currentCase.Description;
            }
            
            List<Group> owner = [Select id, email from Group where id = :cOwner AND Type = 'Queue' Limit 1];
            
            
            
            if(owner.size() > 0){
                cQueueEmail = owner[0].email;
            }
            
            system.debug(' -- le cQueueEmail --'+cQueueEmail);
            
            LEMessage = Case_GetEmailMessage.GetEmailMessage(caseId);
            
            for(EmailMessage em : LEMessage){
                
                if(em.Id == null){
                
                    em.Subject = cSubject;
                    em.TextBody = cTexte;
                
            }
                lem.add(em.Id);
            }
            
            
            
            system.debug(' -- le LEMessage --'+lem);
            
            Map<Id, List<ContentVersion>> LCVersion = new Map<Id, List<ContentVersion>>();
            LCVersion = Case_GetEmailAttachment.GetEmailAttachment(lem, caseId);
            system.debug(' -- le contentversion --'+LCVersion);
            
            /*    for(EmailMessage eMsg : LEMessage){

eId = eMsg.Id;
eSubject = eMsg.Subject;
eTexte = eMsg.TextBody;
eFromAdd = eMsg.FromAddress;
eToAdd = eMsg.ToAddress;
*/   
            
            for (Id key : LCVersion.keySet()){
                
                //    if(eId == key){
                contentV=LCVersion.get(key);
                //    }
                system.debug(' -- le contentV --'+contentV);
                
                // call send email
                
            }
            //    }
            
            if(contentV.size() > 0){
                system.debug(' -- le contentV est --'+contentV);
                Case_SendRedirectEmail.SendRedirectEmail(LEMessage, contentV, cQueueEmail, lCase );
            }
            else {
                Case_SendRedirectEmail.SendRedirectEmail(LEMessage, null, cQueueEmail, lCase );
            }
            
            if (oldObjectMap!=null){
                Case oldObject = oldObjectMap.get(caseId);
                if(oldObject.OwnerId != null){
                    oldOwner = oldObject.OwnerId;
                }
                
                Case newCase = new Case(Id = caseId, OwnerId = oldOwner);
            // update newCase;
            }
            
            
            
            
        }catch(Exception ex){
           If (ex.getMessage() != null){
                system.debug('======='+ex.getStackTraceString());
             
            }
        }
    }
    
}