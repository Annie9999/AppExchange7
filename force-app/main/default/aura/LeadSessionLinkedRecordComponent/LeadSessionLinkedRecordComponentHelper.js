({
    // getLeadSessionLiked: function (component, event, helper) {
    //     console.log('getLeadSessionLiked');
    //     console.log('recordId : ' + component.get("v.recordId"));

    //     var action = component.get("c.getLeadSessionLikedInfomation");
    //     action.setParams({
    //         'sessionId': component.get("v.recordId"),
    //     });
    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         if (state == 'SUCCESS') {
    //             var rtnValue = response.getReturnValue();
    //             console.log(rtnValue);
    //             console.log(rtnValue.leadSessionLinkageData);
    //             if (rtnValue.leadSessionLinkageData != undefined) {
    //                 console.log(rtnValue.leadSessionLinkageData.length);

    //                 component.set('v.leadDataSessionSize', rtnValue.leadSessionLinkageData.length);
    //                 component.set('v.leadDataSession', rtnValue.leadSessionLinkageData);
    //             }else{
    //                 component.set('v.leadDataSessionSize', 0);
    //                 component.set('v.leadDataSession', []);
    //             }
    //         }
    //     });
    //     $A.enqueueAction(action);

    // },
    
    /*getProjectDetail: function (component, event, helper, projectId) {
        console.log('getProjectInfomation');
        console.log('projectId : ' + projectId);

        var action = component.get("c.getProjectInfomation");
        action.setParams({
            'projectId': projectId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var rtnValue = response.getReturnValue();
                console.log(rtnValue);
                console.log(rtnValue.projectData);
                if (rtnValue.projectData != undefined) {
                    component.set('v.selectedProject', rtnValue.projectData);
                }
            }
        });
        $A.enqueueAction(action);

    },*/
    getLeadPicklist: function (component, event, helper) {
        console.log('getLeadPicklist');

        var action = component.get("c.getLeadPicklistInfomation");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var rtnValue = response.getReturnValue();
                console.log(rtnValue);
                console.log(rtnValue.picklistLeadSource);
                if (rtnValue.picklistLeadSource != undefined) {
                    component.set("v.picklistLeadSource", rtnValue.picklistLeadSource);
                }
                /*console.log(rtnValue.picklistPurpose);
                if (rtnValue.picklistPurpose != undefined) {
                    component.set("v.picklistPurpose", rtnValue.picklistPurpose);
                }
                console.log(rtnValue.picklistMediaInfo);
                if (rtnValue.picklistMediaInfo != undefined) {
                    component.set("v.picklistMediaInfo", rtnValue.picklistMediaInfo);
                }*/
            }
        });
        $A.enqueueAction(action);
    },
    // getSocialIdData: function (component, event, helper) {
    //     console.log('getSocialIdData');

    //     var action = component.get("c.getSocialIdFromChatSession");
    //     var recordId = component.get("v.recordId");
    //     action.setParams({
    //         'recordId': recordId,
    //     });
    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         if (state == 'SUCCESS') {
    //             var rtnValue = response.getReturnValue();
    //             console.log(rtnValue);
    //             console.log(rtnValue.socialID);
    //             if (rtnValue.socialID != undefined) {
    //                 component.set("v.socialID", rtnValue.socialID);
    //             }
    //         }
    //     });
    //     $A.enqueueAction(action);
    // },
    // getLightningTableData: function (component, event, helper) {
    //     console.log('getLightningTableData');

    //     var action = component.get("c.getLeadDuplicateRecordData");
    //     var socialID = component.get("v.socialID");
    //     console.log('socialID:' + socialID);

    //     action.setParams({
    //         socialID: socialID
    //     });
    //     $A.util.removeClass(component.find('search-loading'), 'slds-hide');
    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         console.log(state);
    //         $A.util.addClass(component.find('search-loading'), 'slds-hide');
    //         if (state == 'SUCCESS') {
    //             var rtnValue = response.getReturnValue();
    //             var allRecords = rtnValue.leads;
    //             console.log(allRecords);

    //             if (allRecords != undefined) {
    //                 var allRecordsSetted = helper.setRecordsIsLeadLinked(component, event, helper, allRecords)
    //                 console.log(allRecordsSetted);
    //                 component.set("v.SearchData", allRecordsSetted);
    //             }
    //         }
    //     });
    //     $A.enqueueAction(action);
    // },
    // setRecordsIsLeadLinked: function (component, event, helper, records) {
    //     console.log(records);
    //     var leadDataSession = component.get("v.leadDataSession");
    //     console.log(leadDataSession.length);

    //     for (var idx in records) {
    //         if (leadDataSession.length > 0) {
    //             for (var index in leadDataSession) {
    //                 console.log('check is not Leadlinked ?');
    //                 console.log(records[idx].Id);
    //                 console.log(leadDataSession[index].Lead__c);

    //                 if (records[idx].Id != leadDataSession[index].Lead__c) {
    //                     records[idx].isNotLeadlinked = true;
    //                 } else {
    //                     records[idx].isNotLeadlinked = false;
    //                     break;
    //                 }
    //             }
    //         } else {
    //             records[idx].isNotLeadlinked = true;
    //         }
    //         var day = new Date(records[idx].CreatedDate).getDate();
    //         var month = new Date(records[idx].CreatedDate).getMonth() + 1;
    //         var year = new Date(records[idx].CreatedDate).getFullYear();
    //         var time = new Date(records[idx].CreatedDate).toLocaleTimeString('nb-NO');
    //         var CreatedDateDisplay = day + '/' + month + '/' + year + ' ' + time;

    //         records[idx].CreatedDateDisplay = CreatedDateDisplay;
    //     }
    //     console.log(records);
    //     return records;
    // },
    // updateRecordsIsLeadLinked: function (component, event, helper, index, status) {
    //     var SearchDataList = component.get("v.SearchData");
    //     console.log(SearchDataList[index]);
    //     SearchDataList[index].isNotLeadlinked = status;
    //     component.set("v.SearchData", SearchDataList);
    // },
    // searchByLeadKey: function (component, event, helper, queryTermSearch) {
    //     console.log('searchByLeadKey');
    //     console.log(queryTermSearch);
    //     var isValid = helper.validateSearchLead(component, event, helper, queryTermSearch);
    //     console.log('isValid : ' + isValid);

    //     if (isValid) {
    //         var action = component.get("c.searchedByLeadKey");
    //         action.setParams({
    //             searchInputText: queryTermSearch
    //         });
    //         $A.util.removeClass(component.find('search-loading'), 'slds-hide');
    //         action.setCallback(this, function (response) {
    //             var state = response.getState();
    //             $A.util.addClass(component.find('search-loading'), 'slds-hide');
    //             if (state == "SUCCESS") {
    //                 var rtnValue = response.getReturnValue();
    //                 if (rtnValue != null) {
    //                     console.log(rtnValue.leads);

    //                     var searchedLead = rtnValue.leads;
    //                     console.log(searchedLead);
    //                     if (searchedLead != undefined) {
    //                         var allRecordsSetted = helper.setRecordsIsLeadLinked(component, event, helper, searchedLead)
    //                         console.log(allRecordsSetted);
    //                         component.set("v.SearchData", allRecordsSetted);
    //                     } else {
    //                         component.set("v.SearchData", []);
    //                     }
    //                 }
    //             }
    //         });
    //         $A.enqueueAction(action);
    //     } else {
    //         return;
    //     }
    // },
    // validateSearchLead: function (component, event, helper, queryTermValidate) {
    //     console.log('validateSearchLead');
    //     console.log(queryTermValidate + ' ++ ++ ' + queryTermValidate.length);

    //     if (queryTermValidate == "" || queryTermValidate == undefined || queryTermValidate == null) {
    //         component.set("v.errorMessage", "Please input data in search box");
    //         return false;
    //     } else {
    //         var queryTermValidateNoSpace = queryTermValidate.replace(/\s/g, '');
    //         console.log(queryTermValidateNoSpace + ' ++ ++ ' + queryTermValidateNoSpace.length);
    //         if (queryTermValidateNoSpace.length < 2) {
    //             component.set("v.errorMessage", "Please type keyword at least 2 letters");
    //             return false;
    //         }
    //     }
    //     return true;
    // },
    updateLead: function (component, event, helper) {
        console.log('updateLead');
        //console.log(component.get("v.selectedProject"));
        var action = component.get("c.updatedLead");
        var leadEdit = component.get("v.leadEdit");
        console.log(leadEdit);
        console.log(leadEdit.iigproduct__Lead__r);
        /*if (component.get("v.selectedProject") != null) {
            leadEdit.Lead__r.Interested_Project__c = component.get("v.selectedProject").Id;
        } else {
            leadEdit.Lead__r.Interested_Project__c = '';
        }*/
        var isValid = helper.validateUpdateLead(component, event, helper, leadEdit.iigproduct__Lead__r);
        console.log('isValid : ' + isValid);

        if (isValid) {
            action.setParams({
                leadData: leadEdit.iigproduct__Lead__r
            });
            $A.util.removeClass(component.find('update-loading'), 'slds-hide');
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log(state);
                $A.util.addClass(component.find('update-loading'), 'slds-hide');
                if (state == 'SUCCESS') {
                    var rtnValue = response.getReturnValue();
                    if (rtnValue.success) {
                        console.log(rtnValue.success);
                        $A.get('e.force:refreshView').fire();
                        $A.get('e.force:closeQuickAction').fire();
                        // helper.getLeadSessionLiked(component, event, helper);
                        component.set("v.isModalEditOpen", false);
                        var editModal = component.find('editModal');
                        $A.util.addClass(editModal, 'slds-hide');
                        var compEvent = component.getEvent("refreshLeadRecord");
        			    compEvent.fire();
                    } else {
                        console.log(rtnValue.msg);
                        component.set("v.errorMessage", rtnValue.msg);
                    }

                }
            });
            $A.enqueueAction(action);
        } else {
            return;
        }
    },
    // removeLeadToLeadSessionLinkage: function (component, event, helper, index) {
    //     console.log('removeLeadToLeadSessionLinkage');

    //     var action = component.get("c.removedLeadToLeadSessionLinkage");
    //     var SearchDataList = component.get("v.SearchData");
    //     console.log(SearchDataList[index]);
    //     console.log(SearchDataList[index].Id);
    //     console.log(component.get("v.recordId"));

    //     action.setParams({
    //         leadId: SearchDataList[index].Id,
    //         sessionId: component.get("v.recordId")
    //     });
    //     $A.util.removeClass(component.find('search-loading'), 'slds-hide');
    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         console.log(state);
    //         $A.util.addClass(component.find('search-loading'), 'slds-hide');
    //         if (state == 'SUCCESS') {
    //             var rtnValue = response.getReturnValue();
    //             if (rtnValue.success) {
    //                 console.log(rtnValue.success);
    //                 $A.get('e.force:refreshView').fire();
    //                 $A.get('e.force:closeQuickAction').fire();
    //                 helper.getLeadSessionLiked(component, event, helper);
    //                 helper.updateRecordsIsLeadLinked(component, event, helper, index, true);
    //             } else {
    //                 console.log(rtnValue.msg);
    //                 component.set("v.errorMessage", rtnValue.msg);
    //             }
    //         }
    //     });
    //     $A.enqueueAction(action);
    // },
    // addLeadToLeadSessionLinkage: function (component, event, helper, index) {
    //     console.log('addLeadToLeadSessionLinkage');

    //     var action = component.get("c.addedLeadToLeadSessionLinkage");
    //     var SearchDataList = component.get("v.SearchData");
    //     console.log(SearchDataList[index]);
    //     console.log(SearchDataList[index].Id);
    //     console.log(component.get("v.recordId"));

    //     action.setParams({
    //         leadId: SearchDataList[index].Id,
    //         sessionId: component.get("v.recordId")
    //     });
    //     $A.util.removeClass(component.find('search-loading'), 'slds-hide');
    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         console.log(state);
    //         $A.util.addClass(component.find('search-loading'), 'slds-hide');
    //         if (state == 'SUCCESS') {
    //             var rtnValue = response.getReturnValue();
    //             if (rtnValue.success) {
    //                 console.log(rtnValue.success);
    //                 $A.get('e.force:refreshView').fire();
    //                 $A.get('e.force:closeQuickAction').fire();
    //                 helper.getLeadSessionLiked(component, event, helper);
    //                 helper.updateRecordsIsLeadLinked(component, event, helper, index, false);
    //             } else {
    //                 console.log(rtnValue.msg);
    //                 component.set("v.errorMessage", rtnValue.msg);
    //             }
    //         }
    //     });
    //     $A.enqueueAction(action);
    // },
    findLeadSessionLinkageBeforeDeleteLead: function (component, event, helper, index) {
        console.log('findLeadSessionLinkageBeforeDeleteLead');
        component.set("v.sessionLeadDup", []);
        var action = component.get("c.foundLeadSessionLinkageBeforeDeleteLead");
        var leadDataSession = component.get("v.leadDataSession");
        console.log(leadDataSession[index]);
        console.log(leadDataSession[index].iigproduct__Lead__c);

        component.set("v.leadIdDel", leadDataSession[index].iigproduct__Lead__c);

        action.setParams({
            leadId: leadDataSession[index].iigproduct__Lead__c,
            // sessionId: component.get("v.recordId")
            sessionId: component.get("v.sessionId")
        });
        $A.util.removeClass(component.find('del-loading'), 'slds-hide');
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            $A.util.addClass(component.find('del-loading'), 'slds-hide');
            if (state == 'SUCCESS') {
                var rtnValue = response.getReturnValue();
                if (rtnValue.success) {
                    console.log('sessionLeadDup');

                    console.log(rtnValue.success);
                    console.log(rtnValue.sessionLeadDup);
                    var sessionLeadDup = rtnValue.sessionLeadDup;
                    if (sessionLeadDup != undefined) {
                        for (var index in sessionLeadDup) {
                            console.log('set session Created');
                            console.log(sessionLeadDup[index].ChatSession__r.CreatedDate);

                            var day = new Date(sessionLeadDup[index].ChatSession__r.CreatedDate).getDate();
                            var month = new Date(sessionLeadDup[index].ChatSession__r.CreatedDate).getMonth() + 1;
                            var year = new Date(sessionLeadDup[index].ChatSession__r.CreatedDate).getFullYear();
                            var time = new Date(sessionLeadDup[index].ChatSession__r.CreatedDate).toLocaleTimeString('nb-NO');
                            var CreatedDateDisplay = day + '/' + month + '/' + year + ' ' + time;
                            sessionLeadDup[index].CreatedDateDisplay = CreatedDateDisplay;
                        }
                        console.log(sessionLeadDup);
                        component.set("v.sessionLeadDup", sessionLeadDup);
                    }
                } else {
                    console.log(rtnValue.msg);
                    component.set("v.errorMessage", rtnValue.msg);
                }
            }
        });
        $A.enqueueAction(action);
    },
    // getsocialInfo: function (component, event, helper) {
    //     console.log('getsocialInfo');
    //     var action = component.get("c.getSocialInfoFromSocialID");
    //     action.setParams({
    //         socialID: component.get("v.socialID")
    //     });
    //     $A.util.removeClass(component.find('new-loading'), 'slds-hide');
    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         console.log(state);
    //         $A.util.addClass(component.find('new-loading'), 'slds-hide');
    //         if (state == 'SUCCESS') {
    //             var rtnValue = response.getReturnValue();
    //             var socialAccount = rtnValue.socialAccount;
    //             if (socialAccount != undefined) {
    //                 component.set("v.leadNew.FirstName", socialAccount.FirstName__c);
    //                 component.set("v.leadNew.LastName", socialAccount.LastName__c);
    //                 component.set("v.leadNew.Email", socialAccount.Email__c);
    //                 component.set("v.leadNew.MobilePhone", socialAccount.Phone_Number__c);

    //             }
    //         }
    //     });
    //     $A.enqueueAction(action);
    // },
    // createLead: function (component, event, helper) {
    //     console.log('createLead');
    //     console.log(component.get("v.selectedProject"));
    //     var action = component.get("c.insertedLead");
    //     var leadNew = component.get("v.leadNew");
    //     console.log(leadNew);

    //     if (component.get("v.selectedProject") != null) {
    //         leadNew.Interested_Project__c = component.get("v.selectedProject").Id;
    //     } else {
    //         leadNew.Interested_Project__c = '';
    //     }

    //     leadNew.FromChatSession__c = component.get("v.recordId");
    //     console.log(leadNew);

    //     var isValid = helper.validateCreateLead(component, event, helper, leadNew);
    //     console.log('isValid : ' + isValid);

    //     if (isValid) {
    //         action.setParams({
    //             leadData: leadNew,
    //             sessionId: component.get("v.recordId")
    //         });
    //         $A.util.removeClass(component.find('new-loading'), 'slds-hide');
    //         action.setCallback(this, function (response) {
    //             var state = response.getState();
    //             console.log(state);
    //             $A.util.addClass(component.find('new-loading'), 'slds-hide');
    //             if (state == 'SUCCESS') {
    //                 var rtnValue = response.getReturnValue();
    //                 if (rtnValue.success) {
    //                     console.log(rtnValue.success);
    //                     $A.get('e.force:refreshView').fire();
    //                     $A.get('e.force:closeQuickAction').fire();
    //                     helper.getLeadSessionLiked(component, event, helper);
    //                     component.set("v.isModalNewOpen", false);
    //                     var newModal = component.find('newModal');
    //                     $A.util.addClass(newModal, 'slds-hide');
    //                 } else {
    //                     console.log(rtnValue.msg);
    //                     component.set("v.errorMessage", rtnValue.msg);
    //                 }

    //             }
    //         });
    //         $A.enqueueAction(action);
    //     } else {
    //         return;
    //     }
    // },
    deleteLead: function (component, event, helper, index) {
        console.log('deleteLead');
        var action = component.get("c.deletedLead");
        var leadIdDel = component.get("v.leadIdDel");

        action.setParams({
            leadId: leadIdDel,
            // sessionId: component.get("v.recordId")
            sessionId: component.get("v.sessionId")
        });
        $A.util.removeClass(component.find('del-loading'), 'slds-hide');
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            $A.util.addClass(component.find('del-loading'), 'slds-hide');
            if (state == 'SUCCESS') {
                var rtnValue = response.getReturnValue();
                if (rtnValue.success) {
                    console.log(rtnValue.success);
                    $A.get('e.force:refreshView').fire();
                    $A.get('e.force:closeQuickAction').fire();
                    // helper.getLeadSessionLiked(component, event, helper);
                    component.set("v.isModalDeleteOpen", false);
                    component.set("v.leadIdDel", "");
                    var deleteModal = component.find('deleteModal');
                    $A.util.addClass(deleteModal, 'slds-hide');
                    var compEvent = component.getEvent("refreshLeadRecord");
        			compEvent.fire();
                } else {
                    console.log(rtnValue.msg);
                    component.set("v.errorMessage", rtnValue.msg);
                }
            }
        });
        $A.enqueueAction(action);
    },
    // resetModelCreateLead: function (component, Event, helper) {
    //     console.log('resetModelCreateLead');

    //     component.set("v.errorMessage", null);
    //     component.set("v.mediaInputForm", false);
    //     component.set("v.leadNew.FirstName", '');
    //     component.set("v.leadNew.LastName", '');
    //     component.set("v.leadNew.Email", '');
    //     component.set("v.leadNew.MobilePhone", '');
    //     component.set("v.leadNew.Media_info__c", '');
    //     component.set("v.leadNew.Media_Info_Description__c", '');
    //     component.set("v.leadNew.purpose_of_buying__c", '');
    //     component.set("v.leadNew.LeadSource", '');
    //     component.set("v.leadNew.Description", '');
    //     component.set("v.selectedProject", '');
    // },
    validateUpdateLead: function (component, event, helper, leadEdit) {
        console.log('validateUpdateLead');
        console.log(leadEdit);
        console.log(leadEdit.FirstName);
        if (leadEdit.FirstName == '' || leadEdit.FirstName == undefined || this.validationName(leadEdit.FirstName) == null) {
            component.set("v.errorMessage", "Invalid FirstName");
            return false;
        }
        console.log(leadEdit.LastName);
        if (leadEdit.LastName == '' || leadEdit.LastName == undefined || this.validationName(leadEdit.LastName) == null) {
            component.set("v.errorMessage", "Invalid LastName");
            return false;
        }
        console.log(leadEdit.Email);
        if (leadEdit.Email != '' && leadEdit.Email != undefined && this.validationEmail(leadEdit.Email) == null) {
            component.set("v.errorMessage", "Invalid email address");
            return false;
        }
        console.log(leadEdit.MobilePhone);
        if (leadEdit.MobilePhone != '' && leadEdit.MobilePhone != undefined && this.validationMobile(leadEdit.MobilePhone) == null) {
            component.set("v.errorMessage", "Invalid Mobile");
            return false;
        }
        if ((leadEdit.Email == '' || leadEdit.Email == undefined) && (leadEdit.MobilePhone == '' || leadEdit.MobilePhone == undefined)) {
            component.set("v.errorMessage", "Please Input Mobile or Email");
            return false;
        }
        /*console.log(leadEdit.Interested_Project__c);
        if (leadEdit.Interested_Project__c == '' || leadEdit.Interested_Project__c == undefined) {
            component.set("v.errorMessage", "Please select Interested Project");
            return false;
        }*/
        return true;
    },
    // validateCreateLead: function (component, event, helper, leadNew) {
    //     console.log('validateCreateLead');
    //     var mediaInputForm = component.get("v.mediaInputForm");
    //     console.log(mediaInputForm);
    //     console.log(leadNew);
    //     console.log(leadNew.FirstName);
    //     if (leadNew.FirstName == '' || leadNew.FirstName == undefined || this.validationName(leadNew.FirstName) == null) {
    //         component.set("v.errorMessage", "Invalid FirstName");
    //         return false;
    //     }
    //     console.log(leadNew.LastName);
    //     if (leadNew.LastName == '' || leadNew.LastName == undefined || this.validationName(leadNew.LastName) == null) {
    //         component.set("v.errorMessage", "Invalid LastName");
    //         return false;
    //     }
    //     console.log(leadNew.Email);
    //     if (leadNew.Email != '' && leadNew.Email != undefined && this.validationEmail(leadNew.Email) == null) {
    //         component.set("v.errorMessage", "Invalid email address");
    //         return false;
    //     }
    //     console.log(leadNew.MobilePhone);
    //     if (leadNew.MobilePhone != '' && leadNew.MobilePhone != undefined && this.validationMobile(leadNew.MobilePhone) == null) {
    //         component.set("v.errorMessage", "Invalid Mobile");
    //         return false;
    //     }
    //     if ((leadNew.Email == '' || leadNew.Email == undefined) && (leadNew.MobilePhone == '' || leadNew.MobilePhone == undefined)) {
    //         component.set("v.errorMessage", "Please Input Mobile or Email");
    //         return false;
    //     }
    //     console.log(leadNew.Interested_Project__c);
    //     if (leadNew.Interested_Project__c == '' || leadNew.Interested_Project__c == undefined) {
    //         component.set("v.errorMessage", "Please select Interested Project");
    //         return false;
    //     }
    //     console.log(leadNew.purpose_of_buying__c);
    //     if (leadNew.purpose_of_buying__c == '' || leadNew.purpose_of_buying__c == undefined) {
    //         component.set("v.errorMessage", "Please select Purpose of Buying");
    //         return false;
    //     }
    //     console.log(leadNew.LeadSource);
    //     if (leadNew.LeadSource == '' || leadNew.LeadSource == undefined) {
    //         component.set("v.errorMessage", "Please select Lead Source");
    //         return false;
    //     }
    //     console.log(leadNew.Media_info__c);
    //     if (leadNew.Media_info__c == '' || leadNew.Media_info__c == undefined) {
    //         component.set("v.errorMessage", "Please select Media Info");
    //         return false;
    //     }
    //     if (mediaInputForm == true && (leadNew.Media_info__c == '' || leadNew.Media_info__c == undefined)) {
    //         component.set("v.errorMessage", "Please specify media");
    //         return;
    //     }
    //     return true;
    // },
    validationEmail: function (element) {
        var patt = /\S+@\S+\.\S+/g;
        var result = (element.trim()).match(patt);
        return result;
    },
    validationMobile: function (element) {
        var patt = /^(\+)?\b(\d)+$\b/g;
        var result = (element.trim()).match(patt);
        return result;
    },
    validationName: function (element) {
        var patt = /^[ก-๙ - a-zA-z]+$/g;
        var result = (element.trim()).match(patt);
        return result;
    },
})