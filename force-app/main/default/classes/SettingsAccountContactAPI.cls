Global with sharing class SettingsAccountContactAPI {


    public String eipAccountName;
    public String eipAccountUsualName;
    public String eipAccountPostalCode;
    public String eipAccountBillingCity;
    public String eipAccountBillingStreet;
    public String eipAccountBillingState;
    public String eipAccountBillingCountry;
    public String eipAccountPhone;
    public String eipAccountEmail;
    public String eipContactEmail;
    public String eipContactName;
    public String eipContactPhone;
    public String eipActiveDirectoryName;

    public SettingsAccountContactAPI(String eipAccountName,String eipAccountUsualName, String eipAccountPostalCode, String eipAccountBillingCity, 
                                String eipAccountBillingStreet, String eipAccountBillingState,String eipAccountBillingCountry,
                                String eipAccountPhone, String eipAccountEmail, String eipContactEmail, String eipContactName, String eipContactPhone, String eipActiveDirectoryName){

                this.eipAccountName = eipAccountName;
                this.eipAccountUsualName = eipAccountUsualName;
                this.eipAccountPostalCode = eipAccountPostalCode;
                this.eipAccountBillingCity = eipAccountBillingCity;
                this.eipAccountBillingStreet = eipAccountBillingStreet;
                this.eipAccountBillingState = eipAccountBillingState;
                this.eipAccountBillingCountry = eipAccountBillingCountry;
                this.eipAccountPhone = eipAccountPhone;
                this.eipAccountEmail = eipAccountEmail;
                this.eipContactEmail = eipContactEmail;
                this.eipContactName = eipContactName;
                this.eipContactPhone = eipContactPhone;
                this.eipActiveDirectoryName = eipActiveDirectoryName;
                                }
}