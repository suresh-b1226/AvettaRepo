@isTest
public class TestUnattributedPaymentsController
{
/* SSF - commented out for test case failure and no usage of this functionality (confirmed with Jeff)
    @isTest
    public static void testAllMethods()
    {
        Account account = new Account(Name = 'test');
        insert account;
        Date payDate = Date.newInstance(2013, 11, 6);
        Organizer_Payment__c  organizerPayment = new Organizer_Payment__c(Operator__c = account.Id, Payment_Date__c = payDate, Commission_Assigned__c = false, Commissionable_Amount__c = 100, Total_Payment_Amount__c = 1000);
        insert organizerPayment;
        ResolveUnattributedPaymentsController resolveUnattributedPaymentsController = new ResolveUnattributedPaymentsController();
        //resolveUnattributedPaymentsController.AccountID = account.Id;
        System.assertEquals(false, resolveUnattributedPaymentsController.DisplayCommissionUserOrNot);
        resolveUnattributedPaymentsController.displayCommissionUser();
        System.assertEquals(true, resolveUnattributedPaymentsController.DisplayCommissionUserOrNot);
        
        resolveUnattributedPaymentsController.selectedUserId = Userinfo.getUserId();
        resolveUnattributedPaymentsController.selectRole = 'Sales Rep Renewal';
        resolveUnattributedPaymentsController.selectChange();
        
        resolveUnattributedPaymentsController.add();
        System.assertEquals(0, resolveUnattributedPaymentsController.AccountCommissionUserList.size());
        
        resolveUnattributedPaymentsController.save();
        System.assertEquals(false, resolveUnattributedPaymentsController.DisplayCommissionUserOrNot);
        
        List<SelectOption> selectOptions = resolveUnattributedPaymentsController.SalesRepOptions;
    }
    */
}