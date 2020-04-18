public with sharing class LeadSessionLinkedRecordController {
    public class getLeadPicklistInfomationRespon {
        @AuraEnabled
		public List <String> picklistLeadSource {get;set;}
        @AuraEnabled
        public List <String> picklistPurpose {get;set;}
        @AuraEnabled
        public List <String> picklistMediaInfo {get;set;}
	}

    @AuraEnabled
	public static getLeadPicklistInfomationRespon getLeadPicklistInfomation(){
        getLeadPicklistInfomationRespon res = new getLeadPicklistInfomationRespon();
        // picklistLeadSource
        List<String> leadsourceList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Lead.LeadSource.getDescribe();
        List<Schema.PicklistEntry> val = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : val){
            leadsourceList.add(pickListVal.getLabel());
        }
        if (!leadsourceList.isEmpty()) {
            res.picklistLeadSource = leadsourceList;
        }
        // picklistPurpose
        /*List<String> purposeList = new List<String>();
        Schema.DescribeFieldResult fieldResultPurposeList = Lead.PurposeOfBuyingDisplay__c.getDescribe();
        System.debug(fieldResultPurposeList);
        List<Schema.PicklistEntry> purposeListVal = fieldResultPurposeList.getPicklistValues();
        System.debug(purposeListVal);
        for( Schema.PicklistEntry pickListVal : purposeListVal){
            purposeList.add(pickListVal.getLabel());
        }
        System.debug(purposeList);
        if (!purposeList.isEmpty()) {
            res.picklistPurpose = purposeList;
        }*/

        // picklistMediaInfo
       /* List<Survey_Master_Question__c>  masterList  = [select Id, Answer_1__c from Survey_Master_Question__c where Seq__c = 4 and Survey_Master__r.Language__c = 'EN' and Survey_Master__r.Survey_Type__c = 'Visit Survey'  LIMIT 1];
		Survey_Master_Question__c  Survey_Master_Question = masterList.isEmpty()? null:masterList.get(0);
		String[] Survey_Master_QuestionList = Survey_Master_Question == null? new List<String>{'Website', 'Facebook'}:Survey_Master_Question.Answer_1__c.split(';');
			
		List<String>  picklistMedia = new List<String>();
		for (Integer i = 0; i < Survey_Master_QuestionList.size(); i++){
			picklistMedia.add(Survey_Master_QuestionList[i]);
		}

        res.picklistMediaInfo = picklistMedia;*/
        System.debug(res);
        
        return res;
    }
    /*public class ProjectInfomationRespon {
		@AuraEnabled
		public Project__c projectData {get;set;}
	}*/

   /* @AuraEnabled
	public static ProjectInfomationRespon getProjectInfomation(String projectId){
        System.debug(projectId);
        ProjectInfomationRespon res = new ProjectInfomationRespon();
        List<Project__c> project = [select Id,Project_Code__c, Project_Id__c, Name, Active__c, Project_Name_EN__c from Project__c where Id =  :projectId];
        System.debug(project);
        if (!project.isEmpty()) {
            System.debug(project);
            res.projectData = project.get(0);
        }
        
        System.debug(res);
        return res;
    } */
    public class CustomResponse{
		@AuraEnabled
		public Boolean success {get;set;}
		@AuraEnabled
		public String msg {get;set;}
	}
    @AuraEnabled
    public static CustomResponse updatedLead(Lead leadData){
        CustomResponse res = new CustomResponse();
		res.success = false;
        try {
            System.debug(leadData);
            if (leadData != null) {
                update leadData;
                res.success = true;
            }
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            res.success = false;
			res.msg = errorMessage;
			return res;
        }
        return res;
    }
    @AuraEnabled
    public static CustomResponse removedLeadToLeadSessionLinkage(String leadId, String sessionId){
        System.debug(leadId);
        System.debug(sessionId);
        CustomResponse res = new CustomResponse();
		res.success = false;
        try {
            if (leadId != null && sessionId != null) {
                List<Lead_Session_Linkage__c> LeadSessionLinkage = [SELECT Id, Lead__c, ChatSession__c FROM Lead_Session_Linkage__c WHERE Lead__c =: leadId AND ChatSession__c =:sessionId];
                if (!LeadSessionLinkage.isEmpty()) {
                    delete LeadSessionLinkage.get(0);
                    res.success = true;
                }
            }
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            res.success = false;
			res.msg = errorMessage;
			return res;
        }
        return res;
    }
    @AuraEnabled
    public static CustomResponse deletedLead(String leadId, String sessionId){
        CustomResponse res = new CustomResponse();
		res.success = false;
        try {
            if (leadId != null && sessionId != null) {
                List<Lead> leadData = [SELECT Id, FromChatSession__c FROM Lead WHERE Id =: leadId];
                if (!leadData.isEmpty()) {
                    String fromChatSession = leadData.get(0).FromChatSession__c;
                    System.debug('fromChatSession : ' + fromChatSession);
                    System.debug('sessionId : ' + sessionId);
                    
                    removedLeadToLeadSessionLinkage(leadId, sessionId);

                    if (fromChatSession != null && fromChatSession == sessionId) {
                        delete leadData.get(0);
                    }
                    res.success = true;
                }
            }
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            res.success = false;
			res.msg = errorMessage;
			return res;
        }
        return res;
    }
    public class foundLeadSessionLinkageResponse{
		@AuraEnabled
		public Boolean success {get;set;}
		@AuraEnabled
		public String msg {get;set;}
        @AuraEnabled
        public List<Lead_Session_Linkage__c> sessionLeadDup {get;set;}
	}
    @AuraEnabled
    public static foundLeadSessionLinkageResponse foundLeadSessionLinkageBeforeDeleteLead(String leadId, String sessionId){
        foundLeadSessionLinkageResponse res = new foundLeadSessionLinkageResponse();
		res.success = false;
        try {
            if (leadId != null && sessionId != null) {
                List<Lead> leadData = [SELECT Id, FromChatSession__c FROM Lead WHERE Id =: leadId];
                if (!leadData.isEmpty()) {
                    String fromChatSession = leadData.get(0).FromChatSession__c;
                    System.debug('fromChatSession : ' + fromChatSession);
                    System.debug('sessionId : ' + sessionId);
                    System.debug('leadId : ' + leadId);
                    if (fromChatSession != null && fromChatSession == sessionId) {
                        List<Lead_Session_Linkage__c> LeadSessionLinkage = [SELECT Id, Lead__c, ChatSession__c, ChatSession__r.Name, ChatSession__r.CreatedDate FROM Lead_Session_Linkage__c WHERE Lead__c =: leadId AND ChatSession__c !=: sessionId ORDER BY ChatSession__r.CreatedDate DESC Limit 5];
                        System.debug(LeadSessionLinkage);
                        if (!LeadSessionLinkage.isEmpty()) {
                            res.sessionLeadDup = LeadSessionLinkage;
                        }
                    }
                    res.success = true;
                }
            }
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            res.success = false;
			res.msg = errorMessage;
			return res;
        }
        return res;
    }
}