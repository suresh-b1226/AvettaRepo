/****************************************************************************************
 * © Avetta, LLC                                                                        *
 *                                                                                      *
 * AUTHOR: Jeff DeGraw                                                                  *
 * DATE:   09/12/2019                                                                   *
 *                                                                                      *
 * SUMMARY:                                                                             *
 * Tests the Communities_User_Deactivator_Batch class.                                  *
 *                                                                                      *
 * METRICS:                                                                             *
 * This will save the Salesforce Admins ~30 minutes per week.                           *
 *                                                                                      *
 * SALESFORCE CASE:                                                                     *
 * 01285024                                                                             *
 *                                                                                      *
 * REVISION HISTORY:                                                                    *
 * 09/12/2019 - Jeff DeGraw - Initial version                                           *
 ****************************************************************************************/

@isTest
private class Communities_User_Deactivator_Batch_Test {

    @isTest static void testDeactivator() {
        
        List<User> userList = new List<User>();

        // Generate the test Users, then we need to run deactivateOldUsers() as a new
        // User or the following error will occur:
        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you
        // have updated a non-setup object
        Test.startTest();
            generateUsers();
            Communities_User_Deactivator_Batch deactivator = new Communities_User_Deactivator_Batch();
            Database.executeBatch(deactivator);
        Test.stopTest();
 
        // Test if all of the users that should be active are still active
        userList = [
            SELECT Id
            FROM User
            WHERE FirstName='Should be active'
                AND IsActive=true 
        ];
        System.assertEquals(10, userList.size());

        // Test if all of the users that shouldn't be active have been deactivated
        userList = [
            SELECT Id
            FROM User
            WHERE FirstName='Should Be Inactive'
                AND IsActive=true
        ];
        System.assertEquals(0, userList.size());
    }

    // Is there like a TestDataFactory class that will do this?
    // How does test data work with testing? It still uses the same database?
    public static List<User> generateUsers() {
        List<User> newUsers = new List<User>();
        // Need to get different profiles because we need to have some users with
        // UserType 'Standard' and others with UserType 'CSPLitePortal'
        Profile admin = [   // UserType='Standard'
            SELECT Id
            FROM Profile
            WHERE Name='System Administrator'
        ];
        Profile regular = [ // UserType='CSPLitePortal'
            SELECT Id
            FROM Profile
            WHERE Name='Client Community Login'
        ];

        // This generates an account and contact first to associate with the new User.
        // If not done this way we'll get an error.
        for (Integer i = 0; i < 20; i++) {
            Account acct = new Account(Name='Apex Test' + i); 
            insert acct;
            Contact con = new Contact(LastName='Apex Test' + i, AccountId=acct.Id); 
            insert con;
            String firstName = (i < 10) ? 'Should Be Inactive' : 'Should Be Active';
            Profile p = (i < 10) ? regular : admin;

            User u = new User(
                IsActive=true,
                FirstName=firstName,
                LastName=String.valueOf(i),
                Username='test' + i + '@testing123.com',
                Email='test' + i + '@testing123.com',
                Alias='test' + i,
                TimeZoneSidKey='America/Denver',
                LocaleSidKey='en_US',
                EmailEncodingKey='UTF-8',
                LanguageLocaleKey='en_US',
                ProfileId=p.Id,
                ContactId=(i < 10) ? con.Id : null,
                UserRoleId=null
            );
            newUsers.add(u);
        }

        insert newUsers;
        return newUsers;
    }
}