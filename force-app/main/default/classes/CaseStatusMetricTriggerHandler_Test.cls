@isTest(SeeAllData=true)
public class CaseStatusMetricTriggerHandler_Test {
       
  
     @isTest
    static void CaseStatusMetrics(){
        
        User myUser = TestUtils.userTestRecord();
        System.debug('le user '+myUser);
        Account myAccount = TestUtils.accountTestRecord_Email();
        
        Contact myContact = TestUtils.contactTestRecordNoEmail(myAccount.Id);
        
        String emailRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
       
        Case[] myCaseMetric = TestUtils.caseTestForEmailCase((String)myAccount.Id, (String)myContact.Id, emailRT, (String)myUser.Id);
        System.debug('le casse '+myCaseMetric);
       
        Map<Id, Case> oldObjectMap = new Map<Id, Case>();
       
        Test.StartTest();
        
        CaseStatusMetricTriggerHandler.OnAfterInsert(myCaseMetric); 
       Case[] testCase = [select Subject, CaseNumber, Status, Owner.Name from Case where Subject = 'test' AND accountId = :myAccount.Id ];  
        Case_Status_Metric__c  statusChange = new  Case_Status_Metric__c();
        statusChange.Name = myCaseMetric[0].CaseNumber + ' status: New';
        statusChange.Case__c = myCaseMetric[0].Id;
        statusChange.Case_Status__c = myCaseMetric[0].Status;
        statusChange.Status_Start_Time__c = Datetime.now();
        insert statusChange;
            
         Case oldCase = new Case();
        oldCase = myCaseMetric[0];
        
            myCaseMetric[0].Status = 'On Hold';
        
        update(myCaseMetric);
        oldObjectMap.put(myCaseMetric[0].Id, oldCase);
        
         System.debug('le myCaseMetric '+myCaseMetric);
        System.debug('le oldObjectMap '+oldObjectMap);
        CaseStatusMetricTriggerHandler.OnAfterUpdate(myCaseMetric, oldObjectMap);
        
        Case_Status_Metric__c[] caseStatusChange = [select Name from Case_Status_Metric__c where Case__r.Id=:myCaseMetric[0].Id and Status_End_Time__c = null];
        System.debug('le caseStatusChange '+caseStatusChange);
        System.debug('le testCase '+testCase);
         Test.StopTest();
        
        System.assertEquals(myCaseMetric[0].Subject, 'test');
    
        System.assertEquals(caseStatusChange[0].Name, testCase[0].CaseNumber + ' from New to On Hold');
    
    }
}