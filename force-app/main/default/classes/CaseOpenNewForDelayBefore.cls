/*
  Create by Alban Tagnitsap 2022/01/18

  Using to create new Case from existing email queue when responding after delay
 
 */

public class CaseOpenNewForDelayBefore {
    
    Public static List<Case> OpenNewBeforDelay( List<Case> caseList, List<EmailMessage> LEmailLMsg, Double reOpenDate){
        
        List<Case> caseList1 = new  List<Case>();
        String cid, eSubject, eStatus, eRelatedto, eRToEM, eToAdress, eMessage, cOwner, cLang, caseId, eFromEM, eReply;
        Boolean eIncoming;
        
        for(EmailMessage eMsg : LEmailLMsg) {                
            eIncoming = eMsg.Incoming;
            eToAdress = emsg.ToAddress;
            eRToEM = emsg.RelatedToId;
            eMessage = emsg.TextBody;
            eFromEM = emsg.FromAddress;
            eStatus = emsg.Status;
            eReply = emsg.ReplyToEmailMessageId;
            System.debug('le contenu ');
            
        }
        
        Manage_CS_Case_Delay_Before__c delayBefore = Manage_CS_Case_Delay_Before__c.getOrgDefaults();
        Manage_Collection_Case_Delay_Before__c delayBeforeCS = Manage_Collection_Case_Delay_Before__c.getOrgDefaults();
        String RTName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(caseList[0].recordTypeId).getName();
        
        // Open new case depend of delay after previous case was closed 
        //              
        System.debug('le record type name ===  '+RTName);
        if(RTName == 'Customer Service'){
            
            if((reOpenDate/60000)/60 >= delayBefore.Delay_Before_Assign__c && delayBefore.Enable_Delay__c == true  ){
                
                // get queue Id using queue email adresse (ToAdress)
                
                List<Group> CS_Owner = [Select OwnerId, Type, Name, DeveloperName, Id From Group Where email = :eToAdress AND Type = 'Queue' Limit 1]; //:CS_Setting.Queue_Name__c
                caseList1.add( new Case( 
                    Status = 'New', 
                    Subject = caseList[0].Subject, 
                    OwnerId = CS_Owner[0].Id, 
                    Description = eMessage, 
                    SuppliedEmail = eFromEM,
                    Origin = 'Email',
                    recordTypeId = caseList[0].recordTypeId
                )); //, OwnerId = CS_Owner[0].Id,   id = caseList[0].Id,
            }
            else{
                caseList1.add( new Case(id = caseList[0].Id, Status = 'Waiting For Support', Description = eMessage  ));
            }
        }
        else{
            
            if((reOpenDate/60000)/60 >= delayBeforeCS.Delay_Before_Assign__c && delayBeforeCS.Enable_Delay__c == true  ){
                
                // get queue Id using queue email adresse (ToAdress)
                
                List<Group> CS_Owner = [Select OwnerId, Type, Name, DeveloperName, Id From Group Where email = :eToAdress AND Type = 'Queue' Limit 1]; //:CS_Setting.Queue_Name__c
                caseList1.add( new Case( 
                    Status = 'New', 
                    Subject = caseList[0].Subject, 
                    OwnerId = CS_Owner[0].Id, 
                    Description = eMessage, 
                    SuppliedEmail = eFromEM,
                    Origin = 'Email',
                    recordTypeId = caseList[0].recordTypeId
                )); //, OwnerId = CS_Owner[0].Id,   id = caseList[0].Id,
            }
            else{
                caseList1.add( new Case(id = caseList[0].Id, Status = 'Waiting For Support', Description = eMessage  ));
            }
            
        }
        return caseList1;
    }
    
}