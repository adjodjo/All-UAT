global class Welcome_HistoryCustomResponse {
    
    	public String WelcomeHistoryId;
    	public String ParentHistoryId;
        public String API_Error_Msg;
        
        public Welcome_HistoryCustomResponse( String RetardHistoryId, String ParentHistoryId, String API_Error_Msg){ 
           
            this.WelcomeHistoryId = RetardHistoryId;    
            this.ParentHistoryId = ParentHistoryId;
            this.API_Error_Msg = API_Error_Msg;
        }


}