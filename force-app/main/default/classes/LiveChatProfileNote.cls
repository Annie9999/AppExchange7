public without sharing class LiveChatProfileNote {
    	public class NoteData {
		@AuraEnabled
		public String chatNote {get;set;}
		@AuraEnabled
		public String ownerNote {get;set;}
		@AuraEnabled
		public String ownerTypeNote {get;set;}
		@AuraEnabled
		public String createdDate {get;set;}
		@AuraEnabled
		public String createdTime {get;set;}
		@AuraEnabled
		public String ownerNoteId {get;set;}
		@AuraEnabled
		public String ownerNoteLink {get;set;}

		public NoteData(String chatNote ,String ownerNote,String ownerTypeNote,String createdDate,String createdTime,String ownerNoteId){
			// this.chatNote  = chatNote == null? 'None': chatNote;
			this.chatNote  = chatNote;
			this.ownerNote  = ownerNote ;
			this.ownerTypeNote = ownerTypeNote == 'User'?  'true':'false' ;
			this.createdDate  = createdDate  ;
			this.createdTime = createdTime;
			this.ownerNoteId = ownerNoteId;
			this.ownerNoteLink = '/' + ownerNoteId;
		}
	}
    @AuraEnabled
	public static List<NoteData> getNote(String recordId){
        System.debug('___________Note__________');
		System.debug('recordId' + recordId);
        List<NoteData> notes = new List<NoteData>();
		List<ChatSession__c> chat = [select Social_ID__c from ChatSession__c Where id = :recordId];
		System.debug('chat' +chat);
		String  SocialID ;
		if(chat.size() > 0){
        	SocialID = chat[0].Social_ID__c ;
		}
        List<ChatSession__c> note = [select Chat_Note__c ,Owner.Id,Owner.Name,CreatedDate  from ChatSession__c where Social_ID__c  = :SocialID ORDER BY CreatedDate DESC] ;
        System.debug('getNote' + note);  
		String sObjName ;
        if(note.size() > 0){
            for(ChatSession__c each: note){
				sObjName = each.Owner.Id.getSObjectType().getDescribe().getName();
				System.debug(each.Chat_Note__c);
				if(each.Chat_Note__c != null){
					notes.add(new NoteData(each.Chat_Note__c,each.Owner.Name,sObjName,each.CreatedDate.format('dd/MM/yyyy'),each.CreatedDate.format('HH:MM'),each.OwnerId));
				}
                
            }
            System.debug('notes' + notes);
        }
        return notes;
    }

}