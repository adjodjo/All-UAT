@RestResource(urlMapping='/Account/Search/Id/*')


global with sharing class Account_Retrieve_WS {
    
    
    
     @HttpGet
        global static void GetAccountById(){
            
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
            response.addHeader('Content-Type','application/json');
            
            String contactid = null, PrincipalContact = null, s;
           // List<CustomResponseSearch> myCResponseList = new List<CustomResponseSearch>();
            CustomResponseSearch myCResponseList ;
            Boolean isStrategic = false;
            try
        {
            String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            system.debug('accountId -- '+accountId);
        if(accountId != '' )
        {
            // Get relationship between account and contact
            for (accountContactRelation accRelation : [select Id, contactId, accountId From AccountContactRelation where accountId = :accountId AND Is_Primary__c = true limit 1]){
                if(String.isNotBlank(accRelation.contactId)){
                    contactid = accRelation.contactId; // Get the contact Id
                }
                
            }
            if(contactid != null ){
                // Get primary contact Name
                for ( contact c : [select id, Name From Contact where accountId = :accountId and Id = :contactid]){
                    PrincipalContact = c.Name;
                }
            }
            
            // Get account informations
         
        for(Account acc : [Select Id, Name, Phone, Compagnie_Email__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Owner.Name, Sales_Priority__c, RecordType.Name
                                      from Account where Id = :accountId LIMIT 1]){
                             system.debug('acc -- '+acc);              
                                           
                // myAccountId.add(acc.Id);   acc.Compagnie_Email__c,
                if(acc.Sales_Priority__c == 'Strategic' || acc.Sales_Priority__c == 'STRAT'){
                    isStrategic = true;
                }
                      system.debug('isStrategic -- '+isStrategic);                         
            myCResponseList = new CustomResponseSearch(acc.Id, acc.Name, acc.Phone, PrincipalContact, acc.Compagnie_Email__c,  acc.BillingStreet,  //acc.Contact_Principal__c
                                                               acc.BillingCity, acc.BillingState, acc.BillingPostalCode, acc.BillingCountry,acc.RecordType.Name, acc.owner.Name, isStrategic);
                                          
                                         
        system.debug('myCResponseList -- '+myCResponseList);
                                      
                                      
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