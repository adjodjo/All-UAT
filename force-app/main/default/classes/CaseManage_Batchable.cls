/*
 Batch to update unclosed case case to assign to Chantal Ducet
 */
global class CaseManage_Batchable implements Database.Batchable<sObject>, Database.Stateful{
    
    global Map<String, List<Id>> idsFailedToUpdateByErrorMessage = new Map<String, List<Id>>();
    
    global final String Query;
    global final String recipient;
    global Integer recordCount = 0;
    global Date cDate;
    global  List<String> queueId = new List<String>();
    
    global CaseManage_Batchable(Schema.DescribeSObjectResult o, String createDate, String recipient){
        
        
        
        for(Group g : [select Id from Group where type = 'queue']){ // and DeveloperName = 'CS_Queue'
            
            queueId.add(g.Id);
        }
        system.debug('queueId ---  '+queueId);
        
        cDate = date.valueOf(createDate);
        
        this.query = 'Select Id, Status, Type, OwnerId, CreatedDate  FROM ' + o.getName() + ' WHERE Status != \'Closed \' AND ClosedDate = null  AND DAY_ONLY(CreatedDate) < :cDate '  ; //AND OwnerId IN :queueId
        this.recipient = recipient;
        system.debug('query ---  '+query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<Case> caseToUpdate = (List<Case>)scope;
        List<Case> cases = new List<Case>();
        String userId;
        Manage_Owner_Closed_Case__c getClosedUser = Manage_Owner_Closed_Case__c.getOrgDefaults();
        If(getClosedUser.Enable_User__c == true){
            for(User u : [select Id from User where username = :getClosedUser.User_UserName__c]){
                userId = u.Id;
            }
            string caseId, caseType;
            for(Case c : caseToUpdate){
                if(c.Type == null){
                    caseType = 'Other';
                }
                else caseType = c.Type;
                Case closeCase = new Case(Id = c.Id, Status='Closed', Type = caseType, OwnerId = userId);
                cases.add(closeCase);
            }
        system.debug('cases ---  '+cases);
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
                        
//Database.SaveResult sr = Database.insert(closeCase, dml);
        
        recordCount += scope.size();
        
        for(Database.SaveResult sr : Database.update(cases, dml)) {
         if (!sr.IsSuccess()) {
                for(Database.Error err : sr.getErrors()) {                    
                    if (!idsFailedToUpdateByErrorMessage.containsKey(err.getMessage())) {
                        idsFailedToUpdateByErrorMessage.put(err.getMessage(), new List<Id>());
                    }
                    
                    idsFailedToUpdateByErrorMessage.get(err.getMessage()).add(scope[0].Id);
                }
            }
        }
    }
        
    }
    
    
    global void finish(Database.BatchableContext BC){
        
        String body = '';
        
        body += 'Applied to ' + recordCount + ' records.\n';
        if (idsFailedToUpdateByErrorMessage.size() > 0) {
            body += 'Failed to update the following records:\n\n';
            
            for(String errorMessage : idsFailedToUpdateByErrorMessage.keySet()) {
	            body += 'Error: ' + errorMessage + '\n';
                body += String.join(idsFailedToUpdateByErrorMessage.get(errorMessage), '\n') + '\n';
            }
        }
        
        System.debug(body);
        
        if (this.recipient != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(new String[] {this.recipient});
            mail.setReplyTo('noreply@hitachicapitalamerica.com');
            mail.setSenderDisplayName('Apex Batch Processing');
            mail.setSubject('CaseManage_Batchable Completed');
            mail.setPlainTextBody(body);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        
    }

}