({
    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },

    handleSubmit: function(cmp, event, helper) {
		console.log('submit');
		
        cmp.set('v.disabled', true);
		cmp.set('v.showSpinner', true);
		cmp.set("v.errorMessage" , null);
		var defaultValueField = cmp.get("v.defaultValueField");
		//var selectedProject = cmp.get("v.selectedProject");
		var dependentField = JSON.parse(cmp.get("v.dependentField"));
		console.dir(dependentField);
		event.preventDefault();
		var eventFields = event.getParam("fields");
		
		if(dependentField){
			for (var fieldName in dependentField){
				eventFields[fieldName] = eventFields[dependentField[fieldName]];
			}
		}
		/*if(selectedProject){
			console.log('submit selectedProject');
			eventFields["Interested_Project__c"] = selectedProject.Id;
		}*/
		if(defaultValueField){
			for (var fieldName in defaultValueField){
				eventFields[fieldName] = defaultValueField[fieldName];
			}
		}
		cmp.find('leadCreateForm').submit(eventFields);
    },

	handleOnError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:messages
		// so this just hides the spinner
		console.log('handleOnError');
		cmp.set('v.showSpinner', false);
		cmp.set('v.disabled', false);
		var params = event.getParams();
		console.dir(JSON.parse(JSON.stringify(params)));
	},

    handleSuccess: function(cmp, event, helper) {
        var params = event.getParams();
        cmp.set('v.recordId', params.response.id);
        cmp.set('v.showSpinner', false);
		cmp.set('v.saved', true);
		console.log('success');
		console.dir(JSON.parse(JSON.stringify(params)));

		var afterCreateLeadRecord = cmp.getEvent("afterCreateLeadRecord");
		afterCreateLeadRecord.setParams({ 
			params: { 
				recordId : params.response.id,
				isCreating : cmp.get('v.isCreating')
			} 
		});
		afterCreateLeadRecord.fire();
	},
	handleClick: function(cmp, event, helper) {
        var afterCreateLeadRecord = cmp.getEvent("afterCreateLeadRecord");
		afterCreateLeadRecord.setParams({ 
			params: {} 
		});
		afterCreateLeadRecord.fire();
	},
	handleClickSave: function(cmp, event, helper) {
	   console.log('handleClickSave');
	   var errorMessage = cmp.get("v.errorMessage");
	   cmp.set("v.errorMessage" , 'Please complete required fields.');
    }
});