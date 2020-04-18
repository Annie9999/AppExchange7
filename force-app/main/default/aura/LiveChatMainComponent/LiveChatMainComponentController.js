({
  onInit: function (component, event, helper) {
    console.dir(JSON.parse(JSON.stringify(component.get("v.recordId"))));
    
    component.set('v.isFinishedLoadJquery', true);
    var transferObtion = {
      People: {
        objectAPIName: 'User', IconName: 'standard:avatar', condition: 'AND IsActive = true AND Profile.Name IN (\'Sansiri Telesale\',\'Sansiri Call Centre\')',
        selectedValue: null, hasLastViewedDate: true
      },
      Queue: {
        objectAPIName: 'Group', IconName: 'standard:groups', condition: 'AND Type = \'Queue\' And Name like \'%Chat%\'',
        selectedValue: null, hasLastViewedDate: false
      }
    };
    var selectedTransferObtionKey = component.get('v.selectedTransferObtionKey');
    component.set('v.selectedTransferObtion', transferObtion[selectedTransferObtionKey]);
    component.set('v.transferObtion', transferObtion);

    helper.getInitData(component, event, helper);
  },
  onRender: function (component, event, helper) {
    console.dir(JSON.parse(JSON.stringify(component.get("v.recordId"))));
    console.log("---entry in render---");

    
    if (!component.get('v.isFinishedLoadJquery')) {
      return;
    }
    // var containerId = '#id-container-' + component.get('v.recordId');
    // if($(containerId) && $(containerId)[0] && $(containerId)[0].scrollHeight && $(containerId)[0].scrollHeight == 0){
    //   window.location.reload();
    // }
    var isMoveTop = component.get('v.isMoveTop');
    if (isMoveTop === null){
      return;
    }
    // console.log('isMoveTop ' + isMoveTop);
    if (!isMoveTop) {
        helper.moveBottomScrollbar(component);
      
    } else if (isMoveTop) {
      helper.moveTopScrollbar(component);
    }
  },
  
  onClickSendMessage: function (component, event, helper) {
    component.set('v.isMoveTop', false);
    helper.sendMessage(component, event, helper);
  },
  onKeyPressMessage: function (component, event, helper) {
    component.set('v.isMoveTop', false);
    if(event.shiftKey){
      console.dir(JSON.parse(JSON.stringify(event)));
    }
    if (event.which == 13 && event.shiftKey == false) {
      console.log('Enter');
      
      helper.sendMessage(component, event, helper);
    }
  },
  handleShowmoreMessage: function (component, event, helper) {
    component.set('v.isMoveTop', true);
    helper.getMoreData(component, event, helper);
  },
  handleDownloadFile: function (component, event, helper) {
    console.log('handleDownloadFile');
    var param = event.getParam("params");
    if (param['url']) {
      helper.downloadFileFromLine(component, helper, param['url'], param['file_name']);
    } else {
      helper.downloadFileByMessageId(component, helper, param['message_id']);
    }
  },
  handleDownloadImage: function (component, event, helper) {
    console.log('handleDownloadImage');
    var param = event.getParam("params");
    helper.downloadImageFromOutsource(component, helper, param['blob'], param['file_name']);
  },
  onClickEndChat: function (component, event, helper) {
    component.set('v.isOpenEndChat', true);
  },
  onClickWrapUpChat: function (component, event, helper) {
    component.set('v.isOpenWrapUpChat', true);
  },
  onClickCancelEndChat: function (component, event, helper) {
    helper.clearEndChatInformation(component);
  },
  onClickSubmitEndChat: function (component, event, helper) {
    var endChatValue = component.get("v.endChatValue");
    // var chatTopicOptions = component.get("v.chatTopicOptions");
    // var chatTopicValue = [];
    // for(var each of chatTopicOptions){
    //   if(each.checked){
    //     chatTopicValue.push(each.value);
    //   }
    // }
    // endChatValue.chatTopicValue = chatTopicValue;
    // component.set("v.endChatValue.chatTopicValue", chatTopicValue);

    console.dir(JSON.stringify(endChatValue));
    var othersInput = endChatValue.chat_topic_text;
    console.log('othersInput : ',othersInput);
    
    if (othersInput == undefined || othersInput.length == 0  ) {
      component.set('v.endChatErrorMessage', 'Please fill in chat topic.');
      return;
    }
    // console.log('othersInput : ',othersInput);
    // if (chatTopicValue.includes('Other') && !othersInput) {
    //   component.set('v.endChatErrorMessage', 'Please fill in the others chat topic.');
    //   return;
    // }
    // if (!chatTopicValue.includes('Other')) {
    //   component.set("v.endChatValue.othersInput", '');
    //   component.set('v.endChatValue.isOthersInputDisabled', true);
    // }
    helper.saveEndChatInformation(component, event, helper);
  },
  onClickTransferChat: function (component, event, helper) {
    component.set('v.isOpenTransferChat', true);
  },
  onChangeChatTopicRadio: function (component, event, helper) {
    var values = event.getParam("value");
    if (values.includes('Other')) {
      component.set('v.endChatValue.isOthersInputDisabled', false);
    } else {
      component.set('v.endChatValue.isOthersInputDisabled', true);
    }
  },
  onSelectTransferObtions: function (component, event, helper) {
    var selectedMenuItemValue = event.getParam("value");
    component.set('v.selectedTransferObtionKey', selectedMenuItemValue);
    var transferObtion = component.get('v.transferObtion');
    component.set('v.selectedTransferObtion', transferObtion[selectedMenuItemValue]);
    // console.dir(JSON.stringify(transferObtion[selectedMenuItemValue]));
    // console.dir(JSON.stringify(transferObtion[selectedMenuItemValue].objectAPIName));
  },
  onClickCancelTransferChat: function (component, event, helper) {
    helper.clearTransferChatInformation(component);
  },
  onClickSubmitTransferChat: function (component, event, helper) {
    var selectedTransferObtionKey = component.get('v.selectedTransferObtionKey');
    var transferObtion = component.get('v.transferObtion');
    var newOwnerTransfer = transferObtion[selectedTransferObtionKey].selectedValue;

    if (newOwnerTransfer === undefined || newOwnerTransfer === null) {
      component.set('v.transferChatErrorMessage', 'Please choose new owner.');
      return;
    }

    helper.saveTransferChatInformation(component, event, helper, newOwnerTransfer);
  },
  // onClickDownLoadFile: function (component, event, helper) {
  //   helper.downloadFileFromLine(component, event, helper);
  // }
  handleUploadFinished: function (component, event, helper) {
    // Get the list of uploaded files
    var uploadedFiles = event.getParam("files");
    // alert("Files uploaded : " + uploadedFiles[0].name + " " + uploadedFiles[0].documentId);
    helper.sendImageAndFile(component, event, helper, uploadedFiles[0].documentId);
    // use apex get this document
  },
  onTabFocused: function (component, event, helper) {
    // console.log("Tab Focused Hi");
    var focusedTabId = event.getParam("currentTabId");
    var workspaceAPI = component.find("workspace");
    workspaceAPI.getEnclosingTabId().then(function (tabId) {
      if (tabId === focusedTabId) {
        component.set("v.isFlashing", false);
      }
    });
    component.set('v.isFinishedLoadJquery', true);
    // console.log('Init');
    var transferObtion = {
      People: {
        objectAPIName: 'User', IconName: 'standard:avatar', condition: 'AND IsActive = true AND Profile.Name IN (\'Sansiri Telesale\',\'Sansiri Call Centre\')',
        selectedValue: null, hasLastViewedDate: true
      },
      Queue: {
        objectAPIName: 'Group', IconName: 'standard:groups', condition: 'AND Type = \'Queue\' And Name like \'%Chat%\'',
        selectedValue: null, hasLastViewedDate: false
      }
    };
    var selectedTransferObtionKey = component.get('v.selectedTransferObtionKey');
    component.set('v.selectedTransferObtion', transferObtion[selectedTransferObtionKey]);
    component.set('v.transferObtion', transferObtion);

    helper.getInitData(component, event, helper);
  },
  onHandleScroll: function (component, event, helper) {
    var containerId = '#id-container-' + component.get('v.recordId');
    
    // console.log('onHandleScroll ' + $(containerId)[0].scrollHeight);
    // console.log($(containerId)[0].clientHeight);
    // console.log($(containerId).scrollTop());
   
    component.set('v.isMoveTop',null);
    if ($(containerId) && $(containerId)[0] && $(containerId)[0].scrollHeight && $(containerId)[0].clientHeight) {
      var branchmarkBottom = $(containerId)[0].scrollHeight - $(containerId)[0].clientHeight - 40;
      if ($(containerId).scrollTop() > branchmarkBottom) {
        component.set('v.isShowMoveBottomButton', false);
        console.log('isShowMoveBottomButton false');
        return;
      }
    }
    component.set('v.isShowMoveBottomButton', true);
    // console.log('isShowMoveBottomButton true');
  },
  onClickMoveBottom: function (component, event, helper) {
    helper.moveBottomScrollbar(component);
  },
  handleClickRefreshChatBoard: function (component, event, helper){
    helper.getInitData(component, event, helper);
  },
  handleSelectChatBoardMenu: function (component, event, helper) {
    switch(event.getParam("value")) {
      case 'refresh':
          helper.getInitData(component, event, helper);
          break;
    } 
},
onChangeChatTopicCheckbox: function (component, event, helper) {
  var checked = event.getParam('checked');
  var label = event.getSource().get('v.name');
  console.dir(label);
  if (label === 'Other') {
      component.set('v.endChatValue.isOthersInputDisabled', !checked);
  } 
},

})