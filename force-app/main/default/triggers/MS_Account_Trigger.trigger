trigger MS_Account_Trigger on Account (before update, After insert, after update) { //
    
   // if(system.isFuture()) return;
    system.debug(' --- le compte a metter a jour est ---'+Trigger.new);
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    Boolean isTriggerInsert = false;
    Map<Id, Account> oldMapAccount = new Map<Id, Account>();
    oldMapAccount = Trigger.oldMap;
    Manage_API_Profile__c APIcustomSetting = Manage_API_Profile__c.getOrgDefaults();
    Manage_Vendor_RT__c vendorRT = Manage_Vendor_RT__c.getOrgDefaults();
    
    String MDMID;
    String RT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(Trigger.new[0].RecordTypeId).getName();
            
    If(vendorRT.Enable_RT__c == true && RT == vendorRT.RT_Name__c ){
    
    system.debug(' --- le profile name est ---'+profileName);
    
    System.debug('New Calling dispatcher WS');
    // atfer each new from scratch create account, call Dispatcher to update all the third party application in the system
    if(Trigger.isAfter){
        
        if(Trigger.isInsert ){   
            for(account acc : Trigger.new){
                MDMID = acc.MDM_ID__c;
            }
            If(MDMID == null || MDMID == ''){
                isTriggerInsert = true;
                System.debug('Calling dispatcher INSERT WS');
                DispatcherAccountCallout_WS.DispatcherAccountCallout(Trigger.new[0].Id, 'Insert');
                  System.debug('---Update - Insert Flag--- 00  '+isTriggerInsert);
            }
        } 
        
        if(Trigger.isUpdate ){
            
            System.debug(' le shipping address est --'+Trigger.new[0].ShippingCountry+'--'+Trigger.new[0].ShippingState);
            if(system.isFuture()) return;
            
            Account oldObject;
            if(oldMapAccount != null){
                   oldObject = oldMapAccount.get(Trigger.new[0].Id);
                
            }
            
            system.debug('--old last req action -- '+oldObject.Last_Requested_Action__c);
            system.debug('--new  last req action -- '+Trigger.new[0].Last_Requested_Action__c);
            
            if(oldObject.Last_Requested_Action__c != null){
                System.debug('---Update - Insert Flag--- 1  '+isTriggerInsert);
                If(APIcustomSetting.Enable_Profile__c == true && profileName != APIcustomSetting.Profile_Name__c ){
                     System.debug('---Update - Insert Flag---  '+isTriggerInsert);
                    if(isTriggerInsert == false){
                        System.debug('Calling dispatcher UPDATE WS');
                        DispatcherAccountCallout_WS.DispatcherAccountCallout(Trigger.new[0].Id, 'Update');
                    }
                }
            }
        }
    } 
    }
}