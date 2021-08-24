// test class for MS_Salesforce_GetAccount_WS
@isTest
public class MS_Salesforce_GetAccount_WSTest {
    @testSetup
    public static void createTestRecords(){
       Account acctRecord = new Account();
        acctRecord.Name = 'New Microserv Account' + Integer.valueOf(Math.random() * 100);
        acctRecord.Phone = '7987999880';
        acctRecord.Compagnie_Email__c = 'microserv@gmail.com';
        acctRecord.Description = 'New Account Description' + Integer.valueOf(Math.random() * 100);
        acctRecord.MDM_ID__c = '456456';
        acctRecord.Contact_Principal__c = 'test contact'+ Integer.valueOf(Math.random() * 100);
        INSERT acctRecord;
        
        Contact contRecord = new Contact();
        contRecord.AccountId = acctRecord.Id;
        contRecord.LastName = 'New Microserv Contact' + Integer.valueOf(Math.random() * 100);
        contRecord.Email = 'testmicroserv@gmail.com';
        contRecord.Title = 'Test Title' + Integer.valueOf(Math.random() * 100);
        contRecord.MobilePhone = '5454654500';
        INSERT contRecord;
        
    }
    @isTest
    public static void testGetAccountWS(){
        Account acct = [SELECT Id FROM Account LIMIT 1];
        system.debug('--- le id est ----.'+ acct.Id);
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'GET';
        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/Account/EIP/MS_Salesforce/Detailes/' + acct.Id;
        RestContext.request = req;
        RestContext.response = res;
        
        MS_Salesforce_GetAccount_WS.GetAccountById();
        System.assertEquals(200, RestContext.response.statusCode);
        
        // when account id is blank
        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/Account/EIP/MS_Salesforce/Detailes/' + '';
        MS_Salesforce_GetAccount_WS.GetAccountById();
        System.assertEquals(400, RestContext.response.statusCode);
        
        // when account id is wrong
        req.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/Account/EIP/MS_Salesforce/Detailes/' + '001yutyu';
        MS_Salesforce_GetAccount_WS.GetAccountById();
        System.assertEquals(404, RestContext.response.statusCode);
        
       
        Test.stopTest();
    }

}