public class AllObj {
    
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
            accObj.allObj = opt;
            
            List<OptionWrapper> accField = new List<OptionWrapper>();
            Map<String, schema.SObjectField> MapOfFields = gd.get('Account').getDescribe().fields.getMap();
            for(Schema.SObjectField field : MapOfFields.values()){
                Schema.DescribeFieldResult fr = field.getDescribe();
                accField.add( new OptionWrapper(String.valueof(fr.getLabel()) ,String.valueof(fr.getName())));
            } 
            accObj.accField = accField;
            
            List<OptionWrapper> conField = new List<OptionWrapper>();
            Map<String, schema.SObjectField> MapOfField = gd.get('Contact').getDescribe().fields.getMap();
            for(Schema.SObjectField field : MapOfField.values()){
                Schema.DescribeFieldResult fr = field.getDescribe();
                conField.add( new OptionWrapper(String.valueof(fr.getLabel()) ,String.valueof(fr.getName())));
            } 
            accObj.conField = conField;
            
            List<OptionWrapper> accRec = new List<OptionWrapper>();
            accObj.accRecs = [select id,name,Phone from Account];
            for(Account acc : accObj.accRecs) {
                accRec.add( new OptionWrapper(acc.Name,acc.Id));
            }
            accObj.accRec = accRec;
            
            
            List<OptionWrapper> conRec = new List<OptionWrapper>();
            List<Contact> contacts = [select id,firstName,LastName from Contact];
            for(Contact con :contacts) {
                conRec.add( new OptionWrapper(con.LastName,con.Id));
            }
            accObj.conRec = conRec;
            response.setBody(accObj);
            
        }catch(Exception ex) {
            response.setError(ex.getMessage());
        }
        return response;
    }
    
    @AuraEnabled
    public static void saveDataDML(String wrap) {
       AllObjectWrapper wrappedData = (AllObjectWrapper)JSON.deserialize( wrap ,AllObjectWrapper.class );
        system.debug('wrapper=>>' +wrappedData);
       
             system.debug(wrappedData.selectedObject);
            system.debug(wrappedData.selectedAccField);
            system.debug(wrappedData.selectedConField);
            system.debug(wrappedData.selectedAccRec);
            system.debug(wrappedData.selectedConRec);
        
    }
    
    public class AllObjectWrapper {
        @AuraEnabled public list<OptionWrapper> allObj {get;set;}
        @AuraEnabled public list<OptionWrapper> accField {get;set;}
        @AuraEnabled public list<OptionWrapper> conField {get;set;}
        @AuraEnabled public list<OptionWrapper> accRec {get;set;}
        @AuraEnabled public list<OptionWrapper> conRec {get;set;}
        @AuraEnabled public list<Account> accRecs {get;set;}
        @AuraEnabled public String selectedObject {get;set;} 
        @AuraEnabled public String selectedAccField {get;set;} 
        @AuraEnabled public String selectedConField {get;set;} 
        @AuraEnabled public String selectedAccRec {get;set;} 
        @AuraEnabled public String selectedConRec {get;set;} 
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