@isTest
private class leadDuplicatePreventerTest {
    static testMethod void duplicateLeadTest() {
        //set of string that contains the email address
        //it is checked with the existing records
        set<string> testEmailAddress = new set<string>();
        testEmailAddress.add('test1@duptest.com');
        testEmailAddress.add('test2@duptest.com');
        testEmailAddress.add('test3@duptest.com');
        testEmailAddress.add('test4@duptest.com');
        System.assert([SELECT count() 
                         FROM Lead
                        WHERE Email IN :testEmailAddress] == 0);
        //New leads are inserted
        Lead lead1 = new Lead(LastName='Test1', Company='Test1 Inc.', Email='test1@duptest.com');
        Lead lead2 = new Lead(LastName='Test2', Company='Test2 Inc.', Email='test4@duptest.com');
        Lead[] leads = new Lead[] {lead1, lead2};
        insert leads;
        //Duplicate lead is inserted and it should not
        //be inserted and shows the message.
        Lead duplicateLead = new Lead(LastName='Test1Dup', Company='Test1Dup Inc.', Email='test1@duptest.com');
        try
        {
            insert duplicateLead;
            System.assert(false);
        }
        catch(DmlException e)
        {
            System.assert(e.getNumDml() == 1);
            System.assert(e.getDmlMessage(0).indexOf(
                'A lead with this email address already exists.') > -1);
        }
    }
}