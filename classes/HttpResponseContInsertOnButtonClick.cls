/**
* Purpose      :  This class is used to request callout of rest api.

* Created By   :  Shubh Shree Rathore
* 
* Created Date :  24/07/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore -  24/07/2019- Created
* 
**/
public class HttpResponseContInsertOnButtonClick {
    //Calling Constructor
    public HttpResponseContInsertOnButtonClick(ApexPages.StandardController stdController) {
      }    
/* 
*	Description		:	This method used to make the account and contact of that record whose button is clicked by one org it will create records in another org.
*
*	@argument		:	-
*
*	Revision Logs	: 	V_1.0 - Created
*/     
    public static void callout() {
        
        String conId  = apexpages.currentPage().getParameters().get('Id');
        system.debug('id'+conId);
		List<Contact> con = [SELECT Id,LastName, Account.Name ,Target_Session_Id__c from Contact where ID =: conId ];
        system.debug('list of con' +con);
        String body = '{"accName": "'+con[0].Account.Name +'", "conName": "'+con[0].LastName +'"}';
        String accessToken = HttpRequestClass.getAccessToken();
        String bodyResponse = Request.callout(accessToken,body);
        system.debug('bodyResponse' +bodyResponse);
    	String accountUrl = bodyResponse.substringBeforeLast(',').remove('["').removeEnd('"');
        String contactUrl = bodyResponse.substringAfterLast(',').remove('"').removeEnd(']');
        try{
            if(bodyResponse.length()>0) {
                Contact contacts = new Contact();
                contacts.Id = con[0].Id;
                contacts.Synced_Account__c = accountUrl ;
                contacts.Synced_Contact__c =contactUrl;
               	contacts.Rest_Response__c = bodyResponse;
                update contacts;
                system.debug('updated rec' +contacts);
            }
        }Catch(Exception ex){
          System.debug('Error'+ ex.getMessage());
        }     
    }   
}