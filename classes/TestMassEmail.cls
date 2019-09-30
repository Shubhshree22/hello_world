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

*   Description 	:   	This class is used to test the mass email.
*
*   Created by      :   	Shubh Shree Rathore
*
*   Created Date    :   	06-09-2019
*
*   Revision Log    :  	    V_1.0 - Created
*
*	Coverage		: 	    
**/
@isTest
public class TestMassEmail {
    /* 
*	Description		:	This method used to insert Contact.
*
*	@argument		:	none
*
*	Revision Logs	: 	V_1.0 - Created
*/
    @testSetUp public static void createContact() {
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(LastName= 'Test1',Email= 'test1@gmail.com'));
        contacts.add(new Contact(LastName= 'Test2',Email= 'test2@gmail.com'));
        insert contacts;
        
    }
    @isTest public static void testmakeAccount(){
        Test.startTest();
        List<Contact> contacts = [select id ,LastName,Email,AccountId from Contact where LastName Like : 'T%'];
        List<String> folders = new List<String>();
        folders.add('New 1');
        folders.add('New 2');
        List<String> conIds = new List<String>();
        List<String> accIds = new List<String>();
       for(Contact con : contacts) {
            conIds.add(con.id);
            accIds.add(con.AccountId);
        }
        List<String> mergeString = new List<String>();
        mergeString.add('Hey');
        mergeString.add('testing your Name {!v.contactLastName}');
        
        List<String> emailTemplate = new List<String>();
        emailTemplate.add('Testing Custom');
        emailTemplate.add('Testing');
        
        MassEmail.ContactWrapper wrapper = new MassEmail.ContactWrapper();
        wrapper.contactName = contacts[0].LastName;
        wrapper.contactId = contacts[0].Id;
        wrapper.body = 'Template Body';
        wrapper.email = contacts[0].Email;
        wrapper.emailTempId = '00l2v000002C25rAAC';
        wrapper.emailTempName = emailTemplate;
        wrapper.folderId = folders ;
        wrapper.folderName = folders;
       
        MassEmail.fetchLookUpValues('T',new List<String>());
        MassEmail.EmailTemplatePicklist('00l2v000002C25rAAC');
        MassEmail.folderPicklist();
        MassEmail.selectedEmailTemplate(emailTemplate[0]);
        MassEmail.selectedEmailTemplate('Testing simple text');
        MassEmail.previewEmail(conIds[0], accIds[0], mergeString);
        MassEmail.sendEmails(conIds[0], mergeString[0], mergeString[1]);
        MassEmail.sendEmails(conIds[0], '', mergeString[1]);
        Test.stopTest();
    }   
}