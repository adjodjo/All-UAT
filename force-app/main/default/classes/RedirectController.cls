public class RedirectController {
    
    static final String message_14 = 'message_14';
    static final String message_15 = 'message_15';
    static final String message_16 = 'message_16';
    static final String message_18 = 'message_18';
    
    
     @AuraEnabled
    public static String doVerifierCaseStatus(Case caseRecord){
        
        String CaseVerif = LightningComponentController.VerifierCaseStatus(caseRecord);
        
        return CaseVerif;
    }
    
     @AuraEnabled
    public static String doBuildLink(Case caseRecord){
        
        String link = LightningComponentController.BuildLink();
        
        return link;
    }
    
    
      
     @AuraEnabled
    public static Result doAssignCase(Case caseRecord, String sObjectN, String cStatuts){
       Result res = new Result();
        String userLanguage = UserInfo.getLanguage();
        Case responce;
       String assign = LightningComponentController.AssignCaseToMe(caseRecord.Id, sObjectN, cStatuts);
        if (assign == 'message_14'){
             res.status = 'Error';
             res.msg = MessageUtils.ErrorMessage(userLanguage, message_14);
        }
        if (assign == 'message_18'){
            res.status = 'warning';
            res.msg = MessageUtils.ErrorMessage(userLanguage, message_18);
            
        }
         if (assign == 'message_16'){
          res.status = 'Error';
          res.msg = MessageUtils.ErrorMessage(userLanguage, message_16);
        }
        if (assign == null){
            
            res.status = 'Success';
            res.msg = '';
            
        }
        
        return res;
    }
        
    
    @AuraEnabled
    public static String doCreateNewTask(String caseId){
        
        String task = LightningComponentController.CreateNewTask(caseId);
        
        return task;
    }
    
    
    @AuraEnabled
    public static Case getCaseRecord(String recordId){
        Case caseRec;
        for(Case cas : [SELECT Id,AccountId,ContactId,Subject,Description, Resolution__c, Type,Comments,Status, ownerId, Previous_Close_Case_User__c, recordTypeId, 
                        CS_MailBox__c, SuppliedEmail, CreatedById, ActiveDirectory_Username__c, Origin,  Contrat_InfoLease__c , CustId__c
                        FROM Case WHERE Id =: recordId LIMIT 1]){
            caseRec = cas;
        }
        System.debug('caseRec--->' + caseRec);
        return caseRec;
    }
    
    @AuraEnabled
    public static Result saveCaseRecord(Case caseRecord, String caseStatus){
        Result res = new Result();
        String uGp=null, userLanguage = UserInfo.getLanguage();
        String currentUser = UserInfo.getUserId();
        Case responce;
        System.debug('caseRecord 1--->' + caseRecord);
        try{
        //    if(caseRecord.Type == null){
                    for(Case cas : [SELECT Id,AccountId,ContactId,Subject,Description, Resolution__c, Type,Comments,Status, ownerId FROM Case WHERE Id =: caseRecord.Id LIMIT 1]){
                        caseRecord = cas;
                    }
         //      }     
            
            if(caseStatus == 'Closed'){
                            //  if(caseRecord.Status == 'New'){
                if(caseRecord.Type == null){
                    res.status = 'Error';                    
                            res.msg = MessageUtils.ErrorMessage(userLanguage, message_15);
                }else{
                    
                        for (  Group g : [SELECT Id, Name FROM Group where Id =:caseRecord.OwnerId AND Type = 'Queue' ]){
                            uGp = g.Id;
                        }
                    if(uGp != null){
                        
                            caseRecord.Status = caseStatus; //'Resolved';
                            caseRecord.OwnerId = currentUser;
                           caseRecord.Previous_Close_Case_User__c = currentUser;  //currentUser; //caseRecord.OwnerId;
                        UPDATE caseRecord;
                            res.status = 'Success';
                            res.msg = 'Case successfully saved.';
                            System.debug('res--->' + res);
                        }
                    else {
                            caseRecord.Status = caseStatus;
                        caseRecord.Previous_Close_Case_User__c = currentUser; //caseRecord.OwnerId;
                            UPDATE caseRecord;
                            res.status = 'Success';
                            res.msg = 'Case successfully saved.';
                            System.debug('res--->' + res);
                    }
                }
            }
            else{
            
             List<Case> CSize = numberOfPendingCases(currentUser);
                system.debug('la taille est --> '+CSize.size());
                
                 Manage_Number_Of_Case__c numberOfCase = Manage_Number_Of_Case__c.getOrgDefaults();
                
            if((CSize.size() == numberOfCase.Number_Of_Pending_Case__c )
                && (caseRecord.Status != 'Pending' && caseStatus != 'On Hold' && caseStatus != 'Resolved')){
                    
                    if(numberOfCase.Hard_Stop__c == true){
                        res.status = 'Error';
                    res.msg = MessageUtils.ErrorMessage(userLanguage, message_14);
                    }
                    else{
                        res.status = 'warning';
                    res.msg = MessageUtils.ErrorMessage(userLanguage, message_14);
                    }
                   
                    
                }
            else {
                
            if(caseRecord.Type == null){
                    for(Case cas : [SELECT Id,AccountId,ContactId,Subject,Description, Resolution__c, Type,Comments,Status, ownerId FROM Case WHERE Id =: caseRecord.Id LIMIT 1]){
                        caseRecord = cas;
                    }
                }      
          
                System.debug('caseRecord 2--->' + caseRecord);
                Boolean isAssign = LightningComponentController.checkOwner(caseRecord.Id);
                system.debug('le case Type a gere 1 est '+caseRecord.Type);
                
             //   if(String.isNotBlank(caseRecord.Type) || caseRecord.Type != null || caseRecord.Type != 'Transfert'){
                    
                    if(isAssign == false)     {
                       
                        caseRecord.OwnerId = CurrentUser;
                        
                    }
                    System.debug('This is the expected status else--->' + caseStatus+ '   ----  '+caseRecord.Resolution__c);
                    System.debug('This is the expected status--->' + caseStatus);
                    
                    if(caseStatus == 'Resolved'){
                        //   if(String.isNotEmpty(caseRecord.Resolution__c) ||  String.isNotBlank(caseRecord.Resolution__c) || caseRecord.Resolution__c != ''){
                        caseRecord.Status = caseStatus; //'Resolved';
                        UPDATE caseRecord;
                        res.status = 'Success';
                        res.msg = 'Case successfully saved.';
                        System.debug('res--->' + res);
                        
                    }
                    else{
                          System.debug('res--->' + caseStatus);
                            if(caseStatus == 'On Hold'){
                                
                                caseRecord.Status = caseStatus; //'Resolved';
                                System.debug('status--->' + caseStatus+' -- caseRecord --'+ caseRecord);
                                UPDATE caseRecord;
                                System.debug('status--->' + caseStatus+' -- caseRecord --'+ caseRecord);
                                res.status = 'Success';
                                res.msg = 'Case successfully saved.';
                                System.debug('res--->' + res);
                            }
                        }
                        // }
                    }
             //   }
            }
            
        }catch(Exception ex){
            System.debug('exception--- ++++ >' + ex.getMessage());
            if(ex.getTypeName() == 'System.DMLException' || ex.getTypeName() == 'System.MailException'){
                res.status = 'Error';
                res.msg = ex.getDMLMessage(0);
                //   return res;
            }
        }
        return res;
    } 
    
    
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(String objectType, String selectedField){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.Resolution__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
        
    }
    
    
    
   
    private static List<Case> numberOfPendingCases(String owner){
        
        List<Case> lCases = new List<Case>();
        
        lCases = [Select id, Status from Case Where (Origin = 'Email' OR Origin = 'EIP' OR Origin = 'Phone') AND Status ='Pending' AND OwnerId = :owner];
                
              return lCases;
    }
    
    
    
    
    @AuraEnabled
    public static ResultCase GenarateRelatedCase(Case caseRecord){
        
        ResultCase res = new ResultCase();
        Map<String, Object> response;
        String userLanguage = UserInfo.getLanguage();
        String caseId, eId, eSubject, eTexte, eFromAdd, eToAdd, cOwner, cQueueEmail, ehtmlbody;
        CAse newCase;
        Boolean eAttach;
        List<ContentVersion> contentV  = new List<ContentVersion>();
        Map<Id, List<ContentVersion>> LCVersion = new Map<Id, List<ContentVersion>>();
        List<String> eamilMId = new List<String>();
        List<ContentDocumentLink> cLink = new List<ContentDocumentLink>();
        
        System.debug(' le case est '+caseRecord.Id+ ' -- '+caseRecord.Status+ '---- origin --'+caseRecord.Origin+ ' --- Previous_Close_Case_User__c  ----' +caseRecord.Previous_Close_Case_User__c);
        try{
            
             System.debug(' le new Status est '+caseRecord.Status+ ' -- le previous --.. '+caseRecord.Previous_Close_Case_User__c);
              if(caseRecord.Previous_Close_Case_User__c != null && caseRecord.Status != 'Closed'){  //} && caseRecord.Status == 'Waiting For Support')  {
                
              
                List<Case> CSize = numberOfPendingCases(caseRecord.Previous_Close_Case_User__c);
      //      system.debug('la taille est --> '+CSize.size()+ ' ---status--- ' +CSize[0].status);
           
                 Manage_Number_Of_Case__c numberOfCase = Manage_Number_Of_Case__c.getOrgDefaults();
                
                if(CSize.size() <= numberOfCase.Number_Of_Pending_Case__c ){
                system.debug('Ici --- 1 --> ');
                
               newCase = BuildRelatedCase(caseRecord);
                    
                    system.debug('le new case est '+newCase.CaseNumber+ ' --- avec --'+newCase);
                 res.status = 'Success';
                    String message = 'New related case ( '+newCase.CaseNumber+' ) has been successfully created.';
                     res.msg = message;
                    res.OpenCase = newCase.Id;
                        res.CloseCase = caseRecord.Id;
            }
                if(CSize.size() > numberOfCase.Number_Of_Pending_Case__c){
                  system.debug('Ici --- 2 --> ');
                // if(numberOfCase.Hard_Stop__c == false){
                      	newCase = BuildRelatedCase(caseRecord);
                    
                    system.debug(' -- le new related case ouvert  est ---'+newCase);
                        res.status = 'warning';
                        String m1 = MessageUtils.ErrorMessage(userLanguage, message_18);
                        String m2 = ' --- New related case ( '+newCase.CaseNumber+' ) has been successfully created.';
                        res.msg = m1+m2;
                        res.OpenCase = newCase.Id;
                        res.CloseCase = caseRecord.Id;
                     
              /*   }
                 else{
                      //	Result  result =  BuildRelatedCase(caseRecord);
                        res.status = 'Error';
                        res.msg = MessageUtils.ErrorMessage(userLanguage, message_14);
                 } */
             
            	
            }
            }
            else{
                
                 
                if(caseRecord.Status == 'Closed'){
                    res.status = 'Error';
                res.msg = 'This is closed Case, you are not autorize to generate new related Case.';
                }
                else{
                    res.status = 'Error';
                res.msg = 'You are not autorize to generate new related Case.';
                }
                
            }
        
        }catch(Exception ex){
            
               if(ex.getTypeName() == 'System.DMLException' || ex.getTypeName() == 'System.MailException'){
                res.status = 'Error';
                res.msg = ex.getDMLMessage(0);
                //   return res;
            }
        } 
        
        System.debug(' le res est '+res);
        return res;
        
    }
    
    
     public class Result{
        @AuraEnabled public string status {get;set;}
        @AuraEnabled public string msg {get;set;}
    }
    
    public class ResultCase{
        @AuraEnabled public string status {get;set;}
        @AuraEnabled public string msg {get;set;}
        @AuraEnabled public string OpenCase {get;set;}
        @AuraEnabled public string CloseCase {get;set;}
    }
    
    private static Case BuildRelatedCase(Case caseRecord){
        
        String caseId, eId, eSubject, eTexte, eFromAdd, eToAdd, cOwner, cQueueEmail, ehtmlbody;
        Boolean eAttach;
        Result res = new Result();
        List<String> eamilMId = new List<String>();
        List<Case> newCaseL = new List<Case>();
        Map<Id, List<ContentVersion>> LCVersion = new Map<Id, List<ContentVersion>>();
         List<ContentVersion> contentV  = new List<ContentVersion>();
          List<ContentDocumentLink> cLink = new List<ContentDocumentLink>();
        
                   List<EmailMessage> relatedEM = Case_GetEmailMessage.GetEmailMessage(caseRecord.Id);
        for(EmailMessage EmailMsg : relatedEM){
            
            	eId = EmailMsg.Id;
            	eAttach = EmailMsg.HasAttachment;
                eSubject = EmailMsg.Subject;
                eTexte = EmailMsg.TextBody;
                eFromAdd = EmailMsg.FromAddress;
                eToAdd = EmailMsg.ToAddress;
                ehtmlbody = EmailMsg.htmlbody;
            
            eamilMId.add(eId);

        }
            
                
             //    system.debug('etes ici --> '+CSize.size());
                
               Case newCase = new Case(
               
               RecordTypeId = caseRecord.RecordTypeId,
               accountId = caseRecord.AccountId,
               contactId = caseRecord.ContactId,
               SuppliedEmail = caseRecord.SuppliedEmail,
               ownerId = UserInfo.getUserId(), //caseRecord.Previous_Close_Case_User__c,
               Subject = eSubject,
               Description = eTexte,                 
               status = 'Pending',
               Origin = caseRecord.Origin,
               CS_MailBox__c = caseRecord.CS_MailBox__c,
               Contrat_InfoLease__c = caseRecord.Contrat_InfoLease__c,
               CustId__c = caseRecord.CustId__c,
               ParentId = caseRecord.Id,
               ActiveDirectory_Username__c = caseRecord.ActiveDirectory_Username__c,
               Created_ById__c = UserInfo.getUserId(),// caseRecord.Previous_Close_Case_User__c
               Assign_Date__c = System.Datetime.now()
                 
               );
        		//newCaseL.add(newCase);
                     Insert newCase;
        
                  system.debug(' le new case da fonction est --- '+newCase);
        
                 System.debug(' le new case Id est '+newCase.Id+ ' --- '+newCase.OwnerId +' --- '+newCase.CaseNumber );
                 System.debug(' le new case previous est '+caseRecord.Previous_Close_Case_User__c);
                
                if(newCase.Id != null){
                  Case c = [Select Id, CaseNumber, Status, OwnerId From Case where Id = :newCase.Id ];
                    newCase = c;
                  //  newCaseNumber = newCaseL.Id;
                    if(eAttach == true){
            			LCVersion = Case_GetEmailAttachment.GetEmailAttachment(eamilMId, (String)caseRecord.Id);
                        for (Id key : LCVersion.keySet()){
                			contentV=LCVersion.get(key);
            				for(ContentVersion cv : contentV){                                
                                ContentDocumentLink cDLink = new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, LinkedEntityId = newCase.Id );
                         		cLink.add(cDLink);
                        	}
                     	}
                        
                        Insert cLink;
                    }
                    
                     Case previousCase = new Case(
                      Id = caseRecord.Id,
                        status = 'Closed',
                      ownerId = caseRecord.Previous_Close_Case_User__c
                    );
                    
                       Update previousCase;
                  
                        res.status = 'Success';
                     res.msg = 'Case successfully saved.';
                    
                }
                else{
                     res.status = 'Error';
                     res.msg = 'Can not create new related Case.';
                }
        
      
        return newCase;
           }
    
    
    
}