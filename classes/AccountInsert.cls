/**
* Purpose      :  It is a controller class used in visualforce Page.
* 
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  19/07/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 19/07/2019- Created
* 
**/
public with sharing class AccountInsert{
    
    public account acc { get; set; }
    public List<Account> insertedAccount{get;set;}
    
    public AccountInsert(){
        acc =new Account();
        insertedAccount = [Select Id, name,Industry from Account ORDER BY CreatedDate DESC LIMIT 3];
        
    }     
    public void save(){
        
        upsert acc;
        insertedAccount=[Select Id, name,Industry from Account ORDER BY CreatedDate DESC LIMIT 3];
        
    }
}