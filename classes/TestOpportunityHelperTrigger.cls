/**
* This class contains unit tests for validating the behavior of Apex classes
and triggers.

*Unit tests are class methods that verify whether a particular piece
of code is working properly. Unit test methods take no arguments,
commit no data to the database, and are flagged with the testMethod
keyword in the method definition.

* All test methods in an organization are executed whenever Apex code is deployed
to a production organization to confirm correctness, ensure code
coverage, and prevent regressions. All Apex classes are
required to have at least 75% code coverage in order to be deployed
to a production organization. In addition, all triggers must have some code coverage.

* The @isTest class annotation indicates this class only contains test methods. Classes defined with the @isTest annotation do not count against
the organization size limit for all Apex scripts.

* See the Apex Language Reference for more information about Testing and Code Coverage. 

*   Description 	:   	This class is used to test the opportunity
*
*   Created by      :   	Shubh Shree Rathore
*
*   Created Date    :   	02/07/2019
*
*   Revision Log    :  	    V_1.0 - Created
*
*	Coverage		: 	
**/
@isTest private class TestOpportunityHelperTrigger {

    @testSetUp static void insertData() {
        List<Opportunity> listOpp = new List<Opportunity>();
        List<Account> accounts = new List<Account>();
        
        for(Integer i=0;i<2;i++){
        Account acc = new Account();
        acc.Name='Test'+string.valueOf(i);
        accounts.add(acc);
        } 
          INSERT accounts;
        
        for(Integer i=0;i<2;i++){
            Opportunity opp = new Opportunity();
            opp.Name='TestOpp'+string.valueOf(i);
            opp.StageName ='Shipped To Customer';
            opp.CloseDate = system.today();
            opp.Installation_Account__c = accounts[0].id;
            opp.Automobile_Tag_Details1__c = '00:11:CE:01885';
            opp.Shipment_Account__c = accounts[1].id;
            listOpp.add(opp);
          }
         INSERT listOpp;
    }
    @isTest static void testOpp() {
          Test.startTest();
                    
        Test.stopTest();
    }   
}