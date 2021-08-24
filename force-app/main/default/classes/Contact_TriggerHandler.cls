public class Contact_TriggerHandler {
    /**
     * Sanitize phone number by removing separators and other characters.
     * 
     * https://hcnapm.atlassian.net/browse/SF-396
     */
    public static void sanitizeAndValidatePhone() {
        Phone_Utility.sanitizeAndValidateSObjectsPhones(Trigger.New, Schema.SObjectType.Contact);
    }
}