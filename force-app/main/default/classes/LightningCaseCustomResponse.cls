public class LightningCaseCustomResponse {
    
     public String etat;
     public String origin;
    public String contract;
    public String account;
    public String errMsg;
    public LightningCaseCustomResponse( String etat, String origin, String contract, String account, String errMsg){ //Account_Verification.CustomAccountResponse ac, String error){
                this.etat = etat;
                this.origin = origin;
        		this.contract = contract;
        		this.account = account;
        		this.errMsg = errMsg;
        }

}