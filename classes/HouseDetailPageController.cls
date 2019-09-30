/**
* Purpose      :  It is a controller class used in lightning component.
* 
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  28/05/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 28/05/2019- Created
* 
**/

public class HouseDetailPageController {
/**
* @description    :	This method is used to fetch the data of member which is associated to a particular house.
*     
* @args           :	Id
*   
* @return         :	list of member object.
*      
* @revision Logs  :	V1.0 - Shubh Shree Rathore  - 28/06/2019- Created
*     
**/  

@AuraEnabled
    public static ResponeUtility getDoInit(String houseId) {
       ResponeUtility respone = new ResponeUtility();
        try{
             List<Member__c> member = [SELECT Id, name FROM Member__c WHERE House__c =: houseId]; 
             respone.setBody(member);
         }
       	    Catch(Exception ex) {
            respone.setError(ex.getMessage());
         }
       return respone;
    } 
    
/**
* @description    :	This method is used to fetch the data of expense whose type is yearly
*     
* @args           :	Id
*   
* @return         :	list of expense object
*      
* @revision Logs  :	V1.0 - Shubh Shree Rathore  - 28/06/2019- Created
*     
**/
    
    @AuraEnabled
    public static ResponeUtility getExpenseYearly(Id memId) {
         ResponeUtility respone = new ResponeUtility();
        try {
            List<Expense__c> yearlyExpense = [SELECT Id, Name,Total_Expense__c FROM Expense__c WHERE Member__c =: memId AND Type__c ='Yearly'];  
            respone.setBody(yearlyExpense);
         }
       	    Catch(Exception ex) {
            respone.setError(ex.getMessage());
         }
       return respone;
    }
    
/**
* @description    :	This method is used to fetch the data of expense whose type is monthly.
*     
* @args           :	Id
*   
* @return         :	list of expense object
*      
* @revision Logs  :	V1.0 - Shubh Shree Rathore  - 28/06/2019- Created
*     
**/
    
     @AuraEnabled
    public static ResponeUtility getExpenseMonthly(Id yearExp) {
        ResponeUtility respone = new ResponeUtility();
       try {
        	List<Expense__c>   monthlyExpense= [SELECT Id, Name FROM Expense__c WHERE Yearly_Expense__c =: yearExp AND Type__c ='Monthly']; 
            respone.setBody(monthlyExpense);
        }
       	    Catch(Exception ex) {
            respone.setError(ex.getMessage());
        }
       return respone;
    }         
    
/**
* @description    :	This method is used to fetch the data of expense item 
*     
* @args           :	Id
*   
* @return         :	list of expense item object
*      
* @revision Logs  :	V1.0 - Shubh Shree Rathore  - 30/06/2019- Created
*     
**/
     @AuraEnabled
    public static ResponeUtility getExpenseItem(Id expId) {
        ResponeUtility respone = new ResponeUtility();
       try {
        	List<Expense_Item__c>   expenseItems = [SELECT Id, Name,Date__c,Expense_Type__c,Description__c,Expense_Amount__c,Expense__c,
                                                    Bill_Number__c,Approval_Status__c FROM Expense_Item__c  WHERE Expense__c =: expId];  
            respone.setBody(expenseItems);
         }
       	    Catch(Exception ex) {
            respone.setError(ex.getMessage());
         }
       return respone;
  
   } 
}