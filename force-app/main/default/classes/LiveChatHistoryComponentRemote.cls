public without sharing class LiveChatHistoryComponentRemote {
    public static Map<String,String> ICON_NAME_MAP = new Map<String,String>{
		'Sales' =>  'standard:partner_marketing_budget',
		'Support' => 'standard:custom',
		'Lead' => 'standard:lead',
		'Lead (Convert)' => 'standard:opportunity',
		'Coordinate' => 'standard:data_integration_hub',
		'Complaint' => 'custom:custom82',
		'Compliment' => 'standard:resource_preference',
		'Home Care (แจ้งซ่อม)' => 'custom:custom19',
		'Incident' => 'standard:coaching',
		'Other' => 'standard:feedback',
		'Others' => 'standard:feedback'
		};
	public static String DATE_FORMAT = 'd MMM yyyy';    

    public class ActivityTimeLineRecordData {
      @AuraEnabled
      public String header {get;set;}
      @AuraEnabled
      public String subheader {get;set;}
      @AuraEnabled
      public String iconName {get;set;}
      @AuraEnabled
      public String displayDate {get;set;}
      @AuraEnabled
      public String Id {get;set;}
    }

    public class PopupData {
      @AuraEnabled
      public LiveChatMainComponentRemote.ResponseGetInitData LiveChatMainData {get;set;}
     
    }

    @AuraEnabled
	public static List<ActivityTimeLineRecordData> getInitData(String recordId){
        System.debug('recordId ' + recordId);
        List<ActivityTimeLineRecordData> res = new List<ActivityTimeLineRecordData>();
        List<ChatSession__c> socialIdOfChatSession = [SELECT Id, iigproduct__Social_ID__c, iigproduct__Social_ID__r.Display_Name__c FROM ChatSession__c WHERE ID = :recordId limit 1];
        System.debug('socialIdOfChatSession' + socialIdOfChatSession);
        
        List<ChatSession__c> chatSessions = [SELECT Id, iigproduct__Chat_Topic__c, iigproduct__Chat_Note__c, iigproduct__End_DateTime__c, iigproduct__Duration__c ,CreatedDate ,iigproduct__Social_ID__c 
                                                FROM ChatSession__c 
                                                WHERE iigproduct__Social_ID__c = :socialIdOfChatSession[0].iigproduct__Social_ID__c
                                                        // AND End_DateTime__c != null AND IsExpired__c = true AND Id != :recordId
                                                        AND iigproduct__End_DateTime__c != null AND iigproduct__IsExpired__c = true 
                                                ORDER BY CreatedDate DESC];

        List<ChatSession__c> chatSessions2 = [SELECT Id, iigproduct__Chat_Topic__c, iigproduct__Chat_Note__c, iigproduct__End_DateTime__c, iigproduct__Duration__c ,CreatedDate ,iigproduct__Social_ID__c 
                                                FROM ChatSession__c 
                                                WHERE iigproduct__Social_ID__c = :socialIdOfChatSession[0].iigproduct__Social_ID__c
                                                ORDER BY CreatedDate DESC];
        System.debug('show chat >> '+chatSessions);
        System.debug('show chat 2 >> '+chatSessions2);

        for (ChatSession__c each : chatSessions) {
            ActivityTimeLineRecordData rec = new ActivityTimeLineRecordData();
            rec.Id = each.Id;
            rec.header = getHeader(each.iigproduct__Chat_Topic__c);
            rec.subheader = getSubheader(Double.valueOf(each.iigproduct__Duration__c));
            rec.iconName = getIconName(each.iigproduct__Chat_Topic__c);
            rec.displayDate = getDisplayDate(each.CreatedDate);

            System.debug('rec' + rec);
            res.add(rec);
        }

        return res;
    }

    @AuraEnabled
	public static PopupData getPopupDataHistory(String recordId,ChatMessage__c previosChatmessage){
        PopupData responseData = new PopupData();
        System.debug('previos ' + previosChatmessage);
        LiveChatMainComponentRemote.ResponseGetInitData responseMainLiveChat = LiveChatMainComponentRemote.getMoreData(recordId,previosChatmessage, false);
        responseData.LiveChatMainData = responseMainLiveChat;
        return responseData;
    }

    /*@AuraEnabled
    public static ContentDistribution getFileFromLine(String url,String fileName){
        return LiveChatMainComponentRemote.getFileFromLine(url,fileName);
    }*/
    @AuraEnabled
	public static ContentDistribution getDownloadLinkImage(String blobString,String fileName){
        return LiveChatMainComponentRemote.getDownloadLinkImage(blobString,fileName);
    }
    @AuraEnabled
	public static void removeFileFromLine(String Id){
        LiveChatMainComponentRemote.removeFileFromLine(Id);
    }

    private static String getDisplayDate(Datetime targetDatetime){
        if (targetDatetime == null) {
            return '--------';
        }
        String result;
        Datetime currentTime = System.now();
        System.debug('currentTime ' + currentTime);
        System.debug('targetDatetime' + targetDatetime);
        if (targetDatetime < currentTime.addDays(-10)) {
            result = targetDatetime.format(DATE_FORMAT);
        }else {
            Long totalMinutes = (currentTime.getTime() - targetDatetime.getTime())/1000/60;
            System.debug('targetDatetime' + targetDatetime);

            if (totalMinutes <= 1) {
                result = totalMinutes + 'min ago';
            }else if (totalMinutes < 60) {
                result = totalMinutes + 'mins ago';
            }else if (totalMinutes < 120){
                result = '1 hr ago';                
            }else if (totalMinutes < 1440){
                result = Integer.valueOf(totalMinutes/60) + ' hrs ago';                
            }else if (totalMinutes < 2880){
                result = '1 day ago';                
            }else{
                result = Integer.valueOf(totalMinutes/1440) + ' days ago';                
            }
        }

        return result;
    }
    private static String getHeader(String topicString){
        List<String> topics = (topicString == null || topicString == '')? new List<String>() : topicString.split(';');
        String header = 'Chat - ';
        header += topics.size() > 0 ? String.join(topics, '/') : 'None';
        
        return header;
    }
    private static String getIconName(String topicString){
        List<String> topics = (topicString == null || topicString == '')? new List<String>() : topicString.split(';');
        String result = ICON_NAME_MAP.get('Other');
        if (topics.size() > 0) {
            result = ICON_NAME_MAP.get(topics[0]);
        }
        return result;
    }

    private static String getSubheader(Double totalHours){
         if (totalHours == null) {
            return '----------';
        }
        String result = 'Duration:';
        Double days_d = totalHours/24;
        Double hours_d = totalHours - days_d.intValue() * 24;
        Double minutes_d = (hours_d - hours_d.intValue()) * 60;

        Integer days = days_d.intValue();
        Integer hours = hours_d.intValue();
        Integer minutes = minutes_d.intValue();
        
        switch on days {
            when 0 {

            }
            when 1 {
                result += ' ' + days + ' day';
            }
            when else {
                result += ' ' + days + ' days';
            }
        }

        if (hours == 0) {
            if (days > 0) {
                if (minutes != 0) {
                    result += ' ' + hours + ' hour ' + minutes + ' minute';
                }
            }else {
                result += ' ' +  minutes + ' minute';
            }

        }else if (hours == 1) {
            result += ' ' + hours + ' hour';
            if (minutes != 0) {
                result += ' ' + minutes + ' minute';
            }
        }else {
            result += ' ' + hours + ' hours';
            if (minutes != 0) {
                result += ' ' + minutes + ' minute';
            }
        }
        if (minutes > 1) {
            result += 's';
        }

        return result;
    }
}