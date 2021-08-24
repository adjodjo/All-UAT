public class AVISTERM_Historique_Letter {
    
    public static String Historique_Letter_Manage(AVISTERM_SettingHistoricLetter A_HistoricLetter) {
        
         String contactId=null, Obj, histId = null, phistId = null, err_msg=null;
        
        try{
            Obj='Historic_AVISTERM';
           // String organisation = UserInfo.getOrganizationId();
            
            String Link = ParametersUtils.BuildDMSLink()+A_HistoricLetter.DMS_DocLink+'/download';
            
             Historic_AVISTERM__c thisHistorique = new Historic_AVISTERM__c( 
                     
                       Account__c = A_HistoricLetter.SF_AccountId
                     , InfoLease_Contrat__c = A_HistoricLetter.IL_ContractNumber
                     , CustId__c =  A_HistoricLetter.x_CustId
                     ,Langue_communication__c = A_HistoricLetter.IL_Langue
                     , ActiveDirectory_Username__c = A_HistoricLetter.x_ActiveDirectoryName
                     , Letter_Type__c = A_HistoricLetter.EIP_TypeLetter
                     , Date_Letter__c = A_HistoricLetter.EIP_LetterDate
                     , Letter_Owner__c = A_HistoricLetter.x_LetterOwner
                 	, Owner_Extension_Phone_Number__c = A_HistoricLetter.x_OwnerPhoneExt
                 	, Owner_Phone_number__c = A_HistoricLetter.x_OwnerPhone
                 	, Owner_Title__c = A_HistoricLetter.x_OwnerTitle
                     , Letter_DocType__c = A_HistoricLetter.DMS_DocType
                     , Letter_Link__c = Link 
                     , Late_Balance__c = A_HistoricLetter.IL_LateBalance
                     , Late_Paiement_Date__c = A_HistoricLetter.IL_LateDate
                     , Lease_Balance__c = A_HistoricLetter.IL_LeaseBalance
                     , Paiement_dateline__c = A_HistoricLetter.IL_DateLine
                 	, Nb_Payments__c = A_HistoricLetter.IL_NbOfPaiement
                 	, articles__c = A_HistoricLetter.IL_Article
                 
                   
                               );
            		System.debug('un new Historique creer '+thisHistorique);
            
                    upsert thisHistorique;
                    histId = thisHistorique.id;
            		system.debug(' Le histori id est :'+histId);
                    
                    if(histId != null){
                            Manage_EIP_User.Get_User(A_HistoricLetter.x_ActiveDirectoryName, histId, Obj);
                            
                         //   RecordType myRT = [Select Id From RecordType where Name = :A_HistoricLetter.EIP_TypeLetter];
                            
                            historic__c historic = new Historic__c (
                                
                                 //   RecordTypeId = myRT.Id
                                	Account__c = A_HistoricLetter.SF_AccountId
                                ,	Document_Link__c = Link //A_HistoricLetter.DMS_DocLink
                                ,	Historic_Document_Type__c = A_HistoricLetter.EIP_TypeLetter
                                ,	AVISTERM_Historic_Detail__c = histId
                                , 	Object_Name__c = Obj
                        );
                        
                        upsert historic;
                        phistId = historic.Id;
                        
                            if(phistId != null){
                                obj='pHistory';
                            
                                Manage_EIP_User.Get_User(A_HistoricLetter.x_ActiveDirectoryName, phistId, obj);
                            }
                    }
                    
            
        }catch(Exception ex){
            
             err_Msg = ex.getMessage();
                if(err_Msg != null && histId != null){
                    Historic_AVISTERM__c hr = new Historic_AVISTERM__c(id = histId);
                    delete hr;
                }
                histId = null;
        }
        
        return JSON.serialize(new historiesCustomResponse(histId,phistId, err_Msg));
    }

}