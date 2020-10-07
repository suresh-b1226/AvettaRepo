/**
 * Created by JasonMcGrew on 9/6/2019.
 *
 *
 */

global class CommunitiesNewUserCreation_Schedulable implements Schedulable{

    global void execute(SchedulableContext sc){

        CommunitiesNewUserCreation_Batch b = new CommunitiesNewUserCreation_Batch();
        if(!Test.isRunningTest()){

            Database.executeBatch(b, 20);
        }
    }
}