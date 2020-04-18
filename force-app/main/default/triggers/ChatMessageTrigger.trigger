trigger ChatMessageTrigger on ChatMessage__c (after insert) {
    if(true) {
         if (trigger.isAfter) {
             if (trigger.isInsert) {      
                 List <WebhookAuthentication__c> configList = [SELECT Id, userName__c, password__c, token__c, refreshToken__c, endpoint__c, isActive__c, prefix__c FROM WebhookAuthentication__c WHERE isActive__c = true Limit 1];	
                 System.debug(configList);      
                 for (ChatMessage__c chatMessage : trigger.new) {
                     System.debug(chatMessage);

                     if (chatMessage.IsOutbound__c == true && (!configList.isEmpty()) && !chatMessage.Is_System_Message__c) {
                         ChatMessageCallout callout;
                         callout = new ChatMessageCallout(chatMessage.Id, configList.get(0));
                         Database.executeBatch(callout);
                     }
                         /* -- create chat message events and add them into list-- 
                             -- this event will send if 'end chat','transfer' and 'message from provider' */
                        Database.executeBatch(new NotifyChatMessageEvent(chatMessage));
                         /* End -- create chaฬt message events and add them into list-- */
                     
                 }
             }
         }
 }
}