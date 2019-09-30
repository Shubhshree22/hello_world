/*
@ Author : Moulina and Pramod
@ Name : DescribeUtility
@ Created Date : 08 August 2019
@ Revision Log : V_1.0
*/
public With Sharing class PermissionWizardUtility {
    
    public Static Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    
    

@AuraEnabled
    public Static List<PermissionWrapper> retrieveObject(String objectType) {
        List<PermissionWrapper> lstWrapperObject = new List<PermissionWrapper>();
        Set<String> objectsNames = new Set<String>();
        
       Set<String> POLYMORPIC_OBJECTS = new Set<String> {'processinstanceworkitem',
            'attachment',
            'campaignmember',
            'caseteammember',
            'contentdocumentlink',
            'duplicaterecorditem',
            'emailmessage',
            'emailmessagerelation',
            'entitysubscription',
            'eventrelation',
            'feeditem',
            'flowinterviewshare',
            'todaygoalshare',
            'collaborationgrouprecord',
            'contentworkspacemember',
            'note',
            'outgoingemail',
            'outgoingemailrelation',
            'usershare',
            'vote',
            'apextestqueueitem',
            'announcement',
            'todaygoal',
            'objectpermissions',
            'userprovaccount',
            'profile',
            'PromptAction',
            'OauthCustomScope',
            'EnhancedLetterhead',
            'AuthorizationFormText',
            'AuthorizationFormDataUse',
            'AuthorizationFormConsent',
            'AuthorizationForm',
            'Recommendation',
            'Image',
            'ExpressionFilterCriteria',
            'ExpressionFilter',
            'DataUsePurpose',
            'DataUseLegalBasis',
            'ContactPointTypeConsent',
            'AppAnalyticsQueryRequest',
            'ProductConsumptionSchedule',
            'ConsumptionRate',
            'ConsumptionSchedule',
            'ListEmailIndividualRecipient',
            'WaveAutoInstallRequest',
            'FlowRecordRelation',
            'OrgDeleteRequest',
            'RecordAction',
            'ListEmailRecipientSource',
            'ListEmail',
            'AssetRelationship',
            'OutgoingEmailRelation',
            'OutgoingEmail',
            'DuplicateRecordItem',
            'DuplicateRecordSet',
            'TodayGoal',
            'MatchingInformation',
            'ExternalEvent',
            'ExternalEventMapping',
            'ConferenceNumber',
            'InstalledMobileApp',
            'QuickText',
            'DatacloudPurchaseUsage',
            'LeadCleanInfo',
            'ContactCleanInfo',
            'AccountCleanInfo',
            'DandBCompany',
            'FlowInterview',
            'PermissionSetLicenseAssign',
            'StreamingChannel',
            'Announcement',
            'CollaborationGroupRecord',
            'ContentAsset',
            'MacroInstruction',
            'ContentFolder',
            'Macro',
            'IdeaComment',
            'Idea',
            'AccountContactRole',
            'SearchPromotionRule',
            'Individual',
            'EmailMessageRelation',
            'EmailMessage',
            'AuthSession',
            'TopicAssignment',
            'Topic',
            'CategoryData',
            'EventRelation',
            'SetupEntityAccess',
            'FieldPermissions',
            'ObjectPermissions',
            'PermissionSetAssignment',
            'QueueSobject',
            'GroupMember',
            'Group',
            'ApexTestQueueItem',
            'ProcessInstanceWorkitem',
            'PushTopic',
            'CollaborationInvitation',
            'CollaborationGroupMemberRequest',
            'CollaborationGroupMember',
            'CollaborationGroup',
            'EntitySubscription',
            'Note',
            'ContentFolderMember',
            'ContentDistributionView',
            'ContentDistribution',
            'ContentWorkspaceMember',
            'ContentDocumentSubscription',
            'ContentVersionRating',
            'ContentNotification',
            'ContentVersionComment',
            'ContentWorkspacePermission',
            'ContentWorkspaceDoc',
            'ContentWorkspace',
            'ContentDocumentLink',
            'ContentDocument',
            'ContentVersion',
            'Holiday',
            'Solution',
            'CaseSolution',
            'CaseContactRole',
            'CaseTeamTemplateRecord',
            'CaseTeamRole',
            'CaseTeamMember',
            'CaseTeamTemplateMember',
            'CaseTeamTemplate',
            'CaseComment',
            'OpportunityPartner',
            'AccountPartner',
            'Partner',
            'OpportunityCompetitor',
            'OpportunityLineItem',
            'OpportunityContactRole',
            'Vote',
            'ClientBrowser',
            'LoginIp',
            'EmailTemplate',
            'Document',
            'ContractContactRole',
            'OrderItem',
            'history',
            'History',
            'user',
            'User',
            '__user',
            '__User',
            'share',
            '__share',
            'Share',
            '__Share',
            'tag',
            'Tag',
            'Feed',
            'feed',
            'DashboardFeed',
            'DashboardComponentFeed',
            'UserPackageLicense',
            'TaskFeed',
            'EventFeed',
            'SiteFeed',
            'TopicFeed',
            'TopicUserEvent',
            'UserAppMenuCustomization',
            'UserAppMenuCustomizationShare',
            'QuickTextShare',
            'AuthorizationFormShare',
            'AuthorizationFormConsentShare',
            'AuthorizationFormDataUseShare',
            'PromptActionShare',
            'EnhancedLetterheadFeed',
            'ConsumptionScheduleShare',
            'ConsumptionScheduleFeed',
            'DataUseLegalBasisShare',
            'DataUsePurposeShare',
            'ImageShare',
            'OrgDeleteRequestShare',
            'ListEmailShare',
            'AssetRelationshipFeed',
            'TodayGoalShare',
            'ExternalEventMappingShare',
            'UserProvAccountStaging',
            'UserProvAccount',
            'UserProvMockTarget',
            'UserProvisioningLog',
            'UserProvisioningRequestShare',
            'UserProvisioningRequest',
            'UserAppInfo',
            'FlowInterviewShare',
            'StreamingChannelShare',
            'MacroShare'};
        
        
        try{
            String setstring = '';
            for( AggregateResult aggr : [SELECT sObjectType sobj From ObjectPermissions Group BY sObjectType]){
                objectsNames.add(String.valueOf(aggr.get('sobj')));
            }
            System.debug('objectsNames-->'+objectsNames);
            if(String.isNotBlank(objectType) && String.valueOf(objectType).equals('Standard')) {
                for(Schema.SObjectType thisObj : gd.values()) {
                    //describe Object
                    DescribeSobjectResult res = thisObj.getDescribe();
                    //to eleminate unwanted objects
                    if(!res.deprecatedandhidden && !(POLYMORPIC_OBJECTS.contains(res.getName()))) {
                        if(objectsNames.contains(res.getName())){
                                //add Standard Objects to list
                                PermissionWrapper perWrap = new PermissionWrapper();
                                perWrap.objectLabel = res.getLabel()+'('+res.getName()+')';
                                perWrap.objectApiName = res.getName();
                                lstWrapperObject.add(perWrap);
                        }
                    }
                }
            }
            else {
                //for invoking custom metadata
                lstWrapperObject = retrieveMetadataDeveloperName();
            }
            
        }
        catch(Exception e){
            e.getMessage();
        }
        system.debug('lstWrapperObject...'+lstWrapperObject);
        //list of all standard object
        return lstWrapperObject;
    }/*
    * @ Method Name : retrieveObject
    * @ Args : String objectName
    * @ Return Type : Map<String, List<Wrapper>>
    * @ Description : This method is used to describe all fields of a particluar selected standard object or if user selects All in the UI dropdown 
    *                 then will fetch all fields from all standard objects
    */
    @AuraEnabled
    public static List<PermissionWrapper> retrieveFields(String objectName) {
        List<PermissionWrapper> lstWrapperObjectFields = new List<PermissionWrapper>();
		Set<String> systemFieldNames = new Set<String>{'Id', 'CreatedDate', 'IsDeleted', 'LastActivityDate', 
                 'LastModifiedDate', 'LastReferencedDate', 'LastViewedDate', 'SystemModstamp',
                 'CreatedById', 'OwnerId', 'LastModifiedById','MasterRecordId'};
		
        try{
		    String setstring = '';
            if(String.isBlank(objectName)) {
                throw new MyException('Object Name is Blank');
            }
            if(String.isNotBlank(objectName) && !(String.valueOf(objectName).equals('All'))) {
                
                for(SObjectField fieldName: gd.get(objectName).getDescribe().fields.getMap().values()){
                    Schema.DescribeFieldResult fieldResult = fieldName.getDescribe();
                    if(fieldResult.isNillable() && !(systemFieldNames.contains(fieldResult.getName()))) {
                        PermissionWrapper perWrap = new PermissionWrapper();
                        perWrap.fieldLabel = fieldResult.getLabel();
                        perWrap.fieldApiName = fieldResult.getName();
                        perWrap.objectApiName = objectName;
                        lstWrapperObjectFields.add(perWrap);
					}					
              }
              System.debug('list Of fields ===>>> ' + lstWrapperObjectFields );
            }
            
            else {
                List<PermissionWrapper> returnedWrapperList = retrieveObject('Standard');
				for(PermissionWrapper wrap : returnedWrapperList) {
                    lstWrapperObjectFields = new List<PermissionWrapper>();
                    for(SObjectField fieldName: gd.get(wrap.objectApiName).getDescribe().fields.getMap().values()){
                        Schema.DescribeFieldResult fieldResult = fieldName.getDescribe();
                        if(fieldResult.isNillable() && !(systemFieldNames.contains(fieldResult.getName()))) {					
                            PermissionWrapper perWrap = new PermissionWrapper();
                            perWrap.fieldLabel = fieldResult.getLabel();
                            perWrap.fieldApiName = fieldResult.getName();
                            perWrap.objectLabel = wrap.objectLabel;
                            perWrap.objectApiName = wrap.objectApiName;
                            lstWrapperObjectFields.add(perWrap);
							}
                    }
                }
                
            }
        }
        catch(Exception e){
            //throw new MyException();
        }
        
        return lstWrapperObjectFields;
    }
        /*
* @ Method Name : retrieveMetadataDeveloperName
* @ Args : 
* @ Return Type : List<Wrapper>
* @ Description : This method is used to return all metadata group names
*/
    @AuraEnabled
    public static List<PermissionWrapper> retrieveMetadataDeveloperName() {
        List<PermissionWrapper> lstWrapperObject = new List<PermissionWrapper>();
        //to get the group name 
        List<Permission_Group_Config__mdt> permissionGroupConfigForObject = new List<Permission_Group_Config__mdt>();
        //List<Permission_Group_Config__mdt> permissionGroupConfigForProfile = new List<Permission_Group_Config__mdt>();
        
        permissionGroupConfigForObject = [SELECT Id, MasterLabel, DeveloperName, Type__c, Active__c  FROM Permission_Group_Config__mdt WHERE Type__c = 'Object' AND Active__c = True];
        //permissionGroupConfigForProfile = [SELECT Id, MasterLabel, DeveloperName, Type__c, Active__c  FROM Permission_Group_Config__mdt WHERE Type__c = 'Profile' AND Active__c = True];
        
        if(permissionGroupConfigForObject.size() > 0) {
            //to fill individual name of group in the list (this list will be displayed in the front end)
            for(Integer i = 0 ; i < permissionGroupConfigForObject.size() ; i++){
                PermissionWrapper perWrap = new PermissionWrapper();
                perWrap.objectLabel = permissionGroupConfigForObject[i].MasterLabel;
                perWrap.objectApiName = permissionGroupConfigForObject[i].DeveloperName;
                lstWrapperObject.add(perWrap);
            }
        }
        //return all the group name of type object
        return lstWrapperObject;
        
    }    
    
    /*
* @ Method Name : retrieveMetadataObjectDetails
* @ Args : String groupName
* @ Return Type : List<Wrapper>
* @ Description : This method is used to return all metadata objects name in the group selected
*/
    //input is send from ui(group label name in string formate----->groupName)
    @AuraEnabled
    public static List<PermissionWrapper> retrieveMetadataObjectDetails(String groupName) {
        List<PermissionWrapper> lstWrapperObject = new List<PermissionWrapper>();
        //list of Detail Config ---->permissionDetailConfig (holds the list of object names under a particular group send from ui)
        List<Permission_Detail_Config__mdt> permissionDetailConfig = new List<Permission_Detail_Config__mdt>();
        //query
        permissionDetailConfig= [SELECT Id, Object_Name__c, Object_API_Name__c, Permission_Group_Config__r.MasterLabel, Active__c  FROM Permission_Detail_Config__mdt WHERE Permission_Group_Config__r.DeveloperName =: groupName];        
        system.debug('permissionDetailConfig---->>>>>'+permissionDetailConfig);
        if(permissionDetailConfig.size() > 0) {
            for(Integer i = 0 ; i < permissionDetailConfig.size() ; i++){
                PermissionWrapper perWrap = new PermissionWrapper();
                perWrap.objectLabel = permissionDetailConfig[i].Object_Name__c;
                perWrap.objectApiName = permissionDetailConfig[i].Object_API_Name__c;
                lstWrapperObject.add(perWrap);
            }
        }
        system.debug('lstWrapperObject---->>>>>'+lstWrapperObject);
        return lstWrapperObject;
        
    }
    
    /*
* @ Method Name : retrieveFieldsUsingMetaDataList
* @ Args : String groupName
* @ Return Type : Map<String, List<Wrapper>>
* @ Description : This method is used to describe all fields of a particluar group of object selected in custom metadata list in the UI dropdown.
*/
    @AuraEnabled
    public Static List<PermissionWrapper> retrieveFieldsUsingMetaDataList(String groupName) {
        List<PermissionWrapper> lstWrapperObjectFields = new List<PermissionWrapper>();
        Map<String, List<PermissionWrapper>> mapOfObjectWithFields = new Map<String, List<PermissionWrapper>>();
        try{
            if(String.isBlank(groupName)) {
                throw new MyException('Group Name is Blank');
            }
            //to invoke the method to get the listy of objects in the group selected
            List<PermissionWrapper> returnedWrapperList = retrieveMetadataObjectDetails(groupName);
            for(PermissionWrapper wrap : returnedWrapperList) {
                //  lstWrapperObjectFields = new List<PermissionWrapper>();
                for(SObjectField fieldName: gd.get(wrap.objectApiName).getDescribe().fields.getMap().values()){
                    
                    Schema.DescribeFieldResult fieldResult = fieldName.getDescribe();
                    
                    if(fieldResult.isAccessible() || fieldResult.isUpdateable() || fieldResult.isCreateable() || fieldResult.isNillable()) {
                        PermissionWrapper perWrap = new PermissionWrapper();
                        perWrap.fieldLabel = fieldResult.getLabel();
                        perWrap.fieldApiName = fieldResult.getName();
                        perWrap.objectApiName = wrap.objectApiName;
                        perWrap.objectLabel = wrap.objectLabel;
                        lstWrapperObjectFields.add(perWrap);
                        
                    }
                }
            }
        }
        catch(Exception e){
            //throw new MyException();
        }  
        system.debug('lstWrapperObjectFields...'+lstWrapperObjectFields);
        return lstWrapperObjectFields;
    }    
    
    
    
    /*
* @ Method Name : retrievePermissionAndProfile
* @ Args : String permissionType, String profileFilter
* @ Return Type : List<Wrapper>
* @ Description : This method is used to describe all profile and permission set name as per selection of pemisssion type and profile filter
*/
    @AuraEnabled
    public static List<PermissionWrapper> retrievePermissionAndProfile(String permissionType, String profileFilter) {
        
        List<PermissionWrapper> lstWrapperObjectFields = new List<PermissionWrapper>();
        List<Permission_Group_Config__mdt> permissionGroupConfigForProfile = new List<Permission_Group_Config__mdt>();
        List<Permission_Group_Config__mdt> permissionGroupConfigForPermisssonset = new List<Permission_Group_Config__mdt>();
        List<Profile> standardProfiles = new List<Profile>();
        List<PermissionSet> standardPermissionSet = new List<PermissionSet>();
        try{
            if(String.isBlank(permissionType)||String.isBlank(profileFilter)) {
                throw new MyException('Blank Data');
            }
            // if permissionType = 'Profile'
            if(String.isNotBlank(permissionType) && String.valueOf(permissionType).equals('Profile')) {
                
                // if profileFilter = 'Custom'
                if(String.isNotBlank(profileFilter) && String.valueOf(profileFilter).equals('Custom')) {
                    
                    // Retrieve data from metadata profile
                    permissionGroupConfigForProfile = [SELECT Id, MasterLabel, DeveloperName, Type__c, Active__c  FROM Permission_Group_Config__mdt WHERE Type__c = 'Profile' AND Active__c = True];
                    
                    for(Integer i = 0 ; i < permissionGroupConfigForProfile.size() ; i++){
                        PermissionWrapper perWrap = new PermissionWrapper();
                        perWrap.profileLabel = permissionGroupConfigForProfile[i].MasterLabel;
                        perWrap.profileApiName = permissionGroupConfigForProfile[i].DeveloperName;
                        lstWrapperObjectFields.add(perWrap);
                    }
                }
                
                // if profileFilter = 'Standard'
                else if( String.isNotBlank(profileFilter) && String.valueOf(profileFilter).equals('Standard') ) {
                    standardProfiles = [Select Id, Name from Profile];
                    for(Integer i = 0 ; i < standardProfiles.size() ; i++){
                        PermissionWrapper perWrap = new PermissionWrapper();
                        perWrap.profileLabel = standardProfiles[i].Name;
                        perWrap.profileApiName = standardProfiles[i].Name;
                        lstWrapperObjectFields.add(perWrap);
                    }
                }
            }
            // if permissionType = 'Permission Sets'
            else if(String.isNotBlank(permissionType) && String.valueOf(permissionType).equals('Permission Sets')) {
                
                // if profileFilter = 'Custom'
                if(String.isNotBlank(profileFilter) && String.valueOf(profileFilter).equals('Custom')) {
                    
                    // Retrieve data from metadata profile
                    permissionGroupConfigForPermisssonset = [SELECT Id, MasterLabel, DeveloperName, Type__c, Active__c  FROM Permission_Group_Config__mdt WHERE Type__c = 'Permission Set' AND Active__c = True];
                    
                    for(Integer i = 0 ; i < permissionGroupConfigForPermisssonset.size() ; i++){
                        PermissionWrapper perWrap = new PermissionWrapper();
                        perWrap.permissionSetLabel = permissionGroupConfigForPermisssonset[i].MasterLabel;
                        perWrap.permissionSetApiName = permissionGroupConfigForPermisssonset[i].DeveloperName;
                        lstWrapperObjectFields.add(perWrap);
                    }
                }
                // if profileFilter = 'Standard'
                else if( String.isNotBlank(profileFilter) && String.valueOf(profileFilter).equals('Standard') ) {
                    standardPermissionSet = [Select Id, Name from PermissionSet];
                    
                    
                    for(Integer i = 0 ; i < standardPermissionSet.size() ; i++){
                        if(!standardPermissionSet[i].Name.contains('X00')){
                            PermissionWrapper perWrap = new PermissionWrapper();
                            perWrap.permissionSetLabel= standardPermissionSet[i].Name;
                            perWrap.permissionSetApiName = standardPermissionSet[i].Name;
                            lstWrapperObjectFields.add(perWrap);
                        }
                        
                    }
                    System.debug(' lstWrapperObjectFields==== ' + lstWrapperObjectFields);
                }
            }
        }
        catch(Exception e){
            //throw new MyException();
        }
        System.debug('lstWrapperObjectFields...'+lstWrapperObjectFields);
        return lstWrapperObjectFields;
    }
    
    
    /* Method : For permission sets and profile 
* Created By : Divya Narayan Dubey 
* 				Kirti Chhatwani
*/
    @AuraEnabled
    public static List<PermissionWrapper> fieldPermissionsSetter( String mapObjectFields ,String permissionList , String objectName , String permissionName , String profileorPermission){
        try{
            System.debug(mapObjectFields);
            System.debug(permissionList);
            System.debug(objectName);
            System.debug(permissionName);
            
            List<PermissionWrapper> fieldobjWrapped = (List<PermissionWrapper>)JSON.deserialize( mapObjectFields , List<PermissionWrapper>.class);
            List<PermissionWrapper> permissionWrapped = (List<PermissionWrapper>)JSON.deserialize( permissionList , List<PermissionWrapper>.class);
            
            List<PermissionWrapper> returningPermissions = new List<PermissionWrapper>() ;
            List<String> fieldApiName = new List<String>() ;
            List<String> objectAPiName = new List<String>();
            List<String> permissionsList = new List<String>();
            List<FieldPermissions> fieldPermission = new List<FieldPermissions>();
            
            for(PermissionWrapper wr : permissionWrapped ){
                permissionsList.add(wr.profileApiName);
            }
            
            
            for(PermissionWrapper wp : fieldobjWrapped ){
                fieldApiName.add(wp.objectApiName+'.'+wp.fieldApiName);
                if(objectName == 'All'){
                    objectAPiName.add(wp.objectApiName);
                }
            }
            
            if(profileorPermission == 'Profile'){     
                if(objectName != 'All' && permissionName != 'All'){
                    //str += ' sObjectType = '+ '\''+ objectName + '\'' + ' AND FIELDS IN  ' + '\'' + fieldApiName + ' AND ' ;
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType =: objectName
                                       AND FIELD IN : fieldApiName AND  parentId IN (SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name =: permissionName )] ;
                    System.debug('if block 1   ' + fieldPermission );
                }
                if(objectName == 'All' && permissionName != 'All'){
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType IN: objectApiName
                                       AND FIELD IN : fieldApiName AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name =: permissionName )] ;
                    System.debug('if block 2   ' + fieldPermission );
                    
                }
                if(objectName != 'All' && permissionName == 'All'){
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType =: objectName
                                       AND FIELD IN : fieldApiName AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name IN: permissionsList )] ;
                    System.debug('if block 3   ' + fieldPermission );
                    
                }
                if(objectName == 'All' && permissionName == 'All'){
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType IN : objectApiName
                                       AND FIELD IN : fieldApiName AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name IN: permissionsList )] ;
                    
                    System.debug('if block 4   ' + fieldPermission );
                }
            }
            
            if(profileorPermission == 'Permission Sets'){     
                if(objectName != 'All' && permissionName != 'All'){
                    //str += ' sObjectType = '+ '\''+ objectName + '\'' + ' AND FIELDS IN  ' + '\'' + fieldApiName + ' AND ' ;
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType =: objectName
                                       AND FIELD IN : fieldApiName AND  parentId IN (SELECT Id FROM PermissionSet WHERE PermissionSet.Name =: permissionName )] ;
                    System.debug('if block 1   ' + fieldPermission );
                }
                if(objectName == 'All' && permissionName != 'All'){
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType IN: objectApiName
                                       AND FIELD IN : fieldApiName AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Name =: permissionName )] ;
                    System.debug('if block 2   ' + fieldPermission );
                    
                }
                if(objectName != 'All' && permissionName == 'All'){
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType =: objectName
                                       AND FIELD IN : fieldApiName AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Name IN: permissionsList )] ;
                    System.debug('if block 3   ' + fieldPermission );
                    
                }
                if(objectName == 'All' && permissionName == 'All'){
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType IN : objectApiName
                                       AND FIELD IN : fieldApiName AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Name IN: permissionsList )] ;
                    
                    System.debug('if block 4   ' + fieldPermission );
                }
            }
            
            
            System.debug('Query Result -- > '+ fieldPermission);
            
            /*

else{
str += ' sObjectType IN '+ '\''+ objectAPiName  + '\'' + ' AND FIELDS IN  ' + '\'' + fieldApiName + ' AND ' ;
//}
//System.debug('str from fields ' + str);

if( permissionName != 'All' ){
//str += ' parentId in ( SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name = '+ '\'' + permissionName  ;

}
else{
//str += 'parentId in ( SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name IN '+ '\'' + permissionsList  ;
}


//System.debug('str after permissions '  + str);
//String query = str.removeEnd('AND ');
//System.debug(query);
//List<FieldPermissions> fieldpermission = Database.query(query);


*/
            
            for(FieldPermissions fp : fieldpermission ){
                PermissionWrapper pw = new PermissionWrapper();
                pw.isEditable = fp.PermissionsEdit;
                pw.isRedable =  fp.PermissionsRead ;
                pw.objectApiName = fp.SobjectType ; 
                pw.fieldApiName = fp.Field;
                pw.profileLabel = fp.Parent.Profile.Name ;
                returningPermissions.add(pw); 
            }
            return returningPermissions ;
        }    
        catch( Exception e ){
            System.debug('error is ' + e.getMessage()+ ' error on line number  ' +e.getLineNumber());
            return null;
        }
        
    }
    /*
* @ Method Name : retrievePermissionNamesOrProfileNames
* @ Args : String permissionType, String profileFilter
* @ Return Type : List<Wrapper>
* @ Description : This method is used to describe all profile and permission set name as per selection of pemisssion type and profile filter
*/
    @AuraEnabled
    public static List<PermissionWrapper> retrievePermissionNamesOrProfileNames(String profileOrPermissionSetName, String permissionType ) {
        List<PermissionWrapper> lstWrapperProfileOrPermission = new List<PermissionWrapper>();
        List<Permission_Detail_Config__mdt> permissionDetailConfig = new List<Permission_Detail_Config__mdt>();
        
        permissionDetailConfig= [SELECT Id, Profile_Name__c, Profile_API_Name__c, PermissionSet_Name__c, Permission_Set_API_Name__c, Permission_Group_Config__r.MasterLabel, Active__c  FROM Permission_Detail_Config__mdt WHERE Permission_Group_Config__r.DeveloperName =: profileOrPermissionSetName];        
        system.debug('permissionDetailConfig---->>>>>'+permissionDetailConfig);
        if(permissionDetailConfig.size() > 0) {
            for(Integer i = 0 ; i < permissionDetailConfig.size() ; i++){
                PermissionWrapper perWrap = new PermissionWrapper();
                if(String.valueOf(permissionType).equals('Profile')){
                    perWrap.profileApiName = permissionDetailConfig[i].Profile_API_Name__c;
                    perWrap.profileLabel = permissionDetailConfig[i].Profile_Name__c;
                    lstWrapperProfileOrPermission.add(perWrap);
                }
                else if(String.valueOf(permissionType).equals('Permission Sets')){
                    perWrap.permissionSetApiName = permissionDetailConfig[i].Permission_Set_API_Name__c;
                    perWrap.permissionSetLabel = permissionDetailConfig[i].PermissionSet_Name__c;
                    lstWrapperProfileOrPermission.add(perWrap);
                }
            }
        }
        system.debug('lstWrapperProfileOrPermission---->>>>>'+lstWrapperProfileOrPermission);
        return lstWrapperProfileOrPermission;
        
    }
    
    
     /*
* @ Method Name : showPopUp
* @ Created By : Moulina
* @ Args : String objectPassed, List<String> profileNames, String profileType, String objectOrFields
* @ Return Type : List<PermissionWrapper>
* @ Description : This method is used to describe the permission against a particular object selected to show the popup
*/
    @AuraEnabled
    public static List<PermissionWrapper> showPopUp(String objectPassed, List<String> profileNames, String profileType, String objectOrFields, String fieldPassed) {
        
        System.debug('objectPassed....'+objectPassed +'     '+ ' profileNames....'+profileNames +'        ' +' profileType----------->>'+profileType +'    '+' objectOrFields......'+objectOrFields + '       '+'  fieldPassed........'+fieldPassed );
        
        List<PermissionWrapper> lstWrapperObjectPermissions = new List<PermissionWrapper>();
        List<ObjectPermissions> objectPermission = new List<ObjectPermissions>();
        List<FieldPermissions> fieldPermission = new List<FieldPermissions>();
        try{
            if(String.isBlank(objectOrFields)||String.isBlank(profileType)||String.isBlank(objectPassed)||profileNames.size() <= 0) {
                throw new MyException('Blank Data');
            }
            if(objectOrFields == 'Object'){
                if(profileType == 'Profile'){
                    objectPermission= [SELECT ParentId, Parent.Name, Parent.Profile.Name, PermissionsRead, PermissionsCreate, PermissionsEdit, PermissionsDelete,
                                       PermissionsViewAllRecords, PermissionsModifyAllRecords FROM ObjectPermissions where SobjectType =: objectPassed And Parent.Profile.Name IN : profileNames];
                    System.debug('noor' + objectPermission);
                }
                else if(profileType == 'Permission Sets'){
                    objectPermission= [SELECT ParentId, Parent.Name, Parent.Profile.Name, PermissionsRead, PermissionsCreate, PermissionsEdit, PermissionsDelete,
                                       PermissionsViewAllRecords, PermissionsModifyAllRecords FROM ObjectPermissions where SobjectType =: objectPassed And Parent.Name IN : profileNames];
                }
                for(Integer i = 0 ; i < objectPermission.size() ; i++){
                    PermissionWrapper perWrap = new PermissionWrapper();
                    perWrap.isRedable = objectPermission[i].PermissionsRead;
                    perWrap.isEditable = objectPermission[i].PermissionsEdit;
                    perWrap.isCreatable = objectPermission[i].PermissionsCreate;
                    perWrap.isDeletable = objectPermission[i].PermissionsDelete;
                    perWrap.isAllReadable = objectPermission[i].PermissionsViewAllRecords;
                    perWrap.isModifiable = objectPermission[i].PermissionsModifyAllRecords;
                    perWrap.profileLabel = objectPermission[i].Parent.Profile.Name;
                    perWrap.permissionSetLabel = objectPermission[i].Parent.Name;
                    lstWrapperObjectPermissions.add(perWrap);
                }
                System.debug('nooooor = '+ lstWrapperObjectPermissions );
            }
            else if(objectOrFields== 'Field') {
                System.debug('Field--->>>'+objectOrFields);
                String fieldName= objectPassed+'.'+fieldPassed ;
                if(profileType== 'Profile'){
                    System.debug('Profile---->>>'+profileType);
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE Field=: fieldName 
                                       AND sObjectType =: objectPassed AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name IN: profileNames)];                                        
                    
                    System.debug('fieldPermission++++====>>>'+fieldPermission);
                }
                else if(profileType == 'Permission Sets'){
                    fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE Field=: fieldName
                                       AND sObjectType =: objectPassed AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Name IN: profileNames )] ;
                    System.debug('fieldPermission____>>>___>>>'+fieldPermission);
                }
                //system.assert(false, fieldPermission);
                for(Integer i = 0 ; i < fieldPermission.size() ; i++){
                    PermissionWrapper perWrap = new PermissionWrapper();
                    perWrap.isRedable = fieldPermission[i].PermissionsRead;
                    perWrap.isEditable = fieldPermission[i].PermissionsEdit;
                    perWrap.profileLabel = fieldPermission[i].Parent.Profile.Name;
                    perWrap.permissionSetLabel = fieldPermission[i].Parent.Name;
                    perWrap.fieldLabel = fieldPermission[i].Field;
                    lstWrapperObjectPermissions.add(perWrap);
                }
            }
        }
        catch(Exception e){
            //throw new MyException();
        }
        
        System.debug('lstWrapperObjectPermissions....'+lstWrapperObjectPermissions);
        return lstWrapperObjectPermissions;
    }
     
     /** Method      : For permission sets and profile 
* 
* Created By  : Rajnish Singh Chouhan, Ballary Neogy,Swarna Sekhar Das, Prashant Gupta.

* Description : To get the Access Permissions of Profile and Permission Sets.
**/
    @AuraEnabled
    public static List<PermissionWrapper> getPermssionForAllObject(String wrapperData , String permissionType){
        System.debug('PermissionType'+permissionType);
        System.debug('wrapperData' + wrapperData);
        Set<String> objectApi = new Set<String>();
        Set<String> profileApi = new Set<String>();
        List<String> checkObject = new List<String>();
        List<PermissionWrapper> objectList = (List<PermissionWrapper>)JSON.deserialize(wrapperData, List<PermissionWrapper>.class);
        if(permissionType == 'Profile'){
        for(PermissionWrapper selectedObject :objectList){
            objectApi.add(selectedObject.objectApiName);
            profileApi.add(selectedObject.profileApiName);
        }
        }else{
            for(PermissionWrapper selectedObject :objectList){
            objectApi.add(selectedObject.objectApiName);
            profileApi.add(selectedObject.permissionSetApiName);
        }
        }
        System.debug(' objectList'+ objectList);
        
        List<PermissionWrapper> wraperList = new List<PermissionWrapper>();
        if(permissionType == 'Profile'){
            List<ObjectPermissions> objectPermissionList= [SELECT SobjectType,Parent.Profile.Name,PermissionsRead, PermissionsCreate, PermissionsEdit, PermissionsDelete,
                                                           PermissionsViewAllRecords, PermissionsModifyAllRecords FROM ObjectPermissions where SobjectType IN:objectApi And Parent.Profile.Name IN: profileApi];
            
            System.debug('objectPermission'+objectPermissionList);
            for(PermissionWrapper selectedObject :objectList){
                for(ObjectPermissions objpermsion: objectPermissionList ){
                    if(selectedObject.objectApiName == objpermsion.SobjectType && selectedObject.profileApiName == objpermsion.Parent.Profile.Name){
                        PermissionWrapper perWrap = new PermissionWrapper();
                        perWrap.typeOfComponent = 'Object';
                        perWrap.type = permissionType;
                        perWrap.objectLabel = selectedObject.objectLabel;
                        perWrap.objectApiName = selectedObject.objectApiName;
                        perWrap.profileLabel = selectedObject.profileLabel;
                        perWrap.profileApiName = selectedObject.profileApiName;
                        perWrap.isRedable = objpermsion.PermissionsRead;
                        perWrap.isEditable = objpermsion.PermissionsEdit;
                        perWrap.isCreatable = objpermsion.PermissionsCreate;
                        perWrap.isDeletable = objpermsion.PermissionsDelete;
                        perWrap.isAllReadable = objpermsion.PermissionsViewAllRecords;
                        perWrap.isModifiable = objpermsion.PermissionsModifyAllRecords;
                        wraperList.add(perWrap) ;
                        // System.debug('perWrap----'+perWrap);
                        
                    }
                }
            }
        }
        else{
            System.debug('Permission set'+objectApi+'==>'+profileApi);
            List<ObjectPermissions> objectPermissionList= [SELECT SobjectType,Parent.Name,PermissionsRead, PermissionsCreate, PermissionsEdit, PermissionsDelete,
                                                           PermissionsViewAllRecords, PermissionsModifyAllRecords FROM ObjectPermissions where SobjectType IN:objectApi And Parent.Name IN: profileApi];
            
            System.debug('objectPermission Permission'+objectPermissionList);
            for(PermissionWrapper selectedObject :objectList){
                for(ObjectPermissions objpermsion: objectPermissionList ){
                    if(selectedObject.objectApiName == objpermsion.SobjectType && selectedObject.permissionSetApiName == objpermsion.Parent.Name){
                        PermissionWrapper perWrap = new PermissionWrapper();
                        perWrap.type = permissionType;
                        perWrap.typeOfComponent = 'Object';
                        perWrap.objectLabel = selectedObject.objectLabel;
                        perWrap.objectApiName = selectedObject.objectApiName;
                        perWrap.permissionSetLabel = selectedObject.permissionSetLabel;
                        perWrap.permissionSetApiName = selectedObject.permissionSetApiName;
                        perWrap.isRedable = objpermsion.PermissionsRead;
                        perWrap.isEditable = objpermsion.PermissionsEdit;
                        perWrap.isCreatable = objpermsion.PermissionsCreate;
                        perWrap.isDeletable = objpermsion.PermissionsDelete;
                        perWrap.isAllReadable = objpermsion.PermissionsViewAllRecords;
                        perWrap.isModifiable = objpermsion.PermissionsModifyAllRecords;
                        wraperList.add(perWrap) ;
                        System.debug('List'+wraperList);
                    }
                }
            }
        }
        System.debug('wraperList--->'+wraperList);
        return wraperList;
    }    
    
     /* Method : For permission sets and profile of fields on selection of list Of Objects And Profiles Or Permissions .
* Created By : Divya Narayan Dubey 
* 				Kirti Chhatwani
*/
    @AuraEnabled
    public static List<PermissionWrapper> fieldPermissionSetterAsperObjects(String perWrappers , String fieldType , String permissionType ){
        System.debug('wraped data = '+perWrappers);
        System.debug('fieldType = '+fieldType);
        System.debug('permissionType = '+permissionType);
        List<PermissionWrapper> wrappedData = (List<PermissionWrapper>)JSON.deserialize( perWrappers , List<PermissionWrapper>.class );
        List<String> ObjectNames  =  new List<String>();
        List<String> permissionName = new List<String>();
        List<String> profileName = new List<String>();
        List<String> fields = new List<String>();
        
        for(PermissionWrapper wrap : wrappedData){
            if(!String.isBlank(wrap.objectApiName)){
                ObjectNames.add(wrap.objectApiName);
            }
            if(!String.isBlank(wrap.profileApiName)){
                profileName.add(wrap.profileApiName);
            }
            if(!String.isBlank(wrap.permissionSetApiName)){
                permissionName.add(wrap.permissionSetApiName);
                
            }
        }
        if(fieldType == 'Standard'){
            for(String objName : ObjectNames){
                List<PermissionWrapper> wrappedFields = retrieveFields(objName) ;
                for(PermissionWrapper wr : wrappedFields ){
                    fields.add( objName +'.' + wr.fieldApiName);
                }    
                
                
            }
        }
        if(fieldType == 'Custom'){
            for(String objName : ObjectNames){
                List<PermissionWrapper> wrappedFields = retrieveFieldsUsingMetaDataList(objName) ;
                for(PermissionWrapper wr : wrappedFields ){
                    fields.add(objName + '.' +wr.fieldApiName);
                }    
            } 
        }
        
        List<FieldPermissions> fieldPermission = new List<FieldPermissions>();
        if(permissionType == 'Profile' && profileName.size() > 0){
            fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType IN : objectNames
                               AND FIELD IN : fields AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name IN: profileName )] ;
            
        }        
        if(permissionType == 'Permission Sets' && permissionName.size() > 0){
            fieldPermission = [SELECT Field , Id , PermissionsRead , PermissionsEdit , Parent.Name, Parent.Profile.Name , sObjectType FROM FieldPermissions WHERE  sObjectType IN : objectNames
                               AND  parentId IN ( SELECT Id FROM PermissionSet WHERE PermissionSet.Name IN: permissionName) ] ;
            
        } 
        List<PermissionWrapper> returningPermissions = new List<PermissionWrapper>();
        for(FieldPermissions fp : fieldpermission ){
            PermissionWrapper pw = new PermissionWrapper();
            pw.isEditable = fp.PermissionsEdit;
            pw.isRedable =  fp.PermissionsRead ;
            pw.objectApiName = fp.SobjectType ; 
            pw.fieldApiName = fp.Field;
            pw.profileApiName = fp.Parent.Profile.Name ;
            pw.permissionSetApiName = fp.Parent.Name ;
            pw.type= permissionType;
            pw.typeOfComponent= 'Field';   
            returningPermissions.add(pw); 
        }
        System.debug('returningPermissions = ' + returningPermissions);
        return returningPermissions;    
    }
    
    /**
*  Created By		: 	Praveen Singh
*
*	Description 	:	Method for setting permissions of objects
*
*	Return type		:	String 
*
*	@args			:	String data (it will accept a List<PermissionWrapper> objects in stringfy format)
*
*	Revision Logs	: 	V_1.0 – Created
*
**/
    @auraEnabled
    public static String setPermissions(String data){
        
        String response = 'Started';
        
        //deserializing List<PermissionWrapper> from a string accepted as parameter
        List<PermissionWrapper> objects = (List<PermissionWrapper>)JSON.deserialize(data, List<PermissionWrapper>.class);
        
        Set<String> setOfObjectName = new Set<String>();
        
        Set<String> setOfPermissionName = new Set<String>();
        
        Set<String> setOfProfileName = new Set<String>();
        
        if(objects.size() >0){
            //storing API names of object, Profile and permission sets
            for(PermissionWrapper wp : objects){
                if(String.isNotBlank(wp.objectApiName))
                    setOfObjectName.add(wp.objectApiName);
                if(wp.type =='Profile'){
                    if(String.isNotBlank(wp.profileApiName))
                        setOfProfileName.add(wp.profileApiName);
                }
                if(wp.type =='Permission Set'){
                    if(String.isNotBlank(wp.permissionSetApiName))
                        setOfPermissionName.add(wp.permissionSetApiName);
                }
            }
            
            Map<Id, PermissionSet> ps = new Map<Id, PermissionSet>();
            //Fetch the permission set value
            if(setOfPermissionName.size() > 0)
                //fetching permissions from database
                ps = new Map<Id, PermissionSet>([select Id,Name, Label, IsCustom, PermissionsAssignPermissionSets FROM PermissionSet WHERE Name IN : setOfPermissionName]);
            
            Map<String, Id> mapPermissionName = new Map<String, Id>();
            
            for(PermissionSet pss : ps.values()){
                if(!mapPermissionName.containsKey(pss.Name))
                    mapPermissionName.put(pss.Name, pss.Id);
            }
            Map<Id, Profile> mapOfProfile = new Map<Id, Profile>();
            //Fetch the permission set value
            if(setOfProfileName.size() >0)
                //fetching profiles from database
                mapOfProfile = new Map<Id, Profile>([select Id,Name FROM Profile WHERE Name IN : setOfProfileName]);
            
            Map<String, Id> mapProfileName = new Map<String, Id>();
            
            for(Profile pss : mapOfProfile.values()){
                if(!mapProfileName.containsKey(pss.Name))
                    mapProfileName.put(pss.Name, pss.Id);
            }
            
            List<ObJectPermissions> listObJectPermission;
            
            if(mapOfProfile != null){
                Map<Id, PermissionSet> psTemp = new Map<Id, PermissionSet>([select Id,Name, Label, Profile.Name FROM PermissionSet WHERE ProfileId IN : mapOfProfile.keySet()]);
                
                mapProfileName = new Map<String, Id>();
                for(PermissionSet pss : psTemp.values()){
                    if(!mapProfileName.containsKey(pss.Profile.Name))
                        mapProfileName.put(pss.Profile.Name, pss.Id);
                }
                //Fetch the objectPermission record
                listObJectPermission = [SELECT id, SobjectType, ParentId FROM ObJectPermissions WHERE ParentId IN: psTemp.keySet() AND SobjectType IN: setOfObjectName];
                
                //Check that there listOfObject have value or not
                if(listObJectPermission.size() > 0){
                    try {
                        //deleting previous permissions
                        delete listObJectPermission;
                        response = 'success';
                    }
                    catch(Exception e){
                        response = e.getMessage();
                    }
                }
            }
            
            if(ps != null){
                
                //Fetch the objectPermission record
                listObJectPermission = [SELECT id, SobjectType, ParentId FROM ObJectPermissions WHERE ParentId IN: ps.keySet() AND SobjectType IN: setOfObjectName];
                
                //Check that there listOfObject have value or not
                if(listObJectPermission.size() > 0){
                    try {
                        //deleting previous permissions
                        delete listObJectPermission;
                        response = 'success';
                    }
                    catch(Exception e){
                        response = e.getMessage();
                    }
                }
            }
            
            Map<String, ObJectPermissions> newMapOfPermissions = new Map<String, ObJectPermissions>();
            
            for(PermissionWrapper obWrapperObject : objects) {
                                
                if(obWrapperObject.type =='Permission Set'){
                    if(String.isNotBlank(obWrapperObject.permissionSetApiName)){
                        //adding new permissions in list
                        ObjectPermissions newPermission = new ObJectPermissions(ParentId = mapPermissionName.get(obWrapperObject.permissionSetApiName), 
                                                                                SobjectType = obWrapperObject.objectApiName, PermissionsCreate = obWrapperObject.isCreatable, 
                                                                                PermissionsRead = obWrapperObject.isRedable, PermissionsEdit = obWrapperObject.isEditable, 
                                                                                PermissionsDelete = obWrapperObject.isDeletable, PermissionsViewAllRecords = obWrapperObject.isAllReadable,
                                                                                PermissionsModifyAllRecords = obWrapperObject.isModifiable);
                        
                        newMapOfPermissions.put(obWrapperObject.objectApiName+'+'+obWrapperObject.permissionSetApiName,newPermission);
                    }
                }
                if(obWrapperObject.type =='Profile'){
                    if(String.isNotBlank(obWrapperObject.profileApiName)){
                        //adding new permissions in list
                        ObjectPermissions newPermission = new ObJectPermissions(ParentId = mapProfileName.get(obWrapperObject.profileApiName), 
                                                                                SobjectType = obWrapperObject.objectApiName, PermissionsCreate = obWrapperObject.isCreatable, 
                                                                                PermissionsRead = obWrapperObject.isRedable, PermissionsEdit = obWrapperObject.isEditable, 
                                                                                PermissionsDelete = obWrapperObject.isDeletable, PermissionsViewAllRecords = obWrapperObject.isAllReadable, 
                                                                                PermissionsModifyAllRecords = obWrapperObject.isModifiable);
                        
                        newMapOfPermissions.put(obWrapperObject.objectApiName+'+'+obWrapperObject.profileApiName,newPermission);
                        
                    }
                }
            }
            try {
                // inserting new permissions
                insert newMapOfPermissions.values();
                response = 'success';
            }
            catch(Exception e){
                response = e.getMessage();
            }
        }
        return response;
    }
    
    /*
*  Created By		: Satyam
* 
* @ Description 	: This method returns map of Object and list of corresponding Fields
* 
* @  Args 			: JSON List<PermissionWrapper>
* 
* @ Return Type 	: Map<String, List<String>>
*/
    @auraEnabled 
    public static Map<String, List<String>> getMapOfObjectAndFields(String permissionWrapper){
        List<PermissionWrapper> permissions = (List<PermissionWrapper>)JSON.deserialize(permissionWrapper, List<PermissionWrapper>.class);
        
        Map<String, List<String>> mapObjectAndFields = new Map<String, List<String>>();
        
        for(PermissionWrapper permission : permissions ){
            if(mapObjectAndFields.keySet().contains(permission.objectApiName)){ 
                mapObjectAndFields.get(permission.objectApiName).add(permission.fieldApiName);
            }
            else{
                mapObjectAndFields.put(permission.objectApiName, new List<String>{permission.fieldApiName});
            }
        }
        
        return mapObjectAndFields;
    }
    /**
	 * @ Author        :   Chitresh Bhargava And ShubhShree
	 * @description    :   This method is for generating Zip file for Deployment Package
	 * @args           :   String sessionId, List<PermissionWrapper> wrapperList
	 * @return         :   String
	 * @revision Logs  :   V_1.0   
 	**/
    @AuraEnabled 
    public Static String getRetrieveRequest(String sessionId, List<PermissionWrapper> wrapperList){
        
        System.debug('sessionId Aync ----> ' + sessionId);
        System.debug('wrapperList ----> ' + wrapperList);
        MetadataService.AsyncResult AsyncResult;
        
        // Map to store DataType as Key & its Value as List<String>
        Map<String,Set<String>> mapXmlBody = new Map<String,Set<String>>();
        
        Map<String,String> mapForProfileFullName = new Map<String,String>{'System Administrator'=>'Admin', 'Contract Manager' => 'ContractManager', 'Standard User'	=> 'Standard',
            														'Solution Manager' => 'SolutionManager', 'Read Only' => 'ReadOnly','Marketing User'  =>'MarketingProfile',
            														'Standard Platform User' => 'StandardAul','Customer Portal Manager'=>'CustomerManager', 
            														'High Volume Customer Portal' => 'HighVolumePortal','Partner User' => 'Partner', 
            														'Authenticated Website' => 'PlatformPortal','Chatter Free User' => 'Chatter Free User'};
           
	 // Check for WrapperList Size
        if(wrapperList.size() > 0){
            // Iterate PermissionWrapper List
            for(PermissionWrapper wrap : wrapperList) {
                // Fill Map as per the input received from UI
                // If typeOfComponent is Object then CustomObject used as Key and selected Objects as Values to List<String>
                if(wrap.typeOfComponent == 'Object') {
                    if(!mapXmlBody.containsKey('CustomObject')){
                        mapXmlBody.put('CustomObject', new Set<String>());
                    }
                    mapXmlBody.get('CustomObject').add(wrap.objectApiName);
                }
                
                // If typeOfComponent is Field then CustomField used as Key and selected Fields as Values to List<String>
               if(wrap.typeOfComponent == 'Field'){
                    if(!mapXmlBody.containsKey('CustomField')) {
                        mapXmlBody.put('CustomField', new Set<String>());
                    }
                    mapXmlBody.get('CustomField').add(wrap.fieldApiName);
                }
                
                // If type is Profile then Profile used as Key and selected profiles as Values to List<String>
               if(wrap.type == 'Profile') { 
                   if(wrap.profileApiName == 'System Administrator' || wrap.profileApiName == 'Contract Manager'||
                      wrap.profileApiName == 'Standard User' || wrap.profileApiName == 'Solution Manager' || 
                      wrap.profileApiName == 'Read Only' || wrap.profileApiName == 'Marketing User' || 
                      wrap.profileApiName =='Standard Platform User'|| wrap.profileApiName =='Customer Portal Manager' || 
                      wrap.profileApiName =='High Volume Customer Portal'|| wrap.profileApiName =='Partner User' || wrap.profileApiName == 'Authenticated Website' ) {
                       for(String str : mapForProfileFullName.keyset()) {
                           if(str == wrap.profileApiName) { 
                               wrap.profileApiName =  mapForProfileFullName.get(str);
                           }
                       }
                   }
                        if(!mapXmlBody.containsKey('Profile')) {
                           mapXmlBody.put('Profile', new Set<String>());
                    }
						mapXmlBody.get('Profile').add(wrap.profileApiName);
                 }   
             
                System.debug('map of custom profile ----> ' + mapXmlBody);
                
                // If type is PermissionSet then PermissionSet used as Key and selected Permissions as Values to List<String>
                 if(wrap.type == 'Permission Sets') {
                    if(!mapXmlBody.containsKey('Permission Sets')) {
                        mapXmlBody.put('PermissionSet', new Set<String>());
                    }
                    mapXmlBody.get('PermissionSet').add(wrap.permissionSetApiName);
                }
            }
        }
        
        Integer METADATA_API_VERSION = Integer.valueOf(new MetadataService.MetadataPort().endpoint_x.substringAfterLast('/')); 
        
        //Creating instance for metadataport. 
        
        MetadataService.MetadataPort service = new MetadataService.MetadataPort(); 
        
        service.SessionHeader = new MetadataService.SessionHeader_element(); 
        
        //session can be logged in user session or it can another instance session. 
        
        service.SessionHeader.sessionId = sessionId;
        
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest(); 
        
        retrieveRequest.apiVersion = METADATA_API_VERSION; 
        retrieveRequest.packageNames = null; 
        retrieveRequest.singlePackage = true; 
        retrieveRequest.specificFiles = null; 
        retrieveRequest.unpackaged = new MetadataService.Package_x(); 
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>(); 
        if(mapXmlBody.size() > 0){
            for(String component : mapXmlBody.keySet()) {
                MetadataService.PackageTypeMembers packageType = new MetadataService.PackageTypeMembers(); 
                packageType.name = component;
                //packageType.members = mapXmlBody.get(component);
                List<String> membersVal = new List<String>(mapXmlBody.get(component));
                packageType.members = membersVal;
                retrieveRequest.unpackaged.types.add(packageType);
            }
        }
        
        AsyncResult = service.retrieve(retrieveRequest);
        String asyncResultId = AsyncResult.Id;
        return asyncResultId;
    }
    /**
* @ Author        :   Chitresh Bhargava And Shubh Shree
* @description    :   This method is used to return the zip file
* @args           :   String idOfRetrieveResult , String sessionId
* @return         :   String
* @revision Logs  :   V_1.0   
**/
    @AuraEnabled 
    public Static String returnZipFile(String idOfRetrieveResult, String sessionId) {
        
        String downloadURL = 'nodata';
        Document d ;
        
        if(String.isNotBlank(idOfRetrieveResult)) {
            
            String asyncJobId = idOfRetrieveResult;
            MetadataService.MetadataPort service = new MetadataService.MetadataPort(); 
            service.SessionHeader = new MetadataService.SessionHeader_element(); 
            service.SessionHeader.sessionId = sessionId;
            MetadataService.RetrieveResult retrieveResult = service.checkRetrieveStatus(asyncJobId, true); 
            
            System.debug('retrieveResult-- > ' + retrieveResult);
            
            if(retrieveResult.done && retrieveResult.Status == 'Succeeded') {
                
                d = new Document();
                d.body = EncodingUtil.base64Decode(retrieveResult.zipFile);
                d.Name = 'DeploymentRoot';
                d.Type = 'zip';
                d.Folderid = UserInfo.getUserId();
                insert d;
                downloadURL = '/servlet/servlet.FileDownload?file='+ d.Id;
            }
        }
        
        System.debug(downloadURL);
        return downloadURL;
    }  
    /**
* @ Author        :   Chitresh Bhargava And Shubh Shree
* @description    :   This method is used to get session Id for vf page.
* @args           :   -
* @return         :   String
* @revision Logs  :   V_1.0   
**/
    @AuraEnabled
    public static String getUserSessionId(){
        String sessionId = '';
        
        // Refer to the Page
        PageReference reportPage = Page.VfGetSessionIdForMetadata;
        
        // Get the content of the VF page
        String vfContent = reportPage.getContent().toString();
        
        // Find the position of Start_Of_Session_Id and End_Of_Session_Id
        Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
            endP = vfContent.indexOf('End_Of_Session_Id');
        
        // Get the Session Id
        sessionId = vfContent.substring(startP, endP);
        
        // Return Session Id
        return sessionId;
    }
    
    
    
       
    /**
* @description    :   This method is used to update the field permission on button click.     
* @args           :   String,List,String.   
* @return         :   void     
* @revision Logs  :   V1.0 - Nikita Kumari - 12/08/2019- Created     
**/
    @AuraEnabled
    public static String setFieldPerrmissionUpdate(String objectName,  List<String> fields, List<String> permissionTypes, String permissionTypeName, String readEditVal ){
        //System.debug('objectName--->'+objectName+  'fields-------->'+fields+  'permissionTypes---->'+permissionTypes+  'permissionTypeName---->'+permissionTypeName+  'readEditVal--->'+readEditVal);
        String response ='';
        //try block
        try{
            //check values of variables 
            if(String.isNotEmpty(objectName) && fields.size() > 0 && permissionTypes.size() > 0 && String.isNotEmpty(permissionTypeName) && String.isNotEmpty(readEditVal)){
                
                //deserialize wrapper
                List<permissionWrapper> permissions = (List<permissionWrapper>)JSON.deserialize(readEditVal, List<permissionWrapper>.class);
                //System.debug('permissions'+permissions);
                
                Boolean readPermission ;
                Boolean editPermission ;
                for(permissionWrapper permission : permissions) {
                    readPermission = permission.isRedable;
                    editPermission = permission.isEditable;
                }
                List<FieldPermissions> fieldPermissionList = new List<FieldPermissions>();
                
                //get field details according profile or permission set names
                if(permissionTypeName == 'Profile')
                    fieldPermissionList = [SELECT Id, SobjectType, Field, PermissionsEdit, PermissionsRead FROM FieldPermissions WHERE SobjectType =: objectName AND 
                                           Field In: fields  and parentId in ( SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name =: permissionTypes)];
                else
                    fieldPermissionList = [SELECT Id, SobjectType, Field, PermissionsEdit, PermissionsRead FROM FieldPermissions WHERE SobjectType =: objectName AND 
                                           Field In: fields  and parentId in ( SELECT Id FROM PermissionSet WHERE PermissionSet.Name =: permissionTypes)];
                
                // check list size
                if(fieldPermissionList.size() > 0){
                    for(FieldPermissions fp : fieldPermissionList){
                        fp.PermissionsRead = readPermission;
                        fp.PermissionsEdit = editPermission;
                    }
                    // update list of field permission
                    update fieldPermissionList;
                }
                response ='success';
            }
        }Catch(Exception ex){
            System.debug('Error -' +ex.getMessage() +'Line Number -' +ex.getLineNumber());
            response = ex.getMessage();
        }
        return response;
    }
 
    
    
    //////
    
    
    // custom exception class 
    public class MyException extends Exception {}
}