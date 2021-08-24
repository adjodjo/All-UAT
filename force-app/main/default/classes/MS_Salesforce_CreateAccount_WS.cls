@RestResource(urlMapping='/Account/EIP/MS_Salesforce/CreateData/*')

// Create new account in Salesforce from external application
 
global class MS_Salesforce_CreateAccount_WS {
    
     @HttpPost
    global static void CreateAccount(VendorRequest vendorRequest ){
    
    System.debug('Vendor##' + vendorRequest);
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type','application/json');
        
        try{
            Account accountRecord = new Account();
            
          List<Account> duplicateAccount = [Select Id from Account where Name = :vendorRequest.LegalName.ItemValue];
            
            if(duplicateAccount.Size() == 0){
              
            
             if((vendorRequest.MDMID != null &&  ( vendorRequest.SourceSystem.Id == null || vendorRequest.SourceSystem.Id == '')) 
               || (vendorRequest.MDMID == null && ( vendorRequest.SourceSystem.Id == null || vendorRequest.SourceSystem.Id == '')) ) {
                   
                            accountRecord = VendorHelper.BuildAccountInstance(vendorRequest);
                   
                   	Database.DMLOptions dml = new Database.DMLOptions();
                    dml.DuplicateRuleHeader.AllowSave = true; 
                    Database.SaveResult sr = Database.insert(accountRecord, dml);
            
        //    Insert accountRecord;
            
          //  if(accountRecord.Id != null){
                if (sr.isSuccess()) {   
                    if ( vendorRequest.MainContact.ItemValue != null){
                        
                    if((VendorHelper.BuildContact(vendorRequest, accountRecord.Id)) != null ){
                    
                    	response.statusCode = 200;
                // Account_WS_Id accountId = VendorHelper.Build_Id_Response(accountRecord.Id);
                 		String jsonResult = JSON.serialize(accountRecord.Id);
                 		response.responseBody = Blob.valueOf( jsonResult);
                
                }
                else{
                    
                    Account_WS_Msg Err = VendorHelper.Build_Msg('Error in vendor main contact creation');
                 	String jsonResult = JSON.serialize(err);
                 	response.responseBody = Blob.valueOf( jsonResult);
                	response.statusCode = 400;
                    
                }
                }
                    else{
                        response.statusCode = 200;
                // Account_WS_Id accountId = VendorHelper.Build_Id_Response(accountRecord.Id);
                 		String jsonResult = JSON.serialize(accountRecord.Id);
                 		response.responseBody = Blob.valueOf( jsonResult);
                
                    }
            }
            else{
                
                 Account_WS_Msg Err = VendorHelper.Build_Msg('Error in vendor account creation Or Duplicate MDMID');
                 String jsonResult = JSON.serialize(err);
                 response.responseBody = Blob.valueOf( jsonResult);
                response.statusCode = 400;
            }
                
            }
            else{
                
                 Account_WS_Msg Err = VendorHelper.Build_Msg('Bad request');
                 String jsonResult = JSON.serialize(err);
                 response.responseBody = Blob.valueOf( jsonResult);
                response.statusCode = 400;
            }
            
        }
            else {
                
                Account_WS_Msg Err = VendorHelper.Build_Msg('Duplicate Account');
                 String jsonResult = JSON.serialize(err);
                 response.responseBody = Blob.valueOf( jsonResult);
                response.statusCode = 500;
            }
            

            
        }catch(Exception ex){
            String errorMessage = 'Error occured while creating new Vendor Account: ' + String.valueOf(ex);
            System.debug('errorMessage##' + errorMessage);
            Account_WS_Msg Err = VendorHelper.Build_Msg(errorMessage);
            String jsonResult = JSON.serialize(err);
            response.responseBody = Blob.valueOf( jsonResult);
            response.statusCode = 500;
        }
    }

}

/*
 
{
    "vendorRequest": {

       

        "AccountEmailAddress" : {
            "Reason": "",
            "ItemValue": "support@capone.ca",
            "IsValid": true,
            "RollbackValue":"",
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
            "ItemValue": "Michael Paul",
            "IsValid": true,
            "RollbackValue": null,
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
            "ItemValue":"1899999999",
            "IsValid": true,
            "RollbackValue":null,
            "RollbackExist": false
        },
        "Phone": {
            "Reason": "Illegale phone number",
            "ItemValue": "(237) 245-1111",
            "IsValid": true,
            "RollbackValue":null,
            "RollbackExist": false
        },
        "WebsiteUrl": {
            "Reason": "",
            "ItemValue": "www.capone.ca",
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
 "ShippingCountry": {
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
            "ItemValue": "QC",
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
            "ItemValue": "1111 salabery Est",
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
            "ItemValue": "CAPONE",
            "IsValid": true,
            "RollbackValue":null,
            "RollbackExist": false
        },
        "LegalName": {
            "Reason": "",
            "ItemValue": "CAPONE INC.",
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
            "Id": "",
            "SystemType": "3"
        },
        "YearEstablished": {
            "Reason": "",
            "ItemValue": "2001",
            "IsValid": true,
            "RollbackValue":null,
            "RollbackExist": false
        }
    }
}

*/