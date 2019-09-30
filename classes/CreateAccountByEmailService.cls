/**
* Purpose      :  It is a class used to insert object by email service
* 
* Created By   :  Shubh Shree Rathore
* 
* Created Date :  18/07/2019
* 
* Revision Logs:  V1.0 -  Shubh Shree Rathore - 18/07/2019- Created
* 
**/
global class CreateAccountByEmailService implements Messaging.InboundEmailHandler {
    /**
* @description    :	This method is used to create account and contact on the basis of the email text body.
*     
* @args           :	Messaging.inboundEmail , Messaging.InboundEnvelope 
*   
* @return         :	Messaging.inboundEmail
*      
* @revision Logs  :	V1.0 - Shubh Shree Rathore  - 18/07/2019- Created
*     
**/  
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope envelop){ 
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
  
        List<Contact> con = new List<Contact>();
        List<String> toConvertList = new List<String>();
        //Finding String between this string.
        String actualFormatValue = email.plainTextBody.substringBetween('Account Details:Start','Account Details:End');
        //Splitting the string by new Value.
        List<String> splitFormatValue = actualFormatValue.split('\n');
        
        Map<String,String> mapOfStrings = new Map<String,String>();
        //put values in the map according to the string before the colon. 
        for(Integer i =0 ;i<splitFormatValue.size();i++) {
            if(!mapOfStrings.containsKey(splitFormatValue[i].subStringBefore(':'))) {
                mapOfStrings.put(splitFormatValue[i].subStringBefore(':').trim(), splitFormatValue[i].substringAfter(':').trim());
                system.debug('Final String' +mapOfStrings);
            }
        }
        Account acc = new Account();
        acc.Name = mapOfStrings.get('Name');
        acc.Website = mapOfStrings.get('Website');
        acc.Industry = mapOfStrings.get('Industry');
        acc.Description= email.plainTextBody;
        // acc.BillingCity = mapOfStrings.get('Billing Address');
        try {
            if(acc != null) {
                 List<Account> accountsAlreadyInserted = [SELECT ID,Name from Account WHERE name =:acc.Name];
                if(accountsAlreadyInserted.size()> 0) {
                    acc.Id= accountsAlreadyInserted[0].Id;
                }
                upsert acc;
                system.debug('contacts' +acc);
                if (email.binaryAttachments != null && email.binaryAttachments.size()> 0) {
                    
                    
                    List<Attachment> attachments = new List<Attachment>();
                    for (Integer count = 0 ; count < email.binaryAttachments.size(); count++) {
                        Attachment attachment = new Attachment();
                        attachment.ParentId = acc.Id;
                        attachment.Name = email.binaryAttachments[count].filename;
                        attachment.body = email.binaryAttachments[count].body;
                        
                        if(email.binaryAttachments[count].filename.equals('Related Contact Details.csv')) {
                            system.debug('Name matched');
                            attachment.ParentId = acc.Id;
                            attachment.Name = email.binaryAttachments[count].filename;
                            Blob cssFormat = email.binaryAttachments[count].body;
                            String toConvert = cssFormat.toString();
                            system.debug('toConvert....'+toConvert);
                            //attachment.body = toConvert;
                            toConvertList.addAll(toConvert.split('\n'));
                            system.debug('with out loop toConvertList...'+toConvertList);
                            
                            for(Integer i = 1 ; i< toConvertList.size(); i++) {
                                system.debug('With loop '+i +'=>'+toConvertList[i]);
                            }
		                            
                            for(Integer i = 1 ; i< toConvertList.size(); i++){
                                String[] holdString = new String[]{};
                                    holdString = toConvertList[i].split(',');
                                system.debug('holdString....'+holdString);
                                Contact contacts= new Contact();
                                contacts.FirstName = holdString[0];
                                contacts.LastName = holdString[1];
                                contacts.Email = holdString[2];
                                contacts.Phone = holdString[3];
                                con.add(contacts);
                                system.debug('con' +con);
                            }
                            attachments.add(attachment);
                           System.debug('Values' +attachments);
                        }
                        else{
                            attachment.ParentId = acc.Id;
                            attachment.Name = email.binaryAttachments[count].filename;
                            attachment.body = email.binaryAttachments[count].body;
                            attachments.add(attachment);
                        }
                     
                    }
                    
                    if(con.size() > 0)  
                        insert con;
                    
                    if(attachments.size() > 0) {
                        insert attachments;
                    } 
                }
            }
        }
        catch(Exception ex) {
            system.debug('Error'+ex);
        } 
        return null;
    }
    
}