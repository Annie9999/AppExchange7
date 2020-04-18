({
    init : function(component,event,helper) {
        console.log('you are in helper !!');

        console.log('before call apex');
        var action = component.get("c.connectAPI");
        console.log('hi');


    //     action.setParams({ "Username" : recordUsername ,
    //     "Password" : recordPassword,
    //     "Line_user_id" : recordLine_user_id,
    //     "Grant_type" : recordGrant_type,
    //     "RecordClient_id" : recordClient_id,
    //     "RecordClient_secret" : recordClient_secret
    //  });


        action.setCallback(this, function(response){
            
                        var state = response.getState();
                        console.log(state);

                        if (state === "SUCCESS") {
                            console.log(response.getReturnValue());
                            
                            
            
                        }
            
                    });
            
                 $A.enqueueAction(action);
    }
})