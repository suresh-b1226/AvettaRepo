global class PaymentToCommissionScheduler implements Schedulable
{
    global void execute(SchedulableContext ctx)
    {
        /*
        String query = 'select Operator__c, Payment_Date__c, Contractor__c, Invoice_ID__c, Payment_ID__c, Total_Payment_Amount__c, Invoice_Type__c, Commissionable_Amount__c, Transaction_Status__c, Invoice_Total_Amount__c, CurrencyIsoCode from Organizer_Payment__c where Commission_Assigned__c = false and Payment_Date__c != null';
        PaymentToCommissionBatch paymentToCommissionBatch = new PaymentToCommissionBatch(query);
        Database.executeBatch(paymentToCommissionBatch, 50);
        */
    }
}