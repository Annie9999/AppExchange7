({
	getCustomers: function(component, event, helper) {
		var recordId = component.get("v.recordId");
		if (recordId === undefined || recordId === null) {
			return;
		}
		console.log("recordId",recordId)
		var action = component.get("c.getCustomer");
		console.log("Action",action);
		action.setParams({
			'recordId': recordId,
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
				component.set("v.customerdata", rtnValue.customerdataTables);
				component.set("v.customersize", rtnValue.size);
				if(rtnValue.size !== 0){
					console.log(rtnValue.size);
					component.set("v.isNotZeroSize","true");
				}
                
			}
		});
		$A.enqueueAction(action);
	}
})