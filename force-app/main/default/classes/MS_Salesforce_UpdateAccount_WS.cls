@RestResource(urlMapping='/Account/EIP/MS_Salesforce/UpdateData/*')

// Update account in Salesforce

global class MS_Salesforce_UpdateAccount_WS {
    
    @HttpPut
    global static void UpdateAccount(VendorRequest vendorRequest ){ //, IVendor ivendor){  String AccountId, 
        // System.debug('AccountId##' + AccountId);
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type','application/json');
        
        String SVal;
        
        List<String> contactList = new List<String>();
        
        try{
            Account accountRecord;
            System.debug('vendorRequest cuntry##' + vendorRequest.ShippingCountry);
           
            if(String.isNotBlank(vendorRequest.SourceSystem.Id)  || String.isNotEmpty(vendorRequest.SourceSystem.Id)){
                
                for(Account acct : [SELECT Id,Name,MDM_ID__c,Phone,Compagnie_Email__c,BillingStreet,BillingCity,BillingState,BillingPostalCode, 
                                    BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,Fax,
                                    Toll_Free_Phone__c, OwnerId,Doing_Business_As__c, In_Business_Since__c //, ShippingProvinceCode__c, ShippingCountryCode__c, BillingProvinceCode__c, BillingCountryCode__c, AccountManager__c 
                                    
                                    FROM Account WHERE Id = :vendorRequest.SourceSystem.Id  LIMIT 1]){
                                        accountRecord = acct;   
                                    }
                System.debug('accountRecord##' + accountRecord);
                System.debug('shipping country##' + accountRecord.ShippingCountry);
                System.debug('Vendor##' + vendorRequest.Fax);
                System.debug('Vendor##1 ' + String.valueOf(vendorRequest.MDMID) + '  Vendor##1 ' +accountRecord.MDM_ID__c);
                
               // if(accountRecord != null && (accountRecord.MDM_ID__c == String.valueOf(vendorRequest.MDMID) || accountRecord.MDM_ID__c == null || accountRecord.MDM_ID__c == '0')){
                   
                if(accountRecord != null){ // && (accountRecord.MDM_ID__c == String.valueOf(vendorRequest.MDMID) || accountRecord.MDM_ID__c == null || accountRecord.MDM_ID__c == '0')){
                    
                    System.debug('Vendor## ' + String.valueOf(vendorRequest.MDMID) + 'Vendor## ' +accountRecord.MDM_ID__c+ 'le main contact est '+vendorRequest.MainContact.RollbackValue);
                   
                    if(   String.isNotEmpty(vendorRequest.MainContact.RollbackValue)                   //vendorRequest.MainContact.ItemValue != null //|| vendorRequest.MainContact.RollbackValue != null   || String.isNotEmpty(vendorRequest.MainContact.RollbackValue) 
                       || String.isNotEmpty(vendorRequest.MainContact.ItemValue))   
                        VendorHelper.BuildContact(vendorRequest, vendorRequest.SourceSystem.Id);
                    
                    System.debug('vendorRequestendor to update ## ' + vendorRequest+ ' le main contct '+ vendorRequest.MainContact.RollbackValue);
                    accountRecord = VendorHelper.BuildUpdateAccountInstance(vendorRequest);
                    
                    accountRecord.Id = vendorRequest.SourceSystem.Id; //DestinationSystems[0].Id;
                    
                    System.debug('vendor  to updated ## ' + accountRecord);
                    
                    if(accountRecord != null){
                        
                        Database.DMLOptions dml = new Database.DMLOptions();
                        dml.DuplicateRuleHeader.AllowSave = true; 
                        Database.SaveResult sr = Database.Update(accountRecord, dml);
                        
                        if (sr.isSuccess())    {
                            response.statusCode = 200;
                        }
                        else{
                            
                            Database.Error[] errs = sr.getErrors();
				for(Database.Error err : errs)
					System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                            
                            
                            
                            System.debug('ICI## 3 ' + String.valueOf(vendorRequest.MDMID) );
                            response.statusCode = 400;
                            //  Account_WS_Msg Err = VendorHelper.Build_Msg('Missing account Id');
                            Account_WS_Msg Err = VendorHelper.Build_Msg('Missing account Id');
                            String jsonResult = JSON.serialize(err);
                            System.debug('ICI## 3 ' + jsonResult);
                            response.responseBody = Blob.valueOf(jsonResult);
                        }
                        
                    }
                    else{
                        System.debug('ICI## 3 ' + String.valueOf(vendorRequest.MDMID) );
                        response.statusCode = 400;
                        //  Account_WS_Msg Err = VendorHelper.Build_Msg('Missing account Id');
                        Account_WS_Msg Err = VendorHelper.Build_Msg('Missing account');
                        String jsonResult = JSON.serialize(err);
                        System.debug('ICI## 3 ' + jsonResult);
                        response.responseBody = Blob.valueOf(jsonResult);
                    }
                    
                }
                else{
                    System.debug('ICI## 3 ' + String.valueOf(vendorRequest.MDMID) );
                    response.statusCode = 400;
                    //  Account_WS_Msg Err = VendorHelper.Build_Msg('Missing account Id');
                    Account_WS_Msg Err = VendorHelper.Build_Msg('Missing account Id');
                    String jsonResult = JSON.serialize(err);
                    System.debug('ICI## 3 ' + jsonResult);
                    response.responseBody = Blob.valueOf(jsonResult);
                    
                }
                
                
            }
            else{
                System.debug('ICI## 3 ' + String.valueOf(vendorRequest.MDMID) );
                response.statusCode = 400;
                //  Account_WS_Msg Err = VendorHelper.Build_Msg('Missing account Id');
                Account_WS_Msg Err = VendorHelper.Build_Msg('Can not update Account');
                String jsonResult = JSON.serialize(err);
                System.debug('ICI## 3 ' + jsonResult);
                response.responseBody = Blob.valueOf(jsonResult);
                
            }
        }catch(Exception ex){
            String errorMessage = 'Error occured while updating vendor Account: ' + String.valueOf(ex);
            System.debug('errorMessage##' + errorMessage);
            Account_WS_Msg Err = VendorHelper.Build_Msg(errorMessage);
            String jsonResult = JSON.serialize(err);
            response.responseBody = Blob.valueOf(jsonResult);
            response.statusCode = 500;
        }
        
    }
}

/*


{
"vendorRequest": {

"MDMID": 0,

"AccountEmailAddress" : {
"Reason": "",
"ItemValue": "totot@test4.ca",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false

},
"AccountManager": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"MainContact": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"TollFreePhone": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"Fax": {
"Reason": "",
"ItemValue":"18009995566",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"Phone": {
"Reason": "",
"ItemValue": "(525) 278-2900",
"IsValid": false,
"RollbackValue":null,
"RollbackExist": false
},
"WebsiteUrl": {
"Reason": "",
"ItemValue": "www.totot.ca",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"ShippingStreet": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"ShippingProvince": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"ShippingProvinceCode": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"ShippingPostalCode": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"ShippingCountry": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"ShippingCountryCode": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"ShippingCity": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"BillingStreet": {
"Reason": "",
"ItemValue": "2990 salabery Est",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"BillingProvince": {
"Reason": "",
"ItemValue": "QC",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"BillingProvinceCode": {
"Reason": "",
"ItemValue": "QC",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"BillingPostalCode": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"BillingCountry": {
"Reason": "",
"ItemValue": "Canada",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"BillingCountryCode": {
"Reason": "",
"ItemValue": "CA",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"BillingCity": {
"Reason": "",
"ItemValue": "Montreal",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"BusinessName" : {
"Reason": "",
"ItemValue": "TOTOT",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"LegalName": {
"Reason": "",
"ItemValue": "TOTOT LTD.",
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
},
"DestinationSystems" : [
{
"Id": "V12365",
"SystemType": "4"
}
],
"SourceSystem" : {
"Id": "001Z000001W9kohIAB",
"SystemType": "3"
},
"YearEstablished": {
"Reason": "",
"ItemValue": null,
"IsValid": true,
"RollbackValue":null,
"RollbackExist": false
}
}
}


*/