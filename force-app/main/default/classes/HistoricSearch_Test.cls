@isTest(SeeAllData=true)
public class HistoricSearch_Test {
    
    @isTest
    
    static void MyTestClass() {
        
        Account myAccount = TestUtils.accountTestRecord_Email();
        Contact myContact = TestUtils.contactTestRecord(myAccount.Id);
        
        Test.StartTest();
        
        String contactName = (String)myContact.LastName+ ' '+(String)myContact.FirstName;
        
        String history1 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'FR', '051-89622', 'puser000@clecapital.ca','test@analystic.ca, test@test.com','LOAN', '3', 'testbase64', 'TestFile', null, 'tUser');
        String history11 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'FR', '051-89622', 'puser000@clecapital.ca','test@analystic.ca','LOAN', '3', 'testbase64', 'TestFile');
		String history2 = TestUtils.TestHistory1(null, null, 'FR', '051-89622', 'puser000@clecapital.ca',null,'LOAN', '3', 'testbase64', null, null, null);
        String history22 = TestUtils.TestHistory2(null, null, 'FR', '051-89622', 'puser000@clecapital.ca',null,'LOAN', '3', 'testbase64', null);
        String history3 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'FR', '051-89622', null,'test@analystic.ca','LOAN', '1', 'testbase64', 'TestFile', null, 'tUser');
        String history33 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'FR', '051-89622', null,'test@analystic.ca','LOAN', '1', 'testbase64', 'TestFile');
        String history4 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'EN', '051-89622', 'test@analystic.ca',null,'LEASE', '1', null, 'TestFile', null, null);
        String history44 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'EN', '051-89622', 'test@analystic.ca',null,'LEASE', '1', null, 'TestFile');
        String history5 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'EN', '060-89622', 'test@analystic.ca',null,'LEASE', '2', 'testbase64', 'TestFile', null, '');
        String history55 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'EN', '060-89622', 'test@analystic.ca',null,'LEASE', '2', 'testbase64', 'TestFile');
        String history6 = TestUtils.TestHistory1((String)myAccount.Id, contactName, 'FR', '025-89622', null,null,'LEASE', '2', 'testbase64', 'TestFile', null, 'tUser');
        String history66 = TestUtils.TestHistory2((String)myAccount.Id, contactName, 'FR', '025-89622', null,null,'LEASE', '2', 'testbase64', 'TestFile');
                
        
        CustomResponse hist1 = CreationHistorique_WS.createHistorique(history1, history11);
        CustomResponse hist2 = CreationHistorique_WS.createHistorique(history2, history22);
        CustomResponse hist3 = CreationHistorique_WS.createHistorique(history3, history33);
        CustomResponse hist4 = CreationHistorique_WS.createHistorique(history4, history44);	
        CustomResponse hist5 = CreationHistorique_WS.createHistorique(history5, history55);
        CustomResponse hist6 = CreationHistorique_WS.createHistorique(history6, history66);
        
         historicSearchController.historicSearch('test','','', null, 0, 0, null, null, false );
        historicSearchController.historicSearch(null,'051-89622',(String)myAccount.Name, null, 0, 0, null, null, false );
        historicSearchController.historicSearch(null,null,(String)myAccount.Name, contactName, 0, 0, null, null, false );
        historicSearchController.historicSearch(null,null,(String)myAccount.Name, contactName, 5000, 0, null, null, false );
        historicSearchController.historicSearch(null,null,(String)myAccount.Name, contactName, 0, 0, Date.today(), Date.today(), true );
        historicSearchController.historicSearch(null,null,null, contactName, 2000, 0, null, null, true );
        historicSearchController.historicSearch(null,null,(String)myAccount.Name, null, 5000, 0, null, null, true );
        historicSearchController.historicSearch(null,null,(String)myAccount.Name, null, 0, 0, Date.today(), Date.today(), false );
        
        
            
        
        Test.StopTest();
        
    }

}