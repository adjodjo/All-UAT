global with sharing class CustomResponse {

        //public Account_Verification.CustomAccountResponse Account_Contact_Msg;
        public String Id;
        public String Obj;
        public String API_Error_Msg;
        
        public CustomResponse( String ac, String Obj, String API_Error_Msg){ //Account_Verification.CustomAccountResponse ac, String error){
                this.Id = ac;
                this.Obj = Obj;
                this.API_Error_Msg = API_Error_Msg;
        } 
}