public with sharing class Invoice_History_Parameters {
    
    public static SettingInvoiceHistoric Parameters_Deserialize(String InvoiceParam){
        
        Map<String, Object> responseInvoice;
        
         Map<String, Object> responseInvoice1;
        
        String EIP_FeeName, SF_AccountId,SF_HistoryBuyoutId,IL_ContractNumber,x_CustId,EIP_InvoiceDate,IL_Langue,x_ActiveDirectoryName,EIP_InvoiceNumber,EIP_HistoricType, 
            EIP_Comment,DMS_DocType,DMS_DocLink,EIP_InvoiceAmountFee;
        Boolean EIP_TransfertThirdParty;
        //Date EIP_InvoiceDate;
        Decimal EIP_FeeAmount, EIP_InvoiceAmount, EIP_BuyoutAmount, EIP_TotalFee, EIP_InvoicePST, EIP_InvoiceGST, EIP_InvoiceHST, EIP_ReceivedAmount, EIP_InvoiceDifference;
       
        List<String> L_InvoiceAmountFee = new List<String>();
        
        responseInvoice = (Map<String, Object>) JSON.deserializeUntyped(InvoiceParam);
        
        SF_AccountId = (String)responseInvoice.get('SF_AccountId');
        SF_HistoryBuyoutId = (String)responseInvoice.get('SF_HistoryBuyoutId');
        IL_ContractNumber = (String)responseInvoice.get('IL_ContractNumber');
        x_CustId =(String)responseInvoice.get('x_CustId');
        IL_Langue = (String)responseInvoice.get('IL_Langue');
        EIP_InvoiceDate = (String)responseInvoice.get('EIP_InvoiceDate');
        x_ActiveDirectoryName = (String)responseInvoice.get('x_ActiveDirectoryName');
        EIP_InvoiceNumber = (String)responseInvoice.get('EIP_InvoiceNumber');
        EIP_HistoricType = (String)responseInvoice.get('EIP_HistoricType');
        EIP_Comment = (String)responseInvoice.get('EIP_Comment');
        DMS_DocType = (String)responseInvoice.get('DMS_DocType');
        DMS_DocLink = (String)responseInvoice.get('DMS_DocLink');       
        EIP_InvoiceAmount = (Decimal)responseInvoice.get('EIP_InvoiceAmount');
        EIP_BuyoutAmount = (Decimal)responseInvoice.get('EIP_BuyoutAmount');
        EIP_TotalFee = (Decimal)responseInvoice.get('EIP_TotalFee');
        EIP_InvoicePST = (Decimal)responseInvoice.get('EIP_InvoicePST');
        EIP_InvoiceGST = (Decimal)responseInvoice.get('EIP_InvoiceGST');
        EIP_InvoiceHST = (Decimal)responseInvoice.get('EIP_InvoiceHST');
        EIP_ReceivedAmount = (Decimal)responseInvoice.get('EIP_ReceivedAmount');
        EIP_InvoiceDifference = (Decimal)responseInvoice.get('EIP_InvoiceDifference');
        EIP_TransfertThirdParty = (Boolean)responseInvoice.get('EIP_TransfertThirdParty');
        
        for(Object item : (List<Object>) responseInvoice.get('EIP_InvoiceAmountFee')){                        
            system.debug('item = '+ item);
            L_InvoiceAmountFee.add(JSON.serialize(item));
        }
        system.debug('L_InvoiceAmountFee = '+L_InvoiceAmountFee);
        
        Decimal EIP_ThirdPartyFeeAmount,EIP_BankingFeeAmount, EIP_OtherFeeAmount;
        String EIP_OtherFeeDescription;
    
        EIP_InvoiceAmountFee = JSON.serialize(new SettingInvoiceFee(EIP_FeeName , EIP_FeeAmount));
        system.debug('EIP_InvoiceAmountFee ' + EIP_InvoiceAmountFee);
        
        SettingInvoiceHistoric Object_Param = new SettingInvoiceHistoric(SF_AccountId,SF_HistoryBuyoutId,IL_ContractNumber,x_CustId,IL_Langue,x_ActiveDirectoryName,
                                  EIP_InvoiceNumber,EIP_InvoiceDate,EIP_HistoricType, EIP_Comment,DMS_DocType,DMS_DocLink,L_InvoiceAmountFee,EIP_InvoiceAmount,
                                  EIP_BuyoutAmount,EIP_TotalFee,EIP_InvoicePST,EIP_InvoiceGST,EIP_InvoiceHST,EIP_ReceivedAmount,EIP_InvoiceDifference, EIP_TransfertThirdParty);
        
        return Object_Param;
        
    }

}