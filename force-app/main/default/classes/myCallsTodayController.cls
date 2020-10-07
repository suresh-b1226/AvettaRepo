public with sharing class myCallsTodayController {

  // activity history
  public List<Task> activities { get; set; }
  
  public void getCallActivities() {
    try {
      Date today = Date.today();
      Date todayStart = Date.newInstance(today.year(), today.month(), today.day());
      
      activities = Database.query('select id, createddate, subject, calltype, description from task where calltype != \'\' and ownerid = \'' + UserInfo.getUserId() + '\' and createddate >= :todayStart order by createddate desc limit 3');
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
  }
}