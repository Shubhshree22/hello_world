/**
* Purpose      :  To show all Objects. 
* Created By   :  Shubh Shree Rathore
* Created Date :  23/09/2019
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 23/09/2019- Created
**/
public class AllObject {
 /**
* @description    :   This method is used to get all objects .
* @args           :   -  
* @return         :   ResponseUtility     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 23/09/2019- Created
*     
**/   
    @AuraEnabled
    public static ResponseUtility controllerGetAllObject(){
        ResponseUtility response = new ResponseUtility();
        try{
            AllObjectWrapper accObj = new AllObjectWrapper();
            List<OptionWrapper> opt = new List<OptionWrapper>();
            Map<String, Schema.SobjectType> gd = schema.getGlobalDescribe();
            for(Schema.SObjectType obj : gd.values()){
                Schema.DescribeSObjectResult dr = obj.getDescribe();
                opt.add(new OptionWrapper (String.valueOf(dr.getLabel()) , String.valueOf(dr.getName())));
            }
            accObj.options = opt;
            response.setBody(accObj);
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return response;
    }
    
     /**
* @description    :   This method is used to get all fields of account .
* @args           :   -  
* @return         :   ResponseUtility     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 23/09/2019- Created
*     
**/
    @AuraEnabled
    public static ResponseUtility fetchAccountFields(){
        ResponseUtility response = new ResponseUtility();
        try{
            AllObjectWrapper accObj = new AllObjectWrapper();
            List<OptionWrapper> opt = new List<OptionWrapper>();
            Map<String, Schema.SobjectType> gd = schema.getGlobalDescribe();
            Map<String, schema.SObjectField> MapOfFields = gd.get('Account').getDescribe().fields.getMap();
            for(Schema.SObjectField field : MapOfFields.values()){
                Schema.DescribeFieldResult fr = field.getDescribe();
                opt.add( new OptionWrapper(String.valueof(fr.getLabel()) ,String.valueof(fr.getName())));
            } 
            accObj.options = opt;
            response.setBody(accObj);
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return response;
    } 
    
/**
* @description    :   This method is used to get all fields of contact.
* @args           :   -  
* @return         :   ResponseUtility     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 23/09/2019- Created
*     
**/
    @AuraEnabled
    public static ResponseUtility fetchContactFields(){
        ResponseUtility response = new ResponseUtility();
        try{
            AllObjectWrapper accObj = new AllObjectWrapper();
            List<OptionWrapper> opt = new List<OptionWrapper>();
            Map<String, Schema.SobjectType> gd = schema.getGlobalDescribe();
            Map<String, schema.SObjectField> MapOfFields = gd.get('Contact').getDescribe().fields.getMap();
            for(Schema.SObjectField field : MapOfFields.values()){
                Schema.DescribeFieldResult fr = field.getDescribe();
                opt.add( new OptionWrapper(String.valueof(fr.getLabel()),String.valueof(fr.getName())));
            } 
            accObj.options = opt;
            response.setBody(accObj);
            
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return response;
    }
/**
* @description    :   This method is used to get all account record .
* @args           :   -  
* @return         :   ResponseUtility     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 23/09/2019- Created
*     
**/
    @AuraEnabled
    public static ResponseUtility getAccountRec(){
        ResponseUtility response = new ResponseUtility();
        try{
            AllObjectWrapper accObj = new AllObjectWrapper();
            List<OptionWrapper> opt = new List<OptionWrapper>();
            accObj.accRec = [select id,name,Phone from Account];
            
            for(Account acc : accObj.accRec) {
                opt.add( new OptionWrapper(acc.Name,acc.Id));
            }
            accObj.options = opt;
            response.setBody(accObj);
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return response;
    }
 /**
* @description    :   This method is used to get contact records .
* @args           :   -  
* @return         :   ResponseUtility     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 23/09/2019- Created
*     
**/    
    @AuraEnabled
    public static ResponseUtility getContactRec(){
        ResponseUtility response = new ResponseUtility();
        try{
            AllObjectWrapper accObj = new AllObjectWrapper();
            List<OptionWrapper> opt = new List<OptionWrapper>();
            List<Contact> contacts = [select id,firstName,LastName from Contact];
            for(Contact con :contacts) {
                opt.add( new OptionWrapper(con.LastName,con.Id));
            }
            accObj.options = opt;
            response.setBody(accObj);
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return response;
    }
    
    public class AllObjectWrapper {
        @AuraEnabled public list<OptionWrapper> options {get;set;}
        @AuraEnabled public list<Account> accRec {get;set;}
        
    }
    public class OptionWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        
        public OptionWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}