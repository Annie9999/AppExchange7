global class RemoveLiveChatFileBatch implements Database.Batchable<sObject> ,Database.Stateful{
    global RemoveLiveChatFileBatch() {
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select Id from ContentDocument where Id IN (select ContentDocumentId from ContentVersion where Title like \'%' + LiveChatMainComponentRemote.SUFFIX_FILE_LIVE_CHAT + '\') and Createddate = LAST_N_DAYS:30';
		System.debug(query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<ContentDocument> scope) {
        System.debug('scope ' + scope);
        if (scope.size() > 0) {
            delete scope;
        }
	}

	global void finish(Database.BatchableContext BC) {
		
	}
}