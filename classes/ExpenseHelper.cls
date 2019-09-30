/**
* Purpose      :  To Help Trigger on Expense Object
* 
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  30/05/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 30/05/2019- Created
* 
**/

public class ExpenseHelper {
    /**
* @description    :   This method is used to Check Expense not Deleted when Expense Item is in the list.
*     
* @args           :   List
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 30/05/2019- Created
*     
**/     
    
    public static void expensNotDeleted(List<Expense__c> oldExpense){      
        //For Storing Account Ids
        Set<id> expIdSet = new Set<id>();
        for(Expense__c expens :OldExpense ) {
            //Adding Expense Ids
            expIdSet.add(expens.id);
        }
        // Map for fetching Expense Records  according to expIdSet
        Map<Id, Expense__c> expnseHavingExpenseItem = new Map<Id, Expense__c>([SELECT Id,(SELECT ID FROM Expense_Items__r )
                                                                             FROM Expense__c WHERE ID IN: expIdSet ]);
        For(Expense__c exp : oldExpense) {
            // checking expense contains more than 0 expense items
            if(expnseHavingExpenseItem.get(exp.Id).Expense_Items__r.size() > 0){
                exp.addError('Expense Cannot be Deleted');
            }
        }
    }
    
/**
* @description    :   This method is used to Roll up the sum Monthly Expense on Expense whose Type is Yearly
*     
* @args           :   List , Map
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 1/05/2019- Created
*     
**/ 
    public static void rollUpExpenseToYearlyExpense(List<Expense__c> newExpenses, Map<Id,Expense__c> oldExpenses) {
        
        // Set to store Expense 
        Set<String> setId = new Set<String>();  
        
        //using Ternary operator
        for(Expense__c exp : newExpenses != null ? newExpenses : oldExpenses.values()) { 
            
            // In Case of Insert
            if(oldExpenses == Null && exp.Type__c == 'Monthly' && exp.Yearly_Expense__c != Null && exp.Approval_Status__c == 'Approve') {
                
                //Adding Expense's Yearly Expense in Set
                setId.add(exp.Yearly_Expense__c);
            }
            // In Case Of Update
            else if(oldExpenses != NULL && newExpenses != null && exp.Type__c == 'Monthly' && exp.Yearly_Expense__c != Null &&
                    (exp.Yearly_Expense__c != oldExpenses.get(exp.Id).Yearly_Expense__c  
                     || exp.Approval_Status__c != oldExpenses.get(exp.Id).Approval_Status__c
                     ||exp.Total_Expense__c != oldExpenses.get(exp.Id).Total_Expense__c 
                    )) {
                        //Adding Expense's Yearly Expense in Set
                        setId.add(exp.Yearly_Expense__c);                      
                     }
            // In Case of Delete
            else if(oldExpenses != NuLL && newExpenses == NULL && exp.Yearly_Expense__c != null ) {
                
                //Adding All the Yearly expense in set
                setId.add(exp.Yearly_Expense__c);
            }
        }
        //Checking size of Set
        if(setId.size() > 0) {
            
            // Doing Aggregate Query on Total_Expense  grouping with Yearly Expense 
            List<AggregateResult> total = [SELECT Yearly_Expense__c , SUM(Total_Expense__c) totExp FROM Expense__c 
                                           WHERE Yearly_Expense__c in : setId AND Type__c ='Monthly' AND Approval_Status__c ='Approve'
                                           GROUP BY Yearly_Expense__c ]; 
            
            system.debug('+++++' +total +'----------------');
            
            //Taking Map to Update the field according to a particular Id
            Map<ID,Expense__c> mapOfExpenses = new Map<ID,Expense__c>();
            
            for (AggregateResult totalExp : total){
                
                //puting Values in Total Expense  corresponding to Yearly Expense
                mapOfExpenses.put((Id)totalExp.get('Yearly_Expense__c'), new Expense__c(Id = (Id)totalExp.get('Yearly_Expense__c'), Total_Expense__c = (Double)totalExp.get('totExp')));
            }
            
            //checking Size of Map
            if(mapOfExpenses.size() > 0) {
                //Updating the Expense
                update mapOfExpenses.values();
            }
        }   
    }

}