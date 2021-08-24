public class Retard_Historique_Letter {
    
    public static String Historique_Letter_Manage(Retard_SettingHistoricLetter R_HistoricLetter) {
        
        String contactId=null, Obj, histId = null, phistId = null, err_msg=null;
        
        try{
            Obj='Historic_Retard';
            String organisation = UserInfo.getOrganizationId();            
            String Link = ParametersUtils.BuildDMSLink()+R_HistoricLetter.DMS_DocLink+'/download'; //OrganisationUtils.Get_Organisation(organisation, R_HistoricLetter.DMS_DocLink);
            
        /*    Obj='Historic_Retard';
            if(R_HistoricLetter.SendEmail != null){
                
                contactId = Manage_EIP_Informations.Manage_Informations(R_HistoricLetter.IL_Contact, R_HistoricLetter.SF_AccountId, R_HistoricLetter.SendEmail);
             //  contactId = Manage_Informations(R_HistoricLetter.IL_Contact, R_HistoricLetter.SF_AccountId, R_HistoricLetter.SendEmail); 
            }
            else contactId = null;
            */
              //  RecordType myRT = [Select Id From RecordType where Name = :R_HistoricLetter.TypeNote];
                 Historic_Retard__c thisHistorique = new Historic_Retard__c( 
                     
                       Account__c = R_HistoricLetter.SF_AccountId
                     , InfoLease_Contrat__c = R_HistoricLetter.IL_ContractNumber
                     , CustId__c =  R_HistoricLetter.x_CustId
                     , Langue_communication__c = R_HistoricLetter.IL_Langue
                     , ActiveDirectory_Username__c = R_HistoricLetter.x_ActiveDirectoryName
                     , Letter_Type__c = R_HistoricLetter.EIP_TypeLetter
                     , Date_Letter__c = R_HistoricLetter.EIP_LetterDate
                     , Letter_Owner__c = R_HistoricLetter.x_LetterOwner
                     , Owner_Extension_Phone_Number__c = R_HistoricLetter.x_OwnerPhoneExt
                 	, Owner_Phone_number__c = R_HistoricLetter.x_OwnerPhone
                 	, Owner_Title__c = R_HistoricLetter.x_OwnerTitle
                     , Letter_DocType__c = R_HistoricLetter.DMS_DocType
                     , Letter_Link__c = link
                   
                               );
                    System.debug('un new Historique creer '+thisHistorique);
                    upsert thisHistorique;
                    histId = thisHistorique.id;
            		system.debug(' Le histori id est :'+histId);
                   
                    
            		if(histId != null){
                    Manage_EIP_User.Get_User(R_HistoricLetter.x_ActiveDirectoryName, histId, Obj);
                    
                //    RecordType myRT = [Select Id From RecordType where Name = :R_HistoricLetter.EIP_TypeLetter];
                    
                    historic__c historic = new Historic__c (
                    	
                    	 //	RecordTypeId = myRT.Id
                    		Account__c = R_HistoricLetter.SF_AccountId
                    	,	Document_Link__c = Link //R_HistoricLetter.DMS_DocLink
                    	,	Historic_Document_Type__c = R_HistoricLetter.EIP_TypeLetter
                    	,	Retard_Historic_Detail__c = histId
                        , 	Object_Name__c = Obj
                       
                
                );
                
                upsert historic;
                phistId = historic.Id;
                
                    if(phistId != null){
                        obj='pHistory';
                    
                        Manage_EIP_User.Get_User(R_HistoricLetter.x_ActiveDirectoryName, phistId, obj);
                    }
            }
                
           
        	}catch(Exception ex){
            
                err_Msg = ex.getMessage();
                if(err_Msg != null && histId != null){
                    Historic_Retard__c hr = new Historic_Retard__c(id = histId);
                    delete hr;
                }
                histId = null;
        }
        system.debug('les info sont : histId='+histId+' phistId='+phistId+  ' err_Msg= '+err_Msg );
        
        return JSON.serialize(new historiesCustomResponse(histId,phistId, err_Msg));
    
    }
}