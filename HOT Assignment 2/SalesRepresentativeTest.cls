@isTest(seealldata = true)
private class SalesRepresentativeTest {
    
    static testMethod void ListOwnerTest() {
        SalesRepresentativeController controller = new SalesRepresentativeController();
        list<selectOption> option = controller.getlistOfOwner();
        system.assertNotEquals(null,option.size(),'user list size does not match');
        system.assertNotEquals(0,option.size(),'user list size does not match');
    }

    static testMethod void LeadListTest()
    {
         User userInstance = [
            SELECT Id,Name 
              FROM User 
             WHERE Name = 'Vaishali Varma'
         ];

        Lead leadInstance = new Lead();
        leadInstance.firstName = 'testagain';
        leadInstance.lastName = 'test';
        leadInstance.email = 'test@test.com';
        leadInstance.city = 'Nashik';
        leadInstance.State = 'Maharashtra';
        leadInstance.Company = 'TCS';
        leadInstance.Status = 'Open - Not Contacted';
        leadInstance.LeadSource = 'Banner';
        leadInstance.OwnerId = userInstance.Id;

        test.startTest();
        insert leadInstance;

        PageReference pageref = page.SalesRepresentativePage;
        Test.setCurrentPage(pageRef);
        SalesRepresentativeController controller = new SalesRepresentativeController();
        controller.owner = 'Vaishali Varma';
        controller.actionMethod(); 
        list<lead> leadListTest = controller.leadList;
        system.assertNotEquals(0,leadListTest.size(),'Size does not match');
        system.assertNotEquals(null,leadListTest.size(),'Size does not match');
    }
}