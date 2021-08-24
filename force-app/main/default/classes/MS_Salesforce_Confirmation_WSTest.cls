@isTest
public class MS_Salesforce_Confirmation_WSTest {
    
    @testSetup
    public static void createTestRecords(){
        
         Account acctRecord = new Account();
        acctRecord.Name = 'New Microserv Account' + Integer.valueOf(Math.random() * 100);
        acctRecord.Phone = '7987999889';
        acctRecord.Compagnie_Email__c = 'microserv@gmail.com';
        acctRecord.Description = 'New Account Description' + Integer.valueOf(Math.random() * 100);
        acctRecord.MDM_ID__c = '456456';
        acctRecord.Contact_Principal__c = 'test contact'+ Integer.valueOf(Math.random() * 100);
        INSERT acctRecord;
        
    }
    
    public static ConfirmationRequest BuildConfirmation(String acc, String msg, String RA, String RN, Boolean s, String SS){
        
        ConfirmationRequest confirmation = new ConfirmationRequest();
        confirmation.SystemId = acc;
        confirmation.ErrorMessage = msg;
        confirmation.RequestedAction = RA;
        confirmation.ResourceName = RN;
        confirmation.Succeeded = s;
        confirmation.SystemSource = SS;
            
            return confirmation;
    }
       
            
             @isTest
        public static void testCreateConfirmationWS(){
            
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
            
            Account  acct = [SELECT Id,Phone FROM Account LIMIT 1];
            
            ConfirmationRequest conf = BuildConfirmation(acct.Id, 'error', 'Update', 'Vendor', true, 'Salesforce' );            
            MS_Salesforce_Confirmation_WS.GetConfirmation(conf);            
            System.assertEquals(200, RestContext.response.statusCode);
            
            ConfirmationRequest conf1 = BuildConfirmation('', 'error', 'Update', 'Vendor', false, 'Salesforce' );            
            MS_Salesforce_Confirmation_WS.GetConfirmation(conf1);
             System.assertEquals(400, RestContext.response.statusCode);
            
            ConfirmationRequest conf2 = BuildConfirmation('test', 'error', 'Update', 'Vendor', false, 'Salesforce' );            
            MS_Salesforce_Confirmation_WS.GetConfirmation(conf2);
             System.assertEquals(500, RestContext.response.statusCode);
            
            
        }
            
    
}