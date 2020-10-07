/**
 * Created by JasonMcGrew on 2/27/2020.
 */

trigger Live_Chat_Transcript on LiveChatTranscript (after insert, after update) {

    API_CS_Callminer_Chat callMinerAPIChat = new API_CS_Callminer_Chat();

    if(Trigger.isUpdate  && Trigger.isAfter){
        callMinerAPIChat.generateChatTranscriptJSON(Trigger.new);
    }

}