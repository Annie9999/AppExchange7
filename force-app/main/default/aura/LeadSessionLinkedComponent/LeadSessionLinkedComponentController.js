({
    doInit: function (component, event, helper) {

        var defaultNewLeadValueField = {
            "iigproduct__FromChatSession__c" : component.get("v.recordId")
        }


        component.set("v.defaultNewLeadValueField",defaultNewLeadValueField);
        helper.getLeadSessionLiked(component, event, helper);
        helper.getLeadPicklist(component, event, helper);
        helper.getSocialIdData(component, event, helper);

    },
    handleSectionToggle: function (component, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            component.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            component.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    openModelSearch: function (component, event, helper) {
        component.set("v.errorMessage", null);
        component.set("v.isModalSearchOpen", true);
        component.set("v.isStartTableData",true);
        console.log('Open Search Detail');
        helper.getLightningTableData(component, event, helper);
        var searchModal = component.find('searchModal');
        $A.util.removeClass(searchModal, 'slds-hide');
    },
    closeModelSearch: function (component, event, helper) {
        component.set("v.errorMessage", null);
        component.set("v.isModalSearchOpen", false);
        component.set("v.isStartTableData",false);

        console.log(component.get("v.selectedLookUpRecords"));

        component.set("v.selectedLookUpRecords", []);
        component.set("v.SearchData", []);
        console.log(component.get("v.selectedLookUpRecords"));

        var searchModal = component.find('searchModal');
        $A.util.addClass(searchModal, 'slds-hide');
    },
    submitDetailsSearch: function (component, event, helper) {
        component.set("v.errorMessage", null);
        component.set("v.isModalSearchOpen", false);
        console.log('Search');
        var leadList = component.get("v.selectedLookUpRecords");
        var leadId = leadList.length > 0 ? leadList[0].Id : null;
        component.set("v.leadIdForDialog", leadId);
        console.log(JSON.stringify(leadList));
        console.log(leadId);

        component.set("v.selectedLookUpRecords", []);
    },
    openModelCreateLead: function (component, event, helper) {
        helper.resetModelCreateLead(component, event, helper);
        component.set("v.errorMessage", null);
        console.log('openModelCreateLead');
        component.set("v.isModalSearchOpen", false);
        component.set("v.isModalNewOpen", true);
        helper.getsocialInfo(component, event, helper);

        var searchModal = component.find('searchModal');
        $A.util.addClass(searchModal, 'slds-hide');
        var newModal = component.find('newModal');
        $A.util.removeClass(newModal, 'slds-hide');

    },
    closeModelCreateLead: function (component, event, helper) {
        helper.resetModelCreateLead(component, event, helper);
        component.set("v.errorMessage", null);
        console.log('closeModelCreateLead');
        component.set("v.isModalNewOpen", false);
        component.set("v.isStartTableData",false);
        component.set("v.SearchData", []);
        var newModal = component.find('newModal');
        $A.util.addClass(newModal, 'slds-hide');
    },
    submitCreateLead: function (component, event, helper) {
        component.set("v.errorMessage", null);
        console.log('submitCreateLead');
        helper.createLead(component, event, helper);

    },
    leadSearch: function (component, event, helper) {
        component.set("v.errorMessage", null);
        component.set("v.isStartTableData",false);
        var queryTerm = component.find('enter-search').get('v.value');
        // alert('Searched for "' + queryTerm + '"!');
        helper.searchByLeadKey(component, event, helper, queryTerm);

    },
    // openModelEdit: function (component, event, helper) {
    //     component.set("v.errorMessage", null);
    //     component.set("v.isModalEditOpen", true);
    //     component.set("v.mediaInputEditForm", false);
    //     console.log('Open Edit Lead');
    //     var selectedindex = event.target.value;
    //     console.log(selectedindex);

    //     var leadDataSession = component.get("v.leadDataSession");
    //     console.log(leadDataSession[selectedindex]);
    //     component.set("v.leadEdit", leadDataSession[selectedindex]);

    //     var mediaVal = leadDataSession[selectedindex].Lead__r.Media_info__c;
    //     console.log('mediaVal: ' + mediaVal);

    //     if (mediaVal === "Other Websites" || mediaVal === "Agent" || mediaVal === "Event/Sales Booth" || mediaVal === "Others") {
    //         component.set("v.mediaInputEditForm", true);
    //     }

    //     helper.getProjectDetail(component, event, helper, leadDataSession[selectedindex].Lead__r.Interested_Project__c);

    //     var editModal = component.find('editModal');
    //     $A.util.removeClass(editModal, 'slds-hide');
    // },

    // closeModelEdit: function (component, event, helper) {
    //     component.set("v.errorMessage", null);
    //     component.set("v.isModalEditOpen", false);
    //     var editModal = component.find('editModal');
    //     $A.util.addClass(editModal, 'slds-hide');
    // },

    // submitEdit: function (component, event, helper) {
    //     component.set("v.errorMessage", null);
    //     console.log('Edit');
    //     helper.updateLead(component, event, helper);
    // },
    // openModelDelete: function (component, event, helper) {
    //     component.set("v.errorMessage", null);
    //     component.set("v.isModalDeleteOpen", true);
    //     console.log('openModelDelete');
    //     var selectedindex = event.target.value;
    //     console.log(selectedindex);
    //     helper.findLeadSessionLinkageBeforeDeleteLead(component, event, helper, selectedindex);
    //     var deleteModal = component.find('deleteModal');
    //     $A.util.removeClass(deleteModal, 'slds-hide');
    // },

    // closeModelDelete: function (component, event, helper) {
    //     component.set("v.errorMessage", null);
    //     component.set("v.isModalDeleteOpen", false);
    //     component.set("v.leadIdDel", "");
    //     var deleteModal = component.find('deleteModal');
    //     $A.util.addClass(deleteModal, 'slds-hide');
    // },

    // submitDelete: function (component, event, helper) {
    //     component.set("v.errorMessage", null);
    //     console.log('submitDelete');
    //     helper.deleteLead(component, event, helper);
    // },
    /*projectChange: function (component, event, helper) {
        if (component.get("v.selectedProject") !== "") {
            component.set("v.errorMessage", null);
        }

        var projectId = event.getParam('record').Id;
        var filterStr = 'Project__c IN (\'' + projectId + '\') and Lock_Unit__c = false and Booking__c != \'Y\'';
        component.set("v.unitFilter", filterStr);
        component.set("v.projectId", projectId);
    },*/
    addLeadFromSearchtoLinked: function (component, event, helper) {
        component.set("v.errorMessage", null);
        console.log('addLeadFromSearchtoLinked');
        var selectedindex = event.target.value;

        console.log(selectedindex);
        helper.addLeadToLeadSessionLinkage(component, event, helper, selectedindex);
    },
    removeLeadFromSearchtoLinked: function (component, event, helper) {
        component.set("v.errorMessage", null);
        console.log('removeLeadFromSearchtoLinked');
        var selectedindex = event.target.value;
        console.log(' #removeindex: '+selectedindex);
        helper.removeLeadToLeadSessionLinkage(component, event, helper, selectedindex);

    },
   /* mediaInfoChange: function (component, event, helper) {
        console.log(component.get("v.leadNew"));
        console.log('mediaInfoChange : ' + component.get("v.leadNew.Media_info__c"));
        component.set("v.mediaInputForm", false);
        component.set("v.leadNew.Media_Info_Description__c", '');
        var mediaVal = component.get("v.leadNew.Media_info__c");
        if (mediaVal === "Other Websites" || mediaVal === "Agent" || mediaVal === "Event/Sales Booth" || mediaVal === "Others") {
            component.set("v.mediaInputForm", true);
        }
    },*/
    leadSourceChange: function (component, event, helper) {
        console.log(component.get("v.leadNew"));
        console.log('leadSourceChange : ' + component.get("v.leadNew.LeadSource"));

    },
   /* purposeOfBuyingChange: function (component, event, helper) {
        console.log(component.get("v.leadNew"));
        console.log('purposeOfBuyingChange : ' + component.get("v.leadNew.purpose_of_buying__c"));

    },*/

   /* mediaInputChange: function (component, Event, helper) {
        if (component.get("v.leadNew.Media_Info_Description__c") !== "" && component.get("v.leadNew.Media_Info_Description__c") !== undefined && component.get("v.leadNew.Media_Info_Description__c") !== " ") {
            component.set("v.errorMessage", null);
        }
    },*/
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Lead"
        });
        createRecordEvent.fire();
    },
    handleAfterCreateLead : function (component, event, helper) {
        console.log('handleAfterCreateLead');
        var param = event.getParam("params");
        console.log('param: '+param.recordId);

        console.dir(JSON.parse(JSON.stringify(param)))
        if (param.recordId && param.isCreating){
            helper.createLeadSessionLinkage(component, event, helper,param.recordId);
        }else{
            component.set('v.isModalNewOpen',false);
        }
    }

    // mediaInfoEditChange: function (component, event, helper) {
    //     console.log(component.get("v.leadEdit"));
    //     console.log('mediaInfoChange : ' + component.get("v.leadEdit.Lead__r.Media_info__c"));
    //     component.set("v.mediaInputEditForm", false);
    //     component.set("v.leadEdit.Lead__r.Media_Info_Description__c", '');
    //     var mediaVal = component.get("v.leadEdit.Lead__r.Media_info__c");
    //     if (mediaVal === "Other Websites" || mediaVal === "Agent" || mediaVal === "Event/Sales Booth" || mediaVal === "Others") {
    //         component.set("v.mediaInputEditForm", true);
    //     }
    // },
    // leadSourceEditChange: function (component, event, helper) {
    //     console.log(component.get("v.leadEdit"));
    //     console.log('leadSourceChange : ' + component.get("v.leadEdit.Lead__r.LeadSource"));

    // },
    // purposeOfBuyingEditChange: function (component, event, helper) {
    //     console.log(component.get("v.leadEdit"));
    //     console.log('purposeOfBuyingChange : ' + component.get("v.leadEdit.Lead__r.purpose_of_buying__c"));

    // },

    // mediaInputEditChange: function (component, Event, helper) {
    //     if (component.get("v.leadEdit.Lead__r.Media_Info_Description__c") !== "" && component.get("v.leadEdit.Lead__r.Media_Info_Description__c") !== undefined && component.get("v.leadEdit.Lead__r.Media_Info_Description__c") !== " ") {
    //         component.set("v.errorMessage", null);
    //     }
    // },

})