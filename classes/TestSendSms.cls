@isTest
public class TestSendSms {

   @isTest static void testprocessSmsSuccess() {
        Test.startTest();
        Person__c per = new Person__c();
        per.Name='Abc';
        per.Birthday__c= System.today();
        per.Mobile__c ='+919001811457';
        per.Send_SMS__c =true;
        per.SMS_Body__c ='test';
        insert per;
        Test.setMock(HttpCalloutMock.class, new TestsendSmsWithTwilioSuccess()); 
         Test.stopTest();
       Person__c persons = [SELECT ID, Send_SMS_Status__c,Twilio_Response__c From Person__c Where  id =:per.Id];
       system.assertEquals('Send',persons.Send_SMS_Status__c);
        //system.assertEquals(,persons.Twilio_Response__c);
    }
    @isTest static void testprocessSmsFailure() {
        Test.startTest();
        Person__c per = new Person__c();
        per.Name='Abcd';
        per.Mobile__c ='+91900181147';
        per.Birthday__c= System.today();
        per.Send_SMS__c =true;
        per.SMS_Body__c ='test';
        insert per;
        Test.setMock(HttpCalloutMock.class, new TestsendSmsWithTwilioFailure()); 
        Test.stopTest();
         Person__c persons = [SELECT ID, Send_SMS_Status__c,Twilio_Response__c From Person__c Where  id =:per.Id];
       system.assertEquals('Error',persons.Send_SMS_Status__c);
    }
}