@isTest
public class Sandbox_Variable_Initialization_Test {
    
    @isTest static void test_Sandbox_Variable() {       
        Sandbox_Variable_Initialization testRoundRobin = new Sandbox_Variable_Initialization();
            Sandbox_Variable_Initialization.createRoundRobin();
    }    
    
    @isTest static void test_Sandbox_Profile() {       
        Sandbox_Variable_Initialization testProfileId = new Sandbox_Variable_Initialization();
            Sandbox_Variable_Initialization.userProfileUpdate();
    }

    @isTest static void test_SDR_Mapping() {
        Sandbox_Variable_Initialization testSdrMapping = new Sandbox_Variable_Initialization();
            Sandbox_Variable_Initialization.create_SDR_Mapping();


    }
}