/**
 * Created by Emmon Chow on 1/22/2019
 */

trigger Contact_Trigger on Contact (before insert, before update) {
    
    if(Trigger.isInsert && Trigger.isBefore) {
       // Supplier_SER_Contact_ContactPrevent.PreventInsertUpdate(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isBefore) {
      //  Supplier_SER_Contact_ContactPrevent.PreventInsertUpdate(Trigger.new);
    }
    
}