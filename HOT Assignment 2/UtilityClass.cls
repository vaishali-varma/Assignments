@isTest
public class UtilityClass {

    public static List<Lead> createLead(integer countOfRecords) 
    {
        List<Lead> leadList = new List<Lead>();
        for(integer i = 0; i < countOfRecords; i++)
        {   
            leadList.add(
                new Lead(
                    firstName = 'testagain'
                  , lastName = 'test'+i
                  , email = i+'test@test.com'
                  , city = 'Nashik'
                  ,State = 'Maharashtra'
                  , Company = 'TCS'
                  , Status = 'Open - Not Contacted'
                  , LeadSource = 'Banner'
                  , OwnerFieldUpdated__c = false));
        }
        insert leadList;
        return leadList;
    }
}