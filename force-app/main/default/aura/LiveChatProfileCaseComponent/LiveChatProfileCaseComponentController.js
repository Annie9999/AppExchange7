({
	init : function(component, event, helper) {
        component.set('v.casecolumns', [
            {label: 'Case Number', 
             fieldName: 'caseLink', 
             type: 'url', 
             typeAttributes: {label: { fieldName: 'caseNumber' }, target: '_self', tooltip:{ fieldName: 'caseNumber' }}},
            
            {label: 'Subject',
             fieldName: 'caseLink', 
             type: 'url', 
             typeAttributes: {label: { fieldName: 'subject' }, target: '_self', tooltip:{ fieldName: 'subject' }}},
            
            {label: 'Project', 
             fieldName: 'projectLink',  
             type:  'url', 
             typeAttributes: {label: { fieldName: 'project' }, target: '_self', tooltip:{ fieldName: 'project' }}},
            
            {label: 'Unit', 
             fieldName: 'unitLink',  
             type:  'url', 
             typeAttributes: {label: { fieldName: 'unit' }, target: '_self', tooltip:{ fieldName: 'unit' }}},
            
            {label: 'Category', 
             fieldName: 'category', 
             type: 'text'},
            
            {label: 'Sub Category', 
             fieldName: 'subCategory', 
             type: 'text'},
            
            {label: 'Case Owner', 
             fieldName: 'caseOwnerLink',  
             type:  'url', typeAttributes: {label: { fieldName: 'caseOwner' }, target: '_self', tooltip:{ fieldName: 'caseOwner' } }},
            
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

        helper.getCases(component, event, helper);
    }
});