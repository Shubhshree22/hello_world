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
/**
*   Description 	:   	This class is used to test the expense trigger.
*
*   Created by      :   	Shubh Shree Rathore
*
*   Created Date    :   	08/06/2019
*
*   Revision Log    :  	    V_1.0 - Created
*
*	Coverage		: 	
**/

@isTest
private class Test_ExpenseTrigger {
/* 
*	Description		:	This method delete the expense when expense items are associated with it. 
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/
    
 @isTest   static  void expenseWithExpenseItem() {
        //Inserting the expense 
        Expense__c exp = new  Expense__c(name='Test',Type__c='Monthly');
        insert exp;
        //Inserting the expense item.
        Expense_Item__c expItem = new Expense_Item__c(Expense__c =exp.Id,Date__c=date.today(),
                                                      Bill_Number__c='1009',Expense_Amount__c =0, Description__c ='test');
        insert expItem;
        //Perform test
        Test.startTest();
		//Deleting expense
        Database.DeleteResult result = Database.delete(exp,false);
        Test.stopTest();
        //In this we are checking that the expense is deleting or not.
        System.assert(!result.isSuccess());
        //According to trigger it should give the below error message.
        System.assertEquals('Expense Cannot be Deleted', result.getErrors()[0].getMessage()); 
        
    }
}