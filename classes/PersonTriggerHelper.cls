/**
* Purpose      :  This class helps the trigger on Person object

* Created By   :  Shubh Shree Rathore
* 
* Created Date :  22/07/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore -  22/07/2019- Created
* 
**/
public class PersonTriggerHelper {
/**
* @description    :   This method is called by the trigger when send sms field is checked on person to send message through a future class using twilio api.
*     
* @args           :   List,Map 
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 22/07/2019- Created
*     
**/     
    
    public static void smsCheckboxCheck(List<Person__c> newListPersons ,Map<Id,Person__c> mapOldPersons){
        
        if(newListPersons.size() > 0) { 
            String mobileNum ;
            String  smsBody ;
            Id    idPerson ;
            
            for(Person__c person : newListPersons) {
                
                if((mapOldPersons == null &&  person.Send_SMS__c == true && person.Mobile__c != null) ||
                   (mapOldPersons != null && person.Send_SMS__c == true && (person.Send_SMS__c != mapOldPersons.get(person.Id).Send_SMS__c || 
                                                                            person.SMS_Body__c != mapOldPersons.get(person.Id).SMS_Body__c ||
                                                                            person.Mobile__c != mapOldPersons.get(person.Id).Mobile__c ))) {
                                                                                
                                                                                mobileNum = person.Mobile__c;
                                                                                smsBody = person.SMS_Body__c;
                                                                                idPerson = person.Id;
                                                                                system.debug('Person sms body :' +smsBody +'Mobile :'+mobileNum);
                                                                                PersonTriggerHelper.processSms(mobileNum,smsBody,idPerson);
                                                                            }
            }
        }
    }
    
/**
* @description    :   This method is called by the trigger helper  when send sms field is checked on person to send message through a future class using twilio api.
*     
* @args           :   String
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 22/07/2019- Created
*     
**/  
    @future(callout = true)
    public static void processSms(String mobileNum , String smsBody ,Id idPerson){
      
        String accountSid = 'AC7a1d8ac3974a3549e01e75cdb0c06a30';
        String token  = '862f7ab30fa7da65a6f478438bb47131'; 
        String fromPhNumber  = '+12562531285';
        Person__c persons = new Person__c();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+accountSid+'/SMS/Messages.json');
        req.setMethod('POST');
        
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf(accountSid+':' +token)));
        
        req.setBody('To='+EncodingUtil.urlEncode(mobileNum,'UTF-8')+'&From='+EncodingUtil.urlEncode(fromPhNumber,'UTF-8')+'&Body='+smsBody);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
         if(res.getStatusCode()==201) {
            String responseValue = res.getBody();
            list<String> returnedResponses = new List<String>();
            returnedResponses = responseValue.split(',');
            String storeResponse ='';
            String returned = '';
            for(String returnedResponse : returnedResponses) {
                returned = returnedResponse.replace('"','').replace('{','').replace('}','');
                storeResponse += returned +'\n';
            }
            persons.Id = idPerson;
            persons.Twilio_Response__c = storeResponse;
            persons.Send_SMS_Status__c = 'Send';
            update persons; 
            
        }
        
        else{
            String responseValue = res.getBody();
            list<String> returnedResponses = new List<String>();
            returnedResponses = responseValue.split(',');
            String storeResponse ='';
            String returned = '';
            for(String returnedResponse : returnedResponses) {
                returned = returnedResponse.replace('"','').replace('{','').replace('}','');
                storeResponse += returned +'\n';
            }
            persons.Id = idPerson;
            persons.Twilio_Response__c = storeResponse;
            persons.Send_SMS_Status__c = 'Error';
            update persons; 
            
        }
        
    }    
}