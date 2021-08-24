public class CaseMetricsCustomResponse {
    
    public String createdTime;
    public String assignTime;    
    public String pendingTime;
    
    public CaseMetricsCustomResponse( String createdTime, String assignTime,  String pendingTime){ //Account_Verification.CustomAccountResponse ac, String error){
        
        
        this.createdTime = createdTime;
        this.assignTime = assignTime;
        this.pendingTime = pendingTime;
               
        }

}