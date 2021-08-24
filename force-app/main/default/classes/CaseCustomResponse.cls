global class CaseCustomResponse {
    
    public String caseId;
    public String caseNumber;
    public String API_Error_Msg ;
        
    
    global CaseCustomResponse( String caseId, String caseNumber, String API_Error_Msg){ //Account_Verification.CustomAccountResponse ac, String error){
       
        this.caseId = caseId;
        this.caseNumber = caseNumber;
        this.API_Error_Msg  = API_Error_Msg ;
    }

}