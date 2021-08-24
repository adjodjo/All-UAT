public class Manage_Invoice_Fee {
    
    
    public static void ManageFee(String invoiceId, List<String> InvoiceFee){
       
        Decimal EIP_ThirdPartyFeeAmount, EIP_BankingFeeAmount, EIP_FeeAmount;
        String EIP_FeeName;
        Map<String, Object> responseInvoice;
        
        List<Invoice_Fee__c> invoiceFeeList = new List<Invoice_Fee__c>();
        system.debug('InvoiceFee = '+InvoiceFee);
        try{
        
        for(String s :InvoiceFee ){
            
            system.debug('Autre InvoiceFee = '+s);
             system.debug('responseInvoice = '+responseInvoice);
            responseInvoice = (Map<String, Object>) JSON.deserializeUntyped(s);
            
            system.debug('responseInvoice = '+responseInvoice);
            EIP_FeeAmount = (Decimal)responseInvoice.get('EIP_FeeAmount');
            EIP_FeeName = (String)responseInvoice.get('EIP_FeeName');
            system.debug('EIP_FeeAmount = '+EIP_FeeAmount+ 'EIP_FeeName = '+EIP_FeeName);
            Invoice_Fee__c thisInvoiceFee = new Invoice_Fee__c(
                Historic_Invoice__c = invoiceId,
                Fee_Name__c = EIP_FeeName,
                fee_Amount__c = EIP_FeeAmount
               ); 
            invoiceFeeList.add(thisInvoiceFee);
        }
        
        system.debug('invoiceFeeList = '+invoiceFeeList);
                upsert invoiceFeeList;
         
         }catch(Exception ex){
            String err_Msg = ex.getMessage();
             system.debug('err_Msg = '+err_Msg);
        }
        
    }

}