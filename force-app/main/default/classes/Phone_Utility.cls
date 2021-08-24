public class Phone_Utility {
    // Regex of characters to be removed from a phone prior to validation
    final public static String SANITIZATION_REGEX_CHARS = '\\+| |\\.|-|\\(|\\)';
    
    // First character to be trim from the left side of a phone number
    final public static String SANITIZATION_LEFT_TRIM_CHAR = '1';
    
    // The validation regex pattern to be applied for phone post-sanitization (10 numeric chars)
    final public static Pattern VALIDATION_PATTERN = Pattern.compile('^[0-9]{10}$');
    
    /**
     * Sanitize phone number by removing separators and other characters and validate the final result format.
     * 
     * https://hcnapm.atlassian.net/browse/SF-396
     */
	public static void sanitizeAndValidateSObjectsPhones(List<SObject> records, Schema.DescribeSObjectResult o) {
        if (TriggerControl.bypassPhoneSanitizationAndValidation) return ;
        
        List<Schema.SObjectField> phoneFields = getObjectPhoneFields(o);
        
        for(SObject record : records) {
            for(Schema.SObjectField phoneField : phoneFields) {
                String fieldName = (String)phoneField.getDescribe().getName();
                System.debug('le phone fieldName est---'+fieldName+ '----.');
                record.put(fieldName, sanitizePhone((String) record.get(fieldName)));
                 System.debug('le phone record est---'+record+ '----.');
                validateFormat(record, fieldName);
            }
        }
    }
    
    /**
     * Validate phone number and add field-level error if needed.
     * 
     * https://hcnapm.atlassian.net/browse/SF-396
     */
    public static void validateFormat(SObject record, String fieldName) {
        String value = (String)record.get(fieldName);
        System.debug('le phone value est---'+value+ '----.');
       // System.debug('le phone value long est---'+value.length()+ '----.');
        // Skip validation if field is blank
        if (String.isBlank(value)) return ;
        
        // You can use the system static method assert to verify the match
        if (!VALIDATION_PATTERN.matcher(value).matches()) record.addError(fieldName, Label.PHONE_VALIDATION_PATTERN_ERROR);
    }
    
    /**
     * Get a list of all the fields of type phone for an SObject
     * 
     * https://hcnapm.atlassian.net/browse/SF-396
     */
    public static List<Schema.SObjectField> getObjectPhoneFields(Schema.DescribeSObjectResult o) {
        List<Schema.SObjectField> phoneFields = new List<Schema.SObjectField>();
        
        Map<String, Schema.SObjectField> fields = o.fields.getMap();
        
        for(Schema.SObjectField field : fields.values()){
            if (String.valueOf(field.getDescribe().getType()) != 'PHONE') continue;
            
            phoneFields.add(field);
        }
        
        return phoneFields;
    }
    
    /**
     * Sanitize phone number by removing separators and other characters.
     * 
     * https://hcnapm.atlassian.net/browse/SF-396
     */
	public static String sanitizePhone(String phone) {
        if (phone != null) {
            // Remove separators
            phone = phone.replaceAll(SANITIZATION_REGEX_CHARS, '');
            
            // Skip the first character if needed
            if (phone.left(1) == SANITIZATION_LEFT_TRIM_CHAR) {
                phone = phone.right(phone.length() - 1);
            }
        }
        System.debug('le phone est---'+phone+ '----.');
		return phone;
    }
}