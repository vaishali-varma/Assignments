 @isTest
private class EmailHandlerForSearchEngineTest {

    static testMethod void emailTestPositive() {
        Messaging.InboundEmail emailInstance = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelopeInstance = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        emailInstance.subject = 'Test Email';
        emailInstance.fromname = 'FirstName LastName';
        emailInstance.plainTextBody = 'Hello Goobleforce, TCS Thank You';
        envelopeInstance.fromAddress = 'address@email.com';
        
        EmaiLHandlerForSearchEngine emailProcess = new EmaiLHandlerForSearchEngine();
        result = emailProcess.handleInboundEmail(emailInstance, envelopeInstance);
        system.assertEquals('Test Email',emailInstance.subject,'Comparing subject');
        system.assertEquals('Hello Goobleforce, TCS Thank You',emailInstance.plainTextBody,'Comparing body');
        system.assertequals(true,result.success,'comparig the success status');
    }
    
    static testMethod void emailTestNegative() {
        Messaging.InboundEmail emailInstance = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelopeInstance = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        emailInstance.subject = ' ';
        emailInstance.fromname = 'FirstName LastName';
        emailInstance.plainTextBody = ' ';
        envelopeInstance.fromAddress = 'address@email.com';
        
        EmaiLHandlerForSearchEngine emailProcess = new EmaiLHandlerForSearchEngine();
        result = emailProcess.handleInboundEmail(emailInstance, envelopeInstance);
        system.assertEquals(' ',' ','Comparing subject');
        system.assertEquals(' ', ' ','Comparing body');
        system.assertequals(false,result.success,'comparig the success status');
    }
    
    static testMethod void emailTestBodyNegative() {
        Messaging.InboundEmail emailInstance = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelopeInstance = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        emailInstance.subject = 'Test Mail';
        emailInstance.fromname = 'FirstName LastName';
        emailInstance.plainTextBody = 'Hello Goobleforce,  Thank You';
        envelopeInstance.fromAddress = 'address@email.com';
        
        EmaiLHandlerForSearchEngine emailProcess = new EmaiLHandlerForSearchEngine();
        result = emailProcess.handleInboundEmail(emailInstance, envelopeInstance);
        system.assertequals(false,result.success,'comparig the success status');
    }
    
    static testMethod void emailTestBodyPositive() {
        Messaging.InboundEmail emailInstance = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelopeInstance = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        emailInstance.subject = 'Test Mail';
        emailInstance.fromname = 'FirstName LastName';
        emailInstance.plainTextBody = 'Hello Goobleforce, Query Thank You';
        envelopeInstance.fromAddress = 'address@email.com';
        
        EmaiLHandlerForSearchEngine emailProcess = new EmaiLHandlerForSearchEngine();
        result = emailProcess.handleInboundEmail(emailInstance, envelopeInstance);
        system.assertequals(true,result.success,'comparing the success status');
    }
    
    static testMethod void emailReceiverInsertTest() {
        Messaging.InboundEmail emailInstance = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelopeInstance = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        emailInstance.subject = 'Test Mail';
        emailInstance.fromname = 'FirstName LastName';
        emailInstance.plainTextBody = 'Hello Goobleforce, Query Thank You';
        envelopeInstance.fromAddress = 'address@email.com';
        
        Contact contactInstance = new Contact();
        contactInstance.FirstName = 'FirstName';
        contactInstance.LastName = 'LastName';
        contactInstance.Email = 'address@email.com';
        insert contactInstance;
        Email_Receiver__c emailReceiverInstance = new Email_Receiver__c();
        emailReceiverInstance.Name = emailInstance.fromname.substring(0,emailInstance.fromname.indexOf(' '));
        emailReceiverInstance.Body_Of_Email__c = emailInstance.plainTextBody;
        emailReceiverInstance.Subject_Of_Email__c = emailInstance.subject;
        emailReceiverInstance.Email_Address__c = envelopeInstance.fromAddress;
        emailReceiverInstance.Contact__c = contactInstance.Id;
        insert emailReceiverInstance; 
        EmaiLHandlerForSearchEngine emailProcess = new EmaiLHandlerForSearchEngine();
        result = emailProcess.handleInboundEmail(emailInstance, envelopeInstance);
        system.assertequals(true,result.success,'comparing the success status');
        string doubt = emailInstance.plainTextBody.substringBetween('Goobleforce,','Thank You');
        doubt.trim();
        /*QueryFromMail__c queryInstance = new QueryFromMail__c();
        queryInstance.Name = doubt;
        queryInstance.Sender_Address__c = envelopeInstance.fromAddress;
        insert queryInstance;
        */
        
        QueryFromMail__c queryInstance = new QueryFromMail__c();
        queryInstance.Name = 'Noodles';
        queryInstance.Sender_Address__c = 'sender@receiver.com';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockClassForResponse());
        insert queryInstance; 
        Test.stopTest();
        list<Email_Query_Junction__c> junctionList = [
            SELECT Id 
              FROM Email_Query_Junction__c 
             WHERE CreatedDate = TODAY];
        system.assertNotEquals(0,junctionList.size(),'Comparing size');
    }

}