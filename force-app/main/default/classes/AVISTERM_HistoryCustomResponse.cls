global with sharing class AVISTERM_HistoryCustomResponse {
    
    public String avistermHistoryId;
    	public String ParentHistoryId;
        public String API_Error_Msg;
        
        public AVISTERM_HistoryCustomResponse( String avistermHistoryId, String ParentHistoryId, String API_Error_Msg){ 
            this.avistermHistoryId = avistermHistoryId;    
            this.ParentHistoryId = ParentHistoryId;
            this.API_Error_Msg = API_Error_Msg;
        }

}