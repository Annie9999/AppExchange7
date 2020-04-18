global class ChatMessageAuthorization implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    
    private string chatMessageId;
    private string accessToken;
    private string refreshToken;
    private string response;
    private WebhookAuthentication__c config = new WebhookAuthentication__c();

    global ChatMessageAuthorization(String id, WebhookAuthentication__c configdata) {
        chatMessageId = id;
        config = configdata;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator('SELECT Id, Name, ChatSession__c, Message_Type__c, Time_Stamp__c, Body_Message__c,ChatSession__r.Social_ID__r.Social_ID__c FROM ChatMessage__c WHERE ID =:ChatMessageId Limit 1');
   	}
    
    global void execute(Database.BatchableContext BC, List<ChatMessage__c> scope) {
        System.debug('ChatMessageAuthorization');
	    if(!scope.isEmpty()) {
			for(ChatMessage__c chatMessage : scope){
                System.debug(config);

                String ENDPOINT = (config.prefix__c == null ? '': '/' + config.prefix__c) + config.endpoint__c + '/authentications/login';
                Map<String, String> jsonBodyMapObject = new Map<String, String>();

                jsonBodyMapObject.put('username', config.userName__c);
                jsonBodyMapObject.put('password', config.password__c);

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
                    refreshToken = String.valueOf(httpResponseMapObj.get('refreshToken')); 
                }
            }
        }
    }
	
	global void finish(Database.BatchableContext BC) {
		if (response == 'success' && accessToken != null && refreshToken != null || Test.isRunningTest()) {
            List <WebhookAuthentication__c> configList = [SELECT Id, token__c, isActive__c,refreshToken__c FROM WebhookAuthentication__c WHERE isActive__c = true Limit 1];	
            System.debug(configList);

            if (!configList.isEmpty()) {
                configList.get(0).token__c = accessToken;
                configList.get(0).refreshToken__c = refreshToken;
                update configList;
            }

            config.token__c = accessToken;
            config.refreshToken__c = refreshToken;

            ChatMessageCallout callout;
            callout = new ChatMessageCallout(chatMessageId, config);
            if(!Test.isRunningTest()){
               Database.executeBatch(callout);
            }
        }
		
	}
}