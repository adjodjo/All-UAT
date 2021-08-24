public class ExportExternalDataController {
    
    @AuraEnabled
    public static List<ExternalDataWrapper> getExternalApplicationData(){
        List<ExternalDataWrapper> externalList = new List<ExternalDataWrapper>();
       
        externalList.add(new ExternalDataWrapper('Vision','Vision'));
        externalList.add(new ExternalDataWrapper('Location','Location'));
        return externalList;
    }
    
    @AuraEnabled
    public static ResultData getDataFromExternalApp(String recordId,String applicationId){
        System.debug('recordId##' + recordId);
        System.debug('appEndPoint##' + applicationId);
        ResultData result = new ResultData();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endPoint = ParametersUtils.BuildExportMicroServiceEndPoint()+'gateway/rest/Vendor/export/'+ recordId +'/origination/' + applicationId;
        
        System.debug('appEndPoint  ##' + endPoint);
      //  /gateway/rest/Vendor/export/{vendorId}/origination/{originationSystem}
        request.setEndpoint(endPoint);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Content-Length', '4096');
        try{
            HttpResponse response = http.send(request);
            System.debug('response##' + response);
            if (response.getStatusCode() != 200) {
                result.status = 'Error';
                result.message = 'Something went wrong.';
            }
           else{
               
                result.status = 'Success';
                result.message = 'Exportation requested.';
               
       //        System.debug('response body##' + response.getBody());
      //         ConfirmationRequest confirmRequest = (ConfirmationRequest)JSON.deserialize(response.getBody(), ConfirmationRequest.class);
       //         System.debug('confirmRequest##' + confirmRequest);
       //         if(confirmRequest != null){
                    Log_Confirmation__c lConfirmation = new Log_Confirmation__c();
                    lConfirmation.Related_To_Account__c = recordId; //confirmRequest.SystemId;
                    lConfirmation.Related_To_Contact__c = null;     
                    lConfirmation.Error_Message__c = 'Exportation requested'; // confirmRequest.ErrorMessage;
                    lConfirmation.Requested_Action__c = 'Export'; //confirmRequest.RequestedAction;
                    lConfirmation.Resource_Name__c  = 'Vendor'; // confirmRequest.ResourceName;
                    lConfirmation.Succeeded__c = true; //confirmRequest.Succeeded;
                    lConfirmation.System_Source__c =  applicationId;  // confirmRequest.SystemSource;  
                    //INSERT lConfirmation;
                    result.status = 'Success';
                 result.message = 'Exportation requested.';
               
                //    result.message = 'Successfully data exported.';
                //      }else{
                //         result.status = 'Error';
                //         result.message = 'No data found.';
                //    }*/
            }
        }catch(Exception ex){
            System.debug('exception##' + ex.getMessage());
            result.status = 'Error';
            result.message = String.valueOf(ex);
        }
        return result;
    }
    public class ExternalDataWrapper{
        @AuraEnabled public String applicationName {get;set;}
        @AuraEnabled public String applicationId {get;set;}
        public ExternalDataWrapper(String applicationId,String applicationName){
            this.applicationName = applicationName;
            this.applicationId = applicationId;
        }
    }
    public class ResultData{
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String message {get;set;}
        
    }
}