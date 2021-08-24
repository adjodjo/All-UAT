// test class for DispatcherAccountCallout_WS
@isTest
public class DispatcherAccountCallout_WSTest {
   
    
    
    @testSetup
     public static void buildCustomSetting(){
        Manage_Vendor_RT__c vendorRT = new Manage_Vendor_RT__c();
        vendorRT.RT_Name__c = 'Vendor';
        vendorRT.Enable_RT__c = true;
        insert vendorRT;
    }
    
     private class DispatcherCalloutMock_ERR implements HttpCalloutMock{
      public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('Bad request');
        res.setStatusCode(400);
        res.setBody('Error');
        return res;
      }
     }
    
    private class DispatcherCalloutMock_Catch implements HttpCalloutMock{
      public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('Internal Error');
        res.setStatusCode(500);
        
        return res;
      }
}
    
    
    
    @isTest
    public static void DispatcherTestMethod(){
        
       Manage_Vendor_RT__c vendorRT = Manage_Vendor_RT__c.getOrgDefaults();
        
        List<Account> accList = new List<Account>();
        Account acctRecord = new Account();
        acctRecord.RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Vendor').getRecordTypeId();  //vendorRT.RT_Name__c
        
       acctRecord.Name = 'New Microserv Account' + Integer.valueOf(Math.random() * 100);
        acctRecord.Phone = '7987999889';
        acctRecord.Compagnie_Email__c = 'microserv@gmail.com';
        acctRecord.Description = 'New Account Description' + Integer.valueOf(Math.random() * 100);
        acctRecord.MDM_ID__c = '456456';
        acctRecord.Contact_Principal__c = 'test contact'+ Integer.valueOf(Math.random() * 100);
        
        INSERT acctRecord;
        accList.add(acctRecord);
        
              
        
        Test.startTest();
        
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
    
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         DispatcherAccountCallout_WS.DispatcherAccountCallout(acctRecord.Id, 'Insert');
         DispatcherAccountCallout_WS.DispatcherAccountCallout(acctRecord.Id, 'Update');
        
       //  DispatcherAccountCallout_WS.DispatcherAccountCallout('test', 'Update');
        
        Test.setMock(HttpCalloutMock.class, new DispatcherCalloutMock_ERR());
        DispatcherAccountCallout_WS.DispatcherAccountCallout(acctRecord.Id, 'Insert');
        
        Test.setMock(HttpCalloutMock.class, new DispatcherCalloutMock_Catch());
        DispatcherAccountCallout_WS.DispatcherAccountCallout(acctRecord.Id, 'insert');
        
        
        
        Test.stopTest();
    }
}