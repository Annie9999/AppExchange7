({
	onClickHeader : function(component, event, helper) {
        console.log('onClickHeader');
        var recordId = component.get("v.recordId");
        if(recordId === undefined || recordId === null){
            return;
        }
		var clickedEvent = component.getEvent("customBasicHeaderClicked");
        var param =  {
                recordId: recordId,
                index: component.get("v.index")
            };
        clickedEvent.setParams({ params: param });
        clickedEvent.fire();
	}
})