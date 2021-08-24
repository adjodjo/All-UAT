public with sharing class CreateNew_Case_Historic {
    

    
    
    
    /////////////////////////////////////////   CASE CREATION FROM CASE API ////////////////
    //
    
    
    public  static String  CreateNewEIPCase(SettingsCasesAPI CaseSettings, String ContactId, String buyoutType, String partialType, String ExceptionMsg){
        
    
        
        String caseSubject, caseId, uId, uEmail; 
                                             String currentUser = UserInfo.getUserId();
                                             String cNum, err_Msg = null;
                                             system.debug('ceci est un test');
                                              Map<String, Object> response;
                                              
                                             try{
                                                 
                                             
                                                 RecordType myRT = [Select Id From RecordType where Name = 'Sales'];
                                                 system.debug('record type '+ myRT.Id);                
                                                 Group gp = [select Id, name, DeveloperName from Group where type = 'queue' and DeveloperName = 'CS_Queue'];
                                                 system.debug('********** Le compte est ***********3 = '+CaseSettings.eipAccount+ ' le contact est **** = '+contactId);
                                                 
                                                 Case thisCase = new Case(  AccountId = CaseSettings.eipAccount
                                                                          , RecordTypeId = myRT.Id
                                                                          , Status = 'New'
                                                                          , Origin = 'EIP'
                                                                          , Subject = 'EIP Buyout Request'
                                                                          , Type = 'Buyout'
                                                                          //, Service_Email__c = 'dev@analystik.ca'
                                                                          , OwnerId = gp.Id
                                                                          , ContactId = ContactId
                                                                          , Contrat_InfoLease__c = CaseSettings.eipContractNumber
                                                                          , CustId__c =  CaseSettings.eipCustId
                                                                          , Langue_Communication__c = CaseSettings.eipLangue
                                                                          , Date_Buyout__c = date.valueOf(CaseSettings.eipDateBuyout)
                                                                          , Operation_Type__c = CaseSettings.eipOperationType
                                                                          , EIP_Exception__c = ExceptionMsg
                                                                          , Account_Manager__c =  CaseSettings.eipAccountManager
                                                                         // , Requested_By__c = CaseSettings.eipAccountManagerCode
                                                                        //  , SuppliedEmail = userEmail
                                                                          , Buyout_Type__c = partialType
                                                                          , Balance_Type__c = buyoutType
                                                                          , Request_Type__c = 'Buyout'
                                                                          , Expiry_Date__c = date.valueOf(CaseSettings.eipExpiryDate)
                                                                          , ActiveDirectory_Username__c = CaseSettings.eipActiveDirectoryName
                                                                          , Transfer_to_third_party__c = CaseSettings.eipTransfertThirdParty
                                                                          
                                                                         );
                                                 
                                                 System.debug('un new case creer '+thisCase);
                                                 
                                                 upsert thisCase;
                                                 
                                                 System.debug('Le Id du new case creer '+thisCase.Id);
                                                 
                                                 caseId = thisCase.Id;
                                                 
                                                 if (caseId != null){
                                                     
                                                     List<Case> CaseInfo = [Select Id, CaseNumber From Case Where Id = :caseId ];
                                                    
                                                     for(Case rCase : CaseInfo){
                                                         cNum = rCase.CaseNumber;                                                         
                                                     }
                                                     
                                                     caseSubject = CaseSettings.eipOperationType+'_'+CaseSettings.eipCustId+ '[ref:'+caseId +':ref]';
                                                                                                          
                                                     Case updatecase = new Case(Id = caseId, subject = caseSubject);
                                                     update updatecase;
                                                   /* 
                                                     if(String.isNotBlank(CaseSettings.eipAccountManager)){
                                                         
                                                          Manage_EIP_User.Get_Acount_Manager(CaseSettings.eipAccountManager, caseId);
                                                     }
														*/                                                   
                                                     
                                                 }
                                                 
                                                 else {
                                                     caseId = null;
                                                 }
                                             }catch(Exception ex){
                                                 
                                                 err_Msg = ex.getMessage();
                                                 system.debug(' Case pas creer '+err_Msg);
                                             } 
                                             System.debug('Les donnee du case a creer sont' + JSON.serialize(new CaseResponse(caseId , cNum, err_Msg)).remove('\\'));
                                             return JSON.serialize(new CaseResponse(caseId , cNum, err_Msg)).remove('\\');//caseId; // caseId 
                                         }
    
    
        ////   UPDATE EIP CASE FROM EIP BY CUSTOMER SERVICE AGENT////////////////
    //
    public  static String  UpdateEIPCase(SettingsHistoricsAPI HistoricsSettings, String myDesc, String buyoutType, String partialType, String HistoricId ){
     
        String subject,caseId, ccEmail = '', contenV = EncodingUtil.urlDecode(HistoricsSettings.eipFileName, 'UTF-8');
        String pdfFileName;
        try{
        
           // Case ownerCase = [select id, OwnerId from Case where Id = :HistoricsSettings.sfdcCaseId ];
           // RecordType myRT = [Select Id From RecordType where Name = 'Sales'];
            //        system.debug('record type '+ myRT.Id);                
      //  Group gp = [select Id, name, DeveloperName from Group where type = 'queue' and DeveloperName = 'Sales_Queue'];
        //system.debug('********** Le compte est ***********3 = '+eipAccount+ ' le contact est **** = '+contactId);
        
            if(String.isNotEmpty(HistoricsSettings.eipSendEmail)){
                
                 Case thisCase = new Case(    id = HistoricsSettings.sfdcCaseId
                                    	//	, RecordTypeId = myRT.Id
                                          	//, OwnerId = UserInfo.getUserId()
                                            //, Origin = 'Internal'
                                           // , Status = 'Closed'
                                           , Type = HistoricsSettings.eipTypeNote
                                            , Montant_Rachat__c = HistoricsSettings.eipAmount
                                        	, Buyout_End_Of_Term_Fee__c = HistoricsSettings.eipEndOfTermFee
                                            , Taxe_Rachat_Federal__c = HistoricsSettings.eipTaxesPST
                                           	, Taxe_Rachat_Provincial__c = HistoricsSettings.eipTaxesGST
                                            , Taxe_Rachat_Harmonise__c = HistoricsSettings.eipTaxesHST
                                            , Buyout_Total_Amount__c = HistoricsSettings.eipTotalBuyout
                                            , Langue_Communication__c = HistoricsSettings.eipLangue
                                          	, Date_Buyout__c = date.valueOf(HistoricsSettings.epiDateBuyout)
                                           	, Desciption_equipement__c = myDesc
                                            , Buyout_Rate__c = HistoricsSettings.eipRate
                                            , Buyout_Term__c = HistoricsSettings.eipBuyoutTerm
                                           , Buyout_Type__c = partialType
                                          , Balance_Type__c = buyoutType
                                          , CustId__c = HistoricsSettings.eipCustId
                                            , Operation_Type__c = HistoricsSettings.eipOperationType
                                            , Expiry_Date__c = date.valueOf(HistoricsSettings.eipExpiryDate)
                                           	, Balance_Amount__c = HistoricsSettings.eipBalanceAmount
                                          , Transfer_to_third_party__c = HistoricsSettings.eipTransfertThirdParty
                                                                        
                                           );
                 update thisCase;
                                            
                System.debug('Le Id du new case creer '+thisCase.Id);
                                            
                caseId = thisCase.Id;

                
            }
            else{
                 Case thisCase = new Case(    id =  HistoricsSettings.sfdcCaseId
                                           // , RecordTypeId = myRT.Id
                                            //, Origin = 'Internal'
                                           // , Status = 'Update By EIP'
                                           	, Montant_Rachat__c = HistoricsSettings.eipAmount
                                            , Buyout_End_Of_Term_Fee__c = HistoricsSettings.eipEndOfTermFee
                                          	, Taxe_Rachat_Federal__c = HistoricsSettings.eipTaxesPST
                                           	, Taxe_Rachat_Provincial__c = HistoricsSettings.eipTaxesGST
                                            , Taxe_Rachat_Harmonise__c = HistoricsSettings.eipTaxesHST
                                         	, Buyout_Total_Amount__c = HistoricsSettings.eipTotalBuyout
                                           	, Langue_Communication__c = HistoricsSettings.eipLangue
                                            , Date_Buyout__c = date.valueOf(HistoricsSettings.epiDateBuyout)
                                          	, Desciption_equipement__c = myDesc
                                        	, Buyout_Rate__c = HistoricsSettings.eipRate
                                        	, Buyout_Term__c = HistoricsSettings.eipBuyoutTerm
                                            , Operation_Type__c = HistoricsSettings.eipOperationType
                                            //, Balance_Type__c = buyoutType
                                            , Expiry_Date__c = date.valueOf(HistoricsSettings.eipExpiryDate)
                                       		, Balance_Amount__c = HistoricsSettings.eipBalanceAmount
                                          , Transfer_to_third_party__c = HistoricsSettings.eipTransfertThirdParty
                                                                        
                                           );
                 update thisCase;
                                            
                 System.debug('Le Id du new case creer '+thisCase.Id);
                                            
                caseId = thisCase.Id;

            }
                                                                                                           
                                             //   System.debug('un new case creer '+thisCase);
            
                                           
                                            
                                            if (caseId != null){
                                                
                                                //String orgId = UserInfo.getOrganizationId();
                                                   // subject = eipOperationType + '('+caseId+')' +' ['+'ref:_' + orgId.LEFT(5)+ orgId.remove(orgId.substring(0,12)) +'._'+ caseId.LEFT(5)+caseId.substring(10,15)+':ref ]';
                                                //subject = eipOperationType+ '[ref:'+caseId +':ref]';
                                                
                                                if(String.isNotBlank(HistoricsSettings.eipFileName) && String.isNotBlank(HistoricsSettings.eipFile)){

                                                    Case c = [SELECT caseNumber from Case where Id =:caseId];
                                                    pdfFileName = HistoricsSettings.eipContractNumber+'_'+c.caseNumber+'_'+Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')+'.pdf';                                                    

                                                }
                                                    Case updatecase = new Case(Id = caseId,  ExternalDocumentInfo1__c = EncodingUtil.urlDecode(pdfFileName, 'UTF-8'));
                                                    update updatecase;

                                                    system.debug('eipFileName '+pdfFileName+' eipFile '+HistoricsSettings.eipFile);
                                               Id contenVersionId = ImporterDocument.SauvegerPieceJointe(pdfFileName, HistoricsSettings.eipFile, HistoricsSettings.eipContentType,  caseId, null, null);
                                              // ImporterDocument.SauvegerPieceJointe(eipFileName, eipFile, eipContentType,  caseId);
                                                
                                            }
                                        
                                        else {
                                            caseId = null;
                                        }
        }catch(Exception ex){
                
                String err_Msg = ex.getMessage();
                
            } 
    
        
        return pdfFileName;
    }
    
    
    
    ////////////////////////   CASE CREATION FROM HISTORIQUE ////////////////
    //
    public  static String  CreateNewCase(SettingsHistoricsAPI HistoricsSettings, String contactId, String myDesc, String buyoutType, String partialType){
        
        String subject,caseId,pdfFileName, ccEmail = '', contenV = EncodingUtil.urlDecode(HistoricsSettings.eipFileName, 'UTF-8');
        
        try{
        
            RecordType myRT = [Select Id From RecordType where Name = 'Sales'];
                    system.debug('record type '+ myRT.Id);                
        Group gp = [select Id, name, DeveloperName from Group where type = 'queue' and DeveloperName = 'Sales_Queue'];
        system.debug('********** Le compte est ***********3 = '+HistoricsSettings.eipAccount+ ' le contact est **** = '+contactId);
        
                                            Case thisCase = new Case(    AccountId = HistoricsSettings.eipAccount
                                                                        , RecordTypeId = myRT.Id
                                                                        , Status = 'New'
                                                                       // , Origin = 'Internal'
                                                                        , SuppliedEmail = HistoricsSettings.eipSendEmail
                                                                        , ExternalDocumentInfo1__c = contenV
                                                                        , Subject = subject
                                                                        , Type = HistoricsSettings.eipOperationType
                                                                        , OwnerId = gp.Id
                                                                        , ContactId = contactId
                                                                        , Contrat_InfoLease__c = HistoricsSettings.eipContractNumber
                                                                        , CustId__c =  HistoricsSettings.eipCustId
                                                                        , Montant_Rachat__c = HistoricsSettings.eipAmount
                                                                        , Buyout_End_Of_Term_Fee__c = HistoricsSettings.eipEndOfTermFee
                                                                        , Taxe_Rachat_Federal__c = HistoricsSettings.eipTaxesPST
                                                                        , Taxe_Rachat_Provincial__c = HistoricsSettings.eipTaxesGST
                                                                        , Taxe_Rachat_Harmonise__c = HistoricsSettings.eipTaxesHST
                                                                        , Buyout_Total_Amount__c = HistoricsSettings.eipTotalBuyout
                                                                        , Langue_Communication__c = HistoricsSettings.eipLangue
                                                                        , Buyout_Type__c = partialType
                                                                        , Balance_Type__c = buyoutType
                                                                        , Date_Buyout__c = date.valueOf(HistoricsSettings.epiDateBuyout)
                                                                        , Desciption_equipement__c = myDesc
                                                                        , Buyout_Rate__c = HistoricsSettings.eipRate
                                                                        , Buyout_Term__c = HistoricsSettings.eipBuyoutTerm
                                                                      	, Operation_Type__c = HistoricsSettings.eipOperationType
                                                                     	, Expiry_Date__c = date.valueOf(HistoricsSettings.eipExpiryDate)
                                                                     	, Balance_Amount__c = HistoricsSettings.eipBalanceAmount
                                                                     , ActiveDirectory_Username__c = HistoricsSettings.eipActiveDirectoryName
                                                                     , Account_Manager__c =  HistoricsSettings.eipAccountManager
                                                                     , Transfer_to_third_party__c = HistoricsSettings.eipTransfertThirdParty
                                                                    
                                                                        
                                                                        
                                                                    );
                                                                 
                                                System.debug('un new case creer '+thisCase);
                                            
                                          upsert thisCase;
                                            
                                            System.debug('Le Id du new case creer '+thisCase.Id);
                                            
                                            caseId = thisCase.Id;
                                            
                                            if (caseId != null){
                                                
                                                //String orgId = UserInfo.getOrganizationId();
                                                   // subject = eipOperationType + '('+caseId+')' +' ['+'ref:_' + orgId.LEFT(5)+ orgId.remove(orgId.substring(0,12)) +'._'+ caseId.LEFT(5)+caseId.substring(10,15)+':ref ]';
                                                subject = HistoricsSettings.eipOperationType+'_'+HistoricsSettings.eipCustId+ '[ref:'+caseId +':ref]';
                                                
                                                if(String.isNotBlank(HistoricsSettings.eipFileName) && String.isNotBlank(HistoricsSettings.eipFile)){

                                                    Case c = [SELECT caseNumber from Case where Id =:caseId];
                                                    pdfFileName = HistoricsSettings.eipContractNumber+'_'+c.caseNumber+'_'+Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')+'.pdf';                                                    

                                                }
                                                    Case updatecase = new Case(Id = caseId,  subject = subject, ExternalDocumentInfo1__c = EncodingUtil.urlDecode(pdfFileName, 'UTF-8'));
                                                    update updatecase;

                                                    system.debug('eipFileName '+pdfFileName+' eipFile '+HistoricsSettings.eipFile);
                                               Id contenVersionId = ImporterDocument.SauvegerPieceJointe(pdfFileName, HistoricsSettings.eipFile, HistoricsSettings.eipContentType,  caseId, null, null);
                                              // ImporterDocument.SauvegerPieceJointe(eipFileName, eipFile, eipContentType,  caseId);
                                                
                                            }
                                        
                                        else {
                                            caseId = null;
                                        }
        }catch(Exception ex){
                
                String err_Msg = ex.getMessage();
                
            } 
    
        
        return caseId;
    } 
    
    
    /////////////    HISTORIQUE CREATION ////////////////////////////////////
    //
    
    public  static String  CreateNewHistory(SettingsHistoricsAPI HistoricsSettings, String contactId, String myDesc, String buyoutType, String partialType){
        
       
        String currentUser = UserInfo.getUserId();                                                
        String histId, pdfFileName;
        // It is not possible to create new history record if there is no email to receive resulting email generated
        
        String eipEntrants = 'eipSendEmail : '+HistoricsSettings.eipSendEmail+' , eipAccount : '+HistoricsSettings.eipAccount+' , eipContact : '+HistoricsSettings.eipContact+' , eipTypeNote : '+HistoricsSettings.eipTypeNote+
            ' , eipAmount : '+HistoricsSettings.eipAmount+ ' , eipButoutType: '+BuyoutType+' , eipFileName : '+HistoricsSettings.eipFileName+' ,  eipContentType : '+HistoricsSettings.eipContentType+
            ' , eipLangue : '+HistoricsSettings.eipLangue+' , epiDateBuyout : '+HistoricsSettings.epiDateBuyout+' , eipDescripition : '+myDesc+' , eipExpiryDate : '+HistoricsSettings.eipExpiryDate+' , eipCcSendEmail: '+HistoricsSettings.eipCcSendEmail;
        
        
        String eipContent = 'Buyout Terme = '+ HistoricsSettings.eipBuyoutTerm+ '; Buyout Rate = '+(HistoricsSettings.eipRate*100).setScale(2)+'% '+ '; CC Email: '+HistoricsSettings.eipCcSendEmail;
        
        RecordType myRT = [Select Id From RecordType where Name = :HistoricsSettings.eipTypeNote];        
          System.debug(' Le streeeeehhh   leas --- '+HistoricsSettings.eipStretchLease);
        Boolean st;
        if(HistoricsSettings.eipStretchLease == null){
            st = false;
        }
        else st = HistoricsSettings.eipStretchLease;
        
        Historique__c thisHistorique = new Historique__c( Account__c = HistoricsSettings.eipAccount
                                                        , RecordTypeId = myRT.Id
                                                        , Contact__c = contactId
                                                        , Type_Note__c = HistoricsSettings.eipTypeNote
                                                        , Montant_Rachat__c = HistoricsSettings.eipAmount
                                                        , Buyout_End_Of_Term_Fee__c = HistoricsSettings.eipEndOfTermFee
                                                        , Taxe_Rachat_Federal__c = HistoricsSettings.eipTaxesGST
                                                        , Taxe_Rachat_Provincial__c = HistoricsSettings.eipTaxesPST
                                                        , Taxe_Rachat_Harmonise__c = HistoricsSettings.eipTaxesHST
                                                        , Buyout_Total_Amount__c = HistoricsSettings.eipTotalBuyout
                                                        , email__c = HistoricsSettings.eipSendEmail
                                                        , CC_Email__c = HistoricsSettings.eipCcSendEmail
                                                        , Langue_communication__c = HistoricsSettings.eipLangue
                                                        , Date_Buyout__c = date.valueOf(HistoricsSettings.epiDateBuyout)
                                                        , Desciption_equipement__c = myDesc
                                                        , ExternalDocumentInfo1__c = EncodingUtil.urlDecode(HistoricsSettings.eipFileName, 'UTF-8')
                                                        , EIP_Entrants__c = eipEntrants
                                                        , Contenu__c = eipContent
                                                        , Contrat_InfoLease__c = HistoricsSettings.eipContractNumber
                                                        , CustId__c =  HistoricsSettings.eipCustId
                                                        , Buyout_Type__c = partialType
                                                        , Balance_Type__c = buyoutType
                                                        , Operation_Type__c = HistoricsSettings.eipOperationType
                                                        , Expiry_Date__c = date.valueOf(HistoricsSettings.eipExpiryDate)
                                                        , Balance_Amount__c = HistoricsSettings.eipBalanceAmount
                                                        , ActiveDirectory_Username__c = HistoricsSettings.eipActiveDirectoryName
                                                        , Account_Manager__c =  HistoricsSettings.eipAccountManager
                                                        , Transfer_to_third_party__c = HistoricsSettings.eipTransfertThirdParty
                                                        , Buyout_Number__c = HistoricsSettings.eipBuyoutNumber
                                                        , Stretch_Lease__c = st//HistoricsSettings.eipStretchLease
                                                        
                                                        
                                                        );
    System.debug('un new Historique creer '+thisHistorique);
        System.debug('un new Historique Balance type '+thisHistorique.Balance_Type__c+ '---- AVEC buyoutType-- '+buyoutType);
        System.debug('un new Historique Stretch_Lease '+thisHistorique.Stretch_Lease__c);
        upsert thisHistorique;
    
                                            System.debug('Le Id du new Historique creer '+thisHistorique.Id);
        
        histId = thisHistorique.Id;
        
        // Création de la pièce jointe à rattacher à l'historique des communications avec le compte client
        
        if(String.isNotBlank(HistoricsSettings.eipFileName) && String.isNotBlank(HistoricsSettings.eipFile)){ 
            If(histId != null) {
                Historique__c hist = [SELECT name From Historique__c where Id = :histId];
                
                pdfFileName = HistoricsSettings.eipContractNumber+'_'+hist.Name+'_'+Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')+'.pdf';
                
                Historique__c newHist = new Historique__c(Id = histId, ExternalDocumentInfo1__c = EncodingUtil.urlDecode(pdfFileName, 'UTF-8'));
                
                update newHist;
                
                system.debug('eipFileName '+pdfFileName+' eipFile  '+HistoricsSettings.eipFile+ ' histId  '+histId);
                Id contenVersionId = ImporterDocument.SauvegerPieceJointe(pdfFileName, HistoricsSettings.eipFile, HistoricsSettings.eipContentType,  histId, null, null);
               // ImporterDocument.SauvegerPieceJointe(eipFileName, eipFile, eipContentType,  histId);
            }
            
        }
                                            
        return histId;
        
    }   
    
     /////////////    HISTORIQUE CREATION FROM CASE////////////////////////////////////
    //
    
    public  static String  CreateNewHistoryC(SettingsHistoricsAPI HistoricsSettings, String contactId, String myDesc, String buyoutType, String partialType, String fileName){
        
       system.debug('le id du case est ' +HistoricsSettings.sfdcCaseId);
        String currentUser = UserInfo.getUserId();
        String histId, pdfFileName;
        // It is not possible to create new history record if there is no email to receive resulting email generated
        
        String eipEntrants = 'eipSendEmail : '+HistoricsSettings.eipSendEmail+' , eipAccount : '+HistoricsSettings.eipAccount+' , eipContact : '+HistoricsSettings.eipContact+' , eipTypeNote : '+HistoricsSettings.eipTypeNote+
            ' , eipAmount : '+HistoricsSettings.eipAmount+ ' , eipButoutType: '+BuyoutType+' , eipFileName : '+HistoricsSettings.eipFileName+' ,  eipContentType : '+HistoricsSettings.eipContentType+
            ' , eipLangue : '+HistoricsSettings.eipLangue+' , epiDateBuyout : '+HistoricsSettings.epiDateBuyout+' , eipDescripition : '+myDesc+' , eipExpiryDate : '+HistoricsSettings.eipExpiryDate+' , eipCcSendEmail: '+HistoricsSettings.eipCcSendEmail;
        
        
        String eipContent = 'Buyout Terme = '+ HistoricsSettings.eipBuyoutTerm+ '; Buyout Rate = '+(HistoricsSettings.eipRate*100).setScale(2)+'% '+ '; CC Email: '+HistoricsSettings.eipCcSendEmail;
        
        RecordType myRT = [Select Id From RecordType where Name = :HistoricsSettings.eipTypeNote];        
        System.debug(' Le streeeeehhh   leas --- '+HistoricsSettings.eipStretchLease);
        
         Boolean st;
        if(HistoricsSettings.eipStretchLease == null){
            st = false;
        }
        else st = HistoricsSettings.eipStretchLease;
        Historique__c thisHistorique = new Historique__c( Account__c = HistoricsSettings.eipAccount
                                                        , RecordTypeId = myRT.Id
                                                        , Contact__c = contactId
                                                        , Type_Note__c = HistoricsSettings.eipTypeNote
                                                        , Montant_Rachat__c = HistoricsSettings.eipAmount
                                                        , Buyout_End_Of_Term_Fee__c = HistoricsSettings.eipEndOfTermFee
                                                        , Taxe_Rachat_Federal__c = HistoricsSettings.eipTaxesGST
                                                        , Taxe_Rachat_Provincial__c = HistoricsSettings.eipTaxesPST
                                                        , Taxe_Rachat_Harmonise__c = HistoricsSettings.eipTaxesHST
                                                        , Buyout_Total_Amount__c = HistoricsSettings.eipTotalBuyout
                                                        , email__c = HistoricsSettings.eipSendEmail
                                                        , CC_Email__c = HistoricsSettings.eipCcSendEmail
                                                        , Langue_communication__c =HistoricsSettings.eipLangue
                                                        , Date_Buyout__c = date.valueOf(HistoricsSettings.epiDateBuyout)
                                                        , Desciption_equipement__c = myDesc
                                                        , ExternalDocumentInfo1__c = EncodingUtil.urlDecode(HistoricsSettings.eipFileName, 'UTF-8')
                                                        , EIP_Entrants__c = eipEntrants
                                                        , Contenu__c = eipContent
                                                        , Contrat_InfoLease__c = HistoricsSettings.eipContractNumber
                                                        , CustId__c =  HistoricsSettings.eipCustId
                                                        , Buyout_Type__c = partialType
                                                        , Balance_Type__c = buyoutType
                                                        , Operation_Type__c = HistoricsSettings.eipOperationType
                                                        , Expiry_Date__c = date.valueOf(HistoricsSettings.eipExpiryDate)
                                                        , Case__c = HistoricsSettings.sfdcCaseId
                                                        , Balance_Amount__c = HistoricsSettings.eipBalanceAmount
                                                        , ActiveDirectory_Username__c = HistoricsSettings.eipActiveDirectoryName
                                                        , Account_Manager__c =  HistoricsSettings.eipAccountManager
                                                        , Transfer_to_third_party__c = HistoricsSettings.eipTransfertThirdParty
                                                        , Stretch_Lease__c = st //HistoricsSettings.eipStretchLease
                                                         
                                                        , Buyout_Number__c = HistoricsSettings.eipBuyoutNumber
                                                                                                               
                                                        );
    System.debug('un new Historique creer '+thisHistorique);
        upsert thisHistorique;
    
                                            System.debug('Le Id du new Historique creer '+thisHistorique.Id);
        
        histId = thisHistorique.Id;
        
        // Création de la pièce jointe à rattacher à l'historique des communications avec le compte client
        if( String.isNotBlank(HistoricsSettings.sfdcCaseId) ){
            if( String.isNotBlank(HistoricsSettings.eipFileName) ){ 
                If(histId != null) {
                    
                     Historique__c hist = [SELECT name From Historique__c where Id = :histId];
                
                pdfFileName = HistoricsSettings.eipContractNumber+'_'+hist.Name+'_'+Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')+'.pdf'; // fileName;//HistoricsSettings.eipContractNumber+'_'+hist.Name+'_'+Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')+'.pdf';
                
                Historique__c newHist = new Historique__c(Id = histId, ExternalDocumentInfo1__c = EncodingUtil.urlDecode(pdfFileName, 'UTF-8'));
                
                update newHist;
                
                system.debug('eipFileName '+pdfFileName+' eipFile  '+HistoricsSettings.eipFile+ ' histId  '+histId);
                Id contenVersionId = ImporterDocument.SauvegerPieceJointe(pdfFileName, HistoricsSettings.eipFile, HistoricsSettings.eipContentType,  histId, HistoricsSettings.sfdcCaseId, null);
               // ImporterDocument.SauvegerPieceJointe(eipFileName, eipFile, eipContentType,  histId);
                    
               //     Id contenVersionId = ImporterDocument.SauvegerPieceJointe(HistoricsSettings.eipFileName, HistoricsSettings.eipFile, HistoricsSettings.eipContentType,  histId, HistoricsSettings.sfdcCaseId);
                    //ImporterDocument.SauvegerPieceJointe(eipFileName, eipFile, eipContentType,  histId);
                }
            } 
        }
                                        
        
        return histId;
        
    }   

}