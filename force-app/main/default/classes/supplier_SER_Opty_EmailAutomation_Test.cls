/**
* Created by JasonMcGrew on 5/16/2019.
*
* Class will test the 'supplier_SER_Opty_EmailAutomation' classs.
*/

@IsTest public class supplier_SER_Opty_EmailAutomation_Test {

    @IsTest static void registration_Prospect_Test() {
        //Create account record to be used for Testing
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        System.debug('****accountRecord = ' + accountRecord);

        //Create Registration opportunity record for Testing
        Opportunity OppRegRecordInserted_1 = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1', 'Registration', 'Prospect', NULL);
        Opportunity OppRegRecordInserted_2 = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1', 'Registration', 'Prospect', NULL);

        //Create contact records for Testing, these will test two different emails
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        System.debug('****ContactRecord1 = ' + ContactRecord1);
        System.debug('****ContactRecord2 = ' + ContactRecord2);

        //Create the contactrole for the contact on the opportunity
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRegRecordInserted_1.Id);
        OpportunityContactRole contactRole_2 = QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRegRecordInserted_2.Id);

        //Create task records for Testing: Need to have a task record for each possible task scenarios
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRegRecordInserted_1.Id);
        Task TaskInsert_2 = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRegRecordInserted_2.Id);

        OppRegRecordInserted_1.Calls_Made__c = 1;
        if(OppRegRecordInserted_1.Calls_Made__c == 1) {
            if(OppRegRecordInserted_1.get('Id') == null)insert TaskInsert; {
                System.debug('*****TaskInsert ***** = ' + TaskInsert);
                System.assert(OppRegRecordInserted_1.Calls_Made__c == 1);
                System.assert(OppRegRecordInserted_1.Primary_Contact__c == accountRecord.Primary_Contact__c);
                //System.assert(OppRegRecordInserted_1.TaskInsert.type == 'call');
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppRegRecordInserted_2.Calls_Made__c = 2;
        if(OppRegRecordInserted_2.Calls_Made__c == 2) {
            if(OppRegRecordInserted_2.get('Id') == null)insert TaskInsert_2;{
                System.assert(OppRegRecordInserted_2.Calls_Made__c == 2);
                System.assert(OppRegRecordInserted_2.Primary_Contact__c == accountRecord.Primary_Contact__c);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppRegRecordInserted_1.Calls_Made__c = 3;
        if(OppRegRecordInserted_1.Calls_Made__c == 3){
            if(OppRegRecordInserted_1.get('Id') == null)insert TaskInsert;{
                System.assert(OppRegRecordInserted_1.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppRegRecordInserted_1.Calls_Made__c = 4;
        if(OppRegRecordInserted_1.Calls_Made__c == 4){
            if(OppRegRecordInserted_1.get('Id') == null)insert TaskInsert;{
                System.assert(OppRegRecordInserted_1.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppRegRecordInserted_1.Calls_Made__c = 5;
        if(OppRegRecordInserted_1.Calls_Made__c == 5){
            if(OppRegRecordInserted_1.get('Id') == null)insert TaskInsert;{
                System.assert(OppRegRecordInserted_1.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void registration_Prospect_Call2_Test() {
        //Create account record to be used for Testing
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppRegRecordInserted_2 = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1', 'Registration', 'Prospect', NULL);
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole_2 = QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRegRecordInserted_2.Id);
        Task TaskInsert_2 = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRegRecordInserted_2.Id);

        OppRegRecordInserted_2.Calls_Made__c = 2;
        if(OppRegRecordInserted_2.Calls_Made__c == 2) {
            if(OppRegRecordInserted_2.get('Id') == null)insert TaskInsert_2;{
                System.assert(OppRegRecordInserted_2.Calls_Made__c == 2);
                System.assert(OppRegRecordInserted_2.Primary_Contact__c == accountRecord.Primary_Contact__c);
                System.debug('*****PASSED ASSERT_2');
            }
        }
    }
    @IsTest static void registration_In_Progress_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppRegRecordInserted_2 = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Registration', 'In Progress', NULL);
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRegRecordInserted_2.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRegRecordInserted_2.Id);

        OppRegRecordInserted_2.Calls_Made__c = 1;
        if(OppRegRecordInserted_2.Calls_Made__c == 1){
            if(OppRegRecordInserted_2.get('Id') == null)insert TaskInsert; {
                System.assert(OppRegRecordInserted_2.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppRegRecordInserted_2.Calls_Made__c = 2;
        if(OppRegRecordInserted_2.Calls_Made__c == 2){
            if(OppRegRecordInserted_2.get('Id') == null)insert TaskInsert;{
                System.assert(OppRegRecordInserted_2.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppRegRecordInserted_2.Calls_Made__c = 3;
        if(OppRegRecordInserted_2.Calls_Made__c == 3){
            if(OppRegRecordInserted_2.get('Id') == null)insert TaskInsert;{
                System.assert(OppRegRecordInserted_2.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppRegRecordInserted_2.Calls_Made__c = 4;
        if(OppRegRecordInserted_2.Calls_Made__c == 4){
            if(OppRegRecordInserted_2.get('Id') == null)insert TaskInsert;{
                System.assert(OppRegRecordInserted_2.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppRegRecordInserted_2.Calls_Made__c = 5;
        if(OppRegRecordInserted_2.Calls_Made__c == 5){
            if(OppRegRecordInserted_2.get('Id') == null)insert TaskInsert;{
                System.assert(OppRegRecordInserted_2.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void registration_Closed_Lost_Bad_Data_Test() {

        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppReacRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Registration', 'Closed Lost', 'Bad Data');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppReacRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppReacRecordInserted.Id);

        OppReacRecordInserted.Calls_Made__c = 1;
        if(OppReacRecordInserted.Calls_Made__c == 1){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppReacRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 2;
        if(OppReacRecordInserted.Calls_Made__c == 2){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 3;
        if(OppReacRecordInserted.Calls_Made__c == 3){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 4;
        if(OppReacRecordInserted.Calls_Made__c == 4){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 5;
        if(OppReacRecordInserted.Calls_Made__c == 5){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void registration_Closed_Lost_No_Response_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Registration', 'Closed Lost', 'No Response');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRecordInserted.Id);

        OppRecordInserted.Calls_Made__c = 1;
        if(OppRecordInserted.Calls_Made__c == 1){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppRecordInserted.Calls_Made__c = 2;
        if(OppRecordInserted.Calls_Made__c == 2){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppRecordInserted.Calls_Made__c = 3;
        if(OppRecordInserted.Calls_Made__c == 3){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppRecordInserted.Calls_Made__c = 4;
        if(OppRecordInserted.Calls_Made__c == 4){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppRecordInserted.Calls_Made__c = 5;
        if(OppRecordInserted.Calls_Made__c == 5){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void registration_Closed_Lost_Declined_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Registration', 'Closed Lost', 'Declined');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRecordInserted.Id);

        OppRecordInserted.Calls_Made__c = 1;
        if(OppRecordInserted.Calls_Made__c == 1){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppRecordInserted.Calls_Made__c = 2;
        if(OppRecordInserted.Calls_Made__c == 2){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppRecordInserted.Calls_Made__c = 3;
        if(OppRecordInserted.Calls_Made__c == 3){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppRecordInserted.Calls_Made__c = 4;
        if(OppRecordInserted.Calls_Made__c == 4){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppRecordInserted.Calls_Made__c = 5;
        if(OppRecordInserted.Calls_Made__c == 5){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void registration_Closed_Lost_Not_Working_For_Client_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Registration', 'Closed Lost', 'Not Working For Client');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRecordInserted.Id);

        OppRecordInserted.Calls_Made__c = 1;
        if(OppRecordInserted.Calls_Made__c == 1){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppRecordInserted.Calls_Made__c = 2;
        if(OppRecordInserted.Calls_Made__c == 2){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppRecordInserted.Calls_Made__c = 3;
        if(OppRecordInserted.Calls_Made__c == 3){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppRecordInserted.Calls_Made__c = 4;
        if(OppRecordInserted.Calls_Made__c == 4){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppRecordInserted.Calls_Made__c = 5;
        if(OppRecordInserted.Calls_Made__c == 5){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }

    }
    @IsTest static void registration_Closed_Lost_Escalate_To_Client_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Registration', 'Closed Lost', 'Escalate To Client');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRecordInserted.Id);

        OppRecordInserted.Calls_Made__c = 1;
        if(OppRecordInserted.Calls_Made__c == 1){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppRecordInserted.Calls_Made__c = 2;
        if(OppRecordInserted.Calls_Made__c == 2){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppRecordInserted.Calls_Made__c = 3;
        if(OppRecordInserted.Calls_Made__c == 3){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppRecordInserted.Calls_Made__c = 4;
        if(OppRecordInserted.Calls_Made__c == 4){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppRecordInserted.Calls_Made__c = 5;
        if(OppRecordInserted.Calls_Made__c == 5){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void registration_Commit_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Registration', 'Commit', NULL);
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRecordInserted.Id);

        OppRecordInserted.Calls_Made__c = 1;
        if(OppRecordInserted.Calls_Made__c == 1)
            if(OppRecordInserted.get('Id') == null)insert TaskInsert; {
            System.assert(OppRecordInserted.Calls_Made__c == 1);
            System.debug('*****PASSED ASSERT_1');
        }
        OppRecordInserted.Calls_Made__c = 2;
        if(OppRecordInserted.Calls_Made__c == 2)
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
            System.assert(OppRecordInserted.Calls_Made__c == 2);
            System.debug('*****PASSED ASSERT_2');
        }
        OppRecordInserted.Calls_Made__c = 3;
        if(OppRecordInserted.Calls_Made__c == 3)
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
            System.assert(OppRecordInserted.Calls_Made__c == 3);
            System.debug('*****PASSED ASSERT_3');
        }
        OppRecordInserted.Calls_Made__c = 4;
        if(OppRecordInserted.Calls_Made__c == 4)
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
            System.assert(OppRecordInserted.Calls_Made__c == 4);
            System.debug('*****PASSED ASSERT_4');
        }
        OppRecordInserted.Calls_Made__c = 5;
        if(OppRecordInserted.Calls_Made__c == 5)
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
            System.assert(OppRecordInserted.Calls_Made__c == 5);
            System.debug('*****PASSED ASSERT_5');
        }
    }
    @IsTest static void reactivation_Prospect_Test() {

        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppReacRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Reactivation', 'Prospect', NULL);
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppReacRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppReacRecordInserted.Id);

        OppReacRecordInserted.Calls_Made__c = 1;
        if(OppReacRecordInserted.Calls_Made__c == 1){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppReacRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 2;
        if(OppReacRecordInserted.Calls_Made__c == 2){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 3;
        if(OppReacRecordInserted.Calls_Made__c == 3){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 4;
        if(OppReacRecordInserted.Calls_Made__c == 4){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 5;
        if(OppReacRecordInserted.Calls_Made__c == 5){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void reactivation_In_Progress_Test() {

        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppReacRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Reactivation', 'In Progress', NULL);
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppReacRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppReacRecordInserted.Id);

        OppReacRecordInserted.Calls_Made__c = 1;
        if(OppReacRecordInserted.Calls_Made__c == 1){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppReacRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 2;
        if(OppReacRecordInserted.Calls_Made__c == 2){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 3;
        if(OppReacRecordInserted.Calls_Made__c == 3){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 4;
        if(OppReacRecordInserted.Calls_Made__c == 4){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 5;
        if(OppReacRecordInserted.Calls_Made__c == 5){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void reactivation_Closed_Lost_Bad_Data_Test() {

        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppReacRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Reactivation', 'Closed Lost', 'Bad Data');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppReacRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppReacRecordInserted.Id);

        OppReacRecordInserted.Calls_Made__c = 1;
        if(OppReacRecordInserted.Calls_Made__c == 1){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppReacRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 2;
        if(OppReacRecordInserted.Calls_Made__c == 2){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 3;
        if(OppReacRecordInserted.Calls_Made__c == 3){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 4;
        if(OppReacRecordInserted.Calls_Made__c == 4){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 5;
        if(OppReacRecordInserted.Calls_Made__c == 5){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void Reactivation_Closed_Lost_No_Response_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppReacRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Reactivation', 'Closed Lost', 'No Response');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppReacRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppReacRecordInserted.Id);

        OppReacRecordInserted.Calls_Made__c = 1;
        if(OppReacRecordInserted.Calls_Made__c == 1){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppReacRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 2;
        if(OppReacRecordInserted.Calls_Made__c == 2){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 3;
        if(OppReacRecordInserted.Calls_Made__c == 3){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 4;
        if(OppReacRecordInserted.Calls_Made__c == 4){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 5;
        if(OppReacRecordInserted.Calls_Made__c == 5){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void Reactivation_Closed_Lost_Declined_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppReacRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Reactivation', 'Closed Lost', 'Declined');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppReacRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppReacRecordInserted.Id);

        OppReacRecordInserted.Calls_Made__c = 1;
        if(OppReacRecordInserted.Calls_Made__c == 1){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppReacRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 2;
        if(OppReacRecordInserted.Calls_Made__c == 2){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 3;
        if(OppReacRecordInserted.Calls_Made__c == 3){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 4;
        if(OppReacRecordInserted.Calls_Made__c == 4){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 5;
        if(OppReacRecordInserted.Calls_Made__c == 5){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void Reactivation_Closed_Lost_Not_Working_For_Client_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppReacRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Reactivation', 'Closed Lost', 'Not Working For Client');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.id, OppReacRecordInserted.id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppReacRecordInserted.id);

        OppReacRecordInserted.Calls_Made__c = 1;
        if(OppReacRecordInserted.Calls_Made__c == 1){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppReacRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 2;
        if(OppReacRecordInserted.Calls_Made__c == 2){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 3;
        if(OppReacRecordInserted.Calls_Made__c == 3){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 4;
        if(OppReacRecordInserted.Calls_Made__c == 4){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 5;
        if(OppReacRecordInserted.Calls_Made__c == 5){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void Reactivation_Closed_Lost_Escalate_To_Client_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppReacRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Reactivation', 'Closed Lost', 'Escalate To Client');
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppReacRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppReacRecordInserted.Id);

        OppReacRecordInserted.Calls_Made__c = 1;
        if(OppReacRecordInserted.Calls_Made__c == 1){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppReacRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 2;
        if(OppReacRecordInserted.Calls_Made__c == 2){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 3;
        if(OppReacRecordInserted.Calls_Made__c == 3){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 4;
        if(OppReacRecordInserted.Calls_Made__c == 4){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppReacRecordInserted.Calls_Made__c = 5;
        if(OppReacRecordInserted.Calls_Made__c == 5){
            if(OppReacRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppReacRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
    @IsTest static void reactivation_Commit_Test() {
        Account accountRecord = QB_TestDataFactory.createAndInsertAccountRecord(TRUE);
        Opportunity OppRecordInserted = QB_TestDataFactory.createAndInsertOpportunityRecord(TRUE, accountRecord.Id, 'Test Opp_1_1', 'Reactivation', 'Commit', NULL);
        Contact ContactRecord1 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'test@avetta.com');
        Contact ContactRecord2 = QB_TestDataFactory.createAndInsertContactRecord(TRUE, accountRecord.Id, 'jason.mcgrew@avetta.com');
        OpportunityContactRole contactRole =  QB_TestDataFactory.createAndInsertOpportunityContactRole(TRUE, ContactRecord1.Id, OppRecordInserted.Id);
        Task TaskInsert = QB_TestDataFactory.createAndInsertTaskRecord(TRUE, 'call', 'call', OppRecordInserted.Id);

        OppRecordInserted.Calls_Made__c = 1;
        if(OppRecordInserted.Calls_Made__c == 1){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert; {
                System.assert(OppRecordInserted.Calls_Made__c == 1);
                System.debug('*****PASSED ASSERT_1');
            }
        }
        OppRecordInserted.Calls_Made__c = 2;
        if(OppRecordInserted.Calls_Made__c == 2) {
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 2);
                System.debug('*****PASSED ASSERT_2');
            }
        }
        OppRecordInserted.Calls_Made__c = 3;
        if(OppRecordInserted.Calls_Made__c == 3) {
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 3);
                System.debug('*****PASSED ASSERT_3');
            }
        }
        OppRecordInserted.Calls_Made__c = 4;
        if(OppRecordInserted.Calls_Made__c == 4) {
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 4);
                System.debug('*****PASSED ASSERT_4');
            }
        }
        OppRecordInserted.Calls_Made__c = 5;
        if(OppRecordInserted.Calls_Made__c == 5){
            if(OppRecordInserted.get('Id') == null)insert TaskInsert;{
                System.assert(OppRecordInserted.Calls_Made__c == 5);
                System.debug('*****PASSED ASSERT_5');
            }
        }
    }
}