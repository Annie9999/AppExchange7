({
	doInit : function(component, event, helper) {
		var record = component.get("v.oRecord");
		var extraSearchField = '';
		console.log(extraSearchField);
		console.log('/////'+JSON.stringify(record));
		if(extraSearchField !== "" && extraSearchField !== undefined && extraSearchField !== null && record.extraValue !== null) {
			console.log('youre in');
			var extraSearchFields = extraSearchField.split(",");
			if(extraSearchFields.length > 0){
				var extraFeilds = "";
				for(var i = 0; i < extraSearchFields.length; i++){
					if(record.extraValue[extraSearchFields[i]] !== undefined){
						if(extraFeilds.length > 0){
							extraFeilds += ", " + record.extraValue[extraSearchFields[i]];				
						}
						else{
							extraFeilds +=  record.extraValue[extraSearchFields[i]];				
						}
					}
				}
				component.set("v.extraField", extraFeilds);
				console.log(extraFeilds);
			}
			else{
				if(record.extraValue[extraSearchField] !== undefined){
					component.set("v.extraField", extraFeilds);	
					console.log(record.extraValue[extraSearchField]);
				}
			}
		}
		
	},
	 selectRecord : function(component, event, helper){      
	  // get the selected record from list  
		var getSelectRecord = component.get("v.oRecord");
	  // call the event   
		var compEvent = component.getEvent("oSelectedRecordEvent");
	  // set the Selected sObject Record to the event attribute.  
		   compEvent.setParams({"recordByEvent" : getSelectRecord });  
	  // fire the event  
		   compEvent.fire();
	  },
  })