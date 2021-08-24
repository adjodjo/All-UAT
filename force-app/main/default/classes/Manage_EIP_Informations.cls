public with sharing class Manage_EIP_Informations {

    static final String message_1 = 'message_1';
    static final String message_2 = 'message_2';
    static final String message_3 = 'message_3';
    static final String message_4 = 'message_4';
    static final String message_10 = 'message_10';
    static final String message_11 = 'message_11';
	
 /*   public static String Build_OtherFees(SettingInvoiceHistoric InvoiceSettings) {
        
        String otherfee = null;
        for(Integer i = 0; i < InvoiceSettings.EIP_OtherFee.size(); i++){
                    system.debug('la taille '+ InvoiceSettings.EIP_OtherFee.size() + ' La description est '+ i + ' '+otherfee);
                    if( i == 0 && InvoiceSettings.EIP_OtherFee[i] != null) otherfee = InvoiceSettings.EIP_OtherFee[i];
                    else {
                        if(InvoiceSettings.EIP_OtherFee[i] != null && ( otherfee != null || otherfee != '')){
                            otherfee = otherfee+', '+InvoiceSettings.EIP_OtherFee[i];
                        }
                    } 
                    system.debug('La liste de equipement est '+i+' eipDescription[i] ='+InvoiceSettings.EIP_OtherFee[i]+' '+otherfee);
                }

        return otherfee;
    }*/
    
    
    //  Manage global EIP information
    public static String Manage_Informations(SettingsHistoricsAPI HistorySettings) {

        String err_Msg = null, userLanguage = UserInfo.getLanguage();

        System.debug('Le contact en provenance de EIP est 2 ='+HistorySettings.eipContact);
        
        String description = null, buyoutType= null,  userId = null, userEmail = null, partialType = null;
        
        String parentId = null, contactId=null;
        
        String tel, cp, ville,   mail,street, state, country,  cPrincipal, cEm, cId, contactResp;
        
        Map<String, Object> response;

        try{

             system.debug('********** Le compte est ***********2 = '+HistorySettings.eipAccount);

            if(HistorySettings.eipAccount == null || HistorySettings.eipAccount == ''  ){
                parentId = null;
                err_Msg = MessageUtils.ErrorMessage(userLanguage, message_1);
                //err_Msg = 'Missing Account identification, can not send email to no account';
            }
            else{
                ///   BUILD EQUIPEMENT DESCRIPTION   ////////////////////////////////////////////////////////////////////////////////////////////
                for(Integer i = 0; i < HistorySettings.eipDescription.size(); i++){
                    system.debug('la taille '+ HistorySettings.eipDescription.size() + ' La description est '+ i + ' '+description);
                    if( i == 0 && HistorySettings.eipDescription[i] != null) description = HistorySettings.eipDescription[i];
                    else {
                        if(HistorySettings.eipDescription[i] != null && ( description != null || description != '')){
                            description = description+', '+HistorySettings.eipDescription[i];
                        }
                    } 
                    system.debug('La liste de equipement est '+i+' eipDescription[i] ='+HistorySettings.eipDescription[i]+' '+description);
                }

                system.debug('La liste de equipement est '+description);

               
                 ///// DEFINE IF IT IS PARTIAL OR NOT /////////////////////////////////////////////////////////
                
                 If (HistorySettings.eipPartialType == true) {
                     
                     if(HistorySettings.eipLangue == 'FR'){
                         partialType = 'Rachat Partiel';
                     }
                     else {
                         partialType = 'Partial Buyout';
                     }
                 }
                else{
                    
                     if(HistorySettings.eipLangue == 'FR'){
                         partialType = 'Rachat Complet';
                     }
                     else {
                         partialType = 'Full Buyout';
                     }
                    
                }
                

                ///  DEFINE BUYOUT TYPE ////////////////////////////////////////////////////////////////////////////////////////////////     
                If (HistorySettings.eipBuyoutType != null) {
                    
                    if(HistorySettings.eipLangue == 'FR'){
                        
                        if(HistorySettings.eipBuyoutType == '1') 
                        {
                            buyoutType = 'Total Buyout';
                        }
                        else if(HistorySettings.eipBuyoutType == '2'){
                            buyoutType = 'Total Actualisé';
                        }
                        else if(HistorySettings.eipBuyoutType == '3'){
                            buyoutType = 'Total Refinancement';
                        }
                        else {
                            parentId = null;
                            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_10);
                        }
                        
                    }
                    else {
                        
                        if(HistorySettings.eipBuyoutType == '1') 
                        {
                            buyoutType = 'Full Buyout Amount';
                        }
                        else if(HistorySettings.eipBuyoutType == '2'){
                            buyoutType = 'Total Updated';
                        }
                        else if(HistorySettings.eipBuyoutType == '3'){
                            buyoutType = 'Refinancing Amount';
                        }
                        else {
                            parentId = null;
                            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_10);
                        }
                        
                    }
                    
                }
                else {
                            parentId = null;
                            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_10);
                        }
                
                
                
                
                

                ///  GET CONTACT INFORMATION  ////////////////////////////////////////////////////////////////////////////////////////////////////    
                
                // Get contact information 
                
                List<Contact> Hcontact;
                if(HistorySettings.eipContact == null || HistorySettings.eipContact == '' || !String.isNotBlank(HistorySettings.eipContact)){
                
                    Hcontact = [Select name, Email_Permanent__c, id, email from Contact where AccountId = :HistorySettings.eipAccount AND (Email_Permanent__c = :HistorySettings.eipSendEmail OR email = :HistorySettings.eipSendEmail)];
                    system.debug('La liste de contact 4 est '+Hcontact);
                    if(Hcontact.size() > 0){
                        
                        for (Contact cont2 : Hcontact){
                            cEm = HistorySettings.eipSendEmail;
                            cId = cont2.Id;
                            
                        }
                    }
                    
                    else{
                        parentId = null;
                        err_Msg = MessageUtils.ErrorMessage(userLanguage, message_2);
                        //err_Msg = 'Missing Contact Name, can not send email to this account without Contact Information';
                    }
                }

                else{
                    
                    system.debug('Le contact 0 est '+HistorySettings.eipContact);
                    Hcontact = [Select name, Email_Permanent__c, id from Contact 
                                where Name = :HistorySettings.eipContact AND AccountId = :HistorySettings.eipAccount limit 1];//AND (Email_Permanent__c = :eipSendEmail OR email = :eipSendEmail) 
                    system.debug('La liste de contact 1 est '+Hcontact);
                    // The contact is not exist in SFDC yet
                    if(Hcontact.size() > 0){
                        system.debug('La liste de contact 11 est '+Hcontact);
                        for (Contact cont : Hcontact){
                            
                            cEm = cont.Email_Permanent__c; //eipSendEmail;
                            cId = cont.Id;
                            
                        }

                        system.debug('La liste de contact 111 est '+cId+' et cEm '+cEm);
                    }
                    
                    else{
                        //Compagnie_Email__c,
                        List<Account> accList = [Select Id, phone, Contact_Principal__c,Compagnie_Email__c,  BillingPostalCode, BillingCity, BillingStreet, BillingState, BillingCountry 
                                                 From Account where Id = :HistorySettings.eipAccount ];
                        system.debug('La liste de contact 2 est '+Hcontact);
                        for(Account acc : accList){                            
                            cp = acc.BillingPostalCode;
                            tel = acc.Phone;
                            ville = acc.BillingCity;
                            street = acc.BillingStreet;
                            state = acc.BillingState;
                            country = acc.BillingCountry;
                            mail = acc.Compagnie_Email__c;
                            cPrincipal = acc.Contact_Principal__c;
                            
                        }
                        // Create new contact before send email
                        
                        contactId = Contact_Creation.Contact_Manage(HistorySettings.eipAccount, cp, ville,street, state, country, tel, HistorySettings.eipSendEmail, HistorySettings.eipContact);
                        
                        response = (Map<String, Object>) JSON.deserializeUntyped(contactId);
                        cId = (String)response.get('Id');
                        err_Msg = (String)response.get('API_Error_Msg');
                        
                        }
                    
                        System.debug(' les elements du contacts sont cId='+cId + ' err_Msg= '+err_Msg);
                }

            }
        }catch(Exception ex){
            
           // err_Msg = ex.getMessage();
            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_10);
            System.debug(' err_Msg in catch '+err_Msg);
            
            // return new CustomResponse('', err_Msg);
        }


        return JSON.serialize(new CustomEIPInformations(description, buyoutType, partialType, cId, err_Msg, userId, userEmail)).remove('\\');
        
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                         MANAGE CASES INFO 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    public static String Manage_Cases_Informations(SettingsCasesAPI CaseSettingsPUT) {
        
         String err_Msg = null, userLanguage = UserInfo.getLanguage();


        String eipAccount = CaseSettingsPUT.eipAccount;
        String eipContact = CaseSettingsPUT.eipContact;
        String eipContractNumber = CaseSettingsPUT.eipContractNumber;
        String eipCustId = CaseSettingsPUT.eipCustId;
        String eipBuyoutType = CaseSettingsPUT.eipBuyoutType;
       // String eipDateBuyout = CaseSettingsPUT.eipDateBuyout;
        String eipOperationType = CaseSettingsPUT.eipOperationType; 
        String eipLangue = CaseSettingsPUT.eipLangue;
     //   String eipExpiryDate = CaseSettingsPUT.eipExpiryDate;
        String eipAccountManager = CaseSettingsPUT.eipAccountManager; 
        List<String> eipExceptionMsg = CaseSettingsPUT.eipExceptionMessage; 

        String msg_Exception, buyoutType, partialType, userId, userEmail, cId = null;        
        user Luser = new User();
        Map<String, Object> response;

        try{
            /*
            /////  MANAGE ACCOUNT MANAGER CODE//////////////////////////////////////////////////////////////
           // Get AC Informations
           // 
           eipAccountManagerCode = '00000';
            if(String.isNotEmpty(eipAccountManagerCode)){
                
                Luser = [Select id, email From User where Account_Manager_Code__c = :eipAccountManagerCode];
                userId = Luser.Id;
                userEmail = Luser.email;
                
            }
            else{
                
               err_Msg = MessageUtils.ErrorMessage(userLanguage, message_11);
                
            }
            */
            
           ////////////////      GEt CONTACT //////////////////////////
           //
           
            if( String.isNotEmpty(eipContact)) {
                
                Contact contact = [Select Id, name, Email_Permanent__c from Contact 
                                where Name = :eipContact AND AccountId = :eipAccount limit 1];
            
           		 cId = contact.Id;
            
                
            }           
            
            
         ///   BUILD EQUIPEMENT DESCRIPTION   ////////////////////////////////////////////////////////////////////////////////////////////
                for(Integer i = 0; i < eipExceptionMsg.size(); i++){
                    system.debug('la taille '+ eipExceptionMsg.size() + ' La description est '+ i + ' '+msg_Exception);
                    if( i == 0 && eipExceptionMsg[i] != null) msg_Exception = eipExceptionMsg[i];
                    else {
                        if(eipExceptionMsg[i] != null && ( msg_Exception != null || msg_Exception != '')){
                            msg_Exception = msg_Exception+', '+eipExceptionMsg[i];
                        }
                    } 
                    system.debug('La liste de equipement est '+i+' eipDescripition[i] ='+eipExceptionMsg[i]+' '+msg_Exception);
                }

                system.debug('La liste de equipement est '+msg_Exception);

                ///// DEFINE IF IT IS PARTIAL OR NOT /////////////////////////////////////////////////////////
                
                 If (CaseSettingsPUT.eipPartialType == true) {
                     
                     if(CaseSettingsPUT.eipLangue == 'FR'){
                         partialType = 'Rachat Partiel';
                     }
                     else {
                         partialType = 'Partial Buyout';
                     }
                 }
                else{
                    
                     if(CaseSettingsPUT.eipLangue == 'FR'){
                         partialType = 'Rachat Complet';
                     }
                     else {
                         partialType = 'Full Buyout';
                     }
                    
                }

                ///  DEFINE BUYOUT TYPE ////////////////////////////////////////////////////////////////////////////////////////////////     
                
               If (CaseSettingsPUT.eipBuyoutType != null) {
                    
                    if(userLanguage == 'fr'){
                        
                        if(CaseSettingsPUT.eipBuyoutType == '1') 
                        {
                            buyoutType = 'Total Buyout';
                        }
                        else if(CaseSettingsPUT.eipBuyoutType == '2'){
                            buyoutType = 'Total Actualisé';
                        }
                        else if(CaseSettingsPUT.eipBuyoutType == '3'){
                            buyoutType = 'Total Refinancement';
                        }
                        else {
                           // parentId = null;
                            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_10);
                        }
                        
                    }
                    else {
                        
                        if(CaseSettingsPUT.eipBuyoutType == '1') 
                        {
                            buyoutType = 'Full Buyout Amount';
                        }
                        else if(CaseSettingsPUT.eipBuyoutType == '2'){
                            buyoutType = 'Total Updated';
                        }
                        else if(CaseSettingsPUT.eipBuyoutType == '3'){
                            buyoutType = 'Refinancing Amount';
                        }
                        else {
                          //  parentId = null;
                            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_10);
                        }
                        
                    }
                    
                }
                else {
                          //  parentId = null;
                            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_10);
                        }

        }catch(Exception ex){
            
           // err_Msg = ex.getMessage();
            err_Msg = MessageUtils.ErrorMessage(userLanguage, message_10);
            System.debug(' err_Msg in catch '+err_Msg);
            
            // return new CustomResponse('', err_Msg);
        }
        
        system.debug('les info manage envoyes sont ;' + JSON.serialize(new CustomEIPInformations(msg_Exception, buyoutType, partialType, cId, err_Msg, userId, userEmail)).remove('\\'));
        
        return JSON.serialize(new CustomEIPInformations(msg_Exception, buyoutType, partialType, cId, err_Msg, userId, userEmail)).remove('\\');
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////                       GET CONTACT                 /////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    public static String Manage_Informations(String eipContact, String eipAccount, String eipSendEmail){
        
        String err_Msg = null, userLanguage = UserInfo.getLanguage();
        String parentId = null, contactId=null;
        
        String tel, cp, ville,street,state,country, mail, cPrincipal, cEm, cId, contactResp;
        
        Map<String, Object> response;
        
        List<Contact> Hcontact;
                if(eipContact == null || eipContact == '' || !String.isNotBlank(eipContact)){
                
                    Hcontact = [Select name, Email_Permanent__c, id, email from Contact where AccountId = :eipAccount AND (Email_Permanent__c = :eipSendEmail OR email = :eipSendEmail)];
                    system.debug('La liste de contact 4 est '+Hcontact);
                    if(Hcontact.size() > 0){
                        
                        for (Contact cont2 : Hcontact){
                            cEm = eipSendEmail;
                            cId = cont2.Id;
                        }
                    }
                    
                    else{
                        parentId = null;
                        err_Msg = MessageUtils.ErrorMessage(userLanguage, null);
                        //err_Msg = 'Missing Contact Name, can not send email to this account without Contact Information';
                    }
                }
        		else{
                    
                    system.debug('Le contact 0 est '+eipContact);
                    Hcontact = [Select name, Email_Permanent__c, id from Contact 
                                where Name = :eipContact AND AccountId = :eipAccount limit 1];//AND (Email_Permanent__c = :eipSendEmail OR email = :eipSendEmail) 
                    system.debug('La liste de contact 1 est '+Hcontact);
                    // The contact is not exist in SFDC yet
                    if(Hcontact.size() > 0){
                        system.debug('La liste de contact 11 est '+Hcontact);
                        for (Contact cont : Hcontact){
                            
                            cEm = cont.Email_Permanent__c; //eipSendEmail;
                            cId = cont.Id;
                            
                        }

                        system.debug('La liste de contact 111 est '+cId+' et cEm '+cEm);
                    }
                    
                    else{
                        //Compagnie_Email__c, 
                        List<Account> accList = [Select Id, phone, Contact_Principal__c, Compagnie_Email__c,  BillingPostalCode, BillingCity, BillingStreet, BillingState, BillingCountry From Account where Id = :eipAccount ];
                        system.debug('La liste de contact 2 est '+Hcontact);
                        for(Account acc : accList){
                            
                            cp = acc.BillingPostalCode;
                            tel = acc.Phone;
                            ville = acc.BillingCity;
                            street = acc.BillingStreet;
                            state = acc.BillingState;
                            country = acc.BillingCountry;
                            mail = acc.Compagnie_Email__c;
                            cPrincipal = acc.Contact_Principal__c;
                            
                        }
                        // Create new contact before send email
                        
                        contactId = Contact_Creation.Contact_Manage(eipAccount, cp, ville,street, state, country, tel, eipSendEmail, eipContact);
                        
                        response = (Map<String, Object>) JSON.deserializeUntyped(contactId);
                        cId = (String)response.get('Id');
                        err_Msg = (String)response.get('API_Error_Msg');
                        
                        }
                    
                        System.debug(' les elements du contacts sont cId='+cId + ' err_Msg= '+err_Msg);
                }
     return cId;   
    }  

    
    
}