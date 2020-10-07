/**
 * controller of page : Commissions Setup
 */
public class CommissionsSetupController
{    
    public CommissionsSetupController()
    {
        SalesRepList = new List<SalesRepInfo>();

        Profile accountManagerProfile = [select Id from Profile where Name = 'Account Management'];
        String currentUserProfileId = UserInfo.getProfileId();
        if(accountManagerProfile != null && currentUserProfileId == accountManagerProfile.Id)// is account management
        {
            List<User> theSalesReps = [select Id, Name, YearlyQuota__c, StandardCommission__c, RenewalCommission__c, QuotaReachedMultiplier__c, EffectiveDate__c from User where IsActive = true and SalesManager__c != null and Id != :UserInfo.getUserId()];
            for(User salesRep : theSalesReps)
            {
                SalesRepList.add(new SalesRepInfo(false, salesRep));
            }
        }
        else
        {
            List<User> theSalesReps = [select Id, Name, YearlyQuota__c, StandardCommission__c, RenewalCommission__c, QuotaReachedMultiplier__c, EffectiveDate__c from User where IsActive = true and SalesManager__c = : UserInfo.getUserId()];
            for(User salesRep : theSalesReps)
            {
                SalesRepList.add(new SalesRepInfo(false, salesRep));
            }
        }
        TempContact = new Contact();
    }
    
    public List<SalesRepInfo> SalesRepList { get; set; }
    public Decimal YearlyQuota { get; set; }
    public Decimal StandardCommissionPercent { get; set; }
    public Decimal RenewalCommissionPercent { get; set; }
    public Decimal MultiplierCommissionPercent { get; set; }
    public Contact TempContact { get; set; }
    
    //updates commissions of the sales reps under current sales manager
    public PageReference save()
    {
        Boolean isSuccessed = true;
        String Errors = '';
        if(SalesRepList.size() > 0)
        {
            List<User> UserListTemp = new List<User>();
            for(SalesRepInfo salesRepItem : SalesRepList)
            {
                UserListTemp.add(salesRepItem.SalesRep);
            }
            try
            {
                update UserListTemp;
            }
            catch(Exception ex)
            {
                isSuccessed = false;
                Errors += ex.getMessage();
            } 
            if(isSuccessed)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Commissions setup has been successfully saved.'));
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to save commissions setup. please contact your system administrator.'));
            }                     
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No sales reps found.'));
        }
        return null;
    }
    
    //Mass Edit the users
    public void saveMassUpdate()
    {
        for(SalesRepInfo salesRepItem : SalesRepList)
        {
            if(salesRepItem.IsChecked)
            {
                    if(YearlyQuota != null && YearlyQuota != 0)
                    {
                        salesRepItem.SalesRep.YearlyQuota__c = YearlyQuota;
                    }
                    if(StandardCommissionPercent != null && StandardCommissionPercent != 0)
                    {
                        salesRepItem.SalesRep.StandardCommission__c = StandardCommissionPercent;
                    }
                    if(RenewalCommissionPercent != null && RenewalCommissionPercent != 0)
                    {
                        salesRepItem.SalesRep.RenewalCommission__c = RenewalCommissionPercent;
                    }
                    if(MultiplierCommissionPercent != null && MultiplierCommissionPercent != 0)
                    {
                        salesRepItem.SalesRep.QuotaReachedMultiplier__c = MultiplierCommissionPercent;
                    }
                    if(TempContact.BirthDate != null)
                    {
                        salesRepItem.SalesRep.EffectiveDate__c = TempContact.BirthDate;
                    }
            }
        }
        save();
    }
    
    public class SalesRepInfo
    {
        public Boolean IsChecked { get; set; }
        public User SalesRep { get; set; }

        public SalesRepInfo(Boolean isChecked, User theUser)
        {
            this.IsChecked = isChecked;
            this.SalesRep = theUser;
        }
    }  
}