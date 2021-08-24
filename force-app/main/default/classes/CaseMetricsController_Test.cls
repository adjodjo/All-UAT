@isTest(SeeAllData=true)
public class CaseMetricsController_Test {
    
    @isTest
    static void CaseMetrics(){
        
        User myUser = TestUtils.userTestRecord();
        System.debug('le user '+myUser);
        Account myAccount = TestUtils.accountTestRecord_Email();
        
        Contact myContact = TestUtils.contactTestRecordNoEmail(myAccount.Id);
        
        String emailRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
       
        Case[] myCaseMetric = TestUtils.caseTestForEmailCase((String)myAccount.Id, (String)myContact.Id, emailRT, (String)myUser.Id);
        System.debug('le casse '+myCaseMetric);
        
        Test.StartTest();
        	CaseMetricsController.ConvertComputationDelay((String)myCaseMetric[0].Id);
        Test.StopTest();
        
    }

}