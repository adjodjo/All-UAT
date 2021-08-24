@RestResource(urlMapping='/Historic_Retard__c/Letter/Retard/*')

global with sharing class Retard_Historic_Letter_Creation_WS {
    
    static final String message_4 = 'message_4';
      
    @HttpPut
    global static Retard_HistoryCustomResponse createHistoriqueLetterRetard( Retard_SettingHistoricLetter R_HistoricLetter){  
    
        String err_Msg = null, userLanguage = UserInfo.getLanguage();
        
        Map<String, Object> response;
        String hId, phId;
        String SF_Objec = null;
        
       
            if(R_HistoricLetter.EIP_TypeLetter == 'Retard1'  || R_HistoricLetter.EIP_TypeLetter == 'Retard2' || R_HistoricLetter.EIP_TypeLetter == 'Retard3' 
              || R_HistoricLetter.EIP_TypeLetter == 'Late1' || R_HistoricLetter.EIP_TypeLetter == 'Late2' || R_HistoricLetter.EIP_TypeLetter == 'Late3'){
                
           //     SF_Object = 'Historic_Retard__c';
                
                String Historic_Response = Retard_Historique_Letter.Historique_Letter_Manage(R_HistoricLetter);
                system.debug('le string reponse est : '+Historic_Response); 
                
                response = (Map<String, Object>) JSON.deserializeUntyped(Historic_Response);
                
                err_Msg = (String)response.get('API_Error_Msg');
                hId = (String)response.get('historyId');
                phId = (String)response.get('parentHistoryId');
                
                system.debug('le string reponse est 2: hId='+hId+ ' phId='+phId); 
            }
            	else{
              //        SF_Object = 'Historic_Other_Letters__c';
                    
                    String SF_AccountId = R_HistoricLetter.SF_AccountId;
                    String IL_ContractNumber = R_HistoricLetter.IL_ContractNumber;
                    String x_CustId = R_HistoricLetter.x_CustId;
                    String IL_Langue = R_HistoricLetter.IL_Langue;
                    String EIP_LetterDate = R_HistoricLetter.EIP_LetterDate;
                    String x_ActiveDirectoryName = R_HistoricLetter.x_ActiveDirectoryName;
                    String x_LetterOwner = R_HistoricLetter.x_LetterOwner;
                    String x_OwnerPhone = R_HistoricLetter.x_OwnerPhone;
                    String x_OwnerPhoneExt = R_HistoricLetter.x_OwnerPhoneExt;
                    String x_OwnerTitle = R_HistoricLetter.x_OwnerTitle;
                    String EIP_TypeLetter = R_HistoricLetter.EIP_TypeLetter;
                    String DMS_DocLink =R_HistoricLetter.DMS_DocLink;
                    String DMS_DocType =R_HistoricLetter.DMS_DocType;
                   
                    
                    Other_SettingHistoricLetter OtherSetting = new Other_SettingHistoricLetter(SF_AccountId,  IL_ContractNumber,  x_CustId, IL_Langue, EIP_LetterDate, 
                                                                                               x_ActiveDirectoryName,  x_LetterOwner,  x_OwnerPhone,  x_OwnerPhoneExt,  
                                                                                               x_OwnerTitle,EIP_TypeLetter,  DMS_DocLink,  DMS_DocType);
                    String OtherResponse =  Other_Historique_Letter.Historique_Letter_Manage(OtherSetting);
                     	
                    response = (Map<String, Object>) JSON.deserializeUntyped(OtherResponse);
                
                        err_Msg = (String)response.get('API_Error_Msg');
                        hId = (String)response.get('historyId');
                        phId = (String)response.get('parentHistoryId');
                
                }
		system.debug('le test est '+new Retard_historyCustomResponse(phId, hId,  err_Msg));
     	return new Retard_historyCustomResponse(hId, phId, err_Msg);
    }  
}

/*
 
/services/apexrest/Historic_Retard__c/Letter/Retard/*

{
"R_HistoricLetter" : {
"SF_AccountId" : "00119000010JTkiAAG", 
"IL_ContractNumber" : "051-0096467-001",
"x_CustId" : "C349702",
"IL_Langue" : "FR",
"x_ActiveDirectoryName" : "adjodjo",
"EIP_LetterDate" : "2020-02-21",
"EIP_TypeLetter" : "Retard1",
"DMS_DocLink" : "test",
"DMS_DocType" : "application/pdf",
"x_LetterOwner" : "test user",
"x_OwnerPhone" : "8190000000",
"x_OwnerPhoneExt" : "2569",
"x_OwnerTitle" : "sys Admin"

}
}

*/