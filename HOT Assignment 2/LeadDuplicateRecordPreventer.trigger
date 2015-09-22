/**
 *  The trigger which gets executed before the lead is
 *  inserted based on its firstname,lastname,email.
 *
 *  Class : LeadDuplicateRecordPreventerHandler
 *  @author  Vaishali Varma
*/
trigger LeadDuplicateRecordPreventer on Lead (before insert) {
    if(trigger.isInsert && trigger.isBefore)
    {
        LeadDuplicateRecordPreventerHandler.duplicateHandler(trigger.new);
    }
}
