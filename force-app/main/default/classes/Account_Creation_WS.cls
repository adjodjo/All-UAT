@RestResource(urlMapping='/Account/Create/*')


global with sharing class Account_Creation_WS {
    
    
    static final String message_5 = 'message_5';
    static final String message_12 = 'message_12';
 
    
    // Création d'un nouveau compte après vérification et création d'un contact après vérification
    
    @HttpPut
    global static void Account_Contact_Verification(SettingsAccountContactAPI AccountSettings){
        
        String err_Msg = null, userLanguage = UserInfo.getLanguage();
            
        String acc, Obj, cId = null;
        Map<String, Object> resp;
        
         RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type','application/json');
        
        
        try{
        // test if at least one Account parameters is null or empty
        if( AccountSettings.eipAccountName == null || AccountSettings.eipAccountName == '' || AccountSettings.eipAccountPhone == null ){
            
            cId = null;
            Obj = null;
            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_5);
             response.statusCode = 400;
             String jsonResult = JSON.serialize(cId);
             response.responseBody = Blob.valueOf(jsonResult);
            
        }
        else{
            // call Account Contact Manage method
            acc = Account_Verification.Account_Contact_Manage(AccountSettings);
                /*eipAccountName, eipAccountUsualName, eipAccountPostalCode, eipAccountBillingCity, eipAccountBillingStreet,eipAccountBillingState,
                                                              eipAccountBillingCountry, eipAccountPhone, eipAccountEmail,eipContactEmail, eipContactName, eipContactPhone,  eipActiveDirectoryName);
            */
            resp = (Map<String, Object>) JSON.deserializeUntyped(acc);
            
            Obj = 'Account';
            err_Msg = (String)resp.get('API_Error_Msg');
            cId = (String)resp.get('accountId');
            
            
            if(cId == null){
                
                err_Msg = MessageUtils.ErrorMessage(userLanguage, message_12);
                
                response.statusCode = 400;
                String jsonResult = JSON.serialize(cId);
                response.responseBody = Blob.valueOf(jsonResult);
                
            }
            else{
                Manage_EIP_User.Get_User(AccountSettings.eipActiveDirectoryName, cId, Obj);
                
                response.statusCode = 200;
                String jsonResult = JSON.serialize(cId);
                response.responseBody = Blob.valueOf(jsonResult);
            }
            
        }
        //return JSON.serialize(new CustomResponse((String)resp.get('Id'),(String)resp.get('Account_Msg'))).remove('\\');
     //   return new AccountCustomResponse(cId,  err_Msg);
   
    }catch(Exception ex){
        
        		response.statusCode = 500;
                String jsonResult = JSON.serialize(ex.getMessage());
                response.responseBody = Blob.valueOf(jsonResult);
        
    }
}

}
    
    
/*
/services/apexrest/Account/   CREATE NEW HISTORIC RECORD AFTER THE BUYOUT PROCESS WAS SUCCESFULL COMPLETE

/services/apexrest/Account/?eipAccountName=Bonduelle?eipContactName=Stépna Martel?eipAccountPostalCode=G8Y3B5?eipAccountEmail=alban.tagnitsap@analystik.ca?eipContactEmail=dev@analystik.ca?eipAccountBillingCity=Montreal?eipAccountPhone=+14398755526


{
"AccountSettings":{
"eipAccountName" : "parabel inc.",
"eipAccountUsualName" : "parabel", 
"eipContactName" : "Yann Perreau",
"eipAccountPostalCode" : "K8Y3B5", 
"eipAccountEmail" : "devbon@analystic.ca", 
"eipContactEmail" : "testbond@analystic.ca",
"eipAccountBillingCity" : "Quebec",
"eipAccountBillingStreet" : "1450 Rue de la Motte",
"eipAccountBillingState" : "QC",
"eipAccountBillingCountry" : "Canada",
"eipAccountPhone" : "+14188755526",
"eipContactPhone" : "+14188755527"
}
}



{
"eipAccountName" : "ppppp",
"eipLimit" : 10,
"eipOffset" : 0


}

*/