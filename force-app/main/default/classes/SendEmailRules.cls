public class SendEmailRules {
    
    static final String message_2 = 'message_2';
    static final String message_6 = 'message_6';
    static final String message_7 = 'message_7';
    static final String message_8 = 'message_8';
    static final String message_9 = 'message_9';
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///                           BUILD SEND EMAIL USING HISTORIC INFORMATIONS
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    public  static String  BuildSendEmail(String RecordId){
        
        String err_Msg = null, userLanguage = UserInfo.getLanguage(); 
        
        String Obj='Historic',  ContentV, histId, recId,origine, TypeNote, BuyouType, email, ccEmail, accId, langue, contactId = null, AccountId = null, contId, contEmail, custId, InfoLease, OperationType, Error_Msg = null, myId = RecordId, tempId = null, descEquip;
        Date dateB;
        Decimal mRachat, bendOfT, TRF, TRP, balance, TRH, bTotalAmount, bRate, bTerm;
        List<String> ccEmailList = new  List<String>();
        
        System.debug('ceci est un autre test '+ RecordId);
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        // Email BUYOUT envoyé de l'Historique
        //////////////////////////////////////////////////////////////////////////////////////////////
        //if(ObjectName == 'Historique__c'){
        
        List<Historique__c> myHistoric = [SELECT Id, Contact__c, ExternalDocumentInfo1__c, Email__c, CC_Email__c, Account__c, Buyout_Type__c, Type_Note__c, Langue_communication__c, 
                                          CustId__c, Contrat_InfoLease__c, Operation_Type__c
                                          FROM Historique__c WHERE Id = :RecordId Limit 1];
        
        System.debug('ceci est un Historique '+myHistoric.size()+ ' et le historique Id est '+RecordId);
        
        if(myHistoric.size()>0){
           // buyoutObject = 'Historic';
            
       //     System.debug('ceci est un '+buyoutObject);
            for (Historique__c myHistorique : myHistoric) {
                
                
                AccountId = myHistorique.Account__c;
                ContactId = myHistorique.Contact__c;
                ContentV = myHistorique.ExternalDocumentInfo1__c;
                histId = myHistorique.Id;
                email = myHistorique.Email__c;
                ccEmail = myHistorique.CC_Email__c;
                accId = myHistorique.Account__c;
                TypeNote = myHistorique.Type_Note__c;
                BuyouType = myHistorique.Buyout_Type__c;
                OperationType = myHistorique.Operation_Type__c;
                langue = myHistorique.Langue_communication__c;
                custId = myHistorique.CustId__c;
                InfoLease = myHistorique.Contrat_InfoLease__c;
                
                System.debug('voici l historique '+myHistorique);
            }
            
            /////////////////////////////////////////////////////////////////////////////////////////////////////
            //          VALIDATION EMAIL D'ENVOI 
            ////////////////////////////////////////////////////////////////////////////////////////////////////             
            
            if (ContactId == null  ){
                
                System.debug('voici le contact supposé null '+ContactId);
                err_Msg = MessageUtils.ErrorMessage(userLanguage, message_2); //Error_Msg ='Pas de contact ';
                myId = null;
            }
            else{
                
                
                system.debug('Les emails rn entrée sont  '+email+ ' et le contact est '+ContactId);
                
                // validate email information from EIP using to send email  
                
                if(email == null || email == '' || String.isEmpty(email) ){ 
                    system.debug('email est   '+email);
                    
                    
                    Account acc = [select id, Compagnie_Email__c, Contact_Principal__c from Account where id = :AccountId ];
                    
                    system.debug('le conCompte  est   '+acc);
                    
                    
                    if(  acc.Compagnie_Email__c == null || acc.Compagnie_Email__c  == '' || acc.Compagnie_Email__c  == 'none@clecapital.ca' ){ 
                        system.debug('Compagnie_Email_c est   ' +acc.Compagnie_Email__c);
                        
                        List<Contact> Hcontact = [Select name, Email_Permanent__c, id from Contact where id = :ContactId];
                        system.debug('La liste de contact 3 est '+Hcontact);
                        for (Contact cont : Hcontact){
                            contEmail = cont.Email_Permanent__c;
                            contId = cont.Id;
                            
                        }
                        
                        
                        if(contEmail == null || contEmail == '' || contEmail == 'none@clecapital.ca' || String.isEmpty(contEmail)){
                            email = null;
                            myId = null;
                            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_7);
                            // Error_Msg = 'Missing email, can not send email to the account';
                        }
                        else{
                            contactId = contId;
                            email = contEmail;
                        }
                    }
                    else{
                        email = acc.Compagnie_Email__c;
                        contactId = contId;  
                    }
                    // Mise à jour de L'historique avant envoi du Buyout à la nuvelle email adresse
                    Historique__c updateHist = new Historique__c(Id = RecordId, Email__c = email);
                    update updateHist;
                }
                else{
                    email = email;
                    contactId = contactId; 
                    
                    
                    
                    system.debug('Les emails en sortie sont  '+email +' et '+email+ 'Le contact Id est '+contactId);
                    
                    
                    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    // CC Email Adresses
                    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    
                    if(String.isNotBlank(ccEmail) || ccEmail != null ){
                        
                        ccEmailList = ManageCcEmail.ManageCcEmal(ccEmail);
                        
                        
              
                    }
                    
                   
                    
                    
                    
                    /////////////////////////////////////////////////////////////////////////////////////////////////////
                    //          ENVOI DU BUYOUT 
                    ////////////////////////////////////////////////////////////////////////////////////////////////////  
                   
                    if(((TypeNote == 'Buyout' && ( String.isNotBlank(email)))  &&  String.isNotBlank(BuyouType))){
                    
                    /*if(((TypeNote == 'Email' && ( String.isNotBlank(email)))  && (BuyouType !='Total Refinancing' && String.isNotBlank(BuyouType))) ||
                       ((TypeNote == 'Email' && ( String.isNotBlank(email)))  && ((BuyouType =='Total Refinancing' && String.isNotBlank(BuyouType)) &&  (email.contains('clecapital'))|| email.contains('hitachi')))){
                     */      
                           system.debug('BuyouType '+BuyouType+'  email  '+email+'  TypeNote  '+TypeNote);
                           String templateName = null, searchText = null;
                           
                           //BUYOUT OPERATION TYPE   
                           
                           
                           
                           String infoLId = InfoLease.Left(3);
                           system.debug('le lease contract est  '+infoLId+ ' et operation type '+OperationType);
                           
                           
                           ////////////////////////////////////////////////////////
                           //        TEMPLATE POUR LEASE CONTRACT
                           //        Find template depend on Language and Contract number type
                           ///////////////////////////////////////////////////////////////
                           
                           if(OperationType == 'LEASE' ){
                               if(langue == 'FR'){
                                   if(infoLId == '025'|| infoLId == '026'||infoLId == '027'|| infoLId == '060')  templateName='_terme_HCC_FR'; 
                                   
                                   else 
                                       if (infoLId == '051'|| infoLId == '052'||infoLId == '065') templateName='_terme_CLE_FR'; 
                                   
                                   else {
                                       err_Msg = MessageUtils.ErrorMessage(userLanguage, message_8);// Error_Msg ='Le numéro de Contrat n\'est pas pis en charge ';
                                       myId = null;
                                   }
                               }           
                               else 
                               {
                                   if(infoLId == '025'|| infoLId == '026'||infoLId == '027'|| infoLId == '060') templateName='_terme_HCC_EN'; 
                                   
                                   else  
                                       if (infoLId == '051'|| infoLId == '052'||infoLId == '065') templateName='_terme_CLE_EN';
                                   
                                   else{ 
                                       err_Msg = MessageUtils.ErrorMessage(userLanguage, message_8); //Error_Msg ='Le numéro de Contrat n\'est pas pis en charge ';
                                       myId = null;
                                   }
                               }
                           }
                           
                           
                           ////////////////////////////////////////////////////////
                           //        TEMPLATE POUR LOAN CONTRACT
                           //        Find template depend on Language and Contract number type
                           ///////////////////////////////////////////////////////////////
                           
                           else { 
                               if(OperationType == 'LOAN' ){
                                   
                                   if(langue == 'FR'){
                                       if(infoLId == '025'|| infoLId == '026'||infoLId == '027'|| infoLId == '060') templateName='_terme_HCC_FR'; 
                                       
                                       else 
                                           if (infoLId == '051'|| infoLId == '052'||infoLId == '065') templateName='_terme_CLE_FR'; 
                                       else {
                                           err_Msg = MessageUtils.ErrorMessage(userLanguage, message_8); //Error_Msg ='Le numéro de Contrat n\'est pas pis en charge ';
                                           myId = null;
                                       }
                                   }           
                                   else 
                                   {
                                       if(infoLId == '025'|| infoLId == '026'||infoLId == '027'|| infoLId == '060') templateName='_terme_HCC_EN'; 
                                       
                                       else 
                                           if (infoLId == '051'|| infoLId == '052'||infoLId == '065') templateName='_terme_CLE_EN'; 
                                       else {
                                           err_Msg = MessageUtils.ErrorMessage(userLanguage, message_8); //Error_Msg ='Le numéro de Contrat n\'est pas pis en charge';
                                           myId = null;}
                                   }
                               }
                               
                               else err_Msg = MessageUtils.ErrorMessage(userLanguage, message_8);
                           }
                           
                           system.debug('le Contact est contactId '+ContactId+' et email est '+email+ ' et le template name est '+templateName);
                           
                           update new contact(id = ContactId , email = email);
                           
                           
                           if(templateName != null){
                               
                               searchText = '%'+templateName;
                               
                               EmailTemplate template = [SELECT Id, Name FROM EmailTemplate WHERE developername LIKE :searchText limit 1];
                               
                               tempId = template.Id;
                               system.debug('envoi email '+template+ 'langue '+email+ ' ContactId '+ContactId+ ' tempId '+tempId+' ContentV '+ContentV);
                               
                               
                               
                               ////////////////////////////////////////////////////////
                               //        Appel ENVOI DES EMAILS
                               ///////////////////////////////////////////////////////////////
                               
                               Boolean isSend = ParametersUtils.callSendEmail(ContactId, email, ContentV, histId, tempId, ccEmailList);
                               
                               if(isSend == false){
                                   err_Msg = MessageUtils.ErrorMessage(userLanguage, message_9);
                                   myId = null;

                               }
                               else {
                                   
                                   EnvoiEmailUnique.myUniqueEmail(ContactId, email, ContentV, histId, tempId, ccEmailList);
                                   myId = histId; 
                               }                           
                           }
                           else {
                               
                               myId = null;
                               err_Msg = MessageUtils.ErrorMessage(userLanguage, message_8);
                               
                               system.debug( 'le TypeNote est '+ TypeNote+ ' err_Msg '+err_Msg + ' Obj '+Obj);
                               
                               //Error_Msg ='Pas de template ';
                           }                        
                           
                       }
                    else {
                        //update new Historique__c(Id = histId, contenu__c = 'EMAIL NON ENVOYÉ - VÉRIFIEZ LES CRITÈRES ');
                        myId = null;
                        err_Msg = MessageUtils.ErrorMessage(userLanguage, message_8);
                        //Error_Msg = 'Vérifiez les paramètres Type de Buyout et Email d\'envoi.';
                    } 
                    
                }
            }            
        }            
        else{ 
            myId = null;
            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_6);
            system.debug(' Aucune action n\'a été manée '+err_Msg);
        }
       // Obj = buyoutObject;
        // system.debug(' La réponse send Rulee est  '+JSON.serialize(new sendCustomResponse(err_Msg)).remove('\\'));
        //return JSON.serialize(new sendCustomResponse( err_Msg)).remove('\\'); //myId;
         return JSON.serialize(new CustomResponse(myId, Obj, err_Msg)).remove('\\'); //myId;  
    }
    
    
    
}