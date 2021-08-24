trigger Account_Trigger on Account (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        String recordTypeName = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(Trigger.new[0].RecordTypeId).getName();
        
        if(recordTypeName == 'Vendor'){
            Account_TriggerHandler.sanitizeAndValidatePhone();
            Account_TriggerHandler.copyShippingAddressToBillingAddress();
        }
        
        if(recordTypeName == 'Customer'){
            Account_TriggerHandler.sanitizeAndValidatePhone();
        }
        
        
    }
}