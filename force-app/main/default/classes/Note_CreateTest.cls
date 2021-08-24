@isTest
public class Note_CreateTest {
    
    @testSetup
    public static void createTestRecords(){
        Account acctRecord = new Account();
        acctRecord.Name = 'New Note Account' + Integer.valueOf(Math.random() * 100);
        acctRecord.Phone = '7987999889';
        acctRecord.Compagnie_Email__c = 'note@test.ca';
        acctRecord.Description = 'New Account Description' + Integer.valueOf(Math.random() * 100);
       
        INSERT acctRecord;
    } 
        
       
   
    
    @isTest
    public static void testNoteCreateWS(){
        Account acc = [select id from Account Limit 1];
        system.debug('le id du compte est '+acc.Id);
        
          Test.startTest();
        
        SettingNoteContentAPI noteContent = new SettingNoteContentAPI(null, (String)acc.Id, 'test', 'Note Subject', 'Note test content'  );
        /*    noteContent.SF_NoteId = null;
            noteContent.SF_AccountId = (String)acc.Id;
            noteContent.x_ActiveDirectoryName = 'test';
            noteContent.EIP_NoteSubject = 'Note Subject';
            noteContent.EIP_NoteText = 'Note test content';*/
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Note_Create_WS.CreatContentNote(noteContent);        
        System.assertEquals(200, RestContext.response.statusCode); 
     
        
         SettingNoteContentAPI noteContent1 = new SettingNoteContentAPI(null, (String)acc.Id, 'test', null, null);
         /*   noteContent.SF_NoteId = null;
            noteContent.SF_AccountId = (String)acc.Id;
            noteContent.x_ActiveDirectoryName = 'test';
            noteContent.EIP_NoteSubject = null;
            noteContent.EIP_NoteText = null;*/
       
        Note_Create_WS.CreatContentNote(noteContent1); 
        
        system.debug('la note '+[SELECT COUNT() FROM Note]);
        
       System.assertEquals([SELECT COUNT() FROM Note] , 0); 
        
        Test.stopTest();

}
    
}