public class EmailMessage_Trigger_Handler {
   
    Public static void EmailMessageManage(List<EmailMessage> LEmailLMsg){
        try{ 
        String cid, eSubject, eStatus, eRelatedto, eRToEM, eToAdress, cLang, eMessage, eReply, company;
        Boolean eIncoming;
       Case relatedCAse; 
        
            for(EmailMessage eMsg : LEmailLMsg) {                
            	eIncoming = eMsg.Incoming;
                eToAdress = emsg.ToAddress;
                eRToEM = emsg.RelatedToId;
                eMessage = emsg.TextBody;
                system.debug(' email de reception  '+ eToAdress);
				company = (eToAdress.substringAfter('@')).substringBefore('.');
                if(company == 'hitachicapital' || company == 'clecapital'){
                        company = company;
                    }
                    else company = null;
                    
system.debug(' la company est   '+ company); 
                
                if(eToAdress.length() <= 200){
                   
                    relatedCAse = new Case (Id = eRToEM, CS_MailBox__c = eToAdress, company__c = company, Description = eMessage )  ;
                }
                else
                	relatedCAse = new Case (Id = eRToEM, CS_MailBox__c = eToAdress.Left(200)+' ...', company__c = company, Description = eMessage )  ;
               
               
                }
        system.debug(' ceci est un test '+ relatedCAse);
        String cCase;
        for(Case currentCase : [Select id, CS_MailBox__c, company__c from Case Where id = :eRToEM]){
            cCase = currentCase.CS_MailBox__c;
        }
        
        if(eIncoming == true && cCase == null){
             
             system.debug(' le case est '+ relatedCAse);
                upsert relatedCAse; 
            }
        }catch(Exception ex){
            system.debug(ex.getStackTraceString());
        }
    }
    
    
    Public static void EmailMessageManageBefore(List<EmailMessage> LEmailLMsg){
        System.debug('Le parent case Id '+LEmailLMsg[0].ParentId);
        System.debug('Le case Id '+LEmailLMsg);
        String cid, eSubject, eStatus, eRelatedto, eRToEM, eToAdress, eMessage, cOwner, cLang, caseId, eReply;
        Boolean eIncoming;
        List<Case> caseList = new  List<Case>();
        List<Case> caseList1 = new  List<Case>();
        Case relatedCAse; 
        List<String> lOwner = new List<String>();
        List<String> lRToEM = new List<String>();
        Customer_Service_Setting__c CS_Setting = Customer_Service_Setting__c.getOrgDefaults();
        try{
        for(EmailMessage eMsg : LEmailLMsg) {                
            	eIncoming = eMsg.Incoming;
                eToAdress = emsg.ToAddress;
                eRToEM = emsg.RelatedToId;
                eMessage = emsg.TextBody;
            eReply = emsg.ReplyToEmailMessageId;
            System.debug('le contenu ');
           //     relatedCAse = new Case (Id = eRToEM, SAC_MailBox__c = eToAdress, Description = eMessage)  ; 
                }
        System.debug('Le case Id '+LEmailLMsg[0].RelatedToId+' ou bien '+eRToEM);
        System.debug(' ou bien '+eRToEM+ ' eReply '+eReply);
        caseList = [Select id, OwnerId, Status, Langue_Communication__c, ClosedDate, Previous_Close_Case_User__c, recordTypeId from Case Where Id = :LEmailLMsg[0].ParentId];
        if(caseList.size() > 0 ){
          
            System.debug('Le owner Id '+caseList[0].OwnerId);
            List<Group> LCOwner = [Select OwnerId, Type, Name, DeveloperName, Id From Group Where Id = :caseList[0].OwnerId AND Type = 'Queue' ];
            
            // When owner is queue and email incomming
            if(LCOwner.size() > 0 && eIncoming == false && caseList[0].Status != 'Resolved'){
                System.debug('Le owner Id du case '+LCOwner+' ou bien '+LCOwner[0].ownerId+ ' avec le case owner '+caseList[0].OwnerId+' eIncoming'+eIncoming); 
                LightningComponentController.AssignCaseToMe(caseList[0].Id, 'Case', 'Waiting for Customer');
               
            }
            // when owner not a queue and incomming email
            ///////////////////////////////////////////////// Need to add new logic base on date the case was closed (if case is closed)
            else{
                System.debug('Le LC du case '+LCOwner.size() +' ou bien '+' eIncoming'+eIncoming);
                
                if(LCOwner.size() == 0 && eIncoming == true){
                    Long reOpenDate = 0;
                    if(caseList[0].ClosedDate != null){
                    reOpenDate = System.now().getTime() - caseList[0].ClosedDate.getTime();
                    
                    System.debug('Le temps est  '+reOpenDate*24);
                    }
                    
                    Manage_Case_Delay_Before__c delayBefore = Manage_Case_Delay_Before__c.getOrgDefaults();
              
                    if(reOpenDate*24 >= delayBefore.Delay_Before_Assign__c && delayBefore.Enable_Delay__c == true  ){
                        List<Group> CS_Owner = [Select OwnerId, Type, Name, DeveloperName, Id From Group Where Name = 'CS Queue' AND Type = 'Queue' Limit 1]; //:CS_Setting.Queue_Name__c
                        caseList1.add( new Case(id = caseList[0].Id, Status = 'Waiting For Support', OwnerId = CS_Owner[0].Id));
                    }
                    else{
                        caseList1.add( new Case(id = caseList[0].Id, Status = 'Waiting For Support'  ));
                    }
                
                     System.debug('Le caseList1 du case '+caseList1); 
                upsert caseList1;
                }
                // when owner not a queue and not incomming email
                 if(LCOwner.size() == 0 && eIncoming == false && caseList[0].Status != 'Resolved'){
                caseList1.add( new Case(id = caseList[0].Id, Status = 'Waiting for Customer'  ));
                     System.debug('Le caseList1 du case '+caseList1); 
                upsert caseList1;
                }
            }
        }
    }catch(Exception ex){
        system.debug(ex.getStackTraceString());
    }
    }  
}