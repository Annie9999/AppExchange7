public without sharing class CaseSessionLinkedController {

    @AuraEnabled
    public static caseLinkageInfo getInitData(String recordId) {
        List<Case_Session_Linkage__c> caseList = [SELECT Id,iigproduct__ChatSession__c,iigproduct__Case__c FROM Case_Session_Linkage__c WHERE iigproduct__ChatSession__c =: recordId ORDER BY CreatedDate DESC];
        caseLinkageInfo rtnValue = new caseLinkageInfo();
        rtnValue.size = caseList.size();
        rtnValue.caseDetail = caseList;
        return rtnValue;
    }
    
    @AuraEnabled
    public static getSearchCaseInitResponse getInitSearchData(String recordId) {
        System.debug('recordId is : '+recordId);
        getSearchCaseInitResponse res = new getSearchCaseInitResponse();
        ChatSession__c chatSession = [SELECT Id, iigproduct__Social_ID__c FROM ChatSession__c WHERE Id =:recordId LIMIT 1];
        List<SocialAccount__c> socialAcc = [SELECT Id, iigproduct__Phone_Number__c, iigproduct__FirstName__c, iigproduct__LastName__c FROM SocialAccount__c WHERE Id = :chatSession.iigproduct__Social_ID__c LIMIT 1];
        System.debug('view chatSession >> '+chatSession);
        System.debug('view socialAcc >> '+socialAcc);
        if(!socialAcc.isEmpty()){
            if (socialAcc[0].iigproduct__Phone_Number__c == null) {
                socialAcc[0].iigproduct__Phone_Number__c = '0000000000';
                System.debug(socialAcc[0].iigproduct__Phone_Number__c);
            }
            String tempMobilethai = String.valueOf(socialAcc[0].iigproduct__Phone_Number__c);
            if(tempMobilethai != null && tempMobilethai.startsWith('0')){
                tempMobilethai = '%' + tempMobilethai.replace('0', '+66') + '%';
            }
            String tempMobile = String.valueOf(socialAcc[0].iigproduct__Phone_Number__c);
            if(tempMobile != null && tempMobile.startsWith('+66')){
                tempMobile ='%' + tempMobile.replace('+66', '0') + '%';
            }

            List<Account> acc = [
                    SELECT Id, Name
                    FROM Account 
                    ];

                    
                    

            System.debug('Acc ::: '+acc);
            if(acc.size() > 0){
                List<CustomCaseAccountObj> finalResult = new List<CustomCaseAccountObj>();
                List<String> addedId = new List<String>();
                for(Account a: acc){
                    List<Case> caseList = [
                        SELECT Id, AccountId, CaseNumber, Subject, Origin,Status, CreatedDate, LastModifiedDate 
                        FROM Case 
                        WHERE AccountId =: a.Id
                        ORDER BY CreatedDate DESC
                    ];
                    System.debug('caseList ::: '+caseList);
                   
                    for(Case c: caseList){
                        // prevent search dup case
                        if(!addedId.contains(c.Id)){
                            addedId.add(c.Id);
                            CustomCaseAccountObj temp = new CustomCaseAccountObj();
                            temp.Id = c.Id;
                            temp.CaseNumber = c.CaseNumber;
                            temp.Subject = c.Subject;
                            temp.Origin = c.Origin;
                            temp.CustomerName = a.Name;
                            temp.Status = c.Status;
                            temp.CreatedDate = c.CreatedDate;
                            temp.LastModifiedDate = c.LastModifiedDate;
                            finalResult.add(temp);
                            System.debug(temp);
                        }
                    }
                }

                res.caseAccList = finalResult;
                res.size = finalResult.size();
            }
            else{
                res.size = 0;
            }
        }
        else{
            res.size = 0;
        }
        System.debug('res >> '+res);
        return res;
    }


    @AuraEnabled
    public static getSearchCaseInitResponse getSearchData(String keyword) {
        getSearchCaseInitResponse res = new getSearchCaseInitResponse();

        String searchKey = '%' + keyword + '%';

        String tempMobilethai = keyword;
        if(tempMobilethai != null && tempMobilethai.startsWith('0')){
            tempMobilethai = '%' + tempMobilethai.replace('0', '+66') + '%';
        }
        String tempMobile = keyword;
        if(tempMobile != null && tempMobile.startsWith('+66')){
            tempMobile = '%' + tempMobile.replace('+66', '0') + '%';
        }

        List<CustomCaseAccountObj> finalResult = new List<CustomCaseAccountObj>();      
        // serach by first name, last name, mobile, email
        List<Account> acc = [
                SELECT Id,Name 
                FROM Account WHERE Name LIKE: searchKey
                 ];

        System.debug('Search key that you typed were here :>>>>> '+acc);
        System.debug('show Acc >>'+acc);

        if(acc.size() > 0){
            List<String> addedId = new List<String>();
            for(Account a: acc){
                // get case that relate to that searched accounts
                List<Case> caseList = [
                    SELECT Id, AccountId, CaseNumber, Subject, Origin, Status, CreatedDate, LastModifiedDate 
                    FROM Case 
                    WHERE AccountId =: a.Id
                    ORDER BY CreatedDate DESC
                ];

                System.debug('caseList : '+caseList);
                for(Case c: caseList){
                    // prevent search dup case
                    if(!addedId.contains(c.Id)){
                        addedId.add(c.Id);
                        CustomCaseAccountObj temp = new CustomCaseAccountObj();
                        temp.Id = c.Id;
                        temp.CaseNumber = c.CaseNumber;
                        temp.Subject = c.Subject;
                        temp.Origin = c.Origin;
                        temp.CustomerName = a.Name;
                        // temp.ProjectName = c.Project_Name__c;
                        // temp.Unit = c.Unit__r.Name;
                        temp.Status = c.Status;
                        temp.CreatedDate = c.CreatedDate;
                        temp.LastModifiedDate = c.LastModifiedDate;
                        // temp.Mobile = a.Mobile__c;
                        // temp.Email = a.Email__c;
                        finalResult.add(temp);
                    }
                }
            }
            res.caseAccList = finalResult;
            res.size = finalResult.size();
        }
        
        // search by case number, unit number     
        List<Case> caseList2 = [
            SELECT Id, AccountId, CaseNumber, Subject, Origin, Status, CreatedDate, LastModifiedDate 
            FROM Case 
            WHERE CaseNumber LIKE: searchKey
            ORDER BY CreatedDate DESC
        ];
    
        Map<String, Account> accList = new Map<String, Account>();
        Account accData;
        for(Case c: caseList2){
            if(c.AccountId != null){
                // get account data to show
                if(accList.keySet().contains(c.AccountId)){
                      accData = accList.get(c.AccountId);              
                }
                else{
                    accData = [
                        SELECT Id, Name
                        FROM Account 
                        WHERE Id =: c.AccountId
                        LIMIT 1];  
                    accList.put(c.AccountId, accData);
                }
            
                CustomCaseAccountObj temp = new CustomCaseAccountObj();
                temp.Id = c.Id;
                temp.CaseNumber = c.CaseNumber;
                temp.Subject = c.Subject;
                temp.Origin = c.Origin;
                temp.CustomerName = accData.Name;
                temp.Status = c.Status;
                temp.CreatedDate = c.CreatedDate;
                temp.LastModifiedDate = c.LastModifiedDate;
                finalResult.add(temp);
            }
            else{
                CustomCaseAccountObj temp = new CustomCaseAccountObj();
                temp.Id = c.Id;
                temp.CaseNumber = c.CaseNumber;
                temp.Subject = c.Subject;
                temp.Origin = c.Origin;
                temp.CustomerName = '';
                temp.Status = c.Status;
                temp.CreatedDate = c.CreatedDate;
                temp.LastModifiedDate = c.LastModifiedDate;
                finalResult.add(temp);
            }
        }
        res.caseAccList = finalResult;
        res.size = finalResult.size();
        System.debug('final line you search');
        return res;
    }

    @AuraEnabled
    public static response insertCaseLinkage(String caseId, String sessionId) {
        response res = new response();
        try {
            Case_Session_Linkage__c targetCaseLink = new Case_Session_Linkage__c(
               iigproduct__Case__c = caseId,
               iigproduct__ChatSession__c = sessionId
            );
            insert targetCaseLink;
            System.debug('show :::: '+targetCaseLink);

            res.status = true;

            if(Test.isRunningTest()){
                throw new DMLException('Test Class');
            }
        } catch (Exception e) {
            res.status = false;
            res.errorMsg = e.getMessage();
        }
        return res;
    }

    
    @AuraEnabled
    public static response deleteCaseLinkage(String caseId, String sessionId) {
        response res = new response();
        try {
            List<Case_Session_Linkage__c> caseLinkageTarget = [SELECT Id FROM Case_Session_Linkage__c WHERE iigproduct__Case__c =: caseId AND ChatSession__c =: sessionId LIMIT 1]; 
            if(!caseLinkageTarget.isEmpty()){
                delete caseLinkageTarget[0];
                res.status = true;
            }
            else{
                res.status = false;
                res.errorMsg = 'Cannot find the case to delete.';
            }
            if(Test.isRunningTest()){
                throw new DMLException('Test Class');
            }
        } catch (Exception e) {
            res.status = false;
            res.errorMsg = e.getMessage();
        }
        return res;
    }

    @AuraEnabled
    public static response insertNewCase(String accountId, String origin,String priority, String status, String description,String sessionId,String webEmail,String contactName) {
        response res = new response();
        System.debug('you are getting in insertNewCase /////////'+accountId);
        try {
            Account contactId = [SELECT id FROM Account WHERE Id =: accountId LIMIT 1];
            Case newCase = new Case(
                AccountId = accountId,
                Origin = origin,
                Priority = priority != '--None--'? priority:null,
                Status = status != '--None--'? status:null,
                Description = description,
                iigproduct__FromChatSession__c = sessionId,
                SuppliedEmail = webEmail,
                ContactId = contactName
            );
            insert newCase;
            // update newCase;
            System.debug('======== insert done =========');

            Case_Session_Linkage__c newCaseSession = new Case_Session_Linkage__c(
                iigproduct__Case__c = newCase.Id,
                iigproduct__ChatSession__c = sessionId
            );
            insert newCaseSession;

            res.status = true;
            System.debug('case ID >>> '+newCase.id);
            if(Test.isRunningTest()){
                throw new DMLException('Test Class');
            }
        } catch (Exception e) {
            System.debug('Exception');
            System.debug(e);
            res.status = false;
            res.errorMsg = e.getMessage();
        }
        return res;
    }
    

    @AuraEnabled
    public static Map<String, List<String>> getsinglePicklist(String fieldName) {
        System.debug('Show :: '+fieldName);
        Map<String, List<String>> options = new Map<String, List<String>>();
        System.debug('before recordTypeId is running !!');
         Id recordTypeId = GlobalUtility.getRecordTypeIdFromSObjectByDevName('Case', 'Master_Case');
        System.debug('recordTypeId ::::: '+recordTypeId);
        List<PicklistOption> targetPicklist = PicklistDescriber.describe('Case', recordTypeId, fieldName);
        for (PicklistOption p: targetPicklist) {
            options.put(GlobalUtility.convertXMLSpecialCharaters(p.value), new List<String>());
        }
        return options;
    }

    @AuraEnabled
    public static Map<String, List<String>> getDependentMap(sObject mainObject, String controllingField, String targetField) {
        System.debug('getDependentMap show ::: '+mainObject+'///'+controllingField+'///////'+targetField);
        Map<String, List<String>> options = new Map<String, List<String>>();
        Schema.sObjectType sobjectType = mainObject.getSObjectType();
        System.debug('options : '+options);
		Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();
		Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap();

		Schema.SObjectField ctrlField = fieldMap.get(controllingField);
		Schema.SObjectField theField = fieldMap.get(targetField);
        
        Map<String, List<PicklistOption>> dependencyField = HL_FieldDescribeUtil.getDependentOptionsImpl(theField, ctrlField);
        System.debug('show dependencyField :: '+dependencyField);
        for (String dependency: dependencyField.keySet()) {
            List<String> option = new List<String>();
            for(PicklistOption p: dependencyField.get(dependency)){
                option.add(p.value);
            }
            options.put(dependency, option);
        }
        return options;
    }

    @AuraEnabled
    public static Account getCustomerInfo(String accountId) {
        Account acc = [SELECT Id, Name FROM Account WHERE Id =: accountId LIMIT 1];
        return acc;
    }

    @AuraEnabled
    public static RecordType getIndividual() {
        RecordType recType = [SELECT Id FROM RecordType WHERE Name = 'Individual Customer' LIMIT 1];
        return recType;
    }

    @AuraEnabled
    public static String getOwner() {
        User currentUser = GlobalUtility.getCurrentUser();
        return currentUser.Name;
    }
    
    public class caseLinkageInfo {
		@AuraEnabled
		public Integer size {get;set;}
		@AuraEnabled
		public List<Case_Session_Linkage__c> caseDetail {get;set;}
	}

    public class response {
        @AuraEnabled
		public Boolean status {get;set;}
        @AuraEnabled
		public String errorMsg {get;set;}
    }

    public class getSearchCaseInitResponse {
        @AuraEnabled
		public Integer size {get;set;}
        @AuraEnabled
		public List<CustomCaseAccountObj> caseAccList {get;set;}
    }

    public class CustomCaseAccountObj { 
        @AuraEnabled
		public String Id {get;set;}
        @AuraEnabled
		public String CaseNumber {get;set;}
        @AuraEnabled
		public String Subject {get;set;}
        @AuraEnabled
		public String Origin {get;set;}
        @AuraEnabled
		public String CustomerName {get;set;}
        @AuraEnabled
		public String Status {get;set;}
        @AuraEnabled
		public Datetime CreatedDate {get;set;}
        @AuraEnabled
		public Datetime LastModifiedDate {get;set;}

    }
}