/**
* Purpose      :  It is a scheduler class used to schedule monthly and yearly expense to house owner through Email Alert.
*
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  09/06/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 09/06/2019- Created
* 
**/

global class Schedule_ExpenseToHouseOwner implements Schedulable  {
/**
* @description    :   This method is Used to Schedule the Batch Class.
*      
* @args           :   SchedulableContext
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 1/05/2019- Created
*     
**/
global void execute(SchedulableContext schedule) {
        // BatchBirthdayAlertPerson is a Batch class to whom we our calling in our method to Schedule.
        Batch_ExpenseToHouseOwner callingClass = new Batch_ExpenseToHouseOwner();
        //This execute method is called by the Scheduler and it is scheduling in Batch of 10 in a single Batch. 
        Database.executeBatch(callingClass,10);
    }
    
}