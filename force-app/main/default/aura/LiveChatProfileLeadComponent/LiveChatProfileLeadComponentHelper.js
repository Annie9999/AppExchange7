({
	getLeads: function(component, event, helper) {
		var recordId = component.get("v.recordId");
		if (recordId === undefined || recordId === null) {
			return;
		}
		console.log("recordId",recordId)
		var action = component.get("c.getLead");
		console.log("Action",action);
		action.setParams({
			'recordId': recordId,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
				component.set("v.leaddata", rtnValue.leaddataTables);
				component.set("v.leadsize", rtnValue.size);
				if(rtnValue.size !== 0){
					console.log(rtnValue.size);
					component.set("v.isNotZeroSize","true");
				}
                
			}
		});
		$A.enqueueAction(action);
	}
})