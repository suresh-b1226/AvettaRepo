@isTest
public class TestEditCommissionTeamController
{
    @isTest
    public static void testAddAndSave()
    {    
        /*
        Account account = new Account(Name = 'test');
        insert account;        
        PageReference pageRef = new PageReference('/apex/EditCommissionTeam?Id=' + account.Id);
        Test.setCurrentPage(pageRef);
        EditCommissionTeamController editCommissionTeamController = new EditCommissionTeamController();
        //editCommissionTeamController.AccountId = account.Id;
        editCommissionTeamController.add();
        //System.assertEquals(1, editCommissionTeamController.AccountCommissionUserList.size());      
        //Account_Commission_User__c accountCommissionUser = (Account_Commission_User__c)editCommissionTeamController.AccountCommissionUserList.get(0);
        //accountCommissionUser.User__c = UserInfo.getUserId();
        //accountCommissionUser.Role__c = 'Sales Rep Renewal';
        editCommissionTeamController.save();
        */
    }
    @isTest
    public static void testCancel()
    {
        /*
        Account account = new Account(Name = 'test');
        insert account;
        PageReference pageRef = new PageReference('/apex/EditCommissionTeam?Id=' + account.Id);
        Test.setCurrentPage(pageRef);
        EditCommissionTeamController editCommissionTeamController = new EditCommissionTeamController();
        //editCommissionTeamController.AccountId = account.Id;
        editCommissionTeamController.cancel();
        */
    }
    @isTest
    public static void testSelectChange()
    {
        /*
        EditCommissionTeamController editCommissionTeamController = new EditCommissionTeamController();
        editCommissionTeamController.selectedUserId = UserInfo.getUserId();
        editCommissionTeamController.selectRole = 'Sales Rep Renewal';
        editCommissionTeamController.selectChange();
        List<SelectOption> selectOptions = editCommissionTeamController.SalesRepOptions;
        */
    }
}