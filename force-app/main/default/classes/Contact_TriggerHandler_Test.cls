@isTest
public class Contact_TriggerHandler_Test {
	@isTest static void testSanitizePhone() {
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(Lastname = 'foo', Phone = '+1 (222). 333-4444'));
        contacts.add(new Contact(Lastname = 'foo'));
        
        insert contacts;
        
        System.assertEquals('2223334444', [Select Id, Phone from Contact Where Id = :contacts[0].Id].Phone);
    }
}