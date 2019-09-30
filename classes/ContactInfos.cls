public class ContactInfos {
    
 @AuraEnabled
    public static Contact  insertContact(Contact con , Id accId)   {
        String msg ; 
        Contact contacts = new Contact();
        try {
            contacts.AccountId = accId;
            contacts.FirstName= con.FirstName;
            contacts.LastName = con.LastName;
            contacts.Email= con.Email;
            contacts.Phone = con.Phone;
             insert contacts;
           	  } 
        catch(Exception ex) {
            system.debug(ex.getMessage());
            msg = ex.getMessage();
        }
        return contacts;
    }
}