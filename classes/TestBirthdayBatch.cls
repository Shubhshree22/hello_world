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

*   Description 	:   	This class is used to test the batch classes.
*
*   Created by      :   	Shubh Shree Rathore
*
*   Created Date    :   	02/07/2019
*
*   Revision Log    :  	    V_1.0 - Created
*
*	Coverage		: 	
**/
@isTest private class TestBirthdayBatch {
/* 
*	Description		:	This method used insert the data.
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/  
    @testSetUp public static void insertdata() {
         Person__c per = new Person__c();
 			per.Name='ABC';
        	per.Birthday__c = system.today();
        	per.Anniversary__c= system.today();
        	per.Email__c = 'abc@gmail.com';
        	INSERT per;
        }
  /* 
*	Description		:	This method used test the birthday batch class.
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/    
    @isTest public static void testBatchBirthday() {
        Test.startTest();
        List<Person__c> records = [SELECT ID,Birthday__c,Anniversary__c,Email__c FROM Person__c WHERE Email__c != NULL];
        BatchBirthdayAlert bday = new BatchBirthdayAlert();
        database.executeBatch(bday);
        Test.stopTest();
    }
/* 
*	Description		:	This method used test the Anniversary batch class.
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/    
    @isTest public static void testBatchAnniversary() {
        Test.startTest();
        List<Person__c> records = [SELECT ID,Anniversary__c,Email__c FROM Person__c WHERE Email__c != NULL];
        BatchAnniversaryAlert ann = new BatchAnniversaryAlert();
         database.executeBatch(ann);
        Test.stopTest();
       }
    }