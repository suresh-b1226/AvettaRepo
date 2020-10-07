public class API_SER_DatedConversionRate_Queueable implements Queueable, Database.AllowsCallouts 
{
    public static void execute(QueueableContext context) 
    {
        API_SER_DatedConversionRate_RetrieveJSON.getALLJSON();		
    }
}