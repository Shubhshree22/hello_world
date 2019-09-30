@isTest
private class TestConHelper {
    
    @isTest static void testprocessSmsSlack() {
        
        Contact con = new Contact();
        con.LastName='Abc';
        con.Status__c='active';
        insert con;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestContactHelperMock()); 
        //system.assertEquals(expected, actual)
        Test.stopTest();
        Contact cons = [SELECT ID,Is_Notified__c from Contact Where  id=:con.Id];
        system.assertEquals(cons.id, con.id);
        // system.assertEquals(expected, actual)
        system.assertEquals('Abc',con.lastName);
        // cons.Is_Notified__c = con.Is_Notified__c;
        system.assertEquals(true, cons.Is_Notified__c);
    }
    
}