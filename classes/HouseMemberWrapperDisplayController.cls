/**
* Purpose      :  It is a controller class used in lightning component.
* 
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  30/06/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 30/06/2019- Created
* 
**/

public class HouseMemberWrapperDisplayController {
    @AuraEnabled
    public static String createRecord(House__c house) {
        
        try {
            if(house !=NULL && String.isNotBlank(house.Address__c) && String.isNotBlank(house.Email__c)) {
                  insert house;
                 return 'Success';
            }
          } 
        catch(Exception ex) {
           return ex.getMessage();
        }
        return 'Success';
    }  
    @AuraEnabled
    public static String createMemberRecord(Member__c member){
         String msg ; 
        try{ 
            if(member !=NULL && String.isNotBlank(member.House__c) && String.isNotBlank(member.Person__c)) {
                 insert member;
                msg= 'Success';
            }
        }
       	             
        catch(Exception ex){
            system.debug(ex.getMessage());
            msg= ex.getMessage();
        }
        return msg;
    }
    
    @AuraEnabled
    public static HouseMemberController initMethod() {
        HouseMemberController returnwrapperClass = new  HouseMemberController();        
        returnwrapperClass.houseRec = [SELECT Name,Total_Balance__c,Address__c ,Email__c FROM House__c order by CreatedDate desc LIMIT 5 ];
        returnwrapperClass.memberRec = [SELECT Name,Birthday__c,Anniversary__c ,House__c,Person__c FROM Member__c order by CreatedDate desc LIMIT 5];
        returnwrapperClass.personRec = [SELECT Name,Phone__c,Email__c,Gender__c FROM Person__c ];
        returnwrapperClass.expenseRec = [SELECT Name,Type__c,Available_Balance__c,Approval_Status__c FROM Expense__c where Type__c ='Yearly'];
        returnwrapperClass.expenseItemRec = [SELECT Name,Expense_Amount__c,Approval_Status__c,Expense_Type__c FROM Expense_Item__c ];
        returnwrapperClass.customFields =[Select HouseTable__c,	ExpenseItemTable__c,ExpenseTable__c,House_Owner__c,
                                          Birthday__c,Anniversary__c,Inaugration_Date__c,MemberTable__c,PersonTable__c,This_Year_Balance__c,Total_Member__c 
                                          FROM Configure_House__c];
        
        for(Configure_House__c ins :returnwrapperClass.customFields ){
            returnwrapperClass.checkHouse = ins.HouseTable__c;
            returnwrapperClass.checkMember = ins.MemberTable__c;
            returnwrapperClass.checkPerson =ins.PersonTable__c;
            returnwrapperClass.checkExpense =ins.ExpenseTable__c;
            returnwrapperClass.checkExpenseItem =ins.ExpenseItemTable__c;
            returnwrapperClass.checkhousefield1 =ins.House_Owner__c;
            returnwrapperClass.checkhousefield2 =ins.Inaugration_Date__c;
            returnwrapperClass.checkhousefield3 =ins.Total_Member__c ;
            returnwrapperClass.checkhousefield4 =ins.This_Year_Balance__c;
            returnwrapperClass.checkmemberfield1 =ins.Birthday__c;
            returnwrapperClass.checkmemberfield2 =ins.Anniversary__c;
        }
        return returnwrapperClass; 
    }
    
    public class HouseMemberController {
        @AuraEnabled public List<House__c> houseRec{get;set;}
        @AuraEnabled public List<Member__c> memberRec{get;set;}
        @AuraEnabled public List<Person__c> personRec{get;set;}
        @AuraEnabled public List<Expense__c> expenseRec{get;set;}
        @AuraEnabled public List<Expense_Item__c> expenseItemRec{get;set;}
        @AuraEnabled public List<Configure_House__c> customFields{get;set;}
        @AuraEnabled public boolean checkHouse {get;set;}
        @AuraEnabled public boolean checkMember {get;set;}
        @AuraEnabled public boolean checkPerson {get;set;}
        @AuraEnabled public boolean checkExpense {get;set;}
        @AuraEnabled public boolean checkExpenseItem {get;set;}
        @AuraEnabled public boolean checkhousefield1 {get;set;}
        @AuraEnabled public boolean checkhousefield2 {get;set;}
        @AuraEnabled public boolean checkhousefield3 {get;set;}
        @AuraEnabled public boolean checkhousefield4 {get;set;}
        @AuraEnabled public boolean checkmemberfield1 {get;set;}
        @AuraEnabled public boolean checkmemberfield2 {get;set;}
    }
    
}