/**
 * Mass update all the records that contains a phone field within an object
 * 
 * IMPORTANT: This batch must be executed in batch of 1 record at a time.
 * 
 * Example of usage:
 * 
 * 1) Accounts of record type Vendor:
 * 		Database.executeBatch(new PhoneSanitizer_Batchable(Schema.SObjectType.Account, 'RecordType.Name = \'Vendor\'', 'mbeausoleil@clecapital.ca'), 1);
 * 2) Contacts
 * 		Database.executeBatch(new PhoneSanitizer_Batchable(Schema.SObjectType.Contact, null, 'mbeausoleil@clecapital.ca'), 1);
 */
global class PhoneSanitizer_Batchable implements Database.Batchable<sObject>, Database.Stateful {
    global Integer recordCount = 0;
    global Map<String, List<Id>> idsFailedToUpdateByErrorMessage = new Map<String, List<Id>>();
    
    global final List<Schema.SObjectField> objectPhoneFields;
    global final String Query;
    global final String recipient;
    
    global PhoneSanitizer_Batchable(Schema.DescribeSObjectResult o, String additionalWhereClause, String recipient){
        //Id batchInstanceId = Database.executeBatch(new PhoneSanitizer_Batchable(), 1000); 
        //
        
        List<String> phoneFields = new List<String>();
        List<String> whereClauses = new List<String>();
        
        for(Schema.SObjectField phoneField : Phone_Utility.getObjectPhoneFields(o)) {
            String fieldName = (String)phoneField.getDescribe().getName();
            phoneFields.add(fieldName);
            
            whereClauses.add(fieldName + ' != null');
        }
        
        this.query = 'Select Id, ' + String.join(phoneFields, ',') + ' FROM ' + o.getName() + ' WHERE ' + (additionalWhereClause != null ? additionalWhereClause + ' AND (' : '') + String.join(whereClauses, ' OR ') + (additionalWhereClause != null ? ')' : '');
        this.recipient = recipient;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
        recordCount += scope.size();
        
        for(Database.SaveResult sr : Database.update(scope, dml)) {
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
            mail.setSubject('PhoneSanitizer_Batchable Completed');
            mail.setPlainTextBody(body);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}