global class CustomEIPInformations {
    
    public String description;
    public String buyoutType;
    public String partialType;
    public String ContactId;
    public String Error_Msg;
    public String userId;
    public String userEmail;
    

    global CustomEIPInformations( String description, String buyoutType,String partialType, String ContactId, String Error_Msg, String userId, String userEmail){

        this.description = description;
        this.buyoutType = buyoutType;
        this.partialType = partialType;
        this.ContactId = ContactId;
        this.Error_Msg = Error_Msg;
        this.userId = userId;
        this.userEmail = userEmail;

    }
}