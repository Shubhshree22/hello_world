/**
* Purpose      :  To Help Trigger which is on Expense Item.
* 
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  30/05/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 30/05/2019- Created
* 
**/
public class ExpenseItemHelper {
/**
* @description    :   This method is used to Check Unique Bill Number On Expense Item when Inserted and Updated
*     
* @args           :   List , Map
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 30/05/2019- Created
*     
**/     
    public static void billNoUnique(List<Expense_Item__c> newExpensesItem, Map<Id,Expense_Item__c> oldExpensesItem) {
        
       //map of ExpId With BillNo 
       Map <Id, Set<String>> mapOfExpIdWithBillNo = new Map <Id, Set<String>>(); 
       
        for(Expense_Item__c expItem : newExpensesItem) {
             
            if(expItem.Bill_Number__c != NULL && (oldExpensesItem == NULL || 
                      (oldExpensesItem != NULL && oldExpensesItem.get(expItem.Id).Bill_Number__c != expItem.Bill_Number__c))) {
                           
                if(!mapOfExpIdWithBillNo.containsKey(expItem.Expense__c))
                    mapOfExpIdWithBillNo.put(expItem.Expense__c , new Set<String>());
                	if(!mapOfExpIdWithBillNo.get(expItem.Expense__c).contains(expItem.Bill_Number__c))
                    mapOfExpIdWithBillNo.get(expItem.Expense__c).add(expItem.Bill_Number__c);
                else
                    expItem.addError('Bill Number Cannot be Duplicate');
            }
        }
      
        if(mapOfExpIdWithBillNo.size() > 0) {
            List<Expense_item__c> recordsAlreadyExist = new List<Expense_item__c>([SELECT Bill_Number__c, Expense__c FROM Expense_Item__c 
                                                                                   WHERE Expense__c IN :mapOfExpIdWithBillNo.keySet()]);
            if(recordsAlreadyExist.size() > 0) {
                for(Expense_item__c newItem : recordsAlreadyExist ) {
                    if(!mapOfExpIdWithBillNo.get(newItem.Expense__c).contains(newItem.Bill_Number__c))
                        mapOfExpIdWithBillNo.get(newItem.Expense__c).add(newItem.Bill_Number__c);
                    else
                        newExpensesItem[0].addError('Bill Number already Exists');
                }
            }
        }
    }
      /**
* @description    :   This method is used to Roll up the sum of Expense Item On Expense 
*     
* @args           :   List , Map
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 31/05/2019- Created
*     
**/ 
    public static void rollUpExpenseItemToExpense(List<Expense_Item__c> newExpenseItem , Map<Id,Expense_Item__c> oldExpenseItemMap){
        
        // To Hold Ids  
        Map<Id,Expense__c> mapOfExpense =  new Map<Id,Expense__c>();
        // Using Ternory Operator to check The new Expenses Null Or Not   
        for(Expense_Item__c expItem : newExpenseItem != null ? newExpenseItem : oldExpenseItemMap.values()) {
            
            //In Insert Case
            if(oldExpenseItemMap== NULL && expItem.Approval_Status__c =='Approve' && expItem.Expense_Amount__c > 0 && expItem.Expense__c != Null){
                
                //Adding Ids Of Expense in Map
                mapOfExpense.put(expItem.Expense__c,new Expense__c(ID=expItem.Expense__c,Total_Expense__c = 0));
            }
            //In Update case
            else if(newExpenseItem != NULL && oldExpenseItemMap != NULL &&
                    (expItem.Approval_Status__c != oldExpenseItemMap.get(expItem.Id).Approval_Status__c 
                     ||expItem.Expense_Amount__c != oldExpenseItemMap.get(expItem.Id).Expense_Amount__c
                     ||expItem.Expense__c != oldExpenseItemMap.get(expItem.Id).Expense__c)) {
                         
                         //Adding Ids Of Expense in Map
                         mapOfExpense.put(expItem.Expense__c,new Expense__c(ID=expItem.Expense__c,Total_Expense__c = 0));
                     }
            //Delete case
            else   if(oldExpenseItemMap != NULL && newExpenseItem == NULL && oldExpenseItemMap.get(expItem.Id).Expense__c != NULL){
                
                //Adding Expense IDs in Map
                mapOfExpense.put(expItem.Expense__c,new Expense__c(ID = expItem.Expense__c,Total_Expense__c = 0));
            }
        }
        //checking size od set Expense Ids
        if(mapOfExpense.size() > 0) {
            
            //Aggregate  Query on Expense Amount
            List<AggregateResult> results = [Select SUM (Expense_Amount__c) totalExpAmount ,Expense__c FROM Expense_Item__c 
                                                        WHERE Expense__c IN :mapOfExpense.keySet() AND
                                                        Approval_Status__c ='Approve' 
                                                        GROUP BY Expense__c]; 
            
            System.debug('----------' +results.size());
            
            //When There is some records coming In results
            if(results.size()>0) {
                // using For Loop to put Values 
                for (AggregateResult result : results){
                    // Values putting according to the Id In Expense.
                    mapOfExpense.get((ID)result.get('Expense__c')).Total_Expense__c =(Double)result.get('totalExpAmount');
                } 
            }
            system.debug('@@mapOfExpense'+mapOfExpense.keySet() + ''+ mapOfExpense.values());
                 // Updating Map Values  
                update mapOfExpense.values();
        }
    }
    
}