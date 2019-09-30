@isTest
global class TestsendSmsWithTwilioSuccessMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"sid":"SMbcd760ab2a3f438ba52df4a9243b71cc","date_created": "Mon, 22 Jul 2019 13:32:13 +0000" "date_updated": "Mon, 22 Jul 2019 13:32:13 +0000","date_sent": null, "account_sid": "AC7a1d8ac3974a3549e01e75cdb0c06a30", "to": "+919001811457", "from": "+12562531285", "body": "Sent from your Twilio trial account - test", "status": "queued", "direction": "outbound-api", "api_version": "2010-04-01", "price": null, "price_unit": "USD", "uri": "/2010-04-01/Accounts/AC7a1d8ac3974a3549e01e75cdb0c06a30/SMS/Messages/SMbcd760ab2a3f438ba52df4a9243b71cc.json", "num_segments": "1"}');
        response.setStatusCode(201);
        response.setStatus('created');
        return response; 
    }
    
}