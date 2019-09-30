/** Purpose: This class is used to call MetadataService Retrieve Method
 *
 * Created by: Chitresh Bhargava & Shubh Shree Rathore
 * 	
 * Created Date : 9-Aug-2019
 * 
 * Version : V1.0 Created
 * 
 * revision logs:V1.0 -  - 9-Aug-2019
 */

public class PackageXmlGeneratorApex {
    /**
	 * @description    :   This method is for generating Package.xml file
	 * @args           :   List
	 * @return         :   void
	 * @revision Logs  :   V_1.0   
	**/
    @AuraEnabled
    public static String getPackagexml(List<PermissionWrapper> wrapperList){
        system.debug('value='+wrapperList);
        // DownloadUrl assign Default Value
        String downloadURL = 'nodata';
        // Map to store DataType as Key (for Name in XML) & its Value as List<String> (for members in XML)
        Map<String,List<String>> mapXmlBody = new Map<String,List<String>>();
        //start try catch blog
        try{
            // Check for WrapperList Size
            if(wrapperList.size() > 0){
                // Iterate PermissionWrapper List
                for(PermissionWrapper wrap : wrapperList) {
                    // Fill Map as per the input received from UI
                    // If typeOfComponent is Object then CustomObject used as Key and selected Objects as Values to List<String>
                    if(wrap.typeOfComponent == 'Object') {
                        if(!mapXmlBody.containsKey('CustomObject')){
                            mapXmlBody.put('CustomObject', new List<String>());
                        }
                        mapXmlBody.get('CustomObject').add(wrap.objectApiName);
                    }
                    
                    // If typeOfComponent is Field then CustomField used as Key and selected Fields as Values to List<String>
                    else if(wrap.typeOfComponent == 'Field'){
                        if(!mapXmlBody.containsKey('CustomField')) {
                            mapXmlBody.put('CustomField', new List<String>());
                        }
                        mapXmlBody.get('CustomField').add(wrap.objectApiName+'.'+wrap.fieldApiName);
                    }
                    
                    // If type is Profile then Profile used as Key and selected profiles as Values to List<String>
                    if(wrap.type == 'Profile') { 
                        if(!mapXmlBody.containsKey('Profile')) {
                            mapXmlBody.put('Profile', new List<String>());
                        }
                        mapXmlBody.get('Profile').add(wrap.profileApiName);
                    }
                    
                    // If type is PermissionSet then PermissionSet used as Key and selected Permissions as Values to List<String>
                    else if(wrap.type == 'PermissionSet') {
                        if(!mapXmlBody.containsKey('PermissionSet')) {
                            mapXmlBody.put('Permission Set', new List<String>());
                        }
                        mapXmlBody.get('Permission Set').add(wrap.permissionSetApiName);
                    }
                }
                System.debug('hh='+mapXmlBody);
                //values for header of xml
                String startXml = '<?xml version="1.0" encoding="UTF-8"?>\n<Package xmlns="http://soap.sforce.com/2006/04/metadata">';
                String endXml = '<version>'+System.Label.XMLVersion+'</version></Package>';
                
                //map size Check
                if(mapXmlBody.size()>0){
                    // loop on map key set values  
                    for(String name : mapXmlBody.keySet()){
                        startXml += '<types>';
                        //loop on values of key
                        if(mapXmlBody.get(name) != Null){
                            
                            for(String memberName : mapXmlBody.get(name)){
                                startXml += '<members>'+memberName+'</members>';
                            }
                        }
                        startXml += '<name>'+name+'</name></types>';
                    }
                    startXml += endXml;
                    
                    //Convert it to a blob (Specified format required for xml file)
                    Blob xmlBody = Blob.valueOf(startXml); 
                    
                    //making a document of the package xml
                    Document   d = new Document();
                    d.body = xmlBody ;
                    d.Name = 'Package.xml';
                    d.Type = 'xml';
                    d.Folderid = UserInfo.getUserId();
                    insert d;
                    downloadURL = '/servlet/servlet.FileDownload?file='+ d.Id;
                }
            }
        }catch(Exception ex) {
            system.debug(ex.getMessage() +'   '+ ex.getLineNumber() + '   ' + ex.getStackTraceString());
        }
        // return Download URL: on that Package.xml file get downloaded
        return downloadURL;
    }
}