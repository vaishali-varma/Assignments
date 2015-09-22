/**
 *  Trigger that gets fired whenever the lead is updated 
 *  and trigger makes a post on the chatter group.
 *
 *  Class : PostOnChatterOnLeadInsertion
 *  @author  Vaishali Varma
*/
trigger PostOnChatterOnLeadInsertion on Lead (after update) {
    if(trigger.isAfter)
    {
        if(trigger.isUpdate)
        {
            PostOnChatterOnLeadInsertionHandler.PostOnChatter(trigger.new);
        }
    }
}