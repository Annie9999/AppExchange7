public with sharing class chatConfiguration {
    @AuraEnabled
    public static void getConfigInfo(String Username,String Password,String Line_user_id,String Grant_type,String RecordClient_id,String RecordClient_secret,Double Session_expired,String ChatQueue,String recordId){
        
        
        System.debug('hi from getconfiginfo : '+Username+''+Password+''+Line_user_id+''+Grant_type+''+RecordClient_id+''+RecordClient_secret+''+Session_expired+''+ChatQueue+''+recordId);
        ChatConfiguration__c chatConfig = new ChatConfiguration__c();
        chatConfig.iigproduct__username__c=Username;
        chatConfig.id=recordId;
        chatConfig.iigproduct__password__c=Password;
        chatConfig.iigproduct__client_id__c=RecordClient_id;
        chatConfig.iigproduct__client_secret__c=RecordClient_secret;
        chatConfig.iigproduct__grant_type__c=Grant_type;
        chatConfig.iigproduct__line_user_id__c=Line_user_id;
        chatConfig.iigproduct__sessionExpired__c=Session_expired;
        chatConfig.iigproduct__chatQueue__c=ChatQueue;
        upsert chatConfig;
        
      
    }

    @AuraEnabled
    public static ChatConfiguration__c viewRecord(){
        
        ChatConfiguration__c dataChatConfig = [SELECT iigproduct__username__c,iigproduct__password__c,iigproduct__client_id__c,iigproduct__client_secret__c,iigproduct__grant_type__c,iigproduct__line_user_id__c,iigproduct__sessionExpired__c,iigproduct__chatQueue__c
                                                FROM ChatConfiguration__c LIMIT 1];
        
        return dataChatConfig;
    }
}