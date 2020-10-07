//Written by Dallin Wasden 2.21.2018
//Links opportunities matching certain criteria to tasks created in account. Created for Marketo campaign use case
//which would insert tasks and not link them to the opportunity that already existed in the account.
@isTest(SeeAllData=true) private class linkTouchpointEmailToOpportunityTest {

    @isTest(SeeAllData=true) static void linkTouchpointEmail() {

        //Create account record for test purposes.
        List<Account> accountRecords = QB_TestDataFactory.createClientAccountRecords(1, TRUE);
        System.debug('after creating account in QB_TestDataFactory.createClientAccountRecords' + accountRecords);

        //Create campaign record for test purposes.
        List<Campaign> campaignRecords = QB_TestDataFactory.createCampaignRecordsWithClientId(1, TRUE, accountRecords[0].id);
        System.debug('after creating opportunity in QB_TestDataFactory.createCampaignRecords' + campaignRecords);
        
        //Create opportunity record for test purposes.
        List<Opportunity> opportunityRecords = QB_TestDataFactory.createOpportunityRecordsWithCampaign(1, TRUE, accountRecords[0].id, campaignRecords[0].id);
        System.debug('after creating opportunity in QB_TestDataFactory.createOpportunityRecordsWithCampaign' + opportunityRecords);

        /*
		//Create user record for test purposes.
		List<User> userRecords = QB_TestDataFactory.createUserRecords(1, TRUE);
		System.debug('after creating account in QB_TestDataFactory.createUserRecords') ;
        */

        //Create task record for test purposes.
        List<Task> emailTaskRecords = QB_TestDataFactory.createTaskRecord(1, TRUE, 'Email', 'Was Sent Email: EBL.EXT25823580Contractors', accountRecords[0].id);
        System.debug('after creating task in QB_TestDataFactory.createTaskRecords');
	}
}