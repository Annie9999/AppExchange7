({
	doInit: function (component, event, helper) {
        helper.before_init(component, event, helper);
    },
	toggleSwitchButton : function(component, event, helper) {
		var isShowDetail = component.get("v.isShowDetail");
		component.set("v.isShowDetail", !isShowDetail);
	},
	openModalEditCase: function(component, event, helper){
        component.set("v.errorMessageEdit", null);
        component.set("v.selectedCase", event.target.id);
		// get the fields API name and pass it to helper function  
		
		var PriorityFieldAPI =  component.get("v.PriorityFieldAPI");
		var StatusFieldAPI =  component.get("v.StatusFieldAPI");
		
		helper.fetchsinglePicklistValues(component, PriorityFieldAPI);
		helper.fetchsinglePicklistValues(component, StatusFieldAPI);
		helper.setOldCaseData(component);
    },
	openModalDeleteCase: function(component, event, helper){
        component.set("v.errorMessageDelete", null);
        component.set("v.sessionCaseDup", null);  
        component.set("v.selectedCase", event.target.id);
		component.set("v.isDeleteModalOpen", true);
		var modal = component.find('deleteModal');
        var backdrop = component.find('backdrop');
        $A.util.addClass(backdrop, 'slds-backdrop_open');
        $A.util.removeClass(modal, 'slds-hide');
        helper.findDupCaseBeforeDelete(component);
    
	},
	closeModalDelete: function(component, event, helper){
		var modal = component.find('deleteModal');
        var backdrop = component.find('backdrop');
        $A.util.removeClass(backdrop, 'slds-backdrop_open');
        $A.util.addClass(modal, 'slds-hide');
        component.set("v.isDeleteModalOpen", false);
	},
	closeModalEdit: function(component, event, helper){
		var modal = component.find('editModal');
        var backdrop = component.find('backdrop');
        $A.util.removeClass(backdrop, 'slds-backdrop_open');
        $A.util.addClass(modal, 'slds-hide');
        component.set("v.isEditModalOpen", false);
    },
	deleteCase: function(component, event, helper){
		helper.deletedCase(component);
	},
	submitEditCase: function(component, event, helper){
		helper.editCase(component, event, helper);
	},

    
    lookupCustomerChanged: function(component, event, helper) { 
        if(event.getParam('record') === null){
            var editModal = component.find('editModal');
            $A.util.addClass(editModal, 'slds-hide');
            component.set("v.isEditModalOpen", false);

            var newCustomerModal = component.find('newCustomerModal');
            $A.util.removeClass(newCustomerModal, 'slds-hide');
            component.set("v.errorMessageNew", null);
            component.set("v.isNewCustomerOpen", true);  
            helper.getIndividualId(component);
        }
        else{
            var customerId = event.getParam('record').Id;
            if(customerId === ''){
                var modal = component.find('editModal');
                $A.util.removeClass(modal, 'slds-modal_medium');
                
                component.set("v.chooseCustomer" , false);
                component.set("v.simpleNewCase.AccountId", undefined);
                component.set("v.simpleNewCase.ContactEmail", undefined);
                component.set("v.simpleNewCase.ContactMobile", undefined);
            }
            else{
                component.set("v.chooseCustomer" , true);
                var modal = component.find('editModal');
                $A.util.addClass(modal, 'slds-modal_medium');
                helper.getCustomerInfo(component, customerId);
            }
        }
    },

    closeModalNewCustomer: function(component){
        var newCustomerModal = component.find('newCustomerModal');
        $A.util.addClass(newCustomerModal, 'slds-hide');
        component.set("v.isNewCustomerOpen", false);  

        var editModal = component.find('editModal');
        $A.util.removeClass(editModal, 'slds-hide');
        component.set("v.isEditModalOpen", true);  
    },

    handleError: function(component, event, helper){
        var message = event.getParam("message");
        component.set("v.errorMessageNew", message);  
    },

    handleSubmit: function(component){
        $A.util.removeClass(component.find('newCustomerSpinner'), 'slds-hide');
    },

    handleSuccess: function(component, event, helper){
        var newCustomerModal = component.find('newCustomerModal');
        $A.util.addClass(newCustomerModal, 'slds-hide');
        component.set("v.isNewCustomerOpen", false);  

        var editModal = component.find('editModal');
        $A.util.removeClass(editModal, 'slds-hide');
        component.set("v.isEditModalOpen", true);  
        $A.util.addClass(component.find('newCustomerSpinner'), 'slds-hide');
        helper.showToast("success", "Customer was created.");
    },

    editRecord : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        component.set("v.errorMessageEdit", null);
        component.set("v.selectedCase", event.target.id);
        console.log('caseId'+ component.get('v.selectedCase'));
        editRecordEvent.setParams({
            'recordId': component.get('v.selectedCase')
        });
        editRecordEvent.fire();
    }
})