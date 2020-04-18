global class ChatMessageRefreshToken implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    private string accessToken; 
    private string refreshToken;
    private string chatMessageId;
    private string response;
    private WebhookAuthentication__c config = new WebhookAuthentication__c();

    global ChatMessageRefreshToken(string chatMessage, WebhookAuthentication__c configdata) {
        config = configdata;
        chatMessageId = chatMessage;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator('SELECT Id, Name, ChatSession__c, Message_Type__c, Time_Stamp__c, Body_Message__c,ChatSession__r.Social_ID__r.Social_ID__c FROM ChatMessage__c WHERE ID =:ChatMessageId Limit 1');
   	}
    
    global void execute(Database.BatchableContext BC, List<ChatMessage__c> scope) {
        System.debug('ChatMessageRefreshToken');
	    if(!scope.isEmpty()) {
			for(ChatMessage__c chatMessage : scope){
                String ENDPOINT = (config.prefix__c == null ? '': '/' + config.prefix__c) + config.endpoint__c + '/authentications/refreshToken';
                Map<String, String> jsonBodyMapObject = new Map<String, String>();
                String refreshToken = config.refreshToken__c;
                System.debug(refreshToken);
                jsonBodyMapObject.put('refreshToken', refreshToken);
                System.debug(jsonBodyMapObject);

                HttpRequestService callout = new HttpRequestService();
                callout.setHeader('Content-Type','application/json');
                callout.setTimeout(120000);
                callout.setSingleRequestBody(jsonBodyMapObject);

                HttpResponse resp = null;
                try {
                    if (Test.isRunningTest() == false) {
                        resp = callout.executeCallout('POST', ENDPOINT);
                        System.debug(resp);
                        System.debug('Response: ' + resp.getBody());
                    } else if (Test.isRunningTest() == true) {
                        resp = new HttpResponse();
                        resp.setBody('[{}]');
                        resp.setStatusCode(204);
                    }
                } catch (Exception e) {
                    System.debug('catch');
                    System.debug(e.getLineNumber());
                    System.debug(e.getMessage());
                    // if (callApi_setUnitLockStatus.isHTTP503ServiceUnavailable(e) == true) {
                    //     System.debug('Error 503');
                    //     resp = new HttpResponse();
                    //     resp.setStatusCode(503);
                    // }
                }
                if (resp != null && resp.getStatusCode() == 200) {
                    System.debug('200 OK');
                    Map<String, Object> httpResponseMapObj = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
                    System.debug(httpResponseMapObj);
                    System.debug(httpResponseMapObj.get('accessToken'));
                    response = String.valueOf(httpResponseMapObj.get('result'));
                    accessToken = String.valueOf(httpResponseMapObj.get('accessToken'));
                }
            }
        }
    }
	
	global void finish(Database.BatchableContext BC) {
		if (response == 'success' && accessToken != null || Test.isRunningTest()) {
            List <WebhookAuthentication__c> configList = [SELECT Id, token__c, isActive__c FROM WebhookAuthentication__c WHERE isActive__c = true Limit 1];	
            System.debug(configList);

            if (!configList.isEmpty()) {
                configList.get(0).token__c = accessToken;
                update configList;
            }

            config.token__c = accessToken;
            
            ChatMessageCallout callout;
            callout = new ChatMessageCallout(chatMessageId, config);
            if(!Test.isRunningTest()){
                 Database.executeBatch(callout);
            }
        }
	}
}