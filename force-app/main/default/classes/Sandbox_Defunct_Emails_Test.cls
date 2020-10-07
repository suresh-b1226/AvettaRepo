@isTest(SeeAllData=true) public class Sandbox_Defunct_Emails_Test {
    
    @isTest(SeeAllData=true) static void Sandbox_Defunct_Emails_Test(){
        Test.startTest();
        Sandbox_Defunct_Emails handler = new Sandbox_Defunct_Emails();
        database.executeBatch(handler);
        Test.stopTest();
    }
}