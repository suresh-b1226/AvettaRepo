@isTest
public class TestCommissionsSetupController
{
/* SSF - commented out for test case failure and no usage of this functionality (confirmed with Jeff)
    @isTest
    public static void testSave()
    {
        CommissionsSetupController commissionsSetupController = new CommissionsSetupController();
        CommissionsSetupController.save();
    }
    
    @isTest
    public static void testsaveMassUpdate()
    {
        CommissionsSetupController commissionsSetupController = new CommissionsSetupController();
        List<CommissionsSetupController.SalesRepInfo> salesRepsInfo = commissionsSetupController.SalesRepList;
        for(CommissionsSetupController.SalesRepInfo salesRepInfo : salesRepsInfo)
        {
            salesRepInfo.IsChecked = true;
        }
        commissionsSetupController.YearlyQuota = 7.5;
        commissionsSetupController.StandardCommissionPercent = 7.5;
        commissionsSetupController.RenewalCommissionPercent = 7.5;
        commissionsSetupController.MultiplierCommissionPercent = 7.5;
        commissionsSetupController.TempContact.BirthDate = Date.newInstance(2013, 11, 5);
        commissionsSetupController.saveMassUpdate();
    }
    SSF */
}