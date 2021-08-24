@RestResource(urlMapping='/Account/Search/*')

global with sharing class Account_Search_WS {
    
    static final String message_5 = 'message_5';
    static final String message_12 = 'message_12';
    //  Recherche des comptes existant
    @HttpPost
    global static void  Account_Search(String EIP_AccountName, Integer EIP_Limit, Integer EIP_Offset, Double EIP_percent){
               
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type','application/json');
        String contactid, accId, PrincipalContact;
        String err_Msg = null, userLanguage = UserInfo.getLanguage();
        List<Account> AccountSearchList = new List<Account>();
        
        List<CustomResponseSearch> myCResponseList = new List<CustomResponseSearch>();
        Map<ID, String> seachMap = new Map<ID, String> ();
        
        try{
            
            
            String sAccount;
            
            
            
            
             if(EIP_AccountName != null || String.isNotBlank(EIP_AccountName)){
            
            String delimiter1 = ' ',delimiter2 = ';', firstSplit= null, lastSplits= null, searchAccount = EIP_AccountName, myDelimiteur =null;
            system.debug('le cc entré est '+EIP_AccountName);
            // Test délimiteur
            String firstSplit1= null, firstSplit2= null, lastSplits1= null, lastSplits2= null;
            firstSplit1 = searchAccount.substringBefore(delimiter1); 
            system.debug('firstSplit1 '+firstSplit1);
            lastSplits1 = searchAccount.substringAfter(delimiter1);
            system.debug('lastSplits1 '+lastSplits1.length());
            firstSplit2 = searchAccount.substringBefore(delimiter2); 
            system.debug('firstSplit2 '+firstSplit2);
            lastSplits2 = searchAccount.substringAfter(delimiter2);
            system.debug('lastSplits2 '+lastSplits2);
            
            if((lastSplits1.length() > 0) ){
                
                myDelimiteur = delimiter1;
                system.debug('firstSplit1 '+firstSplit1);
                system.debug('cei délimiteur 1 '+delimiter1);
            }
            else if(lastSplits2.length() > 0  ){
                
                myDelimiteur = delimiter2;
                system.debug('firstSplit2 '+firstSplit2);
                system.debug('cei délimiteur 2 '+delimiter2);
            }
            else{
                sAccount = searchAccount+'*';
            } 
                 
                 
            if(myDelimiteur != null){
                system.debug('le délimiteur est '+myDelimiteur);
                do{
                    
                    firstSplit = '';  lastSplits = '';  
                    if(searchAccount.length() > 0){ // check if the cc email in not null before used CC email field value
                        
                        firstSplit = searchAccount.substringBefore(myDelimiteur); // 'this'
                        lastSplits = searchAccount.substringAfter(myDelimiteur);
                        
                        if( lastSplits.length() == 0 && searchAccount.length() > 0){
                            sAccount = sAccount + searchAccount+'*';
                            searchAccount = '';
                            system.debug('la liste des cc email est '+sAccount);
                        }
                        else{
                            if(firstSplit.length() > 0 && lastSplits.length() > 0){
                                sAccount = firstSplit+'*' + ' OR ';
                                searchAccount = lastSplits;
                            }
                        }
                    } 
                    system.debug('la liste des cc email est '+sAccount);
                }While(String.isNotBlank(searchAccount));
            }                       
        }
            
   
            
            Integer NumSearch = Math.round(EIP_AccountName.length()*1); //EIP_percent
             System.debug('Les nombre de lettre recherc  '+EIP_AccountName.length());
             System.debug('Les % est  '+EIP_percent);
             System.debug('Les nombre de lettre est  '+NumSearch);
            
            String varSearch = EIP_AccountName.left(NumSearch);
            System.debug('Les nouveau mot est  '+varSearch);
        
        System.debug('Les comptes rechercher sont '+sAccount);
        String accountName = '%'+varSearch+'%';
        String accountName1 = '%'+varSearch;
        String accountName2 = varSearch+'%';
        
        //Compagnie_Email__c,
       // List<Account> searchList = new List<Account>();
            
             List <List<Account>> searchList = [ FIND :sAccount IN Name FIELDS RETURNING 
                                        Account(Id, Name, Phone, Contact_Principal__c, Compagnie_Email__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, RecordType.Name, Sales_Priority__c, Owner.Name 
                                        ORDER BY Name LIMIT :EIP_Limit OFFSET :EIP_Offset )];
        
        /*    
            for(Account acct : [SELECT Id, Name, Phone, Contact_Principal__c, Compagnie_Email__c, BillingStreet,
                            BillingCity, BillingState, BillingPostalCode, BillingCountry,RecordTypeId,RecordType.Name, Sales_Priority__c, Owner.Name 
                            FROM Account 
                            WHERE 
                           (Name LIKE :accountName OR Name LIKE :accountName1 OR Name LIKE :accountName2) 
                            AND (RecordType.Name = 'Customer' OR (RecordType.Name = 'Vendor' AND Sales_Priority__c = 'Strategic'))
                            ORDER BY Name LIMIT :EIP_Limit OFFSET :EIP_Offset]){
                                searchList.add(acct);
                            }
            */
            
            List<String> accIdList = new List<String>();
            
             for( List<Account> myList : searchList){
                                           
            if(myList.size() > 0){
            
            for(Account accList : myList){
                accIdList.add(accList.Id);
                AccountSearchList.add(accList);
            }
            }
             }
        
       // List<SS_CustomResponseSearch> SSmyCResponseList = new List<SS_CustomResponseSearch>();
        
            
        if(searchList.size() > 0){
            
            // Get relationship between account and contact
            for (accountContactRelation accRelation : [select Id, contactId, accountId From AccountContactRelation where accountId IN :accIdList AND Is_Primary__c = true limit 1]){
                if(String.isNotBlank(accRelation.contactId)){
                    contactid = accRelation.contactId; // Get the contact Id
                    accId = accRelation.accountId;
                }
                
            }
            if(contactid != null ){
                // Get primary contact Name
                for ( contact c : [select id, Name From Contact where accountId = :accId and Id = :contactid]){
                    PrincipalContact = c.Name;
                }
            }
            
            
           System.debug('La taille de la réponse est  '+AccountSearchList.size());
            
            for(Account acc : AccountSearchList){
                Boolean isStrategic = false;
                // myAccountId.add(acc.Id);   acc.Compagnie_Email__c,
                if(acc.Sales_Priority__c == 'Strategic' || acc.Sales_Priority__c == 'STRAT'){
                    isStrategic = true;
                }
                
                  myCResponseList.add(new CustomResponseSearch(acc.Id, acc.Name, acc.Phone, PrincipalContact, acc.Compagnie_Email__c,  acc.BillingStreet,  //acc.Contact_Principal__c
                                                               acc.BillingCity, acc.BillingState, acc.BillingPostalCode, acc.BillingCountry,acc.RecordType.Name, acc.owner.Name, isStrategic));
                
                response.statusCode = 200;
                String jsonResult = JSON.serialize(myCResponseList);
                response.responseBody = Blob.valueOf(jsonResult);
                 system.debug('le rest '+response.responseBody);
            }
        }
        else {
            //myCResponseList ;
            response.statusCode = 400;
                String jsonResult = JSON.serialize(myCResponseList);
                response.responseBody = Blob.valueOf(jsonResult);
            system.debug('le rest '+jsonResult);
          
        }
        
        
        }catch(Exception ex){
            
           String jsonResult = JSON.serialize(String.valueOf(ex));
            response.responseBody = Blob.valueOf(jsonResult);
            response.statusCode = 500;            
            
        }
    }
}

/*
 {
"EIP_AccountName" : "ppppp",
"EIP_Limit" : 10,
"EIP_Offset" : 0,
"EIP_percent" : 0.8
}
*/