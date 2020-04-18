({
	init : function(component, event, helper) {
        component.set('v.customercolumns', [
            {label: 'Name', 
             fieldName: 'customerLink', 
             type: 'url', 
             typeAttributes: {label: { fieldName: 'customerName' }, target: '_self', tooltip:{ fieldName: 'customerName' }}},
			
            {label: 'Status', 
             fieldName: 'status', 
             type: 'text'},
			
            {label: 'VIP', 
             fieldName: 'vip', 
             type: 'text'},
			
            {label: 'Customer Owner', 
             fieldName: 'customerOwnerLink', 
             type:  'url', 
             typeAttributes: {label: { fieldName: 'customerOwner' }, target: '_self', tooltip:{ fieldName: 'customerOwner' }}},
            
            {label: 'Created Date', 
             fieldName: 'createdDate', 
             type: 'text'},
            
            {label: 'Last Modified Date', 
             fieldName: 'lastModified', 
             type: 'text'},

        ]);

        helper.getCustomers(component, event, helper);

    }
});