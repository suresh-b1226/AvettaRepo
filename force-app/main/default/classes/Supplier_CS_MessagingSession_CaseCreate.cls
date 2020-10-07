/******************************************************************************************************************************************
*
* WRITTEN BY: Dallin Wasden 5.20.2020
*
* SUMMARY OF USAGE:
* Used in conjunction with SMS messages. When an SMS message (sObject - Messaging Session) comes in, this class creates a corresponding
* case to be used.
*
******************************************************************************************************************************************/

public class Supplier_CS_MessagingSession_CaseCreate {

    public void createSMSCase(List<MessagingSession> TriggerNew) {
        List<Case> newCases = new List<Case>();
        for(MessagingSession ms : TriggerNew) {
            Case newCase = new Case();
            newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
            newCase.Origin = 'SMS';
            newCase.Subject = 'SMS Chat';
            newCase.Description = 'Enter the description of the support request';
            newCase.OwnerId = ms.OwnerId;
            
            newCases.add(newCase);
        }
        
        insert newCases;
    }
    
}