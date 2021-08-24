global with sharing class SettingSendHistoric {
    
    public String SF_ParentHistoryId;
    public String SF_HistoryId;
    
    public String SendEmail;
    public String CcSendEmail;
    public String FromEmail;
    public String EIP_Contact;
    
    public String DMS_FileName;
    public String DMS_File;
    public String DMS_DocType;
    public String IL_Langue;
    public String x_ActiveDirectoryName;
    
    public String EIP_HistoricType;
    public String EIP_EmailSubject;
    public String EIP_EmailMessage;
    
    
     public SettingSendHistoric( String SF_ParentHistoryId, String SF_HistoryId, String SendEmail, String CcSendEmail, String FromEmail, String EIP_Contact, String DMS_FileName, String DMS_File, String DMS_DocType, 
                                String IL_Langue, String x_ActiveDirectoryName, String EIP_HistoricType, String EIP_EmailSubject, String EIP_EmailMessage){ //, String EIP_EmailMessage
                                      
               
                this.SF_ParentHistoryId = SF_ParentHistoryId;
                this.SF_HistoryId = SF_HistoryId;
                this.SendEmail = SendEmail;
                this.CcSendEmail = CcSendEmail;
                this.FromEmail = FromEmail;
                this.EIP_Contact = EIP_Contact;
                this.DMS_FileName = DMS_FileName;
                this.DMS_File = DMS_File;
                this.DMS_DocType = DMS_DocType;
                this.IL_Langue = IL_Langue;
                this.x_ActiveDirectoryName = x_ActiveDirectoryName;
                this.EIP_HistoricType = EIP_HistoricType;
                this.EIP_EmailSubject = EIP_EmailSubject;
                this.EIP_EmailMessage = EIP_EmailMessage;
                                    }
    
    
    public SettingSendHistoric( String SF_HistoryId, String SendEmail, String CcSendEmail , String FromEmail, String EIP_Contact, String DMS_FileName, String DMS_File, String DMS_DocType, 
                                String IL_Langue, String x_ActiveDirectoryName, String EIP_HistoricType, String EIP_EmailSubject, String EIP_EmailMessage){ //, String EIP_EmailMessage
            
                this.SF_HistoryId = SF_HistoryId;
                this.SendEmail = SendEmail;
                this.CcSendEmail = CcSendEmail;
                this.FromEmail = FromEmail;
                this.EIP_Contact = EIP_Contact;
                this.DMS_FileName = DMS_FileName;
                this.DMS_File = DMS_File;
                this.DMS_DocType = DMS_DocType;
                this.IL_Langue = IL_Langue;
                this.x_ActiveDirectoryName = x_ActiveDirectoryName;
                 this.EIP_HistoricType = EIP_HistoricType;
                this.EIP_EmailSubject = EIP_EmailSubject;
                this.EIP_EmailMessage = EIP_EmailMessage;
                                    }

}