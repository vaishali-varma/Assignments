 global with sharing class EmaiLHandlerForSearchEngine implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Email_Query_Junction__c emailQueryJunctionInstance = new Email_Query_Junction__c();
        Email_Receiver__c emailReceiverInstance = new Email_Receiver__c();
        Contact contactInstance = new Contact();
        list<Contact> contactEmail = [
            SELECT Email,Id 
              FROM Contact 
             WHERE Email = :envelope.fromAddress];
              
    /*To check if the contact already exists or not. 
      If it does not exist then add new contact else do not add.*/
        if(contactEmail.size() == 0)
        {
            contactInstance.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
            contactInstance.LastName = email.fromname.substring(email.fromname.indexOf(' '));
            contactInstance.Email = envelope.fromAddress;
            insert contactInstance;
        } 
        /*Checking the email subject and body to store the email body and 
          subject in the custom object : Email_Receiver__c*/
        if(string.isNotBlank(email.subject) && string.isNotBlank(email.plainTextBody) && string.isNotBlank(email.plainTextBody.substringBefore('Thank You')) && string.isNotBlank(email.plainTextBody.substringAfter('Goobleforce,')))
        {
            system.debug('@@@ In if of null checking ');
            result.success = true;
            list<Email_Receiver__c> emailReceiverListInstance = [ 
                SELECT Subject_Of_Email__c, 
                       Body_Of_Email__c,
                       Name
                  FROM Email_Receiver__c
                 WHERE Subject_Of_Email__c = :email.subject];
             system.debug('############# Records'+emailReceiverListInstance);
             
            if(emailReceiverListInstance.size() != 0)
            { 
                //Get the list of Email_Receiver__c if its empty then check if mail record exists.
                for(Email_Receiver__c emailInstance : emailReceiverListInstance)
                {
                        if(!(email.plainTextBody.equalsIgnoreCase(emailInstance.Body_Of_Email__c)) && 
                       !(email.fromname.substring(0,email.fromname.indexOf(' ')).equalsIgnoreCase(emailInstance.Name)))
                        { system.debug('################in if');
                            system.debug('################in if'+email.plainTextBody);
                            emailReceiverInstance.Name = email.fromname.substring(0,email.fromname.indexOf(' '));
                            emailReceiverInstance.Body_Of_Email__c = email.plainTextBody;
                            emailReceiverInstance.Subject_Of_Email__c = email.subject;
                            emailReceiverInstance.Email_Address__c = envelope.fromAddress;
                            system.debug('######### Email address : '+envelope.fromAddress);
                            emailReceiverInstance.Contact__c = contactInstance.Id;
                            system.debug('######## Contact : '+emailReceiverInstance.Contact__c);
                            insert emailReceiverInstance;
                        
                            emailQueryJunctionInstance.Email_Receiver__c = emailReceiverInstance.Id;
                            system.debug('####### emailQueryJunctionInstance1 : '+emailQueryJunctionInstance.Email_Receiver__c);
                        }
                }
            }
            else 
            {
                //If list is empty then add new records.
                system.debug('################in else');
                emailReceiverInstance.Name = email.fromname.substring(0,email.fromname.indexOf(' '));
                emailReceiverInstance.Body_Of_Email__c = email.plainTextBody;
                emailReceiverInstance.Subject_Of_Email__c = email.subject;
                emailReceiverInstance.Email_Address__c = envelope.fromAddress;
                for(Contact contactAlreadypresent : contactEmail)
                {system.debug('######## inside for of assign contact');
                    if(contactAlreadypresent.Email == envelope.fromAddress)
                    {system.debug('######## inside if of assign contact');
                        emailReceiverInstance.Contact__c = contactAlreadypresent.Id;
                    }
                }
            
                insert emailReceiverInstance;
                emailQueryJunctionInstance.Email_Receiver__c = emailReceiverInstance.Id;
                system.debug('####### emailQueryJunctionInstance2 : '+emailQueryJunctionInstance.Email_Receiver__c);
            }
        }
        else
        {
            system.debug('@@@@@@@@@@'+email.plainTextBody.substringBefore('Thank You'));
                        result.success = false;
                        result.message = 'Please send the email in specified format with subject and body and Please send the query between Goobleforce, and Thank You';
        }
        
        //Add query from body to new custom object QueryFromMail__c
        string getQueryFromBody = email.plainTextBody;
        if(string.isNotBlank(getQueryFromBody))
        { system.debug('@@@@@@@@@@'+email.plainTextBody.substringBefore('Thank You'));
            if(string.isNotBlank(getQueryFromBody.substringBefore('Thank You')) && string.isNotBlank(getQueryFromBody.substringAfter('Goobleforce,')) && string.isNotBlank(getQueryFromBody.substringBetween('Goobleforce,','Thank You')))
            {
                system.debug('@@@@@@@@@@ in second erreor message');
                result.success = true;
                system.debug('####### String query1 : '+getQueryFromBody);
        
                getQueryFromBody = getQueryFromBody.substringAfter('Goobleforce,');
                system.debug('####### String query2 : '+getQueryFromBody);
        
                getQueryFromBody = getQueryFromBody.substringBefore('Thank You');
                system.debug('####### String query3 : '+getQueryFromBody);
                getQueryFromBody = getQueryFromBody.trim();
                system.debug('###### String query4 : '+getQueryFromBody);
                list<QueryFromMail__c> queryList = [
                SELECT Name 
                  FROM QueryFromMail__c
                 WHERE Name = :getQueryFromBody];
               system.debug('######### QueryList'+queryList);
            
               if(queryList.size() == 0)
               {
                   QueryFromMail__c queryFromMailInstance = new QueryFromMail__c();
                   queryFromMailInstance.Name = getQueryFromBody;
                   queryFromMailInstance.Sender_Address__c = envelope.fromAddress; 
                   insert queryFromMailInstance;
                   emailQueryJunctionInstance.QueryFromMail__c = queryFromMailInstance.Id;
                   system.debug('####### emailQueryJunctionInstance3 : '+emailQueryJunctionInstance.QueryFromMail__c);
               }
               else
               {
                   for(QueryFromMail__c Instance : queryList)
                    {
                        emailQueryJunctionInstance.QueryFromMail__c = Instance.Id;
                        
                    }
                }
            }
            else
            {
                result.success = false;
                result.message = 'Please send the query between Goobleforce, and Thank You';
            }
            
        }
        insert emailQueryJunctionInstance;
        return result;
    }
}