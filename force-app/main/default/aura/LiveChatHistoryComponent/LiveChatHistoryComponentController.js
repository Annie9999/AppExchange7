({
	onInit: function (component, event, helper) {
		component.set('v.currentDataTimeLine',{});
		helper.getInitData(component, event, helper);
	},
	navigateToObject :function (component, event, helper) {
		console.log('navigateToObject');
		var recordId = event.getParam('params').recordId;
		var indexList = event.getParam('params').index;
		// var navEvt = $A.get("e.force:navigateToSObject");
		// navEvt.setParams({
		// "recordId": recordId,
		// "slideDevName": "related"
		// });
		// navEvt.fire();
		var dataTimeLines = component.get("v.dataTimeLines");
		component.set("v.currentDataTimeLine",dataTimeLines[indexList]);
		helper.getPopupData(component,event,helper);
		component.set("v.isOpenChatHistoryPopup",true);
	},
	onClickCancelPopup :function (component, event, helper) {
		component.set("v.isOpenChatHistoryPopup",false);
		component.set('v.currentDataTimeLine',{});
		component.set('v.chatCollectionByDate',[]);
		component.set("v.previousMessage",null);
		component.set("v.isHasPreviousMessage",false);
		component.set("v.startChatDateTime",null);
		component.set("v.currentChatSession",false);
	},
	handleShowmoreMessage: function (component, event, helper) {
		console.log('handleShowmoreMessage');
		component.set('v.isMoveTop',true);
		helper.getPopupData(component, event, helper);
	},
	handleDownloadFile: function (component, event, helper) {
		console.log('handleDownloadFile');
		var param = event.getParam("params");
		helper.downloadFileFromLine(component, helper, param['url'], param['file_name']);
	},
	handleDownloadImage: function (component, event, helper) {
		console.log('handleDownloadImage');
		var param = event.getParam("params");
		helper.downloadImageFromLine(component, helper, param['blob'], param['file_name']);
	},
})