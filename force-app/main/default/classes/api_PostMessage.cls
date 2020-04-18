@RestResource(urlMapping = '/postMessage')


global class api_PostMessage {
    
    
    @HttpPost
    global static void doPost () {
        
        List<ChatConfiguration__c> chatConfig = [Select chatQueue__c, sessionExpired__c  From ChatConfiguration__c LIMIT 1];
        
        
        System.debug('postMessage');
        // response
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');
        Boolean isSuccess = false;
        
        
        // request 
        String requestString;
        RestRequest request = RestContext.request;
        
        // Extract string from requestBody
        Blob body = request.requestBody;
        requestString = body.toString();
        
        Map<String, Object> mapResult = (Map<String, Object>)JSON.deserializeUntyped(requestString);
        System.debug(mapResult);
        System.debug(mapResult.get('social_Id'));
        
        
        String socialID = String.valueOf(mapResult.get('social_Id'));
        List<SocialAccount__c> socialAccountList = [SELECT Id, Avatar_URL__c, Display_Name__c, Social_ID__c, Social_Type__c FROM SocialAccount__c WHERE Social_ID__c =:socialID];
        System.debug('socialAccountList'+socialAccountList.size());

        Map<String,SocialAccount__c> socialAccountMapping = new Map<String, SocialAccount__c>();
        
        if (!socialAccountList.isEmpty()) {
            for (SocialAccount__c account : socialAccountList) {
                socialAccountMapping.put(account.Social_ID__c, account);
            }
        }
        String Social_ID = '';
        System.debug(socialAccountMapping);
        if(!socialAccountMapping.containsKey(socialID)){
            System.debug('no account');
            SocialAccount__c socialAccount = new SocialAccount__c();
            System.debug(socialAccount);
            socialAccount.Social_ID__c = String.valueOf(mapResult.get('social_Id'));
            socialAccount.Display_Name__c = String.valueOf(mapResult.get('displayName'));
            socialAccount.Avatar_URL__c = String.valueOf(mapResult.get('avatarURL'));
            String socialType = String.valueOf(mapResult.get('socialType'));
            socialAccount.Social_Type__c = socialType;
            insert socialAccount;
            Social_ID = socialAccount.Id;
            
        }else {
            Social_ID = String.valueOf(socialAccountList.get(0).Id);
        }
        
        
        // check session
        String sessionID;
        List<ChatSession__c> existingSessions = [select Id, SessionID__c, IsExpired__c, Expired_DateTime__c, Social_ID__c from ChatSession__c where   isExpired__c = false and Expired_DateTime__c > :System.now()and Social_ID__c = :Social_ID];
        System.debug('ChatSession: '+ existingSessions.size());

        iigproduct__WebhookAuthentication__c webhookQuery =[SELECT id FROM iigproduct__WebhookAuthentication__c];
        if (!existingSessions.isEmpty()) { // already have session

            System.debug('==============already have session ==============');
            iigproduct__WebhookAuthentication__c webhook =new iigproduct__WebhookAuthentication__c();
            webhook.id=webhookQuery.id;
            webhook.iigproduct__Line_Channel_Token__c = String.valueOf(mapResult.get('channelAccessToken'));
            update webhook;
    
            System.debug('no empty webhook => : '+webhook);
            System.debug(String.valueOf(mapResult.get('channelAccessToken')));

            sessionID = existingSessions.get(0).SessionID__c;
            isSuccess =  CreateChatMessage(mapResult,sessionID,existingSessions.get(0).Id);
            updateExpired(existingSessions,chatConfig.get(0).sessionExpired__c);   
            
        }else if (Social_ID != '' && Social_ID != null) {
            
                //create session
            System.debug('Social_ID: '+ Social_ID);
            sessionID = genUUID();
            System.debug('sessionID: '+sessionID);

            iigproduct__WebhookAuthentication__c webhook =new iigproduct__WebhookAuthentication__c();
            webhook.id=webhookQuery.id;
            webhook.iigproduct__Line_Channel_Token__c = String.valueOf(mapResult.get('channelAccessToken'));
            upsert webhook;
            System.debug('==============new session ==============');

            List<Group> listGroup = getQueueOwnerByName(chatConfig.get(0).chatQueue__c);
            if(!listGroup.isEmpty()){

                Integer randomNumber = Integer.valueof((Math.random() * 1000));
                ChatSession__c chatSession = new ChatSession__c();
                chatSession.Social_ID__c = Social_ID;
                chatSession.SessionID__c = sessionID;
                String sessionExternalId = Social_ID + '_Active_Session_'+ randomNumber;
                chatSession.Chat_Session_External_ID__c = sessionExternalId;
                chatSession.OwnerId = listGroup.isEmpty()?'':listGroup.get(0).Id;
                chatSession.Name = String.valueOf(mapResult.get('displayName')) + ' has requested a LiveChat';
                chatSession.Expired_DateTime__c = System.now();
                
                
                
                try {
               
                    insert chatSession;
                    List<ChatSession__c> insertedSessions = [select Chat_Session_External_ID__c,Expired_DateTime__c,Id, SessionID__c,Auto_Number__c, Name from ChatSession__c where Id = :chatSession.Id LIMIT 1];
            
                    if(!insertedSessions.isEmpty()) {

                        ChatSession__c cs = insertedSessions.get(0);
                        cs.Name = cs.Auto_Number__c + '   ' + String.valueOf(mapResult.get('socialType'));
                        update cs;

                        isSuccess =  CreateChatMessage(mapResult,sessionID,insertedSessions.get(0).Id);
                        System.debug('isSuccess: '+isSuccess);
                        updateExpired(insertedSessions,chatConfig.get(0).sessionExpired__c);
                        
                        
                    }
                    
                }catch(Exception e) {
                    System.debug(e.getStackTraceString());
                    System.debug(e.getMessage());
                    List<ChatSession__c> dupSession = [select Id, SessionID__c from ChatSession__c where Chat_Session_External_ID__c = :sessionExternalId LIMIT 1];

                    if(!dupSession.isEmpty()) {
                        sessionID = dupSession.get(0).SessionID__c;
                    }
                } 
                isSuccess = true; 
                
            }else{
                isSuccess = false; 
                
            }
            
            
        }
        
        // response
        if (isSuccess == true) {
            response.statusCode = 200;
            response.responseBody = Blob.valueOf('{"result" : "success", "sessionID" : ' + '"' + sessionID + '"' + '}');
        } else {
            response.statusCode = 500;
            response.responseBody = Blob.valueOf('{"result" : "error", "errorMessage": "FAILED"}');
        }
        
    }
    
    // create chat message
    public static Boolean CreateChatMessage (Map<String,Object> mapResult, String sessionID, Id chatSessionId){
        
        System.debug('CreateChatMessage => mapResult: '+mapResult);
        System.debug('CreateChatMessage => sessionID: '+sessionID);
        System.debug('CreateChatMessage => chatSessionId: '+chatSessionId);
        
        

        ChatMessage__c chatMessage = new ChatMessage__c();
        String messageExternalId = String.valueOf(mapResult.get('social_Id')) + genUUID();
        System.debug(String.valueOf(mapResult.get('messageType')));
        chatMessage.Message_Type__c = String.valueOf(mapResult.get('messageType'));
        System.debug(String.valueOf(mapResult.get('social_Id')));
        chatMessage.Sender__c = String.valueOf(mapResult.get('social_Id'));
        System.debug(String.valueOf(mapResult.get('timestamp')));
        System.debug(datetime.newinstance(long.valueOf(String.valueOf(mapResult.get('timestamp')))));
        chatMessage.Time_Stamp__c = datetime.newinstance(long.valueOf(String.valueOf(mapResult.get('timestamp'))));
        System.debug(String.valueOf(mapResult.get('message')));
        switch on chatMessage.Message_Type__c {
            when 'file' {
                chatMessage.Body_Message__c = String.valueOf(mapResult.get('message')) + (mapResult.get('fileName') == null || mapResult.get('fileName') == '' ? '' : (';;' + String.valueOf(mapResult.get('fileName')))) ; 
            }
            // when 'sticker' {
            // chatMessage.Message_Type__c = 'text';
            // chatMessage.Body_Message__c = sessionList.get(0).Social_ID__r.Display_Name__c + ' sent you a sticker.';
            // }
            when 'video' {
                chatMessage.Message_Type__c = 'file';
                chatMessage.Body_Message__c = String.valueOf(mapResult.get('message'));
            }
            when else {
                chatMessage.Body_Message__c = String.valueOf(mapResult.get('message'));
            }
        }
        
        chatMessage.ChatSession__c = chatSessionId;
        chatMessage.IsOutbound__c = false;
        chatMessage.Chat_Message_External_ID__c = messageExternalId;
        System.debug(chatMessage);
        insert chatMessage;
        return  true;
        
    }
    
    
    public static void  updateExpired(List<ChatSession__c> sessionList, Decimal expiredMinute){
        
        Integer minute = Integer.valueOf(expiredMinute);
        Datetime expiredDT = sessionList.get(0).Expired_DateTime__c;
        System.debug('expiredDT : '+expiredDT);
        
        if(expiredDT != null){
            sessionList.get(0).Expired_DateTime__c  =  (System.now().addMinutes(minute));
        }
        update sessionList;
        System.debug('updateExpiredDT : '+sessionList.get(0).Expired_DateTime__c);
    }
    
    public static String genUUID(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }
    
    public static List<Group> getQueueOwnerByName(String queueName) {
        return [select Id from Group where Type = 'Queue' AND Name =: queueName  LIMIT 1];
    }
}