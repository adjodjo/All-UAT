@isTest
public class InformationControllerTest {
    
    public static testMethod void testMyController() {
        
        InformationController controller = new InformationController();
        
		controller.getInstanceName();
        
        Organization org = [select IsSandbox, InstanceName  from Organization where Id =:UserInfo.getOrganizationId()];
        
       // System.assertEquals(false, org.IsSandbox);
        
    }


}