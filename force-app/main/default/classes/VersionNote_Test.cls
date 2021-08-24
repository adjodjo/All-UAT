@IsTest
public class VersionNote_Test {
    
    
    @IsTest
    static void contactVerificationTest(){
        
        Account myAccount = TestUtils.accountTestRecord_Email();//accountTestRecord(); 
        Account myAccount1 = TestUtils.accountTestRecord_UN(); //accountTestRecord1(); 


        Note testNote = new Note();

        testNote.Title = 'Test Account Note';
        testNote.Body = 'Test Account Note Body.';
        testNote.ParentId = myAccount.Id;

        insert testNote;

        system.debug('la note est '+testNote);
        ContentNote myCN = TestUtils.CNTestRecord();
        //ContentDocument documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Where ParentId = :myAccount.Id limit 1];
        ContentVersion myCV = TestUtils.CVTestRecord(testNote.Title, myCN.Id);
        ContentVersion contentDocId = [select Id, Title, ContentDocumentId, TextPreview from contentVersion where id = :myCV.id limit 1 ];
        System.debug('ContentDocumentId '+contentDocId.ContentDocumentId);
        
        System.debug('ContentNote '+myCN);
        ContentDocument cDoc = [select Id from ContentDocument where LatestPublishedVersionId = :myCV.Id];
		
        ContentVersion myCV1 = TestUtils.CVTestRecordUpdate(cDoc.Id);
        //ContentVersion contentDocId = [select ContentDocumentId from contentVersion limit 1]; //where id = :myCV.id];
        
        ContentDocumentLink myCDL1 = TestUtils.CDLTestRecord(myAccount1.Id, myCN.Id, 'I');
        ContentDocumentLink myCDL = TestUtils.CDLTestRecord(myAccount.Id,myCN.Id, 'V');
        
        Contact myContact = TestUtils.contactTestRecord(myAccount.Id);
        
                
        Test.startTest();

        VersionNote_Trigger_Handler.linkToHist(myCV.Id, myCN.Id, contentDocId.TextPreview, contentDocId.Title);
        
        Test.stopTest();
        
        // Verify results
        System.assert(myAccount.Id != null);
        System.assertEquals('TestEmail', myAccount.Name);
        System.assertEquals('Test Account Note', myCV.Title);
            
    }

}