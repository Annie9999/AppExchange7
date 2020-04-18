({
    ConnectAPI : function(component,event,helper)
    {
       
        var action = component.get("c.connectAPI");
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