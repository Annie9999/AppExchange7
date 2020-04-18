({
    init : function(component, event, helper) {
        
        $A.util.removeClass(component.find('waitingSpinner'), 'slds-hide');
        var recordId = component.get("v.recordId");
		if (recordId === undefined || recordId === null) {
			return;
		}
        var action = component.get("c.getInitData");
		action.setParams({
			'recordId': recordId,
		});
		action.setCallback(this, function (response) {
            var state = response.getState();
			if (state === "SUCCESS") {
                var rtnValue = response.getReturnValue();
                component.set("v.caseList", rtnValue.caseDetail);
                component.set("v.caseSize", rtnValue.size);
            }
            $A.util.addClass(component.find('waitingSpinner'), 'slds-hide');            
		});
		$A.enqueueAction(action);
    },
    
    getSearchInit: function(component, helper){
        var recordId = component.get("v.recordId");
		if (recordId === undefined || recordId === null) {
            component.set("v.errorMessage", "An error occured. Please refresh page and try again later.");
			return;
		}
        var action = component.get("c.getInitSearchData");
		action.setParams({
			'recordId': recordId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
                if(rtnValue.size > 0){
                    var allRecordsSetted = helper.changeDateFormat(component, rtnValue.caseAccList);
                    component.set("v.SearchData", allRecordsSetted);
                }
                else{
                    component.set("v.SearchData", null);
                }
            }     
		});
		$A.enqueueAction(action);
    },
    
    searchCase: function(component, helper, keyword){
        if(keyword.length >= 2){
            component.set("v.isStartTableData",false);
            $A.util.removeClass(component.find('searchSpinner'), 'slds-hide');
            component.set('v.isSearching',true);
            component.set("v.errorMessage", null);		
            var action = component.get("c.getSearchData");
            action.setParams({
                'keyword': keyword
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var rtnValue = response.getReturnValue();
                    if(rtnValue.size > 0){
                        var allRecordsSetted = helper.changeDateFormat(component, rtnValue.caseAccList);
                        component.set("v.SearchData", allRecordsSetted);
                    }
                    else{
                        component.set("v.SearchData", null);
                    }
                }
                $A.util.addClass(component.find('searchSpinner'), 'slds-hide');
                component.set('v.isSearching',false);
            });
            $A.enqueueAction(action);
        }
        else if(keyword.length == 0){
            component.set("v.errorMessage", "Please input data in search box");
        }
        else{
            component.set("v.errorMessage", "Please type keyword at least 2 letters");
        }
    },

    changeDateFormat: function (component, records) {
        var caseList = component.get("v.caseList");
        var caseIdInThisSession = [];

        for(var index in caseList){
            caseIdInThisSession.push(caseList[index].iigproduct__Case__c);
        }
     
        for (var idx in records) {
            if (caseIdInThisSession.length > 0) {
                    if (caseIdInThisSession.includes(records[idx].Id)) {
                        records[idx].isLinked = true;
                    } else {
                        records[idx].isLinked = false;
                    }
                
            } else {
                records[idx].isLinked = false;
            }

            var day = new Date(records[idx].CreatedDate).getDate();
            var month = new Date(records[idx].CreatedDate).getMonth() + 1;
            var year = new Date(records[idx].CreatedDate).getFullYear();
            var time = new Date(records[idx].CreatedDate).toLocaleTimeString('nb-NO');
            var CreatedDateDisplay = day + '/' + month + '/' + year + ' ' + time;

            records[idx].CreatedDate = CreatedDateDisplay;

            var day = new Date(records[idx].LastModifiedDate).getDate();
            var month = new Date(records[idx].LastModifiedDate).getMonth() + 1;
            var year = new Date(records[idx].LastModifiedDate).getFullYear();
            var time = new Date(records[idx].LastModifiedDate).toLocaleTimeString('nb-NO');
            var CreatedDateDisplay = day + '/' + month + '/' + year + ' ' + time;

            records[idx].LastModifiedDate = CreatedDateDisplay;
        }
        return records;
    },

    addCaseLinkage: function(component, event, helper, caseId, sessionId,index){
        $A.util.removeClass(component.find('searchSpinner'), 'slds-hide');
        var action = component.get("c.insertCaseLinkage");
		action.setParams({
            'caseId': caseId,
            'sessionId': sessionId
		});
		action.setCallback(this, function (response) {
            var state = response.getState();

			if (state === "SUCCESS") {
                var rtnValue = response.getReturnValue();
                
                if(rtnValue.status){
                    helper.init(component, event, helper);
                    var keyword = component.find('enter-search').get('v.value');
                    if(keyword === ''){
                        helper.refreshGetSearchInit(component, helper);
                    }
                    else{
            
                        helper.refreshSearchCase(component, helper, keyword);
                        
                    }
        
                    $A.get('e.force:refreshView').fire();
        
                }
                else{
                    component.set("v.errorMessage", rtnValue.errorMsg);
                    $A.util.addClass(component.find('searchSpinner'), 'slds-hide');
                }
            }     
            else{
                $A.util.addClass(component.find('searchSpinner'), 'slds-hide');
            }
		});
		$A.enqueueAction(action);
    },

    deleteCaseLinkage: function(component, event, helper, caseId, sessionId,index){
        $A.util.removeClass(component.find('searchSpinner'), 'slds-hide');
        var action = component.get("c.deleteCaseLinkage");
		action.setParams({
            'caseId': caseId,
            'sessionId': sessionId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
                if(rtnValue.status){
                    helper.init(component, event, helper);
                    var keyword = component.find('enter-search').get('v.value');
                    if(keyword === ''){
                        helper.refreshGetSearchInit(component, helper);
                       
                    }
                    else{
                        helper.refreshSearchCase(component, helper, keyword);
                      
                    }
                    $A.get('e.force:refreshView').fire();
                }
                else{
                    component.set("v.errorMessage", rtnValue.errorMsg);
                    $A.util.addClass(component.find('searchSpinner'), 'slds-hide');
                }
            }
            else{
                $A.util.addClass(component.find('searchSpinner'), 'slds-hide');
            }
		});
		$A.enqueueAction(action);
    },

    refreshGetSearchInit: function(component, helper){
        
        var recordId = component.get("v.recordId");
		if (recordId === undefined || recordId === null) {
            component.set("v.errorMessage", "An error occured. Please refresh page and try again later.");
            $A.util.addClass(component.find('searchSpinner'), 'slds-hide');
			return;
		}
        var action = component.get("c.getInitSearchData");
        
		action.setParams({
			'recordId': recordId
        });
		action.setCallback(this, function (response) {
            
            var state = response.getState();

			if (state === "SUCCESS") {
                var rtnValue = response.getReturnValue();
    
                if(rtnValue.size > 0){
        
                    var allRecordsSetted = helper.changeDateFormat(component, rtnValue.caseAccList);
                    component.set("v.SearchData", allRecordsSetted);
                }
                else{
                    component.set("v.SearchData", null);
                }
            }     
            $A.util.addClass(component.find('searchSpinner'), 'slds-hide');
		});
		$A.enqueueAction(action);
    },
   
    refreshSearchCase: function(component, helper, keyword){
        component.set("v.errorMessage", null);		
        var action = component.get("c.getSearchData");
        action.setParams({
            'keyword': keyword
        });
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var rtnValue = response.getReturnValue();
    
                if(rtnValue.size > 0){
                    var allRecordsSetted = helper.changeDateFormat(component, rtnValue.caseAccList);
                    
                    component.set("v.SearchData", allRecordsSetted);
                }
                else{
                    component.set("v.SearchData", null);
                }
            }
            $A.util.addClass(component.find('searchSpinner'), 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    
    addNewCase: function(component, event, helper){
        var acc = component.get('v.simpleNewCase.AccountId');
       
        var status = component.get('v.simpleNewCase.Status');
        if(acc === undefined){
            component.set("v.errorMessage", 'Please select customer for this case.');
        }
        
        else if(status === undefined || status === '--None--'){
            component.set("v.errorMessage", 'Please select status for this case.');
        }
        else{
            $A.util.removeClass(component.find('waitingSpinner'), 'slds-hide');
            var action = component.get("c.insertNewCase");

            
            action.setParams({
                'accountId': component.get('v.simpleNewCase.AccountId'),
                'origin': component.get('v.simpleNewCase.Origin'),
                'priority': component.get('v.simpleNewCase.Priority'),
                'status': component.get('v.simpleNewCase.Status'),
                'description': component.get('v.simpleNewCase.Description'),
                'sessionId': component.get('v.recordId'),
                'webEmail': component.get('v.simpleNewCase.SuppliedEmail'),
                'contactName':component.get('v.selectedContact.Id')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var rtnValue = response.getReturnValue();
                    if(rtnValue.status){
                        helper.init(component, event, helper);
                    }
                    else{
                        component.set("v.errorMessage", rtnValue.errorMsg);
                    }
                    $A.get('e.force:refreshView').fire();
                }
                var searchModal = component.find('modalId');
                var newModal = component.find('newModal');
                var backdrop = component.find('backdropId');
                $A.util.removeClass(backdrop, 'slds-backdrop_open');
                $A.util.addClass(searchModal, 'slds-hide');
                $A.util.addClass(newModal, 'slds-hide');
                component.set("v.isSearchModalOpen", false);
                component.set("v.isNewModalOpen", false);  

                $A.util.addClass(component.find('waitingSpinner'), 'slds-hide');
            });
            $A.enqueueAction(action);


        }
        
    },

    fetchsinglePicklistValues: function(component, PicklistFieldAPI) {
        $A.util.removeClass(component.find('loadingSpinner'), 'slds-hide');
        // create a empty array var for store dependent picklist values for controller field 
       
		var action = component.get("c.getsinglePicklist");
       
		action.setParams({
            'fieldName' : PicklistFieldAPI
        });
		action.setCallback(this, function(response) {

            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var PicklistField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    if(PicklistFieldAPI != "Status"){
                        PicklistField.push('--None--');
                    }
                }
            
                for (var i = 0; i < listOfkeys.length; i++) {
                    PicklistField.push(listOfkeys[i]);
                }  

            }
            if(PicklistFieldAPI == "Priority"){
                component.set("v.listCasePriority", PicklistField);
            }
            else if(PicklistFieldAPI == "Status"){
                component.set("v.listCaseStatus", PicklistField);
                component.set("v.simpleNewCase.Status", 'Open');
            }
            
            $A.util.addClass(component.find('loadingSpinner'), 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    
    getCustomerInfo: function(component, customerId){
        var action = component.get("c.getCustomerInfo");
        action.setParams({
            'accountId': customerId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rtnValue = response.getReturnValue();
                component.set("v.simpleNewCase.AccountId", rtnValue.Id);
               
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function(type, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },

    getIndividualId: function(component){
        var action = component.get("c.getIndividual");
        action.setParams({
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rtnValue = response.getReturnValue();
                component.set("v.IndividualId", rtnValue.Id);

            }
        });
        $A.enqueueAction(action);
    },

    getOwner: function(component){
        var action = component.get("c.getOwner");
        action.setParams({
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rtnValue = response.getReturnValue();
                component.set("v.ownerName", rtnValue);

            }
        });
        $A.enqueueAction(action);
    }
})