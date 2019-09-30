/**
* Purpose      :  It is a controller class used in lightning component.
* 
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  05/07/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore -  05/07/2019- Created
* 
**/
public class DynamicCloneRecordController {
    /* 
*	Description		:	This method used to clone data of parent object.
*
*	@argument		:	List 
*
*	Revision Logs	: 	V_1.0 - Created
*/    
    @AuraEnabled
    public static List<WrapperClass> cloneData(Id recordId){
        
        //map of all sObjects names to sObject tokens or values for the standard and custom objects defined in the organization.
        Map<String, Schema.sObjectType> objects = Schema.getGlobalDescribe(); 
        
        //get Sobject Name
        Schema.sObjectType sobjectType = recordId.getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        
        //Get all the fields of sObject
        Schema.sObjectType SchemaObjectName = objects.get(sobjectName);
        System.debug('SchemaObjectName---->'+SchemaObjectName);
        Schema.DescribeSObjectResult sObjectResult = SchemaObjectName.getDescribe();
        System.debug('sObjectResult---->'+sObjectResult);
        
        
        //if(sObjectResult.isAccessible() && sObjectResult.isCreateable() && sObjectResult.isUpdateable() && sObjectResult.isQueryable()) //{
        Map<String, Schema.SObjectField> fieldResult = sObjectResult.fields.getMap();
        System.debug('fieldResult---->'+fieldResult);
        List<String> fieldData = new List<String>();
        for(String fieldDetails: fieldResult.keyset()){
            fieldData.add(fieldDetails);              
        }
        System.debug('fieldData---->'+fieldData);
        String soql = 'SELECT ' + String.join(fieldData, ',') + ' FROM ' + sobjectName + ' WHERE Id =: recordId';
        System.debug('soql' + soql);
        sObject sObjectData= Database.query(soql);
        System.debug('sObjectData'+sObjectData);
        sObject clonesObject = sObjectData.clone(false,true,false,false);
        clonesObject.put('Name','Clone-' +clonesObject.get('Name'));
        //insert clonesObject;
        ID parentId = clonesObject.Id;
        System.debug('sObjectDataClon'+clonesObject);
        system.debug('parent' +parentId);
        // }
        
        List<WrapperClass> wrapList = new List<WrapperClass>(); 
        //child object Data
        List<SObject> cloneChild1 = new  List<SObject>();
        List<Schema.ChildRelationship> crData = sObjectResult.getChildRelationships();
        System.debug('crData---->'+crData);
        for(Schema.ChildRelationship childData : crData)  {
            Schema.DescribeSObjectResult describeChildObjectResult = childData.getChildSObject().getDescribe();
            if(describeChildObjectResult.isAccessible() && describeChildObjectResult.isCreateable() 
               && describeChildObjectResult.isUpdateable() && describeChildObjectResult.isQueryable()) {
                   system.debug('false--'+describeChildObjectResult.getName());
                   WrapperClass wrapObj = new WrapperClass();
                   wrapObj.ObjName = describeChildObjectResult.getName();
                   wrapObj.objLabel = describeChildObjectResult.getLabel();
                   wrapObj.fieldName = String.valueOf(childData.getField());
                   // String soql = 'SELECT ' + childData.removeEnd(',') + ' FROM ' + wrapObj.ObjName + ' WHERE ' + wrapObj.fieldName + ' =: recordId ' ;
                   String soqlchild = 'SELECT Id FROM '+  wrapObj.ObjName +' WHERE '+ wrapObj.fieldName + ' = \''+ recordId+'\'';
                   List<sObject> sObj = Database.query(soqlchild);
                   wrapObj.totNoOfRecords = String.valueOf(sObj.size());
                   System.debug(String.valueOf(sObj.size()));
                   wrapList.add(wrapObj);
                   
                   if(!(sObj.isEmpty()))  {
                       for(sObject sbject : sObj)   {
                           SObject sobjCloneChild1 = sbject.getSobjectType().newSobject(); 
                           sobjCloneChild1 = sbject.clone();
                           sobjCloneChild1.put(wrapObj.fieldName,parentId);
                           insert sobjCloneChild1;
                           System.debug('>> Clone Child >>>'+sobjCloneChild1);
                           cloneChild1.add(sobjCloneChild1);
                       }
                   }
               }
        }
        return wrapList;
    }
/* 
*	Description		:	This method used to clone data of child object.
*
*	@argument		:	List 
*
*	Revision Logs	: 	V_1.0 - Created
*/ 
    @AuraEnabled 
    public static Map<String,List<WrapperClass>> cloneChildData(List<String> childId) {
        system.debug('Child' +childId);
        Map<String,List<WrapperClass>> wrapList = new Map<String,List<WrapperClass>>(); 
        
        //child object Data
        for(String childRelation : childId) {
            system.debug('childRelation'+childRelation);
            Schema.sObjectType objects = Schema.getGlobalDescribe().get(childRelation);
            Schema.DescribeSObjectResult sobjRes = objects.getDescribe();
            List<Schema.ChildRelationship> crData = sobjRes.getChildRelationships();
            
            for(Schema.ChildRelationship childData : crData)  {
                System.debug('#####'+childData);
                Schema.DescribeSObjectResult describeChildObjectResult = childData.getChildSObject().getDescribe();
                
                if(describeChildObjectResult.isAccessible() && describeChildObjectResult.isCreateable() 
                   && describeChildObjectResult.isUpdateable() && describeChildObjectResult.isQueryable()) {
                       
                       WrapperClass wrapObj = new WrapperClass();
                       wrapObj.ObjName = describeChildObjectResult.getName();
                       wrapObj.objLabel = describeChildObjectResult.getLabel();
                       wrapObj.fieldName = String.valueOf(childData.getField());
                       //system.debug('@@@@@@@@'+wrapObj);
                       String soql = 'SELECT Id FROM '+  wrapObj.ObjName +' WHERE '+ wrapObj.fieldName + ' = \''+ childId+'\'';
                       
                       //List<sObject> sObj = Database.query(soql);
                       //wrapObj.totNoOfRecords = String.valueOf(sObj.size());
                       if(!wrapList.containsKey(childRelation)) {
                           wrapList.put((childRelation),new List<WrapperClass>());
                       }
                       wrapList.get(childRelation).add(wrapObj);
                       
                   }
                //system.assert(false,wrapList);
                system.debug('wrapper Child List' +wrapList);
            }
        }
        return  wrapList;    
    }
    
    //wrapper class 
    public class WrapperClass{
        @AuraEnabled String objLabel{get;set;}
        @AuraEnabled String objName{get;set;}
        @AuraEnabled String fieldName{get;set;}
        @AuraEnabled String totNoOfRecords{get;set;}
    }
}