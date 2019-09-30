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
public class HttpRequestClass {
    /* 
*	Description		:	This method used to get the access token.
*
*	@argument		:	
*
*	Revision Logs	: 	V_1.0 - Created
*/
    public static String getAccessToken() {
        String body = 'grant_type=password'+'&client_id=3MVG9G9pzCUSkzZt27sRdy8Ds8i2mbnfdrGIV6Zh96aYoAwWAKOFb7iO8x8uouO_XXTHPOF2BdgxYg5KWcIAf'+'&client_secret=DEE210ABAA3A6F7CABD525134004E6682AB93DE0C70512DCFF0238C6DD2D9AC1'+'&username=shubhshreeerathore2@fexle.com'+'&password=shubhi1234SZuw7CZ57Uem8wjejm8sxUu2';
        String accessToken ='';
        HTTPResponse res = new HTTPResponse();
        try {
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');     
            req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
            req.setBody(body);
            Http http = new Http();
            res = http.send(req);
            String bodyData = res.getBody();
            String response = bodyData.split('"access_token":"')[1].split('",')[0];
            accessToken = response;
        }Catch(Exception ex){
            return ex.getMessage();
        }
        return accessToken;
       }   
 }