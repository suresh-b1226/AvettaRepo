/**
 * Created by JasonMcGrew on 8/26/2020.
 */

@IsTest
private class chatMessagesController_Test {


    @isTest static void test_chatMessagesController() {
        chatMessagesController chatMessage = new chatMessagesController();
        chatMessagesController.getAllChatBotLinks();
    }
}