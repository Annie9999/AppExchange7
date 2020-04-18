@isTest
public without sharing class CaseSessionLinkedControllerTest {

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
            // Social_ID__c = mockSocialAcc.Id,
            // Chat_Note__c = 'test'
        );
        insert mockChatSession;
        // Unit__c mockUnit = TestDataFactory.insertUnit();
        Case mockCase = new Case(
            AccountId = mockAccount.Id,
            Origin = 'Live Chat',
            // Category__c = 'Complaint',
            Priority = 'Medium',
            Status = 'Open',
            // Department__c = 'Call Centre',
            // Media_Info__c = 'Line',
            Description = 'Test CaseSession'
            // Update_Progress__c = 'Test',
            // FromChatSession__c = mockChatSession.Id,
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
    static void getInitDataTest() {
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
        CaseSessionLinkedController.caseLinkageInfo result = CaseSessionLinkedController.getInitData(chatSession.Id);
        System.assertEquals(1, result.size);
    }

    @isTest
    static void getInitSearchDataTest() {
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
        CaseSessionLinkedController.getSearchCaseInitResponse result = CaseSessionLinkedController.getInitSearchData(chatSession.Id);
        System.assertEquals(1, result.size);
    }

    @isTest
    static void getSearchDataTest() {
        CaseSessionLinkedController.getSearchCaseInitResponse result = CaseSessionLinkedController.getSearchData('+66');

        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseObj = [SELECT CaseNumber FROM Case WHERE AccountId =: acc.Id LIMIT 1];
        CaseSessionLinkedController.getSearchCaseInitResponse result2 = CaseSessionLinkedController.getSearchData(caseObj.CaseNumber);
        System.assertEquals(1, result2.size);

        Case mockCase = new Case(
            Origin = 'Live Chat',
            // Category__c = 'Complaint',
            Priority = 'Medium',
            Status = 'Open',
            // Department__c = 'Call Centre',
            // Media_Info__c = 'Line',
            Description = 'Test CaseSession2'
            // Update_Progress__c = 'Test'
        );
        insert mockCase;
        Case caseObj2 = [SELECT CaseNumber FROM Case WHERE Id =: mockCase.Id LIMIT 1];
        CaseSessionLinkedController.getSearchCaseInitResponse result3 = CaseSessionLinkedController.getSearchData(caseObj2.CaseNumber);
    }
    
    @isTest
    static void insertCaseLinkageTest() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseObj = [SELECT Id FROM Case WHERE AccountId =: acc.Id LIMIT 1];
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
        CaseSessionLinkedController.response result = CaseSessionLinkedController.insertCaseLinkage(caseObj.Id, chatSession.Id);
    }

    @isTest
    static void deleteCaseLinkageTest() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseObj = [SELECT Id FROM Case WHERE AccountId =: acc.Id LIMIT 1];
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
        CaseSessionLinkedController.response result = CaseSessionLinkedController.deleteCaseLinkage(caseObj.Id, chatSession.Id);
        CaseSessionLinkedController.response result2 = CaseSessionLinkedController.deleteCaseLinkage('mistake', chatSession.Id);
    }

    @isTest
    static void insertNewCase() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
        String Origin = 'Live Chat';
        String Category = 'Complaint';
        String Incedent = '--None--';
        String SubCategory = '--None--';
        String Priority = 'Medium';
        String LawSuit = '--None--';
        String Status = 'Open';
        String Department = 'Call Centre';
        String MediaInfo = 'Line';
        String Description = 'Test CaseSession';
        String UpdateProgress = 'Test';
        String webEmail = 't@tests.com';
        String sansiriCallCenterRemark = 'test';
        String ASCPlusPropertyRemark = 'test';
              
   
        CaseSessionLinkedController.response result = CaseSessionLinkedController.insertNewCase(acc.Id, Origin, Category, Incedent, SubCategory,
            Priority, LawSuit, Status, Department, MediaInfo, Description, UpdateProgress, null, null, chatSession.Id,webEmail,sansiriCallCenterRemark,ASCPlusPropertyRemark,null );
    }

    @isTest
    static void getsinglePicklistTest() {
        Map<String, List<String>> result = CaseSessionLinkedController.getsinglePicklist('Status');
    }

    @isTest
    static void getDependentMapTest() {
        Case caseObj = new Case();
        Map<String, List<String>> result = CaseSessionLinkedController.getDependentMap(caseObj, 'Category__c', 'Sub_Category__c');
    }

    @isTest
    static void getCustomerInfoTest() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Account result = CaseSessionLinkedController.getCustomerInfo(acc.Id);
        System.assertNotEquals(null, result);
    }

    @isTest
    static void getIndividualTest() {
        RecordType result = CaseSessionLinkedController.getIndividual();
    }
    
    // @isTest
    // static void getOwnerTest() {
    //     String result = CaseSessionLinkedController.getOwner();
    // }
}