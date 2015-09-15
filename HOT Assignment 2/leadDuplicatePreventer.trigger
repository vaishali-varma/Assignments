trigger leadDuplicatePreventer on Lead (before insert, before update) {
    Map<String, Lead> leadMap = new Map<String, Lead>(); 
    for (Lead lead : System.Trigger.new) 
    { 
        if ((lead.Email != null) && (System.Trigger.isInsert || (lead.Email != System.Trigger.oldMap.get(lead.Id).Email))) 
        {system.debug('@@@ Inside if');
            if (leadMap.containsKey(lead.Email)) 
            {
                system.debug('@@ inside inner if');
                system.debug('leadMap@@'+leadMap);
                lead.Email.addError('Another new lead has the same email address.'); 
            } 
            else
            {
                system.debug('in else');
                system.debug('leadMap'+leadMap);
                leadMap.put(lead.Email, lead); 
                system.debug('leadMap'+leadMap);
            }
        }
    }
    // Using a single database query, find all the leads in 
    // the database that have the same email address as any 
    // of the leads being inserted or updated. 
    for (Lead lead : [
        SELECT Email 
          FROM Lead  
         WHERE Email IN :leadMap.KeySet()])
    { 
        system.debug('leadMap.KeySet()'+leadMap.KeySet());
        Lead newLead = leadMap.get(lead.Email);
        system.debug('newLead'+newLead);
        system.debug('system.debug'+lead.Email);
        newLead.Email.addError('A lead with this email address already exists.');
    }
}