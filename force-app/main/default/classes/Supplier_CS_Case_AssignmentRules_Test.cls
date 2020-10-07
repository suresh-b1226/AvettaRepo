/**
 * Created by JasonMcGrew on 6/2/2020.
 */

@IsTest
private class Supplier_CS_Case_AssignmentRules_Test {
    @TestSetup
    static void loadData(){
        Account a = new Account(
                Name = 'Test Account',
                BillingCountry = 'US'
        );
        insert a;
        System.debug('Account = ' + a);
        
        Case c = new Case(
                AccountId   = a.Id,
                Status      = 'New',
                Subject     = 'TESTING',
                Description = 'Case Test',
                Type        = 'InsureGuard',
                Origin      = 'Phone'
        );
        insert c;
        System.debug('Case = ' + c);
    }

    @IsTest
    static void testCase(){
        //instantiate List to pass to @InvocableMethod
        List<Id> ids = new List<Id>();

        //query for test data and add to List
        Case c = [
                SELECT Id, OwnerId
                FROM Case
        ];
        ids.add(c.Id);
        System.debug('case = ' + c);

        //call @InvocableMethod
        Test.startTest();
        Supplier_CS_Case_AssignmentRules.assignCase(ids);
        Test.stopTest();

        //verify that Lead was re-assigned
        Case res = [
                SELECT Id, OwnerId
                FROM Case
        ];
        System.debug('res = ' + res);

        System.assert(c.OwnerId != res.OwnerId, res);
    }
}