global with sharing class HistoryCustomResponse {

        //public Account_Verification.CustomAccountResponse Account_Contact_Msg;
        public String historyId;
        public String historyObj;
        public String API_Error_Msg;
        
        public HistoryCustomResponse( String historyId, String historyObj, String error){ //Account_Verification.CustomAccountResponse ac, String error){
                this.historyId = historyId;
                this.historyObj = historyObj;
                this.API_Error_Msg = error;
        }
}