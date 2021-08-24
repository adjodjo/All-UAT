global with sharing class Invoice_HistoryCustomResponse {
    
    public String InvoiceHistoryId;
    public String API_Error_Msg;
        
        public Invoice_HistoryCustomResponse( String InvoiceHistoryId, String API_Error_Msg){ 
            this.InvoiceHistoryId = InvoiceHistoryId; 
            this.API_Error_Msg = API_Error_Msg;
        }

}