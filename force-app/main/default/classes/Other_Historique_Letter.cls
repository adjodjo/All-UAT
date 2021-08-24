public class Other_Historique_Letter {
    
     public static String Historique_Letter_Manage(Other_SettingHistoricLetter O_HistoricLetter) {
         
          String contactId=null, Obj, histId = null, phistId = null, err_msg=null;
        
        try{
            Obj='Historic_Other_Letters';
           // String organisation = UserInfo.getOrganizationId();            
            String Link = ParametersUtils.BuildDMSLink()+O_HistoricLetter.DMS_DocLink+'/download';
         /*  if(O_HistoricLetter.SendEmail != null){
                
                contactId = Manage_EIP_Informations.Manage_Informations(O_HistoricLetter.IL_Contact, O_HistoricLetter.SF_AccountId, O_HistoricLetter.SendEmail);
             //  contactId = Manage_Informations(R_HistoricLetter.IL_Contact, R_HistoricLetter.SF_AccountId, R_HistoricLetter.SendEmail); 
            }
            else contactId = null;
            */
                   Historic_Other_Letters__c thisHistorique = new Historic_Other_Letters__c( 
                     
                      Account__c = O_HistoricLetter.SF_AccountId
                     , InfoLease_Contrat__c = O_HistoricLetter.IL_ContractNumber
                     , CustId__c =  O_HistoricLetter.x_CustId
                     , Langue_communication__c = O_HistoricLetter.IL_Langue
                     , ActiveDirectory_Username__c = O_HistoricLetter.x_ActiveDirectoryName
                     , Date_Letter__c = O_HistoricLetter.EIP_LetterDate
                     , Letter_Type__c = O_HistoricLetter.EIP_TypeLetter
                     , Letter_Owner__c = O_HistoricLetter.x_LetterOwner
                     , Owner_Extension_Phone_Number__c = O_HistoricLetter.x_OwnerPhoneExt
                 	, Owner_Phone_number__c = O_HistoricLetter.x_OwnerPhone
                 	, Owner_Title__c = O_HistoricLetter.x_OwnerTitle
                     , Letter_Link__c = Link
                     , Letter_DocType__c = O_HistoricLetter.DMS_DocType            
                               );
                    System.debug('un new Historique creer '+thisHistorique);
                    upsert thisHistorique;
                    histId = thisHistorique.id;
            system.debug(' Le histori id est :'+histId);
                   
            if(histId != null){
                    
                   Manage_EIP_User.Get_User(O_HistoricLetter.x_ActiveDirectoryName, histId, Obj);   
                    system.debug(' Le RT est :1');
                //    RecordType myRT = [Select Id From RecordType where Name = 'Other' ];//:O_HistoricLetter.EIP_TypeLetter];
                //     system.debug(' Le RT est :'+myRT.Id);
                    historic__c historic = new Historic__c (
                    	
                    	//	RecordTypeId = myRT.Id
                    		Account__c = O_HistoricLetter.SF_AccountId
                    	,	Document_Link__c = Link //O_HistoricLetter.DMS_DocLink
                    	,	Historic_Document_Type__c = O_HistoricLetter.EIP_TypeLetter
                    	,	Other_Historic_Detail__c = histId
                        , 	Object_Name__c = Obj
                
                );
                
                upsert historic;
                phistId = historic.Id;
                
                 obj='pHistory';
                system.debug(' Le histori est :'+phistId);
                
                Manage_EIP_User.Get_User(O_HistoricLetter.x_ActiveDirectoryName, phistId, obj);
            }
                
            
            
        }catch(Exception ex){
              err_Msg = ex.getMessage();
                if(err_Msg != null && histId != null){
                    Historic_Other_Letters__c ho = new Historic_Other_Letters__c(id = histId);
                    delete ho;
                }
                histId = null;
            
        }
         
         system.debug(' historiesCustomResponse '+new historiesCustomResponse(histId,phistId, err_Msg));
        
         return JSON.serialize(new historiesCustomResponse(histId,phistId, err_Msg));
     }

}