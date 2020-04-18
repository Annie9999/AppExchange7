@isTest
public without sharing class LiveChatProfileDetailTest {
    
    @testSetup
    static void testSetup () {
        // User testUser = TestDataFactory.createUser();
        Account mockAccount = new Account(
            // FirstName = 'Test',
            // LastName = 'Class',
            // Mobile__c = '0852154251',
            // Email__c = 'test@ii.co.th',
            // Customer_Type__c = 'I'     
        );
        insert mockAccount;      
        SocialAccount__c mockSocialAcc = new SocialAccount__c(
            Social_ID__c = 'U551bf1d427ed66416a5a7d5b018696nn', 
            Display_Name__c = 'Test', 
            Avatar_URL__c = 'https://test.png', 
            Social_Type__c = 'Line', 
            Phone_Number__c = null, 
            Email__c = null,
            FirstName__c = null, 
            LastName__c =null,
            First_Name_EN__c = null, 
            Last_Name_EN__c = null,
            Line_ID__c = null
        );
        insert mockSocialAcc;      
        ChatSession__c mockChatSession = new ChatSession__c(
            // OwnerId = testUser.Id,
            Social_ID__c = mockSocialAcc.Id,
            Chat_Note__c = 'test'
        );
        insert mockChatSession;  
    }
    
    @isTest
    static void getDetailTest() {
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
    	LiveChatProfileDetail.DetailsData result = LiveChatProfileDetail.getDetail(chatSession.Id);
        LiveChatProfileDetail.DetailsData result1 = LiveChatProfileDetail.getDetail('a1lO0000003TRNDIA4');
   
    }    
    @isTest
    static void updateSocialAccountIfEditDetailOccuredTest() {
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
  		String	FirstName = 'ทดสอบ';
        String  LastName = 'ระบบ';
        String	FirstNameEN = 'Test';
        String  LastNameEN = 'Class';
        String  PhoneNumber = '0852154251';
        String  Email = 'test@ii.co.th';
        String  LineID = 'test';
        LiveChatProfileDetail.response result = LiveChatProfileDetail.updateSocialAccountIfEditDetailOccured(chatSession.Id,FirstName,LastName,FirstNameEN,LastNameEN,PhoneNumber,Email,LineID);
    }

}