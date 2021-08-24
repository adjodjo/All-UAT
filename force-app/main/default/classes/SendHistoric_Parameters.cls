public with sharing class SendHistoric_Parameters {
    
    public static SettingSendHistoric Parameters_Deserialize(String SendParam, String SendDoc){
        
        Map<String, Object> responseHistory;
        Map<String, Object> responseDoc;
        System.debug('debut test send 2');
        String SendEmail, CcSendEmail,FromEmail,  IL_Langue, SF_ParentHistoryId, SF_HistoryId, x_ActiveDirectoryName, EIP_Contact, DMS_FileName,DMS_File,DMS_DocType, EIP_HistoricType, EIP_EmailMessage, EIP_EmailSubject;
        
        responseHistory = (Map<String, Object>) JSON.deserializeUntyped(SendParam);
        responseDoc = (Map<String, Object>) JSON.deserializeUntyped(SendDoc);
        
        SendEmail = (String)responseHistory.get('SendEmail');
        CcSendEmail = (String)responseHistory.get('CcSendEmail');
        FromEmail = (String)responseHistory.get('FromEmail');
        SF_ParentHistoryId = (String)responseHistory.get('SF_ParentHistoryId');
        SF_HistoryId = (String)responseHistory.get('SF_HistoryId');
        EIP_Contact = (String)responseHistory.get('EIP_Contact');
        IL_Langue = (String)responseHistory.get('IL_Langue');
        x_ActiveDirectoryName = (String)responseHistory.get('x_ActiveDirectoryName');
        DMS_FileName = (String)responseDoc.get('DMS_FileName');
        DMS_File = (String)responseDoc.get('DMS_File');
        DMS_DocType = (String)responseDoc.get('DMS_DocType');
        EIP_HistoricType = (String)responseHistory.get('EIP_HistoricType');
        EIP_EmailMessage = (String)responseHistory.get('EIP_EmailMessage');
        EIP_EmailSubject = (String)responseHistory.get('EIP_EmailSubject');
        
        
        SettingSendHistoric Object_Param = new SettingSendHistoric(SF_ParentHistoryId, SF_HistoryId, SendEmail, CcSendEmail,FromEmail, EIP_Contact, DMS_FileName, DMS_File, DMS_DocType, 
                                IL_Langue, x_ActiveDirectoryName, EIP_HistoricType, EIP_EmailSubject, EIP_EmailMessage);
        
        return Object_Param;
        
        
    }

}