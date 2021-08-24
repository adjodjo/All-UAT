global with sharing class Contact_Creation {


    public static String  Contact_Manage(String accountId, String eipAccountPostalCode, String eipAccountBillingCity, String eipAccountBillingStreet, String eipAccountBillingState, String eipAccountBillingCountry,
                                            String eipAccountPhone, String eipContactEmail, String eipContactName){

    String contactId, contactMsg, contactName, name, cId, obj;
    try{
        obj = 'Contact';
        // test if there is at least Contat name parameter and create if necessery new Contact  
            if(accountId != null && (eipContactName != null || eipContactName != '')){

                String fn = eipContactName.substringBefore(' ');
                String ln = eipContactName.substringAfter(' ');
                
                if(ln == null || ln =='') {
                ln = fn;
                fn = '';
            }
            
                List<Contact> contactList = [Select Id, name, FirstName, LastName,  AccountId, email, 	Email_Permanent__c, MailingPostalCode, MailingCity, Phone 
                                        FROM contact 
                                        WHERE AccountId = :accountId AND FirstName = :fn AND LastName =:ln limit 1];

                for(Contact cont : contactList ){
                        cId = cont.Id;
                        name = cont.Name;
                }
    
                if(contactList.size() == 0){
            system.debug('FN '+ fn+ ' LN '+ln);

                    Contact newContact = new Contact(FirstName = fn, 
                                                    LastName = ln, 
                                                    Email_Permanent__c = eipcontactEmail, 
                                                    MailingPostalCode = eipAccountPostalCode, 
                                                    MailingCity =  eipAccountBillingCity,
                                                    MailingStreet =  eipAccountBillingStreet,
                                                    MailingState = eipAccountBillingState,
                                                    MailingCountry = eipAccountBillingCountry,
                                                    Phone = eipAccountPhone, 
                                                    AccountId = accountId);
                            system.debug(newContact);
                    insert newContact; // create new Contact if not exist
                    contactId = newContact.Id;
                    contactMsg = eipContactName;//newContact.Id;
                
                // update Account with Contact Principal
               ///////////////// 
               /*     if (contactP == '' || contactP == null) {                        
                        update new Account(Id = accountId, Contact_Principal__c = newContact.name);
                    }*////////////////////
                }
                else {
                    contactId = cId;
                    contactMsg = null;//cId;
                  ////////////////////////
                    /*  if (contactP == '' || contactP == null) {
                        
                        update new Account(Id = accountId, Contact_Principal__c = name);
                    }*///////////////////
                }
            }
    }catch(Exception ex){
        contactMsg = ex.getStackTraceString();
    }
    String Msg = JSON.serialize(contactMsg);        
            
    return JSON.serialize(new CustomResponse(contactId, null, contactMsg)).remove('\\'); //contactMsg; // JSON.serialize(new CustomContactResponse(contactMsg)).remove('\\');
    }
}