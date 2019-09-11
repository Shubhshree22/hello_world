trigger AccountTrigger on Account (before insert,before update) {
  
    if(trigger.isBefore) {
        //AccountHelper.accountFields(trigger.new,trigger.oldMap);
       if(trigger.isInsert || trigger.isUpdate )
        AccountTriggerHelper.autoPopulateLongestAndShortestSeries(trigger.new,trigger.oldMap);
    }
}