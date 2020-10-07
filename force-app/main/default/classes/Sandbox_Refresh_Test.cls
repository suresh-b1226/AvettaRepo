@isTest(SeeAllData=true) public class Sandbox_Refresh_Test {
    
    @isTest(SeeAllData=true) static void Sandbox_Refresh_Test(){
        Test.startTest();
        Sandbox_Refresh handler = new Sandbox_Refresh();
        database.executeBatch(handler);
        Test.stopTest();
    }
}