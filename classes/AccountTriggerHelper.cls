/**
* Purpose      :  To Help Trigger on Account Object
* 
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  20/08/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 20/08/2019- Created
* 
**/
public class AccountTriggerHelper {
    /**
* @description    :   This method is used to autopopulate the longest and shortest field when a user fills the number series field.
*					  This field should be autopopulate according to the largest series of number.
*     
* @args           :   List<Account> ,  Map<Id,Account>
*   
* @return         :   void
*      
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 20/08/2019- Created
*     
**/       
    
   public static  void autoPopulateLongestAndShortestSeries(list<Account> newAccounts,Map<Id,Account> mapOfOldAccounts){
         
 		for(Account acc : newAccounts){
            
            if(acc.Number_Series__c != null || acc.Number_Series__c != mapOfOldAccounts.get(acc.Id).Number_Series__c){
                
                List<String> splittedListString = acc.Number_Series__c.trim().split(' ');
                system.debug('List'+splittedListString);
                
                //List to hold splittedList converted into integer list
                List<Integer> splittedListInteger = new List<Integer>();
                
                //loop to convert splittedList to list of integer
                for(String str : splittedListString){
                    Integer val = Integer.valueOf(str);
                    splittedListInteger.add(val);
                }
                
                List<Integer> longestInt = new List<Integer>();
                List<Integer> shortestInt = new List<Integer>();
                List<Integer> listTempInt = new List<Integer>();
                
                for(Integer i=0 ; i < splittedListInteger.size() ; i++ ){
                    
                    if(i == 0){
                        listTempInt.add(splittedListInteger[0]);
                     }
                    else{
                        if(splittedListInteger[i-1] < splittedListInteger[i]){
                            
                            listTempInt.add(splittedListInteger[i]);
                            System.debug('Add = '+listTempInt);
                          }
                        else{
                            //Filling Longest
                            if(longestInt.size() < listTempInt.size() ){
                                if(longestInt.size() == 1){
                                    longestInt.addAll(listTempInt) ;
                                }
                                else{
                                    longestInt.clear();
                                    longestInt = new List<Integer>(listTempInt);
                                }
                            }
                            if(listTempInt.size() < shortestInt.size()){
                                shortestInt.clear();
                                shortestInt = new List<Integer>(listTempInt);
                            }
                            if(shortestInt.size() == 0){
                                shortestInt = new List<Integer>(listTempInt);
                            }
                            System.debug('Temp = '+ listTempInt );
                            listTempInt.clear();
                            listTempInt.add(splittedListInteger[i]);
                        }
                    }
                }
                
                //Strings to hold Longest and Shortest series
                String longestSeries = '';
                String shortestSeries = '';
                
                for(Integer val : longestInt){
                    longestSeries += String.valueof(val) + ' ';
                }
                
                for(Integer val : shortestInt){
                    shortestSeries += String.valueof(val) + ' ';
                }
               	acc.Longest_Series__c = longestSeries;
                acc.Shortest_Series__c = shortestSeries;
            }
        }
   }
}