 @isTest
private class BatchForResponseFromGoogleTest {

    static testMethod void myUnitTest() {
        Test.setMock(HttpCalloutMock.class, new MockClassForResponse());
        Messaging.InboundEmail emailInstance = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelopeInstance = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        emailInstance.subject = 'Test Email';
        emailInstance.fromname = 'FirstName LastName';
        emailInstance.plainTextBody = 'Hello Goobleforce, TCS Thank You';
        envelopeInstance.fromAddress = 'address@email.com';
        
        EmaiLHandlerForSearchEngine emailProcess = new EmaiLHandlerForSearchEngine();
        result = emailProcess.handleInboundEmail(emailInstance, envelopeInstance);
        BatchForResponseFromGoogle batchInstance = new BatchForResponseFromGoogle();
        Test.startTest();
        Database.executeBatch(batchInstance);
        Test.stopTest();
        list<Email_Query_Junction__c> junctionList = [
            SELECT Id 
              FROM Email_Query_Junction__c 
             ];
        system.assertNotEquals(0,junctionList.size(),'Comparing size');
    }
}