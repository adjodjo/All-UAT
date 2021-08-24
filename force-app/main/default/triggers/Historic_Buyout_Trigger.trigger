trigger Historic_Buyout_Trigger on Historique__c (After insert) {
    
      if(Trigger.isAfter){
       
        if(Trigger.isInsert ){
            HistoricBuyoutHandler.OnAfterInsert(Trigger.new);
        } 
    } 

}