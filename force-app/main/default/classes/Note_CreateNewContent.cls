public class Note_CreateNewContent {
    
    public static string CreateNote(SettingNoteContentAPI note){
        
        String response, AccId;
        ContentNote cn = new ContentNote();
        ContentDocumentLink link2 = new ContentDocumentLink();
        
        try{
            System.debug(' --- entree pour creation--- '+note);
            
            if(note.SF_AccountId != null){
                System.debug(' --- ceci est acc id  1--- '+note.SF_AccountId);
                for(Account acc : [Select id From Account Where Id = :note.SF_AccountId]){
                    AccId = acc.Id;   
                    System.debug(' --- ceci est acc id  2 --- '+AccId);
                }
                if(AccId != null){
                    System.debug(' --- content creat--- '+accId);
                     String body = note.EIP_NoteText;
                    
                    
                        cn.Title = note.EIP_NoteSubject;
                        cn.Content = Blob.valueOf(body.escapeHTML4());
                        insert cn;
                    System.debug(' -- la note est --- '+cn+'   -- le id est --'+cn.Id);
                        
                        if(cn.Id != null){
                    
                        link2.ContentDocumentId = cn.id;
                        link2.LinkedEntityId = accId;
                        link2.ShareType = 'V';
                        link2.Visibility = 'AllUsers';
                        
                        insert link2;
                            
                            System.debug(' -- la link est --- '+link2+ '--- le ID est -- '+link2.Id);
                        }
                    /*
                    ContentVersion versionNote = new ContentVersion();
                   // versionNote.FileType = 'SNOTE';
                    versionNote.VersionData = Blob.valueOf(body);
                    versionNote.FirstPublishLocationId = accId;
                    versionNote.PathOnClient = note.EIP_NoteSubject + '.snote';
                //    versionNote.TextPreview = SettingNoteContentAPI.EIP_NoteText;
                    versionNote.Title = note.EIP_NoteSubject;
                        
                        insert versionNote;
                    */
                   
                }
                
            }
            
            
        }catch(Exception ex){
            
            system.debug(' -- this is new exception --'+ex.getMessage());
            
        }
        
        
        
        
        return cn.Id;
    }

}