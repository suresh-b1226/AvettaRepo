/***********************************************************************************************
* Created by Mark Simpson 9/3/2019 
* 
* This class is designed to determine which language the email automation templates will 
* be sent out as. A call is made to the original supplier_SER_Opty_EmailAutomation class 
* that will contain a list of current contacts who will receive automation emails. 
* 
* The original list will be reviewed against a new list that will search for foreign contacts
* if foreign contacts are found, those foreign entities will be moved to a new list which will
* then be assigned the language that the country is located in.
* 
* The new list will then be returned back to the original email automation classk
* 
* Salesforce Case #01175336 - Email Automation Language Enhancements
* *********************************************************************************************/
public class supplier_SER_Opty_LanguageEmailTemplate {
    private static Boolean firstRun = true;
    private static Integer runCount = 0;
    
    //Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }
    
    //Method to set recursion variable to false
    public static void addRunCount() {
        runCount = runCount + 1;
        System.debug('runCount = ' + runCount);
    }
    
    public Boolean DetermineLanguageTemplate(Opportunity opp, List<Contact> optyContact, ID fromId, List<Id> accountIds, ContentVersion attachment) {
        Boolean success = true;
        
        if(runCount == 0 || (Test.isRunningTest() == TRUE && supplier_SER_Opty_EmailAutomation.runCount < 10)) { 
            
            //Creating a soql object called accountCountry that is used to pull the language used in the salesforce account
            //The object is set to the accountID that was generated in the previous class to ensure the correct email is sent
            List<Account> accountCountry = [
                SELECT CountryLanguage__c
                FROM Account
                WHERE Id =:accountIds
            ];
            
            //For loop that runs through the generated accounts that evaluates the country language set in the account.
            //This field will determine which template is used. The opp, optycontact, fromid, and accountID fields
            //that have been brought over from the emailautomation class are passed into the template methods here
            //The first condition will be executed if the account country language is set to spanish. The second
            //condition will be run if the account country language is set to portuguese. If neither of the first
            //two conditions are met, the country language will be determined as english. A call to another class
            //is made which will perform the action of preparing the email template in the determined language based
            //off of the country language set by the end user. The seperate language templates are prepared in
            //seperate classes to allow more dynamic functionality in the future and for easier code maintainance
            
            for(Account acc: accountCountry) {
                supplier_SER_Opty_GenericEmailSetup setupEmail = new supplier_SER_Opty_GenericEmailSetup();
                success = setupEmail.ConfigureGenericEmailTemplate(opp, optyContact, fromId, accountIds, acc.CountryLanguage__c, attachment);
                if (!success)
                    break;
                
                // if(acc.CountryLanguage__c == 'Spanish') {
                //     Supplier_SER_Opty_SpanishEmailSetup prepareSpanishEmail = new Supplier_SER_Opty_SpanishEmailSetup();
                //     prepareSpanishEmail.ConfigureSpanishEmailTemplate(opp, optyContact, fromId, accountIds);
                // }
                
                // else if(acc.CountryLanguage__c == 'Portuguese') {
                //     Supplier_SER_Opty_PortugueseEmailSetup preparePortugueseEmail = new Supplier_SER_Opty_PortugueseEmailSetup();
                //     preparePortugueseEmail.ConfigurePortugueseEmailTemplate(opp, optyContact, fromId, accountIds);
                // }
                
                // else if(acc.CountryLanguage__c == 'English') {
                //     Supplier_SER_Opty_EnglishEmailSetup prepareEnglishEmail = new Supplier_SER_Opty_EnglishEmailSetup();
                //     prepareEnglishEmail.ConfigureEnglishEmailTemplate(opp, optyContact, fromId, accountIds);
                // }
                
                // else if(acc.CountryLanguage__c == 'German') {
                //     Supplier_SER_Opty_GermanEmailSetup prepareGermanEmail = new Supplier_SER_Opty_GermanEmailSetup();
                //     prepareGermanEmail.ConfigureGermanEmailTemplate(opp, optyContact, fromId, accountIds);
                // }
                
                // else if(acc.CountryLanguage__c == 'Dutch') {
                //     Supplier_SER_Opty_DutchEmailSetup prepareDutchEmail = new Supplier_SER_Opty_DutchEmailSetup();
                //     prepareDutchEmail.ConfigureDutchEmailTemplate(opp, optyContact, fromId, accountIds);
                // }
                
                addRunCount();
            }
        }
        return success;
    }
    
    ///This is the final action in the email automation process. This method builds the email and takes the templates
    //previously built and then performs the action of sending the email. Called at the bottom of each template method
    public void SendEmail(Opportunity opp, EmailTemplate serEmailTemp, List<Contact> OptyContact, Id fromId, ContentVersion attachment) {
        
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        if (serEmailTemp != NULL) {
        	email.add(emailHelper.ser_SendEmail(opp, serEmailTemp, OptyContact[0], fromID, attachment));
        }
        
        if (email.size() > 0) {
            Messaging.sendEmail(email);
        }
    }
}