@RestResource(urlMapping='/Case/*')

global with sharing class Case_Creation_WS {
    
   static final String message_3 = 'message_3';
/*
    @HttpGET
    global static CaseCustomResponse getCaseInformations(){
        
        Map<String, Object> resp;
        String CaseInformations =null;
        RestRequest request = RestContext.request;
        // String Hid = request.params.get('Id');
        String case_Id= request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        CaseInformations = getCaseInformations(case_Id);
        
        resp = (Map<String, Object>) JSON.deserializeUntyped(CaseInformations);
        
       //  system.debug('le nom du compte est '+(String)resp.get('caseId')+ ' le telephone est '+AccountPhone+ ' L account Id est '+AccountId);
    
        return new CaseCustomResponse((String)resp.get('CaseId'), (String)resp.get('AccountId'), (String)resp.get('ContractNumber'), (String)resp.get('Account_Phone'), (String)resp.get('Account_Name'), (String)resp.get('Error_Msg'));
    
    }

*/
    
    
    
    @HttpPut
    global static CaseCustomResponse createCase(String eipCase ){  //  SettingsCasesAPI CaseSettingsPUT
        
         
         
        String err_Msg = null, userLanguage = UserInfo.getLanguage();

     //   System.debug('Le contact en provenance de EIP est 1 ='+CaseSettingsPUT.eipContact);
        
        String ExceptionMsg = null, buyoutType='', partialType='', userId, userEmail;
        
        String parentId = null, contactId=null, responseCase, caseNumber = null;
        
        String tel, cp, ville, mail, cPrincipal, cEm, cId, contactResp, obj;
        
        Map<String, Object> response;
        
        //obj = 'Case';


        try{
               SettingsCasesAPI CaseSettingsPut = BUYOUT_Case_Parameters.Parameters_Deserialize(eipCase);
        
            
			system.debug('********** Le compte est ***********1 = '+CaseSettingsPut.eipAccount+' lecontact ');
            
            String CEIP = Manage_EIP_Informations.Manage_Cases_Informations(CaseSettingsPut);
 system.debug(' La liste des CaseSettingsPut '+CaseSettingsPut);
            response = (Map<String, Object>) JSON.deserializeUntyped(CEIP);
            
            system.debug(' La liste des users '+response);

            err_Msg = (String)response.get('Error_Msg');
            cId = (String)response.get('ContactId');
            ExceptionMsg = (String)response.get('description');
            buyoutType = (String)response.get('buyoutType');
            partialType = (String)response.get('partialType');
            userId = (String)response.get('userId');
            userEmail = (String)response.get('userEmail');
           

				system.debug('********** Les information sont ***********1 cId = '+cId+ ' myDesc = '+ExceptionMsg +' buyoutType = '+buyoutType+ ' le err_Msg '+err_Msg);
            
            if(err_Msg == null){
                obj = 'Case';
                
                responseCase = CreateNew_Case_Historic.CreateNewEIPCase(CaseSettingsPut, cId, buyoutType,partialType, ExceptionMsg );  // eipEndOfTermFee // eipOperationType,
				
                response = (Map<String, Object>) JSON.deserializeUntyped(responseCase);
                
                err_Msg = (String)response.get('API_Error_Msg');
            	parentId = (String)response.get('caseId');
            	caseNumber = (String)response.get('caseNumber');
                
                    system.debug('les informations de cases sont : '+parentId+ ', '+ caseNumber+ ', '+ err_Msg );
                
            	if(parentId == null || parentId == ''){ 
                    err_Msg = MessageUtils.ErrorMessage(userLanguage, message_3);
                    
                }
                else{
                    
                    Manage_EIP_User.Get_User(CaseSettingsPUT.eipActiveDirectoryName, parentId, obj);
                }
            }
            else{
                
                parentId = null;
                err_Msg = err_Msg;
                
            }
            
        }catch(Exception ex){
            
            parentId = null;
            err_Msg = ex.getMessage();
            
            System.debug(' err_Msg in catch '+err_Msg);
            
            // return new CustomResponse('', err_Msg);
        }
        
       
        return new CaseCustomResponse(parentId, caseNumber, err_Msg);

    }


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                     GET CASE INFORMATIONS
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    public static String getCaseInformations(String caseId){
        
        String  ContractNumber = null,  AccountName= null, AccountId= null, AccountPhone = null, EquipmentSN = null, Error_Msg = null;
        
        try{
            Case myCase = [SELECT ID, AccountId, Contrat_InfoLease__c From Case where Id = :caseId];
            
            ContractNumber = myCase.Contrat_InfoLease__c;
        
            List<Account> accInfo = [Select Id, Name, Phone from Account Where id = :myCase.AccountId Limit 1];
            
            If(accInfo.Size() > 0){
                        
                AccountPhone = accInfo[0].Phone;
                AccountName = accInfo[0].Name;
                AccountId =accInfo[0].Id;
            
                
                system.debug('le nom du compte est '+AccountName+ ' le telephone est '+AccountPhone+ ' L account Id est '+AccountId);
                
      
        }
        else ContractNumber = null;
        
        } catch(Exception ex){
                
                Error_Msg = ex.getMessage();
                
            } 
            
            return  null; //JSON.serialize(new CaseResponse(caseId, AccountId, ContractNumber, AccountPhone, AccountName, Error_Msg)).remove('\\');
    }
    
    

}



/*

/services/apexrest/Case/

 

{
"CaseSettingsPUT" : {
"eipAccount" : "001c000002DEoHBAA1", 
"eipContact" : "Gaétan Côté",
"eipBuyoutType" : "1", 
"eipOperationType" : "LEASE",
"eipLangue" : "EN",
"eipContractNumber" : "027-458896000025",
"eipCustId" : "C000054563",
"eipDateBuyout" : "2019-08-12",
"eipExceptionMessage" : [
"Description 1",
"Description 2"
],
"eipExpiryDate" :"2019-08-30",
"eipAccountManagerCode" : "00000",
"eipActiveDirectoryName" : "adjodjo"

}
}


*/