@isTest
public class PhoneSanitizer_Batchable_Test {
    public static testMethod void testBatch() {
        // Allow insertion of invalid phone
        TriggerControl.bypassPhoneSanitizationAndValidation = true;
        
        // Create multiple contacts with different phone numbers
        List <Contact> contacts = new List<Contact>();
		contacts.add(new Contact(LastName = 'Foo 1', Phone = '+1 (514) 333-2222')); 
		contacts.add(new Contact(LastName = 'Foo 2', Phone = '514.333.2222'));  
		contacts.add(new Contact(LastName = 'Foo 3', Phone = '5143332222'));   
		contacts.add(new Contact(LastName = 'Foo 4', Phone = '514-333-2222 x 1234'));
        insert contacts;
        
        // Restrict insertion of invalid phone
        TriggerControl.bypassPhoneSanitizationAndValidation = false;
        
        Test.StartTest();
        
        // Execute the phone sanitizer batch
        Database.executeBatch(new PhoneSanitizer_Batchable(Schema.SObjectType.Contact, null, null), 10);
        
        Test.StopTest();
        
        // Make sure that 3 out of the 4 phone numbers where sanitized properly.
        System.AssertEquals(
            3,
            database.countquery('SELECT COUNT()'
                                +' FROM Contact WHERE Phone=\'5143332222\''));  
        
    }
}