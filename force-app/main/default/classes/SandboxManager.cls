/**
 * Created by JasonMcGrew on 5/30/2019.
 *
 * This GLOBAL Class will run when the sandbox refreshes.
 * It calls class methods that will be run during the sandbox refresh.
 *
 */

global class SandboxManager implements SandboxPostCopy {

    global void runApexClass (SandboxContext context) {
        System.debug(' ** Org ID = ' + context.organizationId());
        System.debug(' ** Sandbox ID = ' + context.sandboxId());
        System.debug(' ** Sandbox Name = ' + context.sandboxName());

        Sandbox_Variable_Initialization.userProfileUpdate();
        
        User thisUser = [
                SELECT Id
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];
        System.runAs(thisUser){

            Id BatchJobId = Database.executeBatch(new Sandbox_Defunct_Emails(), 500);
            Sandbox_Variable_Initialization.createRoundRobin();
            Sandbox_Variable_Initialization.create_SDR_Mapping();

        }
    }
}