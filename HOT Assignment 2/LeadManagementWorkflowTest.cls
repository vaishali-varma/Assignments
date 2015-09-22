/**
 *  Test class for the workflow that updates the owner field of lead and the
 *  trigger that inserts the post on the chatter group after lead record insertion.
 *
 *  Class : LeadManagementWorkflowTest
 *  @author  Vaishali Varma
*/
@isTest(SeeAllData=true)
private class LeadManagementWorkflowTest {
    static testMethod void workflowTest() {
//get the list of feeditem before insertion of lead record
        list<FeedItem> feedItemList = [
            SELECT Id 
             FROM FeedItem
        ];
//inserting the lead record
        test.startTest();
        list<Lead> leadList = UtilityClass.createLead(2);
        test.stopTest();
        
        system.debug('#####leadList '+leadList);
//get the list of lead records after insertion
        list<Lead> leadListAfterUpdate = [
            SELECT FirstName
                 , OwnerFieldUpdated__c
              FROM Lead 
             WHERE FirstName = :'testagain'
         ];
//get the list of feeditem after insertion of lead record
         list<FeedItem> feedItemListAfterPostInsertion = [
            SELECT Id 
             FROM FeedItem
        ];
        for(Lead leadInstance : leadListAfterUpdate)
        {
            system.debug('#####leadList '+leadListAfterUpdate);
            system.debug('leadListAfterUpdate.OwnerFieldUpdated__c'+leadInstance.OwnerFieldUpdated__c);
            system.assertEquals(true,leadInstance.OwnerFieldUpdated__c,'Field is not updated');
        }
        system.assertNotEquals(feedItemList.size(),feedItemListAfterPostInsertion.size(),'size of both list matches');
    }
}