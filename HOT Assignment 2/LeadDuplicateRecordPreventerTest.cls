/**
 *  The test class for checking if the duplicate lead is not inserted  
 *  based on its firstname,lastname,email.
 *
 *  Class : LeadDuplicateRecordPreventerTest
 *  @author  Vaishali Varma
*/
@isTest(seealldata = true)
private class LeadDuplicateRecordPreventerTest {

    static testMethod void duplicateHandlerTest() {
        list<Lead> leadList = [
            SELECT Id 
              FROM Lead];
        integer sizeOfListBeforeTrigger = leadList.size();
        Lead leadInstance = new Lead();
        leadInstance.firstName = 'testagain';
        leadInstance.lastName = 'test';
        leadInstance.email = 'test@test.com';
        leadInstance.city = 'Nashik';
        leadInstance.State = 'Maharashtra';
        leadInstance.Company = 'TCS';
        leadInstance.Status = 'Open - Not Contacted';
        leadInstance.LeadSource = 'Banner';
        
        test.startTest();
        insert leadInstance;
        test.stopTest();
        list<Lead> leadListAfterTrigger = [
            SELECT Id 
              FROM Lead];
        integer sizeOfListAfterTrigger = leadListAfterTrigger.size();
        system.assertNotEquals(sizeOfListBeforeTrigger,sizeOfListAfterTrigger,'Size does not match');
    }
}