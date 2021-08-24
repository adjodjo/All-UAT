Global with sharing class SettingsCasesAPITest {

    public String SF_AccountId;
    public String EIP_Contact;
    public String IL_Langue;
    public String IL_ContractNumber;
    public String x_CustId;
    public String EIP_BuyoutType;
    public String EIP_OperationType; 
    public String EIP_DateBuyout; 
    public String EIP_ExpiryDate;
    Public String IL_AccountManager; 
    public List<String> EIP_ExceptionMessage;
    public String x_ActiveDirectoryName;
    Public Boolean EIP_TransfertThirdParty;
    
    public SettingsCasesAPITest( String SF_AccountId, String EIP_Contact, String IL_ContractNumber, String x_CustId,String EIP_BuyoutType, String EIP_DateBuyout, 
                                String EIP_OperationType, String IL_Langue, String EIP_ExpiryDate, String IL_AccountManager, List<String> EIP_ExceptionMessage, String x_ActiveDirectoryName, Boolean EIP_TransfertThirdParty){  //   String eipLoginUser --- //Account_Verification.CustomAccountResponse ac, String error){
                
                this.SF_AccountId = SF_AccountId;
                this.EIP_Contact = EIP_Contact;
                this.IL_ContractNumber = IL_ContractNumber;
                this.x_CustId = x_CustId;
                this.EIP_BuyoutType = EIP_BuyoutType;
                this.EIP_DateBuyout = EIP_DateBuyout;
                this.EIP_OperationType = EIP_OperationType;
                this.IL_Langue = IL_Langue;
                this.EIP_ExpiryDate = EIP_ExpiryDate;
                this.IL_AccountManager = IL_AccountManager;
                this.EIP_ExceptionMessage = EIP_ExceptionMessage;
                this.x_ActiveDirectoryName = x_ActiveDirectoryName;
                this.EIP_TransfertThirdParty = EIP_TransfertThirdParty;
        }
    

}