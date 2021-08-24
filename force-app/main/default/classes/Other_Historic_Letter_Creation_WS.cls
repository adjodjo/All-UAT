@RestResource(urlMapping='/Historic_Other_Letters__c/Letter/Other/*')

global with sharing class Other_Historic_Letter_Creation_WS {
    
    static final String message_4 = 'message_4';
    
     @HttpPut
    global static Other_HistoryCustomResponse createHistoriqueLetterOther( Other_SettingHistoricLetter O_HistoricLetter){ 
    
     String err_Msg = null, userLanguage = UserInfo.getLanguage();
        
        Map<String, Object> response;
        String hId, phId, Obj = 'Historic_Other_Letters__c';
        
       
            if(O_HistoricLetter.EIP_TypeLetter == 'Cautsces' || O_HistoricLetter.EIP_TypeLetter == 'Other' || O_HistoricLetter.EIP_TypeLetter == 'Autre'){
                
                String Historic_Response = Other_Historique_Letter.Historique_Letter_Manage(O_HistoricLetter);
                system.debug('le string reponse est : '+Historic_Response); 
                
                response = (Map<String, Object>) JSON.deserializeUntyped(Historic_Response);
                
                err_Msg = (String)response.get('API_Error_Msg');
                hId = (String)response.get('historyId');
                phId = (String)response.get('parentHistoryId');
                
                system.debug('le string reponse est 2: hId='+hId+ ' phId='+phId); 
            }
            	else{
                     String SF_AccountId = O_HistoricLetter.SF_AccountId;
                    String IL_ContractNumber = O_HistoricLetter.IL_ContractNumber;
                    String x_CustId = O_HistoricLetter.x_CustId;
                    String IL_Langue = O_HistoricLetter.IL_Langue;
                    String EIP_LetterDate = O_HistoricLetter.EIP_LetterDate;
                    String x_ActiveDirectoryName = O_HistoricLetter.x_ActiveDirectoryName;
                    String x_LetterOwner = O_HistoricLetter.x_LetterOwner;
                     String x_OwnerPhone = O_HistoricLetter.x_OwnerPhone;
                    String x_OwnerPhoneExt = O_HistoricLetter.x_OwnerPhoneExt;
                    String x_OwnerTitle = O_HistoricLetter.x_OwnerTitle;
                    String EIP_TypeLetter = O_HistoricLetter.EIP_TypeLetter;
                    String DMS_DocLink =O_HistoricLetter.DMS_DocLink;
                    String DMS_DocType =O_HistoricLetter.DMS_DocType;
                    
                    Other_SettingHistoricLetter OtherSetting = new Other_SettingHistoricLetter(SF_AccountId,  IL_ContractNumber,  x_CustId, IL_Langue, EIP_LetterDate, 
                                                                                               x_ActiveDirectoryName,  x_LetterOwner, x_OwnerPhone,  x_OwnerPhoneExt,  
                                                                                               x_OwnerTitle, EIP_TypeLetter,  DMS_DocLink,  DMS_DocType);
                    String OtherResponse =  Other_Historique_Letter.Historique_Letter_Manage(OtherSetting);
                     	
                    response = (Map<String, Object>) JSON.deserializeUntyped(OtherResponse);
                
                        err_Msg = (String)response.get('API_Error_Msg');
                        hId = (String)response.get('historyId');
                        phId = (String)response.get('parentHistoryId');
                
                }
system.debug('le test est '+new Retard_historyCustomResponse(phId, hId,  err_Msg));
     return new Other_historyCustomResponse( hId, phId, err_Msg);
    
    }

}




/*
 
  /services/apexrest/Historic_Other_Letters__c/Letter/Other/*
 
{
"O_HistoricLetter" : {

"SF_AccountId" : "0013J000003MQ7bQAG", 
"IL_ContractNumber" : "000000000",
"x_CustId" : "C349702",
"IL_Langue" : "FR",
"x_ActiveDirectoryName" : "adjodjo",
"EIP_LetterDate" : "2020-02-21",
"EIP_TypeLetter" : "Other",
"DMS_DocLink" : "test",
"DMS_DocType" : "application/pdf",
"x_LetterOwner" : null

}
}

 */