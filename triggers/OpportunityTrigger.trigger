trigger OpportunityTrigger on Opportunity (before insert ,before update,after insert , after update, after delete ,after undelete) {
   
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isundelete) {
         OpportunityTriggerHelper.stageShippedToCustomerInsertion(Trigger.newMap);
        }
    if(Trigger.isUpdate ) {
         OpportunityTriggerHelper.stageshippedToCustomersisUpdated( Trigger.newMap,Trigger.oldMap) ;
          // OpportunityHelperTrigger.stageRetrunToHeadQuarter(Trigger.newMap ,Trigger.oldMap);
          // OpportunityHelperTrigger.stageReturnToCustomer(Trigger.newMap ,Trigger.oldMap);
         }
    }
}
        /*if(Trigger.isDelete) {
        // OpportunityHelperTrigger.stageshippedToCustomersisDeleted(Trigger.newMap,Trigger.oldMap);
        }*/
    //}
      /* if(Trigger.isBefore){
           if(trigger.isUpdate || trigger.isInsert ){
              // OpportunityTriggerHelper.oppStage(trigger.new,trigger.oldMap);
              // OppStageName.opportunityStageName(trigger.new,trigger.oldMap);
               OpportunityStage.opportunityStageName(trigger.new,trigger.oldMap);
           }
        }*/