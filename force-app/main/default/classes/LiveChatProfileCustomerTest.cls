@isTest
public without sharing class LiveChatProfileCustomerTest {
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
            Phone_Number__c = '0852154251', 
            Email__c = 'test@ii.co.th',
            FirstName__c = 'Test', 
            LastName__c = 'Class'
        );
        insert mockSocialAcc;      
        ChatSession__c mockChatSession = new ChatSession__c(
            // OwnerId = testUser.Id,
            // Social_ID__c = mockSocialAcc.Id,
            // Chat_Note__c = 'test'
        );
        insert mockChatSession;        
        Lead mockLead = new Lead(
            FirstName = 'Test',
            LastName = 'Class'
        );
        insert mockLead;
        Lead_Session_Linkage__c mockLeadLinkage = new Lead_Session_Linkage__c(
            Lead__c = mockLead.Id,
            ChatSession__c = mockChatSession.Id
        );
        insert mockLeadLinkage;
        Case mockCase = new Case(
            AccountId = mockAccount.Id
        );
        insert mockCase;
        Case_Session_Linkage__c mockCaseLinkage = new Case_Session_Linkage__c(
            Case__c = mockCase.Id,
            ChatSession__c = mockChatSession.Id
        );
        insert mockCaseLinkage;
        
        Account mockAccount2 = new Account(
            // FirstName = 'Test2',
            // LastName = 'Class2',
            // Mobile__c = '0852154253',
            // Email__c = 'test2@ii.co.th',
            // Customer_Type__c = 'I',
            // VIP__c = true   
        );
        insert mockAccount2;
        SocialAccount__c mockSocialAcc2 = new SocialAccount__c(
            Social_ID__c = 'U551bf1d427ed66416a5a7d5b018696nj', 
            Display_Name__c = 'Test', 
            Avatar_URL__c = 'https://test.png', 
            Social_Type__c = 'Line', 
            Phone_Number__c = '0852154251', 
            Email__c = 'test2@ii.co.th',
            FirstName__c = 'Test2', 
            LastName__c = 'Class2'
        );
        insert mockSocialAcc2;
        ChatSession__c mockChatSession2 = new ChatSession__c(
            // OwnerId = testUser.Id,
            Social_ID__c = mockSocialAcc2.Id,
            Chat_Note__c = 'test'
        );
        insert mockChatSession2;
        Lead mockLead2 = new Lead(
            FirstName = 'Test',
            LastName = 'Class'
        );
        insert mockLead2;
        Lead_Session_Linkage__c mockLeadLinkage2 = new Lead_Session_Linkage__c(
            Lead__c = mockLead2.Id,
            ChatSession__c = mockChatSession2.Id
        );
        insert mockLeadLinkage2;
        Case mockCase2 = new Case(
            AccountId = mockAccount2.Id
        );
        insert mockCase2;
        Case_Session_Linkage__c mockCaseLinkage2 = new Case_Session_Linkage__c(
            Case__c = mockCase2.Id,
            ChatSession__c = mockChatSession2.Id
        );
        insert mockCaseLinkage2;
    }
    
    @isTest
    static void getNoteTest() {
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
    	LiveChatProfileCustomer.customerLinkData result = LiveChatProfileCustomer.getCustomer(chatSession.Id);
        LiveChatProfileCustomer.customerLinkData result1 = LiveChatProfileCustomer.getCustomer('a1lO0000003TRNDIA4');
        System.assertEquals(1, result.size);
        System.assertEquals(0, result1.size);
    }
    
    @isTest
    static void getNoteVIPTest() {
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nj' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
    	LiveChatProfileCustomer.customerLinkData result = LiveChatProfileCustomer.getCustomer(chatSession.Id);
        LiveChatProfileCustomer.customerLinkData result1 = LiveChatProfileCustomer.getCustomer('a1lO0000003TRNDIA4');
        System.assertEquals(1, result.size);
        System.assertEquals(0, result1.size);
    }
    
    

}