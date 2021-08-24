@isTest(SeeAllData=true)
public  class Case_Creation_Test {

    
    @isTest
  
    static void CaseCreation(){

        User myUser = TestUtils.userTestRecord();
        System.debug('le user '+myUser);
                                            
       //Account myAccount = accountTestRecord();
        Account myAccount = TestUtils.accountTestRecord_Email();
        
        Contact myContact = TestUtils.contactTestRecordNoEmail(myAccount.Id);
       
        
       // Historique__c myHist = HistoriqueTestRecord(myAccount.Id, myContact.Id, 'test@analystic.ca');
        
        Test.StartTest();
        
        system.debug('le contact name est '+myContact.Name+ ' Le compte est '+myAccount);
         String eipCase1 = TestUtils.TestCase((String)myAccount.Id, (String)myContact.Name, 'tUser');    
         String eipCase2 = TestUtils.TestCase((String)myAccount.Id, (String)myContact.Name, null);    
         CaseCustomResponse Cas1 = Case_Creation_WS.createCase(eipCase1);
         CaseCustomResponse Cas2 = Case_Creation_WS.createCase(eipCase2);
                 
        String h1 = getCId(Cas1);
        String h2 = getCId(Cas2);

        String em9 = SendBuyoutEmail.BuyoutEmail(h1);

        Case_Creation_WS.getCaseInformations(h1);
       
        Case c = new Case(Id = h2, status = 'Escalated'); //Type = 'Redirect To', Department__c = 'Collection');
        update c;
        
        Test.StopTest();
        // Verify results
        System.assert(myAccount.Id != null);
       // System.assertEquals('TestEmail', myAccount.Name);
        
    }

  
    
    static String getCId(CaseCustomResponse s){
        
        String hist = JSON.serialize(s).remove('\\');
        Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(hist);
        
        String caseId = (String)resp.get('caseId'); 
        
        
        return caseId;
    }
    
    


    }