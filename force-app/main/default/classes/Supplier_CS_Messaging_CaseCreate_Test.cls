@isTest
public class Supplier_CS_Messaging_CaseCreate_Test {
    
    @isTest
    static void createSMS() {
        User thisUser = [ SELECT Id FROM User WHERE Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            MessagingChannel mc = new MessagingChannel();
            mc.DeveloperName = 'TestChannel';
            mc.MasterLabel = 'TestLabel';
            mc.MessageType = 'Facebook';
            mc.MessagingPlatformKey = '169513519733592';
            Insert mc;
            
            MessagingChannel insertedMC = [select Id, MessagingPlatformKey, DeveloperName
                                           from MessagingChannel
                                           limit 1];
            
            MessagingEndUser meu = new MessagingEndUser();
            meu.MessageType = 'Text';
            meu.MessagingChannelId = insertedMC.Id;
            meu.MessagingPlatformKey = insertedMC.MessagingPlatformKey;
            meu.Name = insertedMC.DeveloperName;
            Insert meu;
            
            MessagingSession ms = new MessagingSession();
            
            ms.MessagingEndUserId = meu.Id;
            ms.MessagingChannelId = mc.Id;
            //ms.Origin = 'Inbound Initiated';
            ms.Status = 'Ended';
            insert ms;
            
        }
    }
    
}