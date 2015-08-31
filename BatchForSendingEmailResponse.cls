public with sharing class BatchForSendingEmailResponse implements Database.Batchable<sObject>,Database.Stateful{
    public BatchForSendingEmailResponse()
    {
        mapOfQueryAndResult = new Map<string,list<Search_Result__c>>();
        queryList = new list<Search_Result__c>();
        senderEmail = new set<string>();
    }
    Map<string,list<Search_Result__c>> mapOfQueryAndResult;
    list<Search_Result__c> queryList;
    set<string> senderEmail;
    public Database.querylocator start(Database.BatchableContext BC)
    {  
        String query = 'SELECT Actual_Link__c,Description__c,Link_Detail__c,QueryFromMail__c,Sender_Email__c FROM Search_Result__c WHERE CreatedDate = TODAY';
        return Database.getQueryLocator(query);  
    }
    
    public void Execute(Database.BatchableContext BC ,list<Search_Result__c> searchResultList)
    {
        for(Search_Result__c searchInstance : searchResultList)
        {
            senderEmail.add(searchInstance.Sender_Email__c);
        }
        /*Make a map of user and its results then send email*/
        for(String SenderInstance : senderEmail)
        {
            list<Search_Result__c> searchRecordsForUser = new list<Search_Result__c>();
            searchRecordsForUser = [
                SELECT link_Detail__c,Actual_Link__c,Description__c 
                  FROM Search_Result__c
                 WHERE Sender_Email__c = :SenderInstance];
                 
            if(!(mapOfQueryAndResult.containsKey(SenderInstance)))
             {
                 mapOfQueryAndResult.put(SenderInstance,searchRecordsForUser);
             }
        }
        system.debug('################ mapOfQueryAndResult : '+mapOfQueryAndResult);
        
        
    }
 
    public void finish(Database.BatchableContext BC)
    { system.debug('Inside finish : : : :');
        system.debug('################ mapOfQueryAndResult : '+mapOfQueryAndResult);
        system.debug('#### keyset : '+mapOfQueryAndResult.keySet());
        for(string userInstance : mapOfQueryAndResult.keySet())
        {system.debug('Inside for : : : :');
            string body;
            system.debug('#### User'+userInstance);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            string [] toaddress=new String[]{userInstance};
            //String[] ccAddresses=new String[]{'vaishali.varma@eternussolutions.com'};
            email.setSubject('Response');
            
            body += mapOfQueryAndResult.get(userInstance);
            system.debug('##### body : '+body);
            email.setToAddresses(toaddress);
            email.setHtmlBody('Response : '+body);
            //email.setCcAddresses(ccAddresses); 
            Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
            system.debug('Mail Sent');
        }            
    }
}