global class UpdateAccountFields implements Database.Batchable<sObject>
{
    public String query;
    
    global Database.queryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<Account> accounts = new List<Account>();
        
        for(sObject s : scope)
        {
            Account acc = (Account)s;
            DateTime lastAccountReview = null;
            DateTime nextAccountReview = null;
            
            for(Event eventProxy : acc.Events)
            {
                if(eventProxy.StartDateTime < DateTime.now())
                {
                    if(lastAccountReview == null)
                    {
                        lastAccountReview = eventProxy.StartDateTime;
                    }
                    else
                    {
                        lastAccountReview = eventProxy.StartDateTime > lastAccountReview ? eventProxy.StartDateTime : lastAccountReview;
                    }
                }
                else if(eventProxy.StartDateTime > DateTime.now())
                {
                    if(nextAccountReview == null)
                    {
                        nextAccountReview = eventProxy.StartDateTime;
                    }
                    else
                    {
                        nextAccountReview = eventProxy.StartDateTime < nextAccountReview ? eventProxy.StartDateTime : nextAccountReview;
                    }
                }
            }
            acc.Last_Account_Review__c = lastAccountReview;
            acc.Next_Scheduled_Account_Review__c = nextAccountReview;
            accounts.add(acc);
        }
        if(accounts.size() > 0)
        {
            update accounts;
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {}
}