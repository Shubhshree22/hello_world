/**
*   Description 	:   	This class is used for error handling in the controller class used in lightning component.
*
*   Created by      :   	Shubh Shree Rathore
*
*   Created Date    :   	02/07/2019
*
*   Revision Log    :  	    V_1.0 - Created
*
*	Coverage		: 	
**/
public class ResponseUtility {
    
    @AuraEnabled
    public String status;
    @AuraEnabled
    public Boolean isSuccess;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public Object body;
    
    
    public ResponseUtility() {
        status = 'success';
        isSuccess = true;
    }
    
/* 
*	Description		:	This method used  for error
*
*	@argument		:	String
*
*	Revision Logs	: 	V_1.0 - Created
*/    
    
    public void setError(String msg) {
        status = 'error';
        message = msg;
        isSuccess = false;
    }
    
/* 
*	Description		:	This method used for warning.
*
*	@argument		:	String
*
*	Revision Logs	: 	V_1.0 - Created
*/   
    
    public void setMessage(String msg) {
        status = 'warning';
        message = msg;
        isSuccess = false;
    }
    
/* 
*	Description		:	This method used for body.
*
*	@argument		:	Object
*
*	Revision Logs	: 	V_1.0 - Created
*/   
    
    public void setBody(Object bdy) {
        body = bdy;
        system.debug('body-->'+body);
        status = 'success';
        isSuccess = true;
    }
}