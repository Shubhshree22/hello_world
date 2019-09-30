@isTest
global class TestHttpRequestMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
       //  System.assertEquals('https://login.salesforce.com/services/oauth2/token', request.getEndpoint());
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
       	response.setBody('["https://ap15.salesforce.com/0032v00002pAZSdAAO","https://ap15.salesforce.com/0012v00002QE7OeAAL"]');
       	response.setStatusCode(200);
        response.setStatus('ok');
        return response; 
    }   
}