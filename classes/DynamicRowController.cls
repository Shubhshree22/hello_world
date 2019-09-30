public with sharing class DynamicRowController {
   @AuraEnabled
    public static void saveContacts(List<Contact> ListContact){
        Insert ListContact;
    }
}