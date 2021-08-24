global class Other_HistoryCustomResponse {
    
    public String OtherHistoryId;
    public String ParentHistoryId;
   	public String API_Error_Msg;
        
        public Other_HistoryCustomResponse( String OtherHistoryId, String ParentHistoryId,  String API_Error_Msg){ 
            this.OtherHistoryId = OtherHistoryId;    
            this.ParentHistoryId = ParentHistoryId;
            this.API_Error_Msg = API_Error_Msg;
        }


}