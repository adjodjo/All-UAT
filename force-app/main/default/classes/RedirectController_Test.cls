@isTest
public class RedirectController_Test {
    
     @testSetup
    public static void createTestRecords(){
        
        User myUser = TestUtils.userTestRecord();
        System.debug('le user '+myUser);
        
        Id caseRT = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
        
        Account acctRecord = new Account();
            acctRecord.Name = 'New Microserv Account' + Integer.valueOf(Math.random() * 100);
            acctRecord.Phone = '7987999889';
            acctRecord.Compagnie_Email__c = 'microserv@gmail.com';
            acctRecord.Description = 'New Account Description' + Integer.valueOf(Math.random() * 100);
            acctRecord.MDM_ID__c = '456456';
            acctRecord.Contact_Principal__c = 'test contact'+ Integer.valueOf(Math.random() * 100);
        INSERT acctRecord;
        
        Contact contRecord = new Contact();
            contRecord.AccountId = acctRecord.Id;
            contRecord.LastName = 'test contact' + Integer.valueOf(Math.random() * 100);
            contRecord.Email = 'testmicroserv@gmail.com';
            contRecord.Title = 'Test Title' + Integer.valueOf(Math.random() * 100);
            contRecord.MobilePhone = '5145465450';
        INSERT contRecord;
        
        
        Case  caseRecord =  new Case();
            caseRecord.AccountId = acctRecord.Id;
            caseRecord.contactId = contRecord.Id;
            caseRecord.RecordTypeId = caseRT;
            caseRecord.Status = 'Waiting For Support';
            caseRecord.Origin = 'Email';
            caseRecord.subject = 'test';
            caseRecord.OwnerId = myUser.Id;
        	caseRecord.Previous_Close_Case_User__c = myUser.Id;
            caseRecord.SuppliedEmail = 'testt0@mhccna.com';
        	caseRecord.Contrat_InfoLease__c = '027-2569-001';
            caseRecord.CustId__c = 'C1236';
            caseRecord.ParentId = null;
            caseRecord.ActiveDirectory_Username__c = 'Mtest';
          //  caseRecord.Created_ById__c 
        INSERT caseRecord;
        
        Case  caseRecord1 =  new Case();
            caseRecord1.AccountId = acctRecord.Id;
            caseRecord1.contactId = contRecord.Id;
            caseRecord1.RecordTypeId = caseRT;
            caseRecord1.Status = 'Closed';
            caseRecord1.Origin = 'Email';
        caseRecord1.Type = 'Other';
            caseRecord1.subject = 'test';
            caseRecord1.OwnerId = myUser.Id;
        	caseRecord1.Previous_Close_Case_User__c = myUser.Id;
            caseRecord1.SuppliedEmail = 'testt0@mhccna.com';
        	caseRecord.Contrat_InfoLease__c = '027-2569-001';
            caseRecord.CustId__c = 'C1236';
            caseRecord.ParentId = null;
            caseRecord.ActiveDirectory_Username__c = 'Mtest';
        INSERT caseRecord1;
        
        EmailMessage em = new EmailMessage();        
            	em.Incoming = true;
                em.Subject = 'test';
                em.TextBody = 'test';
                em.FromAddress = 'testt0@mhccna.com';
                em.ToAddress = 'test@mhccna.com';
                em.htmlbody = 'test';
        		em.RelatedToId = caseRecord1.Id;
        INSERT em;
        
        EmailMessage em1 = new EmailMessage();        
            	em1.Incoming = true;
                em1.Subject = 'test';
                em1.TextBody = 'test@mhccna.com';
                em1.FromAddress = 'testt0@mhccna.com';
                em1.ToAddress = 'test';
                em1.htmlbody = 'test';
        		em1.RelatedToId = caseRecord.Id;
        INSERT em1;
    }
    
    public class Result{
        @AuraEnabled public string status {get;set;}
        @AuraEnabled public string msg {get;set;}
    }
    
    @isTest
    public static void testCreateRedirectCase(){
        Case cRecord = [Select id, AccountId, contactId, RecordTypeId, Status, Origin, subject, OwnerId, SuppliedEmail, 
                        Previous_Close_Case_User__c, Contrat_InfoLease__c, CustId__c, ActiveDirectory_Username__c from Case Limit 1];
        Case cRecord1 = [Select id, AccountId, contactId, RecordTypeId, Status, Origin, subject, OwnerId, SuppliedEmail, 
                         Previous_Close_Case_User__c, Contrat_InfoLease__c, CustId__c, ActiveDirectory_Username__c from Case Limit 1];
        
        Test.startTest();
        Result res = new Result();
        Result res1 = new Result();
        RedirectController.GenarateRelatedCase(cRecord1);
        RedirectController.GenarateRelatedCase(cRecord);
        
        
        Test.stopTest();
        
        
    }
    
    

}