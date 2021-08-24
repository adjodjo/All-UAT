public class Manage_EIP_User {
    
     static final String message_11 = 'message_11';
   
    // GEt SFDC USER from EIP AD user  
    @future
    public static void Get_User(String eipLoginUser, String objectId, String obj){
         
        String userId, err_Msg, ProfileName, pName, pEmail, pTitle;
        
        try{  
             system.debug('le new created by user est '+eipLoginUser+ ' id '+objectId + ' object '+obj);       
            if( eipLoginUser != null || String.isNotBlank(eipLoginUser) || String.isNotEmpty(eipLoginUser)){ //eipLoginUser != null || eipLoginUser != '' ||  !String.isEmpty(eipLoginUser)
                
                String LogUser = eipLoginUser.substringAfter('\\');
                if(LogUser == null || String.isEmpty(LogUser)){
                    LogUser = eipLoginUser;
                }
                
                List<User> createdBy = [Select id, Name, email, profileId, Profile.Name, EIP_Login_User__c, Title 
                                        From User 
                                        Where EIP_Login_User__c =:LogUser limit 1];                
                //String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                
                 system.debug('liste de create by user  est '+createdBy);  
                if(createdBy.size() > 0){
                    
                     for(User u : createdBy){
                    	userId = u.id;
                         ProfileName = u.Profile.Name;
                         pName = u.Name;
                         pTitle = u.Title;
                	}
               system.debug('lle new user est  est '+userId); 
            if (obj == 'Historic'){
                Historique__c userHistoric = new Historique__c(id = objectId, ownerId = userId, Created_ById__c = userId, Sender_Profile__c =ProfileName );
                update userHistoric;
            }
            else if(obj == 'Case'){
                Case userCase = new Case(id = objectId, Created_ById__c = userId, Requested_By__c = userId);
                update userCase;
            	}
                    else if(obj == 'Account'){
                        Account userAccount = new Account(id = objectId, ownerId = userId, 	Created_ById__c= userId);
                        update userAccount;
                    }
                     else if(obj == 'Historic_Retard'){
                        Historic_Retard__c HRetard = new Historic_Retard__c(id = objectId, ownerId = userId, Created_ById__c= userId);
                        update HRetard;
                    }
                     else if(obj == 'Historic_Welcome'){
                        Historic_Welcome__c HRetard = new Historic_Welcome__c(id = objectId, ownerId = userId, Created_ById__c= userId);
                        update HRetard;
                    }
                    else if(obj == 'Historic_AVISTERM'){
                        Historic_AVISTERM__c HRetard = new Historic_AVISTERM__c(id = objectId, ownerId = userId, Created_ById__c= userId);
                        update HRetard;
                    }
                     else if(obj == 'Historic_Other_Letters'){
                        Historic_Other_Letters__c HRetard = new Historic_Other_Letters__c(id = objectId, ownerId = userId, Created_ById__c= userId);
                        update HRetard;
                    }
                     else if(obj == 'Historic_Invoice'){
                        Historic_Invoice__c HInvoice = new Historic_Invoice__c(id = objectId, ownerId = userId, Created_ById__c= userId);
                        update HInvoice;
                    }
                    else if(obj == 'pHistory'){
                        Historic__c pHistoric = new Historic__c(id = objectId,  Created_ById__c= userId);
                        update pHistoric;
                    }
                    
                    
           }
                else{
                      
                    if (obj == 'Historic'){
                Historique__c userHistoric = new Historique__c(id = objectId, Created_ById__c = userInfo.getUserid());
                update userHistoric;
            }
            else if(obj == 'Case'){
               Case userCase = new Case(id = objectId,  Created_ById__c= userInfo.getUserid() );
                update userCase;
            	}
                    else if(obj == 'Account'){
                        Account userAccount = new Account(id = objectId, Created_ById__c= userInfo.getUserid());
                        update userAccount;
                    }
                    else if(obj == 'Historic_Retard'){
                        Historic_Retard__c HRetard = new Historic_Retard__c(id = objectId, Created_ById__c= userInfo.getUserid());
                        update HRetard;
                    }
                    else if(obj == 'Historic_Welcome'){
                        Historic_Welcome__c HRetard = new Historic_Welcome__c(id = objectId, Created_ById__c= userInfo.getUserid());
                        update HRetard;  
                    }
                    else if(obj == 'Historic_AVISTERM'){
                        Historic_AVISTERM__c HRetard = new Historic_AVISTERM__c(id = objectId, Created_ById__c= userInfo.getUserid());
                        update HRetard;
                    }
                    else if(obj == 'Historic_Invoice'){
                        Historic_Invoice__c HInvoice = new Historic_Invoice__c(id = objectId, Created_ById__c= userInfo.getUserid());
                        update HInvoice;
                    }
                     else if(obj == 'pHistory'){
                        Historic__c pHistoric = new Historic__c(id = objectId, Created_ById__c= userInfo.getUserid());
                        update pHistoric;
                    }
                }
        }
        else {
              
            if (obj == 'Historic'){
                Historique__c userHistoric = new Historique__c(id = objectId, Created_ById__c = userInfo.getUserid());
                update userHistoric;
            }
            else if(obj == 'Case'){
               Case userCase = new Case(id = objectId,  Created_ById__c= userInfo.getUserid() );
                update userCase;
            	}
                    else if(obj == 'Account'){
                        Account userAccount = new Account(id = objectId, Created_ById__c= userInfo.getUserid());
                        update userAccount;
                    }
            else if(obj == 'Historic_Retard'){
                         Historic_Retard__c HRetard = new Historic_Retard__c(id = objectId, Created_ById__c= userInfo.getUserid());
                                update HRetard;
                    }
            		else if(obj == 'Historic_Welcome'){
                         Historic_Retard__c HRetard = new Historic_Retard__c(id = objectId, Created_ById__c= userInfo.getUserid());
                                update HRetard;
                    }
            else if(obj == 'Historic_AVISTERM'){
                         Historic_AVISTERM__c HRetard = new Historic_AVISTERM__c(id = objectId, Created_ById__c= userInfo.getUserid());
                                update HRetard;
                    }
            else if(obj == 'Historic_Invoice'){
                        Historic_Invoice__c HInvoice = new Historic_Invoice__c(id = objectId, Created_ById__c= userInfo.getUserid());
                        update HInvoice;
                    }
             		else if(obj == 'pHistory'){
                        Historic__c pHistoric = new Historic__c(id = objectId, Created_ById__c= userInfo.getUserid());
                        update pHistoric;
                    }
        	}
        }catch( Exception ex){
            system.debug(ex.getMessage());
        }
    } 
    
    
}