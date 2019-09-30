/** Purpose: This Class is used as a Controller used in FieldSet Component.
*
* Created by: Shubh Shree Rathore
* 
* Created Date : 27-06-2019
* 
* Version : V.0 Created
* 
* revision logs:V1.0 -Shubh Shree Rathore - 27-06-2019
**/

public class ContactFieldSet {
/**
* @description    :   This method is used to add in the wrapper list
*     
* @args           :   
*   
* @return         :   list
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 27/06/2019- Created
*     
**/ 
    @AuraEnabled
    public static  List<ContactWrapper> getFieldSet(String objectType , String fieldSetName) {
          
	     Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectType);

        //List to hold  the atrributes.
        List<ContactWrapper> wrapper = new List <ContactWrapper>();
      
        //Itteration on the fieldset fields.
        for(Schema.FieldSetMember fieldToUse :  sObj.getDescribe().fieldSets.getMap().get(fieldSetName).getFields()) {
            
            ContactWrapper wrap = new ContactWrapper(); 
            wrap.DBRequired = fieldToUse.getDbRequired();
            wrap.Required = fieldToUse.getRequired();
            wrap.FieldType = String.valueOf(fieldToUse.getType());
            wrap.Label = fieldToUse.getLabel();
            wrap.APIName = fieldToUse.getFieldPath();
            wrap.Value = '';
            wrapper.add(wrap);
        }
        system.debug('--'+wrapper);
        return wrapper;
        
    }
    
    @AuraEnabled
    public static sObject getRecords(List<ContactWrapper> listOfWrap , String Obj){
        
        system.debug('list' +listOfWrap);
        sObject sobj = Schema.getGlobalDescribe().get(Obj).newSObject();
        for(ContactWrapper fw : listOfWrap ){
            system.debug(+fw);
            if(fw.FieldType == 'TEXT' ||  fw.FieldType =='EMAIL' ){
                if(String.isnotBlank(fw.value)){
                      sobj.put(fw.APIName, fw.Value);
                }
              }
            else if(fw.FieldType == 'DATE') {
                if(String.isnotBlank(fw.value)){
                    sobj.put(fw.APIName , DATE.valueOf(fw.Value));
                }
            }
            
            else if(fw.FieldType == 'PHONE'){
                if(String.isnotBlank(fw.value)){
                    sobj.put(fw.APIName , Integer.valueOf(fw.Value));
                }
            }
            else if(fw.FieldType == 'CHECKBOX'){
                if(String.isnotBlank(fw.value)){
                    sobj.put(fw.APIName , Boolean.valueOf(fw.Value));
                }
            }
            else{
                sobj.put(fw.APIName ,fw.Value);
            }
            
            system.debug('--'+sobj);
        }
      
        insert sobj;
        return sobj;
    }
    
    
    public class ContactWrapper {
        @AuraEnabled
        public Boolean DBRequired { get;set; }
        
        @AuraEnabled
        public String APIName { get;set; }
        
        @AuraEnabled
        public String Label { get;set; }
        
        @AuraEnabled
        public Boolean Required { get;set; }
        
        @AuraEnabled
        public String FieldType { get; set; }
        
        @AuraEnabled
        public String Value { get; set; }
           
    }
}