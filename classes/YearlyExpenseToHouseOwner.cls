global class YearlyExpenseToHouseOwner implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){
          return Database.getQueryLocator('SELECT ID,House_Owner__c.person__r.Email__c,	This_Year_Expense__c from Person__c Where Email__c != Null');
      } 
    global void execute(Database.BatchableContext bc, List<Person__c> recOfPerson) {
        
    }
    global void finish(Database.BatchableContext bc) {
        
    }
}