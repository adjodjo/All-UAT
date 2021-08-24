@isTest  //(SeeAllData=true)
public class LightningComponent_Test {
    
   // @isTest
    
     @isTest static void MyTestClass() {
        
        User LUser = [Select id, Name from User where Name = 'System'];
         
       List<Group> getGroup = [select ownerId, id, type, DeveloperName, name from group where type = 'Queue' AND DeveloperName = 'CS_Queue' limit 1];
       // User myUser = userTestRecord();
        RecordType myRT = [Select Id From RecordType where Name = 'Customer service'];
        Account myAccount = TestUtils.accountTestRecord_Email();
        Contact myContact = TestUtils.contactTestRecordEmailPerm(myAccount.Id);
        Case[] myCase = TestUtils.caseTestForEmailCase(myAccount.Id, myContact.Id,myRT.Id, getGroup[0].Id );
        Case myCasec = TestUtils.caseTestRecordClosed_1(myAccount.Id,myContact.Id, myRT.Id) ;
        Case[] myCase2 = TestUtils.caseTestForEmailCase(myAccount.Id, myContact.Id, myRT.Id, getGroup[0].Id );
        Case myCasec2 = TestUtils.caseTestRecordClosed_1(myAccount.Id,myContact.Id, myRT.Id) ;
        Case myCase1 = TestUtils.caseTestRecord_AND_Task(myAccount.Id,myContact.Id, myRT.Id) ;
       // Task myTask= TestUtils.TaskTestRecord_With_Case(myCase.Id, LUser.Id) ;
       // Task myTask1= TestUtils.TaskTestRecord_Without_Case(myCase.Id, LUser.Id) ;
       String cStatus = 'Resolved';
        String cStatus1 = 'Closed';
        
        Test.StartTest();
        
        LightningComponentController.AssignCaseToMe(myCase[0].Id, 'Case', cStatus);
        LightningComponentController.AssignCaseToMe(myCase2[0].Id, 'Case', cStatus1);
        LightningComponentController.CreateNewTask(myCase[0].Id);
        
        LightningComponentController.AssignCaseToMe(myCase1.Id, 'Case', cStatus);
       
        LightningComponentController.VerifierCaseStatus(myCase[0]);
        
        RedirectController.getCaseRecord(myCase1.Id);
        RedirectController.saveCaseRecord(myCasec, cStatus );
        RedirectController.saveCaseRecord(myCasec2, cStatus1 );
        RedirectController.getCaseRecord('t');
   
            
        
    //    String test1 = SendBuyoutEmail.BuyoutEmail(myCase.Id);
    //     String test2 = SendBuyoutEmail.BuyoutEmail(myCasec.Id);
                
        Test.StopTest();
        
        
    }
 
}


/*@isTest(SeeAllData=true)
public class LightningComponent_Test {
    
    @isTest
    
    static void MyTestClass() {
        
        User LUser = [Select id, Name from User where Name = 'System'];
       // User myUser = userTestRecord();
        RecordType myRT = [Select Id From RecordType where Name = 'Sales'];
        Account myAccount = TestUtils.accountTestRecord_Email();
        Contact myContact = TestUtils.contactTestRecordEmailPerm(myAccount.Id);
        Case myCase = TestUtils.caseTestRecord(myAccount.Id, myRT.Id,myContact.Id ) ;
        Case myCasec = TestUtils.caseTestRecordClosed_1(myAccount.Id,myContact.Id, myRT.Id) ;
        Case myCase2 = TestUtils.caseTestRecord(myAccount.Id, myRT.Id,myContact.Id ) ;
        Case myCasec2 = TestUtils.caseTestRecordClosed_1(myAccount.Id,myContact.Id, myRT.Id) ;
        Case myCase1 = TestUtils.caseTestRecord_AND_Task(myAccount.Id,myContact.Id, myRT.Id) ;
       // Task myTask= TestUtils.TaskTestRecord_With_Case(myCase.Id, LUser.Id) ;
       // Task myTask1= TestUtils.TaskTestRecord_Without_Case(myCase.Id, LUser.Id) ;
       String cStatus = 'Resolved';
        String cStatus1 = 'Closed';
        
        Test.StartTest();
        
        LightningComponentController.AssignCaseToMe(myCase.Id, 'Case', cStatus);
        LightningComponentController.AssignCaseToMe(myCase2.Id, 'Case', cStatus1);
        LightningComponentController.CreateNewTask(myCase.Id);
        
        LightningComponentController.AssignCaseToMe(myCase1.Id, 'Case', cStatus);
        LightningComponentController.CreateNewTask(myCase.Id);
        
        LightningComponentController.VerifierCaseStatus(myCase);
        
        RedirectController.getCaseRecord(myCase1.Id);
        RedirectController.saveCaseRecord(myCasec, cStatus );
         RedirectController.saveCaseRecord(myCasec2, cStatus1 );
        RedirectController.getCaseRecord('t');
   
            
        
        String test1 = SendBuyoutEmail.BuyoutEmail(myCase.Id);
         String test2 = SendBuyoutEmail.BuyoutEmail(myCasec.Id);
                
        Test.StopTest();
        
        
    }
}*/