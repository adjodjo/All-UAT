public class InformationController {
    
    public String InstanceInfo{get;set;}
    
    public InformationController(){}
    
    public String getInstanceName(){
        
        Organization org = [select IsSandbox, InstanceName  from Organization where Id =:UserInfo.getOrganizationId()];
        if(org.IsSandbox == false){
            InstanceInfo = 'PROD';
        }
        else{
            
            String Instance = ParametersUtils.IsProductionOrg();
            
            if(Instance == 'CS125'){
                
                InstanceInfo = 'Sandboxuat';
            }
            else  InstanceInfo = 'Sandboxdev';
            //InstanceInfo = UserInfo.getUserName().substringAfterLast('.');
            
        }
        return  InstanceInfo;
    }

}