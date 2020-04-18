@isTest
private class LiveChatHistoryComponentRemoteTest {
    @TestSetup
	static void setup(){
	//   User testUser = TestDataFactory.createUser();
        // System.debug(testUser);
        // Account acc = TestDataFactory.createAccount(testUser.Id);
        Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        String socialId = 'U551bf1d427ed66416a5a7d5b018696ee';
        String displayName = 'testSocialAccount';

        SocialAccount__c socialAccount = new SocialAccount__c(
            Avatar_URL__c = 'test_avatar_url', 
            Display_Name__c = displayName, 
            Social_ID__c = socialId, 
            Social_Type__c = 'Line'
        );
        insert socialAccount;

        List<ChatSession__c> chatSessions = new  List<ChatSession__c>();
        ChatSession__c chatSession1 = new ChatSession__c(
            Social_ID__c = socialAccount.Id,
            SessionID__c = guid,
            Expired_DateTime__c = (System.now().addMinutes(30)),
            // OwnerId = testUser.Id,
            IsExpired__c = false,
            Chat_Topic__c = 'others',
            Name = displayName + ' has requested a LiveChat1'
        );
        chatSessions.add(chatSession1);

        ChatSession__c chatSession2 = new ChatSession__c(
            Social_ID__c = socialAccount.Id,
            SessionID__c = 'dddfeeendslfjis',
            Expired_DateTime__c = (System.now().addMinutes(-30)),
            // OwnerId = testUser.Id,
            IsExpired__c = true,
            Chat_Topic__c = 'others',
            End_DateTime__c = System.now().addMinutes(30),
            Name = displayName + ' has requested a LiveChat2'
        );
        chatSessions.add(chatSession2);

        ChatSession__c chatSession3 = new ChatSession__c(
            Social_ID__c = socialAccount.Id,
            SessionID__c = 'dddfeeendddddslfjis',
            Expired_DateTime__c = (System.now().addMinutes(-30)),
            // OwnerId = testUser.Id,
            IsExpired__c = true,
            Chat_Topic__c = 'others',
            End_DateTime__c = System.now().addHours(1).addMinutes(30),
            Name = displayName + ' has requested a LiveChat2'
        );
        chatSessions.add(chatSession3);

        ChatSession__c chatSession6 = new ChatSession__c(
            Social_ID__c = socialAccount.Id,
            SessionID__c = 'dddfeee',
            Expired_DateTime__c = (System.now().addMinutes(-30)),
            // OwnerId = testUser.Id,
            IsExpired__c = true,
            Chat_Topic__c = 'others',
            End_DateTime__c = System.now().addHours(2).addMinutes(30),
            Name = displayName + ' has requested a LiveChat2'
        );
        chatSessions.add(chatSession6);

        ChatSession__c chatSession4 = new ChatSession__c(
            Social_ID__c = socialAccount.Id,
            SessionID__c = 'eenddslfjis',
            Expired_DateTime__c = (System.now().addMinutes(-30)),
            // OwnerId = testUser.Id,
            IsExpired__c = true,
            Chat_Topic__c = 'others',
            End_DateTime__c = System.now().addDays(5),
            Name = displayName + ' has requested a LiveChat2'
        );
        chatSessions.add(chatSession4);

        ChatSession__c chatSession5 = new ChatSession__c(
            Social_ID__c = socialAccount.Id,
            SessionID__c = 'dddddslfjis',
            Expired_DateTime__c = (System.now().addMinutes(-30)),
            // OwnerId = testUser.Id,
            IsExpired__c = true,
            Chat_Topic__c = 'others',
            End_DateTime__c = System.now().addMonths(5),
            Name = displayName + ' has requested a LiveChat2'
        );
        chatSessions.add(chatSession5);
            
        insert chatSessions;
        for (ChatSession__c each : chatSessions) {
            System.debug(each.Duration__c);
        }

        // SansiriLiveChatAPI__c config = new SansiriLiveChatAPI__c(
        //     userName__c = 'admin',
        //     password__c = 'admin', 
        //     token__c = 'token', 
        //     refreshToken__c = 'refreshToken', 
        //     endpoint__c = 'endpoint', 
        //     isActive__c = true
        // );
        // insert config;

        ChatMessage__c chatMessage = new ChatMessage__c(
            Message_Type__c = 'text',
            IsOutbound__c = true,
            Sender__c = 'U551bf1d427ed66416a5a7d5b018696ee',
            Body_Message__c = 'Hello Salesforce',
            ChatSession__c = chatSessions[0].Id,
            Time_Stamp__c = System.now()
        );
        insert chatMessage;

        // ChatMessage__c chatdata = [SELECT Id, Body_Message__c, Sender__c, Time_Stamp__c, Message_Type__c, createdBy.Id, createdBy.name, IsOutbound__c,
        //                                      ChatSession__r.Owner.Id, ChatSession__r.Owner.Name, ChatSession__r.Social_ID__r.Display_Name__c,ChatSession__r.Is_Auto_Expired__c,
        //                                      ChatSession__r.Social_ID__r.Owner.Id, ChatSession__r.Social_ID__r.Owner.Name, ChatSession__r.IsExpired__c,
        //                                      ChatSession__r.CreatedDate,ChatSession__r.Chat_Note__c,ChatSession__r.Chat_Topic__c,ChatSession__r.Others_Topic__c
        //                                     FROM ChatMessage__c 
        //                                     Where Id =: chatMessage.Id];
        // return chatdata;
	}
     @isTest static void Test_getInitData(){
        Test.startTest();
        List<ChatSession__c> chatSessions = [select Id from ChatSession__c limit 1];
        LiveChatHistoryComponentRemote.getInitData(chatSessions[0].Id);
        Test.stopTest();
    }
    @isTest static void Test_getPopupDataHistory(){
        Test.startTest();
        List<ChatMessage__c> previosChatmessage = [SELECT Id, Body_Message__c, Sender__c, Time_Stamp__c, Message_Type__c, createdBy.Id, createdBy.name, IsOutbound__c,ChatSession__c,
                                             ChatSession__r.Owner.Id, ChatSession__r.Owner.Name, ChatSession__r.Social_ID__r.Display_Name__c,ChatSession__r.Is_Auto_Expired__c,
                                             ChatSession__r.Social_ID__r.Owner.Id, ChatSession__r.Social_ID__r.Owner.Name, ChatSession__r.IsExpired__c,
                                             ChatSession__r.CreatedDate,ChatSession__r.Chat_Note__c,ChatSession__r.Chat_Topic__c,ChatSession__r.Others_Topic__c
                                            FROM ChatMessage__c limit 1];
        LiveChatHistoryComponentRemote.getPopupDataHistory(previosChatmessage[0].ChatSession__c, previosChatmessage[0]);
        Test.stopTest();
    }
    //   @isTest static void Test_getFileFromLine(){
    //     Test.startTest();
    //     LiveChatHistoryComponentRemote.getFileFromLine('diefdjfd','text.pdf');
    //     Test.stopTest();
    //   }
     @isTest static void Test_getDownloadLinkImage(){
        Test.startTest();
        LiveChatHistoryComponentRemote.getDownloadLinkImage('R0lGODlhPQBEAPeoAJosM','image.png');
        Test.stopTest();
    }
     @isTest static void Test_removeFileFromLine(){
        Test.startTest();
        LiveChatHistoryComponentRemote.removeFileFromLine('R0lGOD');
        Test.stopTest();
    }
}