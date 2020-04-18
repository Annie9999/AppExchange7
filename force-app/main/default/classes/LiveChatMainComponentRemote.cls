global without sharing class LiveChatMainComponentRemote {
	global static String DATE_FORMAT = 'EEE, d MMM yyyy';
	global static String TIME_FORMAT = 'HH:mm';
	global static Integer MAX_RECORD_OF_MESSAGE = 15;
    global static List<String> IMAGE_SUFFIX = new List<String>{
		'jpg','png','jpeg','webp'
	};
    global static String PREFIX_IMG = 'data:image/png;base64, ';
    global static String SUFFIX_FILE_LIVE_CHAT = '(Live-Chat Uploaded)';

    global class MessageInTime{
      @AuraEnabled
      global String timeStamp {get;set;}
      @AuraEnabled
      global String owner {get;set;}
      @AuraEnabled
      global String ownerName {get;set;}
      @AuraEnabled
      global String text {get;set;} 
      @AuraEnabled
      global String type {get;set;} 
      @AuraEnabled
      global String urlContent {get;set;} 
      @AuraEnabled
      global List<MapMessage> mapObjects{get;set;}
      @AuraEnabled
      global Boolean isHasMapMessage{get;set;}
      /* 
      global MessageInTime(String timeStamp, String owner, String text){
        this.timeStamp = timeStamp;
        this.owner = owner;
        this.text = text;
      }
      */
    }
    global class MapMessage{
        @AuraEnabled
      global Location location {get;set;}
      @AuraEnabled
      global String title {get;set;}
    }
     global class Location{
        @AuraEnabled
      global String Latitude {get;set;}
      @AuraEnabled
      global String Longitude {get;set;}
      
      global Location(String Latitude,String Longitude){
          this.Longitude = Longitude;
          this.Latitude = Latitude;
      }
    }
    global class MessageCollectionInDay{
      @AuraEnabled
      global String sentDate {get;set;}
      @AuraEnabled
      global List<MessageInTime> messages {get;set;}
      
      global MessageCollectionInDay(String sentDate, List<MessageInTime> messages){
        this.sentDate = sentDate;
        this.messages = messages;
      }
    }

    global class Picklist{
        @AuraEnabled
        global String label {get;set;}
        @AuraEnabled
        global String value {get;set;}
        
        global Picklist(String label,String value){
            this.label = label;
            this.value = value;
        }
    }

    global class ResponseGetInitData{
      @AuraEnabled
      global String clientName {get;set;}
      @AuraEnabled
      global String socialName {get;set;}
      @AuraEnabled
      global User provider {get;set;}
       @AuraEnabled
      global String lastDateSession {get;set;}
        @AuraEnabled
      global ChatSession__c chatSession {get;set;}
      @AuraEnabled
      global List<MessageCollectionInDay> messageCollection {get;set;}
    //   @AuraEnabled
    //   global Map<String, List<MessageInTime>> messageCollectionMap {get;set;}
      @AuraEnabled
      global Boolean isHasPreviousMessage {get;set;}
      @AuraEnabled
      global ChatMessage__c previousMessage {get;set;}
       @AuraEnabled
      global List<String> chatMessageIdList {get;set;}
      @AuraEnabled
      global Boolean isDisableInput {get;set;}
       @AuraEnabled
      global List<PicklistOption> chatTopicOptions {get;set;}
    }

    @AuraEnabled
	global static ResponseGetInitData getInitData(String recordId){
        ResponseGetInitData responseData = new ResponseGetInitData();
        getChatCollectionData(recordId,responseData,null, true);

        // responseData.chatTopicOptions = GlobalUtility.getPicklistOptions('ChatSession__c', 'Chat_Topic__c');
        responseData.chatTopicOptions = null;
        return responseData;
    }
    @AuraEnabled
	global static String getStrtest(String teststring){
        return teststring;
    }

    @AuraEnabled
	global static ResponseGetInitData getMoreData(String recordId,ChatMessage__c previosChatmessage, Boolean useAllSession){
        System.debug('previos ' + previosChatmessage);
        ResponseGetInitData responseData = new ResponseGetInitData();
        getChatCollectionData(recordId,responseData,previosChatmessage, useAllSession);
        // for (MessageCollectionInDay res : responseData.messageCollection) {
        //     System.debug('res ' + res);
        // }

        return responseData;
    }
	global static void getChatCollectionData(String recordId,ResponseGetInitData responseData,ChatMessage__c previousMessage, Boolean useAllSession){
        List<MessageCollectionInDay> results = new List<MessageCollectionInDay>();
        User currentUser = GlobalUtility.getCurrentUser();
        // Map<String, List<MessageInTime>> resultsMap = new Map<String, List<MessageInTime>>();
        String clientName;
        String socialName;
        ChatSession__c chatSession;
        responseData.isHasPreviousMessage = false;
        List<ChatSession__c> sessionLst = [select Id, Social_ID__c, CreatedDate,Owner.Id,Owner.Name,Social_ID__r.Display_Name__c,
                                                Social_ID__r.Social_Type__c,Is_Auto_Expired__c,Social_ID__r.Owner.Id,Social_ID__r.Owner.Name,IsExpired__c,
                                                Chat_Note__c,Chat_Topic__c,Others_Topic__c, Name from ChatSession__c where Id = :recordId];
        List<ChatMessage__c> chatMessages = new  List<ChatMessage__c>();
        List<String> chatMessageIds = new  List<String>();
        if (previousMessage == null) {
            chatMessages = [SELECT Id, Body_Message__c, Sender__c, Time_Stamp__c, Message_Type__c, createdBy.Id, createdBy.name, IsOutbound__c,
                                             ChatSession__r.Owner.Id, ChatSession__r.Owner.Name, ChatSession__r.Social_ID__r.Display_Name__c,ChatSession__r.Social_ID__r.Social_Type__c,ChatSession__r.Is_Auto_Expired__c,
                                             ChatSession__r.Social_ID__r.Owner.Id, ChatSession__r.Social_ID__r.Owner.Name, ChatSession__r.IsExpired__c,
                                             ChatSession__r.CreatedDate,ChatSession__r.Chat_Note__c,ChatSession__r.Chat_Topic__c,ChatSession__r.Others_Topic__c, 
                                             ChatSession__r.Social_ID__c 
                                            FROM ChatMessage__c 
                                            Where ChatSession__c =: recordId
                                            Order by Time_Stamp__c DESC limit : MAX_RECORD_OF_MESSAGE+1];
        }else {
            chatMessages = [SELECT Id, Body_Message__c, Sender__c, Time_Stamp__c, Message_Type__c, createdBy.Id, createdBy.name, IsOutbound__c,
                                             ChatSession__r.Owner.Id, ChatSession__r.Owner.Name, ChatSession__r.Social_ID__r.Display_Name__c,ChatSession__r.Social_ID__r.Social_Type__c,ChatSession__r.Is_Auto_Expired__c,
                                             ChatSession__r.Social_ID__r.Owner.Id, ChatSession__r.Social_ID__r.Owner.Name, ChatSession__r.IsExpired__c,
                                             ChatSession__r.CreatedDate,ChatSession__r.Chat_Note__c,ChatSession__r.Chat_Topic__c,ChatSession__r.Others_Topic__c, 
                                             ChatSession__r.Social_ID__c  
                                            FROM ChatMessage__c 
                                            Where ChatSession__c =: recordId and Time_Stamp__c <= :previousMessage.Time_Stamp__c and Id != :previousMessage.Id
                                            Order by Time_Stamp__c DESC limit : MAX_RECORD_OF_MESSAGE+1];
            if (chatMessages.size() < 1) {
                chatMessages.add(previousMessage);
            }else {
                chatMessages.add(0,previousMessage);
            }
        }

        if(useAllSession) {
            if(!sessionLst.isEmpty()) {
                ChatSession__c currentSession = sessionLst.get(0);
                ChatMessage__c conditionMessage = previousMessage != null? previousMessage : (chatMessages.size() > 0? chatMessages.get(chatMessages.size() - 1) : null);
                List<ChatMessage__c> previousSessionMessages = getPreviousMessageThroughSession(currentSession, conditionMessage);
                for(Integer i = 0; i < previousSessionMessages.size(); i++) {
                    if(chatMessages.size() + 1 > MAX_RECORD_OF_MESSAGE + 1) {
                        break;
                    }
                    chatMessages.add(previousSessionMessages.get(i));          
                }
            }
        }

        System.debug('chatMessage ' + chatMessages);
        System.debug('chatMessage ' + chatMessages.size());
        if (chatMessages.size() > 0) {
            if (chatMessages.size() > MAX_RECORD_OF_MESSAGE) {
                responseData.isHasPreviousMessage = true;
                responseData.previousMessage = chatMessages.remove(MAX_RECORD_OF_MESSAGE);
            }
            System.debug('responseData.previousMessage' +  responseData.previousMessage);
            chatMessages = reIndexList(chatMessages);
            DateTime thisDate = chatMessages[0].Time_Stamp__c;
            chatSession = sessionLst.get(0) ;
            List<MessageInTime> messageOnThisDay = new List<MessageInTime>();
            socialName = sessionLst.get(0) != null 
                        && sessionLst.get(0).Social_ID__r != null ?
                        sessionLst.get(0).Social_ID__r.Display_Name__c : null;
            

            for (ChatMessage__c eachMessage : chatMessages) {
                chatMessageIds.add(eachMessage.Id);
                MessageInTime message = new MessageInTime();
                message.timeStamp = eachMessage.Time_Stamp__c.format(TIME_FORMAT);
                message.owner = eachMessage.IsOutbound__c ? 'provider' : 'client' ;
                
                clientName = clientName == null && !eachMessage.IsOutbound__c ? eachMessage.ChatSession__r.Social_ID__r.owner.Id : null;
                message.ownerName = eachMessage.IsOutbound__c ? eachMessage.createdBy.name : socialName ;
                message.type = eachMessage.Message_Type__c;
                message.mapObjects = new List<MapMessage>();
                message.isHasMapMessage = false;
                switch on eachMessage.Message_Type__c {
                    when 'text' {
                        message.text = eachMessage.Body_Message__c;
                    }
                    when 'image' {
                        if(!eachMessage.IsOutbound__c){
                            switch on eachMessage.ChatSession__r.Social_ID__r.Social_Type__c {
                                when  'Line'{
                                    message.text = getImageFromLine(eachMessage.Body_Message__c);
                                    System.debug('message.text: '+message.text);
                                }
                                 when  'Facebook'{
                                    message.text = getImageFromFacebook(eachMessage.Body_Message__c);        
                                }
                                when else {
                                    message.text = eachMessage.Body_Message__c;
                                }
                            }
                           
                        }else {
                            message.text = eachMessage.Body_Message__c;
                        }
                                        
                        // message.text = eachMessage.IsOutbound__c ? eachMessage.Body_Message__c : getImageFromLine(eachMessage.Body_Message__c);
                    }
                    when 'file' {
                        if (eachMessage.ChatSession__r.Social_ID__r.Social_Type__c == 'Facebook' && !eachMessage.IsOutbound__c) {
                            message.urlContent = eachMessage.Body_Message__c;    
                            message.text = 'File From Facebook';                        
                        } else {
                            List<String> splitedStr = eachMessage.Body_Message__c.split(';;');
                            if (splitedStr.size() > 1) {
                                    if (eachMessage.IsOutbound__c) {
                                        ContentDistribution cd = getContentDistributionDetail(splitedStr[0]);
                                        if (cd != null) {
                                            message.text =  splitedStr[1];
                                            message.urlContent = cd.contentDownloadUrl;
                                        }
                                    }else {
                                            message.text = splitedStr[1];
                                            message.urlContent = splitedStr[0];
                                    }
                            }
                        }
                       
                    }
                    when 'location' {
                        System.debug('location ' + eachMessage.Body_Message__c);
                        List<String> splitedStr = eachMessage.Body_Message__c.split(';;');
                        
                        if (splitedStr.size() > 1) {
                            List<String> locationStr = splitedStr[0].split('::');
                         System.debug('locationStr ' + locationStr);

                            if(locationStr.size() > 1){
                                MapMessage mapMessage = new MapMessage();
                                mapMessage.location = new Location(locationStr[0],locationStr[1]);
                                mapMessage.title = splitedStr[1];
                                message.mapObjects.add(mapMessage);
                                message.isHasMapMessage = true;
                                System.debug('location ' + message.mapObjects);
                            }else {
                                message.text = eachMessage.Body_Message__c;
                                message.type = 'text';
                            }
                        }else {
                            message.text = eachMessage.Body_Message__c;
                            message.type = 'text';
                        }
                        
                    }
                    when 'transfer' {
                        List<String> splitedStr = eachMessage.Body_Message__c.split('->');
                        message.text =splitedStr[0];
                        message.owner = splitedStr.size() > 1 ? splitedStr[1] : ''; 
                        message.ownerName = eachMessage.createdBy.name ;
                       
                    }
                    when 'endchat' {
                        message.text = eachMessage.Body_Message__c;
                        message.ownerName = eachMessage.Body_Message__c.contains('Expired') ? '' : eachMessage.createdBy.name ;
                      
                    }
                    when else {
                        message.text = eachMessage.Body_Message__c;
                       
                    }
                }
                if(eachMessage.Time_Stamp__c.Date() == thisDate.Date()) {
                    messageOnThisDay.add(message);
                } else {
                    results.add(new MessageCollectionInDay(thisDate.format(DATE_FORMAT),
                                                            messageOnThisDay));
                    // resultsMap.put(thisDate.format(DATE_FORMAT),messageOnThisDay);
                    messageOnThisDay = new List<MessageInTime>();

                    messageOnThisDay.add(message);
                    thisDate = eachMessage.Time_Stamp__c;
                }
                
            }


            results.add(new MessageCollectionInDay(thisDate.format(DATE_FORMAT),
                                                    messageOnThisDay));
            // resultsMap.put(thisDate.format(DATE_FORMAT),messageOnThisDay);

            responseData.lastDateSession = thisDate.format(DATE_FORMAT);
            responseData.isDisableInput = currentUser.Id != chatSession.Owner.Id || chatSession.IsExpired__c;
            responseData.messageCollection = results; 
            responseData.chatMessageIdList = chatMessageIds;
            
        }else {
            // in case Chat messge list is empty
            List<ChatSession__c> sessionlist = [SELECT Owner.Id, Owner.Name, Social_ID__r.Display_Name__c, 
            Social_ID__r.Social_Type__c, Is_Auto_Expired__c, Social_ID__r.Owner.Name, IsExpired__c, CreatedDate, 
            Chat_Note__c, Chat_Topic__c, Others_Topic__c, Name FROM ChatSession__c where id =: recordId];
            if (sessionlist.size() > 0) {
                chatSession = sessionlist[0];
            }
        }
        /* return Response */
       
        // responseData.messageCollectionMap = resultsMap; 
        responseData.clientName = clientName;
        responseData.socialName = socialName;
        responseData.provider = currentUser;
        responseData.chatSession = chatSession;

    System.debug(responseData.messageCollection);
        
        // System.debug('currentUser' + currentUser);
        // System.debug('chatSession.Owner.Id ' + chatSession.Owner.Name);
        // System.debug('responseData.isDisableInput ' + responseData.isDisableInput);
    }

	global static List<ChatMessage__c> reIndexList(List<ChatMessage__c> chatMessages){
        List<ChatMessage__c> result = new List<ChatMessage__c>();
        result.add(chatMessages.remove(0));
        for (ChatMessage__c cm : chatMessages) {
            result.add(0,cm);
        }
        return result;
    }
    global class MessageModel{
        @AuraEnabled
        global String messageType {get;set;}
        @AuraEnabled
        global String sender {get;set;}
        @AuraEnabled
        global String text {get;set;} 
     }

    global class ResponseSaveMessage{
        @AuraEnabled
        global String messageType {get;set;}
        @AuraEnabled
        global Boolean isSuccess {get;set;}
        @AuraEnabled
        global String url {get;set;} 
        @AuraEnabled
        global String fileName {get;set;}
         @AuraEnabled
        global String chatMessageId {get;set;}
     }

    @AuraEnabled
	global static ResponseSaveMessage saveMessageObject(String recordId,String messageStringModel){
        ResponseSaveMessage res = new ResponseSaveMessage();
        /**
        var messageModel = {
			messageType : 'image',
			sender : component.get("v.provider").Id,
			text : documentId
		};
         */
        System.debug('messageStringModel ' + messageStringModel);
        
		MessageModel messageModel = (MessageModel)JSON.deserialize(messageStringModel, MessageModel.class);
        System.debug('model ' + messageModel);
        switch on messageModel.messageType {
            when 'text' {
                res.chatMessageId = insertTextMessage(recordId,messageModel);
            }
            when 'imagefile' {
                    ContentVersion cv = getContentVersionDetail(messageModel.text);
                    if (cv != null) {
                        if (IMAGE_SUFFIX.contains(cv.contentdocument.fileExtension.toLowerCase())) {
                            messageModel.messageType = 'image';
                        }else {
                            messageModel.messageType = 'file';
                        }
                         /** messageModel.text as document id */
                        ContentDistribution cd = makePublicFile(cv);
                        if (messageModel.messageType == 'image') {
                            res.chatMessageId = insertImageMessage(cd.contentDownloadUrl,recordId,messageModel);
                            res.isSuccess = true;
                            res.url = cd.contentDownloadUrl;
                            res.messageType = messageModel.messageType;
                        }else {
                            String fileName = cv.contentdocument.Title + '.' + cv.contentdocument.fileExtension;
                            res.chatMessageId = insertFileMessage(fileName,recordId,messageModel);
                            res.isSuccess = true;
                            res.url = cd.contentDownloadUrl;
                            res.fileName = fileName;
                            res.messageType = messageModel.messageType;
                        }
                    }
            }
            when else {
                
            }
        }
        return res;
    }

    global static String insertTextMessage(String recordId, MessageModel messageModel){
        // check expire chat session
        ChatMessage__c chatMessage = new ChatMessage__c();
        chatMessage.Body_Message__c = messageModel.text;
        chatMessage.Sender__c = messageModel.sender;
        chatMessage.Time_Stamp__c = System.now();
        chatMessage.Message_Type__c = messageModel.messageType;
        chatMessage.ChatSession__c = recordId;
        chatMessage.IsOutbound__c = true;

        insert chatMessage;
        return chatMessage.Id;
    }

    global static ContentVersion getContentVersionDetail(String documentId){
        List<ContentVersion> cv = [select id, contentdocumentid, contentdocument.fileExtension, contentdocument.Title from contentversion where contentdocumentid = :documentId];
        if (cv.size() > 0) {
            return cv[0];
        }
        return null;
    }
     global static ContentVersion getContentVersionDetailById(String id){
        List<ContentVersion> cv = [select Id, contentdocumentid, contentdocument.fileExtension, contentdocument.Title from contentversion where id = :id];
        if (cv.size() > 0) {
            return cv[0];
        }
        return null;
    }

    @AuraEnabled
    global static ContentDistribution getContentDistributionDetail(String documentId){
            List<ContentDistribution> cd = [select ContentVersionId,DistributionPublicUrl, contentDownloadUrl from ContentDistribution where ContentDocumentId = :documentId];
            if (cd.size() > 0) {
                return cd[0];
            }
            return null;
     }
    global static ContentDistribution makePublicFile(ContentVersion cv){

        ContentDistribution cd = new ContentDistribution();
        cd.Name = String.valueOf(cv.id);
        cd.ContentVersionId = cv.id;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;
        insert cd;
        
        ContentDocument doc = [select id, Title from ContentDocument where id = :cv.contentdocumentid];
        doc.Title += ' ' + SUFFIX_FILE_LIVE_CHAT;
        update doc;

        ContentDistribution newcd = getContentDistributionDetail(cv.contentdocumentid);
       
        return newcd;
    }
    

    global static String insertImageMessage(String url, String recordId, MessageModel messageModel){
        ChatMessage__c chatMessage = new ChatMessage__c();
        chatMessage.Body_Message__c = url;
        chatMessage.Sender__c = messageModel.sender;
        chatMessage.Time_Stamp__c = System.now();
        chatMessage.Message_Type__c = messageModel.messageType;
        chatMessage.ChatSession__c = recordId;
        chatMessage.IsOutbound__c = true;

        insert chatMessage;
        return chatMessage.Id;
    }
    global static String insertFileMessage(String fileName, String recordId, MessageModel messageModel){
        ChatMessage__c chatMessage = new ChatMessage__c();
        chatMessage.Body_Message__c = messageModel.text + ';;' + fileName;
        chatMessage.Sender__c = messageModel.sender;
        chatMessage.Time_Stamp__c = System.now();
        chatMessage.Message_Type__c = messageModel.messageType;
        chatMessage.ChatSession__c = recordId;
        chatMessage.IsOutbound__c = true;

        insert chatMessage;
        return chatMessage.Id;

    }



    @AuraEnabled
	global static String updateChatSessionIfEndChatOccured(String recordId, String chatTopic, String chatNote,  String messageStringModel ,Boolean isAutoExpired){
        System.debug('updateChatSessionIfEndChatOccured');
        // System.debug('messageStringModel' + messageStringModel);
        // System.debug('isAutoExpired' + isAutoExpired);
        MessageModel messageModel = (MessageModel)JSON.deserialize(messageStringModel, MessageModel.class);
        List<ChatMessage__c> chatMessages = [SELECT Id,Time_Stamp__c 
                                                FROM ChatMessage__c 
                                                WHERE chatSession__c = :recordId and isOutBound__c = true 
                                                ORDER BY CreatedDate limit 1];
            
        List<ChatSession__c> chatSessions = [SELECT Id,Chat_Topic__c,Others_Topic__c,Chat_Note__c,End_DateTime__c,
                                                    First_Responded_DateTime__c,IsExpired__c ,Is_Auto_Expired__c,
                                                    Social_id__r.Social_id__c, Expired_DateTime__c, Chat_Session_External_ID__c 
                                                FROM ChatSession__c WHERE Id = :recordId limit 1];
        // System.debug('hatSessions[0].IsExpired__c' + chatSessions[0].IsExpired__c);         
        // System.debug('hchatSessions.size()' + chatSessions.size());         
        Boolean isExpired = chatSessions[0].IsExpired__c;
        String chatMessageId;
        if (chatSessions.size() > 0) {
            ChatSession__c thisSession = chatSessions[0];
            thisSession.Chat_Session_External_ID__c = api_PostMessage.genUUID() + '_' + System.now().format();
            thisSession.Chat_Topic__c = chatTopic;
            // thisSession.Others_Topic__c = othersTopic;
            thisSession.Chat_Note__c = chatNote == ''? null  : chatNote;
            thisSession.IsExpired__c = true;
            thisSession.Is_Auto_Expired__c = isAutoExpired;
            thisSession.End_DateTime__c = System.now();
            thisSession.First_Responded_DateTime__c = chatMessages.size() > 0 ? chatMessages[0].Time_Stamp__c : null;
            thisSession.Expired_DateTime__c = null;
            //requestResetUserStage(new List<String>{thisSession.Social_id__r.Social_id__c});
            update thisSession;
           
            if (!isAutoExpired && !isExpired) {
                // System.debug('2hchatSessions.size()' + chatSessions.size());         
                chatMessageId = insertSystemMessage(recordId, messageModel);
            }
            
        }
        
        return chatMessageId;
    }

    /*global static void requestUpdateUserStage(List<String> socialId,String newStage){
       List <SansiriLiveChatAPI__c> configList = [SELECT Id, userName__c, password__c, token__c, refreshToken__c, endpoint__c, isActive__c, prefix__c FROM SansiriLiveChatAPI__c WHERE isActive__c = true Limit 1];
        if (configList.size() > 0) {
            SansiriLiveChatAPI__c config = configList[0];
            String ENDPOINT = (config.prefix__c == null ? '': '/' + config.prefix__c) + config.endpoint__c + '/update_user_stage';
            Map<String, String> jsonBodyMapObject = new Map<String, String>();

            jsonBodyMapObject.put('username', config.userName__c);
            jsonBodyMapObject.put('password', config.password__c);
            jsonBodyMapObject.put('userIds', String.join(socialId, ','));
            jsonBodyMapObject.put('stage', newStage);

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
                if (callApi_setUnitLockStatus.isHTTP503ServiceUnavailable(e) == true) {
                    System.debug('Error 503');
                    resp = new HttpResponse();
                    resp.setStatusCode(503);
                }
            }

             if (resp != null && resp.getStatusCode() == 200) {
                System.debug('200 OK');
            }

        }
        
    }*/

    /* global static void requestResetUserStage(List<String> socialId){
        List <SansiriLiveChatAPI__c> configList = [SELECT Id, userName__c, password__c, token__c, refreshToken__c, endpoint__c, isActive__c, prefix__c FROM SansiriLiveChatAPI__c WHERE isActive__c = true Limit 1];
        if (configList.size() > 0) {
            SansiriLiveChatAPI__c config = configList[0];
            String ENDPOINT = (config.prefix__c == null ? '': '/' + config.prefix__c) + config.endpoint__c + '/reset_user_stage';
            Map<String, String> jsonBodyMapObject = new Map<String, String>();

            jsonBodyMapObject.put('username', config.userName__c);
            jsonBodyMapObject.put('password', config.password__c);
            jsonBodyMapObject.put('userIds', String.join(socialId, ','));
          
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
                if (callApi_setUnitLockStatus.isHTTP503ServiceUnavailable(e) == true) {
                    System.debug('Error 503');
                    resp = new HttpResponse();
                    resp.setStatusCode(503);
                }
            }

             if (resp != null && resp.getStatusCode() == 200) {
                System.debug('200 OK');
            }

        }
        
    }*/

     @AuraEnabled
	global static String updateChatSessionIfTransferChatOccured(String recordId, String newOwnerId, String transferMessage, String newOwnerType,
                        String messageStringModel){
        MessageModel messageModel = (MessageModel)JSON.deserialize(messageStringModel, MessageModel.class);
        List<ChatSession__c> chatSessions = [SELECT Id, Transfer_Message__c, OwnerId, Social_ID__r.Display_Name__c,
                                                    Social_ID__r.FirstName__c , Social_ID__r.LastName__c 
                                                FROM ChatSession__c WHERE Id = :recordId limit 1];
        String chatMessageId;
        if (chatSessions.size() > 0) {
            ChatSession__c thisSession = chatSessions[0];
            thisSession.Transfer_Message__c = transferMessage;
            thisSession.OwnerId = newOwnerId;
            
            update thisSession;
            chatMessageId = insertSystemMessage(recordId, messageModel);

            if (newOwnerType == 'People') {
                sentNotificationTaskToNewOwner(thisSession);
            }
        }
        return chatMessageId;
    }
     private static String insertSystemMessage(String recordId, MessageModel messageModel){
        System.debug('insertSystemMessage' + messageModel);
        ChatMessage__c chatMessage = new ChatMessage__c();
        chatMessage.Body_Message__c = messageModel.text;
        chatMessage.Sender__c = messageModel.sender;
        chatMessage.Time_Stamp__c = System.now();
        chatMessage.Message_Type__c = messageModel.messageType;
        chatMessage.ChatSession__c = recordId;
        chatMessage.IsOutbound__c = true;
        chatMessage.Is_System_Message__c = true;

        insert chatMessage;
        System.debug('chatMessage.Id' + chatMessage.Id);

        return chatMessage.Id;
    }

    private static void sentNotificationTaskToNewOwner(ChatSession__c chatSession){
		//Id recordTypeId = GlobalUtility.getRecordTypeIdFromSObjectByDevName('Task', RecordTypeService.TASK_ALERT_TYPE);
        String socialAccountName = (chatSession.Social_ID__r.FirstName__c == null ? '' : chatSession.Social_ID__r.FirstName__c)  + ' ' + (chatSession.Social_ID__r.LastName__c == null ? '' : chatSession.Social_ID__r.LastName__c);
        Task newTask = new Task();
        // newTask.WhoId = chatSession.Social_ID__r.Display_Name__c;
        newTask.WhatId = chatSession.Id;
       // newTask.RecordTypeId = recordTypeId;
        newTask.OwnerId = chatSession.OwnerId;
        newTask.Subject = 'Live chat from ' + chatSession.Social_ID__r.Display_Name__c + (socialAccountName.trim() == '' ? '' : ' - ' + socialAccountName)  + ' has been transferred to you.' ;
        newTask.ActivityDate = Date.today();
        newTask.ReminderDateTime = System.now().addSeconds(5);
        newTask.Description = chatSession.Transfer_Message__c;
        System.debug('newTask' + newTask);
        insert newTask;
    }

    @AuraEnabled
	global static String getImageFromLine(String url){
        if (url == null) {
            return PREFIX_IMG;
        }
        // url = 'https://api.line.me/v2/bot/message/10778575835652/content';
        String token = getChannelToken();
        System.debug('###token###: '+token);
        String imgString = PREFIX_IMG;
        HttpRequestService callout = new HttpRequestService();
        HttpResponse resp = new HttpResponse();
        callout.setHeader('Content-Type','image/jpeg');
        callout.setHeader('Authorization', 'Bearer ' + token);
        callout.setTimeout(120000);

        try{
            resp = callout.executeCallout('GET', url);
            // System.debug(resp.getBody());
            Blob imgBlop = resp.getBodyAsBlob();
            // System.debug('imgBlop '+ imgBlop );
            imgString += EncodingUtil.base64Encode(imgBlop);
            // System.debug('imgString '+ imgString );
        }catch (Exception e){
            System.debug('catch');
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
        }
       
        return imgString;
    }
    @AuraEnabled
	global static String getImageFromFacebook(String url){
        if (url == null) {
            return null;
        }
        String imgString = PREFIX_IMG;
        HttpRequestService callout = new HttpRequestService();
        HttpResponse resp = new HttpResponse();
        callout.setHeader('Content-Type','image/jpeg');
        // callout.setHeader('Authorization', 'Bearer ' + token);
        callout.setTimeout(120000);

        try{
            resp = callout.executeCallout('GET', url);
            // System.debug(resp.getBody());
            Blob imgBlop = resp.getBodyAsBlob();
            // System.debug('imgBlop '+ imgBlop );
            imgString += EncodingUtil.base64Encode(imgBlop);
        }catch (Exception e){
            System.debug('catch');
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
        }
    
        return imgString;
    }
    @AuraEnabled
	global static ContentDistribution getDownloadLinkImage(String blobString,String fileName){
        System.debug('blobString.remove(PREFIX_IMG) ' + blobString.remove(PREFIX_IMG));
        Blob blopData = EncodingUtil.base64Decode(blobString.remove(PREFIX_IMG));
        // System.debug('blopData ' + blopData);
        
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.Origin = 'H'; //C-Content Origin. H-Chatter Origin.
        cVersion.Title = fileName; //Name of the file
        cVersion.PathOnClient = fileName; //File name with extention
        cVersion.VersionData = blopData;//File content
        
        insert cVersion;
        ContentVersion cv = getContentVersionDetailById(cVersion.Id);
        ContentDistribution cd = makePublicFile(cv);
        return cd;
    }

     @AuraEnabled
	global static ContentDistribution getFileFromLine(String url,String fileName){
        
        String token = getChannelToken();
        HttpRequestService callout = new HttpRequestService();
        HttpResponse resp = new HttpResponse();
        //callout.setHeader('Content-Type','application/json');
        callout.setHeader('Authorization', 'Bearer ' + token);
        callout.setTimeout(120000);
        Blob blopData = Blob.valueof('');
        try{
            resp = callout.executeCallout('GET', url);
            // System.debug(resp.getBody());
            blopData = resp.getBodyAsBlob();
        }catch (Exception e){
            System.debug('catch');
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
        }

        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.Origin = 'H'; 
        cVersion.Title = fileName; 
        cVersion.PathOnClient = '/' + fileName; 
        cVersion.VersionData = blopData;//File content
        
        insert cVersion;

        ContentVersion cv = getContentVersionDetailById(cVersion.Id);
        ContentDistribution cd = makePublicFile(cv);
        System.debug(cd);
        return cd;
    }

    @AuraEnabled
	global static void removeFileFromLine(String Id){
        List<ContentDocument> cVersion = [select Id from ContentDocument where Id IN (select ContentDocumentId from ContentVersion where Id = :Id)];
        delete cVersion;
    }

    private static String getChannelToken(){
        // ann
        //return null;
        return String.valueOf(WebhookAuthentication__c.getInstance().get('Line_Channel_Token__c'));

       // return String.valueOf(SansiriLiveChatAPI__c.getInstance().get('Line_Channel_Token__c'));
    }

    global static void postToChatter(List<Task> taskList) {
            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
            for(Task t : taskList) {
                String sfURL = System.Url.getSalesforceBaseUrl().toExternalForm();
                String subject = t.Subject + '\r\n\t' + sfURL + '/' + t.whatId; 
                if(!Test.isRunningTest()){
                    // ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), t.OwnerId, ConnectApi.FeedElementType.FeedItem, subject);
                    ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
                    input.subjectId = t.OwnerId;
                    ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
                    body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

                    ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
                    textSegment.text = subject;

                    body.messageSegments.add(textSegment);
                    input.body = body;

                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
                    batchInputs.add(batchInput);
                }
            }
            if(!Test.isRunningTest()) {
                ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
            }
        }

    global static List<ChatMessage__c> getPreviousMessageThroughSession(ChatSession__c session, ChatMessage__c lastMessage) {
        if(lastMessage == null) {
            lastMessage = new ChatMessage__c();
            lastMessage.Time_Stamp__c = session.createdDate;
            lastMessage.Id = null;
        }
        List<ChatMessage__c> previousMessage = [SELECT Id, Body_Message__c, Sender__c, Time_Stamp__c, Message_Type__c, createdBy.Id, createdBy.name, IsOutbound__c,
                                             ChatSession__r.Owner.Id, ChatSession__r.Owner.Name, ChatSession__r.Social_ID__r.Display_Name__c,ChatSession__r.Social_ID__r.Social_Type__c,ChatSession__r.Is_Auto_Expired__c,
                                             ChatSession__r.Social_ID__r.Owner.Id, ChatSession__r.Social_ID__r.Owner.Name, ChatSession__r.IsExpired__c,
                                             ChatSession__r.CreatedDate,ChatSession__r.Chat_Note__c,ChatSession__r.Chat_Topic__c,ChatSession__r.Others_Topic__c, 
                                             ChatSession__r.Social_ID__c  
                                            FROM ChatMessage__c 
                                            Where ChatSession__r.Social_ID__c = :session.Social_ID__c and ChatSession__r.CreatedDate < :session.CreatedDate 
                                            and Time_Stamp__c < :lastMessage.Time_Stamp__c and Id != :lastMessage.Id 
                                            Order by Time_Stamp__c DESC limit : MAX_RECORD_OF_MESSAGE+1];
        return previousMessage;
    }
}