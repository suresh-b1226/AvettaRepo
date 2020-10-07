// Reference: http://www.xgeek.net/salesforce/a-way-to-make-thread-sleep-in-apex/

public class ApexUtil {

  /**********************************************************
   *  Helper Method: wait
   *  @param Integer millisec : time for wait (millisecond)
   *********************************************************/
  public static void wait(Integer millisec) {
    
    if(millisec == null || millisec < 0) {
      millisec = 0;
    }
      
    Long startTime = DateTime.now().getTime();
    Long finishTime = DateTime.now().getTime();
    while ((finishTime - startTime) < millisec) {
      //sleep for parameter x millisecs
      finishTime = DateTime.now().getTime();
    }
    // System.debug('>>> Done from ' + startTime + ' to ' + finishTime);
  }
}