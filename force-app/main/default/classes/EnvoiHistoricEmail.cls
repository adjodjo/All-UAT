public class EnvoiHistoricEmail {
    
     @future
    public static void HistoricEmail(Id conId, String email, String ContentV, Id histId, Id template, String ccAdressesEmail , String FromEmail , String SF_Object){
        
         ///  PUR PRESENTATION
       //   email = 'stephan.laporte@analystik.ca';
       //   ccAdressesEmail = 'SPrefontaine-Fournier@clecapital.ca,dev@analystik.ca';

		
        
        
        
        System.debug('L ID de l historique est   '+histId+ ' et email est '+email);
        String Message = null, ContentDocId, linkId, ccEmail= ccAdressesEmail;
        String Error_Msg, accountId = null;
        set<String> ContentVersion = new set<String>();
         List<String> ccEmailList = new  List<String>();
        String likeTitle = '%'+ContentV+'%' ;       
        
        List<ContentDocumentLink> cdlList  = [SELECT Id, ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink WHERE LinkedEntityId = :histId limit 1];
        
        try{  //email = 'dev@analystik.ca';
            // Step 0: Create a master list to hold the emails we'll send
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
             //Messaging.SingleEmailMessage mailIDS =  new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add(email);
            system.debug('ccAdressesEmail--'+ccAdressesEmail);
            // Send To CC email setting
            if(ccAdressesEmail != null){
                if(String.isNotEmpty(ccAdressesEmail)){
                if(ccAdressesEmail.length() > 6){
                        
                ccEmailList = ManageCcEmail.ManageCcEmal(ccAdressesEmail);
              
                 mail.setCcAddresses(ccEmailList);
                
                    }
                }
            }
            
         
            // Step 3: Sender email setting
            
            List<OrgWideEmailAddress> owea = new List<OrgWideEmailAddress>();
            String address;
            
            if(FromEmail != null){
               system.debug('CECI EST LA COLLECTION');
               // address = ParametersUtils.getSACemail();
                owea = ParametersUtils.getCollectionOrgWideEmailAddress(FromEmail);
               // owea = ParametersUtils.getOrgWideEmailAddress(address);
            }
            else{
                system.debug('CECI EST LE SERVICE A LA CLIENTELE');
                address = ParametersUtils.getSACemail();
                owea = ParametersUtils.getOrgWideEmailAddress(address);
            }
            
             
          //  OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :address]; 
         /*   if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }*/
            if(FromEmail != null){
                mail.setReplyTo(FromEmail);
            }
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
                    linkId = cDocument.Id;
                    ContentDocId =  cDocument.ContentDocumentId;
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
            
            System.debug('email '+mail);
            
                mails.add(mail);
                 System.debug('test ');
                Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(mails);
            
             System.debug('le send result '+resultMail);
                
            if(resultMail[0].isSuccess()){
                    
                String mailTextBody = mail.getPlainTextBody();
                
                //String mailHtmlBody = mail.getHTMLBody().stripHtmlTags();
                
                String mailSubject = mail.getSubject();
            
                If (histId != null || histId != ''){
                    
                    List<sobject> recs = new List<sobject>();
                    system.debug('le FromEmail '+FromEmail);
                    
                    sObject myHistoric = Database.query ('SELECT Id, Email__c, CC_Email__c, Email_Subject__c, Agent_Email__c, Send_Status__c FROM '+ SF_Object +' WHERE Id = \''+histId+'\'  Limit 1');
                    String param = null;
                    
                    if (FromEmail != null) param = (FromEmail.substringAfter('@')).substringBefore('.');
                    
                     system.debug('le param '+param); 
                    
                    if((String)myHistoric.get('Id') != null  ){
                    myHistoric.put('Email__c',email );
                    myHistoric.put('CC_Email__c',ccemail );
                    myHistoric.put('Email_Subject__c',mailSubject );
                    myHistoric.put('Send_Status__c',' Successfully document send to '+email+', '+ccemail );
                    myHistoric.put('Agent_Email__c',param );
                     system.debug('le record a updater '+myHistoric);   
                    
                    recs.add(myHistoric);
                    
                    update recs;
                    }
                     
                     // After Send email operation is complete, set to empty email field to proted email-to-case Service and help this service to complete properly
                    
                    system.debug('le contact associé '+conId);
                    Contact sendContact = new Contact (id = conId, email = '' );
                    update sendContact;
                  
                }
            }
            system.debug('le test 2 '+ContentDocId);
            DeleteEmailAttachment(histId, ContentV, ContentDocId, linkId);
            
          //  EnvoiIDS(histId);
            
        }catch(System.EmailException ex)  {
            
             List<sobject> recs = new List<sobject>();
                    
                    sObject myHistoric = Database.query ('SELECT Id, Email__c, CC_Email__c, Agent_Email__c, Email_Subject__c, Send_Status__c FROM '+ SF_Object +' WHERE Id = \''+histId+'\'  Limit 1');
                    
                    if((String)myHistoric.get('Id') != null  ){
                    
                    myHistoric.put('Send_Status__c',' Missing document send ... '+email );
                    
                    recs.add(myHistoric);
                    
                    update recs;
                DeleteEmailAttachment(histId, ContentV, ContentDocId, linkId);
                    }
            
            Error_Msg = ex.getMessage();
            
           
        }
        
    }
    
    
    
    public static void DeleteEmailAttachment( Id histId, String ContentV, String ContentDocId, String linkId ){
        
        system.debug('ceci est test delete');
        
        ContentDocumentLink lcd = new ContentDocumentLink(id = linkId );
        
        ContentDocument cDoc = new ContentDocument(id = ContentDocId);
        
        Delete lcd;
        
        Delete cDoc;
        
    }
   
}