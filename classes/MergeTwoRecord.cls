public class MergeTwoRecord {
    public static void mergingTwoRecordsInOne() {
        list<Member__c> mem1 = new list<Member__c>([SELECT ID, Name from Member__c where name ='Test' LIMIT 1]);
        list<Member__c> mem2 = new list<Member__c>([SELECT ID, Name from Member__c where name ='Member2' LIMIT 1]);
        for(Member__c mem : mem2){
            mem.id = mem1[0].id;
            insert mem;
            System.debug(mem);
        }    
        try {
            //merge mem2 mem1;
        }
        catch(DMLexception e){
          //excepetion here
       }
    }}