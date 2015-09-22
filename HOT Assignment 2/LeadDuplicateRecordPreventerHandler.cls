/**
 *  The controller for checking if the duplicate lead is not 
 *  inserted based on its firstname,lastname,email.
 *
 *  Class : LeadDuplicateRecordPreventerHandler
 *  @author  Vaishali Varma
*/
public with sharing class LeadDuplicateRecordPreventerHandler {
    public static void duplicateHandler(list<Lead> leadList)
    {
        List<Lead> existingLeadList = [
            SELECT Id
                 , FirstName
                 , LastName
                 , Email 
              FROM Lead 
             WHERE Email != NULL AND FirstName != NULL AND LastName != NULL
        ];

        //Checking if the record already exists ,if yes then it doesnt get inserted
        for(Lead leadInstance : leadList)
        {
            system.debug('@@@ inside for');
            for(Lead leadInstanceForExisting : existingLeadList)
            {system.debug('@@@ inside for in for');
                if(leadInstance.Email.equals(leadInstanceForExisting.Email) && 
                   leadInstance.FirstName.equalsIgnoreCase(leadInstanceForExisting.FirstName) &&
                   leadInstance.LastName.equalsIgnoreCase(leadInstanceForExisting.LastName))
                {
                    leadInstance.Email.addError('A lead with this email address already exists.',false);
                    leadInstance.FirstName.addError('A lead with this Name already exists.',false);
                    leadInstance.LastName.addError('A lead with this Name already exists.',false);
                }
            }
        }
    }
}