public class QueriesUtils {
    
    // OrgWideEmailAddress using on FROM sending email 
    public static List<OrgWideEmailAddress> getOrgWideEmailAddress(String address){
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :address];
        
        return owea;
    }
    
    public static Boolean callSendEmail(Id ContactId, String email, String ContentV, Id histId, Id tempId, List<String> ccEmailList){
        
        boolean isSend = false;
        
       /* if(((email.substringAfter('@')).containsIgnoreCase('clecapital.ca'))
                   					|| ((email.substringAfter('@')).containsIgnoreCase('hitachicapital.ca'))
                                   || ((email.substringAfter('@')).containsIgnoreCase('analystik.ca'))){
                                  */     
                                  EnvoiEmailUnique.myUniqueEmail(ContactId, email, ContentV, histId, tempId, ccEmailList);
                                   isSend = true;
                                  
                                //   }
        
        return isSend;
    }
        


}