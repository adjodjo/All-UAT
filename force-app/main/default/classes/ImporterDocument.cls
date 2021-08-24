public with sharing class ImporterDocument {
    
  
   // @future
    public static Id SauvegerPieceJointe(String fileName, String fileBody, String contentType,  String parentId, String originId, String source){
        
        List<ContentVersion> myCV = new  List<ContentVersion>();
        List<ContentVersion> cvl = new List<ContentVersion>();
        ContentVersion cv = new ContentVersion();        
        String myCVId, titre, cId;
        
        if(String.isNotEmpty(fileName)){
        myCV = [Select Id, ContentDocumentId,VersionData,Title,PathOnClient  from ContentVersion where title = :fileName Limit 1];  
            system.debug('ceci est in test ,ShareType,Visibility' + myCV+' fileName '+fileName);
        
        
        //   CREATION DE LA NOUVELLE PIECE JOINTEVERIFICATION AUCUNE AU MEME NON)       
        if(myCV.size() == 0 && String.isNotEmpty(fileBody)){
        
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode(fileBody);  
        cv.Title = fileName;
        cv.PathOnClient = '/'+filename;
        cv.ExternalDocumentInfo1 = FileName;
        
        cvl.add(cv);
        
        System.debug('le CV = '+cvl);
        
        insert cvl;
 		System.debug('le CV ID = '+cvl[0].Id);
            
                                               
        for(ContentVersion cvlst: [Select ContentDocumentId,VersionData,Title,PathOnClient  from ContentVersion where title = :fileName AND id = :cvl[0].Id  Limit 1]){ //
            myCVId = cvlst.ContentDocumentId;
            titre = cvlst.Title;
          
        }

         System.debug('le ContentVersion not exist = '+myCVId+ ' title est '+titre);
        }
        else{

            for(ContentVersion cvlst: myCV){
            myCVId = cvlst.ContentDocumentId;
            cId = cvlst.Id;
                
        	}
            ContentVersion newCV = new ContentVersion (id = cId, FirstPublishLocationId  = UserInfo.getUserId());
            //update newCV;

                System.debug('le ContentVersion exist = '+myCVId);
        }
        
        // Librairies des pieces jointes
        String folders;
            if(source == 'Letters'){
               folders = 'Temp';
            }
            else folders = 'Attachments';
            
        ContentWorkspace ws = [SELECT Id, RootContentFolderId FROM ContentWorkspace WHERE Name = :folders ];  // 'Attachments'
        
        System.debug('le ContentVersion = '+myCV);
        
		// recherche de tous les link entre le document et les object standard et custom du systeme
        System.debug('parentId  = '+parentId+ ' myCVId '+myCVId); 
            
            
        List<ContentDocumentLink> cdlList = [SELECT LinkedEntityId, ContentDocumentId
                                                FROM ContentDocumentLink 
                                                WHERE ContentDocumentId = :myCVId AND LinkedEntityId = :originId Limit 1]; //System.debug('le liste de doc 2 est  = '+cdlList);   ContentDocumentId = :myCVId OR   OR LinkedEntityId = :originId

            System.debug('le liste de doc 1 est  = '+cdlList);                                    
        	ContentDocumentLink cdl = new ContentDocumentLink();
            ContentDocumentLink cdl1 = new ContentDocumentLink();
     
        // link de la pièce jointe au file related object des historique et case. 
        // Avec link vers la biblipthèque pour les pièces jointe des emails
        if(cdlList.size() == 0){
		System.debug('le liste de doc 2 est  = '+cdlList);
           
            cdl.ContentDocumentId = myCVId;
            //cdl.LinkedEntityId = parentId;
            cdl.ShareType = 'I';
            cdl.Visibility = 'AllUsers';
            cdl.LinkedEntityId = ws.Id;
            
           // insert cdl;
            cdl1.ContentDocumentId = myCVId;
            cdl1.LinkedEntityId = parentId;
            cdl1.ShareType = 'V';
            cdl1.Visibility = 'AllUsers';
        
            System.debug('le ContentVersionLink = '+cdl);
            insert cdl;
            insert cdl1;
            
            System.debug('le CV Id = '+cv.Id+ ' ou bien '+myCVId);
            
        }
        else{
			System.debug('le liste de doc 3 est  = '+cdlList);

            cdl1.ContentDocumentId = cdlList[0].ContentDocumentId;
            cdl1.LinkedEntityId = parentId;
            cdl1.ShareType = 'V';
            cdl1.Visibility = 'AllUsers';
            
            insert cdl1;

            System.debug('le parentId Id = '+parentId+ ' ou bien '+cdl1);
        }
            }
        else{}
        
        return myCVId; //cvl[0].Id;
    }

}