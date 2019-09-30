public class PermissionWrapper{
    
        public PermissionWrapper() {
            this.objectApiName = '';
            this.objectLabel ='';
            this.fieldApiName = '';
            this.fieldLabel ='';
            this.profileApiName = '';
            this.profileLabel ='';
            this.permissionSetApiName = '';
            this.permissionSetLabel ='';
            this.type = '';
            this.typeOfComponent ='';
            this.isRedable = false;
            this.isEditable = false;
            this.isCreatable = false;
            this.isDeletable = false;
            this.isAllReadable = false;
            this.isModifiable = false;
        }
    
    
        @AuraEnabled public String objectApiName{get;set;}
        @AuraEnabled public String objectLabel{get;set;}
        @AuraEnabled public String fieldApiName{get;set;}
        @AuraEnabled public String fieldLabel{get;set;}
        @AuraEnabled public String profileApiName{get;set;}
        @AuraEnabled public String profileLabel{get;set;}
        @AuraEnabled public String permissionSetApiName{get;set;}
        @AuraEnabled public String permissionSetLabel{get;set;}
        @AuraEnabled public String type{get;set;}//Either Profile or Permission set
        @AuraEnabled public String typeOfComponent{get;set;}// Either Object or Field
        @AuraEnabled public Boolean isRedable{get;set;}
        @AuraEnabled public Boolean isEditable{get;set;}
        @AuraEnabled public Boolean isCreatable{get;set;}
        @AuraEnabled public Boolean isDeletable{get;set;}
        @AuraEnabled public Boolean isAllReadable{get;set;}
        @AuraEnabled public Boolean isModifiable{get;set;}
        
        
    }