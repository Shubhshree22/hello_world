/**
* Purpose      :  It is a controller class used in lightning component.
* 
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  28/06/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 28/06/2019- Created
* 
**/

public class HouseController {
/**
* @description    :	This method is used to fetch the data of house of five top created.
*     
* @args           :	None
*   
* @return         :	list  list of house
*      
* @revision Logs  :	V1.0 - Shubh Shree Rathore  - 28/06/2019- Created
*     
**/      
  @AuraEnabled
    public static List<House__c> fetchHouse(){
        return [SELECT Name,House_owner__c,Address__c ,Email__c FROM House__c order by CreatedDate desc LIMIT 5  ];
    }
/**
* @description    :	This method is used to save the records.
*     
* @args           :	String
*   
* @return         :	String
*      
* @revision Logs  :	V1.0 - Shubh Shree Rathore  - 28/06/2019- Created
*     
**/    
    
    @AuraEnabled
    public static String saveRecords(String houseName,String houseEmail,String houseOwner,String houseAddress) {
        
        House__c house = new House__c();
        house.Name = houseName;
        house.Email__c = houseEmail;
        house.House_owner__c = (Id)houseOwner;
        house.Address__c = houseAddress;
        insert house;
        return 'Success'; 
    }
    
}