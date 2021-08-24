@RestResource(urlMapping='/Account/EIP/MS_Salesforce/Detailes/*')

// WS to create new Account

global with sharing class MS_Salesforce_GetAccount_WS {
    
     @HttpGet
        global static void GetAccountById(){
            
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
            response.addHeader('Content-Type','application/json');
            
            String contactid = null, PrincipalContact = null;
            
            try
        {
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
		if(accountId != '' )
        {
            // Get relationship between account and contact
            for (accountContactRelation accRelation : [select Id, contactId, accountId From AccountContactRelation where accountId = :accountId AND Is_Primary__c = true limit 1]){
                if(String.isNotBlank(accRelation.contactId)){
                    contactid = accRelation.contactId; // Get the contact Id
                }
                
            }
            if(contactid != null ){
                // Get primary contact Name
                for ( contact c : [select id, Name From Contact where accountId = :accountId and Id = :contactid]){
                    PrincipalContact = c.Name;
                }
            }
            
            // Get account informations
            List<Account> accounts = [Select Id, Name, 	MDM_ID__c, Phone, Compagnie_Email__c,  BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
                                      ShippingStreet, ShippingCity, website, ShippingState, ShippingCountry, ShippingPostalCode, Fax, OwnerId, Doing_Business_As__c, Toll_Free_Phone__c,
                                      In_Business_Since__c,  Contact_Principal__c //ShippingProvinceCode__c, ShippingCountryCode__c, BillingProvinceCode__c, BillingCountryCode__c, AccountManager__c,
                                      from Account where Id = :accountId LIMIT 1];
            
            if( accounts.size() > 0 ) {
            	Account account = accounts[0];
                VendorHelper vendorHelper = new VendorHelper();
                VendorResponse vendor = vendorHelper.BuildAccount(account, PrincipalContact);  //, PrincipalContact
                
                String jsonResult = JSON.serialize(vendor);
                response.responseBody = Blob.valueOf(jsonResult);    
            	response.statusCode = 200;
            } 
            else
            {
            	response.statusCode = 404;
                Account_WS_Msg Err = VendorHelper.Build_Msg('Account not found');
                String jsonResult = JSON.serialize(err);
            	response.responseBody = Blob.valueOf( jsonResult);    
            }
        }
        else
        {
            response.statusCode = 400;
                Account_WS_Msg Err = VendorHelper.Build_Msg('Account not found');
                String jsonResult = JSON.serialize(err);
            	response.responseBody = Blob.valueOf( jsonResult);   
        }
        }
           catch(Exception ex)
        {
            String s = 'Error occured while requesting Account: ' + ex.getMessage();
                Account_WS_Msg Err = VendorHelper.Build_Msg(s);
                String jsonResult = JSON.serialize(err);
            	response.responseBody = Blob.valueOf( jsonResult);
           	response.statusCode = 500;
           	
        }
            
          
        }
}