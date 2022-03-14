@isTest
public class productandServicesControllerTest {	
    @isTest
    static void fetchSalesProgramTest() {
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
        
        Sales_Program__c salesRecord = new Sales_Program__c();
        salesRecord.Name = 'Test Sp';
        salesRecord.Program_Status__c = 'Active';
        salesRecord.Program_Summary__c = 'Test Program Summary';
        insert salesRecord;
         
        Account_Sales_Program__c accSalesRecord = new Account_Sales_Program__c();
        accSalesRecord.Sales_Program__c = salesRecord.Id;
        accSalesRecord.Account__c = acctRecord.Id;
        insert accSalesRecord;
        
        productandServicesController.fetchSalesProgram(acctRecord.Id);
        System.assert(acctRecord != null);
        System.assert(salesRecord != null);
        System.assert(accSalesRecord !=null);
    }
    
    

}