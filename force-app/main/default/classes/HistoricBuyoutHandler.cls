public class HistoricBuyoutHandler {
    
     public static void OnAfterInsert(Historique__c[] historicObjects){
         
         Historique__c historicObject;
          Case caseToUpdate;
         
         for(Historique__c h : historicObjects){
             
             historicObject = h;         
     }
         
         if(historicObject.Case__c != null){
             
             if(historicObject.Type_Note__c == 'Buyout'){
                                  
             caseToUpdate = new Case(Id = historicObject.Case__c, AccountId = historicObject.Account__c, ContactId = historicObject.Contact__c,	ActiveDirectory_Username__c = historicObject.ActiveDirectory_Username__c,
                                     Contrat_InfoLease__c = historicObject.Contrat_InfoLease__c, Created_ById__c = historicObject.Created_ById__c, SuppliedEmail = historicObject.Email__c);
             
             }
             
             Upsert caseToUpdate;
                 
             
         }
}
    
}