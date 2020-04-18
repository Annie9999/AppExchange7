global without sharing class RemoveLiveChatFile implements Schedulable {

	public static String cronJob = '0 0 0 * * ?'; 

    global static String scheduleRemoveLiveChatFileBatch() {
        RemoveLiveChatFile job = new RemoveLiveChatFile(); 
        return System.schedule('Remove Live Chat File Batch', cronJob, job);
    }

    global void execute(SchedulableContext sc) {
		RemoveLiveChatFileBatch b = new RemoveLiveChatFileBatch();
		database.executebatch(b);
    }
}