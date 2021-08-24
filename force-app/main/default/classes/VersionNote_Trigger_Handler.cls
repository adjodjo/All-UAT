public with sharing class VersionNote_Trigger_Handler {
    
    
    // Créer un record dans l'object Historique
    
    public static String MajHistorique(String versionNoteId, String ContentDocId, String contenu, String titre) {
        
        List<Historique__c> historique = new  List<Historique__c>();        
        
        String HId;

       // ContentNote myCN = getContentNote(ContentDocId);
      //  String myCNId = myCN.Id;

        List<Id> contLinkId = getContentLink(ContentDocId);  

        system.debug('contLinkId '+contLinkId+' contLinkId size '+contLinkId.size());

        // Recherche de l\'Id du compte'
        String LinkedEntity;
        if(contLinkId.size() !=0){

            Account accountIdCorresp = [ Select Id from Account WHERE Id IN :contLinkId ];
            LinkedEntity = accountIdCorresp.Id ;

            //ContentVersion myCDoc = getContentVersionNote(versionNoteId);
    //system.debug('Account contLinkId '+accountIdCorresp+' account id '+accountIdCorresp.id);
    RecordType myRT = [Select Id From RecordType where Name = 'Note' ];

        //if(myCV.Id != null){
        
        String sujet, content, LastPublishedId, numversion, email;
        sujet = titre;
        content =  contenu;
        email = 'test@test.ca';
        //numversion = ContentDocId;
        //LastPublishedId = myCV.LatestPublishedVersionId;

        List<Historique__c> existHist = [Select Id, Note_Info__c From Historique__c where  Note_Info__c = :ContentDocId limit 1];

            if( existHist.size() == 0){   //(myCN.Id != null || myCN.Id !='') &&
            Historique__c myHistorique = new Historique__c(account__c = LinkedEntity, 
                                                            sujet__c = sujet, 
                                                            contenu__c = content, 
                                                            Type_Note__c = 'Note',
                                                            RecordTypeId = myRT.Id,
                                                            Note_Info__c =  ContentDocId, 
                                                            email__c = email                                                    
                                                        );
                historique.add(myHistorique);
            
          //  insert historique;
            
                for(Historique__c hist : historique){
                    HId = hist.Id;
                }
            }
        }
        return HId;
    }
/*
    public static ContentNote getContentNote(String ContDocId){ 
    
        ContentNote myContentNote = [select id, Title, FileType, TextPreview, LatestPublishedVersionId 
                                        from ContentNote
                                        where id = :ContDocId ] ;
    return myContentNote;
    }
*/
    
    /*
    public static ContentVersion getContentVersionNote(String versionNoteId){ 
    
        ContentVersion myContentDoc = [select id, Title, FileType, TextPreview 
                                        from ContentVersion
                                        where id = :versionNoteId AND FileType = 'SNOTE'] ;
    return myContentDoc;
    
    }
    
    */
    
    // Récupération de la liste des entités liées quis serviront à avoir l'ID du compte origine de la note ContentDocumentLink
    public static List<Id> getContentLink(String cnId){
        
        List<ContentDocumentLink> contLink = [select id, LinkedEntityId,ContentDocumentId, ShareType, Visibility
                                                FROM ContentDocumentLink 
                                                WHERE ContentDocumentId = :cnId ];
        
        List<Id> LinkedEntityListcorrespond = new List<Id>();
        
        for(ContentDocumentLink docLink : contLink){
                String entityId, ShareType; 
                ShareType = docLink.ShareType;  
system.debug('ShareType '+ShareType);
            if(docLink.ShareType == 'V' ){
                entityId = docLink.LinkedEntityId; 
                LinkedEntityListcorrespond.add(entityId);                
            }   
        }
        system.debug('List contLinkId '+LinkedEntityListcorrespond);
        return LinkedEntityListcorrespond;
        
    }
    
    // Création d'un lien entre l'object note et Historique
    
    @future
    public static void linkToHist(String versionNoteId, String ContentDocId, String contenu, String titre){
        system.debug('ContentDocId '+ContentDocId+' versionNoteId '+versionNoteId);
        // system.debug('888 - lr contenu dans la version est '+ contenu+' la version id '+versionNoteId+' le donc id '+ContentDocId);
        String histLink = MajHistorique(versionNoteId, ContentDocId, contenu, titre);
        if(histLink != null){
            ContentDocumentLink hNoteLink = new ContentDocumentLink();
            hNoteLink.ContentDocumentId = ContentDocId;
            hNoteLink.LinkedEntityId = histLink;
            hNoteLink.ShareType = 'V';
            hNoteLink.Visibility = 'AllUsers';
            insert(hNoteLink);            
        }    
    } 
}