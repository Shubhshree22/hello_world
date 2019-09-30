/**
*   Description 	:   	This class is used to test the expense item trigger.
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
private class Test_ExpenseItemTrigger {
/* 
*	Description		:	This method delete the expense when expense items are associated with it. 
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/
    
 @isTest  static  void testbillNoUnique() {
     
        //Inserting the expense 
        Expense__c exp = new  Expense__c(name='Test',Type__c='Monthly');
        insert exp;
        Expense__c exp1 = new  Expense__c(name='Test',Type__c='Monthly');
     	insert exp1;
     
        //Inserting the multiple expense item on that expense with samr bill number .
         List<Expense_Item__c> expenseItem = new List<Expense_Item__c>();
       	 Expense_Item__c expItem;
     
         expItem = new Expense_Item__c(Expense__c =exp.Id,Date__c=date.today(),
                                                      Bill_Number__c='1009',Expense_Amount__c =0, Description__c ='test');
     	 expItem = new Expense_Item__c(Expense__c =exp.Id,Date__c=date.today(),
                                                      Bill_Number__c='1009',Expense_Amount__c =0, Description__c ='test');
     
         expItem = new Expense_Item__c(Expense__c =exp1.Id,Date__c=date.today(),
                                                      Bill_Number__c='1009',Expense_Amount__c =0, Description__c ='test');
          
     	expenseItem.add(expItem);
        insert expenseItem;
     
        //Perform test
     
        Test.startTest();
        try {
            system.debug('expense'+expenseItem);
        } catch (Exception ex) {
              //According to trigger it should give the below error message.
			System.assertNotEquals(true, ex.getMessage().contains('Bill Number Cannot be Duplicate')); 
        }
        Test.stopTest();
       
    }
}