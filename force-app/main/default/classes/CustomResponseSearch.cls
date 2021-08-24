global with sharing class CustomResponseSearch {

    //public Account_Verification.CustomAccountResponse Account_Contact_Msg;
        public String Id;
        public String Name;
        public String Phone;
        public String ContactPrincipal; 
        public String CompagnieEmail; 
        public String BillingStreet; 
        public String BillingCity; 
        public String BillingState; 
        public String BillingPostalCode; 
        public String BillingCountry;
        public String accRecordType;
    public String SF_AccountOwner;
    public Boolean SF_IsStrategic;
        
        public CustomResponseSearch( String id, String name, String phone, String principal, String mail, String street, String city,String state, String postal, String country, String accRecordType, String SF_AccountOwner, Boolean SF_IsStrategic){ //Account_Verification.CustomAccountResponse ac, String error){
                this.Id = id;
                this.Name = name;
                this.Phone = phone;
                this.ContactPrincipal = principal;                     
                this.CompagnieEmail = mail; 
                this.BillingStreet = street; 
                this.BillingCity = city; 
                this.BillingState = state; 
                this.BillingPostalCode = postal; 
                this.BillingCountry = country;
             this.accRecordType = accRecordType;
            this.SF_AccountOwner = SF_AccountOwner;
            this.SF_IsStrategic = SF_IsStrategic;
        }
}