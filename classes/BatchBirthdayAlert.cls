/**
* Purpose      :  It is a Batch class used to Send Birthday Email Alert 
*
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  05/06/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 05/06/2019- Created
* 
**/
        global class BatchBirthdayAlert  implements Database.Batchable <sObject> ,Database.Stateful{ 
           // List To store Email Address  
        global List<String> emailStore =  new List<String>();
/**
* @description    :   This method is used to Execute the Batch +
*     
* @args           :   Database.BatchableContext
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 1/05/2019- Created
*     
**/
    global Database.QueryLocator start(Database.BatchableContext bc) {
    //returning a list of Person Birthday whose Email are not Blank
    return Database.getQueryLocator('SELECT ID,Next_Birthday__c,Email__c FROM Person__c WHERE Email__c != NULL');
}
/**
* @description    :   This method is used to Execute the Batch 
*     
* @args           :   Database.BatchableContext
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 1/05/2019- Created
*     
**/  
    global void execute(Database.BatchableContext bc, List<Person__c> recordsOfBirthday ){
    //This returnTodaysDate will hold today's date 
    Date returnTodaysDate = system.today();
    //Loop To check whose birthday is today
    For(Person__c birthday : recordsOfBirthday){
        if(birthday.Next_Birthday__c == returnTodaysDate ) {
            //storing Today's birthday's Email in List.
            emailStore.add(birthday.Email__c);
        }
    }
    //   Messaging.SingleEmailMessage(emailStore);
}   
/**
* @description    :   This method is used to Finish the Batch.This will send Mail To every person whose email are in the list
*     
* @args           :   Database.BatchableContext
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 1/05/2019- Created
*     
**/  

   global void finish(Database.BatchableContext bc){
    //checking size of Email List  
    if(emailStore.size()>0){
        //Sending Single Message to Everyone
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.toaddresses= emailStore;
        mail.Subject='Birthday Wishes';
        mail.plaintextbody='Wish You a Very Happy Birthday';
        Messaging.SingleEmailMessage[] msgs = new list <Messaging.SingleEmailMessage> {mail};
            Messaging.sendEmailResult[] sendingEmail = Messaging.sendEmail(msgs);
    } 
  }    
}