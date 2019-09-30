/**
* Purpose      :  To send email to multiple contacts in a single time. 
* Created By   :  Shubh Shree Rathore
* Created Date :  06/09/2019
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 06/09/2019- Created
**/
public class MassEmail {
/**
* @description    :   This method is used to find the email folders of email type.
* @args           :   -  
* @return         :   Wrapper     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 06/09/2019- Created
*     
**/     
    @AuraEnabled 
    public static ContactWrapper folderPicklist () {
        ContactWrapper conWrap = new ContactWrapper();
        List<String> nameOfFolder = new List<String>();
        
        List<String> idOfFolder = new List<String>();
        for(Folder fol : [select Id,Name from Folder where Type ='Email']) {
            nameOfFolder.add(fol.Name);
            idOfFolder.add(fol.Id);
        } 
        nameOfFolder.add('Unifiled Public Classic Email Template');
        Id orgId = UserInfo.getOrganizationId();
        idOfFolder.add(orgId);
        nameOfFolder.add('My Personal Email Template');
        Id userId = UserInfo.getUserId();
        idOfFolder.add(userId);
        conWrap.folderName = nameOfFolder;
        conWrap.folderId = idOfFolder;
        return conWrap;
    }
/**
* @description    :   This method is used to find the email templates of a particular folder
* @args           :   Id (Folder Id)  
* @return         :   Wrapper     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 06/09/2019- Created
*     
**/    
    @AuraEnabled 
    public static ContactWrapper EmailTemplatePicklist (Id idsOfFolder) {
         ContactWrapper conWrap = new ContactWrapper();
        if(idsOfFolder != null ) {
            List<String> str = new List <String>();
            List<EmailTemplate> emailTemplates = [SELECT Id,Name,Subject,Body from EmailTemplate where EmailTemplate.FolderId = : idsOfFolder];
            for(EmailTemplate emailTemplate : emailTemplates) {
                conWrap.subject = emailTemplate.Subject;
                conWrap.body = emailTemplate.Body;
                conWrap.emailTempId = emailTemplate.Id;
                str.add(emailTemplate.Name);
            }
            conWrap.emailTempName = str;
        }
        return conWrap;
    }
/**
* @description    :   This method is used to find the body and subject of a particular Email Template.
* @args           :   String(name of Email template)  
* @return         :   Wrapper     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 06/09/2019- Created
*     
**/     
    @AuraEnabled 
    public static ContactWrapper selectedEmailTemplate(String nameOfEmailTemplate) {
        ContactWrapper conWrap = new ContactWrapper();
        if(String.isNotBlank(nameOfEmailTemplate)) {
            List<EmailTemplate> emailTemplates = [SELECT id,Name,Subject,Body, HTMLValue from EmailTemplate where name = : nameOfEmailTemplate];
            for(EmailTemplate emailTemplate : emailTemplates) {
                conWrap.subject = emailTemplate.Subject;
                if(emailTemplate.HtmlValue != null) {
                    conWrap.body = emailTemplate.HtmlValue;
                }
                else
                	conWrap.body = emailTemplate.Body;
            }
        }
        return conWrap;
    }
/**
* @description    :   This method is used to see the email with merged field .
* @args           :   String(Contact Id) , String(Account Id) ,List<String> (Subject and body of email template)
* @return         :   List<String>     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 06/09/2019- Created
*     
**/    
    @AuraEnabled 
    public static List<String> previewEmail(String conId, String accId,List<String> listToMerge) {
        List<String> returnBody = new List<String>();
        if(String.isNotBlank(conId) && listToMerge.size() > 0) {
            List<Messaging.RenderEmailTemplateBodyResult> mergedBody = Messaging.renderEmailTemplate(conId,accId,listToMerge);
            for(Messaging.RenderEmailTemplateBodyResult body : mergedBody) {
                returnBody.add(body.getMergedBody());
            }
            system.debug('return=>>>' +returnBody);
        }
        return returnBody;
    }
/**
* @description    :   This method is used to send the email template with merged field .
* @args           :   String(Contact Id) , String(subject) ,String (body)
* @return         :   String     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 06/09/2019- Created
*     
**/      
    @AuraEnabled
    public static String  sendEmails(String emailString, String subject ,String body) {
        List<String> listOfContacts = emailString.split(',');
       List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        String returnString = '';
     
        if(listOfContacts.size() > 0 && String.isNotBlank(subject) && String.isNotBlank(body)) {
            List<String> mergeStr = new List<String>();
            mergeStr.add(subject);
            mergeStr.add(body);
            for (Contact listOfEmail : [select id,LastName,Email ,AccountId from Contact where id In: listOfContacts]) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> result = MassEmail.previewEmail(String.valueOf(listOfEmail.id),String.valueOf(listOfEmail.AccountId), mergeStr);
                mail.setSubject(result[0]);
                mail.setHtmlBody(result[1]);
                mail.setReplyTo('shubhirathore22@gmail.com'); 
                mail.setSenderDisplayName('salesforce');
                mail.setToAddresses(new List<String>{listOfEmail.Email});
                mail.setSaveAsActivity(true);
                mails.add(mail);
                System.debug('Mail=>>' +mail);
            }
            Messaging.sendEmail(mails);
            returnString ='SUCCESS';
        }
        else 
             returnString = 'Error';
       
        return returnString;
     }
/**
* @description    :   This method is used to find all the contact .
* @args           :   String , String ,List<String> (Selected Contacts)
* @return         :   List<ContactWrapper>     
* @revision Logs  :   V1.0 - Shubh Shree Rathore  - 06/09/2019- Created
*     
**/      
    
    @AuraEnabled
    public static List<ContactWrapper> fetchLookUpValues(String searchKeyWord, List<String> selectedContact) {
        List<ContactWrapper> returnConWrapper = new List<ContactWrapper>(); 
        if(String.isNotBlank(searchKeyWord) ) {
            System.debug('List' +selectedContact);
            String ObjectName = 'Contact';
            
            FieldSetWrapper wrapIns = new FieldSetWrapper();
            //ContactWrapper contactWrapIns = new ContactWrapper();
            List<Schema.FieldSetMember> fields = SObjectType.Contact.FieldSets.ContactFieldSet.getFields();
            List<String> keySet =  new List <String> ();
            for(Schema.FieldSetMember f : fields) {
                keySet.add(f.getFieldPath());
            }
            wrapIns.fieldValue = keySet;
            system.debug('contacts'+ wrapIns.fieldValue);
            String tempInput = searchKeyWord ;
            String likeText = '\'' + String.escapeSingleQuotes(tempInput) + '%\'';
            String soqlStr =  'SELECT ' + String.join(keySet, ',') +' FROM Contact WHERE LastName LIKE ' + likeText +' AND Id NOT IN : selectedContact ORDER BY LastName ASC Limit 5'; 
            system.debug('soql' +soqlStr);
            
            List < Contact > lstOfRecords = Database.query(soqlStr);
            system.debug('soql' +lstOfRecords);
            for (Contact obj: lstOfRecords) {
                system.debug('soql' +obj);
                ContactWrapper contactWrapIns = new ContactWrapper();
                contactWrapIns.contactName  = obj.LastName;
               // contactWrapIns.fieldSetList = obj;
                contactWrapIns.contactId  = obj.Id;
                contactWrapIns.email  = obj.Email;
                returnConWrapper.add( contactWrapIns);
            }
        }
        return returnConWrapper;
    }
    public class ContactWrapper {
        @AuraEnabled public String contactName {get;set;}
        @AuraEnabled public String contactId {get;set;}
        @AuraEnabled public String email {get;set;}
        //@AuraEnabled public Contact fieldSetList {get;set;}
       // @AuraEnabled public FieldSetWrapper fieldSet {get;set;}
        @AuraEnabled public List<String> folderName{get;set;}
        @AuraEnabled public List<String> folderId{get;set;}
        @AuraEnabled public List<String> emailTempName{get;set;}
        @AuraEnabled public String subject{get;set;}
        @AuraEnabled public String body{get;set;}
        @AuraEnabled public String emailTempId{get;set;}
        
        //@AuraEnabled public List<OptionWrapper> folders {get; set;}
    }
    public class FieldSetWrapper {
        @AuraEnabled public List<String> fieldValue {get;set;}
        
    } 
    
   /* public class OptionWrapper {
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}
        
        public OptionWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }*/
}