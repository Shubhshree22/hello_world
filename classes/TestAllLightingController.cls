/**
* This class contains unit tests for validating the behavior of Apex classes
and triggers.

*Unit tests are class methods that verify whether a particular piece
of code is working properly. Unit test methods take no arguments,
commit no data to the database, and are flagged with the testMethod
keyword in the method definition.

* All test methods in an organization are executed whenever Apex code is deployed
to a production organization to confirm correctness, ensure code
coverage, and prevent regressions. All Apex classes are
required to have at least 75% code coverage in order to be deployed
to a production organization. In addition, all triggers must have some code coverage.

* The @isTest class annotation indicates this class only contains test methods. Classes defined with the @isTest annotation do not count against
the organization size limit for all Apex scripts.

* See the Apex Language Reference for more information about Testing and Code Coverage. 

*   Description 	:   	This class is used to test the controller class used in lightning component
*
*   Created by      :   	Shubh Shree Rathore
*
*   Created Date    :   	02/07/2019
*
*   Revision Log    :  	    V_1.0 - Created
*
*	Coverage		: 	
**/

@isTest(SeeAllData=false)
private class TestAllLightingController {
    /* 
*	Description		:	This method used insert the data.
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/
    @testSetUp static void insertData() {
        
        List <House__c> house = new List<House__c>();
        List<Person__c> person = new List< Person__c>();
        List<Member__c> member = new List<Member__c>();
        List<Expense__c> expense = new List<Expense__c>();
        List<Expense__c> expenseMonthly = new List<Expense__c>();
        List<Expense_Item__c> expenseitem = new List<Expense_Item__c>();
        
        for( Integer i=0;i<10;i++){
            House__c houses = new House__c();
            houses.Name='TestHouse'+string.valueOf(i);
            houses.Address__c='Jaipur';
            houses.Email__c ='shubh@gmail.com';
            house.add(houses);
        }
        insert house;
        
        for( Integer i=0;i<10;i++){
            Person__c persons = new Person__c();
            persons.Name='TestPerson'+string.valueOf(i);
            persons.Birthday__c = system.today();
            person.add(persons);
        }
        insert person;
        
        for( Integer i=0;i<10;i++){
            Member__c members = new Member__c();
            members.Name='TestMember'+string.valueOf(i);
            members.House__c = house[0].Id;
            members.Person__c= person[0].Id;
            member.add(members);
        }
        insert member;
        
        for( Integer i=0;i<10;i++){
            Expense__c expenses = new Expense__c();
            expenses.Name='TestExpenseYearly'+string.valueOf(i);
            expenses.Type__c ='Yearly';
            expenses.Member__c= member[0].id;
            expense.add(expenses);
        }
        insert expense;
        
        for( Integer i=0;i<10;i++){
            Expense__c expenses = new Expense__c();
            expenses.Name='TestexpenseMonthly'+string.valueOf(i);
            expenses.Type__c ='Monthly';
            expenses.Yearly_Expense__c = expense[0].Id;
            expenseMonthly.add(expenses);
        }
        insert expenseMonthly;
        
        for( Integer i=0;i<10;i++){
            Expense_Item__c expenseItems = new Expense_Item__c();
            expenseItems.Date__c = system.today();
            expenseItems.Expense__c =expenseMonthly[i].Id;
            expenseItems.Bill_Number__c = string.valueOf(i);
            expenseItems.Description__c ='Test';
            expenseitem.add(expenseItems);
        }
        insert expenseitem;
        
        system.debug('---'+expenseitem);
        system.debug('Monthly Expense'+expenseMonthly);
        system.debug('---'+expense);
        system.debug('---'+member);
        system.debug('---'+person);
        system.debug('---'+house);
    } 
    /* 
*	Description		:	This method checks the functionality of House Detail page Controller class. 
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/
    @isTest static void testHouseDetailPage() {
        List<House__c> houseList = [SELECT Id,Name FROM House__c where Name Like 'TestHouse%'];
        List<Member__c> memberList = [SELECT Id,Name,House__c FROM Member__c where House__c =: houseList[0].id LIMIT 1 ];
        List<Expense__c> expenseYearlyList = [SELECT Id,Name,Member__c FROM Expense__c where Type__c= 'Yearly' AND Member__c=: memberList[0].id ];
        List<Expense__c> expenseMonthlyList = [SELECT Id, Name,Member__c FROM Expense__c WHERE Type__c='Monthly'  AND Yearly_Expense__c =: expenseYearlyList[0].id];
        List<Expense_Item__c> expenseItemList = [SELECT Id, Name,Date__c,Expense_Type__c,Description__c,Expense_Amount__c,Expense__c,Bill_Number__c,Approval_Status__c FROM Expense_Item__c  WHERE Expense__c =: expenseMonthlyList[0].id];
        
        //getDoInit method
        ResponeUtility members = HouseDetailPageController.getDoInit(houseList[0].Id);
        system.assertNotEquals(null,members);
        system.assertEquals(true,members.isSuccess);	
        system.assertEquals('success',members.status);
        system.assertNotEquals('abcd',members.message);
        //system.assertEquals(memberList,members.body);
        
        //getExpenseYearly method
        ResponeUtility expenseYearly = HouseDetailPageController.getExpenseYearly(memberList[0].Id);
        system.assertNotEquals(null,expenseYearly);
        system.assertEquals(true,expenseYearly.isSuccess);
        system.assertNotEquals('abcd',expenseYearly.message);
        system.assertEquals('success',expenseYearly.status);
        
        //getExpenseMonthly method
        ResponeUtility expenseMonthly = HouseDetailPageController.getExpenseMonthly(expenseMonthlyList[0].Id);
        system.assertNotEquals(null,expenseMonthly);
        system.assertEquals(true,expenseMonthly.isSuccess);
        system.assertNotEquals('abcd',expenseMonthly.message);
        system.assertEquals('success',expenseMonthly.status);
        
        //getExpenseItem method
        ResponeUtility expenseItem = HouseDetailPageController.getExpenseItem(expenseMonthlyList[0].id);
        system.assertNotEquals(null,expenseItem);
        system.assertEquals(true,expenseItem.isSuccess);
        system.assertNotEquals('abcd',expenseYearly.message);
        system.assertEquals('success',expenseYearly.status);
        
    } 
    /* 
*	Description		:	This method checks the functionality of House Controller class. 
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/
    @isTest static void testHouseController() {
        List<House__c> houseList = [SELECT Id,Name,Email__c,House_Owner__c,Address__c FROM House__c WHERE Name Like 'TestHouse%' order by CreatedDate desc LIMIT 5 ];
        HouseController.fetchHouse();
        system.assertNotEquals(null, houseList);
        
        String result = HouseController.saveRecords(houseList[0].Name  ,houseList[0].Email__c,houseList[0].House_Owner__C,houseList[0].Address__c);
        system.assertEquals('Success',result);
    }
/* 
*	Description		:	This method checks the functionality of house member wrapper display controller class. 
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/
    @isTest static void testHouseMemberWrapperDisplayController() {
        List<House__c> houseList = [SELECT Id,Name,Email__c,House_Owner__c,Address__c FROM House__c];
        List<Member__c> memberList = [SELECT Name,House__c,Person__c FROM Member__c where House__c =: houseList[0].id ];
        List<Person__c> personList = [SELECT Name,Phone__c,Email__c,Gender__c FROM Person__c ];
        List<Expense__c > expenseList = [SELECT Name,Type__c,Available_Balance__c,Approval_Status__c FROM Expense__c where Type__c ='Yearly'];
        List<Expense_Item__c> expenseItem =[SELECT Name,Expense_Amount__c,Approval_Status__c,Expense_Type__c FROM Expense_Item__c ];
        List<Configure_House__c> configureHouseList = [SELECT HouseTable__c,ExpenseItemTable__c,ExpenseTable__c,House_Owner__c,
                                                       Birthday__c,Anniversary__c,Inaugration_Date__c,MemberTable__c,PersonTable__c,This_Year_Balance__c,Total_Member__c 
                                                       FROM Configure_House__c];
        
        
        String result = HouseMemberWrapperDisplayController.createRecord(houseList[0]);
        system.assertNotEquals(null, houseList[0]);
        system.assertNotEquals('', houseList[0].Address__c);
        system.assertNotEquals('', houseList[0].Email__c);
        
        String results = HouseMemberWrapperDisplayController.createMemberRecord(memberList[0]);
        system.assertNotEquals(null, memberList[0]);
        system.assertNotEquals('', memberList[0].House__c);
        system.assertNotEquals('', memberList[0].Person__c);
        
        HouseMemberWrapperDisplayController.HouseMemberController hou = HouseMemberWrapperDisplayController.initMethod();
    }
    /* 
*	Description		:	This method checks the functionality of Dynamic fieldset 
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/    
    @isTest static void testContactFieldSet(){
        Contact con = new Contact();
        con.FirstName='ABC';
        con.LastName='test';
        insert con;
        
        Test.startTest();
        List<ContactFieldSet.ContactWrapper> newWrapper =  ContactFieldSet.getFieldSet('Contact','ContactFieldSet');
        system.assertNotEquals(null,newWrapper);
        
        List<ContactFieldSet.ContactWrapper> wrap = new  List<ContactFieldSet.ContactWrapper>();
        for(ContactFieldSet.ContactWrapper wrapper :newWrapper) {
            if(wrapper.FieldType =='Text') {
                wrapper.value ='abc';
                wrap.add(wrapper);
            }else if(wrapper.FieldType =='String') {
                wrapper.Value='Test';
                wrap.add(wrapper);
            }else if(wrapper.FieldType =='Email') {
                wrapper.Value='Test@gmail.com';
                wrap.add(wrapper);
            }
           }
        sObject newWrappers = ContactFieldSet.getRecords(wrap ,'Contact' );
        Test.stopTest();
        
    }   
}