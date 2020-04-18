public without sharing class LeadSessionLinkedCtrl {
    public class LeadSessionLikedInfomationRespon {
		@AuraEnabled
		public List<Lead_Session_Linkage__c> leadSessionLinkageData {get;set;}
	}

    @AuraEnabled
	public static LeadSessionLikedInfomationRespon getLeadSessionLikedInfomation(String sessionId){
        System.debug('@getLeadSession: '+ sessionId);

        LeadSessionLikedInfomationRespon res = new LeadSessionLikedInfomationRespon();
        List<Lead_Session_Linkage__c> LeadSessionLinkage = [SELECT Id, Lead__c, Lead__r.Name, Lead__r.FirstName, Lead__r.LastName, Lead__r.Email, Lead__r.MobilePhone,  
                                                            Lead__r.LeadSource, Lead__r.Description, 
                                                            ChatSession__c, Lead__r.Status, Lead__r.FromChatSession__c, CreatedDate 
                                                            FROM Lead_Session_Linkage__c 
                                                            WHERE ChatSession__c  =:sessionId AND Lead__c != null ORDER BY CreatedDate];
       
        /*System.debug('LeadSessionLinkage: '+LeadSessionLinkage.size());
        System.debug('ChatSession__c: '+LeadSessionLinkage.get(0).ChatSession__c);
        System.debug('Lead__c: '+LeadSessionLinkage.get(0).Lead__c);*/

        if (!LeadSessionLinkage.isEmpty()) {
            System.debug(LeadSessionLinkage);
            res.leadSessionLinkageData = LeadSessionLinkage;
        }
        
        System.debug(res);
        return res;
    }

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
       /* List<String> purposeList = new List<String>();
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

    /*@AuraEnabled
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
    }*/
    public class getSocialIdFromChatSessionRespon {
		@AuraEnabled
		public String socialID {get;set;}
	}

    @AuraEnabled
	public static getSocialIdFromChatSessionRespon getSocialIdFromChatSession(String recordId){
        // for  data criteria search
        System.debug(recordId);
        getSocialIdFromChatSessionRespon res = new getSocialIdFromChatSessionRespon();
        List<ChatSession__c> chatSession = [SELECT Id, Social_ID__c FROM ChatSession__c  WHERE Id  =:recordId Limit 1];
        System.debug(chatSession);
        if (!chatSession.isEmpty()) {
            System.debug(chatSession);
            res.socialID = chatSession.get(0).Social_ID__c;
        }
        
        System.debug(res);
        return res;
    }

    public class getSocialInfoFromSocialIDRespon {
		@AuraEnabled
		public SocialAccount__c socialAccount {get;set;}
	}

    @AuraEnabled
	public static getSocialInfoFromSocialIDRespon getSocialInfoFromSocialID(String socialID){
        // for default info to insert lead
        System.debug('getSocialInfoFromSocialID: '+socialID);
        getSocialInfoFromSocialIDRespon res = new getSocialInfoFromSocialIDRespon();
        List<SocialAccount__c> socialAccount = [SELECT Id, LastName__c, FirstName__c, Phone_Number__c, Email__c FROM SocialAccount__c WHERE Id  =:socialID Limit 1];
        System.debug(socialAccount);
        if (!socialAccount.isEmpty()) {
            System.debug(socialAccount);
            res.socialAccount = socialAccount.get(0);
        }
        
        System.debug(res);
        return res;
    }
    public class LeadRecordDataResponse {
        @AuraEnabled
        public List<Lead> leads{get;set;}
    }
	@AuraEnabled
    public static LeadRecordDataResponse getLeadDuplicateRecordData(String socialID){
        System.debug('#socialID: '+ socialID);
        // Criteria FirstName && LastName &&  (Mobile  OR Email)
        LeadRecordDataResponse res = new LeadRecordDataResponse();
        if (socialID == null) {
            return res;
        }
        List<SocialAccount__c> socialAccount = [SELECT Id, Email__c, Phone_Number__c, FirstName__c, LastName__c FROM SocialAccount__c WHERE Id = :socialID Limit 1];
        List<Lead> dupLead = new List<Lead>();

        System.debug(socialAccount);
        if (!socialAccount.isEmpty()) {
            System.debug(socialAccount.get(0));
            System.debug(socialAccount.get(0).Phone_Number__c);
            if (socialAccount.get(0).Phone_Number__c == null) {
                socialAccount.get(0).Phone_Number__c = '0000000000';
            }
            String tempMobilethai = String.valueOf(socialAccount.get(0).Phone_Number__c);
            if(tempMobilethai != null && tempMobilethai.startsWith('0')){
                tempMobilethai = tempMobilethai.replace('0', '+66');
            }
            System.debug(tempMobilethai);
            String tempMobile = String.valueOf(socialAccount.get(0).Phone_Number__c);
            if(tempMobile != null && tempMobile.startsWith('+66')){
                tempMobile = tempMobile.replace('+66', '0');
            }
            System.debug(tempMobile);

            dupLead = [SELECT Id, Email, Name, FirstName, LastName, MobilePhone, CreatedDate, LeadSource, Status, FromChatSession__c FROM Lead 
                            WHERE (FirstName = :socialAccount.get(0).FirstName__c AND LastName = :socialAccount.get(0).LastName__c 
                                AND ((MobilePhone != '0000000000' AND (MobilePhone = :socialAccount.get(0).Phone_Number__c OR MobilePhone = :tempMobilethai OR MobilePhone = :tempMobile)) OR ((Email != 'noemail@sansiri.com' AND Email != '') AND Email = :socialAccount.get(0).Email__c)))
                        ORDER BY CreatedDate DESC];
        }
        System.debug(dupLead);
        if(dupLead.isEmpty()) {
            return res;
        }
        
		res.leads = dupLead;
        return res;

    }

    @AuraEnabled
    public static LeadRecordDataResponse searchedByLeadKey(String searchInputText){

		System.debug(searchInputText);
        LeadRecordDataResponse res = new LeadRecordDataResponse();
        String searchInputTextTemp = '%' + searchInputText + '%';

        String tempMobilethai = searchInputText;
        if(tempMobilethai != null && tempMobilethai.startsWith('0')){
            tempMobilethai = '%' + tempMobilethai.replace('0', '+66') + '%';
        }
        System.debug(tempMobilethai);
        String tempMobile = searchInputText;
        if(tempMobile != null && tempMobile.startsWith('+66')){
            tempMobile = '%' + tempMobile.replace('+66', '0') + '%';
        }
        System.debug(tempMobile);
        List<Lead> leadList = [SELECT Id, Email, Name, FirstName, LastName, MobilePhone, CreatedDate,  LeadSource, Status, FromChatSession__c FROM Lead 
                                WHERE FirstName like :searchInputTextTemp OR LastName like :searchInputTextTemp OR  Name like :searchInputTextTemp OR (MobilePhone like :searchInputTextTemp OR MobilePhone = :tempMobilethai OR MobilePhone = :tempMobile ) OR Email like :searchInputTextTemp
                                ORDER BY CreatedDate DESC];
       
        if(leadList.isEmpty()) {
            return res;
        }

		res.leads = leadList;
        return res;
    } 
    public class CustomResponse{
		@AuraEnabled
		public Boolean success {get;set;}
		@AuraEnabled
		public String msg {get;set;}
	}
    // @AuraEnabled
    // public static CustomResponse updatedLead(Lead leadData){
    //     CustomResponse res = new CustomResponse();
	// 	res.success = false;
    //     try {
    //         System.debug(leadData);
    //         if (leadData != null) {
    //             update leadData;
    //             res.success = true;
    //         }
    //     } catch (Exception ex) {
    //         String errorMessage = ex.getMessage();
    //         res.success = false;
	// 		res.msg = errorMessage;
	// 		return res;
    //     }
    //     return res;
    // }
    @AuraEnabled
    public static CustomResponse addedLeadToLeadSessionLinkage(String leadId, String sessionId){
        System.debug(' #add_leadId: '+ leadId);
        System.debug(' #add_sessionId: '+ sessionId);

        CustomResponse res = new CustomResponse();
		res.success = false;
        try {
            if (leadId != null && sessionId != null) {
                 Lead_Session_Linkage__c LeadSessionLinkage = new Lead_Session_Linkage__c (
                    Lead__c = leadId,
                    ChatSession__c = sessionId
                );
                insert LeadSessionLinkage;
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
        System.debug(' #remove_leadId: '+ leadId);
        System.debug(' #remove_sessionId: '+ sessionId);
        
        CustomResponse res = new CustomResponse();
		res.success = false;
        try {
            if (leadId != null && sessionId != null) {
                List<Lead_Session_Linkage__c> LeadSessionLinkage = [SELECT Id, Lead__c, ChatSession__c FROM Lead_Session_Linkage__c WHERE Lead__c =: leadId AND ChatSession__c =:sessionId];
                System.debug(' #remove: '+ LeadSessionLinkage.size());

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
    // @AuraEnabled
    // public static CustomResponse deletedLead(String leadId, String sessionId){
    //     CustomResponse res = new CustomResponse();
	// 	res.success = false;
    //     try {
    //         if (leadId != null && sessionId != null) {
    //             List<Lead> leadData = [SELECT Id, FromChatSession__c FROM Lead WHERE Id =: leadId];
    //             if (!leadData.isEmpty()) {
    //                 String fromChatSession = leadData.get(0).FromChatSession__c;
    //                 System.debug('fromChatSession : ' + fromChatSession);
    //                 System.debug('sessionId : ' + sessionId);
                    
    //                 removedLeadToLeadSessionLinkage(leadId, sessionId);

    //                 if (fromChatSession != null && fromChatSession == sessionId) {
    //                     delete leadData.get(0);
    //                 }
    //                 res.success = true;
    //             }
    //         }
    //     } catch (Exception ex) {
    //         String errorMessage = ex.getMessage();
    //         res.success = false;
	// 		res.msg = errorMessage;
	// 		return res;
    //     }
    //     return res;
    // }
    // public class foundLeadSessionLinkageResponse{
	// 	@AuraEnabled
	// 	public Boolean success {get;set;}
	// 	@AuraEnabled
	// 	public String msg {get;set;}
    //     @AuraEnabled
    //     public List<Lead_Session_Linkage__c> sessionLeadDup {get;set;}
	// }
    // @AuraEnabled
    // public static foundLeadSessionLinkageResponse foundLeadSessionLinkageBeforeDeleteLead(String leadId, String sessionId){
    //     foundLeadSessionLinkageResponse res = new foundLeadSessionLinkageResponse();
	// 	res.success = false;
    //     try {
    //         if (leadId != null && sessionId != null) {
    //             List<Lead> leadData = [SELECT Id, FromChatSession__c FROM Lead WHERE Id =: leadId];
    //             if (!leadData.isEmpty()) {
    //                 String fromChatSession = leadData.get(0).FromChatSession__c;
    //                 System.debug('fromChatSession : ' + fromChatSession);
    //                 System.debug('sessionId : ' + sessionId);
    //                 if (fromChatSession != null && fromChatSession == sessionId) {
    //                     List<Lead_Session_Linkage__c> LeadSessionLinkage = [SELECT Id, Lead__c, ChatSession__c, ChatSession__r.Name, ChatSession__r.CreatedDate FROM Lead_Session_Linkage__c WHERE Lead__c =: leadId AND ChatSession__c !=: sessionId ORDER BY ChatSession__r.CreatedDate DESC Limit 5];
    //                     System.debug(LeadSessionLinkage);
    //                     if (!LeadSessionLinkage.isEmpty()) {
    //                         res.sessionLeadDup = LeadSessionLinkage;
    //                     }
    //                 }
    //                 res.success = true;
    //             }
    //         }
    //     } catch (Exception ex) {
    //         String errorMessage = ex.getMessage();
    //         res.success = false;
	// 		res.msg = errorMessage;
	// 		return res;
    //     }
    //     return res;
    // }
    @AuraEnabled
    public static CustomResponse insertedLead(Lead leadData, String sessionId){

         System.debug('Lead: '+leadData.Id);
         System.debug('sessionId: '+sessionId);

        CustomResponse res = new CustomResponse();
		res.success = false;
        try {
            System.debug(leadData);
            if (leadData != null) {
                insert leadData;
                System.debug(leadData.Id);
                addedLeadToLeadSessionLinkage(leadData.Id, sessionId);
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
}