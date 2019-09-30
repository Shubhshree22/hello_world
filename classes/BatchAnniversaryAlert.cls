/**
* Purpose      :  It is a Batch class used to Send Anniversary Email Alert 
*
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  05/06/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 05/06/2019- Created
* 
**/
global class BatchAnniversaryAlert implements Database.Batchable <sObject> ,Database.Stateful {

    // List To store Email Address  
    global List<String> emailStore =  new List<String>();

/**
* @description    :   This method is used to Start the Batch 
*     
* @args           :  Database.BatchableContext
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 1/05/2019- Created
*     
**/ 
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        //returning a list of Person anniversary whose Email are not Blank
        return Database.getQueryLocator('SELECT ID,Next_Anniversary__c,Email__c FROM Person__c WHERE Email__c != NULL');
        
    }

/**
* @description    :   This method is used to Execute the Batch. In Execute method we will check the Person whose anniversary is Today
*     
* @args           :  Database.BatchableContext
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 1/05/2019- Created
*     
**/    
   
    global void execute(Database.BatchableContext bc, List<Person__c> recordsOfAnniversary ){
        
        //This returnTodaysDate will hold today's date 
        Date returnTodaysDate = system.today();
        
        //Loop To check whose anniversary is today
        For(Person__c anniversary : recordsOfAnniversary){
            if(anniversary.Next_Anniversary__c == returnTodaysDate ) {
                
                //Storing today's anniversary's Email in List.
                emailStore.add(anniversary.Email__c);
            }
        }
    }    
/**
* @description		:	This method is used to Finish the Batch.This will send Mail to every person whose email are in the list
*
* @args     		:  	Database.BatchableContext
*   
* @return      		:   void
*      
* @revision Logs 	:   V1.0 - Shubh Shree Rathore  - 1/05/2019- Created
*     
**/
    
    global void finish(Database.BatchableContext bc){
        //checking size of Email List
        if(emailStore.size()>0){
            //Sending Single Message to Everyone
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.toaddresses= emailStore;
            mail.Subject='Anniversary Wishes';
            mail.plaintextbody='Wish You a Very Happy Anniversary';
            Messaging.SingleEmailMessage[] msgs = new list <Messaging.SingleEmailMessage> {mail};
                Messaging.sendEmailResult[] sendingEmail = Messaging.sendEmail(msgs);
        }
    }    
}