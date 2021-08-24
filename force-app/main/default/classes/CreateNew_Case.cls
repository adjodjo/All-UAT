public with sharing class CreateNew_Case {
    
   /* 
    public  static String  CreateNewCase(String eipAccount, String contactId, String eipContact, String eipContractNumber, String eipCustId,  
                                         String BuyoutType, Date epiDateBuyout, String eipOperationType, String eipLangue, Date eipExpiryDate,String userId, String userEmail, String eipExceptionMsg) {
                                             
                                             String caseSubject, caseId, uId, uEmail;    
                                             
                                             system.debug('ceci est un test');
                                             
                                             try{
                                                 
                                                 RecordType myRT = [Select Id From RecordType where Name = 'Customer Service'];
                                                 system.debug('record type '+ myRT.Id);                
                                                 Group gp = [select Id, name, DeveloperName from Group where type = 'queue' and DeveloperName = 'SAC_Queue'];
                                                 system.debug('********** Le compte est ***********3 = '+eipAccount+ ' le contact est **** = '+contactId);
                                                 
                                                 Case thisCase = new Case(  AccountId = eipAccount
                                                                          , RecordTypeId = myRT.Id
                                                                          , Status = 'New'
                                                                          , Origin = 'EIP'
                                                                          , Subject = 'EIP Buyout Request'
                                                                          , Type = eipOperationType
                                                                          , OwnerId = gp.Id
                                                                          , ContactId = contactId
                                                                          , Contrat_InfoLease__c = eipContractNumber
                                                                          , CustId__c =  eipCustId
                                                                          , Langue_Communication__c = eipLangue
                                                                          , Date_Buyout__c = epiDateBuyout
                                                                          , Operation_Type__c = eipOperationType
                                                                          , EIP_Exception__c = eipExceptionMsg
                                                                          , Requested_By__c = userId
                                                                          , SuppliedEmail = userEmail
                                                                          , Buyout_Type__c = BuyoutType
                                                                          , Request_Type__c = eipOperationType
                                                                         
                                                                          
                                                                         );
                                                 
                                                 System.debug('un new case creer '+thisCase);
                                                 
                                                 upsert thisCase;
                                                 
                                                 System.debug('Le Id du new case creer '+thisCase.Id);
                                                 
                                                 caseId = thisCase.Id;
                                                 
                                                 if (caseId != null){
                                                     
                                                     caseSubject = eipOperationType+ '[ref:'+caseId +':ref]';
                                                                                                          
                                                     Case updatecase = new Case(Id = caseId, subject = caseSubject);
                                                     update updatecase;
                                                     
                                                 }
                                                 
                                                 else {
                                                     caseId = null;
                                                 }
                                             }catch(Exception ex){
                                                 
                                                 String err_Msg = ex.getMessage();
                                                 
                                             } 
                                             return caseId; // caseId 
                                         }
    
*/    
}