public with sharing class SendBuyoutEmail {
    
    static final String message_2 = 'message_2';
    static final String message_6 = 'message_6';
    static final String message_7 = 'message_7';
    static final String message_8 = 'message_8';
    static final String message_4 = 'message_4';
      //@future
    @AuraEnabled
    public static String BuyoutEmail(String RecordId){
        
        String err_Msg = null, userLanguage = UserInfo.getLanguage(); 

        String buyoutObject = null ,caseId, obj, resp, ContentV, histId, recId,origine, TypeNote, BuyouType,cpartialType, email, ccEmail, accId, langue, ContactId = null, AccountId = null, contId, contEmail, 
            custId, InfoLease, OperationType, Error_Msg = null, myId = null, tempId = null, descEquip, ADUser, ACCMgr, dateB, bExpireDate, buyoutNum=null;
        Boolean ThirdParty, partialType=false;
      //  Date dateB, bExpireDate;
        Decimal mRachat, bendOfT, balance, TRF, TRP, TRH, bTotalAmount, bRate ;
        Integer bTerm;
        Map<String, Object> response;

        
        System.debug('le Id est '+ RecordId+ ' objet est ');
        
        try{
            if (String.isBlank(RecordId) || RecordId == null || RecordId == '')
            {
                err_Msg = MessageUtils.ErrorMessage(userLanguage, message_6);
            }
            else{
                 
               //    else{ // SEND EMAIL FROM HISTORIC DIRECTLY
                         	 system.debug(' Ceci est un historique a send  '+RecordId);
                        
                        buyoutObject = 'Historic';
                      	resp = SendEmailRules.BuildSendEmail(RecordId); //BuildSendEmail(RecordId);

                        response = (Map<String, Object>) JSON.deserializeUntyped(resp);
                        
                         system.debug(' la reponse de send est   '+response);
                        
                        err_Msg = (String)response.get('API_Error_Msg');
                        Obj = (String)response.get('Obj');
                        myId = (String)response.get('Id');

                 //   } 
            }
        }catch(Exception ex){
            
            system.debug('ceci est un test catch '+ex.getMessage());
            myId = null;
            obj = buyoutObject;
            err_Msg = ex.getMessage();
            
        }
        
        String s = JSON.serialize(new CustomResponse(myId , Obj, err_Msg)).remove('\\');
system.debug(' la reponse de send final est   '+s);
        return JSON.serialize(new CustomResponse(myId , Obj, err_Msg)).remove('\\');   
    } 



    
    ///////////////////////////  Updating Send status to track email sending /////////////////////////////////////////////
    //
    
    @AuraEnabled
    public static void updateBuyout(String RecordId, String msg){
        String statusMsg = null;
        try{
            
             Historique__c  forupdate = [Select contact__c, email__c from Historique__c  where id = :RecordId];
        system.debug('ceci est un test h '+RecordId+ ' '+msg);
        
        if(msg.startsWith('Echec')){
            statusMsg = 'Echec d\'envoi à ';
             Historique__c forChatter= new Historique__c(id = RecordId, Send_Status__c = statusMsg+' '+forupdate.email__c);
             update forChatter;
        }
           
    /*    else  statusMsg = 'Email envoyé à ';
        system.debug('le satus de envoi est  '+statusMsg+' '+forupdate.email__c);
        Historique__c forChatter= new Historique__c(id = RecordId, Send_Status__c = statusMsg+' '+forupdate.email__c);
        system.debug('ceci est un update de message '+RecordId+ ' '+statusMsg);
            */
        
        
        }catch( Exception ex){
            
            statusMsg = 'Echec d\'envoi à ';
       
   		 }
    }
}