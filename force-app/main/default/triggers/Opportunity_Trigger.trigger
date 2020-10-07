/**
 * Created by dwasden on 11/1/2018.
 */

trigger Opportunity_Trigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Supplier_Collect_Opty_FollowUp  Supplier_Collect_Opty_FollowUp                       = new Supplier_Collect_Opty_FollowUp();
    Supplier_Collect_Opty_RoundRobin    Supplier_Collect_Opty_RoundRobin                 = new Supplier_Collect_Opty_RoundRobin();
    Supplier_SavesDeactivation_Opty_FollowUp    Supplier_SavesDeactivation_Opty_FollowUp = new Supplier_SavesDeactivation_Opty_FollowUp();
    Supplier_SavesDeact_Opty_RoundRobin Supplier_SavesDeact_Opty_RoundRobin              = new Supplier_SavesDeact_Opty_RoundRobin();
    Supplier_SavesDowngrade_Opty_FollowUp Supplier_SavesDowngrade_Opty_FollowUp          = new Supplier_SavesDowngrade_Opty_FollowUp();
    Supplier_SavesDowngrade_Opty_RoundRobin Supplier_SavesDowngrade_Opty_RoundRobin      = new Supplier_SavesDowngrade_Opty_RoundRobin();
    updateContactRole    UpdateContactRole                                               = new updateContactRole();
    Supplier_SavesDeact_Opty_Deactivation  OptyDeactivationRequests                      = new Supplier_SavesDeact_Opty_Deactivation();
    Supplier_SER_Opty_Registration_RR registrationRoundRobin                             = new Supplier_SER_Opty_Registration_RR();

    
    //After insert and After Update.
    if(Trigger.isInsert && Trigger.isBefore){
        Supplier_SavesDowngrade_Opty_RoundRobin.Supplier_SavesDowngrade_Opty_RoundRobin_Handler(Trigger.new, Trigger.old);
        Supplier_SavesDeact_Opty_RoundRobin.Supplier_SavesDeact_Opty_RoundRobin_Handler(Trigger.new /*, Trigger.old*/);
        Supplier_Collect_Opty_RoundRobin.Supplier_Collect_Opty_RoundRobinHandler(Trigger.new);
        registrationRoundRobin.QueryRegistrationOpportunity(Trigger.new);
        
        CCP_Pricing_Opportunity_Model pricingModel = new CCP_Pricing_Opportunity_Model(Trigger.new);
        pricingModel.calculateTotalCCPAllOpps();
    }

    //After insert and After Update.
    if(Trigger.isInsert && Trigger.isAfter){
        OptyDeactivationRequests.SER_Opty_Midterm_Deactivation_Handler(Trigger.new);
        OptyDeactivationRequests.SER_Deactivation_Requests_Handler(Trigger.new);
    } 

    if(Trigger.isUpdate && Trigger.isBefore){
        CCP_Pricing_Opportunity_Model pricingModel = new CCP_Pricing_Opportunity_Model(Trigger.new);
        pricingModel.calculateTotalCCPAllOpps();

    }

    if(Trigger.isUpdate && Trigger.isAfter){
        Supplier_Collect_Opty_FollowUp.Supplier_Collect_Opty_FollowUp_Handler(Trigger.new, Trigger.old);
        Supplier_SavesDeactivation_Opty_FollowUp.Supplier_SavesDeactivation_Opty_FollowUp_Handler(Trigger.new, Trigger.old);
        Supplier_SavesDowngrade_Opty_FollowUp.Supplier_SavesDowngrade_Opty_FollowUp_Handler(Trigger.new, Trigger.old);
        UpdateContactRole.updateContactRoleHandler(Trigger.new);
    }
 
    if(Trigger.isDelete && Trigger.isAfter){

    }  
}