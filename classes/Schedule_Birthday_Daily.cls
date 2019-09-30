/**
* Purpose      :  It is a Scheduler class used to Schedule Birthday Email Alert.
*
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  05/06/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 05/06/2019- Created
* 
**/
global class Schedule_Birthday_Daily implements Schedulable  {
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
        BatchBirthdayAlert callingClass = new BatchBirthdayAlert();
        //This execute method is called by the Scheduler and it is scheduling in Batch of 10 in a single Batch. 
        Database.executeBatch(callingClass,10);
    }
    
}