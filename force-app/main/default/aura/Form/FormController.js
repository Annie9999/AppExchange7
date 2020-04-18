({
    clickCreate : function(component, event, helper) {
        var recordUsername = component.get("v.Config.iigproduct__username__c");
        var recordPassword = component.get("v.Config.iigproduct__password__c");
        var recordLine_user_id = component.get("v.Config.iigproduct__line_user_id__c");
        var recordGrant_type = component.get("v.Config.iigproduct__grant_type__c");
        var recordClient_id = component.get("v.Config.iigproduct__client_id__c");
        var recordClient_secret = component.get("v.Config.iigproduct__client_secret__c");
        var recordSession_expired = component.get("v.Config.iigproduct__session_expired__c");
        var recordChatQueue = component.get("v.Config.iigproduct__chatQueue__c");
        var recordId = component.get("v.Config.Id");

        


        console.log(recordUsername+recordPassword+recordLine_user_id+recordGrant_type+recordClient_id+recordClient_secret+recordSession_expired+recordChatQueue);
        console.log(recordId);

        var action = component.get("c.getConfigInfo");

        action.setParams({ "Username" : recordUsername ,
        "Password" : recordPassword,
        "Line_user_id" : recordLine_user_id,
        "Grant_type" : recordGrant_type,
        "RecordClient_id" : recordClient_id,
        "RecordClient_secret" : recordClient_secret,
        "Session_expired":recordSession_expired,
        "ChatQueue":recordChatQueue,
        "recordId":recordId
     });

        action.setCallback(this, function(response){
            
                        var state = response.getState();
                        console.log(state);

                        if (state === "SUCCESS") {
                            console.log(response.getReturnValue());
                           
            
                        }
                        else{
                            alert('Wrong !!');
                        }
            
                    }); 
            
                 $A.enqueueAction(action);
            
    },
    doInit : function(component,event,helper)
    {
       console.log('Hi from init ');
       var action = component.get("c.viewRecord");
       action.setCallback(this, function(response){
            
        var state = response.getState();
        console.log(state);

        if (state === "SUCCESS") {
            console.log(response.getReturnValue());
            console.log(response.getReturnValue().Id);
            //  component.set('v.Config.username__c');
            //  component.set('v.Config.password__c');
            //  component.set('v.Config.line_user_id__c');
            //  component.set('v.Config.grant_type__c');
            //  component.set('v.Config.client_id__c');
            //  component.set('v.Config.client_secret__c');
            component.set('v.Config',response.getReturnValue());
            console.log('retrieve data finish ');

        }
        else{
           
        }

    }); 

 $A.enqueueAction(action);

    console.log('Finishh from init ');
    }
})