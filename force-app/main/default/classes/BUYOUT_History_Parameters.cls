public with sharing class BUYOUT_History_Parameters {
    
    
    public static SettingsHistoricsAPI Parameters_Deserialize(String BuyoutParam, String BuyoutDoc){
        
        Map<String, Object> responseHistory;
        Map<String, Object> responseDoc;
       
        String SendEmail, CcSendEmail, SF_AccountId, EIP_Contact, IL_ContractNumber, x_CustId, EIP_TypeNote, EIP_BuyoutType, DMS_FileName,DMS_File,
            DMS_DocType, EIP_OperationType, IL_Langue, SF_sfdcCaseId, x_ActiveDirectoryName, IL_AccountManager, EIP_DateBuyout, EIP_ExpiryDate, EIP_Description, EIP_BuyoutNumber;
        Boolean EIP_TransfertThirdParty, EIP_PartialType, EIP_StretchLease;
        Decimal IL_Amount, IL_EndOfTermFee, IL_TaxesGST, IL_TaxesPST, IL_TaxesHST, IL_TotalBuyout, IL_Rate, IL_BalanceAmount;
        Integer IL_BuyoutTerm;
        List<String> pDescription = new List<String>();
       
        system.debug (' BuyoutParam :'+BuyoutParam);
        responseHistory = (Map<String, Object>) JSON.deserializeUntyped(BuyoutParam);
        system.debug (' responseHistory :'+responseHistory);
        responseDoc = (Map<String, Object>) JSON.deserializeUntyped(BuyoutDoc);
         system.debug (' responseDoc :'+responseDoc);
         
        SendEmail = (String)responseHistory.get('SendEmail');
        system.debug (' SendEmail :'+(String)responseHistory.get('eipSendEmail'));
        CcSendEmail = (String)responseHistory.get('CcSendEmail');
        SF_AccountId = (String)responseHistory.get('SF_AccountId');
        EIP_Contact = (String)responseHistory.get('EIP_Contact');
        IL_ContractNumber = (String)responseHistory.get('IL_ContractNumber');
        x_CustId = (String)responseHistory.get('x_CustId');
        EIP_TypeNote = (String)responseHistory.get('EIP_TypeNote');
        EIP_BuyoutType = (String)responseHistory.get('EIP_BuyoutType');
        DMS_FileName = (String)responseDoc.get('DMS_FileName');
        DMS_File = (String)responseDoc.get('DMS_File');
        DMS_DocType = (String)responseDoc.get('DMS_DocType');
        EIP_OperationType = (String)responseHistory.get('EIP_OperationType');        
        IL_Langue = (String)responseHistory.get('IL_Langue');
        SF_sfdcCaseId = (String)responseHistory.get('SF_sfdcCaseId');
        x_ActiveDirectoryName = (String)responseHistory.get('x_ActiveDirectoryName');
        IL_AccountManager = (String)responseHistory.get('IL_AccountManager');
        EIP_TransfertThirdParty = (Boolean)responseHistory.get('EIP_TransfertThirdParty');
        EIP_StretchLease = (Boolean)responseHistory.get('EIP_StretchLease');
        System.debug ('LE STREEEEEEEE    -----  '+ EIP_StretchLease+ '   --------------     '+(Boolean)responseHistory.get('EIP_StretchLease'));
        EIP_PartialType = (Boolean)responseHistory.get('EIP_PartialType');
        EIP_BuyoutNumber = (String)responseHistory.get('EIP_BuyoutNumber');
        
        IL_Amount = (Decimal)responseHistory.get('IL_Amount');
        IL_EndOfTermFee = (Decimal)responseHistory.get('IL_EndOfTermFee');
        IL_TaxesGST = (Decimal)responseHistory.get('IL_TaxesGST');
        IL_TaxesPST = (Decimal)responseHistory.get('IL_TaxesPST');
        IL_TaxesHST = (Decimal)responseHistory.get('IL_TaxesHST');
        IL_TotalBuyout = (Decimal)responseHistory.get('IL_TotalBuyout');
        IL_Rate = (Decimal)responseHistory.get('IL_Rate');
        IL_BalanceAmount = (Decimal)responseHistory.get('IL_BalanceAmount');
        
        IL_BuyoutTerm = (Integer)responseHistory.get('IL_BuyoutTerm');        
        EIP_DateBuyout = (String)responseHistory.get('EIP_DateBuyout');
        EIP_ExpiryDate = (String)responseHistory.get('EIP_ExpiryDate');
       for(Object item : (List<Object>) responseHistory.get('EIP_Description')){
            pDescription.add(String.valueOf(item));
        }
        system.debug('pDescription '+pDescription);
     
       
        
         SettingsHistoricsAPI Object_Param = new SettingsHistoricsAPI(SendEmail, CcSendEmail, SF_AccountId, EIP_Contact, IL_ContractNumber, x_CustId,
                                    EIP_TypeNote, IL_Amount, IL_EndOfTermFee, IL_TaxesGST, IL_TaxesPST, IL_TaxesHST, 
                                    IL_TotalBuyout, EIP_BuyoutType, EIP_PartialType, DMS_FileName, EIP_DateBuyout, DMS_File, DMS_DocType, 
                                    EIP_OperationType, IL_Langue, pDescription, IL_BuyoutTerm, IL_Rate, EIP_ExpiryDate, 
                                    SF_sfdcCaseId, IL_BalanceAmount, x_ActiveDirectoryName, IL_AccountManager, EIP_TransfertThirdParty, EIP_BuyoutNumber, EIP_StretchLease);
       
       return Object_Param;
    }
    

}