@isTest
private class SearchResultFromGoogleTest {

    static testMethod void historyCheckTest() {

        QueryFromMail__c queryInstance = new QueryFromMail__c();
        queryInstance.Name = 'Noodles';
        queryInstance.Sender_Address__c = 'sender@receiver.com';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockClassForResponse());
        insert queryInstance; 
        Test.stopTest();
        SearchResultFromGoogleController controller = new SearchResultFromGoogleController();
        list<QueryFromMail__c> QueryListFromController = controller.getlistOfQueries();
        system.assertEquals(1,QueryListFromController.size(),'comparing the size');
    }
    
    static testMethod void resultCheckTest() {

        QueryFromMail__c queryInstance = new QueryFromMail__c();
        queryInstance.Name = 'Noodles';
        queryInstance.Sender_Address__c = 'sender@receiver.com';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockClassForResponse());
        insert queryInstance; 
        Test.stopTest();

        SearchResultFromGoogleController controller = new SearchResultFromGoogleController();
        PageReference pageref = page.SearchResultsFromGoogle;
        Test.setCurrentPage(pageRef);
        controller.query = queryInstance.Name;
        list<Search_Result__c> searchListFromController = controller.getresultsFromQuery();
        system.debug('searchListFromController.size()@@@@'+searchListFromController.size());
        system.debug('searchListFromController.size()@@@@4444'+searchListFromController);
        system.assertNotEquals(0,searchListFromController.size(),'comparing the size');
        controller.refresh();
        controller.next();
        controller.previous();
        controller.last();
        controller.first();
        boolean test1 = controller.hasNext;
        boolean test2 = controller.hasPrevious;
        integer test3 = controller.pageNumber;
        controller.showQueries();
        system.assertEquals(true,controller.renderHistory,'Comparing the values');
        controller.showResult();
        system.assertEquals(true,controller.renderResult,'Comparing the values');
    }
}