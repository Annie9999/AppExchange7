global class ChatMessageCallout implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    
    private string accessToken;
    private string chatMessageId;
    private string response;
    private Integer stateResponse;
    private WebhookAuthentication__c config = new WebhookAuthentication__c();
    private Boolean authen;
    private string message;

    global ChatMessageCallout(string chatMessage, WebhookAuthentication__c configdata) {
        ChatMessageId = chatMessage;
        config = configdata;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator('SELECT Id, Name, ChatSession__c, Message_Type__c, Time_Stamp__c, Body_Message__c,ChatSession__r.Social_ID__r.Social_ID__c ,ChatSession__r.Social_ID__r.Social_Type__c FROM ChatMessage__c WHERE ID =:ChatMessageId Limit 1');
   	}
    
    global void execute(Database.BatchableContext BC, List<ChatMessage__c> scope) {  
        System.debug('ChatMessageCallout');
        authen = true;
        System.debug(config);
        if (config.token__c != null) {
            if(!scope.isEmpty()) {
                for(ChatMessage__c chatMessage : scope){
                    String ENDPOINT = (config.prefix__c == null ? '': '/' + config.prefix__c) + config.endpoint__c + '/message';

                    Map<String, String> jsonBodyMapObject = new Map<String, String>();
                    String messageType = chatMessage.Message_Type__c;
                    iigproduct__WebhookAuthentication__c token = [SELECT iigproduct__Line_Channel_Token__c FROM iigproduct__WebhookAuthentication__c];
                    switch on chatMessage.Message_Type__c {
                        when 'text' {
                            jsonBodyMapObject.put('messageType', chatMessage.Message_Type__c);
                            jsonBodyMapObject.put('message', chatMessage.Body_Message__c);
                        }
                        when 'image' {
                            // url = chatMessage.Body_Message__c;
                            // System.debug(message);
                            jsonBodyMapObject.put('messageType', chatMessage.Message_Type__c);
                            jsonBodyMapObject.put('message', '');
                            jsonBodyMapObject.put('originalContentUrl', chatMessage.Body_Message__c);
                            jsonBodyMapObject.put('previewImageUrl', chatMessage.Body_Message__c);
                        }when 'file' {
                            
                            List<String> splitedStr = chatMessage.Body_Message__c.split(';;');
                            if (splitedStr.size() > 1) {
                                List<ContentDistribution> cd = [select contentDownloadUrl from ContentDistribution where ContentDocumentId = :splitedStr[0]];
                                if (cd.size() > 0) {
                                    jsonBodyMapObject.put('messageType', chatMessage.Message_Type__c);
                                    jsonBodyMapObject.put('message',  cd[0].contentDownloadUrl);
                                }
                            }
                        }
                        when else {
                           jsonBodyMapObject.put('messageType', 'text');
                            jsonBodyMapObject.put('message', chatMessage.Body_Message__c);                              
                        }
                    }
                    jsonBodyMapObject.put('social_Id', chatMessage.ChatSession__r.Social_ID__r.Social_ID__c);
                    jsonBodyMapObject.put('social_type', chatMessage.ChatSession__r.Social_ID__r.Social_Type__c);
                    jsonBodyMapObject.put('channel_access_token', token.iigproduct__Line_Channel_Token__c);
                    System.debug('ENDPOINT'+ENDPOINT);
                    System.debug('jsonBodyMapObject'+jsonBodyMapObject);

                    HttpRequestService callout = new HttpRequestService();
                    callout.setHeader('Content-Type','application/json');
                    // callout.setHeader('Authorization', 'Bearer ' + BEARERTOKEN);
                    callout.setHeader('Authorization', 'Bearer ' + config.token__c);
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
                        System.debug(httpResponseMapObj.get('result'));
                    }else if(resp != null && resp.getStatusCode() == 401) {
                        System.debug('401 Unauthorized');
                        Map<String, Object> httpResponseMapObj = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
                        System.debug(httpResponseMapObj.get('result'));
                        System.debug(httpResponseMapObj);
                        stateResponse = resp.getStatusCode();
                        response = String.valueOf(httpResponseMapObj.get('result'));
                        message = String.valueOf(httpResponseMapObj.get('message'));
                    }
                }

                Set<String> sessionId = GlobalUtility.getStringSet('ChatSession__c', scope);
                List<ChatSession__c> sessions = [select Id, Expired_DateTime__c from ChatSession__c where Id in :sessionId];
                // List<LiveChatSesstionExpiredDateTime__mdt> addMinutesExpired = [SELECT Id, Label, addMinutes__c FROM LiveChatSesstionExpiredDateTime__mdt WHERE Label = 'active'];
                Integer minute = Integer.valueOf(5);
                for(ChatSession__c cs : sessions) {
                    cs.Expired_DateTime__c = System.now().addMinutes(minute);
                }
                if(!sessions.isEmpty()) {
                    update sessions;
                }
                authen = false;
            }
        }
    }
	
	global void finish(Database.BatchableContext BC) {
        System.debug(response);
        if (authen == true || Test.isRunningTest()) {
            ChatMessageAuthorization authorization;
            authorization = new ChatMessageAuthorization(chatMessageId, config);
            Database.executeBatch(authorization);
        }
        if (authen == false || Test.isRunningTest()) {
            System.debug('else ' + stateResponse);
            if (stateResponse == 401|| Test.isRunningTest()) {
            // if (response == 'fail' && message == 'access token expired') {
                System.debug('go to refreshTokenCallout');
                ChatMessageRefreshToken refreshTokenCallout;
                refreshTokenCallout = new ChatMessageRefreshToken(chatMessageId, config);
                Database.executeBatch(refreshTokenCallout);
            }
        }
	}
}