/**
* Purpose      :  This Trigger is On Expense Object

* Created By   :  Shubh Shree Rathore
* 
* Created Date :  31/05/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 31/05/2019- Created
* 
**/
trigger ExpenseTrigger on Expense__c ( before delete, after insert, after update, after delete ) {
    
    if (Trigger.isBefore) {
        //Calling Event
        if(Trigger.isDelete)
            // calling HelperCLass.StaticMethod
            ExpenseHelper.expensNotDeleted(Trigger.old);
    }
    if (Trigger.isAfter){
        //Calling Event
        if(Trigger.isInsert ||Trigger.isUndelete||Trigger.isUpdate|| Trigger.isDelete) {
            ExpenseHelper.rollUpExpenseToYearlyExpense(Trigger.new,Trigger.oldMap);
           
        }
    } 
}