@isTest
private class TestHttpResponseContInsertOnButtonClick {
    
    @TestSetUp static void testSetupMethod() {
        Account insAcc = new Account();
        insAcc.Name = 'Test Account Rec';
        insert insAcc;
        Contact testContact = new Contact();
        testContact.LastName='Test Contact record';
        testContact.AccountId = insAcc.Id;
        insert testContact;  
        
        Test.setMock(HttpCalloutMock.class, new TestHttpRequestMock()); 
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(testContact.Id));
     	HttpResponseContInsertOnButtonClick testConPlan = new HttpResponseContInsertOnButtonClick(sc);
       //PageReference result = testConPlan.autoRun();
    }
    @isTest static void testMethod1() {
        //HttpResponseContInsertOnButtonClick.HttpResponseContInsertOnButtonClick(testContact);
       		 HttpResponseContInsertOnButtonClick.callout();
      }
}