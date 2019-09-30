/**
* Purpose      :  This Trigger is On Expense Item Object

* Created By   :  Shubh Shree Rathore
* 
* Created Date :  31/05/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 31/05/2019- Created
* 
**/
trigger ExpenseItemTrigger on Expense_Item__c (before insert ,before Update,after insert, after delete ,after update,after undelete) {
    //When Trigger is running at before event 
    if(Trigger.isbefore ){
        //When Trigger is running at Insert or Update Operation
        if(Trigger.isInsert||Trigger.isUpdate){
            //calling HelperCLass.StaticMethod
            ExpenseItemHelper.billNoUnique(Trigger.new ,Trigger.oldMap);
        }
    }
     //When Trigger is running at after event  
    if(Trigger.isAfter){
          //When Trigger is running at Insert or Update Operation
        if(Trigger.isInsert||Trigger.isUpdate||Trigger.isUndelete||Trigger.isdelete ){
            //calling HelperCLass.StaticMethod
         ExpenseItemHelper.rollUpExpenseItemToExpense(Trigger.new,Trigger.oldMap);
        }
    }
}