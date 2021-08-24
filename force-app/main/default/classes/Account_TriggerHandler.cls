public class Account_TriggerHandler {
    // Record Type names that should trigger the phone sanitization and validation business logics
    final public static List<String> PHONE_SANITIZATION_AND_VALIDATION_RECORD_TYPE_NAME = new List<String>{'Vendor', 'Customer'};
        
    /**
     * Sanitize phone number by removing separators and other characters.
     * 
     * https://hcnapm.atlassian.net/browse/SF-396
     */
    public static void sanitizeAndValidatePhone() {
        // Define list of record type concerned by this business logic
        Set<Id> recordTypeIds = new Set<Id>();
        for(String recordTypeName : PHONE_SANITIZATION_AND_VALIDATION_RECORD_TYPE_NAME) {
            recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId());
        }
        
        // Isolate only the list of records concerned by this business logic
        List<Account> targetAccounts = new List<Account>();
        for(Account a : (List<Account>)Trigger.New) {
            if (!recordTypeIds.contains(a.RecordTypeId)) continue;
            
            targetAccounts.add(a);
        }
        if (targetAccounts.size() == 0) return ;
        
        Phone_Utility.sanitizeAndValidateSObjectsPhones(targetAccounts, Schema.SObjectType.Account);
    }
    
    /**
     * Billing Address should be the same as Shipping Address
     * 
     * https://hcnapm.atlassian.net/browse/SF-368
     */
    public static void copyShippingAddressToBillingAddress() {
        for(Account a : (List<Account>)Trigger.New) {
            if (!a.Billing_Address_Same_as_Shipping__c) continue;
            
            a.BillingCity = a.ShippingCity;
            a.BillingCountryCode = a.ShippingCountryCode;
            a.BillingPostalCode = a.ShippingPostalCode;
            a.BillingStateCode = a.ShippingStateCode;
            a.BillingStreet = a.ShippingStreet;
        }
    }
}