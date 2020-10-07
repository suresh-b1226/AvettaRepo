@isTest
private class myCallsTodayControllerTest {
  // Let's make this happen
  // testing myCallsTodayController
	static testMethod void getCallActivitiestest() {
        //Create a User
        Profile p = [select id from profile where name='SER'];
        User Tester = new User(alias = 'silver', email='Quiksilver@xfactor.org',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/New_York', username='Quiksilver@xfactor.org');
    	
        //that User will now perform 3 calls
        List<Task> newtasks = new List<Task>();
        for(Integer i = 0; i < 4; i++){
            task a = new task(subject = 'Test Tasks ' + i, description = 'Description'+i, OwnerID = Tester.Id, calltype = 'inbound' );
            newtasks.add(a);
        }
        //Now we are using that user to figure out what we did today.
		System.runAs(Tester) {
        	//Running the controller I'm testing...Finally
          	myCallsTodayController RunController = new myCallsTodayController();
        	RunController.getCallActivities();
              //myCallsTodayController.getCallActivities;
              //System.assertEquals(CurrentUser.Id, tcalls.getUser().Id, 'Did not successfully load the current user');
              
          }          
  	}
}