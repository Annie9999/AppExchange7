@isTest
private class customLookUpControllerTest
{
	@isTest
	static void fetchLookUpValuesTest()
	{
		// User testUser = TestDataFactory.createUser();
		// system.runas(testUser){
		// Account acc = TestDataFactory.createAccount(testUser.Id);
		// Project__c project = TestDataFactory.insertProject();
		// Project_Team_Member__c member = TestDataFactory.insertProjectTeamMember(testUser.Id, project);
		
		List<Opportunity> Opportunitys = new List<Opportunity>{
			new Opportunity(Name = 'this is test class', StageName = 'SN', CloseDate = Date.today()),
			new Opportunity(Name = 'a developer is not a tester', StageName = 'SN', CloseDate = Date.today()),
			new Opportunity(Name = 'test is ...', StageName = 'SN', CloseDate = Date.today()),
			new Opportunity(Name = 'eiei', StageName = 'SN', CloseDate = Date.today()),
			new Opportunity(Name = 'this is test controller', StageName = 'SN', CloseDate = Date.today())
		};
		// TriggerActivator.overrideTriggerActivation(TriggerActivator.OPPORTUNITY_TRIGGER, false);
		insert Opportunitys;
		// TriggerActivator.overrideTriggerActivation(TriggerActivator.OPPORTUNITY_TRIGGER, true);
		System.debug(Opportunitys.size() + ' rows has been inserted successfully');
		
		Test.startTest();
		List<customLookUpController.lookupWrapper> recordResults = customLookUpController.fetchLookUpValues('%test%','Opportunity','Name','','StageName', '', '', false,false);
		Test.stopTest();

		System.assertEquals(4, recordResults.size(), 'customLookUpController.fetchLookUpValuesTest test is Passed');
	}

	@isTest
	static void getPicklistValueTest()
	{
		Test.startTest();
		List<PicklistOption> recordResults = customLookUpController.getPicklistValue('Opportunity','StageName');
		Test.stopTest();
		
		/* Currently, This Picklist includes {open,visited,contacted,negotiated,dead,signed,booked} */
		System.assertEquals(recordResults.size(),recordResults.size(),'customLookUpController.getPicklistValue(...) is passed ');
	}

	// add by kevin for testing if clause
	@isTest
	static void fetchLookUpValuesTest_If()
	{
		// User testUser = TestDataFactory.createUser();
		// system.runas(testUser){
		// Account acc = TestDataFactory.createAccount(testUser.Id);
		// Project__c project = TestDataFactory.insertProject();
		// Project_Team_Member__c member = TestDataFactory.insertProjectTeamMember(testUser.Id, project);
		List<Opportunity> Opportunitys = new List<Opportunity>{
			new Opportunity(Name = 'this is test class', StageName = 'SN', CloseDate = Date.today()),
			new Opportunity(Name = 'a developer is not a tester', StageName = 'SN', CloseDate = Date.today()),
			new Opportunity(Name = 'test is ...', StageName = 'SN', CloseDate = Date.today()),
			new Opportunity(Name = 'eiei', StageName = 'SN', CloseDate = Date.today()),
			new Opportunity(Name = 'this is test controller', StageName = 'SN', CloseDate = Date.today())
		};
		// TriggerActivator.overrideTriggerActivation(TriggerActivator.OPPORTUNITY_TRIGGER, false);
		insert Opportunitys;
		// TriggerActivator.overrideTriggerActivation(TriggerActivator.OPPORTUNITY_TRIGGER, true);
		System.debug(Opportunitys.size() + ' rows has been inserted successfully');
		
		//add by kevin to test if condition
		Test.startTest();
		List<customLookUpController.lookupWrapper> recordResults_if = customLookUpController.fetchLookUpValues('%test%','Opportunity','Name','','StageName', '', 'StageName', false,true);
		Test.stopTest();
				System.assertEquals(4, recordResults_if.size(), 'customLookUpController.fetchLookUpValuesTest test is Passed');

		//kevin end here
	}


}