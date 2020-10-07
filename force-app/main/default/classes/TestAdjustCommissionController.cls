@isTest
public class TestAdjustCommissionController
{
    @isTest
    public static void testSave()
    {
        Account account = new Account(Name = 'test');
        insert account;
        PageReference pageRef = new PageReference('/apex/AdjustCommission?openerUrl=https://cs1.salesforce.com/'+account.Id);
        Test.setCurrentPage(pageRef);
        AdjustCommissionController adjustCommissionController = new AdjustCommissionController();
        //System.assertEquals(null, adjustCommissionController.Commission);
        adjustCommissionController.save();
        List<SelectOption> salesReps = adjustCommissionController.SalesRepOptions;
    }
}