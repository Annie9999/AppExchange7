public without sharing class LiveChatProfileCustomer {
	public class CustomerDataTable {
		@AuraEnabled
		public String customerName {get;set;}
		@AuraEnabled
		public String status {get;set;}
		@AuraEnabled
		public String vip {get;set;}
        @AuraEnabled
		public String customerOwner {get;set;}
		@AuraEnabled
		public String createdDate{get;set;}
		@AuraEnabled
		public String lastModified {get;set;}
		@AuraEnabled
		public String customerId {get;set;}
		@AuraEnabled
		public String customerLink {get;set;}
		@AuraEnabled
		public String customerOwnerId {get;set;}
		@AuraEnabled
		public String customerOwnerLink {get;set;}
		
		

		public CustomerDataTable(String customerName,String status,String vip,String customerOwner,String createdDate,String lastModified,String customerId,String  customerOwnerId){
			this.customerName  = customerName ;
			this.status = status;
			this.vip = vip ;
            this.customerOwner = customerOwner ;
			this.createdDate = createdDate;
			this.lastModified = lastModified;
			this.customerId = customerId;
			this.customerLink = '/' + customerId;
			this.customerOwnerId  = customerOwnerId ;
			this.customerOwnerLink  = '/' + customerOwnerId ;
		}
	}
    @AuraEnabled
	public static customerLinkData getCustomer(String recordId){
        System.debug('___________Customer__________');
        List<CustomerDataTable> customerTables = new List<CustomerDataTable>();
		List<ChatSession__c> chat = [select Social_ID__c from ChatSession__c Where id = :recordId];
		System.debug('chat' +chat);
		String  SocialID ;
		if(chat.size() > 0){
        	SocialID = chat[0].Social_ID__c ;
		}
        List<Lead_Session_Linkage__c> lead = [select Lead__r.convertedaccountId from Lead_Session_Linkage__c WHERE ChatSession__r.Social_ID__c = :SocialID] ; 
		List<Case_Session_Linkage__c> cases = [select Case__r.AccountId from Case_Session_Linkage__c WHERE ChatSession__r.Social_ID__c = :SocialID] ;
        System.debug('lead' +lead);
		System.debug('cases' + cases);
		Set<String> accountId = new Set<String>();
		if(lead.size() > 0){    
            for(Lead_Session_Linkage__c each: lead){
                accountId.add(each.Lead__r.convertedaccountId);
            }
        }
		if(cases.size() > 0){
            for(Case_Session_Linkage__c each: cases){
                accountId.add(each.Case__r.AccountId);
            }
        }
		System.debug(accountId);
        List<String> accId = new List<String>();
		accId.addAll(accountId);
		System.debug(accId);

		List<Account> customers = [select Name, Owner.Name,CreatedDate,LastModifiedDate, Id, OwnerId from Account where Id = :accId ORDER BY LastModifiedDate DESC] ;
        System.debug('getcustomer' + customers);  
        /*if(customers.size() > 0){
            for(Account each: customers){
				//System.debug(each.Customer_Status__c);
				
				if(each.VIPText__c == null){
					customerTables.add(new CustomerDataTable(each.Name,each.Customer_Status__c,'-',each.Owner.Name,each.CreatedDate.format('dd/MM/yyyy HH:MM'),each.LastModifiedDate.format('dd/MM/yyyy HH:MM'),each.Id,each.OwnerId));
				}
				else{
					customerTables.add(new CustomerDataTable(each.Name,each.Customer_Status__c,each.VIPText__c,each.Owner.Name,each.CreatedDate.format('dd/MM/yyyy HH:MM'),each.LastModifiedDate.format('dd/MM/yyyy HH:MM'),each.Id,each.OwnerId));
				}
                
            }
            System.debug('customerTables' + customerTables);
        }*/
		customerLinkData rtnValue = new customerLinkData();
		rtnValue.size = customers.size();
        rtnValue.customerdataTables = customerTables;
        return rtnValue;
    }

	public class customerLinkData {
		@AuraEnabled
		public Integer size {get;set;}
		@AuraEnabled
		public List<CustomerDataTable> customerdataTables {get;set;}
	}
}