global with sharing class Account_Verification {


    
    public static String Account_Contact_Manage(SettingsAccountContactAPI AccountSettings){
        
        String accountId,  accEmail, contactName, principalContact, accId, contactId, contactResp, obj;
        String tel, cp, ville, mail, country, state;
        String exResponse;
        Map<String, Object> resp;
        String Account_Msg;
                                                
                                                
       // Contact_Creation.CustomContactResponse contactId;

        try{
           Obj = 'Account';
            
                String RT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            
                country = Manage_State_Country.manage_Country(AccountSettings.eipAccountBillingCountry);
                state = Manage_State_Country.manage_State(AccountSettings.eipAccountBillingState);
                
                    // check if this custom accoun exist
             System.debug('Les comptes rechercher sont '+AccountSettings.eipAccountName+' Phone -- '+AccountSettings.eipAccountPhone+ ' City -- '+AccountSettings.eipAccountBillingCity+
                         ' state-- '+AccountSettings.eipAccountBillingState+' street-- '+AccountSettings.eipAccountBillingStreet+' country-- '+AccountSettings.eipAccountBillingCountry);
            
            List<Account> existingAccount = [Select Id, Name, Phone, RecordTypeId, BillingState, BillingStreet, BillingCountry
                                             From Account 
                                             Where Name = :AccountSettings.eipAccountName AND Phone = :AccountSettings.eipAccountPhone AND
                                            BillingCity = :AccountSettings.eipAccountBillingCity AND BillingCountry = :country AND
                                            BillingState = :state AND BillingStreet = :AccountSettings.eipAccountBillingStreet AND
                                            (RecordType.Name = 'Customer' OR (RecordType.Name = 'Vendor' AND Sales_Priority__c = 'STRAT'))];
            
            System.debug('Leresultat de la recherche est '+existingAccount);
           
            if(existingAccount.size() == 0 ){
                String uName;
                
                If(AccountSettings.eipAccountUsualName == null || AccountSettings.eipAccountUsualName ==''){
                    uName = AccountSettings.eipAccountName;
                    system.debug('Le new usal Account name est '+uName);
                }
                else uName = AccountSettings.eipAccountUsualName;
                
                        List<Account> accList = new List<Account>{
                            new Account(Name = AccountSettings.eipAccountName,
                                        Nom_Usuel__c = uName,
                                        Doing_Business_As__c = uName,
                                        recordtypeId = RT,
                                        BillingPostalCode = AccountSettings.eipAccountPostalCode, 
                                        BillingCity = AccountSettings.eipAccountBillingCity, 
                                        BillingStreet =  AccountSettings.eipAccountBillingStreet,
                                        BillingState = state, //eipAccountBillingState,
                                        BillingCountry = country, //eipAccountBillingCountry,
                                        Phone = AccountSettings.eipAccountPhone, 
                                       Type = 'Other',
                                        Compagnie_Email__c = AccountSettings.eipAccountEmail,
                                       ActiveDirectory_Username__c = AccountSettings.eipActiveDirectoryName
                                       )
                        };
                        system.debug('Le compte a creer est '+accList);
                                           
                        Database.DMLOptions dml = new Database.DMLOptions();
                        dml.DuplicateRuleHeader.AllowSave = true;
                                                        
                        Database.SaveResult[] saveResult = Database.insert(accList, dml) ; //Create new Account if not exist
                                                        
                        for (Database.SaveResult sr : saveResult) {
                            if (sr.isSuccess()) {
                        
                                accountId = accList[0].Id;
                                system.debug('accountId '+ accountId);
                                
                                 // CREATE NEW CONTACT LINK TO ACCOUNT
                if( AccountSettings.eipContactName != null || String.isNotEmpty(AccountSettings.eipContactName) ){ 
             system.debug('ceci est le contact name '+ AccountSettings.eipContactName);
                contactId = Contact_Creation.Contact_Manage(accountId, AccountSettings.eipAccountPostalCode, AccountSettings.eipAccountBillingCity,AccountSettings.eipAccountBillingStreet, state, country, AccountSettings.eipContactPhone, AccountSettings.eipContactEmail, AccountSettings.eipContactName);
				                                            
                resp = (Map<String, Object>) JSON.deserializeUntyped(contactId);
                contactResp = (String)resp.get('API_Error_Msg');
                String contId = (String)resp.get('Id');
                    
                    Account_Msg = contactResp;

                }
                            }
                                                            
                            else{
                                                                
                                for(Database.Error err : sr.getErrors()) {
                                    Account_Msg =  err.getMessage();                           
                                    system.debug('erreur est '+err.getMessage());
                                    accountId = null;
                                }
                            }
                        }
                }
                else{

                    for(Account acct : existingAccount){
                        accountId = acct.Id;
                    }
                    
                     // CREATE NEW CONTACT LINK TO ACCOUNT
                if( AccountSettings.eipContactName != null || String.isNotEmpty(AccountSettings.eipContactName) ){ 
             system.debug('ceci est le contact name '+ AccountSettings.eipContactName);
                contactId = Contact_Creation.Contact_Manage(accountId, AccountSettings.eipAccountPostalCode, AccountSettings.eipAccountBillingCity,AccountSettings.eipAccountBillingStreet, state, country, AccountSettings.eipContactPhone, AccountSettings.eipContactEmail, AccountSettings.eipContactName);
				                                            
                resp = (Map<String, Object>) JSON.deserializeUntyped(contactId);
                contactResp = (String)resp.get('API_Error_Msg');
                String contId = (String)resp.get('Id');
                    
                    Account_Msg = contactResp;

                }
         
                }

          
        }catch(Exception ex){
                exResponse = JSON.serialize(ex.getStackTraceString());
            System.debug('ceci est le message de catch ' +exResponse);
            Account_Msg = exResponse;

                            
        }
        String aId = JSON.serialize(accountId);
    
        String account_contact_Id =accountId +' '+contactId;

        system.debug('account_contact_Id '+account_contact_Id);

        return JSON.serialize(new AccountCustomResponse(accountId , Obj, Account_Msg)).remove('\\'); //account_contact_Id;
    }
    
}