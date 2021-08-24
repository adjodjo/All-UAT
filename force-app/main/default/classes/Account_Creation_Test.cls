@isTest
public class Account_Creation_Test {
    
    @testSetup
		public static void createTestRecords(){
            
            Account acctRecord = new Account();
        acctRecord.Name = 'EIP Account';
        acctRecord.Phone = '7987999880';
        acctRecord.Compagnie_Email__c = 'eiptest@test.com';
        acctRecord.Description = 'New Account Description' + Integer.valueOf(Math.random() * 100);
        acctRecord.Sales_Priority__c = 'STRAT';
        //acctRecord.Contact_Principal__c = 'test contact'+ Integer.valueOf(Math.random() * 100);
        INSERT acctRecord;
        
        Contact contRecord = new Contact();
        contRecord.AccountId = acctRecord.Id;
        contRecord.LastName = 'EIP Contact' + Integer.valueOf(Math.random() * 100);
        contRecord.Email = 'testeip@test.com';
        contRecord.Title = 'Test Title' + Integer.valueOf(Math.random() * 100);
        contRecord.MobilePhone = '5454654500';
        INSERT contRecord;
            
            
            
        
        User myUser = TestUtils.userTestRecord();
        System.debug('le user '+myUser);
        
        Account myAccount = TestUtils.accountTestRecord_NO_Email();
         //Account myAccount1 = accountTestRecord1();
        Account myAccount1 =TestUtils.accountTestRecord_Email();
        Account myAccount2 = TestUtils.accountTestRecord_UN();
        // Account myAccount2 = accountTestRecord2();
       // Contact myContact = contactTestRecord(myAccount.Id);
        }
    
     public static SettingsAccountContactAPI buildAccountValue( String eipAccountName,String eipAccountUsualName, String eipAccountPostalCode, String eipAccountBillingCity, 
                                String eipAccountBillingStreet, String eipAccountBillingState,String eipAccountBillingCountry,
                                String eipAccountPhone, String eipAccountEmail, String eipContactEmail, String eipContactName, String eipContactPhone, String eipActiveDirectoryName){
        
             SettingsAccountContactAPI accSetting = new SettingsAccountContactAPI(eipAccountName,eipAccountUsualName, eipAccountPostalCode, eipAccountBillingCity, eipAccountBillingStreet, 
                                                                              eipAccountBillingState,eipAccountBillingCountry,eipAccountPhone, eipAccountEmail, eipContactEmail, 
                                                                              eipContactName, eipContactPhone, eipActiveDirectoryName);
                                    
      
        
        return accSetting;
    }
    
    public static AccountSearchParams buildSearchParam(String name, String phone){
        
        AccountSearchParams searchParam = new AccountSearchParams();
        searchParam.Name = name;
        searchParam.Phone = phone;
        
        return searchParam;
    }
    
    
    @IsTest
    static void  AccountContactTest(){
        
        Account acct = [SELECT Id FROM Account LIMIT 1];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        
        Test.StartTest();
        
        req.httpMethod = 'GET';
        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/Account/EIP/MS_Salesforce/Detailes/' + acct.Id;
        RestContext.request = req;
        RestContext.response = res;
        
        Account_Retrieve_WS.GetAccountById();
        System.assertEquals(200, RestContext.response.statusCode);
        
        Account_RetrieveALL_WS.GetAccountById();
        System.assertEquals(200, RestContext.response.statusCode);

        
        req.httpMethod = 'GET';
        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/Account/EIP/MS_Salesforce/Detailes/' + 'test';
        RestContext.request = req;
        RestContext.response = res;
        Account_Retrieve_WS.GetAccountById();
        System.assertEquals(400, RestContext.response.statusCode);
        
         SettingsAccountContactAPI accSetting = buildAccountValue('Test test','Test','H4N1P8','Montreal','Test','Test','Test','5142223366','testt0@analystik.ca','test0@analystik.ca','Test Test',
                                                                '5142223367','tUser');
        Account_Creation_WS.Account_Contact_Verification(accSetting);
        System.assertEquals(200, RestContext.response.statusCode);
        
         req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Account_Search_WS.Account_Search('Test test', 1, 0,1);
        System.assertEquals(200, RestContext.response.statusCode);
        
        Account_Search_WS.Account_Search('momo', 1, 0,1);
        System.assertEquals(200, RestContext.response.statusCode);
       
        Account_Search_WS.Account_Search(null, 1, 0,1);
        System.assertEquals(500, RestContext.response.statusCode);
              
        
        
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        
          
        AccountSearchParams myparam = buildSearchParam('Test test', '5142223366');
        
        Account_RetrieveName_Phone_WS.GetAccountByNameANDPhone(myparam);
        System.assertEquals(200, RestContext.response.statusCode);

        
        
   /*     SettingsAccountContactAPI accSetting = buildAccountValue('Test test','Test','H4N1P8','Montreal','Test','Test','Test','5142223366','testt0@analystik.ca','test0@analystik.ca','Test Test',
                                                                '5142223367','tUser');
        Account_Creation_WS.Account_Contact_Verification(accSetting);
        System.assertEquals(200, RestContext.response.statusCode);*/

        
        SettingsAccountContactAPI accSetting1 = buildAccountValue('toto','Test2','','3R','Test','Test','Test','5142223355','testt1@analystik.ca','test1@analystik.ca','Test1 Test1',
                                                                '5142229967','tUser');        
        Account_Creation_WS.Account_Contact_Verification(accSetting1);
        System.assertEquals(200, RestContext.response.statusCode);
        
        SettingsAccountContactAPI accSetting2 = buildAccountValue('tota',null,'','3R','Test','Test','Test','5142223355','testt1@analystik.ca','test1@analystik.ca','Test1 Test1',
                                                                '5142229967','tUser');    
        Account_Creation_WS.Account_Contact_Verification(accSetting2);
        System.assertEquals(200, RestContext.response.statusCode);
        
        SettingsAccountContactAPI accSetting3 = buildAccountValue(null,'Test2',null,'Montreal','Test','Test','Test',null,'testt2@analystik.ca','test2@analystik.ca','Test2 Test2',
                                                                '5142229967','tUser'); 
        Account_Creation_WS.Account_Contact_Verification(accSetting3 );
        System.assertEquals(400, RestContext.response.statusCode);
        
        SettingsAccountContactAPI accSetting4 = buildAccountValue('Test2','Test2',null,'Montreal','Test','Test','Test','5142223369','testt2@analystik.ca','test2@analystik.ca',null,
                                                                '5142229967','tUser'); 
        Account_Creation_WS.Account_Contact_Verification(accSetting4 );
        System.assertEquals(200, RestContext.response.statusCode);
        
       // List<CustomResponseSearch> accountSeach =  new List<CustomResponseSearch>();
        String f = 'Test';
        
        
        
        // Verify results
     System.assertEquals('Test test', accSetting.eipAccountName);
        System.assertEquals('Test1 Test1', accSetting1.eipContactName);
        System.assertEquals('Test Test', accSetting.eipContactName);
        
        
        Test.StopTest();
    }
}