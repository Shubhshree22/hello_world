/**
* Purpose      :  This class is used to request .
*
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  26/07/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore -  25=6/07/2019- Created
* 
**/
public class Request {
/* 
*	Description		:	This method used to send the acess token and body.
*
*	@argument		:	
*
*	Revision Logs	: 	V_1.0 - Created
*/    
    public static String callout(String accessToken,String body) {
       
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            String endPoint='https://ap15.salesforce.com/services/apexrest/Ins/createAcc/';
            req.setHeader('Authorization', 'Bearer '+accessToken);
            req.setHeader('Content-Type','application/json');     
            req.setEndpoint(endPoint);
            req.setBody(body);
            system.debug('Body' +body);
            Http http = new Http();
            HttpResponse res = http.send(req);
            String listToHold = res.getBody();
            return listToHold;
        
    }  
}