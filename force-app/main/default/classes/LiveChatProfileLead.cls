public without sharing class LiveChatProfileLead {
	public class LeadDataTable {
		@AuraEnabled
		public String leadName {get;set;}
		@AuraEnabled
		public String interestedProject {get;set;}
		@AuraEnabled
		public String status {get;set;}
		@AuraEnabled
		public String createdDate{get;set;}
		@AuraEnabled
		public String lastModified {get;set;}
		@AuraEnabled
		public String leadId {get;set;}
		@AuraEnabled
		public String leadLink {get;set;}
		@AuraEnabled
		public String interestedProjectId {get;set;}
		@AuraEnabled
		public String interestedProjectLink {get;set;}
		
		

		public LeadDataTable(String leadName,String interestedProject,String status,String createdDate,String lastModified,String leadId,String  interestedProjectId){
			this.leadName  = leadName ;
			this.interestedProject = interestedProject ;
			this.status = status ;
			this.createdDate = createdDate;
			this.lastModified = lastModified;
			this.leadId = leadId;
			this.leadLink = '/' + leadId;
			this.interestedProjectId  = interestedProjectId  ;
			this.interestedProjectLink  = interestedProject == '-'? 'javascript:void(0)': '/' + interestedProjectId;
		}
	}
    @AuraEnabled
	public static leadLinkData getLead(String recordId){
        System.debug('___________Lead__________');
		System.debug('recordId' + recordId);
        List<LeadDataTable> leadTables = new List<LeadDataTable>();
		List<ChatSession__c> chat = [select Social_ID__c from ChatSession__c Where id = :recordId];
		System.debug('chat' +chat);
		String  SocialID ;
		if(chat.size() > 0){
        	SocialID = chat[0].Social_ID__c ;
		}
        List<Lead_Session_Linkage__c> lead = [select Lead__c,Lead__r.Name  , Lead__r.Status,CreatedDate,LastModifiedDate,Lead__r.Id from Lead_Session_Linkage__c WHERE ChatSession__r.Social_ID__c = :SocialID ORDER BY LastModifiedDate DESC] ;
        System.debug('getLead' + lead);  
		Integer s = 0;
       /* if(lead.size() > 0){
            String interestedproj = '-';
            for(Lead_Session_Linkage__c each: lead){
				if(each.Lead__c != null){
					if(each.Lead__r.Interested_Project__r.Name == null){
						leadTables.add(new LeadDataTable(each.Lead__r.Name,interestedproj,each.Lead__r.Status,each.CreatedDate.format('dd/MM/yyyy HH:MM'),each.LastModifiedDate.format('dd/MM/yyyy HH:MM'),each.Lead__r.Id,each.Lead__r.Interested_Project__r.Id));
					}
					else {
						leadTables.add(new LeadDataTable(each.Lead__r.Name,each.Lead__r.Interested_Project__r.Name,each.Lead__r.Status,each.CreatedDate.format('dd/MM/yyyy HH:MM'),each.LastModifiedDate.format('dd/MM/yyyy HH:MM'),each.Lead__r.Id,each.Lead__r.Interested_Project__r.Id));
					}
					s++;

				}
				
               
            }
            System.debug('leadTables' + leadTables);
        }*/
		leadLinkData rtnValue = new leadLinkData();
		rtnValue.size = s;
        rtnValue.leaddataTables = leadTables;
        return rtnValue;
    }

	public class leadLinkData {
		@AuraEnabled
		public Integer size {get;set;}
		@AuraEnabled
		public List<LeadDataTable> leaddataTables {get;set;}
	}
}