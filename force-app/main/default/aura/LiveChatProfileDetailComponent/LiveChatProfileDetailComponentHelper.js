({
	clearEditDetailInformation: function (component) {
		component.set('v.isOpenEditDetail',false);
		component.set('v.editdetailErrorMessage',null);
	},
	saveEditDetailInformation: function (component, event, helper) {
		$A.util.removeClass(component.find('editDetailLoading'), 'slds-hide');		

		var action = component.get("c.updateSocialAccountIfEditDetailOccured");
		action.setParams({
			'recordId': component.get("v.recordId"),
			'firstName': component.get("v.firstNameValue"),
			'lastName': component.get("v.lastNameValue"),
			'firstNameEN': component.get("v.firstNameENValue"),
			'lastNameEN': component.get("v.lastNameENValue"),
			'phone': component.get('v.phoneValue'),
			'email' : component.get("v.emailValue"),
			'lineId' : component.get("v.lineIdValue")
		});
		action.setCallback(this, function (response) {
			
		var state = response.getState();
		
		if (state == 'SUCCESS') {
			var rtnValue = response.getReturnValue();
			if(rtnValue.status){
				this.clearEditDetailInformation(component);
			}
			else{
				component.set('v.editdetailErrorMessage', 'Saving informations failed');
			}
		}
		$A.util.addClass(component.find('editDetailLoading'), 'slds-hide');		
	});
	$A.enqueueAction(action);
	var act = component.get("c.getDetail");
	var recordId = component.get("v.recordId");
	console.log('recordId',recordId)
	if (recordId === undefined || recordId === null) {
		return;
	}
	act.setParams({
		'recordId': recordId,
	});
	
	act.setCallback(this, function(response) {
		var state = response.getState();
		if (state === "SUCCESS") {
			var rtnValue = response.getReturnValue();
			component.set("v.Detail", rtnValue.detailData);
			component.set("v.isUser", rtnValue.isUser);
			component.set("v.isGroup", rtnValue.isGroup);
		}
	});
	$A.enqueueAction(act);
	}	
})