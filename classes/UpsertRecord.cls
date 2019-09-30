public class UpsertRecord {    
    public static void upsertingRecords(){
        List<Expense__c> exp= new list<Expense__c>([SELECT Id, Name FROM Expense__c WHERE name like 'test%']);
        for (Expense__c expense : exp) {
            expense.name = 'Test To New';
            System.debug(expense.Name);
        }
        
        try {
            upsert exp;
        } catch (DmlException e) {
            // Process exception here
        }
    }}