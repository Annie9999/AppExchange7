public with sharing class LiveChatProfileCase {
    public class CaseDataTable {
		@AuraEnabled
		public String caseNumber {get;set;}
		@AuraEnabled
		public String subject {get;set;}
		@AuraEnabled
		public String project {get;set;}
		@AuraEnabled
		public String unit {get;set;}
		@AuraEnabled
		public String category {get;set;}
		@AuraEnabled
		public String subCategory {get;set;}
		@AuraEnabled
		public String caseOwner {get;set;}
		@AuraEnabled
		public String status {get;set;}
        @AuraEnabled
		public String createdDate{get;set;}
		@AuraEnabled
		public String lastModified {get;set;}
		@AuraEnabled
		public String caseId {get;set;}
		@AuraEnabled
		public String caseLink {get;set;}
		@AuraEnabled
		public String projectId {get;set;}
		@AuraEnabled
		public String projectLink {get;set;}
		@AuraEnabled
		public String unitId {get;set;}
		@AuraEnabled
		public String unitLink {get;set;}
		@AuraEnabled
		public String caseOwnerId {get;set;}
		@AuraEnabled
		public String caseOwnerLink{get;set;}
	
		public CaseDataTable(String caseNumber,String subject,String project,String unit,String category,String subCategory,String caseOwner,String status,String createdDate,String lastModified,String caseId,String projectId,String unitId,String caseOwnerId ){
			this.caseNumber  = caseNumber ;
            this.subject  = subject ;
			this.project = project;
			this.unit = unit;
			this.category = category;
			this.subCategory = subCategory;
			this.caseOwner = caseOwner;
			this.status = status ;
            this.createdDate  =  createdDate;
			this.lastModified = lastModified;
			this.caseId = caseId;
			this.caseLink = '/' + caseId;
			this.projectId = projectId;
			this.projectLink = project == '-'? 'javascript:void(0)': '/' + projectId;
			this.unitId = unitId;
			this.unitLink = unit == '-'? 'javascript:void(0)': '/' + unitId ; 
			this.caseOwnerId = caseOwnerId;
			this.caseOwnerLink = '/' + caseOwnerId;
		}
	}
    @AuraEnabled
	public static caseLinkData getCase(String recordId){
        System.debug('___________Case__________');
        List<CaseDataTable> caseTables = new List<CaseDataTable>();
		List<ChatSession__c> chat = [select Social_ID__c from ChatSession__c Where id = :recordId];
		String  SocialID ;
		if(chat.size() > 0){
        	SocialID = chat[0].Social_ID__c ;
		}
        List<Case_Session_Linkage__c> cases = [select Case__r.CaseNumber,Case__r.Subject,Case__r.Owner.Name ,Case__r.Status,CreatedDate,LastModifiedDate,Case__r.Id,Case__r.OwnerId from Case_Session_Linkage__c  WHERE ChatSession__r.Social_ID__c = :SocialID ORDER BY LastModifiedDate DESC] ;
        System.debug('getCase' + cases);  
        /*if(cases.size() > 0){
			String projectName = '-';
			String unitName = '-';
            for(Case_Session_Linkage__c each: cases){
				if(each.Case__r.Project__r.name != null){
					projectName = each.Case__r.Project__r.name;
				}
				if(each.Case__r.Unit__r.name != null){
					unitName  = each.Case__r.Unit__r.name;
				}
                caseTables.add(new CaseDataTable(each.Case__r.CaseNumber,each.Case__r.Subject,projectName,unitName,each.Case__r.Category__c,each.Case__r.Sub_Category__c,each.Case__r.Owner.Name,each.Case__r.Status,each.CreatedDate.format('dd/MM/yyyy HH:MM'),each.LastModifiedDate.format('dd/MM/yyyy HH:MM'),each.Case__r.Id,each.Case__r.Project__c,each.Case__r.Unit__c,each.Case__r.OwnerId));
            }
            System.debug('caseTables' + caseTables);
        }*/
        caseLinkData rtnValue = new caseLinkData();
		rtnValue.size = cases.size();
        rtnValue.casedataTables = caseTables;
        return rtnValue;
    }

	public class caseLinkData {
		@AuraEnabled
		public Integer size {get;set;}
		@AuraEnabled
		public List<CaseDataTable> casedataTables {get;set;}
	}
    
}