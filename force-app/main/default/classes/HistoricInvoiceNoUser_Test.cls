@isTest(SeeAllData=true)

public class HistoricInvoiceNoUser_Test {
    
    @isTest
  
    static void HistoricsInvoiceTest(){
        
        Account myAccount = TestUtils.accountTestRecord_Email();
        Contact myContact = TestUtils.contactTestRecord(myAccount.Id);
      
        Test.StartTest();
        
        String eipInvoice = TestUtils.TestInvoice((String)myAccount.Id, '', false);
        String eipInvoice1 = TestUtils.TestInvoice((String)myAccount.Id, '', true);
        
        Invoice_HistoryCustomResponse testInvoice = Invoice_Historic_Creation_WS.createHistoriqueInvoice(eipInvoice);
        Invoice_HistoryCustomResponse testInvoice1 = Invoice_Historic_Creation_WS.createHistoriqueInvoice(eipInvoice1);
        
        String invId = testInvoice.InvoiceHistoryId;
        
        String S_Invoice = TestUtils.TestSendrRecord('', invId, myAccount.Id, 'FR', 'test@test.com', '', 'Invoice');
        
        SendCustomResponse invoice1 = SendHistoric_WS.SendHistoric(S_Invoice, S_Invoice);
        
        Test.StopTest();
        
    }

}