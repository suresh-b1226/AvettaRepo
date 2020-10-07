public with sharing class AdjustCommissionController
{
    public Commission__c Commission { get; set; }
    public Boolean IsSalesManager { get; set; }
    public List<SelectOption> SalesRepOptions
    {
        get
        {
            List<SelectOption> results = new List<SelectOption>();
            //results.add(new selectOption('', '--None--'));
            List<User> allSalesRep = [select Id, Name from User where IsActive = true and SalesManager__c = : UserInfo.getUserId()];            
            for(User u : allSalesRep)
            {                   
                results.add(new selectOption(u.Id, u.Name));
            }
            return results;

        }
    }

    public AdjustCommissionController()
    {
        List<User> allSalesRep = [select Id, Name from User where IsActive = true and SalesManager__c = : UserInfo.getUserId()]; 
        if(allSalesRep.size() == 0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Only sales managers can edit commissions.'));
            IsSalesManager = false;
        }
        else{
            String accountString = Apexpages.currentPage().getParameters().get('openerUrl');
            String accountID = accountString.split('/').get(3);
            Commission = new Commission__c(Operator__c = accountID);
            IsSalesManager = true;
        }
    }

    public PageReference save()
    {
        if(Commission != null)
        {
            insert Commission;
        }
        return null;
    }
}