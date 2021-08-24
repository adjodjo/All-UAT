/**
 * @description       : Test class for NavigationMenuItemsController
 * @author            : lvang@northteq.com
 * @test class        :
 * @code coverage     :
 * @last modified on  : 08-20-2021
 * @last modified by  :
 **/
@isTest
public with sharing class NavigationMenuItemsController_Test {

    /**
     * @description tests response is not returned null
     * @author lvang@northteq.com | 08-20-2021
     **/
    static testMethod void testSetupNavigationItems(){
        String menuItems = '[{"id":0,"label":"Home","active":false},{"id":1,"label":"New quote","active":false},{"id":2,"label":"Quotes","active":false},{"id":3,"label":"Products and services","active":false},{"id":4,"label":"Resources","active":false},{"id":5,"label":"Reports","active":false},{"id":6,"label":"Help and contacts","active":false}]';
        String response;
        Test.startTest();
        response = NavigationMenuItemsController.setupNavigationItems(Label.Portal_Navigation_Name, 'Live', menuItems);
        Test.stopTest();
        System.assertEquals(true, response != null, 'Response should not be null');
        System.assertEquals(false, response.containsIgnoreCase('Error'), 'Response should not contain word error');
    }

    static testMethod void testGetClientLogoUrl()
    {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Portal User'].Id;
        User user;
        User admin = [SELECT Id FROM User WHERE Profile.Name =: 'System Administrator' AND IsActive = true LIMIT 1];
        String response;
        System.runAs (admin)
        {

            Account portalAccount = new Account( Name = 'TestAccount',
                                                 Logo_Url__c = 'test',
                                                 Logo_Alt_Text__c = 'test',
                                                 Logo_Alt_Text_French__c = 'test',
                                                 Logo_Url_French__c = 'test');
            Database.insert(portalAccount);

            Contact contact = new Contact(FirstName = 'Test',
                                          Lastname = 'McTesty',
                                          AccountId = portalAccount.Id,
                                          Email = 'randomtest@test.com');
            Database.insert(contact);

            user = new User(
                Username = 'randomtes@test.com',
                ContactId = contact.Id,
                ProfileId = profileId,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US');
            Database.insert(user);
        }

        test.startTest();
        System.runAs(user)
        {
            response = NavigationMenuItemsController.getClientLogoUrl();
        }
        test.stopTest();
        System.assertEquals(true, response != null, 'Response should not be null');
        user = (User) JSON.deserialize(response, User.class);
        System.assertEquals('test', user.Contact.Account.Logo_Url__c, 'logo should equal test');
        System.assertEquals('test', user.Contact.Account.Logo_Alt_Text__c, 'logo alt text should equal test');
        System.assertEquals('test', user.Contact.Account.Logo_Alt_Text_French__c, 'logo french alt text should equal test');
        System.assertEquals('test', user.Contact.Account.Logo_Url_French__c, 'logo french should equal test');
    }
}