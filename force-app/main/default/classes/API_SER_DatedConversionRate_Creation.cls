public class API_SER_DatedConversionRate_Creation implements Schedulable
{
    public static void execute(SchedulableContext sc)
    {
        API_SER_DatedConversionRate_Queueable apiDCR = new API_SER_DatedConversionRate_Queueable();
        System.enqueueJob(new API_SER_DatedConversionRate_Queueable());
    }
    
    //@future(callout=true)
    public static void scheduleNowSuccess() {
        
        datetime thisTime = System.now();   
        datetime outputTime;
        
        String outputString;
        String timeStamp;
        String jobName = 'API_SER_DatedConversionRate_Creation';
        
        Integer second = thisTime.second();
        Integer minute = thisTime.minute();
        Integer hour = thisTime.hour();
        Integer day = thisTime.day();
        Integer month = thisTime.month();
        Integer year = thisTime.year();
        
        System.debug('The time now is ' + thisTime);
        System.debug('The month is now ' + month);      
        
        if (month == 12) {
            month = 1; year += 1;
        } 
        
        else if (month != 12) {
            month += 1;
        }
        
        if (day > 27) {
            day = Date.daysInMonth(year, month);
        }

        System.debug('The time + 1 MONTH ' + month);
        
        timeStamp = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
        System.debug('Time stamp looks like: ' + timeStamp);
        
		CronJobDetail[] cronQuery = 
            [SELECT Id, Name FROM CronJobDetail WHERE Name = 'API_SER_DatedConversionRate_Creation'];
        
        if (cronQuery.size() == 0) {
            scheduleNowBecauseFail();
        }
        
        else {
			
            CronTrigger cronToAbort = [SELECT Id FROM CronTrigger WHERE CronJobDetailId =: cronQuery[0].Id];
            System.abortJob(cronToAbort.Id);
            
            API_SER_DatedConversionRate_Creation p = new API_SER_DatedConversionRate_Creation();
            System.schedule(jobName, timeStamp, p);
        }
    }
    
    //@future(callout=true)
    public static void scheduleNowBecauseFail() {
        
        datetime thisTime = System.now();   
        String timeStamp;
        String jobName = 'API_SER_DatedConversionRate_Creation';
        
        Integer second = thisTime.second();
        Integer minute = thisTime.minute();
        Integer hour = thisTime.hour();
        Integer day = thisTime.day();
        Integer month = thisTime.month();
        Integer year = thisTime.year();
        
        System.debug('The time now is ' + thisTime);
        
		//Check if there is an exisiting job already.
		CronJobDetail[] cronQuery = [SELECT Id, Name FROM CronJobDetail WHERE Name = 'API_SER_DatedConversionRate_Creation'];
        
        //Revised by Emmon Chow 5/1/2019
        if (cronQuery.size() == 0) { //If there is no Job by that name, create one and run it in one minute.
            System.debug('Job named \'API_SER_DatedConversionRate_Creation\' not found under scheduled Apex jobs');
            System.debug('Creating a test job starting 2 minutes from now');
            
           	if (minute == 59) {
                minute = 0; hour += 1;
            } 
            
            else {
                minute += 2;
            }
           
			System.debug('Test job created. A final job will be created when the test is run to be scheduled the 1st of the month');
        } 
        
        else {    
        	
            CronTrigger[] cronToAbort = [SELECT Id FROM CronTrigger WHERE CronJobDetailId =: cronQuery[0].Id];       
            System.abortJob(cronToAbort[0].Id);
            
            minute = minute <= 29 ? 30 : 59;
            System.debug('The nearest 30 minute increment is ' + minute);
            System.debug('Old job found, new job scheduled..');
        }
        
        timeStamp = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
        API_SER_DatedConversionRate_Creation p = new API_SER_DatedConversionRate_Creation();	        
        System.schedule(jobName, timeStamp, p); //Creating the Apex Job
    }  
}