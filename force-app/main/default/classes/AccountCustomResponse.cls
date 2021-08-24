global with sharing class AccountCustomResponse {

        public String accountId;
        public String accountObj;
        public String API_Error_Msg;
        
        public AccountCustomResponse( String accountId, String accountObj, String error){ //Account_Verification.CustomAccountResponse ac, String error){
                this.accountId = accountId;
                this.accountObj = accountObj;
                this.API_Error_Msg = error;
        }
        
        public AccountCustomResponse( String accountId, String error){ //Account_Verification.CustomAccountResponse ac, String error){
                this.accountId = accountId;
                this.API_Error_Msg = error;
        }
}