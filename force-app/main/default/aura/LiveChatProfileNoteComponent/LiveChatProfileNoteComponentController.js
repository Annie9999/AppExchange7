({
	init: function(component, event, helper) {
        var action = component.get("c.getNote");
        var recordId = component.get("v.recordId");
		if (recordId === undefined || recordId === null) {
			return;
		}
		action.setParams({
			'recordId': recordId,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Note', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
});