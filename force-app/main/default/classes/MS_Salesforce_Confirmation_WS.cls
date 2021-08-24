@RestResource(urlMapping='/Log_Confirmation__c/*')

global class MS_Salesforce_Confirmation_WS {
    
     @HttpPost
    global static void GetConfirmation(ConfirmationRequest ConfirmationRequest){
        
         System.debug('ConfirmationRequest##' + ConfirmationRequest);
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type','application/json');
        
        try{
            
            if(String.isNotBlank(ConfirmationRequest.SystemId) || String.isNotEmpty(ConfirmationRequest.SystemId)){
                
                // Save the confirmation informations in Log Confirmation object
                Log_Confirmation__c lConfirmation = new Log_Confirmation__c();
                
                lConfirmation.Related_To_Account__c = ConfirmationRequest.SystemId;
                lConfirmation.Error_Message__c = ConfirmationRequest.ErrorMessage;
                lConfirmation.Requested_Action__c = ConfirmationRequest.RequestedAction;
                lConfirmation.Resource_Name__c = ConfirmationRequest.ResourceName;
                lConfirmation.Succeeded__c = ConfirmationRequest.Succeeded;
                lConfirmation.System_Source__c =   ConfirmationRequest.SystemSource;  
                
                Insert lConfirmation;
                
             //   If(ConfirmationRequest.Succeeded == true){
                    String SVal;
                    Account accountRecord = new Account();
                    accountRecord.Id = ConfirmationRequest.SystemId;
                
                system.debug('--- accountRecord.Id --'+ ConfirmationRequest.SystemId);
                    
                    if(lConfirmation.Succeeded__c == true) SVal = 'Successful';
                    if(lConfirmation.Succeeded__c == false) SVal = 'Missing';
                    
                    accountRecord.Last_Requested_Status__c = SVal+' '+lConfirmation.Requested_Action__c+' - '+ Datetime.Now().format();
                    
                system.debug('--- confirmation --'+ accountRecord);
                    Update accountRecord;
                system.debug('--- confirmation --'+ accountRecord.Id);
              //  }
                
                response.statusCode = 200;
                
                
            }
            else{
                response.statusCode = 400;
            }
         
        }catch(Exception ex){
            
             response.statusCode = 500;
          
        }
       
    }
}
        
        
        /*
        for(  account acc : [Select Id, Name  From Account where id = :ConfirmationRequest.SystemId limit 1]){
            
            if(ConfirmationRequest.Succeeded == false){ 
                
             res.status = 'Error';
             res.RequestedAction = ConfirmationRequest.RequestedAction;
             res.msg = ConfirmationRequest.ErrorMessage;
             res.AccountName = acc.Name;
            
        }
        else{
            
            res.status = 'Success';
            res.RequestedAction = ConfirmationRequest.RequestedAction;
            res.msg = ConfirmationRequest.ErrorMessage;
            res.AccountName = acc.Name;
            
        }
        }
        
        
        
        
    }
    
    
    public class Result{
        @AuraEnabled public string status {get;set;}
        @AuraEnabled public string msg {get;set;}
        @AuraEnabled public String RequestedAction {get;set;}
        @AuraEnabled public String ResourceName {get;set;}
        @AuraEnabled public String AccountName {get;set;}
    }

}

/*
 {
    "ConfirmationRequest": {
        "ResourceName": "Vendor",
        "SystemId": "001Z000001W4Qv9IAF",
        "SystemSource": "Salesforce",
        "RequestedAction": "Update",
        "ErrorMessage": "",
        "Succeeded": true
    }
}


*/