public class Case_GetEmailMessage {
    
    public static List<EmailMessage> GetEmailMessage(String caseId){
        
       
       
        List<EmailMessage> lmess = [Select HasAttachment, MessageDate, CreatedDate, Id, ParentId, Incoming, RelatedToId, Subject, TextBody, 
                                    FromAddress, ToAddress, ValidatedFromAddress, ReplyToEmailMessageId , HtmlBody
                                    from EmailMessage 
                                    where RelatedToId = :caseId // '5003K000002BnhcQAC' 
                                    Order By MessageDate DESC limit 1];
        
       
     //   System.debug(' lmess ---> ----- '+lmess);
        
        
        return lmess;
    }
    
    
    

}