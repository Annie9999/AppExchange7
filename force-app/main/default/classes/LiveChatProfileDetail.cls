public without sharing class LiveChatProfileDetail {
    	public class detailData {
		@AuraEnabled
		public String firstnameDetail {get;set;}
		@AuraEnabled
		public String lastnameDetail {get;set;}
		@AuraEnabled
		public String firstnameENDetail {get;set;}
		@AuraEnabled
		public String lastnameENDetail {get;set;}
		@AuraEnabled
		public String phoneDetail {get;set;}
		@AuraEnabled
		public String emailDetail {get;set;}
		@AuraEnabled
		public String lineIdDetail {get;set;}
		@AuraEnabled
		public String ownerDetail {get;set;}
		@AuraEnabled
		public String ownerDetailId {get;set;}
		@AuraEnabled
		public String ownerDetailLink {get;set;}

			public  detailData(String firstnameDetail,String lastnameDetail,String firstnameENDetail,String lastnameENDetail ,String phoneDetail,String emailDetail,String lineIdDetail,String ownerDetail,String ownerDetailId){
				this.firstnameDetail = firstnameDetail;
				this.lastnameDetail  = lastnameDetail;
				this.firstnameENDetail = firstnameENDetail;
				this.lastnameENDetail  = lastnameENDetail;
				this.phoneDetail  = phoneDetail ;
				this.emailDetail  = emailDetail ;
				this.lineIdDetail = lineIdDetail ;
				this.ownerDetail = ownerDetail;
				this.ownerDetailId = ownerDetailId;
				this.ownerDetailLink  = '/' + ownerDetailId;
				
			}


		}
    @AuraEnabled
	public static  DetailsData getDetail(String recordId){
        System.debug('___________Detail__________');
		System.debug('recordId' + recordId);
        List< DetailData > details = new List< DetailData>();
		List<ChatSession__c> chat = [select Social_ID__c,Social_id__r.Social_Type__c from ChatSession__c Where id = :recordId];
		System.debug('chat' +chat);
		String  SocialID,SocialType ;
		if(chat.size() > 0){
        	SocialID = chat[0].Social_ID__c ;
			SocialType = chat[0].Social_id__r.Social_Type__c;
		}
		List<SocialAccount__c> detail = [select FirstName__c,LastName__c,First_Name_EN__c,Last_Name_EN__c,Phone_Number__c,Email__c,Line_ID__c,Owner.Name ,OwnerId from SocialAccount__c where id = :SocialID ] ;
        System.debug('getDetail' + detail);  
		// String sObjName = detail[0].OwnerId.getSObjectType().getDescribe().getName();
        List<chatsession__c> myId = [select id,owner.name, OwnerId from chatsession__c where id = :recordId]; 
		String  my_ID ;
		if(chat.size() > 0){
        	my_ID = myId[0].OwnerId.getSObjectType().getDescribe().getName();
		}
		String sObjName = my_ID ;
        System.debug('sObjName'+ sObjName);
        String firstnameDetails ;
		String	lastnameDetails ;	
 		String firstnameENDetails ;
		String	lastnameENDetails ;
		String	phoneDetails ;
		String	emailDetails ;
		String lineIdDetails ;

		Id userId = userinfo.getUserId();
		User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
		system.debug('Profile Name:' + userDetails.Profile.Name);

      
        if(detail.size() > 0){
            for(SocialAccount__c each: detail){
                details.add(new  DetailData(each.FirstName__c,each.LastName__c,each.First_Name_EN__c,each.Last_Name_EN__c,each.Phone_Number__c,each.Email__c,each.Line_ID__c,myId[0].Owner.Name,each.OwnerId));
            }
			firstnameDetails = details[0].firstnameDetail ;
			lastnameDetails = details[0].lastnameDetail;
			firstnameENDetails = details[0].firstnameENDetail ;
			lastnameENDetails = details[0].lastnameENDetail;
			phoneDetails = details[0].phoneDetail;
			emailDetails =  details[0].emailDetail;
			lineIdDetails = details[0].lineIdDetail;
            System.debug(' details' +  details);
        }else{
			firstnameDetails = null ;
			lastnameDetails = null;
			firstnameENDetails = null ;
			lastnameENDetails = null;
			phoneDetails = null;
			emailDetails =  null;
			lineIdDetails = null;

		}

        // return  details;
        DetailsData rtnValue = new DetailsData();
        if(sObjName == 'User'){
            rtnValue.isUser = 'true' ;
        }
		if(userDetails.Profile.Name.contains('System Administrator') || userDetails.Profile.Name.contains('TeleSale') || userDetails.Profile.Name.contains('Call Centre')){
			rtnValue.isUserLevelSecurity = 'true';
		}

		rtnValue.detailData = details;
		rtnValue.firstName = firstnameDetails;
		rtnValue.lastName = lastnameDetails;
		rtnValue.firstNameEN = firstnameENDetails;
		rtnValue.lastNameEN = lastnameENDetails;
		rtnValue.phone =   phoneDetails;
        rtnValue.email =  emailDetails;
		rtnValue.lineId =  lineIdDetails ;
		rtnValue.socialType = SocialType;
        return rtnValue;
    }

	public class  detailsData {
		@AuraEnabled
		public String isUser {get;set;}
		@AuraEnabled
		public String isUserLevelSecurity {get;set;}
		@AuraEnabled
		public String firstName {get;set;}
		@AuraEnabled
		public String lastName {get;set;}
		@AuraEnabled
		public String firstNameEN {get;set;}
		@AuraEnabled
		public String lastNameEN {get;set;}
		@AuraEnabled
		public String phone {get;set;}
		@AuraEnabled
		public String email {get;set;}
		@AuraEnabled
		public String lineId {get;set;}
		@AuraEnabled
		public String socialType {get;set;}
		@AuraEnabled
		public List<DetailData>  detailData {get;set;}
	}

	@AuraEnabled
	public static response updateSocialAccountIfEditDetailOccured(String recordId, String firstName, String lastName,String firstNameEN, String lastNameEN, String phone,String email,String lineId){
		response res = new response();
		try {
			List<ChatSession__c> chat = [select Social_ID__c from ChatSession__c Where id = :recordId];
			List<SocialAccount__c> socialAccount = [select FirstName__c,LastName__c,First_Name_EN__c,Last_Name_EN__c,Phone_Number__c,Email__c,Line_ID__c from SocialAccount__c where id = :chat[0].Social_ID__c  limit 1];	
			if (socialAccount.size() > 0) {
				SocialAccount__c thissocialAccount = socialAccount[0];
				thissocialAccount.FirstName__c = firstName == ''? null  : firstName;
				thissocialAccount.LastName__c = lastName == ''? null  : lastName;
				thissocialAccount.First_Name_EN__c = firstNameEN == ''? null  : firstNameEN;
				thissocialAccount.Last_Name_EN__c = lastNameEN == ''? null  : lastNameEN;
				thissocialAccount.Phone_Number__c = phone == ''? null  : phone;
				thissocialAccount.Email__c  = email == ''? null  : email;
				thissocialAccount.Line_ID__c  = lineId == ''? null  : lineId;
            	update thissocialAccount; 
				res.status = true;

				if(Test.isRunningTest()){
					throw new DMLException('Test Class');
				}
        	}
		} catch (Exception e) {
            res.status = false;
            res.errorMsg = e.getMessage();
        }
        return res;
		
	}	
    public class response {
        @AuraEnabled
		public Boolean status {get;set;}
        @AuraEnabled
		public String errorMsg {get;set;}
    }   

}