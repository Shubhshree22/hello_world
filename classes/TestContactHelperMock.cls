@isTest
global class TestContactHelperMock implements HttpCalloutMock {
   
     global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'text');
        response.setBody('Ok');
        response.setStatusCode(200);
        response.setStatus('OK');
        return response; 
    }
}