@isTest
public without sharing class LiveChatProfileCaseTest {
    
	@testSetup
    static void testSetup () {
        // User testUser = TestDataFactory.createUser();
        Account mockAccount = new Account(
            // FirstName = 'Test',
            // LastName = 'Class',
            // Mobile__c = '0852154251',
            // Email__c = 'test@ii.co.th'
        );
        insert mockAccount;
        SocialAccount__c mockSocialAcc = new SocialAccount__c(
            Social_ID__c = 'U551bf1d427ed66416a5a7d5b018696nn', 
            Display_Name__c = 'Test', 
            Avatar_URL__c = 'https://test.png', 
            Social_Type__c = 'Line', 
            Phone_Number__c = '0852154251', 
            Email__c = 'test@ii.co.th',
            FirstName__c = 'Test', 
            LastName__c = 'Class'
        );
        insert mockSocialAcc;
        ChatSession__c mockChatSession = new ChatSession__c(
            // OwnerId = testUser.Id,
            Social_ID__c = mockSocialAcc.Id,
            Chat_Note__c = 'test'
        );
        insert mockChatSession;
        // Project__c mockProject = TestDataFactory.insertProject();
        // Unit__c mockUnit = TestDataFactory.insertUnit();
        Case mockCase = new Case(
            AccountId = mockAccount.Id,
            Subject = 'SCC.Homecare (แจ้งซ่อม) ของโครงการ สราญสิริ ติวานนท์-แจ้งวัฒนะ 1059-1081',
            // Category__c = 'Homecare (แจ้งซ่อม)',
            // Sub_Category__c = 'การทุจริต',
            Status = 'Responded'
            // Project__c = mockProject.Id,
            // Unit__c = mockUnit.Id
        );
        insert mockCase;
        Case_Session_Linkage__c mockCaseLinkage = new Case_Session_Linkage__c(
            Case__c = mockCase.Id,
            ChatSession__c = mockChatSession.Id
        );
        insert mockCaseLinkage;
    }
    
     @isTest
    static void getCaseTest() {
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
        LiveChatProfileCase.caseLinkData result = LiveChatProfileCase.getCase(chatSession.Id);
        LiveChatProfileCase.caseLinkData result1 = LiveChatProfileCase.getCase('a1lO0000003TRNDIA4');
        System.assertEquals(1, result.size);
        System.assertEquals(0, result1.size);
    }
}