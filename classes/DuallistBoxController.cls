public class DuallistBoxController {
    
    @AuraEnabled
    public static Map<String, String> getObjectFields(String objName) {
        Map<String, String> retVal = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        system.debug('---'+fieldMap);
        for (String fieldName: fieldMap.keySet()) {  
            retVal.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
            system.debug('map'+retVal);
            //List<String> aList = new List<String>();
            //aList.addAll(retVal.keySet());
            //aList.sort();
            
        }
        return retVal;
    }
    @AuraEnabled
    public static void selectedOptionList(List<string> selectedOptions , String ObjName) {
        
        String soql = 'SELECT ' ;
        for(String fields : selectedOptions) {
            soql += fields + ',';
        }
        soql = soql.removeEnd(',') + ' FROM '+objName ;
        //system.debug('-----' +selectedOptions);
        // system.debug('soql' +soqlcon);
    }
    
}