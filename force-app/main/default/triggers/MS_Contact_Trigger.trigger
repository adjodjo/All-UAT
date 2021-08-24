trigger MS_Contact_Trigger on Contact (After insert, After update) {
    
    
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    Manage_API_Profile__c APIcustomSetting = Manage_API_Profile__c.getOrgDefaults();
    Manage_Vendor_RT__c vendorRT = Manage_Vendor_RT__c.getOrgDefaults();
    List<Account> rtId = [Select  recordTypeId from Account where Id  = :Trigger.new[0].accountId ];
    if(rtId.size() > 0){
    String RT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(rtId[0].RecordTypeId).getName();
        system.debug('***************  Le RT est -------- '+RT);
     If(vendorRT.Enable_RT__c == true && RT == vendorRT.RT_Name__c ){
     if(Trigger.isAfter ){
         if(Trigger.new[0].accountId != null) {        
             If(APIcustomSetting.Enable_Profile__c == true && profileName != APIcustomSetting.Profile_Name__c ){
                  DispatcherAccountCallout_WS.DispatcherAccountCallout(Trigger.new[0].accountId, 'Update');
             }
         }
     }
     }
}
}