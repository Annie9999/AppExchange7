({
	init : function(component, event, helper) {
        component.set('v.leadcolumns', [
            {label: 'Name', 
             fieldName: 'leadLink', 
             type: 'url', 
             typeAttributes: {label: { fieldName: 'leadName' },target: '_self',tooltip:{ fieldName: 'leadName' }}},
            
			{label: 'Interested Project', 
             fieldName: 'interestedProjectLink', 
             type:  'url', typeAttributes: {label: { fieldName: 'interestedProject' }, target: '_self', tooltip:{ fieldName: 'interestedProject' } }},
            
            {label: 'Status', 
             fieldName: 'status', 
             type: 'text'},
            
            {label: 'Created Date', 
             fieldName: 'createdDate', 
             type: 'text'},
            
			{label: 'Last Modified Date', 
             fieldName: 'lastModified', 
             type: 'text'},

        ]);

        helper.getLeads(component, event, helper);

    }
});