public with sharing class CreateNew_Invoice {
    
    static final String message_13 = 'message_13';
    
    public  static Invoice_HistoryCustomResponse CreateInvoice(SettingInvoiceHistoric InvoiceSettings){
        
        String  Obj, err_msg=null, userLanguage = UserInfo.getLanguage();   //invoiceId=null,
         Historic_Invoice__c thisInvoice ;
        try{
            Obj = 'Historic_Invoice';
            String Link = ParametersUtils.BuildDMSLink()+InvoiceSettings.DMS_DocLink+'/download';
            
            if( String.isBlank(InvoiceSettings.SF_HistoryBuyoutId)  || String.isEmpty(InvoiceSettings.SF_HistoryBuyoutId) 
                 || String.isBlank(InvoiceSettings.SF_AccountId) || String.isEmpty(InvoiceSettings.SF_AccountId)){
                     
                err_Msg = MessageUtils.ErrorMessage(userLanguage, message_13);
            }
            
            else{
            thisInvoice = new Historic_Invoice__c (
                
                                                Account__c = InvoiceSettings.SF_AccountId,
                								Letter_Type__c = InvoiceSettings.EIP_HistoricType,
                                                Historic_Buyout__c = InvoiceSettings.SF_HistoryBuyoutId,
                                          		InfoLease_Contrat__c = InvoiceSettings.IL_ContractNumber,
                                                CustId__c = InvoiceSettings.x_CustId,
                                                Langue_Communication__c = InvoiceSettings.IL_Langue,
                                                ActiveDirectory_username__c = InvoiceSettings.x_ActiveDirectoryName,
                                                EIP_Invoice_Number__c = InvoiceSettings.EIP_InvoiceNumber,
                                                Date_Invoice__c = date.valueOf(InvoiceSettings.EIP_InvoiceDate),
                                                Invoice_Amount__c = InvoiceSettings.EIP_InvoiceAmount,
                                                Content__c = InvoiceSettings.EIP_Comment,
                                                Document_Link__c = Link,
                                                Document_Type__c = InvoiceSettings.DMS_DocType,
                                                Invoice_GST__c = InvoiceSettings.EIP_InvoiceGST,
                                                Invoice_PST__c = InvoiceSettings.EIP_InvoicePST,
                								Invoice_HST__c = InvoiceSettings.EIP_InvoiceHST,
                                                Total_Fee_Amount__c = InvoiceSettings.EIP_TotalFee,
                                                Invoice_Difference__c = InvoiceSettings.EIP_InvoiceDifference,
                                                Buyout_Amount__c = InvoiceSettings.EIP_BuyoutAmount,
                                                Received_Amount__c = InvoiceSettings.EIP_ReceivedAmount
                                            
            							);
            
            upsert thisInvoice;
          //  invoiceId = thisInvoice.id;
            
            if(thisInvoice.id != null){
                system.debug('EIP_InvoiceAmountFee = '+InvoiceSettings.EIP_InvoiceAmountFee);
                
                Manage_Invoice_Fee.ManageFee(thisInvoice.id, InvoiceSettings.EIP_InvoiceAmountFee);
                
                Manage_EIP_User.Get_User(InvoiceSettings.x_ActiveDirectoryName, thisInvoice.id, Obj);
                
                Historique__c buyout = new Historique__c(id = InvoiceSettings.SF_HistoryBuyoutId , With_Invoice__c = true);
                
                update buyout;
                
                
            }
            
        } 
            
        }catch(Exception ex){
            err_Msg = ex.getMessage();
        }
        
        
     
        return new Invoice_HistoryCustomResponse(thisInvoice.id,  err_Msg);
    }
}