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
        String cid, eSubject, eStatus, eRelatedto, eRToEM, eToAdress, eMessage, cOwner, cLang, caseId, eFromEM, eReply;
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
                eFromEM = emsg.FromAddress;
                eStatus = emsg.Status;
                eReply = emsg.ReplyToEmailMessageId;
                System.debug('le contenu ');
                //     relatedCAse = new Case (Id = eRToEM, SAC_MailBox__c = eToAdress, Description = eMessage)  ; 
            }
            System.debug('Le case Id '+LEmailLMsg[0].RelatedToId+' ou bien '+eRToEM);
            System.debug(' ou bien '+eRToEM+ ' eReply '+eReply);
            caseList = [Select id, OwnerId, Status, Subject, Langue_Communication__c, ClosedDate, Previous_Close_Case_User__c, recordTypeId 
                        from Case 
                        Where Id = :LEmailLMsg[0].ParentId];
            if(caseList.size() > 0 ){
                
                
                List<Group> LCOwner = [Select OwnerId, Type, Name, DeveloperName, Id From Group Where Id = :caseList[0].OwnerId AND Type = 'Queue' ];
                
                System.debug('Le owner Id '+caseList[0].OwnerId+ ' ============  eIncoming =='+eIncoming+ ' ======== le size group == '+LCOwner.size()+' === eStatus =='+eStatus);
                
                //////////
                
                if(eIncoming == true && LCOwner.size() == 0 && caseList[0].Status != 'New' ){  //LCOwner.size() == 0 && 
                    
                    Double reOpenDate = 0;
                    //reOpenDate = DateTime.now().getTime() - caseList[0].ClosedDate.getTime() ;
                    
                    if(caseList[0].ClosedDate != null){
                        reOpenDate = System.now().getTime() - caseList[0].ClosedDate.getTime();
                        
                        
                        System.debug('Le temps est  '+reOpenDate*24);
                    }
                    
                    
                    //   Create new Case il delay exeed 
                    caseList1 = CaseOpenNewForDelayBefore.OpenNewBeforDelay(caseList, LEmailLMsg, reOpenDate);
                    
                    System.debug('Le caseList1 du case '+caseList1); 
                    upsert caseList1;
                }
                ///////////
                
                
                // When owner is queue and email incomming
                else { 
                    if(LCOwner.size() > 0 && eIncoming == false && caseList[0].Status != 'Resolved'){
                        System.debug('Le owner Id du case '+LCOwner+' ou bien '+LCOwner[0].ownerId+ ' avec le case owner '+caseList[0].OwnerId+' eIncoming'+eIncoming); 
                        LightningComponentController.AssignCaseToMe(caseList[0].Id, 'Case', 'Waiting for Customer');               
                    }
                    else{
                        if(LCOwner.size() == 0 && eIncoming == false && eStatus != '1'){
                            caseList1.add( new Case(id = caseList[0].Id, Status = 'Waiting for Customer'));
                            System.debug('Le caseList1 du case '+caseList1); 
                            upsert caseList1;
                        }                    
                    }  
                }  
            }
        }catch(Exception ex){
            system.debug(ex.getStackTraceString());
        }
    }  
}