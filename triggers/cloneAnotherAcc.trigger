/*trigger AccountTrigger on Account (before insert,before update) {
  
    if(trigger.isBefore) {
        //AccountHelper.accountFields(trigger.new,trigger.oldMap);
       if(trigger.isInsert || trigger.isUpdate )
        AccountTriggerHelper.autoPopulateLongestAndShortestSeries(trigger.new,trigger.oldMap);
    }
}*/

trigger cloneAnotherAcc on Account (before insert) {
   Account acc = new Account(name='Clone me',Website='www.google.com');
   insert acc;
}