trigger Contact_Trigger on Contact (before insert, before update) {
    /**
     * Sanitize phone number by removing separators and other characters.
     * 
     * https://hcnapm.atlassian.net/browse/SF-396
     */
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        Contact_TriggerHandler.sanitizeAndValidatePhone();
    }
}