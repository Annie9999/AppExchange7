({
    doInit: function (component, event, helper) {
    
       
        // helper.getLeadSessionLiked(component, event, helper);
        helper.getLeadPicklist(component, event, helper);
        // helper.getSocialIdData(component, event, helper);
    },
    toggleSwitchButton : function(component, event, helper) {
		var isShowDetail = component.get("v.isShowDetail");
		component.set("v.isShowDetail", !isShowDetail);
    },
    openModelEdit: function (component, event, helper) {
        component.set("v.errorMessage", null);
        component.set("v.isModalEditOpen", true);
        component.set("v.mediaInputEditForm", false);
        console.log('Open Edit Lead');
        var selectedindex = event.target.value;
        console.log(selectedindex);
        // console.log(JSON.parse(selectedindex));

        var leadDataSession = component.get("v.leadDataSession");
        console.log(leadDataSession[selectedindex]);
        component.set("v.leadEdit", leadDataSession[selectedindex]);

        /*var mediaVal = leadDataSession[selectedindex].Lead__r.iigproduct__Media_info__c;
        console.log('mediaVal: ' + mediaVal);

        if (mediaVal === "Other Websites" || mediaVal === "Agent" || mediaVal === "Event/Sales Booth" || mediaVal === "Others") {
            component.set("v.mediaInputEditForm", true);
        }*/

        //helper.getProjectDetail(component, event, helper, leadDataSession[selectedindex].Lead__r.Interested_Project__c);

        var editModal = component.find('editModal');
        $A.util.removeClass(editModal, 'slds-hide');
    },

    closeModelEdit: function (component, event, helper) {
        component.set("v.errorMessage", null);
        component.set("v.isModalEditOpen", false);
        var editModal = component.find('editModal');
        $A.util.addClass(editModal, 'slds-hide');
    },

    submitEdit: function (component, event, helper) {
        component.set("v.errorMessage", null);
        console.log('Edit');
        helper.updateLead(component, event, helper);
    },
    openModelDelete: function (component, event, helper) {
        console.log('openModelDelete');
        component.set("v.errorMessage", null);
        component.set("v.isModalDeleteOpen", true);
        var selectedindex = event.target.value;
        console.log(selectedindex);
        helper.findLeadSessionLinkageBeforeDeleteLead(component, event, helper, selectedindex);
        var deleteModal = component.find('deleteModal');
        $A.util.removeClass(deleteModal, 'slds-hide');
    },

    closeModelDelete: function (component, event, helper) {
        component.set("v.errorMessage", null);
        component.set("v.isModalDeleteOpen", false);
        component.set("v.leadIdDel", "");
        var deleteModal = component.find('deleteModal');
        $A.util.addClass(deleteModal, 'slds-hide');
    },

    submitDelete: function (component, event, helper) {
        component.set("v.errorMessage", null);
        console.log('submitDelete');
        helper.deleteLead(component, event, helper);
    },
    /*projectChange: function (component, event, helper) {
        if (component.get("v.selectedProject") !== "") {
            component.set("v.errorMessage", null);
        }

        var projectId = event.getParam('record').Id;
        var filterStr = 'Project__c IN (\'' + projectId + '\') and Lock_Unit__c = false and Booking__c != \'Y\'';
        component.set("v.unitFilter", filterStr);
        component.set("v.projectId", projectId);
    },*/
    openNewTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            recordId: component.get("v.recordData").iigproduct__Lead__c,
            focus: true
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    openEditRecord : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
             "recordId": component.get("v.recordData").iigproduct__Lead__c
       });
        editRecordEvent.fire();
    },
    handleAfterEditLead : function (component, event, helper) {
        console.log('handleAfterEditLead');
        var param = event.getParam("params");
        console.dir(JSON.parse(JSON.stringify(param)))
        component.set('v.isModalEditOpen',false);
        $A.get('e.force:refreshView').fire();
    }
})