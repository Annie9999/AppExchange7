public class HttpRequestService {
    public static String CUSTOMER_ENDPOINT = 'Customer_Endpoint';
    public static String MERGE_CUSTOMER_ENDPOINT = 'Merge_Customer_Endpoint';
    public static String CUSTOMER_UPSERT_ENDPOINT = 'Customer_Upsert_Endpoint';
    public static String CUSTOMER_LOGIN_ENDPOINT = 'Customer_Login_Endpoint';
   /* public static Map<String, Sansiri_Endpoint__mdt> endpointMap {
        get {
            if(endpointMap == null) {
                endpointMap = new Map<String, Sansiri_Endpoint__mdt>();
                List<Sansiri_Endpoint__mdt> lst = [select Id, Label, DeveloperName, End_Point__c, Token__c from Sansiri_Endpoint__mdt];
                for(Sansiri_Endpoint__mdt meta : lst) {
                    endpointMap.put(meta.DeveloperName, meta);
                }
            }
            return endpointMap;
        }
        set;
    }*/

    // private static String END_POINT = 'https://siriapi.sansiri.com/api-platform-stg/';
    //private static String END_POINT = 'https://siriapi.sansiri.com/api-platform/';
    //private static String END_POINT = 'http://www.mocky.io/v2/5b98f8d63200007b0013faee';
    private Map<String, String> headers;
    private Map<String, Object> parameters;
    private List<String> DestinationList;
    private boolean SendToSAP;
    @testVisible private HttpRequest request;

    // Start Utilities Methods Section

    //Mapping Reference for Lookup Values
    public static Map<String, String> objectRefMap(String ObjectName) {
         Map<String, String> mapFieldName = new Map<String, String>();
        if(ObjectName=='Account'){
            mapFieldName.put('Nationality__c', 'Nationality_External_ID__c');
            mapFieldName.put('Race__c', 'Race_External_ID__c');
        }else if(ObjectName=='Address__c'){
            mapFieldName.put('Country__c', 'Country_External_ID__c');
            // mapFieldName.put('District__c', 'District_External_ID__c');
            mapFieldName.put('Sub_District__c', 'Sub_District_External_ID__c');
            // mapFieldName.put('Province__c', 'Province_External_ID__c');
            mapFieldName.put('City__c', 'City_External_Id__c');
            mapFieldName.put('State__c', 'State_External_Id__c');
        }
        return mapFieldName;
    }

    //Additional repeat fields
    public static List<String> getRepeatfieldSet(String sObjectName){
        List<String> repeatfieldList = new List<String>();
        if(sObjectName=='Account'){
            repeatfieldList.addAll(getSobjectFieldSet(sObjectName,'Customer_Email_info_fieldset'));
            repeatfieldList.addAll(getSobjectFieldSet(sObjectName,'Customer_Phone_Info_Fieldset'));
        }

        return repeatfieldList;

    }

    //Get Field Set
    public static List<String> getSobjectFieldSet(String sObjectName, String fieldSetName) {
        String result = '';
        List<String> fieldnameList = new List<String>();
        try{
            SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeSObjectResult d = objToken.getDescribe();
            Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
            if(FsMap.containsKey(fieldSetName))
                for(Schema.FieldSetMember f : FsMap.get(fieldSetName).getFields()) {
                    if(result != ''){
                        result += ',';
                    }

                    fieldnameList.add(f.getFieldPath());
                    String jsonPart = '{';
                    jsonPart += '"label":"' + f.getLabel() + '",';
                    jsonPart += '"required":"' + (f.getDBRequired() || f.getRequired()) + '",';
                    jsonPart += '"type":"' + (f.getType()) + '",';
                    jsonPart += '"name":"' + f.getFieldPath() + '"';
                    jsonPart += '}';
                    result += jsonPart;
            }
        }
        catch(Exception e){
            result += e.getLineNumber() + ' : ' + e.getMessage();
        }
        return fieldnameList;
    }

    //Get Relationship SOQL Statements as string
    public static String getRelationshipFieldSOQL(Map<string,String> relationshipfieldMap){
         String soqlstr='';
         String refFieldName = '';

        for (String keyName : relationshipfieldMap.keySet()) {
                    soqlstr += keyName + ',';
                    refFieldName = keyName.replace('__c', '__r');
                    String valueName = relationshipfieldMap.get(keyName);
                    soqlstr += refFieldName + '.' + valueName + ',';
                }
        soqlstr = soqlstr.subString(0, soqlstr.length() - 1);

        return soqlstr;

    }

    public static String getSOQLStatement(String sObjectName,String fieldSetName, List<String> includeFields) {
        String querystr= 'SELECT ';
        for(String field : includeFields) {
            querystr += field + ',';
        }
        List<String> sobjectFieldList = getSobjectFieldSet(sObjectName,fieldSetName);
        sobjectFieldList.addall(getRepeatfieldSet(sObjectName));
        Map<String, Object> sobjectMap = new Map<String, Object>();
        for(String fieldname : sobjectFieldList){
                querystr +=fieldname+',';
        }

        querystr += getRelationshipFieldSOQL(objectRefMap(sObjectName));
        querystr += ' FROM '+sObjectName;
        return querystr;
    }

    //Get Query Statement following Field Sets and Relationship fields
    public static String getSOQLStatement(String sObjectName,String fieldSetName){
        String querystr= 'SELECT ';
        List<String> sobjectFieldList = getSobjectFieldSet(sObjectName,fieldSetName);
        sobjectFieldList.addall(getRepeatfieldSet(sObjectName));
        Map<String, Object> sobjectMap = new Map<String, Object>();
        for(String fieldname : sobjectFieldList){
                querystr +=fieldname+',';
        }

        querystr += getRelationshipFieldSOQL(objectRefMap(sObjectName));
        querystr += ' FROM '+sObjectName;
        return querystr;
    }

    //Formatting Map Key and Value to JSON Body
    public HttpRequestService setRequestBody(Map<String, Object> mainsObject){
        String requestbody  = JSON.Serialize(mainsObject);
        requestbody = requestbody.replace('\\"', '"');
        requestbody = requestbody.replace('"[', '[');
        requestbody = requestbody.replace(']"', ']');
        requestbody = requestbody.replace('"{', '{');
        requestbody = requestbody.replace('}"', '}');
        requestbody = requestbody.replace('}', '}]');
        requestbody = requestbody.replace('{', '[{');
        this.request.setBody(requestbody);

        return this;
    }

    public HttpRequestService setRequestBody(List<Map<String, Object>> mainsObject){
        String requestbody  = JSON.Serialize(mainsObject);
        requestbody = requestbody.replace('\\"', '"');
        requestbody = requestbody.replace('"[', '[');
        requestbody = requestbody.replace(']"', ']');
        requestbody = requestbody.replace('"{', '{');
        requestbody = requestbody.replace('}"', '}');
        // requestbody = requestbody.replace('}', '}]');
        // requestbody = requestbody.replace('{', '[{');
        this.request.setBody(requestbody);

        return this;
    }

    //Formatting Map Key and Value to JSON Body
    public HttpRequestService setSingleRequestBody(Map<String, Object> mainsObject){
        String requestbody  = JSON.Serialize(mainsObject);
        requestbody = requestbody.replace('\\"', '"');
        requestbody = requestbody.replace('"[', '[');
        requestbody = requestbody.replace(']"', ']');
        requestbody = requestbody.replace('"{', '{');
        requestbody = requestbody.replace('}"', '}');
        requestbody = requestbody.replace('}', '}]');
        requestbody = requestbody.replace('{', '[{');
        requestbody = requestbody.substring(1, requestbody.length()-1);
        this.request.setBody(requestbody);
        // System.debug('Request: ' + requestbody);
        return this;
    }

    public HttpRequestService setSingleRequestBodyWithoutReplacing(Map<String, Object> mainsObject){
        String requestbody  = JSON.Serialize(mainsObject);
        requestbody = requestbody.replace('\\"', '"');
        requestbody = requestbody.replace('"[', '[');
        requestbody = requestbody.replace(']"', ']');
        requestbody = requestbody.replace('"{', '{');
        requestbody = requestbody.replace('}"', '}');
        // requestbody = requestbody.replace('}', '}]');
        // requestbody = requestbody.replace('{', '[{');
        // requestbody = requestbody.substring(1, requestbody.length()-1);
        this.request.setBody(requestbody);
        // System.debug('Request: ' + requestbody);
        return this;
    }

    public HttpRequestService setRequestBodyJSONString(String jsonString){
        this.request.setBody(jsonString);
        // System.debug('HttpRequestBody: ' + jsonString);
        return this;
    }

    // End Utilities Methods Section



    // Start Setting Methods

    public HttpRequestService(){
        this.headers = new Map<String, String>();
        this.parameters = new Map<String,Object>();
        this.DestinationList = new List<String>();
        this.SendToSAP = false;
        this.request = new HttpRequest();
    }

    public HttpRequestService setHeader(String paratmetername, String value) {
       this.request.setHeader(paratmetername, value);
        return this;
    }

    public HttpRequestService setHeaders(Map<String, String> headers) {

        this.headers.putAll(headers);
        return this;
    }

    public HttpRequestService setParameter(String key, String value) {
        this.setParameters(new Map<String, String>{key => value});
        return this;
    }

    public HttpRequestService setParameters(Map<String, Object> parameters) {
        this.parameters.putAll(parameters);
        return this;
    }

    public HttpRequestService setTimeout(Integer timeoutMs) {
        this.request.setTimeout(timeoutMs);
        return this;
    }

    public String getBody(){
        return this.request.getbody();
    }

        // End Setting Methods



    //Callout Method
    public HttpResponse executeCallout(String httpVerb) {
        this.request.setMethod(httpVerb);
        //this.request.setEndPoint(endpointMap.get(CUSTOMER_ENDPOINT).End_Point__c);
        
        System.debug(this.request.getbody());

        HttpResponse response;
        if(!Test.isRunningTest()) {
            response = new Http().send(this.request);
        }else {
            response = new CustomerCalloutMock().respond(this.request);
        }
        return response;
    }

    public HttpResponse executeCallout(String httpVerb, String customEndPoint) {
        this.request.setMethod(httpVerb);
        this.request.setEndPoint(customEndPoint);
        
        System.debug(this.request.getbody());

        HttpResponse response;
        if(!Test.isRunningTest()) {
            response = new Http().send(this.request);
        }else {
            response = new CustomerCalloutMock().respond(this.request);
        }
        return response;
    }

}