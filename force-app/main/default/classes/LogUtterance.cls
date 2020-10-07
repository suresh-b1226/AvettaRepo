public with sharing class LogUtterance {

public class LogInput{

    @InvocableVariable(required=false)

    public String sCurrentUtterance;

    @InvocableVariable(required=true)

    public String sLiveAgentTranscriptId;

    @InvocableVariable(required=false)

    public String sDeploymentVersion;

}

 

@InvocableMethod(label='Log Utterance')

public static void logUtterance(List<LogInput> inputParameters)

{

    String sCurrentUtterance = inputParameters[0].sCurrentUtterance;

    String sLiveAgentTranscriptId = inputParameters[0].sLiveAgentTranscriptId;

    String sDeploymentVersion = inputParameters[0].sDeploymentVersion;




 

    // Create a new Utterance Log record

    Utterance_Log__c logRecord = new Utterance_Log__c();

 

    // Store the utterance

    logRecord.CurrentUtterance__c = sCurrentUtterance;

    logRecord.Chat_Transcript__c = sLiveAgentTranscriptId;

    logRecord.Deployment_Version__c = sDeploymentVersion;



 

    // Save the log utterance record to our org

    insert logRecord;

}

}