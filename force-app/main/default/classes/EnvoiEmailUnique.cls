public class EnvoiEmailUnique {
    
    
    @future
    public static void myUniqueEmail(Id conId, String email, String ContentV, Id histId, Id template, List<String> ccAdressesEmail){
        
        System.debug('L ID de l historique est   '+histId);
        String Message = null;
        String Error_Msg, accountId = null;
        set<String> ContentVersion = new set<String>();
        
        String likeTitle = '%'+ContentV+'%' ;       
        
        List<ContentDocumentLink> cdlList  = [SELECT Id, ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink WHERE LinkedEntityId = :histId limit 1];
        
        try{  
            // Step 0: Create a master list to hold the emails we'll send
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
             //Messaging.SingleEmailMessage mailIDS =  new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add(email);
            
            /*String[] toAddresses = new String[] {'dev@analystik.ca'};
            mail.setToAddresses(toAddresses);*/
           
            System.debug('Emails de reception  '+sendTo+ ' Avec les emails en entree '+email);
            
            // Send To CC email setting
             mail.setCcAddresses(ccAdressesEmail);
            
            
            // Step 3: Sender email setting
            
             String address = ParametersUtils.getSACemail();
            List<OrgWideEmailAddress> owea = ParametersUtils.getOrgWideEmailAddress(address);
           
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
                   
          
           
            // Step 4. Set email contents - you can use variables!
            mail.setSaveAsActivity(false);
            mail.setTemplateId(template);
            mail.setTargetObjectId(conId);
            mail.setWhatId(histId);
            
            //Step 5. Set email file attachments
            
            if(cdlList.size() <= 1){
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                Messaging.Emailfileattachment attachment = new Messaging.Emailfileattachment(); 
                
                for(contentDocumentLink cDocument : cdlList)   {
                    //    attachment.setBody(cdocument.ContentDocument.LatestPublishedVersion);
                    List<ContentVersion> lastCV = [SELECT Title, VersionData FROM ContentVersion where ContentDocumentId =: cDocument.ContentDocumentId limit 1];
                    
                    for (ContentVersion document: lastCV) {            
                        // Add to attachment file list
                        
                        attachment.setBody(document.VersionData);
                        attachment.setFileName(document.Title);
                        System.debug('ceci est l attachement '+attachment);
                        fileAttachments.add(attachment);
                    }
                    
                }
                
                
                System.debug('ceci est l attachement '+fileAttachments.size());
                
                if(fileAttachments.size() > 0){
                    mail.setFileAttachments(fileAttachments);        
                }
                else mail.setFileAttachments(null);
           	 }
            
            
                mails.add(mail);
                
                Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(mails);
                if(resultMail[0].isSuccess()){
                    
                String mailTextBody = mail.getPlainTextBody();
                
                //String mailHtmlBody = mail.getHTMLBody().stripHtmlTags();
                
                String mailSubject = mail.getSubject();
                
                If (histId != null || histId != ''){
                    Historique__c emailHist = [Select id, Send_Status__c, CC_Email__c FROM Historique__c Where id = :histId ];
                    String sendStatus = 'Historique envoyé à:  Email principal: '+email+ ',   CC email: '+ccAdressesEmail;
                    Historique__c histObject = new Historique__c(id = histId, sujet__c = mailSubject, Send_Status__c = sendStatus );
                    List<Historique__c> myHistoriqueList = new List<Historique__c>();
                    myHistoriqueList.add(histObject);
                    
                    Update myHistoriqueList;
                    
                    Error_Msg = 'Successfully email send';
                    
                     // After Send email operation is complete, set to empty email field to proted email-to-case Service and help this service to complete properly
                    system.debug('le contact associé '+conId);
                    Contact sendContact = new Contact (id = conId, email = '' );
                    update sendContact;
                    
                }
            }
            
          //  EnvoiIDS(histId);
            
        }catch(System.EmailException ex)
        {
            Error_Msg = ex.getMessage();
            System.debug('Impossible d\'envoyer l\'email car '+Error_Msg);
            
            Historique__c histObject = new Historique__c(id = histId); //,  contenu__c = 'EMAIL NON ENVOYÉ', RecordTypeId = RT ); //'EMAIL NON ENVOYÉ'
            List<Historique__c> myHistoriqueList = new List<Historique__c>();
            //myHistoriqueList.add(histObject);
            
            Update myHistoriqueList;
            
        }
        
    }
    

}