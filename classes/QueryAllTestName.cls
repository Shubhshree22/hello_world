public class QueryAllTestName {
    public static void deleteTestExpense(){
        List<Expense__c> exp = new List<Expense__c>(
         [SELECT ID,Name
          from Expense__c
          where name='Test']);
        delete exp;
    }
}