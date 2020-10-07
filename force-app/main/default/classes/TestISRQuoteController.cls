@isTest(SeeAllData=true)
public class TestISRQuoteController
{
    @isTest
    static void testDefineISRQuotaController()
    {
        User employee = [select Id, SalesManager__c from User where IsActive = true and id != :UserInfo.getUserId() limit 1];
        employee.SalesManager__c = UserInfo.getUserId();
        update employee;
        ISR_Quota__c quota1 = new ISR_Quota__c(Month__c = Date.today().toStartOfMonth(), Quota__c = 1000, Year__c = String.valueOf(date.today().year()), Employee__c = employee.Id, Manager__c = UserInfo.getUserId());
        insert quota1;
        DefineISRQuoteController controller = new DefineISRQuoteController();
        for(DefineISRQuoteController.ISRQuoteInfo isrQUota : controller.CurrentSalesManagerISRQuotes[0].CurrentQuotes)
        {
            if(isrQUota.ISRQuote.Month__c != Date.today().toStartOfMonth())
            {
                isrQUota.ISRQuote.Quota__c = 100;
            }
        }
        system.assert(controller.AllQuotesMonths != null);
        system.assert(controller.AllSalesOptions != null);
        controller.defineQuotes();
    }
    
    @isTest
    static void testViewISRQuotaController()
    {
        User employee = [select Id, SalesManager__c from User where IsActive = true and id != :UserInfo.getUserId() limit 1];
        employee.SalesManager__c = UserInfo.getUserId();
        update employee;
        ISR_Quota__c quota1 = new ISR_Quota__c(Month__c = Date.today().toStartOfMonth(), Quota__c = 1000, Year__c = String.valueOf(date.today().year()), Employee__c = employee.Id, Manager__c = UserInfo.getUserId());
        insert quota1;
        ISRViewQuotasController controller = new ISRViewQuotasController();
        controller.SelectUserId = UserInfo.getuserId();
        controller.Year = String.valueOf(Date.Today().year());
        controller.populateQuotas();
        system.assert(controller.AllSalesOptions != null);
        system.assert(controller.AllSalesManagerOptions != null);
        system.assert(controller.AllYearsOptions != null);
        system.assert(controller.AllQuotesMonths != null);
    }  
}