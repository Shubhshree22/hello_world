/**
* Purpose      :  To update multiple records in a single click. 
* Created By   :  Shubh Shree Rathore
* Created Date :  16/09/2019
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 16/09/2019- Created
**/
public class MassUpdateController {
   /**
* @description    :   This method is used to get the object name and the child of that object dynamically.
* @args           :   Id  
* @return         :   List<string>    
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 06/09/2019- Created
*     
**/
    @AuraEnabled
    public static ResponseUtility getChildObjectName(Id parentObjId) {
        ResponseUtility response = new ResponseUtility();
        try {
            if(String.isNotBlank(parentObjId)) {
                MassUpdateWrapper massUpd = new MassUpdateWrapper();
                Schema.sObjectType sobjectType = parentObjId.getSObjectType();
                String sobjectName = sobjectType.getDescribe().getName();
                list<Schema.Childrelationship> relatedObjectsList = Schema.getGlobalDescribe().get(sobjectName).getdescribe().getChildRelationships();
                List<OptionWrapper> opt = new List<OptionWrapper>();
                for (Schema.Childrelationship  relatedObject : relatedObjectsList) {
                    if(relatedObject.getChildSObject().getDescribe().isUpdateable() && relatedObject.getChildSObject().getDescribe().isCreateable()) {
                        opt.add(new OptionWrapper(String.valueOf(relatedObject.getChildSObject().getDescribe().getLabel()),
                                                  String.valueOf(relatedObject.getChildSObject().getDescribe().getName())));
                    }
                }
                massUpd.options = opt;  
                response.setBody(massUpd.options);
            }
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return response;
    }
    /**
* @description    :   This method is used to get the records of the related list.
* @args           :   String , Id  
* @return         :   List<MassUpdateWrapper>    
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 16/09/2019- Created
*     
**/    
    
    @AuraEnabled
    public static  ResponseUtility getRecordsOfRelatedList(String selectedChildObj,Id parentId) {
        ResponseUtility response = new ResponseUtility();
        try{
            if(String.isNotBlank(selectedChildObj) && String.isNotBlank(parentId)) {
                MassUpdateWrapper massUpd = new MassUpdateWrapper();
                List<String> fieldNames = new List<String>();
                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                Schema.SObjectType ctype = gd.get(selectedChildObj); 
                Map<String, Schema.SobjectField> fmap = ctype.getDescribe().fields.getMap();   
                List<OptionWrapper> opt = new List<OptionWrapper>();
                for(String fieldName: fmap.keySet()) {
                    fieldNames.add(fieldName);
                    opt.add(new OptionWrapper(fmap.get(fieldName).getDescribe().getLabel(), fieldName));      
                }   
                massUpd.options = opt;
                String parentName = String.valueOf(parentId.getsobjecttype());
                String soqlchild = 'SELECT '+string.join(fieldNames,',')+' FROM '+  selectedChildObj +' WHERE '+parentName+'.Id'+' = \''+ parentId+'\'';
                List<sObject> sobj = Database.query(soqlchild);
                if(sobj.size() > 0 ) 
                    massUpd.recordFlag =True;
                else 
                    massUpd.recordFlag = False;
                response.setBody(massUpd);
            } 
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return response;
    }
    /**
* @description    :   This method is used to get the field type.
* @args           :   String , String 
* @return         :   String   
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 16/09/2019- Created
*     
**/    
    @AuraEnabled
    public static ResponseUtility getFieldType(String fieldName ,String parentObj) {
        ResponseUtility response = new ResponseUtility();
        
        try{
            if(String.isNotBlank(fieldName) && parentObj != null) {
                MassUpdateWrapper massUpd = new MassUpdateWrapper();
                Schema.SObjectType obj = Schema.getGlobalDescribe().get(parentObj);
                Schema.DescribeSObjectResult res = obj.getDescribe();
                Schema.DescribeFieldResult fieldType = res.fields.getMap().get(fieldName).getDescribe();
                String fieldTypes = String.valueOf(fieldType.getType());
                massUpd.fieldType = fieldTypes ;
                List<String> pickListValuesList= new List<String>();
                if(fieldType.getType() == Schema.DisplayType.PICKLIST) {
                    List<Schema.PicklistEntry> pickListVal = fieldType.getPicklistValues();
                    List<OptionWrapper> opt = new List<OptionWrapper>();
                    for( Schema.PicklistEntry ple : pickListVal ){
                        opt.add(new OptionWrapper(ple.getLabel(),ple.getLabel()));      
                    }   
                    massUpd.options = opt;
                    response.setbody(massUpd);
                }
            }
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return   response;
    }
    /**
* @description    :   This method is used to update the records.
* @args           :   String , String , List<sObject>, Id 
* @return         :   String   
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 16/09/2019- Created
*     
**/      
    @AuraEnabled 
    public static ResponseUtility updateRecords(String fieldName ,String selectedChildObj,  String fieldValue, Id parentObjId) {
        ResponseUtility response = new ResponseUtility();
        try{
            if(String.isNotBlank(fieldName) && String.isNotBlank(selectedChildObj) && String.isNotBlank(fieldValue) && parentObjId != null) {
                
                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                Schema.SObjectType ctype = gd.get(selectedChildObj); 
                Map<String, Schema.SobjectField> fmap = ctype.getDescribe().fields.getMap();   
                List<String> fieldNames = new List<String>();
                for(String fieldNm: fmap.keySet()) {
                    fieldNames.add(fieldNm);
                }   
                String parentName = String.valueOf(parentObjId.getsobjecttype());
                String soqlchild = 'SELECT '+string.join(fieldNames,',')+' FROM '+  selectedChildObj +' WHERE '+parentName+'.Id'+' = \''+ parentObjId+'\'';
                List<sObject> sobj = Database.query(soqlchild);
                for (sObject rec: sObj){
                    if (rec.get(fieldName) != fieldValue){
                        rec.put(fieldName,fieldValue); 
                    }
                } 
                update sObj;
            }
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return response;
    }
    
    
    public class MassUpdateWrapper {
        @AuraEnabled public String fieldType {get;set;}
        @AuraEnabled public Boolean recordFlag {get;set;}
        @AuraEnabled public List<OptionWrapper> options {get; set;}
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