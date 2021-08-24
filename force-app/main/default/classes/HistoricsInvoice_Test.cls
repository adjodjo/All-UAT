@isTest(SeeAllData=true)

public class HistoricsInvoice_Test {
    
     @isTest
  
    static void HistoricsInvoiceTest(){
        
        User myUser = TestUtils.userTestRecord();
        System.debug('le user '+myUser);
       
        Account myAccount = TestUtils.accountTestRecord_Email();
        Contact myContact = TestUtils.contactTestRecord(myAccount.Id);
      
        Test.StartTest();
        
        String eipInvoice = TestUtils.TestInvoice(myAccount.Id, 'tUser', true);
        String eipInvoice1 = TestUtils.TestInvoice(myAccount.Id, 'tUser', false);
        
        Invoice_HistoryCustomResponse testInvoice = Invoice_Historic_Creation_WS.createHistoriqueInvoice(eipInvoice);
        Invoice_HistoryCustomResponse testInvoice1 = Invoice_Historic_Creation_WS.createHistoriqueInvoice(eipInvoice1);
        
        String invId = testInvoice.InvoiceHistoryId;
        String invId1 = testInvoice.InvoiceHistoryId;
        
        String S_Invoice = TestUtils.TestSendInvoiceRecord('',invId, myAccount.Id, 'FR', 'test@test.com', '', 'Invoice');
        String S_Invoice1 = TestUtils.TestSendInvoiceRecord('',invId1, myAccount.Id, 'EN', null,  'tUser', 'Invoice');
        
        SendCustomResponse invoice1 = SendHistoric_WS.SendHistoric(S_Invoice, S_Invoice); //SendHistoric_Invoice_WS.SendHistoric(S_Invoice, S_Invoice);
        SendCustomResponse invoice2 = SendHistoric_WS.SendHistoric(S_Invoice1, S_Invoice1); //SendHistoric_Invoice_WS.SendHistoric(S_Invoice1, S_Invoice1);
        
        Test.StopTest();
        
    }

}