@RestResource(urlMapping='/Historic_Welcome__c/Letter/Welcome/*')
              
global with sharing class Welcome_Historic_Letter_Creation_WS {
    
    static final String message_4 = 'message_4';
    
     @HttpPut
    global static Welcome_HistoryCustomResponse createHistoriqueLetterWelcome( Welcome_SettingHistoricLetter W_HistoricLetter){  
    
        String err_Msg = null, userLanguage = UserInfo.getLanguage();
        
        Map<String, Object> response;
        String hId, phId, Obj = null;
        
       
            if(W_HistoricLetter.EIP_TypeLetter == 'Welcome' || W_HistoricLetter.EIP_TypeLetter == 'Bienvenue'){
                
                Obj = 'Historic_Welcome__c';
                
                String Historic_Response = Welcome_Historique_Letter.Historique_Letter_Manage(W_HistoricLetter);
                system.debug('le string reponse est : '+Historic_Response); 
                
                response = (Map<String, Object>) JSON.deserializeUntyped(Historic_Response);
                
                err_Msg = (String)response.get('API_Error_Msg');
                hId = (String)response.get('historyId');
                phId = (String)response.get('parentHistoryId');
                
                system.debug('le string reponse est 2: hId='+hId+ ' phId='+phId); 
            }
            	else{
                    
                    Obj = 'Historic_Other_Letters__c';
                    
                    String SF_AccountId = W_HistoricLetter.SF_AccountId;
                    String IL_ContractNumber = W_HistoricLetter.IL_ContractNumber;
                    String x_CustId = W_HistoricLetter.x_CustId;
                    String IL_Langue = W_HistoricLetter.IL_Langue;
                    String EIP_LetterDate = W_HistoricLetter.EIP_LetterDate;
                    String x_ActiveDirectoryName = W_HistoricLetter.x_ActiveDirectoryName;
                    String x_LetterOwner = W_HistoricLetter.x_LetterOwner;
                    String x_OwnerPhone = W_HistoricLetter.x_OwnerPhone;
                    String x_OwnerPhoneExt = W_HistoricLetter.x_OwnerPhoneExt;
                    String x_OwnerTitle = W_HistoricLetter.x_OwnerTitle;
                    String EIP_TypeLetter = W_HistoricLetter.EIP_TypeLetter;
                    String DMS_DocLink =W_HistoricLetter.DMS_DocLink;
                    String DMS_DocType =W_HistoricLetter.DMS_DocType;
                    
                    Other_SettingHistoricLetter OtherSetting = new Other_SettingHistoricLetter(SF_AccountId,  IL_ContractNumber,  x_CustId, IL_Langue, EIP_LetterDate, 
                                                                                               x_ActiveDirectoryName,  x_LetterOwner,  x_OwnerPhone,  x_OwnerPhoneExt,  
                                                                                               x_OwnerTitle, EIP_TypeLetter,  DMS_DocLink,  DMS_DocType);
                   String OtherResponse =  Other_Historique_Letter.Historique_Letter_Manage(OtherSetting);
                     	
                    response = (Map<String, Object>) JSON.deserializeUntyped(OtherResponse);
                
                        err_Msg = (String)response.get('API_Error_Msg');
                        hId = (String)response.get('historyId');
                        phId = (String)response.get('parentHistoryId');
                
                }
system.debug('le test est '+new Retard_historyCustomResponse(phId, hId, err_Msg));
     return new Welcome_historyCustomResponse(hId, phId, err_Msg);
    }  

}


/*
 
/services/apexrest/Historic_Welcome__c/Letter/Welcome/*

{
"W_HistoricLetter" : {

"SF_AccountId" : "0013J000003MQ7bQAG", 
"IL_ContractNumber" : "051-0096467-001",
"x_CustId" : "C349702",
"IL_Langue" : "FR",
"x_ActiveDirectoryName" : "adjodjo",
"EIP_LetterDate" : "2020-02-21",
"EIP_TypeLetter" : "Welcome",
"DMS_DocLink" : "test",
"DMS_DocType" : "application/pdf",
"x_LetterOwner" : null

}
}

*/