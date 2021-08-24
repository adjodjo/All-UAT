public class LightningComponentController {
    
    static final String message_14 = 'message_14';
    static final String message_15 = 'message_15';
    static final String message_16 = 'message_16';
    static final String message_18 = 'message_18';
    
    @AuraEnabled
    public static Case getCaseRecord(String recordId){
        Case caseRec;
        system.debug('recordId --'+recordId);       
        for(Case cas : [SELECT Id,AccountId,ContactId,Subject,Description, Resolution__c, Type,Comments,Status, ownerId FROM Case WHERE Id =: recordId LIMIT 1]){
            caseRec = cas;
        }
        System.debug('caseRec de lightning--->' + caseRec);
        return caseRec;
    }
    
    @AuraEnabled
    public static String BuildLink() { // Method to check of environement is Production ORG or not
        String InstanceInfo = null;
      
        InstanceInfo = ParametersUtils.BuildEIPLink();
        return  InstanceInfo;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // 
    public static Boolean checkOwner(String caseId){
        
        Boolean isQueue = false;
        
        List<Case> getCase = [SELECT OwnerId FROM CASE WHERE Id = :caseId];
        List<String> i = new List<String>();
        
        for( Case c : getCase){            
            i.add(c.OwnerId);
        }
        
        List<Group> getGroup = [SELECT Id, Name FROM Group where Id IN :i AND Type = 'Queue' ];
         system.debug('la liste des elt du groupe = '+ getGroup.size());
        if(getGroup.size() <= 0){
            isQueue = True;
        }
        system.debug('isQueue = '+ isQueue);
        return  isQueue;
    }
    
    ///////////////////////////////////////////////////////////////////////////////////// 
    // Assign Case to connect owner
    // 
    @AuraEnabled
    public static String AssignCaseToMe(String caseId, String sObjectN, String cStatuts){
        
         Result res = new Result();
        String userLanguage = UserInfo.getLanguage();
        String currentUser = UserInfo.getUserId();
        String currentUserN = UserInfo.getName();
        system.debug('le currentUserN = '+currentUserN);
        String cId,cCont, cAcc, cType, errMsg=null, owner, cStatus;
        
        try{
            If(sObjectN == 'Case'){
                List<Case> myCase = new List<Case>();
                List<Case> getCase = [SELECT Id, OwnerId, Description, Origin,AccountId, ContactId, Type, Status FROM CASE WHERE Id = :caseId];
                system.debug('le case getCase = '+getCase);
                
                for(Case c : getCase){
                    
                    owner = c.OwnerId;
                    cId = c.Id;
                    cType = c.Type;
                    cAcc = c.AccountId;
                    cCont = c.ContactId;
                    
                    //String des = c.Description + ' '+currentUser;
                    myCase.add(new Case (Id = cId, OwnerId = currentUser, Status = cStatuts));
                    system.debug('case to update '+myCase);
                }
               
                
                List<Case> CSize = numberOfPendingCases(currentUser);
                 Manage_Number_Of_Case__c numberOfCase = Manage_Number_Of_Case__c.getOrgDefaults();
                
                if(CSize.size() >= numberOfCase.Number_Of_Pending_Case__c && numberOfCase.Hard_Stop__c == true)
               {   
                   errMsg = 'message_14';
                //   res.status = 'Error';
                //   res.msg = MessageUtils.ErrorMessage(userLanguage, message_14);
                  
                }
                else if(CSize.size() >= numberOfCase.Number_Of_Pending_Case__c && numberOfCase.Hard_Stop__c == false){
                    
                    Update myCase;
                    
                /*    List<Task> myTask = new List<Task>();
                    //List<User> LUser = [Select id, Name from User where Name = 'Katie Mullin'];
                    List<Task> LTask = [Select Id, OwnerId From Task where 	WhatId = :caseId ];
                    //system.debug('List user '+LUser+' list tasck = '+LTask);
                    
                    for(Task t : LTask){
                        String tId = t.Id;
                        
                        myTask.add(new Task(Id = tId, OwnerId = currentUser));
                    }
                    update myTask;*/
                     errMsg = 'message_18';
                  //  res.status = 'warning';
                 //  res.msg = MessageUtils.ErrorMessage(userLanguage, message_18);
                    
                }
                else {// MAJOwner(caseId, 'Pending');
                    Update myCase;
                    
                /*    List<Task> myTask = new List<Task>();
                    //List<User> LUser = [Select id, Name from User where Name = 'Katie Mullin'];
                    List<Task> LTask = [Select Id, OwnerId From Task where 	WhatId = :caseId ];
                    //system.debug('List user '+LUser+' list tasck = '+LTask);
                    
                    for(Task t : LTask){
                        String tId = t.Id;
                        
                        myTask.add(new Task(Id = tId, OwnerId = currentUser));
                    }
                    update myTask;*/
                    
                    // system.debug('Task Id '+myTask[0].Id);
                }
            }
            
            system.debug(currentUser+' '+currentUserN);
        }
        catch(Exception ex){
              system.debug('Exception --- '+ex.getMessage());
            If (ex.getMessage() != null){
                 errMsg = 'message_16';
              
               // res.status = 'warning';
                //   res.msg = MessageUtils.ErrorMessage(userLanguage, message_16);
            }
        }
        String t = JSON.serialize(new LightningCaseCustomResponse(null, null,null, null, errMsg));
        system.debug('le string est '+t);
        return errMsg;
    }
    
    
    @AuraEnabled
    public static String CreateNewTask(String caseId){
        
        List<Case> myCase = new List<Case>();
        List<Task> myTask = new List<Task>();
        
        String owner, sujet, taskId;       
        Date dueDate;
        
        try{        
            List<Case> getCase = [SELECT Id, OwnerId, Subject,Expiry_Date__c, EIP_Exception__c, Description FROM CASE WHERE Id = :caseId limit 1];
            
            if(getCase.size() > 0){
                
                for(Case c : getCase){
                    owner = c.OwnerId;
                    sujet = c.Subject;
                    dueDate = c.Expiry_Date__c;
                    
                }
                
                List<Task> taskCase = [select Id, WhatId From Task  where WhatId = :caseId];
                
                if(taskCase.size() <= 0){
                    
                    Task task = new Task(
                        OwnerId = owner
                        , ActivityDate = dueDate
                        , WhatId = caseId
                        , Subject = sujet
                        , TaskSubtype = 'Task'
                        , Status = 'Not Started'
                        , Priority = 'Normal'
                    );
                    
                    Upsert task;
                    taskId = task.Id;
                    
                }
                else  taskId = null;
            }
            else taskId = null;
            
            return taskId;
        }
        catch(Exception ex){
            
            return ex.getMessage();
        }
    }
    
    //////////////////////
    //
    
    @future
    public static void MAJOwner(String caseId, String status){
        
        Boolean etat =null;  
        String cId, cType, errMsg, cResolution;
        String currentUser = UserInfo.getUserId();
        String currentUserN = UserInfo.getName();
        system.debug('le currentUserN = '+currentUserN);
        try{
            List<Case> myCase = new List<Case>();
            List<Case> getCase = [SELECT Id, OwnerId, Description, Type, Resolution__c FROM CASE WHERE Id = :caseId];
            system.debug('le case getCase = '+getCase);
            
            for(Case c : getCase){
                
                cId = c.Id;
                cType = c.Type;
                cResolution = c.Resolution__c;
                
            }
            
            myCase.add(new Case (Id = cId, OwnerId = currentUser, Status = status));   //, Status = 'Pending'  , Resolution__c = cResolution
            system.debug('case to update '+myCase);
            Update myCase;
            if(caseId != null){
                CreateNewTask(caseId);
            }
            
            
            
        }catch(Exception ex){
            errMsg = ex.getMessage();
            
        }
        
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Managed case status
    
    @AuraEnabled
    public static String VerifierCaseStatus( Case caseRecord){  //  String caseId){  //LightningCustomResponse
        
        String userLanguage = UserInfo.getLanguage();
        String currentUser = UserInfo.getUserId();
        String currentUserN = UserInfo.getName();
        String owner, cId, status, taskId, etat, gType, grpType, gDName, gOrigin, gCust, gInfolease, errMsg, gCont, gAcc, gContract=null ;       
        Date dueDate;
        String sObjectN = null;
        try{
          //  List<Case> getCase = [SELECT Id, OwnerId, Status, contactId, AccountId, Expiry_Date__c, EIP_Exception__c, Description, Origin, Type, CustId__c, Contrat_InfoLease__c 
           //                       FROM CASE WHERE Id = :caseRecord.Id limit 1];
        //   system.debug('le getCase est '+getCase);
       //     if(getCase.size() > 0){
                
                for(Case c : [SELECT Id, OwnerId, Status, contactId, AccountId, Expiry_Date__c, EIP_Exception__c, Description, Origin, Type, CustId__c, Contrat_InfoLease__c 
                                  FROM CASE WHERE Id = :caseRecord.Id limit 1]){
                    cId = c.Id;
                    owner = c.OwnerId;
                    status = c.Status;
                    dueDate = c.Expiry_Date__c;
                    gOrigin = c.Origin;
                    gType = c.Type;
                    gCont = c.ContactId;
                    gAcc = c.AccountId;
                    gCust = c.CustId__c;
                    gInfolease = c.Contrat_InfoLease__c;
                    
                }
          //  }
            
            List<Case> CSize = numberOfPendingCases(currentUser);
            system.debug('la taille est --> '+CSize.size());
           
            Manage_Number_Of_Case__c numberOfCase = Manage_Number_Of_Case__c.getOrgDefaults();
                
            if((CSize.size() > numberOfCase.Number_Of_Pending_Case__c &&  numberOfCase.Hard_Stop__c == true)
               && status != 'Pending'){
                errMsg = MessageUtils.ErrorMessage(userLanguage, message_14);
            }
            else {
                
                Boolean isAssign = checkOwner(caseRecord.Id);
                system.debug('isAssign = '+ isAssign);
                
                if(isAssign == false)     {
                    
                    MAJOwner(caseRecord.Id, 'Pending');
                    system.debug('le status est '+status);
                    
                }
                
                system.debug('do somthing = '+caseRecord.Id+ 'sObjectN '+sObjectN + ' gType '+gType );
                
                if( String.isNotBlank(gInfolease)){
                    
                    gContract = gInfolease;
                }
                else if( String.isNotBlank(gCust)){ 
                    
                    gContract = gCust;                    
                }
                
              //  List<Group> getGroup = [select id, type, DeveloperName, name from group where Id = :owner limit 1];
                
                for(Group g : [select id, type, DeveloperName, name from group where Id = :owner limit 1]){
                    
                    grpType = g.type;
                    gDName = g.DeveloperName;
                    
                }
                if(grpType == 'Queue' ){
                    etat = 'Pending';
                }
                else if( status == 'Closed'){  //gOrigin == 'EIP' &&
                    etat = status;
                }                
                else{
                                                                                                         
                    caseRecord.Status = 'Pending';
                    etat = caseRecord.Status;        
                    Upsert caseRecord;
                }
            }
            
        }catch(Exception ex){
            
            If (ex.getMessage() != null){
                
                errMsg = ex.getMessage(); //'There are some missing information or you have more than one assigned Case in your personal queue';
            }
        }
        system.debug('le gOrigin est '+gOrigin);
        String t = JSON.serialize(new LightningCaseCustomResponse(etat, gOrigin,gContract, gAcc, errMsg));
        system.debug('le string est '+t);
        return t; //new LightningCustomResponse(etat, gOrigin );//etat;   
    }
    
    
    // Select Case with Case origine as Email or EIP to manage pending Case in personnal queue
    private static List<Case> numberOfPendingCases(String owner){
        
        List<Case> lCases = [Select id from Case Where (Origin = 'Email' OR Origin = 'EIP'OR Origin = 'Phone') AND Status ='Pending' AND OwnerId = :owner];
        
        return lCases;
    }
    
     public class Result{
        @AuraEnabled public string status {get;set;}
        @AuraEnabled public string msg {get;set;}
    }
    
}