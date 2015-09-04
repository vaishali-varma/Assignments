 @isTest
private class PdfComponentTest {

    static testMethod void checkPdf() {
        QueryFromMail__c queryInstance = new QueryFromMail__c();
        queryInstance.Name = 'Maggie';
        queryInstance.Sender_Address__c = 'first.last@email.com';
        Test.setMock(HttpCalloutMock.class, new MockClassForResponse());
        Test.startTest();
        insert queryInstance; 
        Test.stopTest();
        pdfComponentController controller = new pdfComponentController();
        controller.queryToGet = queryInstance.Id;
        list<Search_Result__c> pdfResults = controller.getsearchResultList();

        system.assertNotEquals(0,pdfResults.size(),'comparing the size of the list');


    }
}