({  before_init : function(component, event, helper) {

    var recordData = component.get("v.recordData");
    if (recordData === undefined || recordData === null) {
        return;
    }
    component.set('v.temp',recordData.iigproduct__Case__c);

    var beforeAction = component.get("c.retrieveData");
    beforeAction.setParams({
        'caseId' : component.get("v.temp")
    });
    beforeAction.setCallback(this, function (response) {
        var state = response.getState();
        
        if (state === "SUCCESS") {
            var rtnValue = response.getReturnValue();
            
            var Casenum = [];
            var CaseId =[];
            var stringify = JSON.parse(JSON.stringify(rtnValue));
            for (var i = 0; i < stringify.length; i++) {
                 Casenum.push(stringify[i]['CaseNumber']);
                 CaseId.push(stringify[i]['Id']);
               
                
            }
            component.set('v.case_Obj',rtnValue);
            component.set('v.caseObj',Casenum);
            component.set('v.caseObjId',CaseId);
            helper.init(component,event,helper,rtnValue)
            
            
        }
    });
    $A.enqueueAction(beforeAction);
    ///////////////////
    
    },
	init : function(component, event, helper,caseObj) {
        var recordData = component.get("v.recordData");
        
		if (recordData === undefined || recordData === null) {
			return;
        }
       
        var caseOwner = component.get("v.case_Obj");

        var stringify = JSON.parse(JSON.stringify(caseOwner));
        for (var i = 0; i < stringify.length; i++) {
        
        var action = component.get("c.getInitData");
		action.setParams({
            'ownerId': stringify[i]['OwnerId'],
            'accountId': stringify[i]['AccountId']
		});
		action.setCallback(this, function (response) {
            var state = response.getState();
			if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
				component.set("v.owner", rtnValue.owner);
				component.set("v.acc", rtnValue.acc);
			}
		});
        $A.enqueueAction(action);
        }
	},

	deletedCase: function(component){
        var sessionId = component.get("v.sessionId");
		if (sessionId === undefined || sessionId === null) {
			return;
		}
        $A.util.removeClass(component.find('waitingSpinner'), 'slds-hide');
		var action = component.get("c.handleDeleteCase");
        action.setParams({
            'id': component.get("v.selectedCase"),
            'sessionId': sessionId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
                if(rtnValue.status){
					var compEvent = component.getEvent("refreshRecord");
                    compEvent.fire();
                    var modal = component.find('deleteModal');
                    var backdrop = component.find('backdrop');
                    $A.util.removeClass(backdrop, 'slds-backdrop_open');
                    $A.util.addClass(modal, 'slds-hide');
                    component.set("v.isDeleteModalOpen", false);
                    $A.get('e.force:refreshView').fire();
				}
				else{
                    component.set("v.errorMessageDelete", rtnValue.errorMsg);  
                }
            }
            $A.util.addClass(component.find('waitingSpinner'), 'slds-hide');
		});
		
		$A.enqueueAction(action);
    },
    
    findDupCaseBeforeDelete: function(component){
        var sessionId = component.get("v.sessionId");
		if (sessionId === undefined || sessionId === null) {
			return;
		}
		var action = component.get("c.checkDupCaseBeforeDelete");
        action.setParams({
            'id': component.get("v.selectedCase"),
            'sessionId': sessionId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
				if(rtnValue.status){
                    var dupCase = rtnValue.dupCase;
                    if(dupCase != null){
                        for (var index in dupCase) {
                            var day = new Date(dupCase[index].ChatSession__r.CreatedDate).getDate();
                            var month = new Date(dupCase[index].ChatSession__r.CreatedDate).getMonth() + 1;
                            var year = new Date(dupCase[index].ChatSession__r.CreatedDate).getFullYear();
                            var time = new Date(dupCase[index].ChatSession__r.CreatedDate).toLocaleTimeString('nb-NO');
                            var CreatedDateDisplay = day + '/' + month + '/' + year + ' ' + time;
                            dupCase[index].CreatedDateDisplay = CreatedDateDisplay;
                        }
                        component.set("v.sessionCaseDup", dupCase);  
                    }
				}
				else{
                    component.set("v.errorMessageDelete", rtnValue.errorMsg);  
				}
			}
		});
		
		$A.enqueueAction(action);
    },

	editCase: function(component, event, helper){
        var acc = component.get('v.simpleNewCase.AccountId');
        
        var status = component.get('v.simpleNewCase.Status');
        if(acc === undefined){
            component.set("v.errorMessageEdit", 'Please select customer for this case.');  
        }
        else if(status === undefined || status === '--None--'){
            component.set("v.errorMessageEdit", 'Please select status for this case.');  
        }
        else{
            $A.util.removeClass(component.find('waitingSpinner'), 'slds-hide');
            var action = component.get("c.updateCase");
            action.setParams({
				'caseId': component.get('v.selectedCase'),
                'accountId': component.get('v.simpleNewCase.AccountId'),
                'origin': component.get('v.simpleNewCase.Origin'),
                'priority': component.get('v.simpleNewCase.Priority'),
                'status': component.get('v.simpleNewCase.Status'),
                'description': component.get('v.simpleNewCase.Description')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
					var rtnValue = response.getReturnValue();
					if(rtnValue.status){
						var compEvent = component.getEvent("refreshRecord");
                        compEvent.fire();
                        $A.get('e.force:refreshView').fire();
					}
					else{
                        component.set("v.errorMessageEdit", rtnValue.errorMsg);  
                    }
                    $A.get('e.force:refreshView').fire();
                }
                var deleteModal = component.find('deleteModal');
                var backdrop = component.find('backdrop');
                $A.util.removeClass(backdrop, 'slds-backdrop_open');
                $A.util.addClass(deleteModal, 'slds-hide');
                component.set("v.isEditModalOpen", false);  

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
            }
			$A.util.addClass(component.find('loadingSpinner'), 'slds-hide');					
        });
        $A.enqueueAction(action);
	},
	
	getCustomerInfo: function(component, customerId){
        $A.util.removeClass(component.find('loadingSpinner'), 'slds-hide');
        var action = component.get("c.getCustomerInfo");
        action.setParams({
            'accountId': customerId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rtnValue = response.getReturnValue();
                component.set("v.simpleNewCase.AccountId", rtnValue.Id);
				//for initial edit case
				component.set("v.selectedCustomer", rtnValue);
			}
			$A.util.addClass(component.find('loadingSpinner'), 'slds-hide');		
        });
        $A.enqueueAction(action);
	},
	
	setOldCaseData: function(component){
        $A.util.removeClass(component.find('loadingSpinner'), 'slds-hide');
		var action = component.get("c.getOldCaseData");
        action.setParams({
            'caseId': component.get("v.selectedCase")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				var rtnValue = response.getReturnValue();
				if(rtnValue != null){
					var caseObj = rtnValue.caseObj;
					component.set("v.simpleNewCase.AccountId", caseObj.AccountId);
					component.set("v.simpleNewCase.Subject", caseObj.Subject);
					component.set("v.simpleNewCase.Origin", caseObj.Origin);
					component.set("v.simpleNewCase.Priority", caseObj.Priority);
					component.set("v.simpleNewCase.Status", caseObj.Status);
					component.set("v.simpleNewCase.Description", caseObj.Description);

					this.getCustomerInfo(component, caseObj.AccountId);
					
					component.set("v.isEditModalOpen", true);
					var modal = component.find('editModal');
					var backdrop = component.find('backdrop');
					if(component.get("v.chooseCustomer")){
						$A.util.addClass(modal, 'slds-modal_medium');                
					}
					$A.util.addClass(backdrop, 'slds-backdrop_open');
					$A.util.removeClass(modal, 'slds-hide');
				}
				$A.util.addClass(component.find('loadingSpinner'), 'slds-hide');		
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
    }

})