public Class SearchWizard {

/* 
*	Description		:	This method used  to fetch all the fields api name and label with their data type the Account
*
*	@argument		:	Id accountId
*
*	Revision Logs	: 	V_1.0 - Created
*/
    @AuraEnabled
    public static ResponseUtility fetchDetails(Id accId) {
        ResponseUtility response = new ResponseUtility();
        try{
            
            List<wrapperClassforObjects> wrapperList = new List<wrapperClassforObjects>();
            DescribeSObjectResult describeResult = accId.getSObjectType().getDescribe();
            
            Map<String,Schema.SObjectField> fieldSetMemberMap =  describeResult.fields.getMap();
            for(String f : fieldSetMemberMap.keyset()){
                Schema.DescribeFieldResult desribeResult = fieldSetMemberMap.get(f).getDescribe();
                wrapperClassforObjects wrapper = new wrapperClassforObjects();
                wrapper.label = desribeResult.getLabel();
                wrapper.value= desribeResult.getName();
                wrapper.fieldtype = String.valueOf(desribeResult.getType());
                wrapperList.add(wrapper);
            }
            
            response.setBody(wrapperList);
            
            
        }
        catch(Exception ex){
            system.debug('error-'+ ex.getMessage()+' on line -'+ ex.getLineNumber());
        }
        return response;
    }
	
	public class wrapperClassforObjects {
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String fieldtype{get;set;}
        
    }

}