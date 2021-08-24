public class VendorHelper {
    
    public VendorHelper()
    {
    }
    
    //////////  BUILD GET ACCOUNT RESPONSE   /////////////////////////////////////////// 
    
    public VendorResponse BuildAccount(Account account, String contactName) //
    {
        System.debug(' This account Id is---'+account.Id);
        VendorResponse vendor = new VendorResponse();
        String accManager;
        
        // Get Main Contact from Contact object
        String mainContact = GetMainContact(account.Id, null );
        
        //Map<Systems, integer> 
        SystemValue dest = new SystemValue('', GetSystemValue(Systems.Salesforce));
        List<SystemValue> mydest = new List<SystemValue>();
        // mydest.add(dest);
        
        if(account.OwnerId != null){
            accManager = GetAccountManagerName(account.OwnerId);            
        }
        
        if(account.MDM_ID__c == null){account.MDM_ID__c = '0';}
        
        vendor.MDMID = Integer.valueOf(account.MDM_ID__c);
        vendor.AccountEmailAddress = new Value(account.Compagnie_Email__c, true, '');
        
        vendor.Phone = new Value(account.Phone, true, '');
        vendor.Fax = new Value(account.Fax, true, '');
        vendor.TollFreePhone = new Value(account.Toll_Free_Phone__c, true, '');        
        Vendor.WebsiteUrl = new Value(account.website, true, ''); 
        
        vendor.BusinessName = new Value(account.Doing_Business_As__c, true, '');        
        vendor.LegalName = new Value(account.Name, true, '');
        
        vendor.MainContact = new Value(mainContact, true, '');  //contactName
        
        vendor.BillingStreet = new Value(account.BillingStreet, true, '');
        vendor.BillingCity = new Value(account.BillingCity, true, '');
        vendor.BillingProvince = new Value(account.BillingState, true, ''); //Manage_State_Country.manage_State(account.BillingState), true, '');
        //  vendor.BillingProvinceCode = new Value(account.BillingProvinceCode__c, true, '');
        vendor.BillingCountry = new Value(account.BillingCountry, true, '');
        //  vendor.BillingCountryCode = new Value(account.BillingCountryCode__c, true, '');
        vendor.BillingPostalCode = new Value(account.BillingPostalCode, true, '');
        vendor.ShippingStreet = new Value(account.ShippingStreet, true, '');
        vendor.ShippingCity = new Value(account.ShippingCity, true, '');
        vendor.ShippingProvince = new Value(account.ShippingState , true, '');  //Manage_State_Country.manage_State(account.ShippingState), true, '');
        vendor.ShippingCountry = new Value(account.ShippingCountry, true, '');
        //   vendor.ShippingCountryCode = new Value(account.ShippingCountryCode__c, true, '');
        vendor.ShippingPostalCode = new Value(account.ShippingPostalCode, true, '');
        //  vendor.ShippingProvinceCode = new Value(account.ShippingProvinceCode__c , true, '');
        vendor.YearEstablished = new Value(account.In_Business_Since__c, true, '');
        vendor.AccountManager =  new Value(accManager, true, '');         //new Value(GetAccountManagerName(account.OwnerId), true, ''); //account.OwnerId
        vendor.SourceSystem = new SystemValue(account.Id, GetSystemValue(Systems.Salesforce));
        vendor.DestinationSystems = mydest;
        
        
        system.debug(' le vendor est -- '+Vendor);
        
        return vendor;
        
    }
    
    
    
    //// SourceSystem convertion to enum ////////////////////////////////////////////////////////////////////////////
    
    private Integer GetSystemValue(Systems enumValue){
        
        Map<Systems, Integer> SystemsMap = new Map<Systems, Integer>
        {
            Systems.MDM => 0,
                Systems.Hitachi => 1,
                Systems.Infolease => 2,
                Systems.Salesforce => 3,
                Systems.Vision => 4,
                Systems.Location => 5
                };
                    return SystemsMap.get(enumValue);
    }
    
    
    //////////// FOR CREATE  ACCOUNT   ///////////////////////////////////
    
    
    public static Account BuildAccountInstance (VendorRequest Vendor){
        
        Account accountRecord = new Account();
        
        Manage_Vendor_RT__c vendorRT = Manage_Vendor_RT__c.getOrgDefaults();
        Manage_Account_Owner__c accountOwner = Manage_Account_Owner__c.getOrgDefaults();
        
        if(GetAccountManagerId(vendor.AccountManager.ItemValue) != null){
            accountRecord.OwnerId = GetAccountManagerId(vendor.AccountManager.ItemValue);            
        }
        else{
            
            List<User> user = [Select Id From User Where Email = :accountOwner.Default_Owner_Email__c Limit 1];
            if(user.Size() > 0){
                accountRecord.OwnerId = user[0].Id;
            }
            
        }
        
        accountRecord.RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get(vendorRT.RT_Name__c).getRecordTypeId();
        
        if(Vendor.MDMID != null){accountRecord.MDM_ID__c = String.valueOf(vendor.MDMID);}
        
        accountRecord.Phone = vendor.Phone.ItemValue;
        accountRecord.Fax = vendor.Fax.ItemValue;
        accountRecord.Name = vendor.LegalName.ItemValue;
        
        accountRecord.Toll_Free_Phone__c = vendor.TollFreePhone.ItemValue;
       // accountRecord.Contact_Principal__c = vendor.MainContact.ItemValue;
        accountRecord.Compagnie_Email__c = vendor.AccountEmailAddress.ItemValue;
        accountRecord.Doing_Business_As__c = vendor.BusinessName.ItemValue;
        accountRecord.BillingStreet = vendor.BillingStreet.ItemValue;
        accountRecord.BillingCity = vendor.BillingCity.ItemValue;
        accountRecord.BillingState = Manage_State_Country.manage_State(vendor.BillingProvince.ItemValue); //vendor.BillingProvince.ItemValue;
        accountRecord.BillingCountry = Manage_State_Country.manage_Country(vendor.BillingCountry.ItemValue); //vendor.BillingCountry.ItemValue;
        accountRecord.BillingPostalCode = vendor.BillingPostalCode.ItemValue;
        accountRecord.ShippingStreet = vendor.ShippingStreet.ItemValue;
        accountRecord.ShippingCity = vendor.ShippingCity.ItemValue;
        accountRecord.ShippingState = Manage_State_Country.manage_State(vendor.ShippingProvince.ItemValue); //vendor.ShippingProvince.ItemValue;
        accountRecord.ShippingCountry = Manage_State_Country.manage_Country(vendor.BillingCountry.ItemValue); //vendor.ShippingCountry.ItemValue;
        accountRecord.ShippingPostalCode = vendor.ShippingPostalCode.ItemValue;
        //    accountRecord.ShippingProvinceCode__c = vendor.ShippingProvinceCode.ItemValue;
        //    accountRecord.AccountManager__c = vendor.AccountManager.ItemValue;
        //   accountRecord.ShippingCountryCode__c = vendor.ShippingCountryCode.ItemValue;
        //   accountRecord.BillingProvinceCode__c = vendor.BillingProvinceCode.ItemValue;
        //    accountRecord.BillingCountryCode__c = vendor.BillingCountryCode.ItemValue;
        accountRecord.In_Business_Since__c = vendor.YearEstablished.ItemValue;
        //  accountRecord.AccountManager__c = vendor.AccountManager.ItemValue;
        accountRecord.website = vendor.WebsiteUrl.ItemValue;
        
        return accountRecord;
        
    }
    
    
    //////////// FOR UPDATE  ACCOUNT   ///////////////////////////////////
    
    
    public static Account BuildUpdateAccountInstance (VendorRequest Vendor){
        // system.debug(' -- la raison est 1---'+Vendor);
        
        List<String> LReason = new List<String>();  
        List<Log_Confirmation__c> lConfirmation = new List<Log_Confirmation__c>();
        String SVal = 'Successful';
        Account accountRecord = new Account();
        
        if(GetAccountManagerId(vendor.AccountManager.ItemValue) != null){
            accountRecord.OwnerId = GetAccountManagerId(vendor.AccountManager.ItemValue);            
        }
        
        if(Vendor.MDMID != null){accountRecord.MDM_ID__c = String.valueOf(vendor.MDMID);}
        
        // Phone
        if(vendor.Phone.IsValid == true) accountRecord.Phone = vendor.Phone.ItemValue;
        else{
            
            if (vendor.Phone.RollbackValue != null) accountRecord.Phone = vendor.Phone.RollbackValue;
            else LReason.add('Phone - '+vendor.Phone.Reason);
        } 
        
        // Fax
        if(vendor.Fax.IsValid == true) accountRecord.Fax = vendor.Fax.ItemValue;
        else{
            
            if (vendor.Fax.RollbackValue != null) accountRecord.Fax = vendor.Fax.RollbackValue;
            else LReason.add('Fax - '+vendor.Fax.Reason);
        } 
        
        // Legal Name
        if(vendor.LegalName.IsValid == true) accountRecord.Name = vendor.LegalName.ItemValue;
        else{
            
            if (vendor.LegalName.RollbackValue != null) accountRecord.Name = vendor.LegalName.RollbackValue;
            else LReason.add('Legal Name - '+vendor.LegalName.Reason);
        } 
        
      /*  // MainContact
        if(vendor.MainContact.IsValid == true) accountRecord.Contact_Principal__c = vendor.MainContact.ItemValue;
        else{
            
            if (vendor.MainContact.RollbackValue != null) accountRecord.Contact_Principal__c = vendor.MainContact.RollbackValue;
            else LReason.add('Main Contact - '+vendor.MainContact.Reason);
        } 
       */ 
        // Usual Name
        if(vendor.BusinessName.IsValid == true) accountRecord.Doing_Business_As__c = vendor.BusinessName.ItemValue;
        else{
            
            if (vendor.BusinessName.RollbackValue != null) accountRecord.Doing_Business_As__c = vendor.BusinessName.RollbackValue;
            else LReason.add('Usual Name - '+vendor.BusinessName.Reason);
        } 
        
        // Account Manager
        /*    if(vendor.AccountManager.IsValid == true) accountRecord.AccountManager__c = vendor.AccountManager.ItemValue;
else{

if (vendor.AccountManager.RollbackValue != null) accountRecord.AccountManager__c = vendor.AccountManager.RollbackValue;
else LReason.add('Account Manager - '+vendor.AccountManager.Reason);
} */
        
        // TollFreePhone
        if(vendor.TollFreePhone.IsValid == true) accountRecord.Toll_Free_Phone__c = vendor.TollFreePhone.ItemValue;
        else{
            
            if (vendor.TollFreePhone.RollbackValue != null) accountRecord.Toll_Free_Phone__c = vendor.TollFreePhone.RollbackValue;
            else  LReason.add('TollFreePhone - '+vendor.TollFreePhone.Reason);
        } 
        
        // AccountEmailAddress
        if(vendor.AccountEmailAddress.IsValid == true) accountRecord.Compagnie_Email__c = vendor.AccountEmailAddress.ItemValue;
        else{
            
            if (vendor.AccountEmailAddress.RollbackValue != null) accountRecord.Compagnie_Email__c = vendor.AccountEmailAddress.RollbackValue;
            else LReason.add('Account Email Address - '+vendor.AccountEmailAddress.Reason);
        } 
        
        // BillingCountry
        System.debug('Vendor BillingCountry'+vendor.BillingCountry.ItemValue+'vendor  BillingCountry RollbackValue## Id ' + vendor.BillingCountry.RollbackValue);
        
        //    if(vendor.BillingCountry.ItemValue != null || vendor.BillingCountry.ItemValue != ''){
        if(vendor.BillingCountry.IsValid == true) accountRecord.BillingCountry = Manage_State_Country.manage_Country(vendor.BillingCountry.ItemValue); //vendor.BillingCountry.ItemValue;
        else{
            
            if (vendor.BillingCountry.RollbackValue != null){
                accountRecord.BillingCountry = Manage_State_Country.manage_Country(vendor.BillingCountry.RollbackValue); 
                LReason.add('Billing Country - '+vendor.BillingCountry.Reason);
            }
            else LReason.add('Billing Country - '+vendor.BillingCountry.Reason);
        } 
        //   }
        
        // BillingStreet
        if(vendor.BillingStreet.IsValid == true) accountRecord.BillingStreet = vendor.BillingStreet.ItemValue;
        else{
            
            if (vendor.BillingStreet.RollbackValue != null){
                accountRecord.BillingStreet = vendor.BillingStreet.RollbackValue;
                LReason.add('Billing Street - '+vendor.BillingStreet.Reason);
            }
            else LReason.add('Billing Street - '+vendor.BillingStreet.Reason);
        } 
        
        // BillingCity
        if(vendor.BillingCity.IsValid == true) accountRecord.BillingCity = vendor.BillingCity.ItemValue;
        else{
            
            if (vendor.BillingCity.RollbackValue != null){
                accountRecord.BillingCity = vendor.BillingCity.RollbackValue;
                LReason.add('Billing City - '+vendor.BillingCity.Reason);
            }
            else  LReason.add('Billing City - '+vendor.BillingCity.Reason);
        } 
        
        
        
        // BillingProvince
        //  if(vendor.BillingProvince.ItemValue != null || vendor.BillingProvince.ItemValue != ''){
        
        if(vendor.BillingProvince.IsValid == true) accountRecord.BillingState = Manage_State_Country.manage_State(vendor.BillingProvince.ItemValue);
        else{
            
            if (vendor.BillingProvince.RollbackValue != null){
                accountRecord.BillingState = Manage_State_Country.manage_State(vendor.BillingProvince.RollbackValue); 
                LReason.add('Billing Province - '+vendor.BillingProvince.Reason);
            }
            else LReason.add('Billing Province - '+vendor.BillingProvince.Reason);
        } 
        //  }
        
        // BillingPostalCode
        
        if(vendor.BillingPostalCode.IsValid == true) accountRecord.BillingPostalCode = vendor.BillingPostalCode.ItemValue;
        else{
            
            if (vendor.BillingPostalCode.RollbackValue != null){
                accountRecord.BillingPostalCode = vendor.BillingPostalCode.RollbackValue;
                LReason.add('Billing Postal Code - '+vendor.BillingPostalCode.Reason);
            }
            else LReason.add('Billing Postal Code - '+vendor.BillingPostalCode.Reason);
        } 
        
        // ShippingCountry
        
        //   if(vendor.ShippingCountry.ItemValue != null || vendor.ShippingCountry.ItemValue != ''){
        if(vendor.ShippingCountry.IsValid == true) accountRecord.ShippingCountry = Manage_State_Country.manage_Country(vendor.ShippingCountry.ItemValue); //vendor.ShippingCountry.ItemValue;
        else{
            
            if (vendor.ShippingCountry.RollbackValue != null) {
                accountRecord.ShippingCountry = Manage_State_Country.manage_Country(vendor.ShippingCountry.RollbackValue);
                LReason.add('Shipping Country - '+vendor.ShippingCountry.Reason);
            }
            else LReason.add('Shipping Country - '+vendor.ShippingCountry.Reason);
        } 
        //  }
        // ShippingStreet
        if(vendor.ShippingStreet.IsValid == true) accountRecord.ShippingStreet = vendor.ShippingStreet.ItemValue;
        else{
            
            if (vendor.ShippingStreet.RollbackValue != null) {
                accountRecord.ShippingStreet = vendor.ShippingStreet.RollbackValue;
                LReason.add('Shipping Street - '+vendor.ShippingStreet.Reason);
            }
            else LReason.add('Shipping Street - '+vendor.ShippingStreet.Reason);
        } 
        
        // ShippingCity
        if(vendor.ShippingCity.IsValid == true) accountRecord.ShippingCity = vendor.ShippingCity.ItemValue;
        else{
            
            if (vendor.ShippingCity.RollbackValue != null){
                accountRecord.ShippingCity = vendor.ShippingCity.RollbackValue;
                LReason.add('Shipping City - '+vendor.ShippingCity.Reason);
            }
            else LReason.add('Shipping City - '+vendor.ShippingCity.Reason);
        } 
        // ShippingState
        
        //    if(vendor.ShippingProvince.ItemValue != null || vendor.ShippingProvince.ItemValue != ''){
        if(vendor.ShippingProvince.IsValid == true) accountRecord.ShippingState = Manage_State_Country.manage_State(vendor.ShippingProvince.ItemValue);
        else{
            
            if (vendor.ShippingProvince.RollbackValue != null){
               // accountRecord.ShippingState = Manage_State_Country.manage_State(vendor.ShippingProvince.RollbackValue); 
              //  LReason.add('Shipping State - '+vendor.ShippingProvince.Reason);
            }
            else LReason.add('Shipping State - '+vendor.ShippingProvince.Reason);
        } 
        //    }
        // ShippingPostalCode
        if(vendor.ShippingPostalCode.IsValid == true) accountRecord.ShippingPostalCode = vendor.ShippingPostalCode.ItemValue;
        else{
            
            if (vendor.ShippingPostalCode.RollbackValue != null){
                accountRecord.ShippingPostalCode = vendor.ShippingPostalCode.RollbackValue;
                LReason.add('Shipping Postal Code - '+vendor.ShippingPostalCode.Reason);
            }
            else LReason.add('Shipping Postal Code - '+vendor.ShippingPostalCode.Reason);
        } 
        
        // website
        if(vendor.WebsiteUrl.IsValid == true) accountRecord.website = vendor.WebsiteUrl.ItemValue;
        else{
            
            if (vendor.WebsiteUrl.RollbackValue != null) accountRecord.website = vendor.WebsiteUrl.RollbackValue;
            else LReason.add('Website - '+vendor.WebsiteUrl.Reason);
        }
        
        // YearEstablished
        if(vendor.YearEstablished.IsValid == true) accountRecord.In_Business_Since__c = vendor.YearEstablished.ItemValue;
        else{
            
            if (vendor.YearEstablished.RollbackValue != null) accountRecord.In_Business_Since__c = vendor.YearEstablished.RollbackValue;
            else LReason.add('Year Established - '+vendor.YearEstablished.Reason);
        }
        
        
        system.debug(' -- la raison est ---'+ LReason);
        
        if(LReason.size() > 0 ){ //.length()>5   ){
            
            for(String r : LReason){
                Log_Confirmation__c Confirmation = new Log_Confirmation__c();
                Confirmation.Error_Message__c = r;
                Confirmation.Related_To_Account__c = Vendor.SourceSystem.Id;
                Confirmation.Requested_Action__c = 'Update';
                Confirmation.Resource_Name__c = 'Vendor';
                Confirmation.Succeeded__c = false;
                Confirmation.System_Source__c =   'Salesforce';  
                
                lConfirmation.add(Confirmation);
            }
            
            if(lConfirmation.size() > 0){
                
                Insert lConfirmation;
                
                for(Log_Confirmation__c lc : lConfirmation){
                    
                    if(lc.Succeeded__c == false) SVal = 'Missing';
                    
                    accountRecord.Last_Requested_Status__c = SVal +' '+ lc.Requested_Action__c+' - '+Datetime.Now().format(); 
                }
                
            }
            
        }
        
        else  accountRecord.Last_Requested_Status__c = 'Successful Update - '+ Datetime.Now().format(); //system.now();
        
        
        return  accountRecord;
        
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    // Get main Contact
    
    private static String GetMainContact(String accId, String contName){
        String contactName;
        if(accId != null){
            
            for(accountcontactrelation  ac  : [Select id, accountId, Contact.Name, Is_Primary__c  
                       from AccountContactRelation where (accountId = :accId AND Is_Primary__c = true) OR (accountId = :accId AND Contact.Name = :contName )]){
                                       contactName = ac.Contact.Name;               
                                                  }
        }
        return contactName;
    }
    
   
    
    
    //// Link Account Manager who come from MS to Salesforce User (Account Owner) to get UserId or UserName  //////////////////////////////////
    
    private static String GetAccountManagerName(String userId){
        String accManger = null;
        for(User u : [Select Id, Name from User where Id = :userId]){
            
            accManger = u.Name;
            
        }
        return accManger;
    }
    
    
    
    private static String GetAccountManagerId(String am){
        
        String accManger = null;
        for(User u : [Select Id from User where Name = :am]){
            
            accManger = u.Id;
            
        }
        
        return accManger; 
    }
    
    
    
    ////////////////////////  NEW CONTACT AND ACCOUNT-CONTCT RELATION ///////////////////////////////////
    
    public static String BuildContact (VendorRequest Vendor, String accountId){
        
        Contact contactRecord = new Contact();
        String lName, fName, ContactId;
        String SVal;
        List<String> LReason = new List<String>();
        List<Log_Confirmation__c> lConfirmation = new List<Log_Confirmation__c>();
        
        System.debug('Vendor value'+Vendor+'vendor  contact ## Id ' + contactId+ '---- le accountId --'+accountId +'vendor cuntry ## Id ----' + vendor.BillingCountry.ItemValue);
        
        //  List<Contact> mainContact = [Select Id, Name From Contact where  AccountId = :accountId AND (Name = :Vendor.MainContact.ItemValue OR Name = :Vendor.MainContact.RollbackValue)];
        
        If(Vendor.MainContact.ItemValue != null  && Vendor.MainContact.IsValid == true){
            
            lName = (Vendor.MainContact.ItemValue).substringAfter(' ');
            fName = (Vendor.MainContact.ItemValue).substringBefore(' ');
            if(lName == null || lName =='') {
                lName = fName;
                fName = '';
            }
            
        } 
        else if(Vendor.MainContact.RollbackValue != null  && Vendor.MainContact.IsValid == false){
            
            lName = (Vendor.MainContact.RollbackValue).substringAfter(' ');
            fName = (Vendor.MainContact.RollbackValue).substringBefore(' ');
            if(lName == null || lName =='') {
                lName = fName;
                fName = '';
            }
            
        }
        else {
            
            lName = (Vendor.MainContact.RollbackValue).substringAfter(' ');
            fName = (Vendor.MainContact.RollbackValue).substringBefore(' ');
            if(lName == null || lName =='') {
                lName = fName;
                fName = '';
            }
            
        }
        
        System.debug('vendor  contact ## ' + Vendor.MainContact.ItemValue);
        
        System.debug('vendor  contact RollbackValue## ' + Vendor.MainContact.RollbackValue);
        
        System.debug('vendor  name ## 1 ' + (Vendor.MainContact.ItemValue).substringAfter(' '));
        System.debug('vendor  name ## 2 ' + (Vendor.MainContact.ItemValue).substringBefore(' '));
        
        List<Contact> lcontact = [Select Id, accountId, Name From Contact where  AccountId = :accountId AND FirstName = :fName AND LastName = :lName Limit 1];
        if(lcontact.size() > 0)  {
            
            contactId = lcontact[0].Id;
            accountId = lcontact[0].accountId;
            System.debug('vendor  contact ## Id 1--' + lcontact[0].Id);
            System.debug('vendor  contact ## Id 2--' + contactId);
            
        }
        
        System.debug('vendor  contact ## Id ' + contactId);
        if(contactId == null  ){
            
            // update isPrimary existing Account contact relationship 
            List<AccountContactRelation> Lacr = new list<AccountContactRelation>();          
            String acrId, acrPrimary;
            for (AccountContactRelation acr : [select id, accountId, Contact.Name, Is_Primary__c  from AccountContactRelation where  accountId = :accountId]){
                
               AccountContactRelation acrelation = new AccountContactRelation(id = acr.Id, Is_Primary__c = false);
               Lacr.add(acrelation);
            }
            if(Lacr.size() > 0){
                UPDATE Lacr;
            }   
            
            // create new contact
            contactRecord.AccountId = accountId;
            contactRecord.LastName = lName;
            contactRecord.FirstName = fName;
        /*    contactRecord.Phone = Vendor.Phone.ItemValue;
            contactRecord.Email_Permanent__c = Vendor.AccountEmailAddress.ItemValue;
            if(vendor.BillingCountry.ItemValue != null || vendor.BillingCountry.ItemValue != '')
                contactRecord.MailingCountry = Manage_State_Country.manage_Country(vendor.BillingCountry.ItemValue); //Vendor.BillingCountry.ItemValue;
            if(vendor.BillingProvince.ItemValue != null || vendor.BillingProvince.ItemValue!= '')
                contactRecord.MailingState = Manage_State_Country.manage_State(vendor.BillingProvince.ItemValue); //Vendor.BillingProvince.ItemValue;
            contactRecord.MailingStreet = Vendor.BillingStreet.ItemValue;
            contactRecord.MailingCity = Vendor.BillingCity.ItemValue;
            contactRecord.MailingPostalCode = Vendor.BillingPostalCode.ItemValue;
           */ 
            
            System.debug('Vendor contact value to update'+contactRecord);            
            
            Insert contactRecord;
            contactId = contactRecord.Id;
            
        }
        else{
            
            
            contactRecord.Id = contactId;  
            contactRecord.AccountId = accountId;
            contactRecord.LastName = lName;
            contactRecord.FirstName = fName;
            
         /*   // Phone
            if(vendor.Phone.IsValid == true) contactRecord.Phone = vendor.Phone.ItemValue;
            else{
                
                // system.debug(' -- la raison phone est ---'+Reason);
                if (vendor.Phone.RollbackValue != null) contactRecord.Phone = vendor.Phone.RollbackValue;
                else  LReason.add('Contact Phone - '+vendor.Phone.Reason);
            } 
            
            // AccountEmailAddress
            if(vendor.AccountEmailAddress.IsValid == true) contactRecord.Email_Permanent__c = vendor.AccountEmailAddress.ItemValue;
            else{
                
                if (vendor.AccountEmailAddress.RollbackValue != null) contactRecord.Email_Permanent__c = vendor.AccountEmailAddress.RollbackValue;
                else LReason.add('Contact Email Address - '+vendor.AccountEmailAddress.Reason);
            } 
            
            // BillingCountry
            System.debug('vendor  contact address## Id ' + vendor.BillingCountry.ItemValue+'- rollback--'+vendor.BillingCountry.RollbackValue);
            
            if(vendor.BillingCountry.IsValid == true) contactRecord.MailingCountry = Manage_State_Country.manage_Country(vendor.BillingCountry.ItemValue); //vendor.BillingCountry.ItemValue;
            else{
                
                if (vendor.BillingCountry.RollbackValue != null) contactRecord.MailingCountry = Manage_State_Country.manage_Country(vendor.BillingCountry.RollbackValue); //vendor.BillingCountry.RollbackValue;
                else LReason.add('Contact Mailing Country - '+vendor.BillingCountry.Reason);
            }     
            
            
            
            // MailingStreet
            if(vendor.BillingStreet.IsValid == true) contactRecord.MailingStreet = vendor.BillingStreet.ItemValue;
            else{
                
                if (vendor.BillingStreet.RollbackValue != null) contactRecord.MailingStreet = vendor.BillingStreet.RollbackValue;
                else  LReason.add('Contact Mailing Street - '+vendor.BillingStreet.Reason);
            } 
            
            // BillingCity
            if(vendor.BillingCity.IsValid == true) contactRecord.MailingCity = vendor.BillingCity.ItemValue;
            else{
                
                if (vendor.BillingCity.RollbackValue != null) contactRecord.MailingCity = vendor.BillingCity.RollbackValue;
                else LReason.add('Contact Mailing City - '+vendor.BillingCity.Reason);
            } 
            
            
            // BillingProvince
            System.debug('vendor  contact address## Id ' + vendor.BillingProvince.ItemValue+'- RollbackValue --'+vendor.BillingProvince.RollbackValue);
            if(vendor.BillingProvince.IsValid == true) contactRecord.MailingState =  Manage_State_Country.manage_State(vendor.BillingProvince.ItemValue);
            else{
                
                if (vendor.BillingProvince.RollbackValue != null) contactRecord.MailingState = Manage_State_Country.manage_State(vendor.BillingProvince.RollbackValue); //vendor.BillingProvince.RollbackValue;
                else  LReason.add('Contact Mailing Province - '+vendor.BillingProvince.Reason);
            } 
            
            
            // BillingPostalCode
            if(vendor.BillingPostalCode.IsValid == true) contactRecord.MailingPostalCode = vendor.BillingPostalCode.ItemValue;
            else{
                
                if (vendor.BillingPostalCode.RollbackValue != null) contactRecord.MailingPostalCode = vendor.BillingPostalCode.RollbackValue;
                else LReason.add('Contact Mailing Postal Code - '+vendor.BillingPostalCode.Reason);
            }
            */
            
            if(LReason.size() > 0 ){
                
                for(String r : LReason){
                    Log_Confirmation__c Confirmation = new Log_Confirmation__c();
                    Confirmation.Error_Message__c = r;
                    Confirmation.Related_To_Contact__c = contactId;
                    Confirmation.Related_To_Account__c = accountId;
                    Confirmation.Requested_Action__c = 'Update';
                    Confirmation.Resource_Name__c = 'Vendor';
                    Confirmation.Succeeded__c = false;
                    Confirmation.System_Source__c =   'Salesforce';  
                    
                    lConfirmation.add(Confirmation);
                }
                
                if(lConfirmation.size() > 0){
                    
                    Insert lConfirmation;
                    
                    for(Log_Confirmation__c lc : lConfirmation){
                        
                        if(lc.Succeeded__c == false) SVal = 'Missing';
                        
                        //   accountRecord.Last_Requested_Status__c = SVal +' '+ lc.Requested_Action__c+' / '+system.now(); 
                    }
                    
                }
            }       
            Update contactRecord;
            
            system.debug(' -- le id contact '+contactRecord.id);
        }
        
        return contactRecord.Id;
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    
    public Static Account_WS_Msg Build_Msg(String msg){
        
        Account_WS_Msg err = new Account_WS_Msg();
        
        err.Message = msg;
        
        return err;
    }
    
    ////////////////////////////////////////////
    
    /*
    public Static Account_WS_Id Build_Id_Response(String msg){
        
        Account_WS_Id Id = new Account_WS_Id();
        
        Id.SystemId = msg;
        
        return Id;
    }
    */
}