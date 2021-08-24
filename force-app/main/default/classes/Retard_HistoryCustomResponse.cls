global with sharing class Retard_HistoryCustomResponse {
    
    	public String RetardHistoryId;
    	public String ParentHistoryId;
        public String API_Error_Msg;
        
        public Retard_HistoryCustomResponse( String RetardHistoryId, String ParentHistoryId, String API_Error_Msg){ 
            this.RetardHistoryId = RetardHistoryId;    
            this.ParentHistoryId = ParentHistoryId;
            this.API_Error_Msg = API_Error_Msg;
        }

}