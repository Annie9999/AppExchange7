@isTest
public with sharing class CaseSessionLinkedRecordControllerTest {
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
            // FromChatSession__c = mockChatSession.Id
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
        User testUser = [SELECT Id FROM User WHERE FirstName =: 'Test' AND LastName =: 'Sansiri' LIMIT 1];
        Account acc = [SELECT Id FROM Account LIMIT 1];
        CaseSessionLinkedRecordController.userInfo result = CaseSessionLinkedRecordController.getInitData(testUser.Id, acc.Id);
        CaseSessionLinkedRecordController.userInfo result2 = CaseSessionLinkedRecordController.getInitData('mistake', 'mistake');
        System.assertNotEquals(null, result.owner);
        System.assertNotEquals(null, result.acc);
        System.assertEquals(null, result2.owner);
        System.assertEquals(null, result2.acc);

        Account mockAccount = new Account(
            // FirstName = 'Test',
            // LastName = 'Class',
            // Mobile__c = '+66852154251',
            // Email__c = 'test@ii.co.th'
        );
        insert mockAccount;
        CaseSessionLinkedRecordController.userInfo result3 = CaseSessionLinkedRecordController.getInitData(testUser.Id, mockAccount.Id);
    }

    @isTest
    static void handleDeleteCaseTest() {
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];        
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseObj = [SELECT Id FROM Case WHERE AccountId =: acc.Id LIMIT 1];
        CaseSessionLinkedRecordController.response result = CaseSessionLinkedRecordController.handleDeleteCase(caseObj.Id, chatSession.Id);
        CaseSessionLinkedRecordController.response result2 = CaseSessionLinkedRecordController.handleDeleteCase('mistake', chatSession.Id);
        System.assertEquals(false, result.status);
        System.assertEquals(false, result2.status);
        System.assertEquals('Test Class', result.errorMsg);
        System.assertEquals('Test Class', result2.errorMsg);

        Case mockCase = new Case(
            AccountId = acc.Id,
            Origin = 'Live Chat',
            // Category__c = 'Complaint',
            Priority = 'Medium',
            Status = 'Open',
            // Department__c = 'Call Centre',
            // Media_Info__c = 'Line',
            Description = 'Test CaseSession'
            // Update_Progress__c = 'Test'
        );
        insert mockCase;
        Case_Session_Linkage__c mockCaseLinkage = new Case_Session_Linkage__c(
            Case__c = mockCase.Id,
            ChatSession__c = chatSession.Id
        );
        insert mockCaseLinkage;
        CaseSessionLinkedRecordController.response result3 = CaseSessionLinkedRecordController.handleDeleteCase(mockCase.Id, chatSession.Id);
    }

    @isTest
    static void checkDupCaseBeforeDeleteTest() {
        SocialAccount__c socialAcc = [SELECT Id FROM SocialAccount__c WHERE Social_ID__c =: 'U551bf1d427ed66416a5a7d5b018696nn' LIMIT 1];        
        ChatSession__c chatSession = [SELECT Id FROM ChatSession__c WHERE Social_ID__c =: socialAcc.Id LIMIT 1];
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseObj = [SELECT Id FROM Case WHERE AccountId =: acc.Id LIMIT 1];
        // User testUser = TestDataFactory.createUser();
        ChatSession__c mockChatSession = new ChatSession__c(
            // OwnerId = testUser.Id,
            // Social_ID__c = socialAcc.Id,
            // Chat_Note__c = 'test'
        );
        insert mockChatSession;
        Case_Session_Linkage__c mockCaseLinkage = new Case_Session_Linkage__c(
            Case__c = caseObj.Id,
            ChatSession__c = mockChatSession.Id
        );
        insert mockCaseLinkage;
        CaseSessionLinkedRecordController.dupCaseResponse result = CaseSessionLinkedRecordController.checkDupCaseBeforeDelete(caseObj.Id, chatSession.Id);
        CaseSessionLinkedRecordController.dupCaseResponse result2 = CaseSessionLinkedRecordController.checkDupCaseBeforeDelete('mistake', chatSession.Id);
    }
    
    @isTest
    static void getOldCaseData() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseObj = [SELECT Id FROM Case WHERE AccountId =: acc.Id LIMIT 1];
        CaseSessionLinkedRecordController.oldData result = CaseSessionLinkedRecordController.getOldCaseData(caseObj.Id);
        CaseSessionLinkedRecordController.oldData result2 = CaseSessionLinkedRecordController.getOldCaseData('mistake');
        System.assertNotEquals(null, result.caseObj);
        // System.assertEquals(null, result.projectObj);
        // System.assertEquals(null, result.unitObj);
        System.assertEquals(null, result2.caseObj);
        // System.assertEquals(null, result2.projectObj);
        // System.assertEquals(null, result2.unitObj);

        // Unit__c mockUnit = TestDataFactory.insertUnit();
        // Project__c mockProject = TestDataFactory.insertProject();
        Case mockCase = new Case(
            AccountId = acc.Id,
            Origin = 'Live Chat',
            // Category__c = 'Complaint',
            Priority = 'Medium',
            Status = 'Open',
            // Department__c = 'Call Centre',
            // Media_Info__c = 'Line',
            Description = 'Test CaseSession'
            // Update_Progress__c = 'Test',
            // Project__c = mockProject.Id,
            // Unit__c = mockUnit.Id
        );
        insert mockCase;
        CaseSessionLinkedRecordController.oldData result3 = CaseSessionLinkedRecordController.getOldCaseData(mockCase.Id);
        System.assertNotEquals(null, result3.caseObj);
        // System.assertNotEquals(null, result3.projectObj);
        // System.assertNotEquals(null, result3.unitObj);
    }

    @isTest
    static void updateCase() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case caseObj = [SELECT Id FROM Case WHERE AccountId =: acc.Id LIMIT 1];
        String Origin = 'Live Chat';
        String Category = 'Complaint';
        String Incedent = '--None--';
        String SubCategory = '--None--';
        String Priority = 'High';
        String LawSuit = '--None--';
        String Status = 'Open';
        String Department = 'Call Centre';
        String MediaInfo = 'Line';
        String Description = 'Test Update';
        String UpdateProgress = 'Test';
        CaseSessionLinkedRecordController.response result = CaseSessionLinkedRecordController.updateCase(caseObj.Id, acc.Id, Origin, Category, Incedent, SubCategory,
            Priority, LawSuit, Status, Department, MediaInfo, Description, UpdateProgress, null, null);
        CaseSessionLinkedRecordController.response result2 = CaseSessionLinkedRecordController.updateCase('mistake', acc.Id, Origin, Category, Incedent, SubCategory,
            Priority, LawSuit, Status, Department, MediaInfo, Description, UpdateProgress, null, null);
    }

    @isTest
    static void getsinglePicklistTest() {
        Map<String, List<String>> result = CaseSessionLinkedRecordController.getsinglePicklist('Status');
    }

    @isTest
    static void getDependentMapTest() {
        Case caseObj = new Case();
        Map<String, List<String>> result = CaseSessionLinkedRecordController.getDependentMap(caseObj, 'Category__c', 'Sub_Category__c');
    }

    @isTest
    static void getCustomerInfoTest() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Account result = CaseSessionLinkedRecordController.getCustomerInfo(acc.Id);
        System.assertNotEquals(null, result);
    }

    @isTest
    static void getIndividualTest() {
        RecordType result = CaseSessionLinkedRecordController.getIndividual();
    }
}