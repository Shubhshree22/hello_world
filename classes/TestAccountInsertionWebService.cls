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

*   Description 	:   	This class is used to test the Account Insertion Web Service class which is used in soap api.
*
*   Created by      :   	Shubh Shree Rathore
*
*   Created Date    :   	25/07/2019
*
*   Revision Log    :  	    V_1.0 - Created
*
*	Coverage		: 	    100%
**/
@isTest
private class TestAccountInsertionWebService {
/* 
*	Description		:	This method used to check the web service.
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/
    @testSetUp public static void insertAccdata() {
        Account acc = new Account();
        acc.Name = 'abcdef';
        acc.AccountNumber='AJS852698855UY';
        acc.Phone = '+91905811457';
        insert acc;
    }
    @isTest public static void testmakeAccount(){
        Test.startTest();
        AccountInsertionWebService.makeAccount('AJS852698855UY','+91905811457');
        
        AccountInsertionWebService.makeAccount('DFSG132633DK','+91747845679');
        Test.stopTest();
   
    }   
}