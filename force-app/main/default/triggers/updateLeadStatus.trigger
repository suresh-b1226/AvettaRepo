trigger updateLeadStatus on Task (after insert) 
{
    String leadObjPrefix = Lead.sObjectType.getDescribe().getKeyPrefix();
    List<Lead> updateLeads = new List<Lead>();
    set<Id> updateLeadIds = new set<Id>();
    for(Task t : trigger.New)
    {
        if(t.WhoId != null && String.valueOf(t.WhoId).substring(0, 3) == leadObjPrefix && t.Subject != null && t.Subject.contains('Email:'))
        {
            updateLeadIds.add(t.WhoId);
        }
    }
    if(updateLeadIds.size() > 0)
    {
        updateLeads = [select Id, Status from Lead where Id in :updateLeadIds and Status = 'Open'];
        for(Lead l : updateLeads)
        {
            l.Status = 'Working - Contacted';
        }
        update updateLeads;
    }
}