@isTest
public class CaseManage_Batchable_Test {
    
      @testSetup
    public static void createTestRecords(){

        Manage_Owner_Closed_Case__c vendorRT = new Manage_Owner_Closed_Case__c();
        vendorRT.Enable_User__c = true;
        vendorRT.User_UserName__c = 'puser0001@clecapital.ca';
        insert vendorRT;
   
    }
    
    
    
public static testMethod void testBatch() { 
    
    Group myGp = TestUtils.groupTestRecord('CS_Queue');
    
    User myUser = TestUtils.userTestRecord();
    
    Account myAccount = TestUtils.accountTestRecord_Email();
        
        Contact myContact = TestUtils.contactTestRecordNoEmail(myAccount.Id);
        
        String emailRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
       
        Case[] myCaseMetric = TestUtils.caseTestForEmailCase((String)myAccount.Id, (String)myContact.Id, emailRT,(String)myGp.Id);
    
    
    Test.StartTest();
        
        // Execute the phone sanitizer batch
        Database.executeBatch(new CaseManage_Batchable(Schema.SObjectType.Case, '2021-06-15', 'puser0001@clecapital.ca'), 1);
        
        Test.StopTest();


}}