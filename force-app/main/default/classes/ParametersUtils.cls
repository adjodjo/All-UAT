public class ParametersUtils {
    
     // OrgWideEmailAddress using on FROM sending email 
    public static List<OrgWideEmailAddress> getOrgWideEmailAddress(String address){
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :address];
        
        return owea;
    }
    
     public static List<OrgWideEmailAddress> getCollectionOrgWideEmailAddress(String address){
         
         String param, param1;
         param = (address.substringAfter('@')).substringBefore('.');
         
         System.debug('LE PARAM OrgWideEmailAddress EST'+ param);
         if(param == 'Clecapital'){
             param1 = 'collections@clecapital.ca';
         }
         else{
             param1 = 'collections@clecapital.ca'; //hitachicapital.ca';
         }
         
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :param1];
          System.debug('LE PARAM owea EST'+ owea);
        return owea;
    }
    
    
    
    public static Boolean callSendEmail(Id ContactId, String email, String ContentV, Id histId, Id tempId, List<String> ccEmailList){
        
        boolean isSend = false;
        String InstanceInfo = IsProductionOrg();
        
        if(InstanceInfo == 'CS66'){
            
            if(((email.substringAfter('@')).containsIgnoreCase('clecapital.ca'))
                   				|| ((email.substringAfter('@')).containsIgnoreCase('hitachicapital.ca'))
                                || ((email.substringAfter('@')).containsIgnoreCase('analystik.ca'))){
                                    
                                    isSend = true;
            
            
        }
            else isSend = false;
        }
        else isSend = true;
       /* 
        if(((email.substringAfter('@')).containsIgnoreCase('clecapital.ca'))
                   				|| ((email.substringAfter('@')).containsIgnoreCase('hitachicapital.ca'))
                                || ((email.substringAfter('@')).containsIgnoreCase('analystik.ca'))){
                                    
                              //    EnvoiEmailUnique.myUniqueEmail(ContactId, email, ContentV, histId, tempId, ccEmailList);
                                isSend = true;
                                
                                }
        */
        return isSend;
    }
    
    
   // GET SAC EMAIL
    
    public static String getSACemail(){
        
        String emailSAC, InstanceInfo;
        Organization org = [select IsSandbox, InstanceName  from Organization where Id =:UserInfo.getOrganizationId()];
        if(org.IsSandbox == false){
            emailSAC = 'service@hitachicapital.ca';
        }
         else{
            
            InstanceInfo = UserInfo.getUserName().substringAfterLast('.');
             
             if(InstanceInfo == 'sandboxuat'){
                 emailSAC = 'service@hitachicapital.ca';
             }
             else emailSAC = 'salesforcesac@clecapital.ca';
            
        }
    return emailSAC;
    }
    
    
    
    
    public static String IsProductionOrg() { // Method to check of environement is Production ORG or not
        String InstanceInfo = null;
        Organization org = [select IsSandbox, InstanceName  from Organization where Id =:UserInfo.getOrganizationId()];
        if(org.IsSandbox == false){
            InstanceInfo = 'PROD';
        }
        else{
            
            InstanceInfo = org.InstanceName; //UserInfo.getUserName().substringAfterLast('.');
            
        }
        return  InstanceInfo;
    }
    
    
     //////////////////////////////////////////////////////////////////////////
    //      Build DMS link used to download Invoice and Buyout Documents 
    //      ////////////////////////////////////////////////////////////////////
    
    
    public static String BuildDMSLink(){
        
        String dmsLink, InstanceInfo = IsProductionOrg(); //UserInfo.getUserName().substringAfterLast('.');
        
        if(InstanceInfo == 'PROD'){
            
            dmsLink = 'http://hcwebservice.hcac1.com:8008/eip/dms/';
            
        }
        else 
            if(InstanceInfo == 'CS66'|| InstanceInfo == 'CS200'){
                
                dmsLink = 'http://hcwebservicedev.hcac1.com:8008/eip/dms/';  //10088
            }
        else
        	//if(InstanceInfo == 'CS69'){
            
                dmsLink = 'http://hcwebservicedev.hcac1.com:10098/eip/dms/'; //10098
           /* }
        else{
            dmsLink = 'SERVER ERROR';
        }*/
		
        return dmsLink;        
    }
    
    
    
    //////////////////////////////////////////////////////////////////////////
    //      Build Salesforce Microservice endPoint root used in Callout services 
    //      ////////////////////////////////////////////////////////////////////
    
    
    public static String BuildSFDCMicroServiceEndPoint(){
        
         String MS_RootEndPonit, InstanceInfo = IsProductionOrg();
        
         if(InstanceInfo == 'PROD'){
            
            MS_RootEndPonit = 'https://webapi.hitachicapital.ca:8008/'; 
            
        }
        else 
            if(InstanceInfo == 'CS44' || InstanceInfo == 'CS200'){
                
                MS_RootEndPonit = 'https://dev-webapi.hitachicapital.ca:8008/';
            }
        else
        //	if(InstanceInfo == 'CS69'){
            
                MS_RootEndPonit = 'https://dev-webapi.hitachicapital.ca:8108/';
         /*   }
        else{
            eipLink = 'SERVER ERROR';
        }*/
		
        return MS_RootEndPonit;        
        
        
    }
    
     //////////////////////////////////////////////////////////////////////////
    //      Build Export Microservice endPoint root used in Callout services 
    //      ////////////////////////////////////////////////////////////////////
    
    
    public static String BuildExportMicroServiceEndPoint(){
        
         String MS_RootEndPonit, InstanceInfo = IsProductionOrg();
        
         if(InstanceInfo == 'PROD'){
            
            MS_RootEndPonit = 'https://webapi.hitachicapital.ca:8008/'; 
            
        }
        else 
            if(InstanceInfo == 'CS44'|| InstanceInfo == 'CS200'){
                
                MS_RootEndPonit = 'https://dev-webapi.hitachicapital.ca:8008/';  //'https://dev-webapi.hitachicapital.ca:10088/'
            }
        else
        //	if(InstanceInfo == 'CS69'){
            
                MS_RootEndPonit = 'https://dev-webapi.hitachicapital.ca:8108/';  //10098
         /*   }
        else{
            eipLink = 'SERVER ERROR';
        }*/
		
        return MS_RootEndPonit;        
        
        
    }
    
    
     //////////////////////////////////////////////////////////////////////////
    //      Build Link to call EIP application 
    //      ////////////////////////////////////////////////////////////////////
    
    
    public static String BuildEIPLink(){
        
         String eipLink, InstanceInfo = IsProductionOrg(); //UserInfo.getUserName().substringAfterLast('.');
        
        if(InstanceInfo == 'PROD'){
            
            eipLink = JSON.serialize(new SettingEIPServer_Organization('http://hcwebservice.hcac1.com:8007/', InstanceInfo)); 
            
        }
        else 
            if(InstanceInfo == 'CS66'|| InstanceInfo == 'CS200'){
                
                eipLink = JSON.serialize(new SettingEIPServer_Organization('http://hcwebservicedev.hcac1.com:8000/', InstanceInfo)); //10080
            }
        else
        //	if(InstanceInfo == 'CS69'){
            
                eipLink = JSON.serialize(new SettingEIPServer_Organization('http://hcwebservicedev.hcac1.com:10090/', InstanceInfo)); //10090
         /*   }
        else{
            eipLink = 'SERVER ERROR';
        }*/
		
        return eipLink;        
        
    }

}