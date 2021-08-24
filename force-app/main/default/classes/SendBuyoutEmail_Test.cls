@isTest

public class SendBuyoutEmail_Test {
    
    
    @isTest  (SeeAllData=true)
    static void BuyoutEmailTest(){
        
        User myUser = TestUtils.userTestRecord();
        System.debug('le user '+myUser);
        
         Account myAccount = TestUtils.accountTestRecord_Email();
        Contact myContact = TestUtils.contactTestRecord(myAccount.Id);
        
        Test.StartTest();
         system.debug('le contact name est '+myContact.Name+ ' Le compte est '+myAccount);
         String eipCase = TestUtils.TestCase((String)myAccount.Id, (String)myContact.Name, '');        
         CaseCustomResponse Cas1 = Case_Creation_WS.createCase(eipCase);
         String tcase = getCId(Cas1);
        system.debug('le case est '+Cas1+'le case de test est '+tcase);
        
        String contactName = (String)myContact.LastName+ ' '+(String)myContact.FirstName;
        
        String history1 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'FR', '051-89622', 'puser000@clecapital.ca','test@analystic.ca','LOAN', '3', 'testbase64', 'TestFile', tcase, 'tUser');
        String history11 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'FR', '051-89622', 'puser000@clecapital.ca','test@analystic.ca','LOAN', '3', 'testbase64', 'TestFile');
		String history2 = TestUtils.TestHistory1(null, null, 'FR', '051-89622', 'puser000@clecapital.ca',null,'LOAN', '3', 'testbase64', null, null, null);
        String history22 = TestUtils.TestHistory2(null, null, 'FR', '051-89622', 'puser000@clecapital.ca',null,'LOAN', '3', 'testbase64', null);
        
        CustomResponse hist1 = CreationHistorique_WS.createHistorique(history1, history11);
        CustomResponse hist2 = CreationHistorique_WS.createHistorique(history2, history22);
        
        String Shist = JSON.serialize(hist1).remove('\\');
            Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(Shist);
        String Shist1 = JSON.serialize(hist2).remove('\\');
            Map<String, Object> resp1 = (Map<String, Object>) JSON.deserializeUntyped(Shist1);
        
       
        String histId = (String)resp.get('Id');
        String histId1 = (String)resp1.get('Id');
        
         String BEmail = SendBuyoutEmail.BuyoutEmail(histId);
         String BEmail1 = SendBuyoutEmail.BuyoutEmail(histId1);
         String CEmail1 = SendBuyoutEmail.BuyoutEmail(tcase);
        
        Test.StopTest();
        // Verify results
        System.assert(myAccount.Id != null);
        System.assertEquals('TestEmail', myAccount.Name);
        
           }   
    
    static String getCId(CaseCustomResponse s){
        
        String hist = JSON.serialize(s).remove('\\');
        Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(hist);
        
        String caseId = (String)resp.get('caseId'); 
        
        
        return caseId;
    }
}