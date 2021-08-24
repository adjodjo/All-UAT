@isTest(SeeAllData=true)

public class CreationHistoriqueNoUser_Test {


    @isTest
  
    static void createHistoriqueNoUserTest(){
        
       
        Account myAccount = TestUtils.accountTestRecord_Email();
        Contact myContact = TestUtils.contactTestRecord(myAccount.Id);
      
        Test.StartTest();
        system.debug('le contact name est '+myContact.Name+ ' Le compte est '+myAccount);
        String eipCase = TestUtils.TestCase((String)myAccount.Id, (String)myContact.Name, 'tUser');        
        CaseCustomResponse Cas1 = Case_Creation_WS.createCase(eipCase);
        String tcase = getCId(Cas1);
        system.debug('le case est '+Cas1+'le case de test est '+tcase);
        
        String contactName = (String)myContact.LastName+ ' '+(String)myContact.FirstName;
        
   //     String history1 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'FR', '051-89622', 'puser000@clecapital.ca','test@analystic.ca, test@test.com','LOAN', '3', 'testbase64', 'TestFile', tcase, 'tUser');
   //     String history11 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'FR', '051-89622', 'puser000@clecapital.ca','test@analystic.ca','LOAN', '3', 'testbase64', 'TestFile');
		String history2 = TestUtils.TestHistory1(null, null, 'FR', '051-89622', 'puser000@clecapital.ca',null,'LOAN', '3', 'testbase64', null, null, null);
        String history22 = TestUtils.TestHistory2(null, null, 'FR', '051-89622', 'puser000@clecapital.ca',null,'LOAN', '3', 'testbase64', null);
    //    String history3 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'FR', '051-89622', null,'test@analystic.ca','LOAN', '1', 'testbase64', 'TestFile', null, 'tUser');
    //    String history33 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'FR', '051-89622', null,'test@analystic.ca','LOAN', '1', 'testbase64', 'TestFile');
        String history4 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'EN', '051-89622', 'test@analystic.ca',null,'LEASE', '1', null, 'TestFile', null, null);
       String history44 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'EN', '051-89622', 'test@analystic.ca',null,'LEASE', '1', null, 'TestFile');
        String history5 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'EN', '060-89622', 'test@analystic.ca',null,'LEASE', '2', 'testbase64', 'TestFile', null, '');
        String history55 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'EN', '060-89622', 'test@analystic.ca',null,'LEASE', '2', 'testbase64', 'TestFile');
    //    String history6 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'FR', '025-89622', null,null,'LEASE', '2', 'testbase64', 'TestFile', null, 'tUser');
    //    String history66 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'FR', '025-89622', null,null,'LEASE', '2', 'testbase64', 'TestFile');
                
        
     //   CustomResponse hist1 = CreationHistorique_WS.createHistorique(history1, history11);
       CustomResponse hist2 = CreationHistorique_WS.createHistorique(history2, history22);
     //   CustomResponse hist3 = CreationHistorique_WS.createHistorique(history3, history33);
        CustomResponse hist4 = CreationHistorique_WS.createHistorique(history4, history44);	
        CustomResponse hist5 = CreationHistorique_WS.createHistorique(history5, history55);
    //    CustomResponse hist6 = CreationHistorique_WS.createHistorique(history6, history66);
            
        
   //     String Shist1 = JSON.serialize(hist1).remove('\\');
    //    Map<String, Object> resp1 = (Map<String, Object>) JSON.deserializeUntyped(Shist1);
        String Shist5 = JSON.serialize(hist5).remove('\\');
        Map<String, Object> resp5 = (Map<String, Object>) JSON.deserializeUntyped(Shist5);
        String Shist2 = JSON.serialize(hist2).remove('\\');
        Map<String, Object> resp2 = (Map<String, Object>) JSON.deserializeUntyped(Shist2);
    //     String Shist3 = JSON.serialize(hist3).remove('\\');
     //   Map<String, Object> resp3 = (Map<String, Object>) JSON.deserializeUntyped(Shist3);
         String Shist4 = JSON.serialize(hist4).remove('\\');
        Map<String, Object> resp4 = (Map<String, Object>) JSON.deserializeUntyped(Shist4);
        
       
     //   String histId1 = (String)resp1.get('Id');
        String histId2 = (String)resp2.get('Id');
     //   String histId3 = (String)resp3.get('Id');
        String histId4 = (String)resp4.get('Id');
        String histId5 = (String)resp5.get('Id');
        
        
    //    String SEmailR1 = SendEmailRules.BuildSendEmail(histId1);
        String SEmailR2 = SendEmailRules.BuildSendEmail(histId2);
     //   String SEmailR3 = SendEmailRules.BuildSendEmail(histId3);
        String SEmailR4 = SendEmailRules.BuildSendEmail(histId4);
        String SEmailR5 = SendEmailRules.BuildSendEmail(histId5);
                
     //   String em1 = SendBuyoutEmail.BuyoutEmail(histId1);
        String em2 = SendBuyoutEmail.BuyoutEmail(histId2);
    //     String em3 = SendBuyoutEmail.BuyoutEmail(histId3);
         String em4 = SendBuyoutEmail.BuyoutEmail(histId4);
        String em5 = SendBuyoutEmail.BuyoutEmail(histId5);
        String em7 = SendBuyoutEmail.BuyoutEmail('test');
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Historique__c/'; 
        req.addParameter('Id',histId2);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;   
        
        CustomResponse emailResp = CreationHistorique_WS.SendBuyout();
        
        Test.StopTest();
        // Verify results
        System.assert(myAccount.Id != null);
        System.assertEquals('TestEmail', myAccount.Name);
        
    }
    
    static String getHId(CustomResponse c){
        
        String hist = JSON.serialize(c).remove('\\');
        Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(hist);
        
        String histId = (String)resp.get('Id'); 
        
        
        return histId;
    }
    
    static String getCId(CaseCustomResponse s){
        
        String hist = JSON.serialize(s).remove('\\');
        Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(hist);
        
        String caseId = (String)resp.get('caseId'); 
        
        
        return caseId;
    }
}