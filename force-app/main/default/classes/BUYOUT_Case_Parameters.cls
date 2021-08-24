public class BUYOUT_Case_Parameters {
    
    public static SettingsCasesAPI Parameters_Deserialize(String eipCaseParam){
        
        Map<String, Object> response;
        String SF_AccountId, EIP_Contact, IL_Langue, IL_ContractNumber, x_CustId, EIP_BuyoutType,  EIP_OperationType, IL_AccountManager, x_ActiveDirectoryName ;
        String EIP_DateBuyout, EIP_ExpiryDate;
        List<String> pExceptionMessage = new List<String>();
        Boolean EIP_TransfertThirdParty, EIP_PartialType;
        
        response = (Map<String, Object>) JSON.deserializeUntyped(eipCaseParam);
        
        SF_AccountId = (String)response.get('SF_AccountId');
        EIP_Contact = (String)response.get('EIP_Contact');
        IL_ContractNumber = (String)response.get('IL_ContractNumber');
        x_CustId = (String)response.get('x_CustId');
        EIP_BuyoutType = (String)response.get('EIP_BuyoutType');
        EIP_OperationType = (String)response.get('EIP_OperationType');        
        IL_Langue = (String)response.get('IL_Langue');
        x_ActiveDirectoryName = (String)response.get('x_ActiveDirectoryName');
        IL_AccountManager = (String)response.get('IL_AccountManager');
        EIP_TransfertThirdParty = (Boolean)response.get('EIP_TransfertThirdParty');
        EIP_PartialType = (Boolean)response.get('EIP_PartialType');
        EIP_DateBuyout = (String)response.get('EIP_DateBuyout');
        EIP_ExpiryDate = (String)response.get('EIP_ExpiryDate');
        for(Object item : (List<Object>) response.get('EIP_ExceptionMessage')){
            pExceptionMessage.add(String.valueOf(item));
        }
        
       // eipExceptionMessage = (List<String>)response.get('eipExceptionMessage');
        
       SettingsCasesAPI Object_Param = new SettingsCasesAPI (SF_AccountId, EIP_Contact, IL_ContractNumber, x_CustId, EIP_BuyoutType, EIP_PartialType, EIP_DateBuyout, 
                                EIP_OperationType, IL_Langue, EIP_ExpiryDate, IL_AccountManager, pExceptionMessage, x_ActiveDirectoryName, EIP_TransfertThirdParty);  //   String eipLoginUser --- //Account_Verification.CustomAccountResponse ac, String error){
                
        
    
    return Object_Param;
    }

}