trigger SearchQueryFromGoogleTrigger on QueryFromMail__c (after insert) {
    if(Trigger.isAfter && Trigger.isInsert)
    {
        system.debug('######### Inside Trigger');
        SearchQueryFromGoogleHandler.initialiseQueryList(Trigger.new);
    }
}