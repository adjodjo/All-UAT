@RestResource(urlMapping='/Historic_AVISTERM__c/Letter/Avisterm/*')

global with sharing  class AVISTERM_Historic_Letter_Creation_WS {
    
    static final String message_4 = 'message_4';
      
    @HttpPut
    global static AVISTERM_HistoryCustomResponse createHistoriqueLetterAvisterm( AVISTERM_SettingHistoricLetter A_HistoricLetter){ 
        
        String err_Msg = null, userLanguage = UserInfo.getLanguage();
        
        Map<String, Object> response;
        String hId, phId, Obj = 'Historic_AVISTERM__c';
        
       
            if(A_HistoricLetter.EIP_TypeLetter == 'AVISTERM'){
                
                 String Historic_Response = AVISTERM_Historique_Letter.Historique_Letter_Manage(A_HistoricLetter);
                system.debug('le string reponse est : '+Historic_Response); 
                
                response = (Map<String, Object>) JSON.deserializeUntyped(Historic_Response);
                
                err_Msg = (String)response.get('API_Error_Msg');
                hId = (String)response.get('historyId');
                phId = (String)response.get('parentHistoryId');
                
                system.debug('le string reponse est 2: hId='+hId+ ' phId='+phId); 
            }
            	else{
                    String SF_AccountId = A_HistoricLetter.SF_AccountId;
                    String IL_ContractNumber = A_HistoricLetter.IL_ContractNumber;
                    String x_CustId = A_HistoricLetter.x_CustId;
                    String IL_Langue = A_HistoricLetter.IL_Langue;
                    String EIP_LetterDate = A_HistoricLetter.EIP_LetterDate;
                    String x_ActiveDirectoryName = A_HistoricLetter.x_ActiveDirectoryName;
                    String x_LetterOwner = A_HistoricLetter.x_LetterOwner;
                    String x_OwnerPhone = A_HistoricLetter.x_OwnerPhone;
                    String x_OwnerPhoneExt = A_HistoricLetter.x_OwnerPhoneExt;
                    String x_OwnerTitle = A_HistoricLetter.x_OwnerTitle;
                    String EIP_TypeLetter = A_HistoricLetter.EIP_TypeLetter;
                    String DMS_DocLink =A_HistoricLetter.DMS_DocLink;
                    String DMS_DocType =A_HistoricLetter.DMS_DocType;
                    
                    Other_SettingHistoricLetter OtherSetting = new Other_SettingHistoricLetter(SF_AccountId,  IL_ContractNumber,  x_CustId, IL_Langue, EIP_LetterDate, 
                                                                                               x_ActiveDirectoryName,  x_LetterOwner,  x_OwnerPhone,  x_OwnerPhoneExt,  
                                                                                               x_OwnerTitle,  EIP_TypeLetter,  DMS_DocLink,  DMS_DocType);
                    String OtherResponse =  Other_Historique_Letter.Historique_Letter_Manage(OtherSetting);
                     	
                    response = (Map<String, Object>) JSON.deserializeUntyped(OtherResponse);
                
                        err_Msg = (String)response.get('API_Error_Msg');
                        hId = (String)response.get('historyId');
                        phId = (String)response.get('parentHistoryId');
                
            }
        
    return new AVISTERM_HistoryCustomResponse( hId, phId,err_Msg);
    }

}


/*
 
/services/apexrest/Historic_AVISTERM__c/Letter/Avisterm/*

{
"A_HistoricLetter" : {
"SF_AccountId" : "00119000010JTkiAAG", 
"IL_ContractNumber" : "051-0096467-001",
"x_CustId" : "C349702",
"IL_Langue" : "FR",
"IL_DateLine" : "2020-02-21",
"IL_LateDate" : "2020-02-21",
"IL_LateBalance" : "200",
"IL_LeaseBalance" : "500",
"IL_NbOfPaiement" : "5",
"IL_Article" : "23 al3",
"IL_DayDueDate" : "31",
"x_ActiveDirectoryName" : "adjodjo",
"EIP_LetterDate" : "2020-02-21",
"EIP_TypeLetter" : "AVISTERM",
"DMS_DocLink" : "test",
"DMS_DocType" : "application/pdf",
"x_LetterOwner" : "test user",
"x_OwnerPhone" : "8190000000",
 "x_OwnerPhoneExt" : "2569",
"x_OwnerTitle" : "sys Admin"

}
}

public Date IL_LateDate;
    public Date IL_DateLine;
    public Decimal IL_LateBalance;
    public Decimal IL_LeaseBalance;
    public Integer IL_NbOfPaiement;
	public Integer IL_DayDueDate;
    

*/