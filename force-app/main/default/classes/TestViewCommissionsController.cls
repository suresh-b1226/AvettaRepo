@isTest
public class TestViewCommissionsController
{
/*
    @isTest
    public static void testAllMethods()
    {
        Account account = new Account(Name = 'test');
        insert account;
        Account_Commission_User__c accountCommissionUser = new Account_Commission_User__c(Account__c = account.Id, Commission_Percent__c = 7.5, QuotaAttributablePercent__c = 7.5);
        insert accountCommissionUser;
        Date payDate = Date.newInstance(2013, 11, 6);
        Organizer_Payment__c organizerPayment = new Organizer_Payment__c(Operator__c = account.Id, Commission_Assigned__c = false, Commissionable_Amount__c = 1000, Payment_Date__c = payDate);
        insert organizerPayment;
        Commission__c commission = new Commission__c(User__c = Userinfo.getUserId(), Payment_Date__c = payDate, Operator__c = account.Id, Commission_Amount__c = 100, Quota_Attributable_Amount__c = 100, QuotaAttributablePercent__c = 7.5, Commissionable_Amount__c = 1000);
        insert commission;
        
        ViewCommissionsController viewCommissionsController = new ViewCommissionsController();
        List<SelectOption> selectOptions = viewCommissionsController.YearsOptions;
        viewCommissionsController.SelectedSalesRep = UserInfo.getUserId();
        viewCommissionsController.FYYear = '2013';
        viewCommissionsController.salesRepSelectListChange();
        System.assertEquals(false, viewCommissionsController.DiplayCommissionInOneMonth);
        
        viewCommissionsController.Month = 12;
        viewCommissionsController.diplayCommissionInOneMonth();
        System.assertEquals(true, viewCommissionsController.DiplayCommissionInOneMonth);
    }
    */
}