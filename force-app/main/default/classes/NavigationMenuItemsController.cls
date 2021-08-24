/**
 * @description       : Controller is used to retrieve navigation data for specified nav items
 * @author            : lvang@northteq.com
 * @test class        : NavigationMenuItemsController_Test
 * @code coverage     : 95%
 * @last modified on  : 08-20-2021
 * @last modified by  :
 **/
global with sharing class NavigationMenuItemsController {

    /**
     * @description Builds out the data we need for the menu navigation, based on the menu item data we retrieved from
     * the aura navigation container as lwc does not support the forceCommunity:navigationMenuBase extension which
     * is needed for menu navigation translations from french to english and vise versa.
     * @author lvang@northteq.com | 08-12-2021
     * @param menuName
     * @param menuItems
     * @param x_menuItems
     * @return String
     **/
    @AuraEnabled
    public static String setupNavigationItems(String menuName, String publishedState, String x_menuItems){
        String networkId = Network.getNetworkId();
        String response = 'Error :';
        try{
            //the menu navigation items retrieve from container aura component
            List<MenuItem> menuItems = (List<MenuItem>) JSON.deserialize(x_menuItems, List<MenuItem>.class);
            List<Map<String, Object> > navigationMenuItems = new List<Map<String, Object> >();
            Map<String, MenuItem> menuItemMap = new Map<String, MenuItem>();

            for(MenuItem item : menuItems)
            {
                menuItemMap.put(item.label, item);
            }

            //retrieve the groupings for the navigation item based on menu label
            for(Portal_Navigation_Settings__mdt nav : [SELECT Grouping__c, MasterLabel, English_Translation__c, French_Translation__c
                                                       FROM Portal_Navigation_Settings__mdt WHERE Type__c =: 'Menu Item'])
            {
                for(String key : menuItemMap.keySet())
                {
                    if(key.equalsIgnoreCase(nav.English_Translation__c) || key.equalsIgnoreCase(nav.French_Translation__c))
                    {
                        menuItemMap.get(key).grouping = nav.Grouping__c;
                        MenuItem mi =  menuItemMap.get(key);
                        menuItemMap.put(nav.English_Translation__c + '-' + nav.French_Translation__c, mi);
                        menuItemMap.remove(key);
                    }
                }
            }

            // find the link set belonging to the navigation menuName and active networkId
            List<NavigationLinkSet> linkSets = Test.isRunningTest() ? [ SELECT Id FROM NavigationLinkSet WHERE DeveloperName = :menuName ] :  [ SELECT Id FROM NavigationLinkSet WHERE DeveloperName = :menuName AND NetworkId = :networkId];
            Id linkSetId = linkSets.get(0).Id;

            for(NavigationMenuItem item : [SELECT Label, Target, Type, DefaultListViewId,  AccessRestriction, ParentId, Position, Status, TargetPrefs
                                           FROM NavigationMenuItem
                                           WHERE NavigationLinkSetId = :linkSetId AND Status =: publishedState ORDER BY Position])
            {
                for(String key :  menuItemMap.keySet())
                {
                    if(key.containsIgnoreCase(item.Label))
                    {
                        menuItemMap.get(key).navMenuItem = item;
                    }
                }
            }

            response = !menuItemMap.isEmpty() ? JSON.serialize(menuItemMap.values()) : null;
        }catch(Exception ex) {
            response += ex.getMessage();
        }

        return response;
    }

    /**
     * @description retrieve client logo info
     * @author lvang@northteq.com | 08-20-2021
     * @return string
     **/
    @AuraEnabled
    public static string getClientLogoUrl(){
        String response;
        List<User> users = [SELECT id, Contact.Account.Logo_Url__c, Contact.Account.Logo_Alt_Text__c,
                            Contact.Account.Logo_Alt_Text_French__c, Contact.Account.Logo_Url_French__c
                            FROM User
                            WHERE Id =: UserInfo.getUserId()
                                       AND ContactId != null
                                       AND Contact.AccountId != null
                                       AND Contact.Account.Logo_Url__c != null
                                       AND Contact.Account.Logo_Alt_Text__c != null
                                       AND Contact.Account.Logo_Alt_Text_French__c != null
                                       AND Contact.Account.Logo_Url_French__c != null ];
        if(!users.isEmpty())
        {
            response = JSON.serialize(users[0]);
        }
        return response;
    }

    public class MenuItem
    {
        public String label;
        public Integer id;
        public Boolean active;
        public String grouping;
        public NavigationMenuItem navMenuItem;
    }
}