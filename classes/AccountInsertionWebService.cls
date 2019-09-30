/**
* Purpose      :  This class is used  for Soap api web service.

* Created By   :  Shubh Shree Rathore
* 
* Created Date :  25/07/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore -  25/07/2019- Created
* 
**/
global class AccountInsertionWebService {
    /* 
*	Description		:	This method used to make the account.
*
*	@argument		:	String , String
*
*	Revision Logs	: 	V_1.0 - Created
*/    
    
    webservice static String makeAccount(String accNumber,String mobileNum) {
        //Fetch the account having mobile and account number.
        String response ='';
        try {     
            if(String.isBlank(accNumber) || String.isBlank(mobileNum))
                throw new CustomException('Arguments cannot be blank');
            
            List<Account> accounts = [SELECT ID,Name, Phone, AccountNumber FROM Account WHERE Phone =:mobileNum AND AccountNumber =:accNumber];
            List<Task> tasks = new List<Task>();
            
            if(accounts.size()== 0) {
                Account account = new Account();
                //Generating 5 digit random number.
                String randomNumber = String.valueOf(Math.random()).right(5);
                //Account name is a combination of account number and random number
                account.Name = accNumber +'-'+randomNumber;
                account.AccountNumber = accNumber;
                account.Phone = mobileNum;
                insert account;
                accounts.add(account);
            }
            // when there is a account and we have to insert task.
            Task task = new Task();
            task.WhatId = accounts[0].Id;
            task.Subject ='Testing Task' +accounts[0].Name;
            tasks.add(task);
            insert tasks;
            response = 'Successfully Inserted.';
        }Catch(CustomException ex){
            response = ex.getMessage();
            
        }Catch(Exception ex) {
            response = ex.getMessage();
        }
        return response;
    }        
}