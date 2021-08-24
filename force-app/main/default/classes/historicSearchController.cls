public class historicSearchController {
    
    @AuraEnabled
    public static List<Historique__c> historicSearch(String bNumber,String bContract, String account, String contact, Decimal amount, Integer variance, Date sdate, Date edate, boolean invoice ){ //, Decimal amount1, Decimal amount2, Date d1, Date d2){
        String s = 'toto';
        
        String id, acc, cont, hist;
        
        system.debug('amount1= '+amount+ ' variance = '+variance);
        Decimal mont, mt1=0, mt2=0;
        
        if( amount != null || variance != null ||  amount != 0 ){
            system.debug('ici');
            
            variance = (variance == null) ? 125 : variance;
            mt1 = (amount == null ) ? 0 : amount - variance;
            mt2 = (amount == null ) ? 0 : amount + variance;
            
            system.debug('xxxxmt1 '+mt1+ ' mt2 '+mt2);
         //    mt1 = amount - variance;
         //    mt2 = amount + variance;
        }
       
        String cs;
        
        List<Historique__c> ListHistories = new List<Historique__c>();
        
        system.debug('account= '+account+ ' contact = '+contact+' amount = '+amount +' var = '+variance+' sdate = '+sdate+' edate = '+edate);
        
        List<String> myList = new List<String>();
        
         if(bNumber != null ){
            system.debug('ici 1');
            //String searchString = '%' + account + '%';
            ListHistories = [SELECT Name, Account__r.Name, Contact__r.Name, Buyout_Total_Amount__c, Date_Buyout__c, id, With_Invoice__c, Contrat_InfoLease__c, CustId__c, Buyout_Number__c 
                                             FROM Historique__c 
                                             WHERE Buyout_Number__c  =: bNumber ];
        }
        
         else if(bContract != null ){
            system.debug('ici 1');
            String searchString = bContract + '%';
            ListHistories = [SELECT Name, Account__r.Name, Contact__r.Name, Buyout_Total_Amount__c, Date_Buyout__c, id, With_Invoice__c, Contrat_InfoLease__c, CustId__c, Buyout_Number__c 
                                             FROM Historique__c 
                                             WHERE  Contrat_InfoLease__c Like :searchString OR CustId__c Like :searchString ]; //Contrat_InfoLease__c  =: bContract OR
        }
        
        else if(account != null && (contact == null && mt1 == 0   && sdate == null && edate == null)){
            system.debug('ici 1');
            String searchString = '%' + account + '%';
            ListHistories = [SELECT Name, Account__r.Name, Contact__r.Name, Buyout_Total_Amount__c, Date_Buyout__c, id, With_Invoice__c, Contrat_InfoLease__c, CustId__c, Buyout_Number__c 
                                             FROM Historique__c 
                                             WHERE Account__r.Name Like :searchString AND (With_Invoice__c =: invoice OR With_Invoice__c = false) ];
        }
        else if( account != null && contact != null && mt1 == 0  && sdate == null && edate == null) {
            system.debug('ici 2');
            String searchString1 = '%' + account + '%';
            String searchString2 = '%' + contact + '%';
            ListHistories = [SELECT Name, Account__r.Name, Contact__r.Name, Buyout_Total_Amount__c, Date_Buyout__c, id, With_Invoice__c, Contrat_InfoLease__c, CustId__c, Buyout_Number__c 
                                             FROM Historique__c 
                                             WHERE Account__r.Name Like :searchString1 AND Contact__r.Name Like :searchString2 
                             				AND (With_Invoice__c =: invoice OR With_Invoice__c = false)];
        }
        
        else if(account != null && contact != null && mt1 > 0  && (sdate == null && edate == null)){
            system.debug('ici 3');
            ListHistories = [SELECT Name, Account__r.Name, Contact__r.Name, Buyout_Total_Amount__c, Date_Buyout__c, id, With_Invoice__c, Contrat_InfoLease__c , CustId__c, Buyout_Number__c
                                             FROM Historique__c 
                                             WHERE Account__r.Name = :account AND Contact__r.Name = :contact
                                            AND (Buyout_Total_Amount__c > :mt1 AND Buyout_Total_Amount__c < :mt2)
                            				AND (With_Invoice__c =: invoice OR With_Invoice__c = false)];
        }
        else if(account != null && contact != null && mt1 == 0 && sdate != null && edate != null){
            system.debug('ici 4');
            ListHistories = [SELECT Name, Account__r.Name, Contact__r.Name, Buyout_Total_Amount__c, Date_Buyout__c, id, With_Invoice__c, Contrat_InfoLease__c, CustId__c, Buyout_Number__c 
                                             FROM Historique__c 
                                             WHERE Account__r.Name = :account AND Contact__r.Name = :contact
                                            AND (Buyout_Total_Amount__c > :mt1 AND Buyout_Total_Amount__c < :mt2)
                                            AND (Date_Buyout__c > :sdate AND Date_Buyout__c < :edate)
                            				AND (With_Invoice__c =: invoice OR With_Invoice__c = false)];
        }
        else if(account == null && contact != null && mt1 > 0 && sdate == null && edate == null){
            String searchString = '%' + contact + '%';
            system.debug('ici 5');
             ListHistories = [SELECT Name, Account__r.Name, Contact__r.Name, Buyout_Total_Amount__c, Date_Buyout__c, id, With_Invoice__c, Contrat_InfoLease__c, CustId__c, Buyout_Number__c 
                                             FROM Historique__c 
                                             WHERE Contact__r.Name Like :searchString AND (With_Invoice__c =: invoice OR With_Invoice__c = false)];
        }        
        else if(account != null && mt1 > 0 &&  (contact == null && sdate == null && edate == null)){
            String searchString = '%' + account + '%';
            system.debug('ici 6');
            ListHistories = [SELECT Name, Account__r.Name, Contact__r.Name, Buyout_Total_Amount__c, Date_Buyout__c, id, With_Invoice__c, Contrat_InfoLease__c, CustId__c, Buyout_Number__c 
                                             FROM Historique__c 
                                             WHERE Account__r.Name Like :searchString 
                                            AND (Buyout_Total_Amount__c > :mt1 AND Buyout_Total_Amount__c < :mt2)
                            				AND (With_Invoice__c =: invoice OR With_Invoice__c = false)];
        }
        else if(account != null &&  sdate != null && edate != null){
            system.debug('ici 7');
            ListHistories = [SELECT Name, Account__r.Name, Contact__r.Name, Buyout_Total_Amount__c, Date_Buyout__c, id, With_Invoice__c, Contrat_InfoLease__c, CustId__c, Buyout_Number__c 
                                             FROM Historique__c 
                                             WHERE Account__r.Name = :account 
                                             AND (Date_Buyout__c > :sdate AND Date_Buyout__c < :edate)
                            				AND (With_Invoice__c =: invoice OR With_Invoice__c = false)];
        }
        
        
        System.debug('ListHistories--->' + ListHistories);
     
        return ListHistories;
    }

}