global class CreateContactFrmEmail implements Messaging.InboundEmailHandler {
        
        global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
            
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            try {
                if(String.isNotBlank(email.plainTextBody) && email.plainTextBody.containsIgnoreCase('Email')) {
                    Map<String,String> mapOfEmailBody = new Map<String,String>();
                    String emailBody = email.plainTextBody ;
                    List<String> splittedBody = emailBody.split('\n');
                    String s1 = splittedBody.remove(0);
                    String s2 = splittedBody.remove(0);
                    String s3 = splittedBody.remove(0);
                    String s4 = splittedBody.remove(5);
                    for(String str: splittedBody) {
                        List<String> splitByHyphen = str.deleteWhitespace().split('-',2);
                        if(!mapOfEmailBody.containsKey((splitByHyphen[0])))
                            mapOfEmailBody.put(splitByHyphen[0], splitByHyphen[1].removeEnd('.'));
                    }
                    System.debug('split' +mapOfEmailBody);
                    String emailAddress = mapOfEmailBody.get('Email');
                    String userName = mapOfEmailBody.get('User Name');
                    String firstName = userName.substringBefore(' ');
                    String lastName = userName.substringAfter(' ');
                    
                    List<Lead__c> leadRecords = [select id,Email__c,BOH_User__c From Lead__c where Email__c = : emailAddress ]; 
                    
                    if(leadRecords.size() > 0) {
                        for(Lead__c leadRecord :leadRecords) {
                            leadRecord.BOH_User__c = mapOfEmailBody.get('User Id') ;
                        }
                        update leadRecords ;
                    }
                    else {
                        System.debug('In lead' );
                        Lead__c lead = new Lead__c();
                        lead.Name = lastName;
                        lead.BOH_User__c =  mapOfEmailBody.get('User Id');
                        //lead.Account_Type__c =accountType;
                        System.debug('In lead'+ lead.BOH_User__c);
                        lead.Email__c = emailAddress;
                        System.debug('In lead'+ lead.Email__c);
                        lead.FirstName__c = firstName;
                        System.debug('In lead'+ lead.FirstName__c);
                        System.debug('lead' +lead.Name);
                        insert lead ;
                    }
                    result.success = true;
                }
            }Catch(Exception ex) {
                result.success = false;   
            }
            return result;
        }
        
    }