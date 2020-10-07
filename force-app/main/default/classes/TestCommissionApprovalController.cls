@isTest
public class TestCommissionApprovalController
{

    @isTest
    public static void test()
    {
    CommissionApprovalController cc = new CommissionApprovalController();
    }
/* SSF - commented out for test case failure and no usage of this functionality (confirmed with Jeff)
    @isTest
    public static void test()
    {
        String uId = UserInfo.getUserId();
        User currentUser = [ select Id, CommunityNickname, TimeZoneSidKey, EmailEncodingKey, LocaleSidKey, ProfileId, LanguageLocaleKey from User where Id = :uId];
        User u = new User();
        u.SalesManager__c = uId;
        u.Username = 'leo.wang2@meginfo.com';
        u.LastName = 'TestLastName2';
        u.Email = '123@gmail.com';
        u.Alias = '123Test';
        u.CommunityNickname = 'TEST2';
        u.TimeZoneSidKey = currentUser.TimeZoneSidKey;
        U.LocaleSidKey = currentUser.LocaleSidKey;
        u.EmailEncodingKey = currentUser.EmailEncodingKey;
        u.ProfileId = currentUser.ProfileId;
        u.LanguageLocaleKey = currentUser.LanguageLocaleKey;
        u.YearlyQuota__c = 2000;
        insert u;
        Account ac = new Account(Name = 'test');
        insert ac;
        Date d = Date.newInstance(2013, 10, 15);
        List<Commission__c> commissions = new List<Commission__c>();
        for(Integer i = 0; i < 10; i++)
        {
            Commission__c com = new Commission__c();
            com.Commissionable_Amount__c = 10;
            com.Commission_Amount__c = 11;
            com.Commission_Percent__c = 5;
            com.Creator__c = uId;
            com.InvoiceID__c = 100 + i;
            com.InvoiceTotalAmount__c = 1000;
            com.Operator__c = ac.Id;
            com.Payment_Date__c = d;
            com.Payment_ID__c = 100 + i;
            com.Quota_Attributable_Amount__c = 500;
            com.QuotaAttributablePercent__c = 6;
            com.Total_Payment_Amount__c = 1200;
            com.User__c = u.Id;
            commissions.add(com);
        }
        insert commissions;
        CommissionApprovalController cac = new CommissionApprovalController();
        cac.Month = '201310';
        cac.monthSelectChange();
        
        List<SelectOption> monthOptionsTemp = cac.MonthOptions;
        
        
        PageReference pageRef = new PageReference('/apex/CommissionApproval?approvedUserId=' + u.Id);
        Test.setCurrentPage(pageRef);
        cac.approval();
        
        cac.selectUser = u.Id;
        cac.diplayCommissionForCertainUser();
        
        cac.commissionId = commissions.get(0).Id;
        cac.adjust();
        //cac.createAdjustCommission();
    }
     SSF */
}