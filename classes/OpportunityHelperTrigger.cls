/** Purpose: This Class is used to help the Opportunity Trigger.
*
* Created by: Shubh Shree Rathore
* 
* Created Date : 10-06-2019
* 
* Version : V.0 Created
* 
* revision logs:V1.0 -Shubh Shree Rathore - 10-06-2019
**/

public class OpportunityHelperTrigger {
/**
* @description    :   This method is used to check after the insertion of opportunity when stage is Shipped To Customer.
*     
* @args           :   Map 
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 10/06/2019- Created
*     
**/ 
    public static void stageShippedToCustomerInsertion(Map<ID,Opportunity> newMap) { 
        
        // Taking a map to hold records according to the Account and Opp Id
        Map<String, List<String>> mapOfAtds = new  Map<String,List<String>>();
        // Taking a map to hold unique records according to the Account and Opp Id
        Map<String, Set<String>> mapOfAtdsUnique = new  Map<String,Set<String>>();
        // Taking a map to hold duplicate records according to the Account and Opp Id
        Map<String, List<String>> mapOfAtdsDuplicate = new  Map<String,List<String>>();
        
        if(newMap.size() > 0)  {
            
            //Iteration on Opportunity for the newMap values.
            for(Opportunity Opp : newMap.values()) { 
            System.debug('-----' +opp);
            
           // Opportunity oldOpp = oldMap.get(opp.ID);
                
                //system.debug('---'+oldOpp);
                
                //Checking the Map that the opportunity stage should be Shipped To Customer and installation account should not be null
                
                if(opp.StageName =='Shipped To Customer' && opp.Installation_Account__c != NULL && 
                   (opp.Automobile_Tag_Details1__c != NULL || opp.Automobile_Tag_Details_2__c != NULL ||
                    opp.Automobile_Tag_Details_3__c != NULL)) {
                        
                        //checking for Automobile_Tag_Details1 if it is not null then we will put values in it
                        if(!mapOfAtds.containsKey(opp.id+'-'+opp.Installation_Account__c)) {
                            mapOfAtds.put(opp.id+'-'+ opp.Installation_Account__c, new List<String>());
                        }
                        //If the Automobile Tag Details are not null we will get values 
                        if(opp.Automobile_Tag_Details1__c != NULL)
                            mapOfAtds.get(opp.id+'-'+opp.Installation_Account__c).addAll(opp.Automobile_Tag_Details1__c.split('\n'));
                        
                        if(opp.Automobile_Tag_Details_2__c != NULL)
                            mapOfAtds.get(opp.id+'-'+opp.Installation_Account__c).addAll(opp.Automobile_Tag_Details_2__c.split('\n'));
                        
                        if(opp.Automobile_Tag_Details_3__c != NULL)
                            mapOfAtds.get(opp.id+'-'+opp.Installation_Account__c).addAll(opp.Automobile_Tag_Details_3__c.split('\n'));
                        
                    }
            }                                                                              
      }
        system.debug('All Atds Values=>' +mapOfAtds.values());
        
        
        //checking size of map 
        if(mapOfAtds.size() > 0) {
            
            //Iteration for the map ids
            for(String ids : mapOfAtds.Keyset())  {
                
                //Geting Values of mapOfAtds corresponding to a particular Id.
                for(String spliting : mapOfAtds.get(ids))  {
                    
                    if(String.isBlank(ids))
                        continue;
                    
                    //Declaring subStringvalues a string variable.
                    String subStringvalues;
                    
                    //checking the Size of the value if it is greater than 18 it should be truncate.
                    if(spliting.length() > 18) {
                        //value will truncate and trim till 18 will be store.
                        subStringvalues  = spliting.substring(0,18).trim();      
                    }
                    
                    else{
                        subStringvalues = spliting.trim();
                    }
                    String sub = subStringvalues.substring(0,3);
                    system.debug('truncate values'+subStringvalues);
                    
                    //checking the format of all substringvalues. 
                    if(subStringvalues!= null && (subStringvalues.startsWithIgnoreCase(FinalFormat.AUTO_SENSOR)|| 
                                                  subStringvalues.startsWithIgnoreCase(FinalFormat.AUTO_PRESENCE_SENSOR)||
                                                  subStringvalues.startsWithIgnoreCase(FinalFormat.AUTO_TDU) ||
                                                  (subStringvalues.substring(0,3).isNumeric() && subStringvalues.substring(3,4).equals('-')
                                                   && subStringvalues.substring(7,8).equals('-') 
                                                   && subStringvalues.substring(11,12).equals('-'))))
                        
                 	   { 
                        
                        //checking that the map having ids in it or not 
                        if(!mapOfAtdsUnique.containsKey(ids)) {
                            //putting ids in the unique set of map.
                            mapOfAtdsUnique.put(ids,new Set<String>());
                        }
                        if(!mapOfAtdsUnique.get(ids).contains(subStringvalues)){
                            mapOfAtdsUnique.get(ids).add(subStringvalues);
                        }
                        
                        else {
                            
                            //putting ids in the list of duplicate map.
                            if(!mapOfAtdsDuplicate.containsKey(ids)) {
                                mapOfAtdsDuplicate.put(ids,new List<String>());	
                            }
                            mapOfAtdsDuplicate.get(ids).add(subStringvalues);
                        }
                    }
                }
            }
        }
        system.debug('Unique value' +mapOfAtdsUnique.values());
        system.debug('Dupliacte value' +mapOfAtdsDuplicate.values());
        
        //Taking sboject list to hold every type of object list in a single   
        List<sObject> sobjrecords = new List<sObject>();
        
        //Taking unique map
        for(String str : mapOfAtdsUnique.keySet()) {
            List<String> listToHoldRec = new List<String>(mapOfAtdsUnique.get(str));
            
            system.debug('&&&&');
            //spiting the IDs with -
            List<String> listofIds = new List<String>(str.split('-'));
            
            for(String record : listToHoldRec) {
                //String  record1 = record.substring(0,3);
                //Checking for Auto sensor Records object
                if(record.startsWithIgnoreCase(FinalFormat.AUTO_SENSOR)) {
                    
                    sobjrecords.add(new Automobile_Sensor__c (name =record, Account__c = listofIds[1] , Opportunity__c = listofIds[0] ));
                    
                }
                //checking for AutomobilePresenceSensor object
                if(record.startsWithIgnoreCase(FinalFormat.AUTO_PRESENCE_SENSOR)) {
                   sobjrecords.add(new Automobile_Presence_Sensor__c (name =record,Account__c = listofIds[1] , Opportunity__c = listofIds[0] ));
                    // insert sobjrecords;
                }
                //checking for Automobile TDU cbject
                if(record.startsWithIgnoreCase(FinalFormat.AUTO_TDU)) {
                    sobjrecords.add(new Automobile_TDU__c (name =record, Account__c  = listofIds[1] , Opportunity__c = listofIds[0] ));
                } 
                //checking for Automobile Tag object
                if(record.substring(0,3).isNumeric() && record.substring(3,4).equals('-') && record.substring(7,8).equals('-') &&record.substring(11,12).equals('-')) {
                    sobjrecords.add(new Automobile_Tag__c (name =record, Account__c  = listofIds[1] , Opportunity__c = listofIds[0] ));     
                }
            }                       
        }
        
        system.debug('sobject list >>>>'+sobjrecords); 
        if(sobjrecords.size() > 0) {
            //Inserting records in database.
            Database.SaveResult[] sobjList =  database.insert(sobjrecords,false);
            for (Database.SaveResult sobj : sobjList) {
                if (sobj.isSuccess()) {
                    // Insertion is successful, so get the ID of the record that was processed
                    System.debug('Successfully inserterted' + sobj.getId());
                }
                else {
                    // Insertion is  failed, so get all errors                	
                    for(Database.Error err : sobj.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug( err.getMessage());
                        System.debug('On field: ' + err.getFields());
                    }
                }
            }
            
        }             	      	
    }     
/**
* @description    :   This method is used to check after the insertion of opportunity when there is updation in the records we are changing the format then also they insert in the object according to the pattern.
*     
* @args           :   Map 
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 14/06/2019- Created
*     
**/ 
    public static void stageshippedToCustomersisUpdated(Map<ID,Opportunity> newMap ,Map<Id,Opportunity> oldMap) { 
	
        // Taking a map to hold Ids
        Map<String, List<String>> mapOfAtds = new  Map<String,List<String>>();
        //Unique data to store in the map
        Map<String, Set<String>> mapOfAtdsUnique = new  Map<String,Set<String>>();
        // Duplicate data to store in the map
        Map<String, List<String>> mapOfAtdsDuplicate = new  Map<String,List<String>>();
        //set to store values of oldMap.
        
        if(newMap.size() > 0 && oldMap.size() >0)  {
            system.debug('11111111111111111111111');
            //Iteration on Opportunity for the newMap values.
            for(Opportunity opp : newMap.values()) {
                Opportunity oldOpp = oldMap.get(opp.ID);  
                
                //Checking the Map that the opportunity stage should be Shipped To Customer and installation account should not be null and Automobile_Tag_Details 1,2,3 cannot be same as old values.
                if(opp != oldOpp && oldOpp != NULL && opp.StageName =='Shipped To Customer' && 
                   opp.Installation_Account__c == oldOpp.Installation_Account__c && 
                   (opp.Automobile_Tag_Details1__c != oldOpp.Automobile_Tag_Details1__c  
                    || opp.Automobile_Tag_Details_2__c !=  oldOpp.Automobile_Tag_Details_2__c  
                    || opp.Automobile_Tag_Details_3__c != oldOpp.Automobile_Tag_Details_3__c ))   {
                 
                    //We are putting values in mapOfAtds which is inserting taking key as opportunity id And Installation_Account__c.Id 
                    if(!mapOfAtds.containsKey(opp.id+'-'+opp.Installation_Account__c)) {
                        
                        mapOfAtds.put(opp.id+'-'+opp.Installation_Account__c, new List<String>());
                    }
                    //checking for Automobile_Tag_Details 1,2,3 if it is not null then we will put values in it
                    
                    if(opp.Automobile_Tag_Details1__c != NULL)
                        mapOfAtds.get(opp.id+'-'+opp.Installation_Account__c).addAll(opp.Automobile_Tag_Details1__c.split('\n'));
                    if(opp.Automobile_Tag_Details_2__c != NULL)
                        mapOfAtds.get(opp.id+'-'+opp.Installation_Account__c).addAll(opp.Automobile_Tag_Details_2__c.split('\n'));
                    if(opp.Automobile_Tag_Details_3__c != NULL)
                        mapOfAtds.get(opp.id+'-'+opp.Installation_Account__c).addAll(opp.Automobile_Tag_Details_3__c.split('\n'));
                }
            }                      
        }
        //checking oldMap values 
       Set<String> oldvalues = new Set<String>();
        if(oldMap.size() >0) {
            //Itteration of OldMap values
            for(Opportunity oldOp : oldMap.values()) {
                //If oldMap values have Automobile_Tag_Details 1,2,3 and we to add them in a set
                if(oldOp.Automobile_Tag_Details1__c != NULL) {
                    oldvalues.addAll(oldOp.Automobile_Tag_Details1__c.split('\n'));
                }
                if(oldOp.Automobile_Tag_Details_2__c != NULL) {
                    oldvalues.addAll(oldOp.Automobile_Tag_Details_2__c.split('\n'));
                }
                if(oldOp.Automobile_Tag_Details_3__c != NULL) {
                    oldvalues.addAll(oldOp.Automobile_Tag_Details_3__c.split('\n'));
                }
            }
        }
         Set<String> subStringVal = new Set<String>();
                   for(String record :oldvalues ) {
                       //checking Length of the format if it is greater than the size we have to truncate and trim it.
                       if(record.length() > 18 ) {
                           subStringVal.add(record.subString(0,18).trim());
                       }
                       else{
                           subStringVal.add(record.trim()); 
                       }  
                   }
       system.debug('All Atds Values=>' +mapOfAtds.values());
        
       //checking size of map 
        if(mapOfAtds.size() > 0) {
            //Iteration for the map ids
            for(String ids : mapOfAtds.Keyset())  {
                
                //Geting Values of mapOfAtds corresponding to a particular Id.
                for(String spliting : mapOfAtds.get(ids))  {
                    
                    if(String.isBlank(ids))
                        continue;
                    
                    String subStringvalues;
                    //checking the Size of the value if it is greater than 18 it should be truncate.
                    if(spliting.length() > 18) {
                        //value will truncate and trim till 18 will be store.
                        subStringvalues  = spliting.substring(0,18).trim();      
                    }
                    else{
                        subStringvalues = spliting.trim();
                    }
                    
                    system.debug('truncate values'+subStringvalues);
                    //checking the format
                    if(subStringvalues!= null && (!subStringVal.contains(subStringvalues)) && 
                       (subStringvalues.startsWithIgnoreCase(FinalFormat.AUTO_SENSOR)|| 
                         subStringvalues.startsWithIgnoreCase(FinalFormat.AUTO_PRESENCE_SENSOR)||
                         subStringvalues.startsWithIgnoreCase(FinalFormat.AUTO_TDU) ||
                         (subStringvalues.substring(0,3).isNumeric() && subStringvalues.substring(3,4).equals('-')
                          && subStringvalues.substring(7,8).equals('-') && subStringvalues.substring(11,12).equals('-')))) {
                        
                   //checking that the map having ids in it or not 
                        if(!mapOfAtdsUnique.containsKey(ids)){
                            //putting ids in the unique set of map.
                            mapOfAtdsUnique.put(ids,new Set<String>());
                        }
                        if(!mapOfAtdsUnique.get(ids).contains(subStringvalues)){
                            mapOfAtdsUnique.get(ids).add(subStringvalues);
                        }
                        
                        else {
                            
                            //putting ids in the list of duplicate map.
                            if(!mapOfAtdsDuplicate.containsKey(ids)) {
                                mapOfAtdsDuplicate.put(ids,new List<String>());	
                            }
                            mapOfAtdsDuplicate.get(ids).add(subStringvalues);
                        }
                    }
                }
            }
         }
        system.debug('Unique value' +mapOfAtdsUnique.values());
        system.debug('Dupliacte value' +mapOfAtdsDuplicate.values());
        
        //Taking sboject list to hold every type of object list in a single   
        List<sObject> sobjrecords = new List<sObject>();
        
        //Taking unique map
        for(String str : mapOfAtdsUnique.keySet()) {
            List<String> listToHoldRec = new List<String>(mapOfAtdsUnique.get(str));
            
            //spiting the IDs with -
            List<String> listofIds = new List<String>(str.split('-'));
            
            for(String record : listToHoldRec) {
                //String  record1 = record.substring(0,3);
                //Checking for Auto sensor Records object
                if(record.startsWithIgnoreCase(FinalFormat.AUTO_SENSOR)) {
                   
                    sobjrecords.add(new Automobile_Sensor__c (name =record, Account__c = listofIds[1] , Opportunity__c = listofIds[0] ));
                    
                }
                //checking for AutomobilePresenceSensor object
                if(record.startsWithIgnoreCase(FinalFormat.AUTO_PRESENCE_SENSOR)) {
                  
                    sobjrecords.add(new Automobile_Presence_Sensor__c (name =record,Account__c = listofIds[1] , Opportunity__c = listofIds[0] ));
                    // insert sobjrecords;
                }
                //checking for AutomobileTDU
                if(record.startsWithIgnoreCase(FinalFormat.AUTO_TDU)) {
                    
                    sobjrecords.add(new Automobile_TDU__c (name =record, Account__c  = listofIds[1] , Opportunity__c = listofIds[0] ));
                } 
                //checking for Automobile_Tag
                if(record.substring(0,3).isNumeric() && record.substring(3,4).equals('-') && record.substring(7,8).equals('-') && record.substring(11,12).equals('-')) {
                    sobjrecords.add(new Automobile_Tag__c (name =record, Account__c  = listofIds[1] , Opportunity__c = listofIds[0] ));     
                }
            }                       
        }
        
        system.debug('sobject list >>>>'+sobjrecords); 
        if(sobjrecords.size() > 0) {
            //Inserting records in database.
            insert sobjrecords;
        } 
    }
    
    public static void stageShippedToCustomersisDeleted(Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap) {
        for(Opportunity opp : newMap.values()){
             Opportunity oldOpp = oldMap.get(opp.ID);
            if(oldOpp.StageName == 'shipped To Customer' && opp.stageName =='shipped To Customer' &&  opp.Shipment_Account__c != NULL && opp.Return_To_HQ__c != NULL &&
               (oldOpp.Automobile_Tag_Details1__c != null || oldOpp.Automobile_Tag_Details_2__c!=null || oldOpp.Automobile_Tag_Details_3__c!=null) &&
               opp.Installation_Account__c == oldOpp.Installation_Account__c ) {
                 
					  List<String> holdOldRec = new List<String>();
                   //checking Automobile tag detail 1,2,3 are not null and adding them to list
                   if(oldOpp.Automobile_Tag_Details1__c != NULL) {
                       holdOldRec.addAll(oldOpp.Automobile_Tag_Details1__c.split('\n'));
                   }
                   if(oldOpp.Automobile_Tag_Details_2__c != NULL) {
                       holdOldRec.addAll(oldOpp.Automobile_Tag_Details_2__c.split('\n'));
                   }
                   if(oldOpp.Automobile_Tag_Details_3__c != NULL) {
                       holdOldRec.addAll(oldOpp.Automobile_Tag_Details_3__c.split('\n'));
                   }  
                   
               }
        }
    }    
/**
* @description    :   This method is used to check when stage is Retrun to Head Quarter then the records on that Installation Account change to Shipment Account.
*     
* @args           :   Map , Map
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 13/06/2019- Created
*     
**/    
    public static void stageRetrunToHeadQuarter(Map<ID,Opportunity> holdingNewValuesInMap, Map<ID,Opportunity> holdingOldValuesInMap ) {
       
        //list to hold Automobile Sensor object Records
        List<Automobile_Sensor__c> recOfAutoSensor = new List<Automobile_Sensor__c>();
        //List to hold Automobile_Presence_Sensor Records
        List<Automobile_Presence_Sensor__c> recOfAutoPresenceSensor = new List<Automobile_Presence_Sensor__c>();
        //List to hold Automobile_Tag Records
        List<Automobile_Tag__c> recOfAutoTag = new List<Automobile_Tag__c>();
        //List to hold Automobile Tag Records
        List<Automobile_TDU__c>  recOfAutoTDU = new List<Automobile_TDU__c>();
        //List to hold Opportunity whose stage is Return To HQ
        List<String> recHavingStageReturnToHQ = new List<String>();
        //Map to hold all records  
        Map<String,Set<String>> mapToHoldOpp  = new  Map<String,Set<String>>();
        
        //Iteration on new list
        for(Opportunity newopp : holdingNewValuesInMap.values()) {
            System.debug('-----' +newopp);
             //Iteration on old list
            Opportunity oldOpp = holdingOldValuesInMap.get(newopp.ID);
            System.debug('--->'+oldOpp);
            
            //checking all the conditions to Update records when stage is updated.  
            if(oldOpp.StageName == 'shipped To Customer' && newopp.stageName=='Return To HQ' &&  newopp.Shipment_Account__c != NULL && newopp.Return_To_HQ__c != NULL &&
               (oldOpp.Automobile_Tag_Details1__c!=null || oldOpp.Automobile_Tag_Details_2__c!=null || oldOpp.Automobile_Tag_Details_3__c!=null) &&
               newopp.Installation_Account__c == oldOpp.Installation_Account__c ) {
                   
                   //Hold Records in one list  
                   List<String> holdRec = new List<String>();
                   //checking Automobile tag detail 1,2,3 are not null and adding them to list
                   if(oldOpp.Automobile_Tag_Details1__c != NULL) {
                       holdRec.addAll(oldOpp.Automobile_Tag_Details1__c.split('\n'));
                   }
                   
                   if(oldOpp.Automobile_Tag_Details_2__c != NULL) {
                       holdRec.addAll(oldOpp.Automobile_Tag_Details_2__c.split('\n'));
                   }
                   if(oldOpp.Automobile_Tag_Details_3__c != NULL) {
                       holdRec.addAll(oldOpp.Automobile_Tag_Details_3__c.split('\n'));
                   }
                   system.debug('--'+holdRec);
                   
                   //Declaring Variable
                   String subStringValues ;
                   for(String record :holdRec ) {
                       //checking Length of the format if it is greater than the size we have to truncate and trim it.
                       if(record.length() > 18 ) {
                           subStringValues = record.subString(0,18).trim();
                       }
                       else{
                           subStringValues = record.trim();
                       }  
                   }
                   //Comapring the subStringValues with the format they are matched then add them in the set.
                   Set<String> setOfAllNames = new Set<String>();
                   if(subStringValues!= null && (subStringValues.startsWithIgnoreCase(FinalFormat.AUTO_SENSOR)|| 
                                                 subStringValues.startsWithIgnoreCase(FinalFormat.AUTO_PRESENCE_SENSOR)||
                                                 subStringValues.startsWithIgnoreCase(FinalFormat.AUTO_TDU) ||
                                                 (subStringValues.substring(0,3).isNumeric() && subStringValues.substring(3,4).equals('-')
                                                  && subStringValues.substring(7,8).equals('-') 
                                                  && subStringValues.substring(11,12).equals('-'))))  {
                                                      setOfAllNames.add(subStringValues);
                                                  }
                   //If the field Return to Hq have some format in it then we are adding them in the list.
                   List<string> oppReturnToHq = new List<string>();
                        if (newOpp.Return_To_HQ__c!=null){
                       
                       oppReturnToHq .addAll(newOpp.Return_To_HQ__c.split('\n'));
                   }
                   else{
                       oppReturnToHq.add(newOpp.Return_To_HQ__c);
                   }
                   // we are truncating and trim the values of Return to HQ field.
                   for(Integer i=0; i<oppReturnToHq.size();i++) {
                            
                            if(oppReturnToHq[i].length() > 18) {
                                oppReturnToHq[i]=oppReturnToHq[i].subString(0,18).trim();
                            }
                            
                            else {
                                oppReturnToHq[i]=oppReturnToHq[i].trim();
                            }
                         }
                   system.debug('--'+oppReturnToHq);
                   
                   //we are comparing the Return To Hq fields data to the Automobile Tag details if they contains values from the automobile tag detail 1,2,3 then only we have to add them in list.
                   List<string> listsToCompare = new List<string>();
                   for(string str: oppReturnToHq){
                       if(setOfAllNames.contains(str)){
                           listsToCompare.add(str);
                       }
                   }
                   //Adding in the List
                   recHavingStageReturnToHQ.addAll(listsToCompare);
                   //Adding in the map acccording to the New opportunity Id
                   mapToHoldOpp.put(newOpp.Id,new Set<String>());
                   mapToHoldOpp.get(newOpp.Id).addAll(listsToCompare);
                   
                   system.debug('---'+recHavingStageReturnToHQ);
                   system.debug('---'+mapToHoldOpp);
               } 
             
   }
        
          //These loops will be used to change the Installation Account to Shipment Account
         for(Automobile_Sensor__c sensor : [Select id, name, opportunity__c, Account__c from Automobile_Sensor__c where Name IN : recHavingStageReturnToHQ]) {
            //Fecthing data for the Automobile_Sensor__c
            if(mapToHoldOpp.containsKey(sensor.opportunity__c) && mapToHoldOpp.get(sensor.opportunity__c).contains(sensor.name)) {
                sensor.Account__c = holdingNewValuesInMap.get(sensor.opportunity__c).Shipment_Account__c;
                recOfAutoSensor.add(sensor);
            }
        }
        system.debug('---'+recOfAutoSensor);
          //Fecthing data for the Automobile_Presence_Sensor
        for(Automobile_Presence_Sensor__c autoPreSensor : [Select id, name, opportunity__c, Account__c from Automobile_Presence_Sensor__c where Name IN : recHavingStageReturnToHQ]) {
            if(mapToHoldOpp.containsKey(autoPreSensor.opportunity__c) && mapToHoldOpp.get(autoPreSensor.opportunity__c).contains(autoPreSensor.name)) {
                autoPreSensor.Account__c = holdingNewValuesInMap.get(autoPreSensor.opportunity__c).Shipment_Account__c;
                recOfAutoPresenceSensor.add(autoPreSensor);
            }
        }
        system.debug('---'+recOfAutoPresenceSensor);
        
            //Fecthing data for the Automobile_TDU
        for(Automobile_TDU__c autoTDU : [Select id, name, opportunity__c, Account__c from Automobile_TDU__c where Name IN : recHavingStageReturnToHQ]) {
            if(mapToHoldOpp.containsKey(autoTDU.opportunity__c) && mapToHoldOpp.get(autoTDU.opportunity__c).contains(autoTDU.name)) {
                autoTDU.Account__c = holdingNewValuesInMap.get(autoTDU.opportunity__c).Shipment_Account__c;
                recOfAutoTDU.add(autoTDU);
            }
        }
        system.debug('---'+recOfAutoTDU);
        //Fetching data for the Automobile Tag
        for(Automobile_Tag__c autoTag : [Select id, name, opportunity__c, Account__c from Automobile_Tag__c where Name IN : recHavingStageReturnToHQ]) {
            if(mapToHoldOpp.containsKey(autoTag.opportunity__c) && mapToHoldOpp.get(autoTag.opportunity__c).contains(autoTag.name)) {
                autoTag.Account__c = holdingNewValuesInMap.get(autoTag.opportunity__c).Shipment_Account__c;
                recOfAutoTag.add(autoTag);
              }
        }
        // updating the records
        system.debug('---'+recOfAutoTag);
        if(recOfAutoSensor.size() > 0){
             update recOfAutoSensor;
        }
        system.debug('--'+recOfAutoSensor);
        
        if(recOfAutoPresenceSensor.size() > 0){
            update recOfAutoPresenceSensor;
        }
        
        if(recOfAutoTDU.size() > 0){
            update recOfAutoTDU;
        }
        
        if(recOfAutoTag.size() > 0){
            update recOfAutoTag;
        }
    }
    
/**
* @description    :   This method is used to check when stage is Retrun to  Customer then the records on that Shipment Account changed to Installation Account .
*     
* @args           :   Map , Map
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 13/06/2019- Created
*     
**/  
    public static void stageReturnToCustomer(Map<ID,Opportunity> holdingNewValuesInMap, Map<ID,Opportunity> holdingOldValuesInMap ) {
        //list to hold Automobile Sensor object Records
        List<Automobile_Sensor__c> recOfAutoSensor = new List<Automobile_Sensor__c>();
        //List to hold Automobile_Presence_Sensor Records
        List<Automobile_Presence_Sensor__c> recOfAutoPresenceSensor = new List<Automobile_Presence_Sensor__c>();
        //List to hold Automobile_Tag Records
        List<Automobile_Tag__c> recOfAutoTag = new List<Automobile_Tag__c>();
        //List to hold Automobile Tag Records
        List<Automobile_TDU__c>  recOfAutoTDU = new List<Automobile_TDU__c>();
        //List To Hold Opportunity whose stage is Return To HQ
        List<String> recHavingStageReturnToCustomer = new List<String>();
        //Map to Hold 
        Map<String,Set<String>> mapToHoldOpp  = new  Map<String,Set<String>>();
        
        //we will iterate on new list, which already holds the new values of all records.
        for(Opportunity newopp : holdingNewValuesInMap.values()) {
            System.debug('-----' +newopp);
            
            Opportunity oldOpp = holdingOldValuesInMap.get(newopp.ID);
            System.debug('--->'+oldOpp);
            
            If(oldOpp.StageName == 'Return To HQ' && newopp.stageName =='Return To Customer' &&  newopp.Shipment_Account__c != NULL && newopp.Return_To_HQ__c != NULL &&  newopp.Installation_Account__c != NULL
             && (oldOpp.Automobile_Tag_Details1__c!=null || oldOpp.Automobile_Tag_Details_2__c !=null || oldOpp.Automobile_Tag_Details_3__c !=null) &&
               newopp.Installation_Account__c == oldOpp.Installation_Account__c ) {
                   
                   //Hold Records in one list  
                   List<String> holdRec = new List<String>();
                   //Checking if the Automobile Tag detail 1,2,3 are not null
                   if(oldOpp.Automobile_Tag_Details1__c != NULL) {
                       holdRec.addAll(oldOpp.Automobile_Tag_Details1__c.split('\n'));
                   }
                   if(oldOpp.Automobile_Tag_Details_2__c != NULL) {
                       holdRec.addAll(oldOpp.Automobile_Tag_Details_2__c.split('\n'));
                   }
                   if(oldOpp.Automobile_Tag_Details_3__c != NULL) {
                       holdRec.addAll(oldOpp.Automobile_Tag_Details_3__c.split('\n'));
                   }
                   system.debug('--'+holdRec);
                   //Initialsed variable 
                   String subStringValues ;
                   //checking the length of the string if it is greater than 18 trunncate and trim it.
                   for(String record :holdRec ) {
                       
                       if(record.length() > 18 ) {
                           subStringValues = record.subString(0,18).trim();
                       }
                       else{
                           subStringValues = record.trim();
                       }  
                   }
                   //checking the records with the formatm if they are matched then add them in the set.
                   Set<String> setOfAllNames = new Set<String>();
                   if(subStringValues!= null && (subStringValues.startsWithIgnoreCase(FinalFormat.AUTO_SENSOR)|| 
                                                 subStringValues.startsWithIgnoreCase(FinalFormat.AUTO_PRESENCE_SENSOR)||
                                                 subStringValues.startsWithIgnoreCase(FinalFormat.AUTO_TDU) ||
                                                 (subStringValues.substring(0,3).isNumeric() && subStringValues.substring(3,4).equals('-')
                                                  && subStringValues.substring(7,8).equals('-') 
                                                  && subStringValues.substring(11,12).equals('-'))))  {
                                                      
                                                      setOfAllNames.add(subStringValues);
                                                  }
                   
                   //If the field Return To Hq is hold some pattern then split, truncate and trim them.
                   List<string> oppReturnToCus = new List<string>();
                   if (newOpp.Return_To_HQ__c!=null){
                       
                       oppReturnToCus .addAll(newOpp.Return_To_HQ__c.split('\n'));
                   }
                   else {
                       oppReturnToCus.add(newOpp.Return_To_HQ__c);
                   }
                   
                   for(Integer i=0; i<oppReturnToCus.size();i++) {
                            
                            if(oppReturnToCus[i].length() > 18) {
                                oppReturnToCus[i]=oppReturnToCus[i].subString(0,18).trim();
                            }
                            
                            else {
                                oppReturnToCus[i]= oppReturnToCus[i].trim();
                              }
                         }
                   system.debug('--'+oppReturnToCus);
                   
                   //This list is used to compare the return to hq field pattern with the Automobile Tag details. If they contains that then adding them in the list.
                   List<string> listsToCompare = new List<string>();
                   for(string str: oppReturnToCus){
                       if(setOfAllNames.contains(str)){
                           listsToCompare.add(str);
                       }
                   }
                   //Adding values in the list.
                   recHavingStageReturnToCustomer.addAll(listsToCompare);
                   //Adding values in the map according to the newOpp Ids
                   mapToHoldOpp.put(newOpp.Id,new Set<String>());
                   mapToHoldOpp.get(newOpp.Id).addAll(listsToCompare);
                   
                   system.debug('---'+recHavingStageReturnToCustomer);
                   system.debug('---'+mapToHoldOpp);
               } 
             
   }
        
          //These loops will be used to change the changed the Shipment Id to Installtion Id
         for(Automobile_Sensor__c sensor : [Select id, name, opportunity__c, Account__c from Automobile_Sensor__c where Name IN : recHavingStageReturnToCustomer]) {
             //Fetching the values of  Automobile Sensor
            if(mapToHoldOpp.containsKey(sensor.opportunity__c) && mapToHoldOpp.get(sensor.opportunity__c).contains(sensor.name)) {
                sensor.Account__c = holdingNewValuesInMap.get(sensor.opportunity__c).Installation_Account__c ;
                recOfAutoSensor.add(sensor);
            }
        }
        system.debug('---'+recOfAutoSensor);
        //Fetching the values of Automobile_Presence_Sensor__c
        for(Automobile_Presence_Sensor__c autoPreSensor : [Select id, name, opportunity__c, Account__c from Automobile_Presence_Sensor__c where Name IN : recHavingStageReturnToCustomer]) {
            if(mapToHoldOpp.containsKey(autoPreSensor.opportunity__c) && mapToHoldOpp.get(autoPreSensor.opportunity__c).contains(autoPreSensor.name)) {
                autoPreSensor.Account__c = holdingNewValuesInMap.get(autoPreSensor.opportunity__c).Installation_Account__c ;
                recOfAutoPresenceSensor.add(autoPreSensor);
            }
        }
        system.debug('---'+recOfAutoPresenceSensor);
        
        //Fetching the values of Automobile_TDU__c
        for(Automobile_TDU__c autoTDU : [Select id, name, opportunity__c, Account__c from Automobile_TDU__c where Name IN : recHavingStageReturnToCustomer]) {
            if(mapToHoldOpp.containsKey(autoTDU.opportunity__c) && mapToHoldOpp.get(autoTDU.opportunity__c).contains(autoTDU.name)) {
                autoTDU.Account__c = holdingNewValuesInMap.get(autoTDU.opportunity__c).Installation_Account__c ;
                recOfAutoTDU.add(autoTDU);
            }
        }
        system.debug('---'+recOfAutoTDU);
        //Fetching the values of Automobile_Tag__c
        for(Automobile_Tag__c autoTag : [Select id, name, opportunity__c, Account__c from Automobile_Tag__c where Name IN : recHavingStageReturnToCustomer]) {
            if(mapToHoldOpp.containsKey(autoTag.opportunity__c) && mapToHoldOpp.get(autoTag.opportunity__c).contains(autoTag.name)) {
                autoTag.Account__c = holdingNewValuesInMap.get(autoTag.opportunity__c).Installation_Account__c;
                recOfAutoTag.add(autoTag);
              }
        }
        
        //Updating the records.
        system.debug('---'+recOfAutoTag);
        if(recOfAutoSensor.size() > 0){
             update recOfAutoSensor;
        }
        system.debug('--'+recOfAutoSensor);
        
        if(recOfAutoPresenceSensor.size() > 0){
            update recOfAutoPresenceSensor;
        }
        
        if(recOfAutoTDU.size() > 0){
            update recOfAutoTDU;
        }
        
        if(recOfAutoTag.size() > 0){
            update recOfAutoTag;
        }
    }    
}