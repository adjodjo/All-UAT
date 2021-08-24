Global with sharing class SettingsCasesAPI {

    public String eipAccount;
    public String eipContact;
    public String eipLangue;
    public String eipContractNumber;
    public String eipCustId;
    public String eipBuyoutType;
    public Boolean eipPartialType;
    public String eipOperationType; 
    public String eipDateBuyout; 
    public String eipExpiryDate;
    Public String eipAccountManager; 
    public List<String> eipExceptionMessage;
    public String eipActiveDirectoryName;
    Public Boolean eipTransfertThirdParty;
    
       
        public SettingsCasesAPI( String eipAccount, String eipContact, String eipContractNumber, String eipCustId,String eipBuyoutType, Boolean eipPartialType, String eipDateBuyout, 
                                String eipOperationType, String eipLangue, String eipExpiryDate, String eipAccountManager, List<String> eipExceptionMessage, String eipActiveDirectoryName, 
                                Boolean eipTransfertThirdParty){  //   String eipLoginUser --- //Account_Verification.CustomAccountResponse ac, String error){
        
                                    
            
                this.eipAccount = eipAccount;
                this.eipContact = eipContact;
                this.eipContractNumber = eipContractNumber;
                this.eipCustId = eipCustId;
                this.eipBuyoutType = eipBuyoutType;
                 this.eipPartialType = eipPartialType;
                this.eipDateBuyout = eipDateBuyout;
                this.eipOperationType = eipOperationType;
                this.eipLangue = eipLangue;
                this.eipExpiryDate = eipExpiryDate;
                this.eipAccountManager = eipAccountManager;
                this.eipExceptionMessage = eipExceptionMessage;
                this.eipActiveDirectoryName = eipActiveDirectoryName;
                this.eipTransfertThirdParty = eipTransfertThirdParty;
        }
}