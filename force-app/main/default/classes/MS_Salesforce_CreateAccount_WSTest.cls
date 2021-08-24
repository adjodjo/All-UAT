@isTest
public class MS_Salesforce_CreateAccount_WSTest {
    
    @testSetup
    public static void createTestRecords(){
         Account acctRecord = new Account();
        acctRecord.Name = 'New Microserv Account' + Integer.valueOf(Math.random() * 100);
        acctRecord.Phone = '7987999889';
        acctRecord.Compagnie_Email__c = 'microserv@gmail.com';
        acctRecord.Description = 'New Account Description' + Integer.valueOf(Math.random() * 100);
        acctRecord.MDM_ID__c = '456456';
        acctRecord.Contact_Principal__c = 'test contact'+ Integer.valueOf(Math.random() * 100);
     //   INSERT acctRecord;
    
        
        Profile pf= [Select Id from profile where Name='System Administrator'];
        //UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
        
        
        User myUser = new User(
            ProfileId = pf.Id,
            firstName = 'test',
            LastName = 'test',
            Email = 'test@clecapital.ca',
            Username = 'puser0001@clecapital.ca' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            isActive = true,
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = null,
            Account_Manager_Code__c = '00000',
            	EIP_Login_User__c = 'tUser'
            
            
        );
        insert myUser;
        
        Manage_Vendor_RT__c vendorRT = new Manage_Vendor_RT__c();
        vendorRT.RT_Name__c = 'Vendor';
        vendorRT.Enable_RT__c = true;
        insert vendorRT;
    }
    
    // @testSetup
    public static StringValueRequest buildItemValue( String item, String roll, String reason, Boolean v, Boolean e){
        
        StringValueRequest sValue = new StringValueRequest();
        sValue.ItemValue = item;
        sValue.RollbackValue = roll;
        sValue.Reason = null;
        sValue.IsValid = v;
        sValue.RollbackExist = e;
        
        
        return sValue;
    }
    
   
    
    
    public static SystemLocalRequest buildSystemLocal( String s){
        
        SystemLocalRequest sValue = new SystemLocalRequest();
        sValue.Id = s;
        
        
        return sValue;
    }
    
    ////////////////// Custom Setting  ////////////////////////
    
 /*   public static void buildCustomSetting(){
        Manage_Vendor_RT__c vendorRT = new Manage_Vendor_RT__c();
        vendorRT.RT_Name__c = 'Vendor';
        vendorRT.Enable_RT__c = true;
        insert vendorRT;
    }*/
    
    
        
        @isTest
        public static void testCreateAccountWS(){
        //    Account  acct = [SELECT Id,Phone FROM Account LIMIT 1];
        
            Test.startTest();            
      //  System.assertEquals('7987999889', acct.Phone);
                     
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
            
        StringValueRequest emailval = new StringValueRequest();
        emailval = buildItemValue('test@test.com', null, null, true, false); 
        StringValueRequest phoneval = new StringValueRequest();
        phoneval = buildItemValue('98987979', null, null, false, true);
        StringValueRequest faxval = new StringValueRequest();
        faxval = buildItemValue('456521332', null, null, true, false);
        StringValueRequest contval = new StringValueRequest();
        contval = buildItemValue('Martins', null, null, true, false);
        StringValueRequest TollFreeval = new StringValueRequest();
        TollFreeval = buildItemValue('45466656', null, null, true, false);
        StringValueRequest nameval = new StringValueRequest();
        nameval = buildItemValue('New test Account' + Integer.valueOf(Math.random() * 100), null, null, true, false);
        StringValueRequest bnameval = new StringValueRequest();
        bnameval = buildItemValue('New Account Business', null, null, true, false);
        StringValueRequest streetval = new StringValueRequest();
        streetval = buildItemValue('Alberta Road', null, null, true, false);
        StringValueRequest Countryval = new StringValueRequest();
        Countryval = buildItemValue('Canada', null, null, true, false);
        StringValueRequest CountryCodeval = new StringValueRequest();
        CountryCodeval = buildItemValue('CA', null, null, true, false);
        StringValueRequest Cityval = new StringValueRequest();
        Cityval = buildItemValue('Montreal', null, null, true, false);
        StringValueRequest Provinceval = new StringValueRequest();
        Provinceval = buildItemValue('Quebec', null, null, true, false);
        StringValueRequest ProvinceCodeval = new StringValueRequest();
        ProvinceCodeval = buildItemValue('QC', null, null, true, false);
        StringValueRequest PostalCodeval = new StringValueRequest();
        PostalCodeval = buildItemValue('PC' + Integer.valueOf(Math.random() * 1000), null, null, true, false);
        StringValueRequest AccountManagerval = new StringValueRequest();
        AccountManagerval = buildItemValue('test test', null, null, true, false);
        StringValueRequest WebsiteUrlval = new StringValueRequest();
        WebsiteUrlval = buildItemValue('test.com', null, null, true, false);
        StringValueRequest YearEstablishedval = new StringValueRequest();
        YearEstablishedval = buildItemValue('2001', null, null, true, false);
            
        SystemLocalRequest SourceSystemval = new SystemLocalRequest();
        SourceSystemval = buildSystemLocal(null);
            
        VendorRequest vendor = new VendorRequest();
        vendor.SourceSystem = SourceSystemval;    
        vendor.MDMID = 456456;
        vendor.AccountEmailAddress = emailval;
        vendor.Phone = phoneval;
        vendor.Fax = faxval;
        vendor.MainContact = contval;
        vendor.TollFreePhone = TollFreeval;
        vendor.LegalName = nameval;
        vendor.BusinessName = bnameval;
        vendor.BillingStreet = streetval;
        vendor.AccountManager = AccountManagerval;
        vendor.BillingCity = Cityval;
        vendor.BillingProvince = Provinceval;
        vendor.BillingProvinceCode = ProvinceCodeval;
        vendor.BillingCountry = Countryval;
        vendor.BillingCountryCode = CountryCodeval;
        vendor.BillingPostalCode = PostalCodeval;
        vendor.ShippingStreet = streetval;
        vendor.ShippingCity = Cityval;
        vendor.ShippingProvince = Provinceval;
        vendor.ShippingProvinceCode = ProvinceCodeval;
        vendor.ShippingCountry = Countryval;
        vendor.ShippingCountryCode = CountryCodeval;
        vendor.ShippingPostalCode = PostalCodeval;
        vendor.YearEstablished = YearEstablishedval;
        vendor.WebsiteUrl = WebsiteUrlval; 
           
        MS_Salesforce_CreateAccount_WS.CreateAccount(vendor);
            
            MS_Salesforce_CreateAccount_WS.CreateAccount(vendor);
      //  System.assertEquals(200, RestContext.response.statusCode); 
       
       
            
        VendorRequest vendor1 = new VendorRequest();
            
        vendor1.SourceSystem = SourceSystemval;    
        vendor1.MDMID = null;
        vendor1.AccountEmailAddress = emailval;
        vendor1.Phone = phoneval;
        vendor1.Fax = faxval;
        vendor1.MainContact = null; //contval;
        vendor1.TollFreePhone = TollFreeval;
        vendor1.LegalName = nameval;
        vendor1.BusinessName = bnameval;
        vendor1.BillingStreet = streetval;
        vendor1.AccountManager = AccountManagerval;
        vendor1.BillingCity = Cityval;
        vendor1.BillingProvince = Provinceval;
        vendor1.BillingProvinceCode = ProvinceCodeval;
        vendor1.BillingCountry = Countryval;
        vendor1.BillingCountryCode = CountryCodeval;
        vendor1.BillingPostalCode = PostalCodeval;
        vendor1.ShippingStreet = streetval;
        vendor1.ShippingCity = Cityval;
        vendor1.ShippingProvince = Provinceval;
        vendor1.ShippingProvinceCode = ProvinceCodeval;
        vendor1.ShippingCountry = Countryval;
        vendor1.ShippingCountryCode = CountryCodeval;
        vendor1.ShippingPostalCode = PostalCodeval;
        vendor1.YearEstablished = YearEstablishedval;
        vendor1.WebsiteUrl = WebsiteUrlval; 
            
        MS_Salesforce_CreateAccount_WS.CreateAccount(vendor1);
       // System.assertEquals(200, RestContext.response.statusCode);    
       
            ///////////////////////////////////////////////////////////////////////
            //
        SystemLocalRequest SourceSystemval2 = new SystemLocalRequest();
        SourceSystemval2 = buildSystemLocal(null);
            
        StringValueRequest emailval1 = new StringValueRequest();
        emailval1 = buildItemValue('test@test.com', null, null, true, false); 
        StringValueRequest phoneval1 = new StringValueRequest();
        phoneval1 = buildItemValue('98987979', null, null, false, true);
        StringValueRequest faxval1 = new StringValueRequest();
        faxval1 = buildItemValue('456521332', null, null, true, false);
        StringValueRequest contval1 = new StringValueRequest();
        contval1 = buildItemValue(null, null, null, true, false);
        StringValueRequest TollFreeval1 = new StringValueRequest();
        TollFreeval1 = buildItemValue('45466656', null, null, true, false);
        StringValueRequest nameval1 = new StringValueRequest();
        nameval1 = buildItemValue('New Microserv Account' + Integer.valueOf(Math.random() * 100), null, null, true, false);
        StringValueRequest bnameval1 = new StringValueRequest();
        bnameval1 = buildItemValue('New Account Business', null, null, true, false);
        StringValueRequest streetval1 = new StringValueRequest();
        streetval1 = buildItemValue('Alberta Road', null, null, true, false);
        StringValueRequest Countryval1 = new StringValueRequest();
        Countryval1 = buildItemValue('Canada', null, null, true, false);
        StringValueRequest CountryCodeval1 = new StringValueRequest();
        CountryCodeval1 = buildItemValue('CA', null, null, true, false);
        StringValueRequest Cityval1 = new StringValueRequest();
        Cityval1 = buildItemValue('Montreal', null, null, true, false);
        StringValueRequest Provinceval1 = new StringValueRequest();
        Provinceval1 = buildItemValue('Quebec', null, null, true, false);
        StringValueRequest ProvinceCodeval1 = new StringValueRequest();
        ProvinceCodeval1 = buildItemValue('QC', null, null, true, false);
        StringValueRequest PostalCodeval1 = new StringValueRequest();
        PostalCodeval1 = buildItemValue('PC' + Integer.valueOf(Math.random() * 1000), null, null, true, false);
        StringValueRequest AccountManagerval1 = new StringValueRequest();
        AccountManagerval1 = buildItemValue('Martins Paul', null, null, true, false);
        StringValueRequest WebsiteUrlval1 = new StringValueRequest();
        WebsiteUrlval1 = buildItemValue('test.com', null, null, true, false);
        StringValueRequest YearEstablishedval1 = new StringValueRequest();
        YearEstablishedval1 = buildItemValue('2001', null, null, true, false);
            
        VendorRequest vendor2 = new VendorRequest();
            
        vendor2.SourceSystem = SourceSystemval2;    
        vendor2.MDMID = 223366;
        vendor2.AccountEmailAddress = emailval1;
        vendor2.Phone = phoneval1;
        vendor2.Fax = faxval1;
        vendor2.MainContact = contval1; //contval;
        vendor2.TollFreePhone = TollFreeval1;
        vendor2.LegalName = nameval1;
        vendor2.BusinessName = bnameval1;
        vendor2.BillingStreet = streetval1;
        vendor2.AccountManager = AccountManagerval1;
        vendor2.BillingCity = Cityval1;
        vendor2.BillingProvince = Provinceval1;
        vendor2.BillingProvinceCode = ProvinceCodeval1;
        vendor2.BillingCountry = Countryval1;
        vendor2.BillingCountryCode = CountryCodeval1;
        vendor2.BillingPostalCode = PostalCodeval1;
        vendor2.ShippingStreet = streetval1;
        vendor2.ShippingCity = Cityval1;
        vendor2.ShippingProvince = Provinceval1;
        vendor2.ShippingProvinceCode = ProvinceCodeval1;
        vendor2.ShippingCountry = Countryval1;
        vendor2.ShippingCountryCode = CountryCodeval1;
        vendor2.ShippingPostalCode = PostalCodeval1;
        vendor2.YearEstablished = YearEstablishedval1;
        vendor2.WebsiteUrl = WebsiteUrlval1; 
            
            
        MS_Salesforce_CreateAccount_WS.CreateAccount(vendor2);
      //  System.assertEquals(200, RestContext.response.statusCode);        
        
            
            VendorRequest vendor3 = new VendorRequest();
            
        vendor3.SourceSystem = SourceSystemval2;    
        vendor3.MDMID = 223366;
        vendor3.AccountEmailAddress = emailval1;
        vendor3.Phone = phoneval1;
        vendor3.Fax = faxval1;
        vendor3.MainContact = contval1; //contval;
        vendor3.TollFreePhone = TollFreeval1;
        vendor3.LegalName = null;
        vendor3.BusinessName = bnameval1;
        vendor3.BillingStreet = streetval1;
        vendor3.AccountManager = AccountManagerval1;
        vendor3.BillingCity = Cityval1;
        vendor3.BillingProvince = Provinceval1;
        vendor3.BillingProvinceCode = ProvinceCodeval1;
        vendor3.BillingCountry = null;
        vendor3.BillingCountryCode = CountryCodeval1;
        vendor3.BillingPostalCode = PostalCodeval1;
        vendor3.ShippingStreet = streetval1;
        vendor3.ShippingCity = Cityval1;
        vendor3.ShippingProvince = Provinceval1;
        vendor3.ShippingProvinceCode = ProvinceCodeval1;
        vendor3.ShippingCountry = Countryval1;
        vendor3.ShippingCountryCode = CountryCodeval1;
        vendor3.ShippingPostalCode = PostalCodeval1;
        vendor3.YearEstablished = YearEstablishedval1;
        vendor3.WebsiteUrl = WebsiteUrlval1; 
            
            
        MS_Salesforce_CreateAccount_WS.CreateAccount(vendor3);
            
            
            
            
            
            Test.stopTest();
        }

}