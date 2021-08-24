global with sharing class Other_SettingHistoricLetter {
    
    public String SF_AccountId;
    public String IL_ContractNumber;
    public String x_CustId;
    public String IL_Langue;
    public String EIP_LetterDate;
    public String x_ActiveDirectoryName;
    public String x_LetterOwner;
    public String x_OwnerPhone;
    public String x_OwnerPhoneExt;
    public String x_OwnerTitle;
    public String EIP_TypeLetter;
    public String DMS_DocLink;
    public String DMS_DocType;
    
    
     public Other_SettingHistoricLetter( String SF_AccountId, String IL_ContractNumber, String x_CustId,String IL_Langue,String EIP_LetterDate, 
                                         String x_ActiveDirectoryName, String x_LetterOwner, String x_OwnerPhone,String x_OwnerPhoneExt,String x_OwnerTitle,
                                        String EIP_TypeLetter, String DMS_DocLink, String DMS_DocType){ //, String EIP_EmailMessage
                
                this.SF_AccountId = SF_AccountId;
                this.IL_ContractNumber = IL_ContractNumber;
                this.x_CustId = x_CustId;
                this.IL_Langue = IL_Langue;
                this.EIP_LetterDate = EIP_LetterDate;
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