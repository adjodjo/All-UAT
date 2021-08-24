//@RestResource(urlMapping='/Account/EIP/Dispatcher/*')

// Call external WS that will come and get Account information for 3 party application


global class DispatcherAccountCallout_WS {
    
    @future(callout=true)
    global static void DispatcherAccountCallout(String accId, String operation) {
        
        String SVal;
        List<Account> accountRecord = new List<Account>();
        String endPoint;
        try{
            String jsonCallout = JSON.serialize(new DispatcherCalloutParameter(accId));
            System.debug('Le JSON est:' + jsonCallout);
            
             System.debug('Le accId est:' + accId+ ' --- operation --'+operation);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            If(operation == 'Insert') {
                endPoint = ParametersUtils.BuildSFDCMicroServiceEndPoint()+'gateway/rest/Vendor/create/'+accId;
                request.setMethod('POST');
            }
            	
            else {
                endPoint = ParametersUtils.BuildSFDCMicroServiceEndPoint()+'gateway/rest/Vendor/update/'+accId;
                System.debug(' le endpoint pour update est --'+endPoint);
                request.setMethod('PUT');
            }
                
            
            request.setEndpoint(endPoint);            
            request.setHeader('Content-Length', '4096');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            
            // Set the body as a JSON object
            request.setBody(jsonCallout);
            
            HttpResponse response = http.send(request);
            System.debug('la réponse est:' + response);
            System.debug('la code de reponse est:' + response.getStatusCode());
            System.debug('la status de reponse est:' + response.getStatus());
            // Parse the JSON response
            if ( response.getStatusCode() != 200) {
                
                Log_Confirmation__c lConfoirmation = new Log_Confirmation__c();
                
                lConfoirmation.Related_To_Account__c = accId;
                lConfoirmation.Error_Message__c = response.getStatusCode()+' -- '+response.getStatus();
                lConfoirmation.Requested_Action__c = 'Create';
                lConfoirmation.Resource_Name__c = 'Vendor';
                lConfoirmation.Succeeded__c = false;
                lConfoirmation.System_Source__c =   'Salesforce';  
                
                Insert lConfoirmation;
                
                if(lConfoirmation.Succeeded__c == true) SVal = 'Successful';
                if(lConfoirmation.Succeeded__c == false) SVal = 'Missing';
                
                //accountRecord = null;
                for(Account c : [Select Id, Last_Requested_Status__c from Account where Id = :accId]){
                    
                    c.Last_Requested_Status__c = SVal +' '+ lConfoirmation.Requested_Action__c;
                    accountRecord.add(c);
                }
                
                Update accountRecord;
            } 
            
            //  return callout_Msg;
        }catch(Exception ex){
            
            Log_Confirmation__c lConfirmation = new Log_Confirmation__c();
            
            lConfirmation.Related_To_Account__c = accId;
            lConfirmation.Error_Message__c = Ex.getMessage();
            lConfirmation.Requested_Action__c = 'Create';
            lConfirmation.Resource_Name__c = 'Vendor';
            lConfirmation.Succeeded__c = false;
            lConfirmation.System_Source__c =   'Salesforce';  
            
            Insert lConfirmation;
            
            if(lConfirmation.Succeeded__c == true) SVal = 'Successful';
            if(lConfirmation.Succeeded__c == false) SVal = 'Missing';
            
            //accountRecord = null;
            for(Account c : [Select Id, Last_Requested_Status__c from Account where Id = :accId]){
                
                c.Last_Requested_Status__c = SVal +' '+ lConfirmation.Requested_Action__c;
                accountRecord.add(c);
            }
            System.debug('la liste acc est:' + accountRecord);
            Update accountRecord;
            
            
            
        }
    }
    
    
    
    
    
    
    
}