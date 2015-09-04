 public with sharing class BatchForResponseFromGoogle implements Database.Batchable<sObject>,Database.Stateful{

    /*Gets the id from the junction object of email object and query object*/
    public Database.querylocator start(Database.BatchableContext BC)
    {  
        String query = 'SELECT Email_Receiver__r.Contact__c,QueryFromMail__c FROM Email_Query_Junction__c WHERE CreatedDate = TODAY';
        return Database.getQueryLocator(query);  
    } 
/*------------------------------------------------------------------------------------------------------*/
    /*This method sets the contact Id and the query Id in the visualforce template 
      which further passes the query to the component */
    public void Execute(Database.BatchableContext BC ,list<Email_Query_Junction__c> searchResultList)
    {   Messaging.SingleEmailMessage[] emails = new list<Messaging.SingleEmailMessage>();
        system.debug('##############searchResultList'+searchResultList);
        for(Email_Query_Junction__c instance : searchResultList)
        {
            system.debug('@@@@@@@ COntact Id : '+instance.Email_Receiver__r.Contact__c);
            system.debug('@@@@@@ instance.QueryFromMail__c '+instance.QueryFromMail__c);
            
            Messaging.SingleEmailMessage emailInstance = new  Messaging.SingleEmailMessage();
            Id templateId =  [select id, name from EmailTemplate where Name = 'Response Template'].id; 
            emailInstance.setTargetObjectId(instance.Email_Receiver__r.Contact__c);
            emailInstance.setWhatId(instance.QueryFromMail__c);
            emailInstance.setTemplateId(templateId);
            emailInstance.setSaveAsActivity(False);
            emails.add(emailInstance);
        }
        //Messaging.sendEmail(emails);
    }
/*------------------------------------------------------------------------------------------------------*/
    public void finish(Database.BatchableContext BC)
    {
        
    }

}