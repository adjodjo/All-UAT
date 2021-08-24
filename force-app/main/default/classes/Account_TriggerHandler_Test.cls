@isTest
public class Account_TriggerHandler_Test {
	@isTest static void testSanitizePhone() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'A - Customer', Phone = '+1 (222). 333-4444'));
        accounts.add(new Account(Name = 'B - Vendor', Phone = '+1 (222). 333-4444', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId()));
        accounts.add(new Account(Name = 'Z - Empty'));
        
        insert accounts;
        
        for(Account a : [Select Id, Name, Phone from Account]) {
            if (a.Name == 'A - Customer') System.assertEquals('2223334444', a.Phone);
            if (a.Name == 'B - Vendor') System.assertEquals('2223334444', a.Phone);
        }
    }
    
	@isTest static void testValidatePhone() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'A - Customer', Phone = '+1 (222). 333-4444 x 1234'));
        accounts.add(new Account(Name = 'B - Vendor', Phone = '+1 (222). 333-4444 x 1234', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId()));
        accounts.add(new Account(Name = 'Z - Empty'));
        
        List<Database.SaveResult> results = Database.insert(accounts, false);
        System.assert(!results[0].isSuccess());
        System.assert(!results[1].isSuccess());
        
        Boolean errorIsThrown = false;
        for(Database.Error e : results[1].getErrors()) {
            if (e.getMessage() == Label.PHONE_VALIDATION_PATTERN_ERROR) errorIsThrown = true;
        }
        System.assert(errorIsThrown);
        
        System.assert(results[2].isSuccess());
    }
    
    @isTest static void testCopyShippingAddressToBillingAddress() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = '0 - Same', Billing_Address_Same_as_Shipping__c = true, ShippingStreet = '111 Union St', ShippingPostalCode = 'h1h2h3', ShippingCountryCode = 'CA', ShippingStateCode = 'QC', ShippingCity = 'FooBarVille'));
        accounts.add(new Account(Name = '1 - Different', ShippingStreet = '111 Union St', ShippingPostalCode = 'h1h2h3', ShippingCountryCode = 'CA', ShippingStateCode = 'QC', ShippingCity = 'FooBarVille'));
        
        insert accounts;
        
        accounts = [Select Id, Name, ShippingStreet, ShippingCity, ShippingPostalCode, ShippingStateCode, ShippingCountryCode, BillingStreet, BillingCity, BillingPostalCode, BillingStateCode, BillingCountryCode from Account ORDER BY Name];
		System.assertEquals(null, accounts[0].BillingStreet); //accounts[0].ShippingStreet
        
		System.assertNotEquals(accounts[1].ShippingStreet, accounts[1].BillingStreet);
        
    }
}