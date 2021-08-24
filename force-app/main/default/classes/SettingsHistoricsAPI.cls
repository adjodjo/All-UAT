Global with sharing class SettingsHistoricsAPI {

    public String eipSendEmail;
    public String eipCcSendEmail;
    public String eipAccount;
    public String eipContact;
    public String eipContractNumber;
    public String eipCustId;
    public String eipTypeNote;
    public Decimal eipAmount;
    public Decimal eipEndOfTermFee;
    public Decimal eipTaxesGST;
    public Decimal eipTaxesPST;
    public Decimal eipTaxesHST;
    public Decimal eipTotalBuyout;
    public String eipBuyoutType;
    public Boolean eipPartialType;
    public String eipFileName;
    public String epiDateBuyout;
    public String eipFile;
    public String eipContentType;
    public String eipOperationType; 
    public String eipLangue;
    public List<String> eipDescription;
    public Integer eipBuyoutTerm;
    public Decimal eipRate;
    public String eipExpiryDate;
    public String sfdcCaseId;
    public Decimal eipBalanceAmount;
    public String eipActiveDirectoryName;
    Public String eipAccountManager;
    Public Boolean eipTransfertThirdParty;
    Public String eipBuyoutNumber;
    Public Boolean eipStretchLease;
    
        
                                        
        public SettingsHistoricsAPI( String eipSendEmail, String eipCcSendEmail, String eipAccount, String eipContact, String eipContractNumber, String eipCustId,
                                    String eipTypeNote, Decimal eipAmount, Decimal eipEndOfTermFee, Decimal eipTaxesGST, Decimal eipTaxesPST, Decimal eipTaxesHST, Decimal eipTotalBuyout, 
                                    String eipBuyoutType,Boolean eipPartialType,String eipFileName, String epiDateBuyout, String eipFile, String eipContentType, String eipOperationType, 
                                    String eipLangue, List<String> eipDescription, Integer eipBuyoutTerm, Decimal eipRate, String eipExpiryDate, String sfdcCaseId, Decimal eipBalanceAmount, 
                                    String eipActiveDirectoryName, String eipAccountManager, Boolean eipTransfertThirdParty, String eipBuyoutNumber, Boolean eipStretchLease){ //  eipLoginUser;  //Account_Verification.CustomAccountResponse ac, String error){

                this.eipSendEmail = eipSendEmail;
                this.eipCcSendEmail = eipCcSendEmail;
                this.eipAccount = eipAccount;
                this.eipContact = eipContact;
                this.eipContractNumber = eipContractNumber;
                this.eipCustId = eipCustId;
                this.eipTypeNote = eipTypeNote;
                this.eipAmount = eipAmount;
                this.eipEndOfTermFee = eipEndOfTermFee;
                this.eipTaxesGST = eipTaxesGST;
                this.eipTaxesPST = eipTaxesPST;
                this.eipTaxesHST = eipTaxesHST;
                this.eipTotalBuyout = eipTotalBuyout;
                this.eipBuyoutType = eipBuyoutType;
                this.eipPartialType = eipPartialType;
                this.eipFileName = eipFileName;
                this.epiDateBuyout = epiDateBuyout;
                this.eipFile = eipFile;
                this.eipContentType = eipContentType;
                this.eipOperationType = eipOperationType;
                this.eipRate = eipRate;
                this.eipBuyoutTerm = eipBuyoutTerm;
                this.eipDescription = eipDescription;
                this.eipLangue = eipLangue;
                this.eipExpiryDate = eipExpiryDate;
                this.sfdcCaseId = sfdcCaseId;
                this.eipBalanceAmount = eipBalanceAmount;
                this.eipActiveDirectoryName = eipActiveDirectoryName;
                this.eipAccountManager = eipAccountManager;
                this.eipTransfertThirdParty = eipTransfertThirdParty;
                this.eipBuyoutNumber = eipBuyoutNumber;
                this.eipStretchLease = eipStretchLease;                        
             
        }
}