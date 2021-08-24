public class SettingInvoiceFee {
    
    //public String SF_InvoiceHistoryId;
    public String EIP_FeeName;
    public Decimal EIP_FeeAmount;
    
    public SettingInvoiceFee(String EIP_FeeName, Decimal EIP_FeeAmount){
        
       // this.SF_InvoiceHistoryId = SF_InvoiceHistoryId;
       
        this.EIP_FeeName = EIP_FeeName;
        this.EIP_FeeAmount = EIP_FeeAmount;
        
        
    }

}