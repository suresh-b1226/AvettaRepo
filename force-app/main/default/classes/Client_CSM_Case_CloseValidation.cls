/**
 * Created by JasonMcGrew on 10/9/2020.
 *
 * This Class is an Apex Validation Rule on the Case object. It's validates that all tasks have been completed on
 * all Client Cases that are of the Complaint type. If the Tasks are any tasks that are not complete an error will pop up
 * stating that you cannot close the case with tasks that are not complete.
 *
 *
 ************************************************************************************************************************/

public class Client_CSM_Case_CloseValidation {

    public List<Case> getAssociatedCases(List<Case> newTrigger) {

        List<Case> casesToValidate = new List<Case>();

        for (Case c : newTrigger) {
            if (c.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Client').getRecordTypeId() &&
                    c != null &&
                    c.Type == 'Complaint' &&
                    c.Status == 'Closed') {
                System.debug(' CASE STATUS = ' + c.Status);
                casesToValidate.add(c);
            }
        }
        System.debug('casesToValidate = ' + casesToValidate);
        return casesToValidate;
    }

    public List<Task> getAssociatedTasks(List<Case> c) {

        List<Task> tasksAssociatedToCases = [
                SELECT Id, RecordTypeId,  WhatId, Status, Type
                FROM Task
                WHERE WhatId =: getAssociatedCases(c)
                AND Type = 'Complaint'
        ];
        System.debug('tasksAssociatedToCases = ' + tasksAssociatedToCases);
        return tasksAssociatedToCases;
    }

    public Boolean stillOpenCases = false;

    public List<Case> validateAssociatedCases(List<Case> newTrigger) {
        System.debug('Entering validateAssociatedCases HANDLER ');

        List<Case> getCases = getAssociatedCases(newTrigger);
        List<Task> getTasks = getAssociatedTasks(getCases);

        System.debug('getCases = ' + getCases);
        System.debug('getTasks = ' + getTasks);

        List<Case> casesToClose = new List<Case> ();
        if (getCases != null) {
            for (Case c : getCases) {
                for (Task t : getTasks) {
                    if (t != null && c.Id == t.WhatId) {
                        if (t.Status != 'Completed') {
                            if (t.Status != 'Resolved') {
                                stillOpenCases = true;
                            }

                            System.debug('stillOpenCases = ' + stillOpenCases);
                        }
                    }
                    if (stillOpenCases == false) {
                        c.Status = 'Closed';
                        casesToClose.add(c);
                    }
                }
            }
        }
        System.debug('casesToClose + ' + casesToClose);
        return casesToClose;
    }
}