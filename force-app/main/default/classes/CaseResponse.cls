global with sharing class CaseResponse {
/*    public String CaseId;
    public String AccountId;
    public String ContractNumber;
    public String Account_Phone;
    public String Account_Name;
    public String API_Error_Msg;
    
        public CaseResponse( String CaseId, String AccountId, String ContractNumber, String Account_Phone, String Account_Name, String API_Error_Msg ){ //Account_Verification.CustomAccountResponse ac, String error){
                
            this.CaseId = CaseId;
            this.AccountId = AccountId;
            this.Account_Phone = Account_Phone;
            this.ContractNumber = ContractNumber;
            this.Account_Name = Account_Name;
            this.API_Error_Msg = API_Error_Msg;
        }
*/
    public String caseId;
        public String caseNumber;
        public String ErrorMessage ;
        
        public CaseResponse( String caseId, String caseNumber, String ErrorMessage ){ //Account_Verification.CustomAccountResponse ac, String error){
                this.caseId = caseId;
                this.caseNumber = caseNumber;
                this.ErrorMessage  = ErrorMessage ;
        }

}