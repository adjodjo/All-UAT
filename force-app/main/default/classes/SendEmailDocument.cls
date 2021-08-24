public class SendEmailDocument {
    
    static final String message_2 = 'message_2';
    static final String message_6 = 'message_6';
    static final String message_7 = 'message_7';
    static final String message_8 = 'message_8';
    static final String message_4 = 'message_4';
    static final String message_9 = 'message_9';
    
    public static String DocumentEmail(String RecordId, String SF_Object, SettingSendHistoric S_Historic, String HistoricType){
        
        String err_Msg = null, userLanguage = UserInfo.getLanguage();
        System.debug('HistoricType '+HistoricType);
        //String SF_Object = S_Historic.SF_Object;
        String histId = S_Historic.SF_HistoryId;
        String  Obj, contactId, email, contEmail, contId, templateName = null, searchText, templateId, LetterFileName = null;
        SF_Object = SF_Object+'__c';
        sObject  myHistoric;
        List<sobject> recs = new List<sobject>();
        
        try{   
            System.debug('selection '+SF_Object+' id '+histId);
            myHistoric = Database.query ('SELECT Id, Contact__c,  Email__c, CC_Email__c, Agent_Email__c, Name, Account__c, Letter_Type__c, Langue_communication__c,'+ 
                                         'CustId__c, InfoLease_Contrat__c, Email_Subject__c, Send_Status__c FROM '+ SF_Object +' WHERE Id = \''+histId+'\'  Limit 1');
            
            System.debug('id selection '+myHistoric.Id+ ' SF_Object '+SF_Object+ ' Letter_Type__c '+(String)myHistoric.get('Letter_Type__c') );
            
            if((String)myHistoric.get('Id') != null  ){
                system.debug('le contact Name est '+S_Historic.EIP_Contact);
                contactId = Manage_EIP_Informations.Manage_Informations(S_Historic.EIP_Contact, (String)myHistoric.get('Account__c'), S_Historic.SendEmail);
                system.debug('le contactId est '+contactId);
                String se = S_Historic.SendEmail;
                
                if(String.isNotBlank(se) || String.isNotEmpty(se)){ //(S_Historic.SendEmail).length() > 0)  se != null || 
                    system.debug('le email lengh est '+(S_Historic.SendEmail).length());
                    
                    system.debug('le email lengh est ');
                    email = S_Historic.SendEmail;
                    
                    
                    if (contactId == null ){
                        
                        System.debug('voici le contact supposé null '+contactId);
                        err_Msg = MessageUtils.ErrorMessage(userLanguage, message_2); //Error_Msg ='Pas de contact ';
                        //histId = null;
                    }
                    else{
                        
                        
                        //   myHistoric = Database.query ('SELECT Id, Email__c, CC_Email__c, Email_Subject__c, Send_Status__c, Content__c, Contact__c FROM '+ SF_Object +' WHERE Id = \''+histId+'\'  Limit 1');
                        
                        //   if((String)myHistoric.get('Id') != null  ){
                        myHistoric.put('Email__c',email );
                        myHistoric.put('CC_Email__c',S_Historic.CcSendEmail );
                        myHistoric.put('Agent_Email__c',S_Historic.FromEmail );
                        myHistoric.put('Content__c',S_Historic.EIP_EmailMessage );  
                        myHistoric.put('Contact__c',contactId );  
                        myHistoric.put('Email_Subject__c',S_Historic.EIP_EmailSubject );     
                        
                        recs.add(myHistoric);
                        system.debug(' myHistoric '+recs+ ' from email --'+ S_Historic.FromEmail);
                        update recs;
                        
                        //  }
                    }
                    
                }   
                else{          system.debug('ceci est un test ...   ');     
                     Account acc = [select id, Compagnie_Email__c, Contact_Principal__c from Account where id = :(String)myHistoric.get('Account__c') ];
                     
                     system.debug('le conCompte  est   '+acc);
                     if(acc.id != null){
                         system.debug('Compagnie_Email_c est   ' +acc.Compagnie_Email__c);
                         if(  acc.Compagnie_Email__c != null  ){ //|| acc.Compagnie_Email__c  == '' || acc.Compagnie_Email__c  == 'none@clecapital.ca' || ///  || acc.Compagnie_Email__c  != '' || acc.Compagnie_Email__c  != 'none@clecapital.ca' || String.isNotBlank(acc.Compagnie_Email__c ) || String.isNotEmpty(acc.Compagnie_Email__c )
                             
                             email = acc.Compagnie_Email__c;
                             
                             system.debug('le test email  est   '+email);
                         }
                         else {
                             system.debug('le contact name  est   '+(String)myHistoric.get('Contact__c'));                       
                             List<Contact> Hcontact = [Select name, Email_Permanent__c, id from Contact where Name = :S_Historic.EIP_Contact AND AccountId =:(String)myHistoric.get('Account__c')  ];
                             system.debug('La liste de contact 3 est '+Hcontact);
                             
                             for (Contact cont : Hcontact){
                                 contEmail = cont.Email_Permanent__c;
                                 contId = cont.Id;
                                 
                             }
                             
                             if(contEmail != null || contEmail != '' || contEmail != 'none@clecapital.ca' ) { // || contEmail == '' || contEmail == 'none@clecapital.ca' || String.isEmpty(contEmail)){
                                 email = contEmail;
                             }   
                             else{
                                 
                                 email = null;
                                 histId = null;
                                 err_Msg = MessageUtils.ErrorMessage(userLanguage, message_7);
                                 // Error_Msg = 'Missing email, can not send email to the account';
                             }
                             
                         }
                         
                         
                         //  myHistoric = Database.query ('SELECT Id, Email__c, CC_Email__c, Email_Subject__c, Send_Status__c, Content__c, Contact__c FROM '+ SF_Object +' WHERE Id = \''+histId+'\'  Limit 1');
                         
                         //  if((String)myHistoric.get('Id') != null  ){
                         myHistoric.put('Email__c',email );
                         myHistoric.put('CC_Email__c',S_Historic.CcSendEmail );
                         myHistoric.put('Content__c',S_Historic.EIP_EmailMessage );
                         myHistoric.put('Agent_Email__c',S_Historic.FromEmail );                    
                         myHistoric.put('Contact__c',contactId );
                         myHistoric.put('Email_Subject__c',S_Historic.EIP_EmailSubject ); 
                         
                         recs.add(myHistoric);
                         system.debug(' myHistoric 2'+recs);
                         update recs;
                         
                     }
                    }
                
                if(histId != null && (S_Historic.SendEmail != null || email != null) ){
                    
                    if(email == 'none@clecapital.ca'){
                        List<sobject> recs1 = new List<sobject>();
                        err_Msg ='Send email invalid '; 
                        system.debug(' msg'+err_Msg);
                        myHistoric.put('Send_Status__c', 'Missing document send '+err_Msg+' '+email);
                        recs1.add(myHistoric);
                        system.debug(' myHistoric 3'+recs1);
                        update recs1;               
                    }
                    else{
                        
                        LetterFileName = (S_Historic.DMS_FileName).substringBefore('.pdf')+'_'+(String)myHistoric.get('Name')+'.PDF';
                        
                        system.debug('LetterFileName = '+LetterFileName);
                        
                        Id contenVersionId = ImporterDocument.SauvegerPieceJointe(LetterFileName, S_Historic.DMS_File, S_Historic.DMS_DocType, histId, null, HistoricType); //S_Historic.DMS_FileName
                        
                        if(contenVersionId != null){
                            
                            ////////////////////////////////////////////////////////
                            //        TEMPLATE POUR PAR CONTRACT
                            //        Find template depend on Language and Contract number type
                            ///////////////////////////////////////////////////////////////
                            
                            String Temp = null, TempName = null, lang = null, infoLId = null;
                            
                            Temp = ((String)myHistoric.get('Letter_Type__c')).left(6);
                            
                            if(Temp == 'Retard'){
                                TempName = Temp;
                            }
                            else{
                                TempName = (String)myHistoric.get('Letter_Type__c');
                            }
                            
                            lang = (String)myHistoric.get('Langue_communication__c');
                            
                            
                            if((String)myHistoric.get('InfoLease_Contrat__c') != null){
                                infoLId = ((String)myHistoric.get('InfoLease_Contrat__c')).Left(3);
                            }
                            system.debug('le Agent_Email__c est  = '+(String)myHistoric.get('Agent_Email__c')+ ' --Le template  est --- '+ TempName);
                            templateName = getEmailTemplate.EmailTemplate(TempName, infoLId, lang);
                            
                            
                            
                            ////////////////////////////////////////////////////////
                            //       Get specific template
                            ///////////////////////////////////////////////////////////////
                            
                            if(templateName != null){
                                
                                searchText = templateName;
                                system.debug('searchText = '+searchText);
                                
                                List<EmailTemplate> template = [SELECT Id, Name FROM EmailTemplate WHERE developername LIKE :searchText limit 1];
                                system.debug('le size est  = '+template.size());
                                
                                //  email = 'stephan.laporte@analystik.ca';
                                // String  ccAdressesEmail = 'SPrefontaine-Fournier@clecapital.ca,dev@analystik.ca';
                                
                                
                                if(template.size() > 0){
                                    templateId = template[0].Id;
                                    system.debug('envoi email '+template+ 'langue '+email+ ' ContactId '+ContactId+ ' tempId '+templateId+' ContentV '+LetterFileName);
                                    
                                    
                                    ////////////////////////////////////////////////////////
                                    //        Appel ENVOI DES EMAILS
                                    ///////////////////////////////////////////////////////////////
                                    
                                    
                                    
                                    update new contact(id = ContactId, email = email );
                                    EnvoiHistoricEmail.HistoricEmail(ContactId, email, LetterFileName, (String)myHistoric.get('Id'), templateId, S_Historic.CcSendEmail, S_Historic.FromEmail , SF_Object); //S_Historic.DMS_FileName   S_Historic.CcSendEmail  (String)myHistoric.get('ExternalDocumentInfo1__c')
                                    
                                    histId = (String)myHistoric.get('Id');               
                                    
                                    
                                }
                                else{
                                    //  String searchText1 = 'Other_Letter';
                                    searchText = templateName;
                                    
                                    List<EmailTemplate> template1 = [SELECT Id, Name FROM EmailTemplate WHERE developername LIKE :searchText limit 1];
                                    system.debug('searchText = '+searchText+ ' le size est '+template1.size());
                                    update new contact(id = ContactId, email = email );
                                    EnvoiHistoricEmail.HistoricEmail(ContactId, email, S_Historic.DMS_FileName, (String)myHistoric.get('Id'), template1[0].Id, S_Historic.CcSendEmail, S_Historic.FromEmail, SF_Object); //(String)myHistoric.get('ExternalDocumentInfo1__c')
                                    //S_Historic.DMS_FileName
                                    histId = (String)myHistoric.get('Id'); 
                                    
                                    //   histId = null;
                                    //err_Msg ='Missing email template';
                                }
                                
                            }
                            else{
                                err_Msg ='Missing email template';
                            }
                            
                            
                        }
                        /////////////////////////////////////////////////////////
                        else {
                            //histId = null;
                            err_Msg = 'Missing attachement';
                            //Error_Msg ='Pas de template ';
                        }
                    }
                    
                }
                
                //////////////////////////////////////////
                else{
                    // histId = null;
                    err_Msg = MessageUtils.ErrorMessage(userLanguage, message_9);
                    
                }
            }
            else{
                //histId = null;
                err_Msg = MessageUtils.ErrorMessage(userLanguage, message_9);
                
            }
        }catch(Exception ex){
            
            //histId = null;
            err_Msg = ex.getMessage();
        }
        
        return JSON.serialize(new sendCustomResponse(err_Msg)).remove('\\');   
    }
    
}