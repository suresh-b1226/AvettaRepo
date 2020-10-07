/**
 * Created by JasonMcGrew on 9/25/2019.
 *
 *
 */

    global class Supplier_SavesDeact_Opty_Batch_Scheduled implements Schedulable{

        global void execute(SchedulableContext sc){

            Supplier_SavesDeact_Opty_Deact_Batch b = new Supplier_SavesDeact_Opty_Deact_Batch();
            if(!Test.isRunningTest()){

                Database.executeBatch(b, 10);
            }
        }
    }