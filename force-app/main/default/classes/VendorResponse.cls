public class VendorResponse {
    
    public Integer MDMID { get; set;}
    public Value AccountEmailAddress { get; set; }
    public Value BusinessName { get; set;}
    
    public Value Phone { get; set;}
    public Value Fax { get; set;}
    public Value TollFreePhone { get; set;}
    
    public SystemValue SourceSystem { get; set; }
    public SystemValue[] DestinationSystems { get; set; }
   
    public Value LegalName { get; set;}    
    public Value BillingStreet { get; set;}
    public Value BillingCity { get; set;}
    public Value BillingProvince { get; set;}
    public Value BillingProvinceCode { get; set; }
    public Value BillingCountry { get; set;}
    public Value BillingCountryCode { get; set; }
    public Value BillingPostalCode { get; set;}
    public Value ShippingStreet { get; set;}
    public Value ShippingCity { get; set;}
    public Value ShippingProvince { get; set;}
    public Value ShippingProvinceCode { get; set; }
    public Value ShippingCountry { get; set;}
    public Value ShippingCountryCode { get; set; }
    public Value ShippingPostalCode { get; set;}    
    public Value MainContact { get; set;}
    public Value AccountManager { get; set;}
    public Value YearEstablished { get; set;}
    public Value WebsiteUrl { get; set;}

}