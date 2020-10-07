@isTest(SeeAllData=true)
public class RHX_TEST_Case {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Case LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Case()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}