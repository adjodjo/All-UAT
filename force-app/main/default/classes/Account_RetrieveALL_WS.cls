@RestResource(urlMapping='/Account/Search/ALL/*')


global with sharing Class Account_RetrieveALL_WS {
    
    @HttpGet
        global static void GetAccountById(){
            
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
            response.addHeader('Content-Type','application/json');
            Map<Id, Account> mapAccount = new Map<Id, Account>();
             Map<Id, String> mapContact = new Map<Id, String>();
            List<String> accountId = new List<String>();
             List<String> relatedContactId = new List<String>();
          //  String contactid = null, PrincipalContact = null;
            List<CustomResponseSearch> myCResponseList = new List<CustomResponseSearch>();
            Boolean isStrategic = false;
            try
        {
            // Get account informations
         
        for(Account acc : [Select Id, Name, Phone, Compagnie_Email__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Owner.Name, Sales_Priority__c, RecordType.Name
                                      from Account Where RecordType.Name = 'Customer'  LIMIT 500]){
                             system.debug('acc -- '+acc); 
                                          
                           mapAccount.put(acc.Id, acc) ;
                          accountId.add(acc.Id);
                                      }                        
              
           // Get relationship between account and contact
            for (accountContactRelation accRelation : [select Id, contactId, accountId From AccountContactRelation where accountId IN :accountId AND Is_Primary__c = true ]){
                if(String.isNotBlank(accRelation.contactId)){
                    relatedContactId.add(accRelation.contactId); // Get the contact Id
                }
                
            }
            if(relatedContactId.size() > 0 ){   
                // Get primary contact Name
                for ( contact c : [select id, Name, accountId From Contact where accountId IN :accountId and Id IN :relatedContactId]){
                    mapContact.put(c.accountId, c.Name ); //PrincipalContact = c.Name;
                }
            }
            
            for(Id key1 : mapAccount.keySet()){
                
                for(Id key2 : mapContact.keySet()){
                    
                    if(key1 == key2){
                        
                        account acct = mapAccount.get(key1);
                        String PrincipalContact = mapContact.get(Key2);
                        
                        if(acct.Sales_Priority__c == 'Strategic' || acct.Sales_Priority__c == 'STRAT'){
                    isStrategic = true;
                }
                        
                        
                        myCResponseList.add(new CustomResponseSearch(acct.Id, acct.Name, acct.Phone, PrincipalContact, acct.Compagnie_Email__c,  acct.BillingStreet,  //acc.Contact_Principal__c
                                                               acct.BillingCity, acct.BillingState, acct.BillingPostalCode, acct.BillingCountry,acct.RecordType.Name, acct.owner.Name, isStrategic));
                          
                        }
                    
                    }
                }
            
             if( myCResponseList != null ) {
               
                
                response.statusCode = 200;
                String jsonResult = JSON.serialize(myCResponseList);
                response.responseBody = Blob.valueOf(jsonResult);
                 system.debug('le rest '+response.responseBody);
            } 
            else
            {
                response.statusCode = 400;
               
                String jsonResult = JSON.serialize(myCResponseList);
                response.responseBody = Blob.valueOf( jsonResult);    
            }
        
            
                
            }catch(Exception ex){
            system.debug(' exception '+ex.getStackTraceString());
                
                 response.statusCode = 500;
              //  String jsonResult = JSON.serialize(myCResponseList);
                response.responseBody = Blob.valueOf(ex.getStackTraceString());
                system.debug('le rest '+response.responseBody);
        }

    }

}