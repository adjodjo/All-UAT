public class Case_SendRedirectEmail {
    
    public Static void SendRedirectEmail(List<EmailMessage> lEM, List<ContentVersion> mapCV, String cQueueEmail, List<Case> lcase){
       
        String caseId, eId, eSubject, eTexte, eFromAdd, eToAdd, ehtmlbody;
       List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
         system.debug(' mapCV est -- .'+mapCV);
        try{
          
            if(mapCV !=null && !mapCV.isEmpty() ){
                if(mapCV != null){
            for(ContentVersion cv : mapCV){
                Messaging.Emailfileattachment attachment = new Messaging.Emailfileattachment(); 
                attachment.setBody(cv.VersionData);
                String fiteTitle = cv.Title+'.'+cv.FileExtension;
                attachment.setFileName(fiteTitle);
                attachment.setInline(false);
                system.debug(' FileExtension est -- .'+cv.FileExtension+ '---- fileType est ---'+cv.fileType);
                if(cv.fileType == 'PDF') {                   
                    attachment.setContentType('application/'+cv.fileType);
                    system.debug('le content type est ----  application/'+cv.fileType+ '---- fileType est ---'+cv.fileType);                    
                } 
                if(cv.FileExtension == '.txt' || cv.FileExtension == '.csv') attachment.setContentType('text/plain');
                if(cv.FileExtension == '.png' || cv.FileExtension == '.jpeg' || cv.FileExtension == '.gif' || cv.FileExtension == '.jpg') 
                    attachment.setContentType('image/'+cv.FileExtension);
                if(cv.FileExtension == '.doc' || cv.FileExtension == '.docx') attachment.setContentType('application/msword');
                //else attachment.setContentType('application/octet-stream');
                attachments.add(attachment);
            }}
        }
             system.debug(' attachments est -- .'+attachments);
            
            for(EmailMessage eMsg : lEM){
                
                eId = eMsg.Id;
                eSubject = eMsg.Subject;
                eTexte = eMsg.TextBody;
                eFromAdd = eMsg.FromAddress;
                eToAdd = eMsg.ToAddress;
                ehtmlbody = eMsg.htmlbody;
               
            }
            if(eId == null){
                    eTexte = lcase[0].Description;
                    eSubject = lcase[0].Subject;
                    
                }
            if(eTexte == null){
                eTexte = 'aucun message';
            }
            
          system.debug(' eSubject -- .'+eSubject+ '--- eTexte --'+eTexte);
            
             // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add(cQueueEmail);
            mail.setToAddresses(sendTo);
            system.debug(' email de reception est -- .'+sendTo);
            // Step 3: Sender email setting
            List<OrgWideEmailAddress> owea = new List<OrgWideEmailAddress>();
            String address;
            
                system.debug('CECI EST LE SERVICE A LA CLIENTELE');
                address = ParametersUtils.getSACemail();
                owea = ParametersUtils.getOrgWideEmailAddress(address);
            
            system.debug('CECI EST LE SAC '+address+' -- et--'+owea );
         
             if ( owea.size() > 0 ) {  
                 
                mail.setReplyTo(eFromAdd);
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            mail.setSubject(eSubject);
            
            mail.setPlainTextBody( eTexte);
            
            mail.setHtmlBody(ehtmlbody);
            If(attachments.size() > 0){
                 mail.setFileAttachments(attachments);
            }
               
           

             system.debug(' email de envyé est -- .'+mail);
            
             mails.add(mail);
                 System.debug('test ');
                Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(mails);   
             if(resultMail[0].isSuccess()){
                 system.debug(' envoi réussit');
             }
            else{
                 system.debug(' echec');
            }
          
        }catch(Exception ex){
            
            system.debug(' Impossible de envoyer email -- '+ex.getStackTraceString());
        }
        
        
    }

}