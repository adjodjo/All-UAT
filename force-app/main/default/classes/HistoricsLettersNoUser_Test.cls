@isTest(SeeAllData=true)

public class HistoricsLettersNoUser_Test {
    
    
    @isTest
  
    static void HistoricsLettersNoUserTest(){
        
        User myUser = TestUtils.userTestRecord();
        System.debug('le user '+myUser);
        
        Account myAccount = TestUtils.accountTestRecord_Email();
        Account myAccount1 = TestUtils.accountTestRecord_NO_Email();
        
        Retard_SettingHistoricLetter R_HistoricSetting = TestUtils.TestRetardRecord('Retard1', myAccount.Id, 'tUser' );
        Retard_SettingHistoricLetter R_HistoricSetting1 = TestUtils.TestRetardRecord('test', myAccount.Id, 'tUser');
        
        Welcome_SettingHistoricLetter W_HistoricSetting = TestUtils.TestWelcomeRecord('Welcome', myAccount.Id, 'tUser');
        Welcome_SettingHistoricLetter W_HistoricSetting1 = TestUtils.TestWelcomeRecord('test', myAccount.Id, null);
        
        Other_SettingHistoricLetter O_HistoricSetting = TestUtils.TestOtherRecord('Other', myAccount.Id, 'tUser');
        Other_SettingHistoricLetter O_HistoricSetting1 = TestUtils.TestOtherRecord('test', myAccount.Id, 'tUser');
        
        AVISTERM_SettingHistoricLetter A_HistoricSetting = TestUtils.TestAvistermRecord('AVISTERM', myAccount.Id, null);
        AVISTERM_SettingHistoricLetter A_HistoricSetting1 = TestUtils.TestAvistermRecord('test', myAccount.Id, 'tUser');
        
       
        
        Test.StartTest();
        
        Retard_HistoryCustomResponse retard = Retard_Historic_Letter_Creation_WS.createHistoriqueLetterRetard(R_HistoricSetting);
        Retard_HistoryCustomResponse retard1 = Retard_Historic_Letter_Creation_WS.createHistoriqueLetterRetard(R_HistoricSetting1);
        
        Welcome_HistoryCustomResponse welcome = Welcome_Historic_Letter_Creation_WS.createHistoriqueLetterWelcome(W_HistoricSetting);
        Welcome_HistoryCustomResponse welcome1 = Welcome_Historic_Letter_Creation_WS.createHistoriqueLetterWelcome(W_HistoricSetting1);
        
        Other_HistoryCustomResponse other = Other_Historic_Letter_Creation_WS.createHistoriqueLetterOther(O_HistoricSetting);
        Other_HistoryCustomResponse other1 = Other_Historic_Letter_Creation_WS.createHistoriqueLetterOther(O_HistoricSetting1);
        
        AVISTERM_HistoryCustomResponse avisterm = AVISTERM_Historic_Letter_Creation_WS.createHistoriqueLetterAvisterm(A_HistoricSetting);
        AVISTERM_HistoryCustomResponse svisterm1 = AVISTERM_Historic_Letter_Creation_WS.createHistoriqueLetterAvisterm(A_HistoricSetting1);
        
        
        String phist = other.ParentHistoryId;
        String fhist = other.OtherHistoryId;
        
        String phist1 = retard.ParentHistoryId;
        String fhist1 = retard.RetardHistoryId;
        
       String S_Historic = TestUtils.BuildsendParam(phist, fhist, myAccount.Id, 'FR', 'test@test.com', '', 'Letters', 'cle0@clecapital.ca');
         String S_Doc = TestUtils.BuildsendDoc();
        String S_Historic1 = TestUtils.BuildsendParam(phist, fhist, myAccount1.Id, 'EN', 'test@test.com',  'tUser', 'Letters', 'hit1@hitachicapital.ca');
        String S_Doc1 = TestUtils.BuildsendDoc();
         
        SendCustomResponse sendH = SendHistoric_WS.SendHistoric(S_Historic1, S_Doc1);
           
   
        Test.StopTest();
        
    }

}