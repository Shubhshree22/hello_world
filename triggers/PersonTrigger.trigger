/**
* Purpose      :  This Trigger is On Person Object

* Created By   :  Shubh Shree Rathore
* 
* Created Date :  22/07/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore -  22/07/2019- Created
* 
**/
trigger PersonTrigger on Person__c (after insert,after update) {
    
    if(trigger.isAfter) {
        if(trigger.isInsert || trigger.isUpdate) {
            PersonTriggerHelper.smsCheckboxCheck(trigger.new,trigger.oldMap);
        }
    }

}