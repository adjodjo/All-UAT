global with sharing class AVISTERM_SettingHistoricLetter {
    
    public String SF_AccountId;
    public String IL_ContractNumber;
    public String x_CustId;
    public String IL_Langue;
    public String EIP_LetterDate;
   
    public String IL_LateDate;
    public String IL_DateLine;
    public Decimal IL_LateBalance;
    public Decimal IL_LeaseBalance;
    public Integer IL_NbOfPaiement;
    public String IL_Article;
	public Integer IL_DayDueDate;
    
    
    public String x_ActiveDirectoryName;
    public String x_LetterOwner;
    public String x_OwnerPhone;
    public String x_OwnerPhoneExt;
    public String x_OwnerTitle;
    public String EIP_TypeLetter;
    public String DMS_DocLink;
    public String DMS_DocType;
    
    
     public AVISTERM_SettingHistoricLetter( String SF_AccountId, String IL_ContractNumber, String x_CustId,String IL_Langue,String EIP_LetterDate, String IL_LateDate, String IL_DateLine, 
                                           Decimal IL_LateBalance, Decimal IL_LeaseBalance, Integer IL_NbOfPaiement,String IL_Article, Integer IL_DayDueDate, String x_ActiveDirectoryName, 
                                           String x_LetterOwner, String x_OwnerPhone,String x_OwnerPhoneExt,String x_OwnerTitle,
                                         String EIP_TypeLetter, String DMS_DocLink,  String DMS_DocType){ 
                                      
                this.SF_AccountId = SF_AccountId;
                this.IL_ContractNumber = IL_ContractNumber;
                this.x_CustId = x_CustId;
                this.IL_Langue = IL_Langue;
                this.EIP_LetterDate = EIP_LetterDate;
                
                this.IL_LateDate = IL_LateDate;
                this.IL_DateLine = IL_DateLine;
                this.IL_LateBalance = IL_LateBalance;
                this.IL_LeaseBalance = IL_LeaseBalance;
                this.IL_NbOfPaiement = IL_NbOfPaiement;
                this.IL_Article = IL_Article;
				this.IL_DayDueDate = IL_DayDueDate;
                
                this.x_ActiveDirectoryName = x_ActiveDirectoryName;
                this.x_LetterOwner = x_LetterOwner;
                this.x_OwnerPhone = x_OwnerPhone;                             
                this.x_OwnerPhoneExt = x_OwnerPhoneExt;
                this.x_OwnerTitle = x_OwnerTitle;
                                             
              	this.EIP_TypeLetter = EIP_TypeLetter;
                this.DMS_DocLink = DMS_DocLink;
                this.DMS_DocType = DMS_DocType;
                                    }

}