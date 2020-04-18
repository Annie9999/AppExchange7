({
	getInitData: function(component, event, helper) {
		console.log('getinitHistory');
		var action = component.get("c.getInitData");
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
			console.log('setCallHistory');

            var state = response.getState();
           
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();
				console.log('rtnValue His');
				// console.dir(JSON.stringify(rtnValue));
				
				component.set("v.dataTimeLines",rtnValue);
			}
			$A.util.addClass(component.find('chatHistoryPopupLoading'), 'slds-hide');		
        });
		$A.enqueueAction(action);
	},
	getPopupData: function(component, event, helper) {
		$A.util.removeClass(component.find('chatHistoryPopupLoading'), 'slds-hide');		

		console.log('getPopupData');
		var chatCollectionByDate = component.get("v.chatCollectionByDate");
		var action = component.get("c.getPopupDataHistory");
        action.setParams({
			'recordId': component.get("v.currentDataTimeLine").Id,
			'previosChatmessage': component.get("v.previousMessage")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
           
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();
				console.log('return');
				// console.dir(JSON.stringify(rtnValue));
				var LiveChatMainData = rtnValue.LiveChatMainData;
				if (chatCollectionByDate.length > 0){
					helper.addPreviosMessage(component,helper,LiveChatMainData.messageCollection)
				}else {
					component.set("v.chatCollectionByDate",LiveChatMainData.messageCollection);
					helper.setStartChatTime(component,LiveChatMainData.chatSession.CreatedDate);
				}

				// component.set("v.provider",LiveChatMainData.provider);
				component.set("v.isHasPreviousMessage",LiveChatMainData.isHasPreviousMessage);
				component.set("v.previousMessage",LiveChatMainData.previousMessage);
				if(!LiveChatMainData.chatSession.Chat_Note__c){
					LiveChatMainData.chatSession.Chat_Note__c = 'None';
				}
				
				component.set("v.currentChatSession",LiveChatMainData.chatSession);

			}
		$A.util.addClass(component.find('chatHistoryPopupLoading'), 'slds-hide');		

        });
		$A.enqueueAction(action);
	},
	addPreviosMessage: function (component, helper,priviousMessageList) {
		var chatCollectionByDate = component.get('v.chatCollectionByDate');
		var oldPriviousDate = chatCollectionByDate[0].sentDate;
		var newLastDate = priviousMessageList[priviousMessageList.length-1].sentDate;
		var newChatCollectionByDate = [];

		if(oldPriviousDate === newLastDate){
			var lastItemOfPriviousMessage = priviousMessageList.pop();
			var newMessage = [];
			newMessage = lastItemOfPriviousMessage.messages.concat(chatCollectionByDate[0].messages);
			chatCollectionByDate[0].messages = newMessage;
		}

		newChatCollectionByDate = priviousMessageList.concat(chatCollectionByDate);
		component.set('v.chatCollectionByDate',newChatCollectionByDate);
	  },
	  setStartChatTime: function(component,createdChatDateString){
		var today = new Date();
		var createdChatDate = new Date(createdChatDateString);
		
		var toDayStr = '' + today.getDate() + today.getMonth() + today.getFullYear();
		var createdChatDateStr = '' + createdChatDate.getDate() + createdChatDate.getMonth() + createdChatDate.getFullYear();
		
		var startChatDateTime = this.getTimeOnFormat(createdChatDate);
		if(toDayStr !== createdChatDateStr) {
			startChatDateTime +=  ' on ' + this.getDateOnFormat(createdChatDate);
		}
		component.set('v.startChatDateTime',startChatDateTime);
	},
	getDateOnFormat: function(thisDate){
		var today;

		if(thisDate != null){
			today = new Date(thisDate);
		}else{
			today = new Date();
		}
		const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
		const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		var dayOfweek = days[today.getDay()];
		var dateAsNumber = '' + today.getDate();
		var monthAsName = months[today.getMonth()];
		var year = '' + today.getFullYear();

		var result = dayOfweek + ', ' + dateAsNumber + ' ' + monthAsName + ' ' + year;
		return result;
	},
	getTimeOnFormat: function(thisDate){
		var today;

		if(thisDate != null){
			today = new Date(thisDate);
		}else{
			today = new Date();
		}
		
		var hours = '' + today.getHours();
		var minutes = today.getMinutes();
		
		var result = hours + ':' + ((minutes < 10) ? ('0' + minutes) : ('' + minutes));
		return result;
	},
	downloadFileFromLine : function(component, helper, url, fileName) {
		console.log('downloadFileFromLine');
		// console.log('url' + url);
		// console.log('fileName' + fileName);
		var action = component.get("c.getFileFromLine");
		action.setParams({
			"url" : url,
			"fileName" : fileName
        });
        action.setCallback(this, function (response) {
			console.log('downloadFileFromLine callback');
			
            var state = response.getState();
			console.log(state);
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();
					console.log(rtnValue.Id);
				if(rtnValue !== null && rtnValue !== undefined) {
					//  var openPDF = $A.get("e.force:navigateToSObject");
                    // openPDF.setParams({
                    //     "recordId" : rtnValue.Id,
                    //     "slideDevName" : "detail",
                    // });
					// openPDF.fire();
					window.location = rtnValue.ContentDownloadUrl
					setTimeout(function(){
						helper.removeFileFromLine(component, rtnValue.ContentVersionId);
					}, 5000);
                }
			}
		});
		action.setBackground();
		$A.enqueueAction(action);
	},
	downloadImageFromLine : function(component, helper, blob, fileName) {
		console.log('downloadImageFromLine');
		// console.log('url' + url);
		// console.log('fileName' + fileName);
		var action = component.get("c.getDownloadLinkImage");
		action.setParams({
			"blobString" : blob,
			"fileName" : fileName
        });
        action.setCallback(this, function (response) {
			console.log('downloadImageFromLine callback');
			
            var state = response.getState();
			console.log(state);
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();
				console.log(rtnValue.Id);
				if(rtnValue !== null && rtnValue !== undefined) {
					//  var openPDF = $A.get("e.force:navigateToSObject");
                    // openPDF.setParams({
                    //     "recordId" : rtnValue.Id,
                    //     "slideDevName" : "detail",
                    // });
					// openPDF.fire();
					window.location = rtnValue.ContentDownloadUrl
					setTimeout(function(){
						helper.removeFileFromLine(component, rtnValue.ContentVersionId);
					}, 5000);
                }
			}
		});
		action.setBackground();
		$A.enqueueAction(action);
	},
	removeFileFromLine : function(component, fileId) {
		console.log('removeFileFromLine');
		var action = component.get("c.removeFileFromLine");
		action.setParams({
            'Id': fileId
        });
        action.setCallback(this, function (response) {
			console.log('removeFileFromLine callback');
			
            var state = response.getState();
			console.log(state);
            if (state == 'SUCCESS') {
				console.log('removeFileFromLine success');
			}
		});
		$A.enqueueAction(action);
	},
})