public class UpdateRecordType {
    public static void changeRecordType(){
        List<Member__c> exp = new List<Member__c>([SELECT ID,Name,RecordTypeID from Member__c where name='Test'AND RecordType.DeveloperName='Permanent']);
        system.debug(exp);
        List<Member__c> expTemp = new List<Member__c>([SELECT ID,RecordTypeID from Member__c where RecordType.DeveloperName='Temporary']);
        for(Member__c swapRectype :exp){
            swapRectype.RecordTypeId = expTemp[0].ID;
        }
    }
}