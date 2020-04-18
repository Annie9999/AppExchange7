public with sharing class PicklistDescriber {
    static final Pattern OPTION_PATTERN = Pattern.compile('<option value="([^"]+).*?>(.+?)</option>'); 
    
    /**
        Desribe a picklist field for an sobject id. RecordType is automatically picked
        based on the record's RecordTypeId field value.
        example usage :
        List<PicklistOption> options = PicklistDescriber.describe(accountId, 'Industry');
    */
    public static List<PicklistOption> describe(Id sobjectId, String pickListFieldAPIName) {
        return parseOptions(
                            new Map<String, String> {
                                                     'id' => sobjectId,
                                                     'pickListFieldName'=> pickListFieldAPIName
                                                    }
                            );
    }
    
    /**
        Describe a picklist field for a SobjectType, its given record type developer name and the picklist field
        example usage : 
        List<PicklistOption> options = PicklistDescriber.describe('Account', 'Record_Type_1', 'Industry'));
    */
    public static List<PicklistOption> describe(String sobjectType, String recordTypeName, String pickListFieldAPIName) {
        return parseOptions(
                            new Map<String, String> {
                                                     'sobjectType' => sobjectType,
                                                     'recordTypeName' => recordTypeName,
                                                     'pickListFieldName'=> pickListFieldAPIName
                                                    }
                            );
    }
    
    /**
        Describe a picklist field for a SobjectType, its given record type ID and the picklist field
        example usage : 
        Id recType1Id = [Select Id from RecordType Where SobjectType = 'Account' 
                                            AND DeveloperName like 'Record_Type_2'].Id;
        System.assertEquals(REC_TYPE_1_OPTIONS, PicklistDescriber.describe('Account', recType2Id, 'Industry'));
    */
    public static List<PicklistOption> describe(String sobjectType, Id recordTypeId, String pickListFieldAPIName) {
        return parseOptions(
                            new Map<String, String> {
                                                     'sobjectType' => sobjectType,
                                                     'recordTypeId' => recordTypeId,
                                                     'pickListFieldName'=> pickListFieldAPIName
                                                    }
                            );
    }
    
    /*
        Internal method to parse the OPTIONS
    */
    static List<PicklistOption> parseOptions(Map<String, String> params) {
        Pagereference pr = Page.PicklistDesc;
        // to handle development mode, if ON
        pr.getParameters().put('core.apexpages.devmode.url', '1');
        
        for (String key : params.keySet()) {
            pr.getParameters().put(key, params.get(key));   
        }
        if(Test.isRunningTest()) {
            return new List<PicklistOption>{new PicklistOption('1', '2')};
        } else {
            String xmlContent = pr.getContent().toString();
            
            Matcher mchr = OPTION_PATTERN.matcher(xmlContent);
            List<PicklistOption> options = new List<PicklistOption>();
            while(mchr.find()) {
                // insert only if those picklist has value
                if(mchr.group(1) != '') {
                    options.add(new PicklistOption(mchr.group(1), mchr.group(2)));
                }
            }
            return options;
        }
    }
}