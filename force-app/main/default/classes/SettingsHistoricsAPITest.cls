Global with sharing class SettingsHistoricsAPITest {
    
     public String SendEmail;
    public String CcSendEmail;
    public String SF_AccountId;
    public String EIP_Contact;
    public String IL_ContractNumber;
    public String x_CustId;
    public String EIP_TypeNote;
    public Decimal IL_Amount;
    public Decimal IL_EndOfTermFee;
    public Decimal IL_TaxesGST;
    public Decimal IL_TaxesPST;
    public Decimal IL_TaxesHST;
    public Decimal IL_TotalBuyout;
    public String EIP_BuyoutType;
    public String DMS_FileName;
    public String EIP_DateBuyout;
    public String DMS_File;
    public String DMS_DocType;
    public String EIP_OperationType; 
    public String IL_Langue;
    public List<String> EIP_Description;
    public Integer IL_BuyoutTerm;
    public Decimal IL_Rate;
    public String EIP_ExpiryDate;
    public String SF_sfdcCaseId;
    public Decimal IL_BalanceAmount;
    public String x_ActiveDirectoryName;
    Public String IL_AccountManager;
    Public Boolean EIP_TransfertThirdParty;
    Public String eipBuyoutNumber;
    Public Boolean eipStretchLease;
   
    
  
        
        public SettingsHistoricsAPITest( String SendEmail, Boolean eipStretchLease, String CcSendEmail, String SF_AccountId, String EIP_Contact, String IL_ContractNumber, String x_CustId,
                                    String EIP_TypeNote, Decimal IL_Amount, Decimal IL_EndOfTermFee, Decimal IL_TaxesGST, Decimal IL_TaxesPST, Decimal IL_TaxesHST, 
                                    Decimal IL_TotalBuyout, String EIP_BuyoutType, String DMS_FileName, String EIP_DateBuyout, String DMS_File, String DMS_DocType, 
                                    String EIP_OperationType, String IL_Langue, List<String> EIP_Description, Integer IL_BuyoutTerm, Decimal IL_Rate, String EIP_ExpiryDate, 
                                    String SF_sfdcCaseId, Decimal IL_BalanceAmount, String x_ActiveDirectoryName, String IL_AccountManager, Boolean EIP_TransfertThirdParty, String eipBuyoutNumber){ // String eipTypeLetter, String eipDMSId
                                        
                                        //  eipLoginUser;  //Account_Verification.CustomAccountResponse ac, String error){
                
                this.SendEmail = SendEmail;
                this.CcSendEmail = CcSendEmail;
                this.SF_AccountId = SF_AccountId;
                this.EIP_Contact = EIP_Contact;
                this.IL_ContractNumber = IL_ContractNumber;
                this.x_CustId = x_CustId;
                this.EIP_TypeNote = EIP_TypeNote;
                this.IL_Amount = IL_Amount;
                this.IL_EndOfTermFee = IL_EndOfTermFee;
                this.IL_TaxesGST = IL_TaxesGST;
                this.IL_TaxesPST = IL_TaxesPST;
                this.IL_TaxesHST = IL_TaxesHST;
                this.IL_TotalBuyout = IL_TotalBuyout;
                this.EIP_BuyoutType = EIP_BuyoutType;
                this.DMS_FileName = DMS_FileName;
                this.EIP_DateBuyout = EIP_DateBuyout;
                this.DMS_File = DMS_File;
                this.DMS_DocType = DMS_DocType;
                this.EIP_OperationType = EIP_OperationType;
                this.IL_Rate = IL_Rate;
                this.IL_BuyoutTerm = IL_BuyoutTerm;
                this.EIP_Description = EIP_Description;
                this.IL_Langue = IL_Langue;
                this.EIP_ExpiryDate = EIP_ExpiryDate;
                this.SF_sfdcCaseId = SF_sfdcCaseId;
                this.IL_BalanceAmount = IL_BalanceAmount;
                this.x_ActiveDirectoryName = x_ActiveDirectoryName;
                this.IL_AccountManager = IL_AccountManager;
                this.EIP_TransfertThirdParty = EIP_TransfertThirdParty;
                                        this.eipBuyoutNumber = eipBuyoutNumber;
                                         this.eipStretchLease = eipStretchLease;
                                        
                              
               
        }

}