/**
* Purpose      :  This class is used to request callout of rest api.

* Created By   :  Shubh Shree Rathore
* 
* Created Date :  24/07/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore -  24/07/2019- Created
* 
**/
public class SyncDataRequest {
    //Calling Constructor
    public SyncDataRequest(ApexPages.StandardController stdController) {
        
    }    
/* 
*	Description		:	This method used to make the account.
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
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        
        String endPoint='https://ap15.salesforce.com/services/apexrest/Ins/createAcc/';
        
        req.setHeader('Authorization', 'OAuth '+con[0].Target_Session_Id__c );
        
        req.setHeader('Content-Type','application/json');     
        
        req.setEndpoint(endPoint);
        
        String body = '{"accName": "'+con[0].Account.Name +'", "conName": "'+con[0].LastName +'"}';
        
        system.debug('Body' +body);
        
        req.setBody(body);
        
        
        Http http = new Http();
        
        HTTPResponse res = http.send(req);
        
        String listToHold = res.getBody();
        String accountUrl = listToHold.substringBeforeLast(',').remove('["').removeEnd('"');
        String contactUrl = listToHold.substringAfterLast(',').remove('"').removeEnd(']');
        try{
            if(res.getStatusCode() == 200) {
                Contact contacts = new Contact();
                contacts.Id = con[0].Id;
                contacts.Synced_Account__c =accountUrl ;
                contacts.Synced_Contact__c =contactUrl;
                system.debug('Acc' +accountUrl); 
                system.debug('con' +contactUrl);
                contacts.Rest_Response__c = res.getBody();
                update contacts;
                system.debug('updated rec' +contacts);
            }
        }Catch(Exception ex){
          System.debug('Error'+ ex.getMessage());
        }     
    }   
}