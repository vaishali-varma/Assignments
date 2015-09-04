 @isTest
private class SearchResultDisplayControllerTest {

    static testMethod void searchResultDisplayTest() {
        QueryFromMail__c queryInstance = new QueryFromMail__c();
        queryInstance.Name = 'Maggie';
        queryInstance.Sender_Address__c = 'first.last@email.com';
        Test.setMock(HttpCalloutMock.class, new MockClassForResponse());
        Test.startTest();
        insert queryInstance; 
        Test.stopTest();
        SearchResultDisplayController controller = new SearchResultDisplayController();
        controller.queryToGet = queryInstance.Id;
        list<Search_Result__c> searchResults = controller.getsearchResultList();

        system.assertNotEquals(0,searchResults.size(),'comparing the size of the list');
    }
}