// test class for MS_Salesforce_UpdateAccount_WS
@isTest
public class MS_Salesforce_UpdateAccount_WSTest {
    @testSetup
    public static void createTestRecords(){
        Account acctRecord = new Account();
        acctRecord.Name = 'New Microserv Account' + Integer.valueOf(Math.random() * 100);
        acctRecord.Phone = '7987999889';
        acctRecord.Compagnie_Email__c = 'microserv@gmail.com';
        acctRecord.Description = 'New Account Description' + Integer.valueOf(Math.random() * 100);
        acctRecord.MDM_ID__c = '456456';
        acctRecord.Contact_Principal__c = 'test contact'+ Integer.valueOf(Math.random() * 100);
        INSERT acctRecord;
        
        Contact contRecord = new Contact();
        contRecord.AccountId = acctRecord.Id;
        contRecord.LastName = 'test contact' + Integer.valueOf(Math.random() * 100);
        contRecord.Email = 'testmicroserv@gmail.com';
        contRecord.Title = 'Test Title' + Integer.valueOf(Math.random() * 100);
        contRecord.MobilePhone = '5454654500';
        INSERT contRecord;
        
    }
    
   // @testSetup
    public static StringValueRequest buildItemValue( String item, String roll, String reason, Boolean v, Boolean e){
        
        StringValueRequest sValue = new StringValueRequest();
        sValue.ItemValue = item;
        sValue.RollbackValue = roll;
        sValue.Reason = 'This is an error';
        sValue.IsValid = v;
        sValue.RollbackExist = e;
        
        
        return sValue;
    }
    
     public static ConfirmationRequest buldConfirmation(String ResourceName, String SystemId, String SystemSource, String RequestedAction, String ErrorMessage, Boolean Succeeded){
        
    ConfirmationRequest conf = new ConfirmationRequest();
        conf.ResourceName = ResourceName;
        conf.SystemId = SystemId;
        conf.SystemSource = SystemSource;
        conf.RequestedAction = RequestedAction;
        conf.ErrorMessage = ErrorMessage;
        conf.Succeeded = Succeeded;
          
        return conf;
    }
    
    
    
    public static StringValueRequest buildRollbackValue( String s){
        
        StringValueRequest sValue = new StringValueRequest();
        sValue.RollbackValue = s;
        
        
        return sValue;
    }
    
    
     public static StringValueRequest buildIsValid( String s, Boolean b){
        
        StringValueRequest sValue = new StringValueRequest();
        sValue.Reason = 'This is an error';
        sValue.IsValid = b;
          sValue.ItemValue = s;
        
        
        return sValue;
    }
    
    public static StringValueRequest buildRollbackExist(String s, Boolean b){
        
        StringValueRequest sValue = new StringValueRequest();
        sValue.RollbackExist = b;
        sValue.RollbackValue = s;
        
        
        return sValue;
    }
    
    
    public static SystemLocalRequest buildSystemLocal( String s){
        
        SystemLocalRequest sValue = new SystemLocalRequest();
        sValue.Id = s;
        
        
        return sValue;
    }
    
    public static account getAcoount(){
         Account acct = [SELECT Id FROM Account where name = 'TOTOT LTD.' LIMIT 1];
        
        return acct;
    }
    
/*    public static SystemLocalRequest[] buildItemDestination(){
        
        StringValueRequest sValue = new StringValueRequest();
        sValue[0].ItemValue = s;
        
        return sValue;
    }*/
        
    
    
    
    @isTest
    public static void testUpdateAccountWS(){
       // Account acct = getAcoount();
        Account acct = [SELECT Id FROM Account LIMIT 1];
        Contact cont = [SELECT Id,Name FROM Contact LIMIT 1];
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        
        
        
        StringValueRequest emailval = new StringValueRequest();
        emailval = buildItemValue('test@test.com', 'test@test.com', null, true, false); 
        StringValueRequest phoneval = new StringValueRequest();
        phoneval = buildItemValue('9898797900', '98987979', null, false, true);
        StringValueRequest faxval = new StringValueRequest();
        faxval = buildItemValue('456521332', '456521332', null, true, false);
        StringValueRequest contval = new StringValueRequest();
        contval = buildItemValue(cont.Name, null, null, true, false);
        StringValueRequest TollFreeval = new StringValueRequest();
        TollFreeval = buildItemValue('45466656', null, null, true, false);
        StringValueRequest nameval = new StringValueRequest();
        nameval = buildItemValue('New Alban Account' + Integer.valueOf(Math.random() * 100), null, null, true, false);
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
        AccountManagerval = buildItemValue('test', null, null, true, false);
        StringValueRequest WebsiteUrlval = new StringValueRequest();
        WebsiteUrlval = buildItemValue('test.com', null, null, true, false);
        StringValueRequest YearEstablishedval = new StringValueRequest();
        YearEstablishedval = buildItemValue('2001', null, null, true, false);
        
        //////////////////////////////////////
        //
         StringValueRequest emailval1 = new StringValueRequest();
        emailval1 = buildItemValue('test@test.com', null, 'need update', false, true); 
        StringValueRequest phoneval1 = new StringValueRequest();
        phoneval1 = buildItemValue('9898797900', '9898797900', 'need update', false, true);
        StringValueRequest faxval1 = new StringValueRequest();
        faxval1 = buildItemValue('456521332', '456521332', null, false, true);
        StringValueRequest contval1 = new StringValueRequest();
        contval1 = buildItemValue(cont.Name, cont.Name, null, false, true);
        StringValueRequest TollFreeval1 = new StringValueRequest();
        TollFreeval1 = buildItemValue('4546665600', '4546665600', null, false, true);
        StringValueRequest nameval1 = new StringValueRequest();
        nameval1 = buildItemValue('New Alban Account' + Integer.valueOf(Math.random() * 100), 'New Alban Account' + Integer.valueOf(Math.random() * 100), null, false, true);
        StringValueRequest bnameval1 = new StringValueRequest();
        bnameval1 = buildItemValue('New Account Business', 'New Account Business', null, false, true);
        StringValueRequest streetval1 = new StringValueRequest();
        streetval1 = buildItemValue('Alberta Road', 'Alberta Road', null, false, true);
        StringValueRequest Countryval1 = new StringValueRequest();
        Countryval1 = buildItemValue('Canada', 'Canada', null,  false, true);
        StringValueRequest CountryCodeval1 = new StringValueRequest();
        CountryCodeval1 = buildItemValue('CA', 'CA', null, false, true);
        StringValueRequest Cityval1 = new StringValueRequest();
        Cityval1 = buildItemValue('Montreal', 'Montreal', null, false, true);
        StringValueRequest Provinceval1 = new StringValueRequest();
        Provinceval1 = buildItemValue('Quebec', 'Quebec', null, false, true);
        StringValueRequest ProvinceCodeval1 = new StringValueRequest();
        ProvinceCodeval1 = buildItemValue('QC', 'QC', null, false, true);
        StringValueRequest PostalCodeval1 = new StringValueRequest();
        PostalCodeval1 = buildItemValue('PC' + Integer.valueOf(Math.random() * 1000), 'PC' + Integer.valueOf(Math.random() * 1000), null, false, true);
        StringValueRequest AccountManagerval1 = new StringValueRequest();
        AccountManagerval1 = buildItemValue('test', 'test', null, false, true);
        StringValueRequest WebsiteUrlval1 = new StringValueRequest();
        WebsiteUrlval1 = buildItemValue('test.com', 'test.com', null, false, true);
        StringValueRequest YearEstablishedval1 = new StringValueRequest();
        YearEstablishedval1 = buildItemValue('2001', '2010', null, false, true);
        
        SystemLocalRequest SourceSystemval = new SystemLocalRequest();
        SourceSystemval = buildSystemLocal(acct.Id);
        
        
        
        VendorRequest vendor = new VendorRequest();
        vendor.MDMID = 456456;
        vendor.AccountEmailAddress = emailval;
        vendor.Phone = phoneval;
        vendor.Fax = faxval;
        vendor.MainContact = contval;
        vendor.TollFreePhone = TollFreeval;
        vendor.LegalName = nameval;
        vendor.BusinessName = bnameval;
        vendor.BillingStreet = streetval;
        
        vendor.SourceSystem = SourceSystemval;
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
        
        MS_Salesforce_UpdateAccount_WS.UpdateAccount(vendor);
        acct = [SELECT Id,MDM_ID__c FROM Account LIMIT 1];
        
        
         ConfirmationRequest conf = new ConfirmationRequest();
        conf = buldConfirmation('Vendor', acct.Id, '3', 'Update', '', true);
          MS_Salesforce_Confirmation_WS.GetConfirmation(conf);
        
        system.debug(' ---   le compte est ----'+acct);
        
        System.assertEquals('456456', acct.MDM_ID__c);
        System.assertEquals(200, RestContext.response.statusCode); 
        
        
        VendorRequest vendorRoll = new VendorRequest();
        vendorRoll.MDMID = 456456;
        vendorRoll.AccountEmailAddress = emailval1;
        vendorRoll.Phone = phoneval1;
        vendorRoll.Fax = faxval1;
        vendorRoll.MainContact = contval1;
        vendorRoll.TollFreePhone = TollFreeval1;
        vendorRoll.LegalName = nameval1;
        vendorRoll.BusinessName = bnameval1;
        vendorRoll.BillingStreet = streetval1;
        vendorRoll.SourceSystem = SourceSystemval;
        vendorRoll.AccountManager = AccountManagerval1;
        vendorRoll.BillingCity = Cityval1;
        vendorRoll.BillingProvince = Provinceval1;
        vendorRoll.BillingProvinceCode = ProvinceCodeval1;
        vendorRoll.BillingCountry = Countryval1;
        vendorRoll.BillingCountryCode = CountryCodeval1;
        vendorRoll.BillingPostalCode = PostalCodeval1;
        vendorRoll.ShippingStreet = streetval1;
        vendorRoll.ShippingCity = Cityval1;
        vendorRoll.ShippingProvince = Provinceval1;
        vendorRoll.ShippingProvinceCode = ProvinceCodeval1;
        vendorRoll.ShippingCountry = Countryval1;
         vendorRoll.ShippingCountryCode = CountryCodeval1;
        vendorRoll.ShippingPostalCode = PostalCodeval1;
        vendorRoll.YearEstablished = YearEstablishedval1;
        vendorRoll.WebsiteUrl = WebsiteUrlval1;
        
        MS_Salesforce_UpdateAccount_WS.UpdateAccount(vendorRoll);
        acct = [SELECT Id,MDM_ID__c FROM Account LIMIT 1];
        
        system.debug(' ---   le compte est ----'+acct);
        
        System.assertEquals('456456', acct.MDM_ID__c);
       // System.assertEquals(200, RestContext.response.statusCode); 
        
    //////////////////////////////////////////////////////////////////////////////////////
    //    
       VendorRequest vendorerr = new VendorRequest();
        
        StringValueRequest contvalerr3 = new StringValueRequest();
        contvalerr3 = buildItemValue(null, null, null, true, true);
        
        vendorerr.MDMID = 456456;
        vendorerr.AccountEmailAddress = emailval;
        vendorerr.Phone = phoneval;
        vendorerr.Fax = faxval;
        vendorerr.MainContact = contvalerr3;
        vendorerr.TollFreePhone = TollFreeval;
        vendorerr.LegalName = contvalerr3;
        vendorerr.BusinessName = bnameval;
        vendorerr.BillingStreet = streetval;
        vendorerr.SourceSystem = SourceSystemval;
         vendorerr.AccountManager = AccountManagerval;
        vendorerr.BillingCity = Cityval;
        vendorerr.BillingProvince = Provinceval;
        vendorerr.BillingProvinceCode = ProvinceCodeval;
        vendorerr.BillingCountry = Countryval;
        vendorerr.BillingCountryCode = CountryCodeval;
        vendorerr.BillingPostalCode = PostalCodeval;
        vendorerr.ShippingStreet = streetval;
        vendorerr.ShippingCity = Cityval;
        vendorerr.ShippingProvince = Provinceval;
        vendorerr.ShippingProvinceCode = ProvinceCodeval;
        vendorerr.ShippingCountry = Countryval;
         vendorerr.ShippingCountryCode = CountryCodeval;
        vendorerr.ShippingPostalCode = PostalCodeval;
         vendorerr.YearEstablished = YearEstablishedval;
        vendorerr.WebsiteUrl = WebsiteUrlval;
        
        MS_Salesforce_UpdateAccount_WS.UpdateAccount(vendorerr);
        acct = [SELECT Id,MDM_ID__c FROM Account LIMIT 1];
        
        system.debug(' ---   le compte est ----'+acct);
        
        System.assertEquals('456456', acct.MDM_ID__c);  
        
        
        
       
       // Update with no valide information
        
        StringValueRequest faxvalIsErr = new StringValueRequest();
        faxvalIsErr = buildItemValue('45652','456456','need update', false, true);
        
        StringValueRequest contvalerr = new StringValueRequest();
        contvalerr = buildItemValue('test ', null, null, true, true);
       
        
        VendorRequest vendor4 = new VendorRequest();
        vendor4.MDMID = 456456;
        vendor4.AccountEmailAddress = emailval;
        vendor4.Phone = phoneval;
        vendor4.Fax = faxvalIsErr;
        vendor4.MainContact = contval;
        vendor4.TollFreePhone = TollFreeval;
        vendor4.LegalName = nameval;
        vendor4.BusinessName = bnameval;
        vendor4.BillingStreet = streetval;
        
        vendor4.SourceSystem = SourceSystemval;
         vendor4.AccountManager = AccountManagerval;
        vendor4.BillingCountry = Countryval;
        vendor4.BillingCountryCode = CountryCodeval;
        vendor4.BillingCity = Cityval;
        vendor4.BillingProvince = Provinceval;
        vendor4.BillingProvinceCode = ProvinceCodeval;        
        vendor4.BillingPostalCode = PostalCodeval;
        vendor4.ShippingStreet = streetval;
        vendor4.ShippingCity = Cityval;
        vendor4.ShippingProvince = Provinceval;
         vendor4.ShippingProvinceCode = ProvinceCodeval;
         vendor4.ShippingCountry = Countryval;
         vendor4.ShippingCountryCode = CountryCodeval;
        vendor4.ShippingPostalCode = PostalCodeval;
        vendor4.YearEstablished = YearEstablishedval;
        vendor4.WebsiteUrl = WebsiteUrlval;
        
        MS_Salesforce_UpdateAccount_WS.UpdateAccount(vendor4);
        
        System.assertEquals('456456', acct.MDM_ID__c);
        
      //  System.assertEquals(200, RestContext.response.statusCode);
      
     
        // when MDM value is different
    
        VendorRequest vendor3 = new VendorRequest();
        
         StringValueRequest contvalerr1 = new StringValueRequest();
        contvalerr1 = buildItemValue(null, 'test ', null, true, false);
        
        vendor3.MDMID = 11111;
        vendor3.AccountEmailAddress = emailval;
        vendor3.Phone = phoneval;
        vendor3.Fax = faxval;
        vendor3.MainContact = contvalerr1;
        vendor3.TollFreePhone = TollFreeval;
        vendor3.LegalName = nameval;
        vendor3.BusinessName = bnameval;
        vendor3.BillingStreet = streetval;
        
        vendor3.SourceSystem = SourceSystemval;
         vendor3.AccountManager = AccountManagerval;
        vendor3.BillingCity = Cityval;
        vendor3.BillingProvince = Provinceval;
        vendor3.BillingProvinceCode = ProvinceCodeval;
        vendor3.BillingCountry = Countryval;
         vendor3.BillingCountryCode = CountryCodeval;
        vendor3.BillingPostalCode = PostalCodeval;
        vendor3.ShippingStreet = streetval;
        vendor3.ShippingCity = Cityval;
        vendor3.ShippingProvince = Provinceval;
        vendor3.ShippingProvinceCode = ProvinceCodeval;
        vendor3.ShippingCountry = Countryval;
        vendor3.ShippingCountryCode = CountryCodeval;
        vendor3.ShippingPostalCode = PostalCodeval;
        vendor3.YearEstablished = YearEstablishedval;
        vendor3.WebsiteUrl = WebsiteUrlval;
        
         MS_Salesforce_UpdateAccount_WS.UpdateAccount(vendor3);
        acct = [SELECT Id,MDM_ID__c FROM Account LIMIT 1];
        
      //  System.assertEquals('11111', acct.MDM_ID__c);
      //  System.assertEquals(400, RestContext.response.statusCode);
        
        
       
        
         // when account id is blank
        SystemLocalRequest SourceSystemvalEmpty = new SystemLocalRequest();
        SourceSystemvalEmpty = buildSystemLocal('');
        
        VendorRequest vendor2 = new VendorRequest();
        
        vendor2.MDMID = 456456;
        vendor2.AccountEmailAddress = emailval;
        vendor2.Phone = phoneval;
        vendor2.Fax = faxval;
        vendor2.MainContact = contval;
        vendor2.TollFreePhone = TollFreeval;
        vendor2.LegalName = nameval;
        vendor2.BusinessName = bnameval;
        vendor2.BillingStreet = streetval;
        vendor2.AccountManager = AccountManagerval;
        vendor2.BillingCity = Cityval;
        vendor2.BillingProvince = Provinceval;
        vendor2.BillingProvinceCode = ProvinceCodeval;
        vendor2.BillingCountry = Countryval;
        vendor2.BillingCountryCode = CountryCodeval;
        vendor2.BillingPostalCode = PostalCodeval;
        vendor2.ShippingStreet = streetval;
        vendor2.ShippingCity = Cityval;
        vendor2.ShippingProvince = Provinceval;
        vendor2.ShippingProvinceCode = ProvinceCodeval;
        vendor2.ShippingCountry = Countryval;
         vendor2.ShippingCountryCode = CountryCodeval;
        vendor2.ShippingPostalCode = PostalCodeval;
        vendor2.YearEstablished = YearEstablishedval;
        vendor2.WebsiteUrl = WebsiteUrlval;
        
        vendor2.SourceSystem = SourceSystemvalEmpty; //DestinationSystems[0].Id = '';
        MS_Salesforce_UpdateAccount_WS.UpdateAccount(vendor2);
        
        
        ConfirmationRequest conf1 = new ConfirmationRequest();
        conf1 = buldConfirmation('Vendor', null, '3', 'Insert', 'test', true);
          MS_Salesforce_Confirmation_WS.GetConfirmation(conf1);
     
        System.assertEquals(400, RestContext.response.statusCode);
    
        
        SystemLocalRequest SourceSystemvalFalse = new SystemLocalRequest();
        SourceSystemvalFalse = buildSystemLocal('test');
        
       
         VendorRequest vendor1 = new VendorRequest();
        
        vendor1.MDMID = 456456;
        vendor1.AccountEmailAddress = emailval;
        vendor1.Phone = phoneval;
        vendor1.Fax = faxval;
        vendor1.MainContact = contval;
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
        vendor.ShippingProvince = Provinceval;
        vendor1.ShippingProvinceCode = ProvinceCodeval;
        vendor1.ShippingCountry = Countryval;
         vendor1.ShippingCountryCode = CountryCodeval;
        vendor1.ShippingPostalCode = PostalCodeval;
        vendor1.YearEstablished = YearEstablishedval;
        vendor.WebsiteUrl = null;
        
        vendor1.SourceSystem = SourceSystemvalFalse; //DestinationSystems[0].Id = '';
        MS_Salesforce_UpdateAccount_WS.UpdateAccount(vendor1);
        
        System.assertEquals(500, RestContext.response.statusCode);
        
        Test.stopTest();
    }

}