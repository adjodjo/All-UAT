public class Welcome_Historique_Letter {
    
    
    public static String Historique_Letter_Manage(Welcome_SettingHistoricLetter W_HistoricLetter) {
     String contactId=null, Obj, histId = null, phistId = null, err_msg=null;
        
        try{
            
            String Link = ParametersUtils.BuildDMSLink()+W_HistoricLetter.DMS_DocLink+'/download';
         
            obj = 'Historic_Welcome';
              //  RecordType myRT = [Select Id From RecordType where Name = :R_HistoricLetter.TypeNote];
                 Historic_Welcome__c thisHistorique = new Historic_Welcome__c( 
                       Account__c = W_HistoricLetter.SF_AccountId
                     , Contrat_InfoLease__c = W_HistoricLetter.IL_ContractNumber
                     , CustId__c =  W_HistoricLetter.x_CustId
                     , Langue_communication__c = W_HistoricLetter.IL_Langue
                     , ActiveDirectory_Username__c = W_HistoricLetter.x_ActiveDirectoryName
                     , Date_Letter__c = W_HistoricLetter.EIP_LetterDate
                     , Letter_Type__c = W_HistoricLetter.EIP_TypeLetter
                     , Letter_Owner__c = W_HistoricLetter.x_LetterOwner
                     , Owner_Extension_Phone_Number__c = W_HistoricLetter.x_OwnerPhoneExt
                 	, Owner_Phone_number__c = W_HistoricLetter.x_OwnerPhone
                 	, Owner_Title__c = W_HistoricLetter.x_OwnerTitle
                     , Letter_Link__c = Link
                     , Letter_DocType__c = W_HistoricLetter.DMS_DocType
                    
                               );
           
                    System.debug('un new Historique creer '+thisHistorique);
                    upsert thisHistorique;
                    histId = thisHistorique.id;  
                    Manage_EIP_User.Get_User(W_HistoricLetter.x_ActiveDirectoryName, histId, obj);
                    
            	if(histId != null){
                    
                  
              //      RecordType myRT = [Select Id From RecordType where Name = :W_HistoricLetter.EIP_TypeLetter];
                    
                    historic__c historic = new Historic__c (
                    	
                    	//	RecordTypeId = myRT.Id
                    		Account__c = W_HistoricLetter.SF_AccountId
                    	,	Document_Link__c = Link
                    	,	Historic_Document_Type__c = W_HistoricLetter.EIP_TypeLetter
                    	,	Welcome_Historic_Detail__c = histId
                         , 	Object_Name__c = Obj
                
                );
                
                upsert historic;
                obj='pHistory';
                    
                phistId = historic.Id;
                Manage_EIP_User.Get_User(W_HistoricLetter.x_ActiveDirectoryName, phistId, obj);
            }
                
           
        	}catch(Exception ex){
            
                err_Msg = ex.getMessage();
                histId = null;
        }
        system.debug('les info sont : histId='+histId+' phistId='+phistId+  ' err_Msg= '+err_Msg );
        
        return JSON.serialize(new historiesCustomResponse(histId,phistId, err_Msg));
    }
    
     
}