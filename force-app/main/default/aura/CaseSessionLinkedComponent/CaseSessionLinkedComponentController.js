({
    doInit: function (component, event, helper) {
        helper.init(component, event, helper);
    },

    openModalSearch: function(component, event, helper){
        component.set("v.isSearchModalOpen", true);
        component.set("v.errorMessage", null);
        component.set("v.isStartTableData",true);
        helper.getSearchInit(component, helper);
        var modal = component.find('modalId');
        var backdrop = component.find('backdropId');
        $A.util.addClass(backdrop, 'slds-backdrop_open');
        $A.util.removeClass(modal, 'slds-hide');
    },
    
    openModalNewCase: function(component, event, helper){
        component.set("v.errorMessage", null);
        var modal = component.find('modalId');
        $A.util.addClass(modal, 'slds-hide');
        component.set("v.isSearchModalOpen", false);
        component.set("v.isNewModalOpen", true);
        // get the fields API name and pass it to helper function  
            
        var PriorityFieldAPI =  component.get("v.PriorityFieldAPI");
        var StatusFieldAPI =  component.get("v.StatusFieldAPI");


        helper.fetchsinglePicklistValues(component, PriorityFieldAPI);
        helper.fetchsinglePicklistValues(component, StatusFieldAPI);
        component.set('v.selectedContact',undefined)
        component.set('v.simpleNewCase.SuppliedEmail',undefined)
        component.set('v.simpleNewCase.Description',undefined);
       
        helper.getOwner(component);
        
        var newModal = component.find('newModal');
        if(component.get("v.chooseCustomer")){
            $A.util.addClass(newModal, 'slds-modal_medium');                
        }
        $A.util.removeClass(newModal, 'slds-hide');
    },
   
    closeModalSearch: function(component, event, helper){
        var modal = component.find('modalId');
        var backdrop = component.find('backdropId');
        $A.util.removeClass(backdrop, 'slds-backdrop_open');
        $A.util.addClass(modal, 'slds-hide');
        component.set("v.isSearchModalOpen", false);
        component.set("v.SearchData", null);
    },

    closeModalNewCase: function(component, event, helper){
        var newModal = component.find('newModal');
        $A.util.addClass(newModal, 'slds-hide');
        component.set("v.isNewModalOpen", false);  
        
        component.set("v.isSearchModalOpen", true);
        component.set("v.isStartTableData",true);
        var modal = component.find('modalId');
        var backdrop = component.find('backdropId');
        $A.util.addClass(backdrop, 'slds-backdrop_open');
        $A.util.removeClass(modal, 'slds-hide');
    },

    submitNewCase: function(component, event, helper){
        helper.addNewCase(component, event, helper);
    },

    caseSearch: function (component, event, helper) {
        var keyword = component.find('enter-search').get('v.value');
        helper.searchCase(component, helper, keyword);
    },
    
    keyPressController : function(component, event, helper) {
        if (event.which == 13){
            var keyword = component.find('enter-search').get('v.value');
            helper.searchCase(component, helper, keyword);
        } 
    },

    lookupCustomerChanged: function(component, event, helper) { 
        // add new customer from lookup
        if(event.getParam('record') === null){
            var newModal = component.find('newModal');
            $A.util.addClass(newModal, 'slds-hide');
            component.set("v.isNewModalOpen", false);  

            var newCustomerModal = component.find('newCustomerModal');
            $A.util.removeClass(newCustomerModal, 'slds-hide');
            component.set("v.isNewCustomerOpen", true);  

            helper.getIndividualId(component);
        }
        else{
            var customerId = event.getParam('record').Id;
            if(customerId === ''){
                var modal = component.find('newModal');
                $A.util.removeClass(modal, 'slds-modal_medium');
                
                component.set("v.chooseCustomer" , false);
                component.set("v.simpleNewCase.AccountId", undefined);
                component.set("v.simpleNewCase.ContactEmail", undefined);
                component.set("v.simpleNewCase.ContactMobile", undefined);
            }
            else{
                component.set("v.chooseCustomer" , true);
                var modal = component.find('newModal');
                $A.util.addClass(modal, 'slds-modal_medium');
                helper.getCustomerInfo(component, customerId);
            }
        }
    },
    addCaseFromSearchtoLinked: function(component, event, helper){
        var caseId = event.target.id;
        var sessionId = component.get("v.recordId");
        

        helper.addCaseLinkage(component, event, helper, caseId, sessionId);
    },

    removeCaseFromSearchtoLinked: function(component, event, helper){
        var caseId = event.target.id;
        var sessionId = component.get("v.recordId");
        
        helper.deleteCaseLinkage(component, event, helper, caseId, sessionId);
    },

    closeModalNewCustomer: function(component){
        var newCustomerModal = component.find('newCustomerModal');
        $A.util.addClass(newCustomerModal, 'slds-hide');
        component.set("v.isNewCustomerOpen", false);  

        var newModal = component.find('newModal');
        $A.util.removeClass(newModal, 'slds-hide');
        component.set("v.isNewModalOpen", true);  
    },

    handleError: function(component, event, helper){
        var message = event.getParam("message");
        component.set("v.errorMessage", message);
    },

    handleSubmit: function(component){
        $A.util.removeClass(component.find('newCustomerSpinner'), 'slds-hide');
    },

    handleSuccess: function(component, event, helper){
        var newCustomerModal = component.find('newCustomerModal');
        $A.util.addClass(newCustomerModal, 'slds-hide');
        component.set("v.isNewCustomerOpen", false);  

        var newModal = component.find('newModal');
        $A.util.removeClass(newModal, 'slds-hide');
        component.set("v.isNewModalOpen", true);  
        $A.util.addClass(component.find('newCustomerSpinner'), 'slds-hide');
        helper.showToast("success", "Customer was created.");
    }
})