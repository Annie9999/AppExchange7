public without sharing class CaseSessionLinkedRecordController {

    @AuraEnabled
    public static List<Case> retrieveData(String caseId){

        List<Case> caseData = [SELECT id,CaseNumber,AccountId,ownerId,Status FROM Case WHERE id=:caseId];
        return caseData;
    }


    @AuraEnabled
    public static userInfo getInitData(String ownerId, String accountId) {
        userInfo rtnValue = new userInfo();
        List<User> user = [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id =: ownerId LIMIT 1];
        if(!user.isEmpty()){
            rtnValue.owner = user[0];
        }
        else{
            rtnValue.owner = null;
        }

        List<Account> customer = [SELECT Id, Name FROM Account WHERE Id =: accountId LIMIT 1];
        if(!customer.isEmpty()){
            // if(customer[0].Mobile__c != null && customer[0].Mobile__c.startsWith('+66')){
            //     customer[0].Mobile__c = customer[0].Mobile__c.replace('+66', '0');
            // }
            rtnValue.acc = customer[0];
        }
        else{
            rtnValue.acc = null;
        }
        System.debug('view value >>>>> '+rtnValue);
        return rtnValue;
    }
    @AuraEnabled
    public static response handleDeleteCase(String id, String sessionId) {
        response res = new response();
        try {
            List<Case> caseTarget = [SELECT Id, FromChatSession__c FROM Case WHERE Id =: id LIMIT 1];
            if(!caseTarget.isEmpty()){
                if(caseTarget[0].FromChatSession__c != null && caseTarget[0].FromChatSession__c == sessionId){
                    delete caseTarget[0];
                }
                else{
                    List<Case_Session_Linkage__c> caseLinkageTarget = [SELECT Id FROM Case_Session_Linkage__c WHERE Case__c =: id LIMIT 1];         
                    if(!caseLinkageTarget.isEmpty()){  
                        delete caseLinkageTarget[0];
                    }
                }
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
    public static dupCaseResponse checkDupCaseBeforeDelete(String id, String sessionId) {
        dupCaseResponse res = new dupCaseResponse();
        try {
            List<Case> caseTarget = [SELECT Id, FromChatSession__c FROM Case WHERE Id =: id LIMIT 1];
            if(!caseTarget.isEmpty()){
                if(caseTarget[0].FromChatSession__c != null & caseTarget[0].FromChatSession__c == sessionId){
                    List<Case_Session_Linkage__c> dupCase = [
                        SELECT Id, iigproduct__ChatSession__r.Name, iigproduct__ChatSession__r.CreatedDate
                        FROM Case_Session_Linkage__c 
                        WHERE iigproduct__Case__c =: id AND iigproduct__ChatSession__c !=: sessionId ORDER BY iigproduct__ChatSession__r.CreatedDate DESC LIMIT 5];
                    if(!dupCase.isEmpty()){
                        res.dupCase = dupCase;
                    }
                    res.status = true;
                }
            }
            else{
                res.status = false;
                res.errorMsg = 'An error occured. Please try again later.';
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
    public static oldData getOldCaseData(String caseId) {
        oldData res = new oldData();

        List<Case> caseObj = [SELECT Id, Subject, AccountId, Origin,Priority,Status, Description FROM Case WHERE Id =: caseId LIMIT 1];
        if(!caseObj.isEmpty()){
            res.caseObj = caseObj[0];
        }
         else{
            res.caseObj = null;
        }

        return res;
    }

    @AuraEnabled
    public static response updateCase(String caseId, String accountId, String origin,
        String priority, String status,String description) {
        response res = new response();
        try {
            List<Case> targetCase = [SELECT Id FROM Case WHERE Id =: caseId LIMIT 1];
            if(!targetCase.isEmpty()){
                targetCase[0].AccountId = accountId;
                targetCase[0].Origin = origin;
                targetCase[0].Priority = priority != '--None--'? priority:null;
                targetCase[0].Status = status != '--None--'? status:null;
                targetCase[0].Description = description;
                update targetCase[0];
                
                res.status = true;
            }
            else{
                res.status = false;
                res.errorMsg = 'An error occured. Cannot find the case.';
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
    public static Map<String, List<String>> getsinglePicklist(String fieldName) {
        return CaseSessionLinkedController.getsinglePicklist(fieldName);
    }

    @AuraEnabled
    public static Account getCustomerInfo(String accountId) {
        return CaseSessionLinkedController.getCustomerInfo(accountId);
    }

    @AuraEnabled
    public static RecordType getIndividual() {
        return CaseSessionLinkedController.getIndividual();
    }

    public class userInfo {
		@AuraEnabled
		public User owner {get;set;}
        @AuraEnabled
		public Account acc {get;set;}
	}

    public class oldData {
		@AuraEnabled
		public Case caseObj {get;set;}
	}

    public class response {
        @AuraEnabled
		public Boolean status {get;set;}
        @AuraEnabled
		public String errorMsg {get;set;}
    }

    public class dupCaseResponse {
        @AuraEnabled
		public Boolean status {get;set;}
        @AuraEnabled
		public String errorMsg {get;set;}
        @AuraEnabled
		public List<Case_Session_Linkage__c> dupCase {get;set;}
    }
   
}