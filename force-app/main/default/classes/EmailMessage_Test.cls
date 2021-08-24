@isTest

public class EmailMessage_Test {
    
    @testSetup
    public static void createTestRecords(){
         Manage_Case_Delay_Before__c delayb = new Manage_Case_Delay_Before__c();
        delayb.Delay_Before_Assign__c = 0;
        delayb.Enable_Delay__c = true;
        insert delayb;
    }
       

    static testMethod void myUnitTest() {
        
        
        RecordType myRT = [Select Id From RecordType where Name = 'Customer Service'];
        
         Group myGP = [Select Id From GROUP where type = 'Queue' AND DeveloperName = 'CS_Queue' limit 1];
        User myUser = TestUtils.userTestRecord();
        Account myAccount = TestUtils.accountTestRecord_Email();        
        Contact myContact = TestUtils.contactTestRecordEmailPerm(myAccount.Id);
     //   Group grp = TestUtils.groupTestRecord('CS Queue');
         Case eipCase1 = TestUtils.caseTestForEmail1((String)myAccount.Id, (String)myContact.Name, (String)myRT.Id, (String)myUser.Id); 
         Case eipCase2 = TestUtils.caseTestForEmail((String)myAccount.Id, (String)myContact.Name,(String)myRT.Id, myGP.Id); 
        Case eipCase3 = TestUtils.caseTestForEmail2((String)myAccount.Id, (String)myContact.Name, (String)myRT.Id, (String)myUser.Id);
         String sb = eipCase2.Subject +'[ref:'+eipCase2.Id+ ':ref]';
         String sb3 = eipCase3.Subject +'[ref:'+eipCase3.Id+ ':ref]';
        String sb2 = eipCase2.Subject +'[ref:'+eipCase2.Id+ ':ref]';
        
        List<EmailMessage> myEM1 = TestUtils.EMTestRecord((String)eipCase1.Id, sb, (String)eipCase2.id);
        List<EmailMessage> myEM2 = TestUtils.EMTestRecord((String)eipCase2.Id, sb, (String)eipCase2.id);
      //  List<EmailMessage> myEM3 = TestUtils.EMTestRecord(eipCase3.Id, sb3, (String)eipCase3.id);
        List<EmailMessage> myEM22 = TestUtils.EMOutgoingRecord(eipCase2.Id);
        List<EmailMessage> myEM33 = TestUtils.EMOutgoingRecord(eipCase3.Id);
        
        Test.StartTest();
       
      //  EmailMessage_Trigger_Handler.EmailMessageManage(myEM1);
     //   EmailMessage_Trigger_Handler.EmailMessageManageBefore(myEM1);
        
        EmailMessage_Trigger_Handler.EmailMessageManage(myEM2);
        EmailMessage_Trigger_Handler.EmailMessageManageBefore(myEM22);
        
        
        
        
        Test.StopTest();
        
    }
}