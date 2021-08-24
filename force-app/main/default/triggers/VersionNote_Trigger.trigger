trigger VersionNote_Trigger on ContentVersion (after insert, after update) {
    
    IF ((trigger.isAfter && Trigger.isInsert) || (trigger.isAfter && Trigger.isUpdate)) {
        
    
    Set<ID> ids = Trigger.newMap.keySet();
        
    List <ContentVersion> verNotes = [SELECT id, Title,TextPreview, ContentDocumentId, FileType, VersionNumber
                                        FROM ContentVersion 
                                        WHERE isLatest = true AND Id IN: ids];
        
        String versionNoteId,ContentDocId,contenu, titre;
    
    for (ContentVersion verNote : verNotes) {
        if (verNote.FileType == 'SNOTE'){
            
            versionNoteId = verNote.Id;
            ContentDocId = verNote.ContentDocumentId;
            contenu = verNote.TextPreview;
            titre = verNote.Title;

        VersionNote_Trigger_Handler.linkToHist(versionNoteId, ContentDocId, contenu, titre);
        }
    }
        
    }


}