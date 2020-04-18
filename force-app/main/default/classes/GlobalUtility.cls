public with sharing class GlobalUtility {
    public static final String NO_REPLY_NAME = 'Sansiri (no-reply)';
    public static final String PROFILE_SYSADMIN = 'System Administrator';

    // LOG_LEVEL
    public static final String LEVEL_DEBUG = 'Debug';
    public static final String LEVEL_ERROR = 'Error';
    public static final String LEVEL_INFO = 'Info';
    public static final String LEVEL_WARNING = 'Warning';

    //Marketing cloud
    public static final String CLICKNEXT_CREDENTIAL_CUSTOM_SETTING_NAME = 'Test credential';
    public static final String CLICKNEXT_GET_CREDIT_ENDPOINT = 'https://member.smsmkt.com/SMSLink/GetCredit/index.php';
    public static final String CLICKNEXT_SEND_MESSAGE_ENDPOINT = 'https://member.smsmkt.com/SMSLink/SendMsg/index.php';

    public static final String FIELD_CUSTOM_VALIDATION_EXCEPTION = 'FIELD_CUSTOM_VALIDATION_EXCEPTION';
    public static final String FIELD_INSUFFICIENT_ACCESS_EXCEPTION = 'INSUFFICIENT_ACCESS_OR_READONLT';

    public static final String ERROR_MESSAGE_INSUFFICIENT_ACCESS = 'You do not have sufficient privilege to edit this record';
    public static final String ERROR_MESSAGE_UNIT_IS_LOCKED_BY_OTHERS = 'Selected unit has been locked by others opportunity. Please change customer interested unit.';
    public static final String ERROR_MESSAGE_UNIT_IS_LOCKED_BY_HS = 'Selected unit has been locked. Please change customer interested unit.';
    public static final String ERROR_MESSAGE_INSUFFICIENT_OPPORTUNITY_ACCESS = 'You do not have enough access to the related opportunity';

    public static final String API_NAME_PROJECT_ACTIVE_API_NAME = 'TRUE';
    public static final String API_NAME_PROJECT_INACTIVE_API_NAME = 'FALSE';

    public static Boolean runOnce = false;
    public static Boolean accounFromYearend = false;
    public static Boolean initialMonthly = false;
    public static Boolean resetStatement = false;

    public static Map<String, Map<String, String>> recordTypeMapMapBySObject;

    public static final String LOG_NAME_PREFIX = 'ALOG-';

    //Task booking uncomplete
    public static final String TASK_BOOKING_COMPLETED = 'Booking information of this opportunity is completed';
    public static final String TASK_BOOKING_INCOMPLETED = 'This opportunity is not completed the booking information';
    public static final String TASK_DESC_CUS_INFO = 'The customer information is not completed';
    public static final String TASK_DESC_PRICE_PROMOTION = 'The price and promotion is not completed';
    public static final String TASK_DESC_PAYMENT = 'The payment information is not completed';

    // Endpoint API
   // public static String API_GET_BOOKING_DOCUMENT = Config_CRMApi.CRM_HOST() + Config_CRMApi.STOCK_SERVICE_API() + '/api/document/booking/pdf';

    public static String subStringByMaxLength(String str, Integer maxLength) {
        if (str != null && str.length() > maxLength) {
            return str.substring(0, maxLength);
        } else {
            return str;
        }
    }

    public static String formatErrorMessage(Exception ex) {
        String errorMessage = ex.getMessage();
        if (errorMessage.contains(FIELD_CUSTOM_VALIDATION_EXCEPTION)) {
            //errorMessage = errorMessage.substring(errorMessage.indexOf(BE8_GlobalConstants.FIELD_CUSTOM_VALIDATION_EXCEPTION) + BE8_GlobalConstants.FIELD_CUSTOM_VALIDATION_EXCEPTION.length());
            errorMessage = errorMessage.substring(errorMessage.indexOf(FIELD_CUSTOM_VALIDATION_EXCEPTION));
        }
        return errorMessage;
    }

    public static Boolean isEmailValid(String email) {
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern emailPattern = Pattern.compile(emailRegex);
        Matcher resutlMatcher = emailPattern.matcher(email);

        return resutlMatcher.matches();
    }

    //public static void sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName,
    //                                      ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity,
    //                                      Attachment[] attachList ) {

    //    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    //    Id templateId;

    //    try {
    //        templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;
    //    } catch (Exception e) {
    //        e.setMessage('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName +
    //                     ' refer to Setup | Communications Templates ' + templateApiName);
    //        throw e;
    //    }

    //    email.setToAddresses(toRecipients);
    //    email.setCcAddresses(ccRecipients);
    //    email.setTargetObjectId(targetObjId);
    //    email.setWhatId(whatId);
    //    email.setorgWideEmailAddressId(orgWideEmailId);
    //    email.setTemplateId(templateId);
    //    email.setSaveAsActivity(saveAsActivity);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users

    //    try {
    //        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    //        return;
    //    } catch (EmailException e) {
    //        e.setMessage('[U-02] sendTemplatedEmail error. ' + e.getMessage());
    //        throw e;
    //    }
    //}

    private static Map<String, Map<String, Id>> getRecordTypeIdMapByDevName() {
        System.debug('recordTypeMapMapBySObject :::'+recordTypeMapMapBySObject);
        if (GlobalUtility.recordTypeMapMapBySObject == null) {
            GlobalUtility.recordTypeMapMapBySObject = new Map<String, Map<String, Id>>();
            Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([SELECT Id, DeveloperName, SObjectType FROM RecordType]);
            System.debug('getting in if loop :::'+recordTypeMap.values());

            for (RecordType eachRecordType : recordTypeMap.values()) {
                if (GlobalUtility.recordTypeMapMapBySObject.containsKey(eachRecordType.SObjectType)) {
                    GlobalUtility.recordTypeMapMapBySObject.get(eachRecordType.SObjectType).put(eachRecordType.DeveloperName, eachRecordType.Id);
                } else {
                    GlobalUtility.recordTypeMapMapBySObject.put(eachRecordType.SObjectType, new Map<String, Id> {eachRecordType.DeveloperName => eachRecordType.Id});
                }
            }
        }

        return GlobalUtility.recordTypeMapMapBySObject;
    }

    public static Map<String, Id> getRecordTypeMapByDevNameFromSObject(String sObjectName) {
        GlobalUtility.recordTypeMapMapBySObject = getRecordTypeIdMapByDevName();
        Map<String, Id> resultsMap = GlobalUtility.recordTypeMapMapBySObject.get(sObjectName);

        return resultsMap;
    }

    public static Map<Id, String> getRecordTypeDevNameMapByIdFromSObject(String sObjectName) {
        GlobalUtility.recordTypeMapMapBySObject = getRecordTypeIdMapByDevName();
        Map<Id, String> resultsMap = new Map<Id, String>();
        Map<String, Id> recIdMapByDevName = GlobalUtility.recordTypeMapMapBySObject.get(sObjectName);

        for (String recordTypeDevName : recIdMapByDevName.keySet()) {
            resultsMap.put(recIdMapByDevName.get(recordTypeDevName), recordTypeDevName);
        }

        return resultsMap;
    }

    public static Id getRecordTypeIdFromSObjectByDevName(String sObjectName, String recordTypeDevName) {
        System.debug('Global : '+sObjectName+'  '+recordTypeDevName);
        GlobalUtility.recordTypeMapMapBySObject = getRecordTypeIdMapByDevName();
        System.debug('Global /// : '+ GlobalUtility.recordTypeMapMapBySObject);
        Map<String, Id> resultsMap = GlobalUtility.recordTypeMapMapBySObject.get(sObjectName);
        System.debug('three /// : '+ GlobalUtility.recordTypeMapMapBySObject.get(sObjectName));
        return resultsMap.get(recordTypeDevName);
    }

    public static String toNumber(Object val) {
        String numberString;
        try {
            numberString = String.valueOf(Integer.valueOf(val));
        } catch (Exception ex) {
            numberString = '0';
        }
        return val != null ? numberString : '0';
    }

    public static String toExportDateFormat(Date inputDate) {
        String returnDate;
        String tempYear = String.valueOf(inputDate.year());
        if (String.valueOf(UserInfo.getLocale()) == 'th_TH') {
            tempYear = String.valueOf(Integer.valueOf(inputDate.year()) - 543);
        }
        returnDate = String.valueOf(tempYear) + '-' + String.valueOf('0' + String.valueOf(inputDate.month())).right(2) + '-' + String.valueOf('0' + String.valueOf(inputDate.day())).right(2);

        return returnDate;
    }

    public static  Map<String, String> getLocaleDateMap() {
        Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
        locale_map.put('ar', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_AE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_BH', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_KW', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
        locale_map.put('bg_BG', 'yyyy-M-d H:mm');
        locale_map.put('ca', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('cs', 'd.M.yyyy H:mm');
        locale_map.put('cs_CZ', 'd.M.yyyy H:mm');
        locale_map.put('da', 'dd-MM-yyyy HH:mm');
        locale_map.put('da_DK', 'dd-MM-yyyy HH:mm');
        locale_map.put('de', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('el_GR', 'd/M/yyyy h:mm a');
        locale_map.put('en_AU', 'd/MM/yyyy HH:mm');
        locale_map.put('en_B', 'M/d/yyyy h:mm a');
        locale_map.put('en_BM', 'M/d/yyyy h:mm a');
        locale_map.put('en_CA', 'dd/MM/yyyy h:mm a');
        locale_map.put('en_GB', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_GH', 'M/d/yyyy h:mm a');
        locale_map.put('en_ID', 'M/d/yyyy h:mm a');
        locale_map.put('en_IE', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_IE_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_NZ', 'd/MM/yyyy HH:mm');
        locale_map.put('en_SG', 'M/d/yyyy h:mm a');
        locale_map.put('en_US', 'M/d/yyyy h:mm a');
        locale_map.put('en_ZA', 'yyyy/MM/dd hh:mm a');
        locale_map.put('es', 'd/MM/yyyy H:mm');
        locale_map.put('es_AR', 'dd/MM/yyyy HH:mm');
        locale_map.put('es_BO', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CL', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CO', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_CR', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_EC', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_ES', 'd/MM/yyyy H:mm');
        locale_map.put('es_ES_EURO', 'd/MM/yyyy H:mm');
        locale_map.put('es_GT', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_HN', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_MX', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_PE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_PR', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_PY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_SV', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_UY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_VE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('et_EE', 'd.MM.yyyy H:mm');
        locale_map.put('fi', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI_EURO', 'd.M.yyyy H:mm');
        locale_map.put('fr', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_BE', 'd/MM/yyyy H:mm');
        locale_map.put('fr_CA', 'yyyy-MM-dd HH:mm');
        locale_map.put('fr_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('fr_FR', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_FR_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_LU', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_MC', 'dd/MM/yyyy HH:mm');
        locale_map.put('hr_HR', 'yyyy.MM.dd HH:mm');
        locale_map.put('hu', 'yyyy.MM.dd. H:mm');
        locale_map.put('hy_AM', 'M/d/yyyy h:mm a');
        locale_map.put('is_IS', 'd.M.yyyy HH:mm');
        locale_map.put('it', 'dd/MM/yyyy H.mm');
        locale_map.put('it_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('it_IT', 'dd/MM/yyyy H.mm');
        locale_map.put('iw', 'HH:mm dd/MM/yyyy');
        locale_map.put('iw_IL', 'HH:mm dd/MM/yyyy');
        locale_map.put('ja', 'yyyy/MM/dd H:mm');
        locale_map.put('ja_JP', 'yyyy/MM/dd H:mm');
        locale_map.put('kk_KZ', 'M/d/yyyy h:mm a');
        locale_map.put('km_KH', 'M/d/yyyy h:mm a');
        locale_map.put('ko', 'yyyy. M. d a h:mm');
        locale_map.put('ko_KR', 'yyyy. M. d a h:mm');
        locale_map.put('lt_LT', 'yyyy.M.d HH.mm');
        locale_map.put('lv_LV', 'yyyy.d.M HH:mm');
        locale_map.put('ms_MY', 'dd/MM/yyyy h:mm a');
        locale_map.put('nl', 'd-M-yyyy H:mm');
        locale_map.put('nl_BE', 'd/MM/yyyy H:mm');
        locale_map.put('nl_NL', 'd-M-yyyy H:mm');
        locale_map.put('nl_SR', 'd-M-yyyy H:mm');
        locale_map.put('no', 'dd.MM.yyyy HH:mm');
        locale_map.put('no_NO', 'dd.MM.yyyy HH:mm');
        locale_map.put('pl', 'yyyy-MM-dd HH:mm');
        locale_map.put('pt', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_AO', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_BR', 'dd/MM/yyyy HH:mm');
        locale_map.put('pt_PT', 'dd-MM-yyyy H:mm');
        locale_map.put('ro_RO', 'dd.MM.yyyy HH:mm');
        locale_map.put('ru', 'dd.MM.yyyy H:mm');
        locale_map.put('sk_SK', 'd.M.yyyy H:mm');
        locale_map.put('sl_SI', 'd.M.y H:mm');
        locale_map.put('sv', 'yyyy-MM-dd HH:mm');
        locale_map.put('sv_SE', 'yyyy-MM-dd HH:mm');
        locale_map.put('th', 'M/d/yyyy h:mm a');
        locale_map.put('th_TH', 'd/M/yyyy, H:mm');
        locale_map.put('tr', 'dd.MM.yyyy HH:mm');
        locale_map.put('ur_PK', 'M/d/yyyy h:mm a');
        locale_map.put('vi_VN', 'HH:mm dd/MM/yyyy');
        locale_map.put('zh', 'yyyy-M-d ah:mm');
        locale_map.put('zh_CN', 'yyyy-M-d ah:mm');
        locale_map.put('zh_HK', 'yyyy-M-d ah:mm');
        locale_map.put('zh_TW', 'yyyy/M/d a h:mm');
        return locale_map; //return the map
    }

    //public static String makeSOAPRequestCallout(String endpoint, String soapAction, String body) {
    //    //body = body.replaceAll('&', '&amp;');
    //    if(body.contains('&') && !body.contains('&amp;')) body = replaceAll(body, '&', '&amp;');
    //    //body = replaceAll(body, '&', '&amp;');
    //    HttpRequest req = new HttpRequest();
    //    HttpResponse res = new HttpResponse();
    //    Http http = new Http();
    //    req.setTimeout(120000);
    //    req.setEndpoint(endpoint);
    //    req.setHeader('Content-Type', 'text/xml;charset=utf-8');
    //    //req.setHeader('Content-Type', 'application/soap+xml;charset=UTF-8;action="EnrollROPMember"');
    //    req.setHeader('Content-Length', '' + body.length());
    //    req.setHeader('soapAction', soapAction);
    //    req.setHeader('Accept', 'text/xml');
    //    req.setMethod('POST');
    //    req.setBody(body);
    //    res = http.send(req);
    //    return res.getBody();
    //}

    //public static String makeSOAPRequestCallout(String endpoint, String soapAction, String body, String actionOnContentType) {
    //    HttpRequest req = new HttpRequest();
    //    HttpResponse res = new HttpResponse();
    //    Http http = new Http();
    //    req.setTimeout(120000);
    //    req.setEndpoint(endpoint);
    //    //req.setHeader('Content-Type', 'text/xml;charset=utf-8');
    //    req.setHeader('Content-Type', 'application/soap+xml;charset=UTF-8;action="' + actionOnContentType + '"');
    //    req.setHeader('Content-Length', '' + body.length());
    //    req.setHeader('soapAction', soapAction);
    //    req.setHeader('Accept', 'text/xml');
    //    req.setMethod('POST');
    //    req.setBody(body);
    //    res = http.send(req);
    //    return res.getBody();
    //}

    //public static String removeCDATAfromXMLString(String xml) {
    //    //String encoded = EncodingUtil.urlEncode(xml, 'UTF-8');
    //    //encoded = encoded.replaceAll('%3C%21%5BCDATA%5B', ''); // i.e. '<![CDATA['
    //    //encoded = encoded.replaceAll('%5D%5D%3E', ''); // i.e. ']]>'
    //    return xml.unescapeHtml4();
    //}

    public static String getDateString(Date pDT, String pFormat) {
        if (pDT == null) return null;
        return String.valueOf(Datetime.newInstance(pDT.year(), pDT.month(), pDT.day()).format(pFormat));
    }

    public static Integer toNumber(String pData) {
        if (pData == null) return null;

        pData = pData.replaceAll(',', '');

        Integer result = null;
        try {
            result = Integer.valueOf(pData);
        } catch (Exception e) {
            return null;
        }

        return result;
    }

    public static Set<Id> getIdSet(String fieldName, List<SObject> sObjectList) {
        Set<Id> idSet = new Set<Id>();
        if (sObjectList != null) {
            for (SObject obj : sObjectList) {
                Id eachId = (Id) obj.get(fieldName);
                if (eachId != null) {
                    idSet.add(eachId);
                }
            }
        }
        return idSet;
    }

    public static Set<String> getStringSet(String fieldName, List<SObject> sObjectList) {
        Set<String> stringSet = new Set<String>();
        if (sObjectList != null) {
            for (SObject obj : sObjectList) {
                String eachString = String.valueOf(obj.get(fieldName));
                if (eachString != null) {
                    stringSet.add(eachString);
                }
            }
        }
        return stringSet;
    }

    public static Map<String, SObject> getSObjectMap(String byFieldName, List<SObject> sObjectList) {
        Map<String, SObject> sObjectMap = new Map<String, SObject>();
        if(sObjectList != null){
            for (SObject obj : sObjectList) {
                String key = String.valueOf(obj.get(byFieldName));
                sObjectMap.put(key, obj);
            }
        }
        return sObjectMap;
    }

    public static Map<String, SObject> getSObjectMap(Set<String> byFieldName, List<SObject> sObjectList) {
        Map<String, SObject> sObjectMap = new Map<String, SObject>();
        if (byFieldName.size() > 0 && sObjectList != null) {
            for (SObject obj : sObjectList) {
                String key = '';
                for (String filedName : byFieldName) {
                    key += String.valueOf(obj.get(filedName));
                }
                sObjectMap.put(key, obj);
            }
        }
        return sObjectMap;
    }

    public static Map<String, List<SObject>> getSObjectListMap(String byFieldName, List<SObject> sObjectList) {
        Map<String, List<SObject>> sObjectMap = new Map<String, List<SObject>>();
        if(sObjectList != null){
            for (SObject obj : sObjectList) {
                String key = String.valueOf(obj.get(byFieldName));
                if (sObjectMap.containsKey(key)) {
                    List<SObject> tempList = sObjectMap.get(key);
                    tempList.add(obj);
                } else {
                    List<SObject> tempList = new List<SObject>();
                    tempList.add(obj);
                    sObjectMap.put(key, tempList);
                }
            }
        }
        return sObjectMap;
    }

    public static Map<String, List<SObject>> getSObjectListMap(Set<String> byFieldName, List<SObject> sObjectList) {
        Map<String, List<SObject>> sObjectMap = new Map<String, List<SObject>>();
        if (byFieldName.size() > 0 && sObjectList != null) {
            for (SObject obj : sObjectList) {
                String key = '';
                for (String filedName : byFieldName) {
                    key += String.valueOf(obj.get(filedName));
                }
                if (sObjectMap.containsKey(key)) {
                    List<SObject> tempList = sObjectMap.get(key);
                    tempList.add(obj);
                } else {
                    List<SObject> tempList = new List<SObject>();
                    tempList.add(obj);
                    sObjectMap.put(key, tempList);
                }
            }
        }
        return sObjectMap;
    }

    public static String convertDurationToMinuteUnit(String duration, String delimeter) {
        List<String> durationSplit = null;
        Integer minute = 0;
        if (duration != null) {
            if (delimeter != null) {
                durationSplit = duration.split('\\' + delimeter);
            } else {
                durationSplit = new List<String>();
                durationSplit.add(duration.substring(0, 2));
                durationSplit.add(duration.substring(2, duration.length()));
            }
            minute = Integer.valueOf(durationSplit.get(0)) * 60;
            minute += Integer.valueOf(durationSplit.get(1));
            return String.valueOf(minute);
        }
        return null;

    }

    //public static String getErrorMessage(List<Database.UpsertResult> results) {
    //    if (results != null) {
    //        String error = '';
    //        for (Database.UpsertResult r : results) {
    //            if (!r.isSuccess()) {
    //                List<Database.Error> errors = r.getErrors();
    //                for (Database.Error e : errors) {
    //                    error += 'Error upsert :' + e.getMessage() + ' ' + r.getId() + '\n';
    //                }
    //            }
    //        }
    //        return error;
    //    }
    //    return null;
    //}

    //public static String getErrorMessage(List<Database.SaveResult> results) {
    //    if (results != null) {
    //        String error = '';
    //        for (Database.SaveResult r : results) {
    //            if (!r.isSuccess()) {
    //                List<Database.Error> errors = r.getErrors();
    //                for (Database.Error e : errors) {
    //                    error += 'Error Save :' + e.getMessage() + ' ' + r.getId() + '\n';
    //                }
    //            }
    //        }
    //        return error;
    //    }
    //    return null;
    //}

    //public static String getErrorMessage(List<Database.DeleteResult> results) {
    //    if (results != null) {
    //        String error = '';
    //        for (Database.DeleteResult r : results) {
    //            if (!r.isSuccess()) {
    //                List<Database.Error> errors = r.getErrors();
    //                for (Database.Error e : errors) {
    //                    error += 'Error Delete :' + e.getMessage() + ' ' + r.getId() + '\n';
    //                }
    //            }
    //        }
    //        return error;
    //    }
    //    return null;
    //}

    public static Boolean abortScheduledJob(String containName) {
        containName = '%' + containName + '%';
        List<CronTrigger> jobList = [SELECT Id, State, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType
                                     FROM CronTrigger WHERE CronJobDetail.Name LIKE :containName];

        if (jobList.isEmpty()) {
            //AppLogger.debug('GlobalUtility', 'abortScheduledJob', containName, containName + ' not found', null);
        }

        Boolean hasAbort = false;
        for (CronTrigger job : jobList) {
            if (job != null && job.Id != null) {
                System.abortJob(job.Id);
                hasAbort = true;
            }
        }
        return hasAbort;
    }

    public static Boolean abortScheduledJob(String containName, String state) {
        containName = '%' + containName + '%';
        List<CronTrigger> jobList = [SELECT Id, State, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType
                                     FROM CronTrigger WHERE CronJobDetail.Name LIKE :containName AND State = :state];

        if (jobList.isEmpty()) {
            //AppLogger.debug('GlobalUtility', 'abortScheduledJob', containName, containName + ' not found', null);
        }

        Boolean hasAbort = false;
        for (CronTrigger job : jobList) {
            if (job != null && job.Id != null) {
                System.abortJob(job.Id);
                hasAbort = true;
            }
        }
        return hasAbort;
    }

    //@future
    //public static void massDeleteJobs(List<ID> paramIDsToAbort) {
    //    Integer i = 0;
    //    while (i < 150 && paramIDsToAbort.size() > 0) {
    //        System.abortJob(paramIdsToAbort.remove(0));
    //        i++;
    //    }
    //    if (paramIDsToAbort.size() > 0) {
    //        GlobalUtility.massDeleteJobs(paramIDsToAbort);
    //    }
    //}

    public static String getMsgBetween(String pMessage, String pStartText, String pEndText) {
        return pMessage.substring(pMessage.indexOf(pStartText) + pStartText.length(), pMessage.indexOf(pEndText));
    }

    public static String getObjectNameFromRecordIdPrefix(String recordIdOrPrefix) {
        String objectName = '';
        try {
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0, 3);
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe();

            for (Schema.SObjectType stype : gd.values()) {
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();

                if (prefix != null && prefix.equals(myIdPrefix)) {
                    objectName = r.getName();
                    break;
                }
            }
        } catch (Exception e) {

        }
        return objectName;
    }

    public static void sendEmail(String subject, String toEmails, String bodyMsg) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>();
        toAddresses.addAll(toEmails.split(','));
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(bodyMsg);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    @future(callout=true)
    public static void sendEmailFuture(String subject, String toEmails, String bodyMsg) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>();
        toAddresses.addAll(toEmails.split(','));
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(bodyMsg);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    //public static Set<String> getFieldsFromFieldSet(List<Schema.FieldSet> fieldSets) {
    //    Set<String> customFieldSet = new Set<String>();
    //    for (Schema.FieldSet fieldSet : fieldSets) {
    //        for (Schema.FieldSetMember field : fieldSet.getFields()) {
    //            customFieldSet.add(field.getFieldPath());
    //        }
    //    }
    //    return customFieldSet;
    //}

    //public static Set<String> getFieldsFromFieldSet(String sObjectType, Set<String> fieldSetNameSet) {
    //    Map<String, Schema.FieldSet> fieldSetMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fieldSets.getMap();

    //    Set<String> customFieldSet = new Set<String>();
    //    for (String fieldSetName : fieldSetNameSet) {
    //        for (Schema.FieldSetMember field : fieldSetMap.get(fieldSetName).getFields()) {
    //            customFieldSet.add(field.getFieldPath());
    //        }
    //    }

    //    return customFieldSet;
    //}

    //public static Integer randomWithLimit(Integer upperLimit) {
    //    Integer rand = Math.round(Math.random() * 1000);
    //    return Math.mod(rand, upperLimit);
    //}

    //public static String toCSVString(List<List<String>> datas) {
    //    String str = '';
    //    for (List<String> eachRow : datas) {
    //        str += String.join(eachRow, ',') + '\n';
    //    }
    //    return str;
    //}

    public static String replaceCharToString(String sourceStr, String targetChar, String replaceStr) {
        if (targetChar.length() != 1) {
            return sourceStr;
        }
        String returnStr = '';
        Integer targetCharInt = targetChar.getChars()[0];
        List<Integer> chars = new List<Integer>();
        List<Integer> replaceChars = replaceStr.getChars();
        for (Integer i = 0; i < sourceStr.length(); i++) {
            if (sourceStr.charAt(i) == targetCharInt) {
                chars.addAll(replaceChars);
            } else {
                chars.add(sourceStr.charAt(i));
            }
        }
        return String.fromCharArray(chars);
    }

    public static String getSetToString(Set<String> setString){
        String returnStr = '';
        Integer loopcount = 1;
        if(setString != null && !setString.isEmpty()){
            for(String str : setString){
                returnStr += loopCount < setString.size() ? str + ', ' : str;
                loopcount++;
            }
        }
        return returnStr;
    }

    //public static String replaceAll(String inputString, String removetxt, String replacetxt){
    //    if(inputString.contains(removetxt)){
    //        List<String> inputList = stringSplit(inputString, removetxt);
    //        return insertTargetintoString(inputList, replacetxt);
    //    }
    //    return inputString;

    //}

    //@testVisible
    //private static List<String> stringSplit(String inputString, String target){
    //    List<String> returnList = new List<String>();
    //    while(inputString.contains(target)){
    //        String subString = inputString.substringBefore(target);
    //        inputString = inputString.substringAfter(target);
    //        returnList.add(subString);
    //        if(!inputString.contains(target)) returnList.add(inputString);
    //    }
    //    return returnList;
    //}

    //@testVisible
    //private static String insertTargetintoString(List<String> inputString, String target){
    //    return String.join(inputString, target);
    //}

    public static Set<String> getAllCreateableFields(String objectName) {
        Set<String> fieldSet = new Set<String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        for(Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult describeField = field.getDescribe();
            if(describeField.isCreateable()) {
                fieldSet.add(describeField.getName());
            }
        }
        return fieldSet;
    }

    public static List<Schema.SObjectField> getAllCreatableSchemaSObjectFields(String objectName){
        return Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap().values();
    }

    public static List<SelectOption> getPicklistValues(String ObjectApi_name,String Field_name){ 
        List<SelectOption> lstPickvals = new List<SelectOption>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry eachValue : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(new SelectOption(eachValue.getLabel(),eachValue.getValue()));//add the value  to our final list
        }

        return lstPickvals;
    }

    public static Boolean isChangeValue(SObject oldRecord, SObject newRecord, String fieldName){
        return oldRecord==null||(oldRecord.get(fieldName)!=newRecord.get(fieldName));
    }

    public static List<PicklistOption> getPicklistOptions(String objectName, string fieldName) {
        List<PicklistOption> options = new List<PicklistOption>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult reso = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = reso.fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            options.add(new PicklistOption(pickListVal.getValue(), pickListVal.getLabel()));
        } 
        return options;
    }

    private static User currentUser;
    public static User getCurrentUser() {
        if(currentUser == null){
		    currentUser = [SELECT Id, Name, Username, Profile.Name, Profile.UserLicense.Name, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        }
		return currentUser;
	}

    public static boolean hasSObjectField(String fieldName, SObject so){
            return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
    }

    public static Datetime getNextScheduleTimeOnBusinessHours(Datetime targetDateTime,Integer intervalNextTime){
        targetDateTime = Datetime.newInstance(targetDateTime.year(), targetDateTime.month(), targetDateTime.day(), targetDateTime.hour(), targetDateTime.minute(), 0);
        // this day on weekday
        //DateTime myDateTime = System.now();
        //String thisDayOfWeek = myDateTime.format('EEEE');
        //String tomorrowDayOfWeek = myDateTime.addDays(1).format('EEEE');

        //// get hour time of this day on businessHours        
        //String query = 'select '+ thisDayOfWeek + 'StartTime' +  ',' + thisDayOfWeek + 'EndTime' +  ',' + tomorrowDayOfWeek + 'StartTime' +',' + tomorrowDayOfWeek +'EndTime' + ' from BusinessHours';
        //BusinessHours businessHours = Database.query(query);

        System.debug('targetDateTime :' + targetDateTime);
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
        Datetime nextScheduleTime = targetDateTime.addMinutes(intervalNextTime == null? 30:intervalNextTime);
        System.debug('nextScheduleTime :' + nextScheduleTime);
        Datetime nextScheduleTimeInBusTime = BusinessHours.nextStartDate(bh.id,  nextScheduleTime);
        System.debug('nextScheduleTimeInBusTime :' + nextScheduleTimeInBusTime);
        if (nextScheduleTime != nextScheduleTimeInBusTime){
            nextScheduleTimeInBusTime = nextScheduleTimeInBusTime.addMinutes(intervalNextTime == null? 30:intervalNextTime);
        }

        return nextScheduleTimeInBusTime;
    }

    public static Datetime getNextScheduleTimeOnBusinessHoursReward(Datetime targetDateTime,Integer intervalNextTime){
        targetDateTime = Datetime.newInstance(targetDateTime.year(), targetDateTime.month(), targetDateTime.day(), targetDateTime.hour(), targetDateTime.minute(), 0);

        System.debug('targetDateTime :' + targetDateTime);
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
        Datetime nextScheduleTime = targetDateTime.addHours(intervalNextTime == null? 24:intervalNextTime);
        System.debug('nextScheduleTime :' + nextScheduleTime);
        Datetime nextScheduleTimeInBusTime = BusinessHours.nextStartDate(bh.id,  nextScheduleTime);
        System.debug('nextScheduleTimeInBusTime :' + nextScheduleTimeInBusTime);
        if (nextScheduleTime != nextScheduleTimeInBusTime){
            nextScheduleTimeInBusTime = nextScheduleTimeInBusTime.addHours(intervalNextTime == null? 24:intervalNextTime);
        }

        return nextScheduleTimeInBusTime;
    }

    public static String convertXMLSpecialCharaters(String text){
        if(text.contains('&lt;')){
            text = text.replace('&lt;', '<');
        }
        if(text.contains('&amp;')){
            text = text.replace('&amp;', '&');
        }
        if(text.contains('&gt;')){
            text = text.replace('&gt;', '>');
        }
        if(text.contains('&quot;')){
            text = text.replace('&quot;', '"');
        }
        if(text.contains('&apos;')){
            text = text.replace('&apos;', '\'');
        }
        return text;
    }

    //convert number to Thai Baht text
    //Covert number to String baht
    private static String[] numbers = new String[] {'', 'หนึ่ง', 'สอง', 'สาม', 'สี่', 'ห้า', 'หก', 'เจ็ด', 'แปด', 'เก้า'};

    private static String[] digits = new String[] {'สิบ', 'ร้อย', 'พัน', 'หมื่น', 'แสน', 'ล้าน'};

    private static String one_at_oneth = 'เอ็ด';

    private static  String two_at_tenth = 'ยี่';


    public static String numberToWordTH(Decimal amountValue) {
        if (amountValue == 0) return 'ศูนย์บาท';

        system.debug('amountValue='+amountValue);

        String amount = amountValue +''  ;//string.valueof(amountValue).replace(',' , '');

        Integer dot = amount.indexOf('.');
        system.debug('dot='+dot);

        // find stang portion
        //if (($dot = strpos($amount, '.')) > 0)
        String stang = '';
        if (dot > 0) {
            system.debug('amount='+amount);
            stang = amount.subString(dot+1); //stang = substr($amount, $dot+1);

            //$amount = substr($amount, 0, $dot);
            amount = amount.subString(0 , dot);
        } else {
            stang = '';
        }

        // pad string to multiple of 6
        Integer lth = (Integer)(((Decimal)amount.length()) / 6).round(System.RoundingMode.UP);
        amount = amount.leftPad( lth * 6);

        System.debug('amount after leftPad:' + amount);
        System.debug('amount: ' + amount);
        String []chunks = GlobalUtility.split(amount, 6); //$chunks = str_split($amount, 6);
        System.debug('chunks: ' + chunks);

        String text = ''; //$text = '';

        //while ( ! empty($chunks))
        Integer id = chunks.size();
        System.debug('chunks.size(): ' + chunks.size());
        while ( id > 0) {
            //$segment = array_pop($chunks);
            String segment = chunks[id - 1];
            //return segment;
            text = convertSegment(segment) + text;

            if ( id - 1 != 0) {
                text = 'ล้าน' + text;
            }

            id --;
        }

        System.debug('text:' + text);

        //return $text . 'บาท' . (empty($stang) ? '' : (static::convertSegment($stang) . 'สตางค์'));
        system.debug('stang='+stang);
        return text + 'บาท' + (String.isEmpty(stang) || Integer.valueOf(stang) == 0 ? 'ถ้วน' : (convertSegment(stang) + 'สตางค์'));
    }

    public static String convertSegment(String segment) {
        segment = segment.trim();
        Integer length = segment.length();
        Integer last_digit = length - 1;

        if (length == 1) {
            System.debug('element: ' + segment + ' - ' +  numbers[Integer.valueOf(segment)]);
            return numbers[Integer.valueOf(segment)];
        }

        String text = '';
        String digit = '';
        String numberValue = '';

        //Integer nth = last_digit;
        for ( Integer nth = last_digit; nth >= 0 ; nth --) {
            // any zero in any digit
            if (segment.subString(nth, nth + 1) == '0') {
                continue;
            }

            // oneth digit
            if (nth == last_digit) {
                digit = '';
                numberValue = (segment.subString(nth, nth + 1) == '1'
                               && segment.subString(nth - 1, nth) != '0')
                    ? one_at_oneth : numbers[Integer.valueOf(segment.subString(nth, nth + 1))];
            }

            // tenth digit
            else if (nth == last_digit - 1) {
                digit = digits[last_digit - nth - 1];

                if ( segment.subString(nth, nth + 1) == '1') {
                    numberValue = '';
                } else if (segment.subString(nth, nth + 1) == '2') {
                    numberValue = two_at_tenth;
                } else {
                    numberValue = numbers[Integer.valueOf(segment.subString(nth, nth + 1) )];
                }
            }

            // other digits
            else {

                numberValue  = numbers[Integer.valueOf(segment.subString(nth, nth + 1))];
                digit = digits[last_digit - nth - 1];
            }

            text = (numberValue + digit) + text;

        }
        return text;
    }

    public static List<String> split(String strValue, Integer numOfValue) {
        List<String> lst = new List<String>();
        Integer idx = 0;
        while (idx < strValue.length()) {
            String sub = strValue.subString(idx, idx + numOfValue );
            System.debug(sub + ' idex: ' + idx);
            lst.add(sub);
            idx = idx + numOfValue;
        }
        return lst;
    }


    // convert number to EN
    // http://salesforcewithkiran.blogspot.com/2013/05/number-to-words-in-apex.html
    // private static String[] to_19 = new string[]{ 'zero', 'one',  'two', 'three', 'four',  'five',  'six',  
    //   'seven', 'eight', 'nine', 'ten',  'eleven', 'twelve', 'thirteen',  
    //   'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen' };  
    // private static String[] tens = new string[]{ 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'};  
    // private static String[] denom = new string[]{ '',  
    //   'thousand',   'million',     'billion',    'trillion',    'quadrillion',  
    //   'quintillion', 's!xtillion',   'septillion',  'octillion',   'nonillion',  
    //   'decillion',  'undecillion',   'duodecillion', 'tredecillion',  'quattuordecillion',  
    //   's!xdecillion', 'septendecillion', 'octodecillion', 'novemdecillion', 'vigintillion' };  
    // // convert a value < 100 to English.    
    // public static String convert_nn(integer val) {  
    //     if (val < 20)  
    //     return to_19[val];  
    //     if(val == 100)  
    //         return 'One Hundred';  
    //     for (integer v = 0; v < tens.size(); v++) {  
    //     String dcap = tens[v];  
    //     integer dval = 20 + 10 * v;  
    //     if (dval + 10 > val) {  
    //         if (Math.Mod(val,10) != 0)  
    //         return dcap + ' ' + to_19[Math.Mod(val,10)];  
    //         return dcap;  
    //     }      
    //     }  
    //     return 'Should never get here, less than 100 failure';  
    // }  
    // // convert a value < 1000 to english, special cased because it is the level that kicks   
    // // off the < 100 special case. The rest are more general. This also allows you to  
    // // get strings in the form of "forty-five hundred" if called directly.  
    // public static String convert_nnn(integer val) {  
    //     String word = '';  
    //     integer rem = val / 100;  
    //     integer mod = Math.mod(val,100);  
    //     if (rem > 0) {  
    //         word = to_19[rem] + ' hundred';  
    //         if (mod > 0) {  
    //             word += ' ';  
    //         }  
    //     }  
    //     if (mod > 0) {  
    //         word += convert_nn(mod);  
    //     }  
    //     return word;  
    // }

    // public static String numberToWordEN(long val) {  
    //     if (val < 100) {  
    //         return convert_nn(val.intValue());  
    //     }  
    //     if (val < 1000) {  
    //         return convert_nnn(val.intValue());  
    //     }  
    //     for (integer v = 0; v < denom.size(); v++) {  
    //         integer didx = v - 1;  
    //         integer dval = (integer)Math.pow(1000, v);  
    //         if (dval > val) {  
    //             integer mod = (integer)Math.pow(1000, didx);  
    //             integer l = (integer) val / mod;  
    //             integer r = (integer) val - (l * mod);  
    //             String ret = convert_nnn(l) + ' ' + denom[didx];  
    //             if (r > 0) {  
    //                 ret += ', ' + numberToWordEN(r);  
    //             }  
    //             return ret;  
    //         }  
    //     }  
    //     return 'Should never get here, bottomed out in english_number';  
    // }


    // convert number to en
    // https://ayushmangalblog.wordpress.com/2016/04/15/salesforce-currency-to-word-number-to-word/
    private static String bigCurrencySingular    = 'Baht';
    private static String bigCurrencyplural      = 'Baht';
    private static String smlCurrencySingular    = 'Satang';
    private static String smlCurrencyplural      = 'Satang';

    private static String[]  ones = new string[] {  'Zero',  'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen' };
    private static String[]  tens = new string[] { '', 'Ten', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety' };
    private static integer[] base = new integer[]{0,1,10,100,1000,1000,1000,1000000,1000000,1000000,1000000000};
    private static String[]  unit = new String[] {'','','','Hundred','Thousand','Thousand','Thousand','Million','Million','Million','Billion','Billion','Billion','Trillion'};

    public static String numberToWordEN(Decimal num){
        String numInWords;
        Integer intNum;
        Integer decNum;
        String numToString = String.valueOf(num);
        List<String> parts = numToString.split('\\.');
        if( parts != null && parts.size()>0 ){
            intNum = Integer.valueOf(parts[0]);
            decNum = parts.size() > 1? Integer.valueOf(parts[1]) : -1;
        }
        if( intNum == 0 )
            numInWords ='Zero';
        if( intNum > 0 ){
            if( intNum == 1 )
                numInWords = NumberToWords(intNum);
            else
                numInWords = NumberToWords(intNum);
        }
        if( decNum > 0 ){
            if( decNum == 1 )
                numInWords += NumberToWords(decNum);
            else
                numInWords +=' AND ' + NumberToWords(decNum);
        }
        System.debug(num+':'+numInWords);
        return numInWords;
    }

    private static String NumberToWords(Integer num){
        String words = '';
        integer digit, den, rem;
        digit = String.valueOf(num).length();
        //System.debug(num+':'+digit);
        den = num / base[digit];
        rem = Math.mod(num,base[digit]);
        if( digit == 1 ){
            words = ones[num];
        }
        else if( digit == 2 ){
            if( den == 1 && rem >0 )
                words = ones[num];
            else{
                words = tens[den];
                if( rem > 0 )
                    words += NumberToWords(rem) + ' ';
                }
        }
        else if( digit > 2 ){
            words += NumberToWords(den) + ' ' + unit[digit] + ' ';
            if( rem > 0 )
                words += NumberToWords(rem) + ' ';
        }
        return words;
    }

    private static List<String> monthEN = new List<String> {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};
    private static List<String> monthTH = new List<String> {'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน', 'กรกฏาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'};
    public static String dateToStringEN(Date d) {
        if(d.month() - 1 < monthEN.size()) {
            return (d.day() < 10? '0' : '') + String.valueOf(d.day()) + ' ' + monthEN[d.month() - 1] + ' ' + ((d.year() + 543 > 3000)? String.valueOf(d.year() - 543) : String.valueOf(d.year()));
        }
        return d.format();
    }

    public static String dateToStringTH(Date d) {
        if(d.month() - 1 < monthTH.size()) {
            return (d.day() < 10? '0' : '') + String.valueOf(d.day()) + ' ' + monthTH[d.month()- 1] + ' ' + ((d.year() + 543 > 3000)? String.valueOf(d.year() - 543) : String.valueOf(d.year()));
        }
        return d.format();
    }

    public static String formatDecimal(Decimal dec) {
        if(dec == null){
            dec = 0;
        }
        return dec.format() + '.00';
    }
}