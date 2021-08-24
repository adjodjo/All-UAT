public class Case_GetEmailAttachment {
    
    public static Map<Id, List<ContentVersion>> GetEmailAttachment(List<String> em, String CaseId){
        
        List<String> links = new List<String>();
        
        Map<Id, List<ContentVersion>> mapCEM = new Map<Id, List<ContentVersion>>();
    
     	List<ContentDocumentLink> CD = [SELECT ContentDocumentId, LinkedEntityId  
                                        FROM ContentDocumentLink 
                                        where  LinkedEntityId  = :em OR LinkedEntityId  = :CaseId];

        for(ContentDocumentLink c : CD){
            links.add(c.ContentDocumentId);
        }

        List<ContentVersion> myCV = [Select Id, ContentDocumentId,VersionData,Title,PathOnClient, FileType, FileExtension  
                                     from ContentVersion 
                                     where ContentDocumentId IN :links AND IsLatest = true]; 
        System.debug(' Case_ ---> '+ CD + ' ----- '+myCV);
        
        
         //   for(ContentVersion cv : myCV){
                for(ContentDocumentLink cl : CD){
                
             //   if(cv.ContentDocumentId == cl.ContentDocumentId){
                    mapCEM.put(cl.LinkedEntityId, myCV);
             //   }
          //  }
        }
        
        return mapCEM;
	}
}