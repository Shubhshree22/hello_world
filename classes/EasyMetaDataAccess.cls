public class EasyMetaDataAccess {
    
    @AuraEnabled
    public static List<String> customMetaDataRecords(){
        List<String> nameOfMetadata =  new List<String>();
        for( Metadata_Access__mdt metaDataItr:  [select MasterLabel from Metadata_Access__mdt ORDER BY MasterLabel ASC] ){
            nameOfMetadata.add(metaDataItr.MasterLabel);
        }
        return  nameOfMetadata;
    }
    
    @AuraEnabled 
    public static List<MetadataWrapper> retriveList(String searchKey,String typeOfMetadata) {
        try {
            if(String.isNotBlank(searchKey) && String.isNotBlank(typeOfMetadata)) {
                List<MetadataWrapper> metadataInsList=new List<MetadataWrapper>();
                if(typeOfMetadata == 'Apex Class') {
                    
                    for(ApexClass apexcls :[select Id,Name from ApexClass where Name LIKE : searchKey +'%' ORDER BY Name ASC ]) {
                        MetadataWrapper metadataIns = new MetadataWrapper();
                        metadataIns.label =apexcls.Name;
                        metadataIns.Value =apexcls.Id;
                        system.debug('apex class label=>  ' + metadataIns.label);
                        system.debug('apex class' + metadataIns.value);
                        metadataInsList.add( metadataIns);
                    }
                }
                
                if(typeOfMetadata == 'Apex Page') {
                    
                    for(ApexPage apexpg :[select id,Name from ApexPage where Name LIKE: searchKey +'%' ORDER BY name ASC ]) {
                        MetadataWrapper metadataIns = new MetadataWrapper();
                        metadataIns.label = apexpg.Name;
                        metadataIns.Value = apexpg.Id;
                        system.debug('apex class label=>  ' + metadataIns.label);
                        system.debug('apex class' + metadataIns.value);
                        metadataInsList.add( metadataIns);
                        
                    }
                }
                
                if(typeOfMetadata == 'Lightning Component') {
                    for(AuraDefinitionBundle cmp :[select Id, MasterLabel from AuraDefinitionBundle where MasterLabel LIKE: searchKey +'%' ORDER BY MasterLabel ASC ]) {
                        MetadataWrapper metadataIns = new MetadataWrapper();
                        metadataIns.label = cmp.MasterLabel;
                        metadataIns.Value = cmp.Id;
                        system.debug('apex class label=>  ' + metadataIns.label);
                        system.debug('apex class' + metadataIns.value);
                        metadataInsList.add( metadataIns);
                    }
                }
                if(typeOfMetadata == 'VF Component') {
                    
                    for(ApexComponent VfCmp :[select Id,Name from ApexComponent where Name LIKE: searchKey +'%' ORDER BY Name ASC ]) {
                        MetadataWrapper metadataIns = new MetadataWrapper();
                        metadataIns.label = VfCmp.Name;
                        metadataIns.Value = VfCmp.Id;
                        system.debug('VfCmp label=>  ' + metadataIns.label);
                        system.debug('VfCmp' + metadataIns.value);
                        metadataInsList.add( metadataIns);
                    }
                }
                if(typeOfMetadata == 'Static Resource') {
                    
                    for(StaticResource staticReItr :[SELECT Id,Name FROM StaticResource where Name LIKE: searchKey +'%' ORDER BY Name ASC ]) {
                        
                        MetadataWrapper metadataIns = new MetadataWrapper();
                        metadataIns.label = staticReItr.Name;
                        metadataIns.Value = staticReItr.Id;
                        system.debug('staticReItr label=>  ' + metadataIns.label);
                        system.debug('staticReItr' + metadataIns.value);
                        metadataInsList.add( metadataIns);
                    }
                }
                return metadataInsList;
            }
        } Catch (Exception ex){
            System.debug('Error' + ex.getMessage() +'Line Number' +ex.getLineNumber());
            
        }
        return null;
    }
    @auraEnabled 
    public static String MetadataUrl( Id metadataId, string metadataType){
        system.debug('String metadata' +metadataId +'metadataType' +metadataType);
        try { 
            if(metadataId != null && String.isNotBlank(metadataType)) {
                String urlForMetadata = URL.getSalesforceBaseUrl().toExternalForm();
                urlForMetadata+='/lightning/setup/';
                if(metadataType=='Apex Class'){
                    urlForMetadata += ' ApexClasses/page?address=%2F' + metadataId ;
                    system.debug(urlForMetadata);
                }
                if(metadataType=='Apex Page'){
                    urlForMetadata += 'ApexPages/page?address=%2F' + metadataId ;
                    system.debug(urlForMetadata);
                }
                if(metadataType=='VF Component'){
                    urlForMetadata += 'ApexComponents/page?address=%2F' + metadataId ;
                    system.debug(urlForMetadata);
                }
                if(metadataType=='Lightning Component'){
                    urlForMetadata += 'LightningComponentBundles/page?address=%2F' + metadataId ;
                    system.debug(urlForMetadata);
                } 
                if(metadataType=='Static Resource'){
                    urlForMetadata += 'StaticResources/page?address=%2F' + metadataId ;
                }
                return urlForMetadata;
            } 
        }Catch(Exception ex){
            System.debug('Error ' +ex.getMessage());  
        }
        return null;
    }
    
    @AuraEnabled
    public static String OpenCmpIndevConsole(Id auraId){
        String urlForMetadata = URL.getSalesforceBaseUrl().toExternalForm();
        urlForMetadata+='/_ui/common/apex/debug/ApexCSIPage?action=openFile&extent=AuraDefinition&';
        urlForMetadata+= 'AuraDefinitionBundleId='+auraId;
        urlForMetadata+='&DefType=COMPONENT&Format=XML';
         system.debug('url   '+urlForMetadata);
        return urlForMetadata;
       
    }
    
    public class MetadataWrapper {
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String value {get;set;}
    } 
}