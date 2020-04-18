public with sharing class connectAPI {

    @AuraEnabled
    public static void connectAPI(){
        ChatConfiguration__c config = [SELECT iigproduct__username__c,iigproduct__password__c,iigproduct__client_id__c,iigproduct__client_secret__c,iigproduct__grant_type__c,iigproduct__line_user_id__c,iigproduct__chatQueue__c,iigproduct__sessionExpired__c FROM ChatConfiguration__c LIMIT 1];
        System.debug(config);
        System.debug(config.username__c);
        System.debug(config.password__c);
        System.debug(config.client_id__c);
        System.debug(config.client_secret__c);
        System.debug(config.grant_type__c);
        System.debug(config.line_user_id__c);
        System.debug(config.iigproduct__chatQueue__c);
        System.debug(config.iigproduct__sessionExpired__c);



        
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://3b694a76.ngrok.io/getwebhookurl');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');

            String body = '{"channel_id" : "1654015478"},'+
            '{"channel_access_token" : "AaVWNHwkXGEAHOSt6xaUH98Brl+XUFDNjFSEVP/Ldzoi4dxBfMslgkxWAvY9saHVSReY/PMYSe8l8UM7rHSpd5o85xDc3QjMjksYnl89KVpFrj8Wzer5KKxcMusDUsX2kAQBhC0ePnIKEXKtg9DPjgdB04t89/1O/w1cDnyilFU="},'+
            '{"channel_secret" : "f55736b4289d7ea3b01a2ebcba3ea449"},'+
            '{"domain" : "https://login.salesforce.com/services/oauth2/token?"},'+
            '{"liveChatHost" : "https://iigproduct-dev-ed.my.salesforce.com/services/apexrest/iigproduct/"},'+
            '{"clientId" : "3MVG9n_HvETGhr3AJ85yX_S5fTTYfr7TvBWh1VhHqAjoozxVleQXeFn4BZvM1qCXSkiN.p9xHbrNutOQpP4zm"}'+
            '{"clientSecret" : "B02869EF5E6F279093A567587D9C8D33B1E19734BEA00629A432423BC6DDD3F6"}'+
            '{"username" : "pai@ii.co.th"}'+
            '{"password" : "phai1379"}';



            String body2 ='[{'+
                '"channel_id":"1654015478",'+
                '"channel_access_token":"AaVWNHwkXGEAHOSt6xaUH98Brl+XUFDNjFSEVP/Ldzoi4dxBfMslgkxWAvY9saHVSReY/PMYSe8l8UM7rHSpd5o85xDc3QjMjksYnl89KVpFrj8Wzer5KKxcMusDUsX2kAQBhC0ePnIKEXKtg9DPjgdB04t89/1O/w1cDnyilFU=",'+
                '"channel_secret":"f55736b4289d7ea3b01a2ebcba3ea449",'+
                '"domain":"https://login.salesforce.com/services/oauth2/token?",'+
                '"liveChatHost":"https://iigproduct-dev-ed.my.salesforce.com/services/apexrest/iigproduct/",'+
                '"clientId":"3MVG9n_HvETGhr3AJ85yX_S5fTTYfr7TvBWh1VhHqAjoozxVleQXeFn4BZvM1qCXSkiN.p9xHbrNutOQpP4zm",'+
                '"clientSecret":"B02869EF5E6F279093A567587D9C8D33B1E19734BEA00629A432423BC6DDD3F6",'+
                '"username":"pai@ii.co.th",'+
                '"password":"phai1379",'+
               '}]';



            String bodyAsJSON = JSON.serialize(body2);
            
            request.setBody(body2);
            System.debug('view body : '+bodyAsJSON);
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
            } else {
                System.debug(response.getBody());
            }
            // return response;
        




        // Http http = new Http();
        // HttpRequest request = new HttpRequest();
        // request.setEndpoint('https://3b694a76.ngrok.io/getwebhookurl');
        // request.setMethod('GET');
        // HttpResponse response = http.send(request);
        // // If the request is successful, parse the JSON response.
        // if (response.getStatusCode() == 200) {
        // // Deserialize the JSON string into collections of primitive data types.
        // Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        // // Cast the values in the 'animals' key as a list
        // List<Object> animals = (List<Object>) results.get('animals');
        // System.debug('Received the following animals:');
        // for (Object animal: animals) {
        // System.debug(animal);
           
        }
        
    
}