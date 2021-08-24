global with sharing class SendCustomResponse {
      
      public String API_Error_Msg;
        
        public SendCustomResponse( String error){ //Account_Verification.CustomAccountResponse ac, String error){
                
                this.API_Error_Msg = error;
        }

}