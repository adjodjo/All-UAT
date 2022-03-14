public without sharing class productandServicesController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account_Sales_Program__c> fetchSalesProgram(String Account_Id){
        List<Account_Sales_Program__c> accSalesProgram = [SELECT id,Account__c,Sales_Program__c,Sales_Program__r.Name,
                                                          Sales_Program__r.EnglishPortal__c, Sales_Program__r.FrancaisPortail__c, 
                                                          Sales_Program__r.Program_Description__c,Sales_Program__r.Program_Description_FR__c,
                                                          Sales_Program__r.Program_Summary__c, Sales_Program__r.Program_Summary_FR__c,
                                                          Sales_Program__r.KB_Article_Link__c
                                                          FROM Account_Sales_Program__c 
                                                          WHERE Account__c=:Account_Id];
 		return accSalesProgram;
    }
}