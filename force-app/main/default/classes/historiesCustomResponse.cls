public class historiesCustomResponse {
    
    public String historyId;
     public String parentHistoryId;
        public String API_Error_Msg;
        
        public historiesCustomResponse( String id,String parentHistoryId,String error){ //Account_Verification.CustomAccountResponse ac, String error){
                this.historyId = id;
                this.parentHistoryId = parentHistoryId;
                this.API_Error_Msg = error;
        }
}