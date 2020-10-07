/**
 * Created by JasonMcGrew on 6/2/2020.
 */

 public class Supplier_CS_Case_AssignmentRules {

    @InvocableMethod
        public static void assignCase(List<Id> CaseIds)
        {
            Database.DMLOptions dmo = new Database.DMLOptions();
            //dmo.assignmentRuleHeader.useDefaultRule = true;
            dmo.assignmentRuleHeader.assignmentRuleId = '01Q70000000dKqN';
            Case Cases = [
                    SELECT Id
                    FROM Case
                    WHERE Id IN :CaseIds
            ];
            Database.update(Cases,dmo);
            //Cases.setOptions(dmo);
            //update Cases;
       } 
}