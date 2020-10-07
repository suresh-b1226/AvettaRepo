public class ScheduleOperatorMeetingController
{
    public Event EventObject {get; set;}
    public String EventType {get; set;}
    private  Account currentAccount;
    
    public ScheduleOperatorMeetingController(Apexpages.standardController std)
    {
        currentAccount = [select Id, Name, Account_Review_Frequency__c, Status__c from Account where Id = :std.getId()];
        EventObject = new Event();
    }
    
    public void saveScheduleOperator()
    {
        Boolean isValidData = true;
        if(EventObject.StartDateTime == null)
        {
            isValidData = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Appointment Date: You must enter a value.'));
        }
        if(String.isEmpty(EventType))
        {
            isValidData = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Meeting Type: You must enter a value.'));
        }
        if(isValidData)
        {
            createEvent();
            currentAccount.Status__c = 'Completed';
            update currentAccount;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '<script type="text/javascript">closeWindow();</script>'));
        }
    }
   
    private void createEvent()
    {
        String subjectVal = EventType == 'Account Review' ? 'Account Review' : 'Training';
        eventObject.Subject = currentAccount.Name + ' - ' + subjectVal;
        eventObject.WhatId = currentAccount.Id;
        eventObject.Type = EventType;
        eventObject.OwnerId = UserInfo.getUserId();
        String eventDescription = EventType == 'Account Review' ? 'Guided Account Review' : 'Provide Operator Training';
        eventObject.Description = eventDescription;
        eventObject.EndDateTime = eventObject.StartDateTime.addHours(1);
        eventObject.IsReminderSet = true;
        eventObject.ReminderDateTime = eventObject.StartDateTime.addMinutes(-15);
        insert eventObject;
    }
    
    @isTest
    public static void testScheduleOperatorMeeting()
    {
        Account acc = new Account(Name = 'Test');
        insert acc;
        Apexpages.standardController accountStandard = new Apexpages.standardController(acc);
        ScheduleOperatorMeetingController scheduleOperator = new ScheduleOperatorMeetingController(accountStandard);
        scheduleOperator.EventObject.StartDateTime = DateTime.now();
        scheduleOperator.EventType = 'Account Review';
        scheduleOperator.saveScheduleOperator();
    }
}