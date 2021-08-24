// test class for Account Exportation service
@isTest
public class ExportExternalDataControllerTest {
    
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
    
    public class ResultData{
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String message {get;set;}
        
    }
    
    @isTest
    public static void testExportAccountWS(){
        
        Account acct = [SELECT Id FROM Account LIMIT 1];
        
        ResultData res = new ResultData();
        ExportExternalDataController.getDataFromExternalApp(acct.Id, 'Vision');
        
        ResultData res1 = new ResultData();
        ExportExternalDataController.getDataFromExternalApp(acct.Id, 'Location');
        
        
    }

}