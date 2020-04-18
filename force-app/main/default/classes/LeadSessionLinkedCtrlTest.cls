@isTest
private class LeadSessionLinkedCtrlTest {
    @isTest static void getLeadSessionLikedInfomationTest() {
		// Given
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		String uniqueName = orgId + RandomId; 
		// Project__c p = new Project__c();
		// p.Name = 'Test Project ' + RandomId;
		// p.Project_Name_EN__c = p.Name;
		// p.Building_Type__c = '1';
		// p.Segment__c = 'S';
		// p.Project_Code__c = String.valueOf(RandomId);
		// p.Project_External_ID__c  = String.valueOf(RandomId);
		// insert p;

		Lead l = new Lead(
			FirstName = 'Test fname'+uniqueName,
			LastName = 'Test lname'+uniqueName,
			MobilePhone = '0987654321'+uniqueName,
			Email = 'email'+uniqueName+'@email.com',
			LeadSource = 'Website',
			Status = 'Open'
			// Budget__c = '4 - 4.99 ล้านบาท',
			// Project_ID_Text__c = '100'+uniqueName
		);
		insert l;

        SocialAccount__c socialAccount = new SocialAccount__c(
            Social_Type__c = 'Line',
            FirstName__c = 'FirstNameT',
            LastName__c = 'LastNameT',
            Phone_Number__c = '0212121212',
            Email__c = 'test@mail.com'

        );
        insert socialAccount;

        ChatSession__c session = new ChatSession__c(
            Name = 'Test has requested a LiveChat',
            Expired_DateTime__c = System.now().addMinutes(30),
            Social_ID__c = socialAccount.Id
        );
        insert session;

        Lead_Session_Linkage__c lead_session = new Lead_Session_Linkage__c(
            Lead__c = l.Id,
            ChatSession__c = session.Id
        );
        insert lead_session; 
		// Execute
		Test.startTest();
        LeadSessionLinkedCtrl.LeadSessionLikedInfomationRespon result =  LeadSessionLinkedCtrl.getLeadSessionLikedInfomation(session.Id);
		Test.stopTest();
		// Expected
        // System.assertEquals(1, result.leadSessionLinkageData.size());
	}
    @isTest static void getLeadPicklistInfomationTest() {
		// Given
		// Execute
		Test.startTest();
        LeadSessionLinkedCtrl.getLeadPicklistInfomationRespon result =  LeadSessionLinkedCtrl.getLeadPicklistInfomation();
		Test.stopTest();
		// Expected
	}
    @isTest static void getProjectInfomationTest() {
		// Given
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		String uniqueName = orgId + RandomId; 
		// Project__c p = new Project__c();
		// p.Name = 'Test Project ' + RandomId;
		// p.Project_Name_EN__c = p.Name;
		// p.Building_Type__c = '1';
		// p.Segment__c = 'S';
		// p.Project_Code__c = String.valueOf(RandomId);
		// p.Project_External_ID__c  = String.valueOf(RandomId);
		// insert p;
		
        // Execute
		// Test.startTest();
        // LeadSessionLinkedCtrl.ProjectInfomationRespon result =  LeadSessionLinkedCtrl.getProjectInfomation(p.Id);
		// Test.stopTest();
		// Expected
	}
    @isTest static void getSocialIdFromChatSessionTest() {
		// Given
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		String uniqueName = orgId + RandomId; 
		// Project__c p = new Project__c();
		// p.Name = 'Test Project ' + RandomId;
		// p.Project_Name_EN__c = p.Name;
		// p.Building_Type__c = '1';
		// p.Segment__c = 'S';
		// p.Project_Code__c = String.valueOf(RandomId);
		// p.Project_External_ID__c  = String.valueOf(RandomId);
		// insert p;

		Lead l = new Lead(
			FirstName = 'Test fname'+uniqueName,
			LastName = 'Test lname'+uniqueName,
			MobilePhone = '0987654321'+uniqueName,
			Email = 'email'+uniqueName+'@email.com',
			LeadSource = 'Website',
			Status = 'Open'
			// Budget__c = '4 - 4.99 ล้านบาท',
			// Project_ID_Text__c = '100'+uniqueName
		);
		insert l;

        SocialAccount__c socialAccount = new SocialAccount__c(
            Social_Type__c = 'Line',
            FirstName__c = 'FirstNameT',
            LastName__c = 'LastNameT',
            Phone_Number__c = '0212121212',
            Email__c = 'test@mail.com'

        );
        insert socialAccount;

        ChatSession__c session = new ChatSession__c(
            Name = 'Test has requested a LiveChat',
            Expired_DateTime__c = System.now().addMinutes(30),
            Social_ID__c = socialAccount.Id
        );
        insert session;

        Lead_Session_Linkage__c lead_session = new Lead_Session_Linkage__c(
            Lead__c = l.Id,
            ChatSession__c = session.Id
        );
        insert lead_session; 
		
        // Execute
		Test.startTest();
        LeadSessionLinkedCtrl.getSocialIdFromChatSessionRespon result =  LeadSessionLinkedCtrl.getSocialIdFromChatSession(session.Id);
		Test.stopTest();
		// Expected
	}
    @isTest static void getSocialInfoFromSocialIDTest() {
		// Given
        SocialAccount__c socialAccount = new SocialAccount__c(
            Social_Type__c = 'Line',
            FirstName__c = 'FirstNameT',
            LastName__c = 'LastNameT',
            Phone_Number__c = '0212121212',
            Email__c = 'test@mail.com'

        );
        insert socialAccount;

        // Execute
		Test.startTest();
        LeadSessionLinkedCtrl.getSocialInfoFromSocialIDRespon result =  LeadSessionLinkedCtrl.getSocialInfoFromSocialID(socialAccount.Id);
		Test.stopTest();
		// Expected
	}
    @isTest static void getLeadDuplicateRecordDataTest() {
		// Given
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		String uniqueName = orgId + RandomId; 
		// Project__c p = new Project__c();
		// p.Name = 'Test Project ' + RandomId;
		// p.Project_Name_EN__c = p.Name;
		// p.Building_Type__c = '1';
		// p.Segment__c = 'S';
		// p.Project_Code__c = String.valueOf(RandomId);
		// p.Project_External_ID__c  = String.valueOf(RandomId);
		// insert p;

		Lead l = new Lead(
			FirstName = 'FirstNameT',
			LastName = 'LastNameT',
			MobilePhone = '0212121212',
			Email = 'test@mail.com',
			LeadSource = 'Website',
			Status = 'Open'
			// Budget__c = '4 - 4.99 ล้านบาท',
			// Project_ID_Text__c = '100'+uniqueName
		);
		insert l;

        SocialAccount__c socialAccount = new SocialAccount__c(
            Social_Type__c = 'Line',
            FirstName__c = 'FirstNameT',
            LastName__c = 'LastNameT',
            Phone_Number__c = '0212121212',
            Email__c = 'test@mail.com'

        );
        insert socialAccount;
        
        SocialAccount__c socialAccount2 = new SocialAccount__c(
            Social_Type__c = 'Line',
            FirstName__c = 'FirstNameT',
            LastName__c = 'LastNameT',
            Phone_Number__c = '+66212121212',
            Email__c = 'test@mail.com'

        );
        insert socialAccount2;

        SocialAccount__c socialAccount3 = new SocialAccount__c(
            Social_Type__c = 'Line',
            FirstName__c = 'FirstNameTT',
            LastName__c = 'LastNameTT',
            Email__c = 'test@Tmail.com'

        );
        insert socialAccount3;
        // Execute
		Test.startTest();
        LeadSessionLinkedCtrl.LeadRecordDataResponse result =  LeadSessionLinkedCtrl.getLeadDuplicateRecordData(socialAccount.Id);
        LeadSessionLinkedCtrl.LeadRecordDataResponse result2 =  LeadSessionLinkedCtrl.getLeadDuplicateRecordData(null);
        LeadSessionLinkedCtrl.LeadRecordDataResponse result3 =  LeadSessionLinkedCtrl.getLeadDuplicateRecordData(socialAccount2.Id);
        LeadSessionLinkedCtrl.LeadRecordDataResponse result4 =  LeadSessionLinkedCtrl.getLeadDuplicateRecordData(socialAccount3.Id);
		Test.stopTest();
		// Expected
	}
    @isTest static void searchedByLeadKeyTest() {
		// Given
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		String uniqueName = orgId + RandomId; 
		// Project__c p = new Project__c();
		// p.Name = 'Test Project ' + RandomId;
		// p.Project_Name_EN__c = p.Name;
		// p.Building_Type__c = '1';
		// p.Segment__c = 'S';
		// p.Project_Code__c = String.valueOf(RandomId);
		// p.Project_External_ID__c  = String.valueOf(RandomId);
		// insert p;

		Lead l = new Lead(
			FirstName = 'FirstNameT',
			LastName = 'LastNameT',
			MobilePhone = '0212121212',
			Email = 'test@mail.com',
			LeadSource = 'Website',
			Status = 'Open'
			// Budget__c = '4 - 4.99 ล้านบาท',
			// Project_ID_Text__c = '100'+uniqueName
		);
		insert l;

        // Execute
		Test.startTest();
        LeadSessionLinkedCtrl.LeadRecordDataResponse result =  LeadSessionLinkedCtrl.searchedByLeadKey('FirstNameT');
		LeadSessionLinkedCtrl.LeadRecordDataResponse result2 =  LeadSessionLinkedCtrl.searchedByLeadKey('+6621212');
        LeadSessionLinkedCtrl.LeadRecordDataResponse result3 =  LeadSessionLinkedCtrl.searchedByLeadKey('02121212');
        LeadSessionLinkedCtrl.LeadRecordDataResponse result4 =  LeadSessionLinkedCtrl.searchedByLeadKey('FirstNameTTT');
        Test.stopTest();
		// Expected
	}

	// @isTest static void updatedLeadTest() {
	// 	// Given
    //     Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
    //     String orgId = UserInfo.getOrganizationId(); 
	// 	String uniqueName = orgId + RandomId; 

	// 	Lead l = new Lead(
	// 		FirstName = 'Test fname'+uniqueName,
	// 		LastName = 'Test lname'+uniqueName,
	// 		MobilePhone = '0987654321'+uniqueName,
	// 		Email = 'email'+uniqueName+'@email.com',
	// 		LeadSource = 'Website',
	// 		Status = 'Open',
	// 		Budget__c = '4 - 4.99 ล้านบาท',
	// 		Project_ID_Text__c = '100'+uniqueName
	// 	);
	// 	insert l;

	// 	l.Email = 'email_2'+uniqueName+'@email.com';
		
    //     // Execute
	// 	Test.startTest();
    //     LeadSessionLinkedCtrl.CustomResponse result =  LeadSessionLinkedCtrl.updatedLead(l);
	// 	Test.stopTest();
	// 	// Expected
	// }

	@isTest static void addedLeadToLeadSessionLinkageTest() {
		// Given
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String orgId = UserInfo.getOrganizationId(); 
		String uniqueName = orgId + RandomId; 

		Lead l = new Lead(
			FirstName = 'Test fname'+uniqueName,
			LastName = 'Test lname'+uniqueName,
			MobilePhone = '0987654321'+uniqueName,
			Email = 'email'+uniqueName+'@email.com',
			LeadSource = 'Website',
			Status = 'Open'
			// Budget__c = '4 - 4.99 ล้านบาท',
			// Project_ID_Text__c = '100'+uniqueName
		);
		insert l;

		SocialAccount__c socialAccount = new SocialAccount__c(
            Social_Type__c = 'Line',
            FirstName__c = 'FirstNameT',
            LastName__c = 'LastNameT',
            Phone_Number__c = '0212121212',
            Email__c = 'test@mail.com'

        );
        insert socialAccount;

        ChatSession__c session = new ChatSession__c(
            Name = 'Test has requested a LiveChat',
            Expired_DateTime__c = System.now().addMinutes(30),
            Social_ID__c = socialAccount.Id
        );
        insert session;
		
        // Execute
		Test.startTest();
        LeadSessionLinkedCtrl.CustomResponse result =  LeadSessionLinkedCtrl.addedLeadToLeadSessionLinkage(l.Id, session.Id);
		Test.stopTest();
		// Expected
	}

	@isTest static void removedLeadToLeadSessionLinkageTest() {
		// Given
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String orgId = UserInfo.getOrganizationId(); 
		String uniqueName = orgId + RandomId; 

		Lead l = new Lead(
			FirstName = 'Test fname'+uniqueName,
			LastName = 'Test lname'+uniqueName,
			MobilePhone = '0987654321'+uniqueName,
			Email = 'email'+uniqueName+'@email.com',
			LeadSource = 'Website',
			Status = 'Open'
			// Budget__c = '4 - 4.99 ล้านบาท',
			// Project_ID_Text__c = '100'+uniqueName
		);
		insert l;

		SocialAccount__c socialAccount = new SocialAccount__c(
            Social_Type__c = 'Line',
            FirstName__c = 'FirstNameT',
            LastName__c = 'LastNameT',
            Phone_Number__c = '0212121212',
            Email__c = 'test@mail.com'

        );
        insert socialAccount;

        ChatSession__c session = new ChatSession__c(
            Name = 'Test has requested a LiveChat',
            Expired_DateTime__c = System.now().addMinutes(30),
            Social_ID__c = socialAccount.Id
        );
        insert session;
		
		Lead_Session_Linkage__c lead_session = new Lead_Session_Linkage__c(
            Lead__c = l.Id,
            ChatSession__c = session.Id
        );
        insert lead_session; 

        // Execute
		Test.startTest();
        LeadSessionLinkedCtrl.CustomResponse result =  LeadSessionLinkedCtrl.removedLeadToLeadSessionLinkage(l.Id, session.Id);
		Test.stopTest();
		// Expected
	}

	// @isTest static void deletedLeadTest() {
	// 	// Given
    //     Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
    //     String orgId = UserInfo.getOrganizationId(); 
	// 	String uniqueName = orgId + RandomId; 

	// 	SocialAccount__c socialAccount = new SocialAccount__c(
    //         Social_Type__c = 'Line',
    //         FirstName__c = 'FirstNameT',
    //         LastName__c = 'LastNameT',
    //         Phone_Number__c = '0212121212',
    //         Email__c = 'test@mail.com'

    //     );
    //     insert socialAccount;

    //     ChatSession__c session = new ChatSession__c(
    //         Name = 'Test has requested a LiveChat',
    //         Expired_DateTime__c = System.now().addMinutes(30),
    //         Social_ID__c = socialAccount.Id
    //     );
    //     insert session;

	// 	Lead l = new Lead(
	// 		FirstName = 'Test fname'+uniqueName,
	// 		LastName = 'Test lname'+uniqueName,
	// 		MobilePhone = '0987654321'+uniqueName,
	// 		Email = 'email'+uniqueName+'@email.com',
	// 		LeadSource = 'Website',
	// 		Status = 'Open',
	// 		Budget__c = '4 - 4.99 ล้านบาท',
	// 		Project_ID_Text__c = '100'+uniqueName,
	// 		FromChatSession__c = session.Id
	// 	);
	// 	insert l;
		
	// 	Lead_Session_Linkage__c lead_session = new Lead_Session_Linkage__c(
    //         Lead__c = l.Id,
    //         ChatSession__c = session.Id
    //     );
    //     insert lead_session; 
		
    //     // Execute
	// 	Test.startTest();
    //     LeadSessionLinkedCtrl.CustomResponse result =  LeadSessionLinkedCtrl.deletedLead(l.Id, session.Id);
	// 	Test.stopTest();
	// 	// Expected
	// }

	// @isTest static void foundLeadSessionLinkageBeforeDeleteLeadTest() {
	// 	// Given
    //     Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
    //     String orgId = UserInfo.getOrganizationId(); 
	// 	String uniqueName = orgId + RandomId; 

	// 	SocialAccount__c socialAccount = new SocialAccount__c(
    //         Social_Type__c = 'Line',
    //         FirstName__c = 'FirstNameT',
    //         LastName__c = 'LastNameT',
    //         Phone_Number__c = '0212121212',
    //         Email__c = 'test@mail.com'

    //     );
    //     insert socialAccount;

 	// 	ChatSession__c session = new ChatSession__c(
    //         Name = 'Test has requested a LiveChat',
    //         Expired_DateTime__c = System.now().addMinutes(30),
    //         Social_ID__c = socialAccount.Id
    //     );
    //     insert session;

	// 	Lead l = new Lead(
	// 		FirstName = 'Test fname'+uniqueName,
	// 		LastName = 'Test lname'+uniqueName,
	// 		MobilePhone = '0987654321'+uniqueName,
	// 		Email = 'email'+uniqueName+'@email.com',
	// 		LeadSource = 'Website',
	// 		Status = 'Open',
	// 		Budget__c = '4 - 4.99 ล้านบาท',
	// 		Project_ID_Text__c = '100'+uniqueName,
	// 		FromChatSession__c = session.Id
	// 	);
	// 	insert l;
		
	// 	Lead_Session_Linkage__c lead_session = new Lead_Session_Linkage__c(
    //         Lead__c = l.Id,
    //         ChatSession__c = session.Id
    //     );
    //     insert lead_session; 
		
    //     // Execute
	// 	Test.startTest();
    //     LeadSessionLinkedCtrl.foundLeadSessionLinkageResponse result =  LeadSessionLinkedCtrl.foundLeadSessionLinkageBeforeDeleteLead(l.Id, session.Id);
	// 	Test.stopTest();
	// 	// Expected
	// }

	@isTest static void insertedLeadTest() {
		// Given
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String orgId = UserInfo.getOrganizationId(); 
		String uniqueName = orgId + RandomId; 

		SocialAccount__c socialAccount = new SocialAccount__c(
            Social_Type__c = 'Line',
            FirstName__c = 'FirstNameT',
            LastName__c = 'LastNameT',
            Phone_Number__c = '0212121212',
            Email__c = 'test@mail.com'

        );
        insert socialAccount;

 		ChatSession__c session = new ChatSession__c(
            Name = 'Test has requested a LiveChat',
            Expired_DateTime__c = System.now().addMinutes(30),
            Social_ID__c = socialAccount.Id
        );
        insert session;

		Lead l = new Lead(
			FirstName = 'Test fname'+uniqueName,
			LastName = 'Test lname'+uniqueName,
			MobilePhone = '0987654321'+uniqueName,
			Email = 'email'+uniqueName+'@email.com',
			LeadSource = 'Website',
			Status = 'Open'
			// Budget__c = '4 - 4.99 ล้านบาท',
			// Project_ID_Text__c = '100'+uniqueName
		);
		
        // Execute
		Test.startTest();
        LeadSessionLinkedCtrl.CustomResponse result =  LeadSessionLinkedCtrl.insertedLead(l, session.Id);
		Test.stopTest();
		// Expected
	}
}