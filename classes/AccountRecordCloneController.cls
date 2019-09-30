/** Purpose: This Class is used as a Controller used in FieldSet Component.
*
* Created by: Shubh Shree Rathore
* 
* Created Date : 04-07-2019
* 
* Version : V.0 Created
* 
* revision logs:V1.0 -Shubh Shree Rathore -  04-07-2019
**/

public with sharing class  AccountRecordCloneController {
/**
* @description    :	This method is used to clone account and contact records.
*     
* @args           :	Id
*   
* @return         :	void
*      
* @revision Logs  :	V1.0 - Shubh Shree Rathore  - 04/07/2019- Created
*     
**/
    @AuraEnabled public static void  cloneAccountRecord(Id accId)   {
       
        Schema.DescribeSObjectResult acc = Account.sObjectType.getDescribe(); 
        Schema.DescribeSObjectResult con = Contact.sObjectType.getDescribe(); 
        String  objName = acc.getName();
        String soqlacc = 'SELECT ' ;
        String soqlcon = 'SELECT ' ;
        
        for(string apiName : acc.fields.getMap().keySet()) {
            soqlacc += apiName + ',';
        }
        for(string apiName : con.fields.getMap().keySet()) {
            soqlcon += apiName + ',';
        }
        
        soqlacc = soqlacc.removeEnd(',') + ' FROM '+objName +' WHERE ID = \'' + accId +'\'' ;
        soqlcon = soqlcon.removeEnd(',') + ' FROM CONTACT WHERE AccountId = \'' + accId + '\'' ;
        
        
        Account record = Database.query(soqlacc);
        Account accounrec = record.clone();
        accounrec.Name = ('Clone-' +record.Name).left(80);
        insert accounrec ;
        
        List<Contact> cons = Database.query(soqlcon);
        List<Contact> cont = new List<Contact>();
        for(Contact c : cons)  {
            Contact conCopy = c.clone(false,true);
            conCopy.AccountId = accounrec.Id;
            conCopy.FirstName = ('Clone-'+c.FirstName).left(80);
            cont.add(conCopy);
        }
        insert cont;
        system.debug('record'+cont);
    }
}