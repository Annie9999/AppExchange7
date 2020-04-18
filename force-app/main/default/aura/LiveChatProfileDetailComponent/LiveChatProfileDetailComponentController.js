({
	init: function(component, event, helper) {
		var action = component.get("c.getDetail");
		var recordId = component.get("v.recordId");
		console.log('recordId',recordId)
		if (recordId === undefined || recordId === null) {
			return;
		}
		action.setParams({
			'recordId': recordId,
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
				component.set("v.Detail", rtnValue.detailData);
				component.set("v.isUser", rtnValue.isUser);
				component.set("v.isGroup", rtnValue.isGroup);
				component.set("v.isUserLevelSecurity",rtnValue.isUserLevelSecurity);
				var userSocialAccountColumnName = rtnValue.socialType === 'Line'? 'Line ID' : 'Account Facebook';
				component.set("v.userSocialAccountColumnName",userSocialAccountColumnName);
            }
        });
        $A.enqueueAction(action);
	},
	onClickEditDetail:function(component, event, helper) {
		var action = component.get("c.getDetail");
		var recordId = component.get("v.recordId");
		console.log('recordId',recordId)
		if (recordId === undefined || recordId === null) {
			return;
		}
		action.setParams({
			'recordId': recordId,
		});
		
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
				component.set("v.firstNameValue", rtnValue.firstName);
				component.set("v.lastNameValue", rtnValue.lastName);
				component.set("v.firstNameENValue", rtnValue.firstNameEN);
				component.set("v.lastNameENValue", rtnValue.lastNameEN);
				component.set("v.phoneValue", rtnValue.phone);
				component.set("v.emailValue", rtnValue.email);
				component.set("v.lineIdValue", rtnValue.lineId);
			}
		});
		$A.enqueueAction(action);
		component.set('v.isOpenEditDetail',true);

	},
	onClickCancelEditDetail: function (component, event, helper) {
		helper.clearEditDetailInformation(component);
	},
	onClickSubmitEditDetail: function (component, event, helper) {
		var firstName = component.get("v.firstNameValue");
		var lastName =  component.get("v.lastNameValue");
		var firstNameEN = component.get("v.firstNameENValue");
		var lastNameEN =  component.get("v.lastNameENValue");
		var phone = component.get('v.phoneValue');
		var email = component.get("v.emailValue");
		var lineId = component.get("v.lineIdValue");
		if((firstName === undefined || firstName === null) && (lastName === undefined || lastName === null)&& (firstNameEN === undefined || firstNameEN === null)&& (lastNameEN === undefined || lastNameEN === null) &&(phone === undefined || phone === null)&&( email === undefined ||  email  === null)&&( lineId === undefined ||  lineId === null)){
			component.set('v.editdetailErrorMessage','Please fill in Edit Detail.');
			return;
		}
	  	helper.saveEditDetailInformation(component, event, helper);
	}
});