 @isTest
private class SearchQueryFromGoogleHandlerTest {

    static testMethod void ResponseTest() {
        
        QueryFromMail__c queryInstance = new QueryFromMail__c(); 
        queryInstance.Name = 'Maggie';
        queryInstance.Sender_Address__c = 'first.last@email.com';
        system.debug('queryInstance@@@@@@'+queryInstance);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockClassForResponse());
        system.debug('queryInstance@@@@@@'+queryInstance);
        insert queryInstance;
        Test.stopTest();
        system.debug('queryInstance@@@@@@'+queryInstance);
        list<string> queryString = new list<string>();
        queryString.add(queryInstance.Name);
        
        SearchQueryFromGoogleHandler.searchQuery(queryString);
        list<Search_Result__c> searchList = [
            SELECT Actual_Link__c,Description__c,Link_Detail__c
              FROM Search_Result__c
             WHERE QueryFromMail__r.Name = :'Maggie'];
             
        system.assertNotEquals(0,searchList.size(),'Comparing the size');
    }
}  