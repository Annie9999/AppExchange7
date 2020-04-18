({
	getInitData: function(component, event, helper) {
		console.log('getInitData');
		$A.util.removeClass(component.find('mainLoading'), 'slds-hide');		
		var action = component.get("c.getInitData");
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
			
            var state = response.getState();
           
            if (state == 'SUCCESS') {
			console.log('success getInitData');

				var rtnValue = response.getReturnValue();
	
				component.set("v.chatCollectionByDate",rtnValue.messageCollection);
				component.set("v.lastDate",rtnValue.lastDateSession);
				component.set("v.provider",rtnValue.provider);
				component.set("v.isHasPreviousMessage",rtnValue.isHasPreviousMessage);
				component.set("v.previousMessage",rtnValue.previousMessage);
				component.set("v.chatMessageIdList",rtnValue.chatMessageIdList);
				component.set("v.isDisableInput",rtnValue.isDisableInput);
				// component.set("v.chatTopicOptions",rtnValue.chatTopicOptions);
				
				var chatSession = rtnValue.chatSession;
				// helper.setChatTopicSection(component,rtnValue.chatTopicOptions,chatSession);
				console.log('chatSession ',JSON.parse(JSON.stringify(chatSession)));
				
				if(chatSession){
					var endChatValue = {
						chatTopicValue : chatSession.iigproduct__Chat_Topic__c ? chatSession.iigproduct__Chat_Topic__c : '',
						// othersInput : chatSession.iigproduct__Others_Topic__c,
						chatNote : chatSession.iigproduct__Chat_Note__c,
						isOthersInputDisabled : !chatSession.iigproduct__Others_Topic__c 
					};
					component.set("v.chatSession",chatSession);
					component.set("v.endChatValue",endChatValue);
					helper.setStartChatTime(component,chatSession.CreatedDate);
					if(!rtnValue.chatSession.iigproduct__IsExpired__c){
						helper.subscribeChatMessage(component, event, helper);
					}
					component.set("v.tabName", chatSession.Name);
					helper.changeTabLabel(component, event, helper, chatSession.Name);
				}
				
				// console.log('rtnValue.messageCollection');
				// console.dir(JSON.stringify(rtnValue.messageCollection));
				setTimeout(function(){
					helper.moveBottomScrollbar(component); 
				}, 2000);
			}else{
				var endChatValue = {
					chatTopicValue : [],
					othersInput : '',
					chatNote : '',
					isOthersInputDisabled : true
				};
				component.set("v.endChatValue",endChatValue);
			}
			$A.util.addClass(component.find('mainLoading'), 'slds-hide');	
        });
		$A.enqueueAction(action);
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
			// console.log('downloadFileFromLine callback');
			
            var state = response.getState();
			console.log(state);
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();
				if(rtnValue !== null && rtnValue !== undefined) {
					// var openPDF = $A.get("e.force:navigateToSObject");
                    // openPDF.setParams({
                    //     "recordId" : rtnValue.Id,
                    //     "slideDevName" : "detail",
                    // });
					// openPDF.fire();
				
					// window.open(rtnValue.ContentDownloadUrl);
					window.location = rtnValue.ContentDownloadUrl
					setTimeout(function(){
						helper.removeFileFromOutsource(component, rtnValue.ContentVersionId);
					}, 5000);
					
                }
			}
		});
		action.setBackground();
		$A.enqueueAction(action);
	},
	downloadFileByMessageId: function(component, helper, messageId){
		console.log('downloadFileByMessageId');
	
		var action = component.get("c.getUrlFileByMessageId");
		action.setParams({
			"id" : messageId
        });
        action.setCallback(this, function (response) {
			// console.log('downloadFileByMessageId callback');
			
            var state = response.getState();
			console.log(state);
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();
				if(rtnValue) {
					window.open(rtnValue);
                }
			}
		});
		action.setBackground();
		$A.enqueueAction(action);
	},
	downloadImageFromOutsource : function(component, helper, blob, fileName) {
		console.log('downloadImageFromOutsource');
		
		var action = component.get("c.getDownloadLinkImage");
		action.setParams({
			"blobString" : blob,
			"fileName" : fileName
        });
        action.setCallback(this, function (response) {
			// console.log('downloadImageFromOutsource callback');
			
            var state = response.getState();
			// console.log(state);
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();
					// console.log(rtnValue.Id);
				if(rtnValue !== null && rtnValue !== undefined) {
					// var openPDF = $A.get("e.force:navigateToSObject");
                    // openPDF.setParams({
                    //     "recordId" : rtnValue.Id,
                    //     "slideDevName" : "detail",
					// });
					// openPDF.fire();
					window.location = rtnValue.ContentDownloadUrl					
					setTimeout(function(){
						helper.removeFileFromOutsource(component, rtnValue.ContentVersionId);
					}, 5000);
					
				}
			}
		});
		action.setBackground();
		$A.enqueueAction(action);
	},
	removeFileFromOutsource : function(component, fileId) {
		console.log('removeFileFromOutsource');
		var action = component.get("c.removeFileFromLine");
		action.setParams({
            'Id': fileId
        });
        action.setCallback(this, function (response) {
			// console.log('removeFileFromOutsource callback');
			
            var state = response.getState();
			console.log(state);
            if (state == 'SUCCESS') {
				console.log('removeFileFromOutsource success');
			}
		});
		$A.enqueueAction(action);
	},
	subscribeChatMessage: function (component, event, helper) {
		const empApi = component.find('empApi');
		const channel = component.get('v.channelEvent');
		const replayId = -1;
		
		const callback = function (response) {
			var newMessageResult = response.data.payload;
			// console.log('newMessageResult');
			// console.dir(JSON.stringify(newMessageResult));
			// console.log(component.get("v.recordId"));

			if(newMessageResult.iigproduct__ChatSession_Id__c === component.get("v.recordId")){
				if(newMessageResult.iigproduct__isExpired__c === 'true'){
					// console.log('newMessageResult.iigproduct__IsExpired__c ' + newMessageResult.iigproduct__isExpired__c);

					var chatSession = component.get("v.chatSession");		
					chatSession.iigproduct__IsExpired__c = true;
					// helper.showToast('sticky','info','Session is expired.', newMessageResult.iigproduct__Message__c);
					
					var thisDate = newMessageResult.iigproduct__Display_Date__c;
					var messageObject = { "owner" : '', 
											"timeStamp" : newMessageResult.iigproduct__Display_Time__c, 
											"ownerName" : '',
											"type" : 'expired'
										};

					helper.addMessageIntoCollection(component,messageObject,thisDate,newMessageResult.iigproduct__ChatMessage_Id__c);
					component.set("v.chatSession",chatSession);
					component.set("v.isDisableInput",true);
					helper.unsubscribeChatMessage(component,event,helper);

				}else{
					// component.set('v.isMoveTop',false);
				
					// var thisDate = newMessageResult.iigproduct__Display_Date__c;
					// var messageObject = helper.getMessageObjectByType(component,newMessageResult);

					// component.set("v.playNotifyInboundSound",true);
					// helper.addMessageIntoCollection(component,messageObject,thisDate);
					// helper.setFalseToPlayNoti(component,false);

					helper.getMessageObjectByType(component,helper,newMessageResult);
					if(!newMessageResult.iigproduct__Is_Outbound__c) {
						var workspaceAPI = component.find("workspace");
						workspaceAPI.getFocusedTabInfo().then(function(response) {
							var focusedTabId = response.tabId;
							workspaceAPI.getEnclosingTabId().then(function(tabId) {
								if(tabId !== focusedTabId) {
									component.set("v.isFlashing", true);
									helper.flashTabLabel(component, event, helper);
								}
							});
					   	});
        				
						// component.set("v.isFlashing", true);
						// helper.flashTabLabel(component, event, helper);
					}
				}
			}
		};

		empApi.subscribe(channel, replayId, $A.getCallback(callback))
		.then($A.getCallback(function (subscription) {
			console.log('Start subscribe chat by platform event on ' + component.get('v.recordId'));
			console.dir(JSON.stringify(subscription));
			component.set('v.chatMessageSubscription',subscription);
		}));
	},
	unsubscribeChatMessage: function (component, event, helper) {
		const empApi = component.find('empApi');
		const callback = function (message) {
		  console.log('Unsubscribed from channel ' + message.channel);
		};
		empApi.unsubscribe(component.get('v.chatMessageSubscription'), $A.getCallback(callback));
	},
	showToast : function(mode, type, title, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"mode" : mode,
			"type": type, 
			"title": title,
			"message": message
		});
		toastEvent.fire();
	},
	getMessageObjectByType: function (component,helper,newMessageResult) {
		// console.log('getMessageObjectByType');
		// console.dir(JSON.stringify(newMessageResult));

		var messageObject = { 
			"owner" : newMessageResult.iigproduct__Is_Outbound__c ? "provider" : "client", 
			"text" : newMessageResult.iigproduct__Message__c , 
			"timeStamp" : newMessageResult.iigproduct__Display_Time__c,
			"ownerName" : newMessageResult.iigproduct__Message_Owner__c,
			// "ownerName" : component.get("v.chatSession").Social_ID__r.iigproduct__Display_Name__c,
			"type" : newMessageResult.iigproduct__message_type__c,
			"urlContent" : newMessageResult.iigproduct__url_content__c,
			"id" : newMessageResult.iigproduct__ChatMessage_Id__c,
			"isHasMapMessage" : false
		};
		var thisDate = newMessageResult.iigproduct__Display_Date__c;
		var chatSession = component.get("v.chatSession");

				switch(newMessageResult.iigproduct__message_type__c) {
					case 'endchat':
								
						chatSession.iigproduct__IsExpired__c = true;
					  	messageObject = { "owner" : '', "text" : newMessageResult.iigproduct__Message__c , 
											"timeStamp" : helper.getTimeOnFormat(null), 
											"ownerName" : newMessageResult.iigproduct__Message_Owner__c,
											"type" : newMessageResult.iigproduct__message_type__c
										};
						
						helper.addMessageIntoCollection(component,messageObject,thisDate,newMessageResult.iigproduct__ChatMessage_Id__c);
						helper.setFalseToPlayNoti(component,true);
						component.set("v.chatSession",chatSession);
						// console.log(component.get("v.chatSession").iigproduct__isExpired__c);
						helper.unsubscribeChatMessage(component,event,helper);
						break;
					case 'transfer':
						window.location.reload();
						 //$A.get('e.force:refreshView').fire();
					  break;
					case 'location':
						if(newMessageResult.iigproduct__url_content__c && newMessageResult.iigproduct__url_content__c.includes('::')){
							var locationObject = newMessageResult.iigproduct__url_content__c.split('::');
							messageObject.mapObjects = [{
								location:{
									Latitude : locationObject[0],
									Longitude : locationObject[1]
								},
								title: newMessageResult.iigproduct__Message__c
							}];
							messageObject.isHasMapMessage = true;
						}else{
							messageObject.type = 'text';
						}
						helper.addMessageIntoCollection(component,messageObject,thisDate,newMessageResult.iigproduct__ChatMessage_Id__c);
					break;
					default:
						if(newMessageResult.iigproduct__Is_Outbound__c){
							if(newMessageResult.iigproduct__message_type__c === 'file'){
								var action = component.get("c.getContentDistributionDetail");
								action.setParams({
									"documentId" : newMessageResult.iigproduct__url_content__c
								});
								action.setCallback(this, function (response) {
									// console.log('getImage callback');
									
									var state = response.getState();
									console.log(state);
									if (state == 'SUCCESS') {
										var rtnValue = response.getReturnValue();
					
										messageObject.urlContent = rtnValue;
										// component.set("v.playNotifyOutboundSound",true);
										helper.addMessageIntoCollection(component,messageObject,thisDate,newMessageResult.iigproduct__ChatMessage_Id__c);
										// helper.setFalseToPlayNoti(component,true);
									}
								});
								$A.enqueueAction(action);
							}else{
								// component.set("v.playNotifyOutboundSound",true);
								helper.addMessageIntoCollection(component,messageObject,thisDate,newMessageResult.iigproduct__ChatMessage_Id__c);
								// helper.setFalseToPlayNoti(component,true);
							}
						}else{
							if(newMessageResult.iigproduct__message_type__c === 'image'){
								var action;
								switch (chatSession.iigproduct__Social_ID__r.iigproduct__Social_Type__c) {
									case 'Line' :
										action  = component.get("c.getImageFromLine");
										break;
									case 'Facebook' :
										action  = component.get("c.getImageFromFacebook");
										break;
								}
								if(!action) {
									return;
								}
								action.setParams({
									"url" : newMessageResult.iigproduct__Message__c
								});
								action.setCallback(this, function (response) {
									// console.log('getImage callback');
									
									var state = response.getState();
									// console.log(state);
									if (state == 'SUCCESS') {
										var rtnValue = response.getReturnValue();
					
										messageObject.text = rtnValue;
										//return messageObject;
										// console.dir(JSON.stringify(messageObject))
										// component.set("v.playNotifyInboundSound",true);
										helper.addMessageIntoCollection(component,messageObject,thisDate,newMessageResult.iigproduct__ChatMessage_Id__c);
										// helper.setFalseToPlayNoti(component,false);
									}
								});
								$A.enqueueAction(action);
							}else {				
								// component.set("v.playNotifyInboundSound",true);
								helper.addMessageIntoCollection(component,messageObject,thisDate,newMessageResult.iigproduct__ChatMessage_Id__c);
								// helper.setFalseToPlayNoti(component,false);
								//return messageObject;
							}
						}
					}

	},
	setFalseToPlayNoti: function (component,isOutbound) {
		if(isOutbound){
			setTimeout(function() {
				component.set('v.playNotifyOutboundSound',false);
			}, 1000);
		}
		else {
			setTimeout(function() {
				component.set('v.playNotifyInboundSound',false);
			}, 1000);
		}
	},
	convertObjectToMap: function(objectToConverted) {
		var mapResult = [];
		for(var o of objectToConverted){
			mapResult.push({value:o.messages, key:o.sentDate}); 
		}
		return mapResult;
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
	
	setStartChatTime: function(component,createdChatDateString){
		var today = new Date();
		var createdChatDate = createdChatDateString? new Date(createdChatDateString) : new Date();
		
		var toDayStr = '' + today.getDate() + today.getMonth() + today.getFullYear();
		var createdChatDateStr = '' + createdChatDate.getDate() + createdChatDate.getMonth() + createdChatDate.getFullYear();
		
		var startChatDateTime = this.getTimeOnFormat(createdChatDate);
		if(toDayStr !== createdChatDateStr) {
			startChatDateTime +=  ' on ' + this.getDateOnFormat(createdChatDate);
		}
		component.set('v.startChatDateTime',startChatDateTime);
	},
	saveTextMessage: function(component, event, helper,textMessage) {
		console.log('saveTextMessage _______');
		
		var action = component.get("c.saveMessageObject");
		var messageModel = {
			messageType : 'text',
			// sender : component.get("v.provider").Id,
			sender : '111',
			text : textMessage
		};
		console.log('JSON.stringify(messageModel)' + JSON.stringify(messageModel));
        action.setParams({
			'recordId': component.get("v.recordId"),
			'messageStringModel' : JSON.stringify(messageModel)
        });
        action.setCallback(this, function (response) {
			var state = response.getState();
           
            if (state == 'SUCCESS') {
				console.log('----------____---------');
				
				var rtnValue = response.getReturnValue();

				var thisDate = helper.getDateOnFormat(null);
				var messageObject = { "owner" : "provider", "text" : textMessage , 
										"timeStamp" : helper.getTimeOnFormat(null), 
										"ownerName" : component.get("v.provider").Name,
										"type" : 'text'
									};
				// console.log(textMessage);
				helper.addMessageIntoCollection(component,messageObject,thisDate,rtnValue.chatMessageId);
			}else{
				console.log('testsetsete');
				
			}
        });
		$A.enqueueAction(action);
	},
	moveBottomScrollbar: function(component) {
		console.log('moveBottomScrollbar');
		var containerId = '#id-container-' + component.get('v.recordId');
		console.log('containerId :: '+containerId);
		
		if($(containerId) && $(containerId)[0] && $(containerId)[0].scrollHeight){
			
			console.log('moveBottomScrollbar');
			$(containerId).scrollTop($(containerId)[0].scrollHeight);
		}else{
			console.log('can not moveBottomScrollbar');
			component.set('v.isShowMoveBottomButton',true)
		}
        //else{
		//	$A.get('e.force:refreshView').fire();
		//}
	},
	moveTopScrollbar: function(component) {
		console.log('moveTopScrollbar');
		var containerId = '#id-container-' + component.get('v.recordId');
		$(containerId).scrollTop(0);
	},
	sendMessage: function (component, event, helper) {
		var currentMessage = component.get('v.currentMessage');
		console.log('currentMessage : '+currentMessage);
		
		component.set('v.currentMessage',null);
		if(currentMessage === undefined || currentMessage === null || currentMessage.trim() === ""){
			console.log( ' currentMessage === null ja ');
			
		  return;
		}
		helper.saveTextMessage(component, event, helper,currentMessage);
	  },
	addMessageIntoCollection: function (component,messageObject,thisDate,chatMessageId) {
		// console.log('messageObject');
		// console.dir(JSON.stringify(messageObject));
		var chatMessageIdList = component.get('v.chatMessageIdList');
		if(!chatMessageId || chatMessageIdList.includes(chatMessageId)){
			return;
		}
		var chatCollectionByDate = component.get('v.chatCollectionByDate');
		var lastDate = component.get('v.lastDate');
	
		if(lastDate === thisDate){
			/** the last item always has the last date */
			// chatCollectionByDate[0].messages.splice(0,0,messageObject);
			chatCollectionByDate[chatCollectionByDate.length-1].messages.push(messageObject);
		}else{
			
			// chatCollectionByDate.splice(0,0,newCollectionInThisDate);
			chatCollectionByDate.push({
				"sentDate" : thisDate,
				"messages" : [messageObject]
			  });
			lastDate = thisDate;
		}
		// console.log('chatCollectionByDate');
		// console.dir(JSON.stringify(chatCollectionByDate));
		chatMessageIdList.push(chatMessageId);
		component.set('v.chatMessageIdList',chatMessageIdList);
		component.set('v.chatCollectionByDate',chatCollectionByDate);
		component.set('v.lastDate',lastDate);
		if(messageObject.owner && messageObject.owner === 'client'){
			component.set('v.playNotifyOutboundSound',true);
			this.setFalseToPlayNoti(component,true);
		}else{
			component.set('v.playNotifyInboundSound',true);
			this.setFalseToPlayNoti(component,false);
		}
		component.set('v.isMoveTop',false);

	  },
	  getMoreData: function (component, event, helper) {
		$A.util.removeClass(component.find('mainLoading'), 'slds-hide');		
		var action = component.get("c.getMoreData");
        action.setParams({
			'recordId': component.get("v.recordId"),
			'previosChatmessage': component.get("v.previousMessage"),
			'useAllSession': true
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
           
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();
				helper.addPreviosMessage(component,helper,rtnValue.messageCollection)
				component.set("v.isHasPreviousMessage",rtnValue.isHasPreviousMessage);
				component.set("v.previousMessage",rtnValue.previousMessage);
			}
			$A.util.addClass(component.find('mainLoading'), 'slds-hide');
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
	  clearEndChatInformation: function (component) {
		component.set('v.isOpenEndChat',false);
		component.set('v.isOpenWrapUpChat',false);
		component.set('v.endChatErrorMessage',null);
		var chatSession = component.get("v.chatSession");
		// var endChatValue = {
		// 	chatTopicValue : [],
		// 	othersInput : '',
		// 	chatNote : ''
		// };
		var endChatValue = {
			chatTopicValue : chatSession.iigproduct__Chat_Topic__c ? chatSession.iigproduct__Chat_Topic__c.split(";") : [],
			othersInput : chatSession.iigproduct__Others_Topic__c,
			chatNote : chatSession.iigproduct__Chat_Note__c,
			isOthersInputDisabled : !chatSession.iigproduct__Others_Topic__c 
		};
		component.set("v.endChatValue",endChatValue);
		// component.set('v.chatTopicValue',[]);
		// component.set('v.othersInput',null);
		// component.set('v.chatNote',null);
	  },
	  saveEndChatInformation: function (component, event, helper) {
		$A.util.removeClass(component.find('endChatLoading'), 'slds-hide');		
		var chatSession = component.get('v.chatSession');
		console.log('chatSession.iigproduct__isExpired__c ' + chatSession.iigproduct__IsExpired__c);
		var action = component.get("c.updateChatSessionIfEndChatOccured");
		var endChatValue = component.get("v.endChatValue");
		var messageModel = {
			messageType : 'endchat',
			sender : component.get("v.provider").Id,
			text : 'Chat ended by'
		};
        action.setParams({
			'recordId': component.get("v.recordId"),
			'chatTopic': endChatValue.chat_topic_text,
			// 'othersTopic': endChatValue.othersInput,
			'chatNote' : endChatValue.chatNote,
			'messageStringModel' : JSON.stringify(messageModel),
			'isAutoExpired' : false
        });
        action.setCallback(this, function (response) {
			
            var state = response.getState();
           
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();
				chatSession.iigproduct__IsExpired__c = true;
				chatSession.iigproduct__Chat_Topic__c = endChatValue.chat_topic_text;
				// chatSession.iigproduct__Others_Topic__c = endChatValue.othersInput;
				chatSession.iigproduct__Chat_Note__c = endChatValue.chatNote;
				// console.log('isCollectionAdded ' + isCollectionAdded);
				// if(isCollectionAdded){
				// 	var thisDate = helper.getDateOnFormat(null);
				// 	var messageObject = { "owner" : '', "text" : messageModel.text , 
				// 							"timeStamp" : helper.getTimeOnFormat(null), 
				// 							"ownerName" : component.get("v.provider").Name,
				// 							"type" : messageModel.messageType
				// 						};

					// helper.addMessageIntoCollection(component,messageObject,thisDate,rtnValue);
				// }
				
				component.set('v.chatSession',chatSession);
				component.set('v.isOpenEndChat',false);
				component.set('v.isOpenWrapUpChat',false);
				component.set('v.endChatErrorMessage', null);
				component.set("v.isDisableInput",true);
				
				$A.get('e.force:refreshView').fire();
				
				// this.clearEndChatInformation(component);
			}else if(state === "ERROR"){
				component.set('v.endChatErrorMessage', 'Saving informations failed');
			}
			$A.util.addClass(component.find('endChatLoading'), 'slds-hide');		
        });
		$A.enqueueAction(action);
	  },
	  clearTransferChatInformation: function (component) {
		component.set('v.transferChatErrorMessage', null);		
		component.set('v.isOpenTransferChat',false);
	  },
	  saveTransferChatInformation: function (component, event, helper,newOwnerTransfer) {
		$A.util.removeClass(component.find('transferChatLoading'), 'slds-hide');				
		var action = component.get("c.updateChatSessionIfTransferChatOccured");
		var textMessage = 'sent a transfer chat to';
		var messageModel = {
			messageType : 'transfer',
			sender : component.get("v.provider").Id,
			text : textMessage + '->' + newOwnerTransfer.Name
		};
        action.setParams({
			'recordId': component.get("v.recordId"),
			'newOwnerId': newOwnerTransfer.Id,
			'transferMessage': component.get('v.transferMessage'),
			'newOwnerType' : component.get('v.selectedTransferObtionKey'),
			'messageStringModel' : JSON.stringify(messageModel)
        });
        action.setCallback(this, function (response) {
			
            var state = response.getState();
           
            if (state == 'SUCCESS') {
				// var rtnValue = response.getReturnValue();
				// var thisDate = helper.getDateOnFormat(null);
				// var messageObject = { "owner" : newOwnerTransfer.Name, "text" : textMessage , 
				// 						"timeStamp" : helper.getTimeOnFormat(null), 
				// 						"ownerName" : component.get("v.provider").Name,
				// 						"type" : messageModel.messageType
				// 					};

				// helper.addMessageIntoCollection(component,messageObject,thisDate,rtnValue);
				this.clearTransferChatInformation(component);
				// window.location.reload();
				// $A.get('e.force:refreshView').fire();

			

			}else if(state === "ERROR"){
				component.set('v.transferChatErrorMessage', 'Saving informations failed');
			}
			$A.util.addClass(component.find('transferChatLoading'), 'slds-hide');				
        });
		$A.enqueueAction(action);
	  },
	  sendImageAndFile: function (component, event, helper,documentId) {
		var action = component.get("c.saveMessageObject");
		var messageModel = {
			messageType : 'imagefile',
			sender : component.get("v.provider").Id,
			text : documentId
		};
        action.setParams({
			'recordId': component.get("v.recordId"),
			'messageStringModel' : JSON.stringify(messageModel)
        });
        action.setCallback(this, function (response) {
			var state = response.getState();
            if (state == 'SUCCESS') {
				var rtnValue = response.getReturnValue();

				var thisDate = helper.getDateOnFormat(null);
				var messageObject;
				switch(rtnValue.messageType) {
					case 'image':
						messageObject = { "owner" : "provider", "text" : rtnValue.url, 
							"timeStamp" : helper.getTimeOnFormat(null), 
							"ownerName" : component.get("v.provider").Name,
							"type" : rtnValue.messageType
						};
					  break;
					case 'file':
						messageObject = { "owner" : "provider", "text" : rtnValue.fileName, 
							"timeStamp" : helper.getTimeOnFormat(null), 
							"ownerName" : component.get("v.provider").Name,
							"type" : rtnValue.messageType,
							"urlContent" : rtnValue.url
						};
					  break;
					default:
					  // code block
				  }

				helper.addMessageIntoCollection(component,messageObject,thisDate,rtnValue.chatMessageId);
				}
		});
		$A.enqueueAction(action);
	},
	changeTabLabel: function(component, event, helper, message) {
		var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
			workspaceAPI.setTabLabel({
                tabId: tabId,
                label: message
            });
       });
	},
	flashTabLabel: function(component, event, helper) {
		if(!component.get("v.isFlashing")) {
			return;
		}
		helper.changeTabLabel(component, event, helper, "*** NEW MESSAGE ***");
		setTimeout(() => {
			helper.changeTabLabel(component, event, helper, component.get("v.tabName"));
			if(component.get("v.isFlashing")) {
				setTimeout(() => {
					helper.flashTabLabel(component, event, helper);
				}, 1000);
			}
		}, 1000);
	},
	setChatTopicSection: function(component,chatTopicPickLists,chatSession){
		if(!chatSession){
			return;
		}
		var numberRowOfFirstColums = 5;
		var numberRowOfSecondColums = 3;
		var result = [];
		var existChatTopic = chatSession.iigproduct__Chat_Topic__c? chatSession.iigproduct__Chat_Topic__c.split(";"): [];
		
		for(var i = 0; i < chatTopicPickLists.length; i++){
		console.dir(chatTopicPickLists[i]);
			// if(existChatTopic.includes(chatTopicPickLists[i].label)){
			// 	chatTopicPickLists[i].checked = true;
			// }else{
			// 	chatTopicPickLists[i].checked = false;
			// }
			chatTopicPickLists[i].checked = existChatTopic.includes(chatTopicPickLists[i].value);

			var index = i % numberRowOfFirstColums;
			if(i < numberRowOfFirstColums){
				result[index] = [];
				result[index].push(chatTopicPickLists[i]);
			}else{
				result[index].push(chatTopicPickLists[i]);
			}

			if(chatTopicPickLists[i].value == 'Other' || chatTopicPickLists[i].value == 'Others'){
				result[index+1].push('inputText');
			}
		}

		console.dir(result);
		component.set('v.chatTopicSection',result);
	},
	udpateChatTopicCheckedStatus : function(component,chatTopicPickLists){

	}
})