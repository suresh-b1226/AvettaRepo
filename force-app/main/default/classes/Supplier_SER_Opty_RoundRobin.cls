/**
* Created by MarkSimpson on 4/13/2020.
*
* BREAK UP INTO SEPERATE METHODS BEFORE YOU CALL THIS DONE! IT LOOKS LIKE HELL RN!!!!!!!!!
*/

public class Supplier_SER_Opty_RoundRobin implements Schedulable {

    private static Boolean firstRun = true;

    public void execute(SchedulableContext exe) {

        Automation_Switch__mdt serRoundRobinSwitch = [
                SELECT On_Off__c
                FROM Automation_Switch__mdt
                WHERE Label = 'SER Round Robin'
        ][0];

        if (serRoundRobinSwitch.On_Off__c == True) {

            List<Campaign> serCampaign = new List<Campaign>();
            serCampaign = [
                    SELECT Id, Name, Round_Robin_Status__c, CreatedDate, OwnerId
                    FROM Campaign
                    WHERE CreatedDate != Null
                    AND Round_Robin_Status__c = 'Go'
                    ORDER BY CreatedDate
            ];

            List<Id> CampaignIds = new List<Id>();
            for (Campaign campaign : serCampaign) {
                CampaignIds.add(campaign.Id);
            }

            System.debug('CAMPAIGN: '  + serCampaign);
            System.debug('SIZE: ' + serCampaign.size());

            List<Rep__c> firstPriorityReps = new List<Rep__c>();
            firstPriorityReps = [
                    SELECT Id, Name, User__c, Language__c, Language_Priority_c__c, RecordTypeId, OwnerId, Language_1__c, Language_2__c, Language_3__c, SER_Region_Language__c
                    FROM Rep__c
                    WHERE Language_Priority_c__c != NULL AND RecordType.Name = 'SER'
                    ORDER BY Language_Priority_c__c DESC
            ];

            System.debug('OWNERS: ' + firstPriorityReps);
            System.debug('SIZE: ' + firstPriorityReps.size());

            List<Id> userIds = new List<Id>();
            for (Rep__c newRep : firstPriorityReps) {
                userIds.add(newRep.User__c);
            }

            System.debug('HERE6 ' + firstPriorityReps);
            System.debug('Total Users to Round Robin ' + firstPriorityReps.size());

            List<Opportunity> optyList = [
                    SELECT Id, AccountId, OwnerId, Opp_Owner_Name_First__c, Name, StageName, Type, RecordType.Name, Owner_role__c, LastActivityDate, Campaign__c, CampaignId
                    FROM Opportunity
                    WHERE CampaignId = :CampaignIds
                    AND OwnerId Not IN :userIds
                    AND RecordType.Name = 'Supplier'
                    AND (Type = 'Registration' OR Type = 'Reactivation')
                    AND (StageName = 'Mailed')
            ];

            List<Id> oppIds = new List<Id>();
            for (Opportunity opty : optyList) {
                oppIds.add(opty.OwnerId);
            }

            List<Id> oppAccountIds = new List<Id>();
            for (Opportunity optyAccountIds : optyList) {
                oppAccountIds.add(optyAccountIds.AccountId);
            }

            List<Account> rrAccounts = [
                    SELECT Id, Name, CountryLanguage__c, Region__c
                    FROM Account
                    WHERE Id IN :oppAccountIds
            ];

            List<Id> accountIds = new List<Id>();
            for (Account accounts : rrAccounts) {
                accountIds.add(accounts.Id);
            }

            Supplier_SER_Opty_RoundRobin_Handler(campaignIds, oppIds, userIds, firstPriorityReps, serCampaign, optyList, oppAccountIds, rrAccounts, accountIds);
        }
    }

    //--Used to prevent recursion
    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }

    //--Method to set recursion variable to false
    public static void setFirstRunFalse() {
        firstRun = false;
        System.debug('setFirstRunFalse run');
    }

    //Query Reps
    public void Supplier_SER_Opty_RoundRobin_Handler(List<Id> campaignIds, List<Id> oppIds, List<Id> userIds, List<Rep__c> firstPriorityReps, List<Campaign> campaignList, List<Opportunity> optyList, List<Id> oppAccountIds, List<Account> rrAccounts, List<Id> accountIds) {

        integer counter = 0;

        //Makes sure opportunity is loaded into a list to be distributed
        List<Opportunity> collOpty = new List<Opportunity>();
        for (Opportunity singleOpty : optyList) {
            System.debug('SINGLE OPTY: ' + singleOpty);
            if (singleOpty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId()) {
                collOpty.add(singleOpty);
            }
        }

        if(optyList != NULL && collOpty.size() > 0 && Supplier_SER_Opty_RoundRobin.isFirstRun() == true) {

            setFirstRunFalse();
            System.debug('START');

            List<Opportunity> existingOptys = [
                    SELECT Id, AccountId, OwnerId, Opp_Owner_Name_First__c, Name, StageName, Type, RecordType.Name, Owner_role__c, LastActivityDate, Campaign__c, CampaignId, Owner.Id
                    FROM Opportunity
                    WHERE CampaignId = :CampaignIds
                    AND RecordType.Name = 'Supplier'
                    AND (Type = 'Registration' OR Type = 'Reactivation')
                    AND (StageName = 'Mailed')
                    AND (Owner_role__c = 'Registration' OR Owner_role__c = 'Collections' OR Owner_role__c = 'Saves (Deactivation)')
                    //AND LastActivityDate < LAST_WEEK
            ];

            counter++;
            System.debug('COUNTER: ' + counter);
            System.debug('USER IDS: ' + userIds);
            System.debug('OPP IDS: ' + oppIds);
            System.debug('REP SIZE: ' + firstPriorityReps.size());
            System.debug('REP LIST: ' + firstPriorityReps);
            System.debug('OPTY LIST: ' + optyList);
            System.debug('OPTY LIST SIZE: ' + optyList.size());
            System.debug('EXISTING OPTYS: ' + existingOptys);
            System.debug('EXISTING OPTYS SIZE: ' + existingOptys.size());
            System.debug('ACCOUNT: ' + rrAccounts);
            System.debug('ACCOUNT ID: ' + oppAccountIds);

            if (campaignList.size() != null) {

                System.debug('OWNERS: ' + firstPriorityReps);
                System.debug('SIZE: ' + firstPriorityReps.size());

                System.debug('HERE6 ' + firstPriorityReps);
                System.debug('Total Users to Round Robin ' + firstPriorityReps.size());

                Integer roundRobinOriginal = 0;

                List<Rep__c> filteredList = new List<Rep__c>();
                List<integer> storeOpty = new List<integer>();
                List<Rep__c> disqualifiedReps = new List<Rep__c>();

                integer iCount2 = 0;

                for (Rep__c filterRep : firstPriorityReps) {

                    integer optyCount = 0;

                    for (Opportunity existingOpty : existingOptys) {

                        if (filterRep.User__c == existingOpty.OwnerId) {
                            optyCount++;
                            System.debug('Counter at: ' + optyCount);
                        }
                    }

                    if (optyCount < 300) {

                        filteredList.add(filterRep);
                        System.debug('Rep: ' + filterRep);
                        System.debug('FILTERED LIST: ' + filteredList);
                        System.debug('Current Size: ' + filteredList.size());
                    }

                    else {
                        System.debug('USER DOES NOT QUALIFY: ' + filterRep);
                        disqualifiedReps.add(filterRep);
                    }
                    iCount2++;
                }

                storeOpty.add(1);
                storeOpty.add(2);
                storeOpty.add(3);

                boolean swapped = false;

                if (storeOpty.size() > 0) {

                    swapped = true;

                    if (swapped == true) {

                        storeOpty.add(4);

                        if(swapped == true && storeOpty.size() > 0) {
                            storeOpty.add(5);
                            storeOpty.add(6);
                            storeOpty.add(7);
                            storeOpty.add(8);
                            storeOpty.add(9);
                            storeOpty.add(10);
                            storeOpty.add(11);
                            storeOpty.add(12);
                            storeOpty.add(13);
                        }
                    }
                }

                if (filteredList.size() != NULL) {

                    List<Id> disqualifiedRepIds = new List<Id>();
                    for (Rep__c disqualifiedRep : disqualifiedReps) {
                        disqualifiedRepIds.add(disqualifiedRep.User__c);
                    }

                    List<Id> filteredIds = new List<Id>();
                    for (Rep__c filterRep : filteredList) {
                        filteredIds.add(filterRep.User__c);
                    }

                    List<roundRobinVariable__c> roundRobinListEnglish = new List<roundRobinVariable__c>();
                    roundRobinListEnglish = [
                            SELECT roundRobinID__c
                            FROM roundRobinVariable__c
                            WHERE Name = 'SER'
                    ];

                    roundRobinVariable__c roundRobin = (roundRobinListEnglish != null && roundRobinListEnglish.size() > 0) ? roundRobinListEnglish[0] : null;

                    if (roundRobin != null) {
                        roundRobinOriginal = Integer.valueOf(roundRobin.roundRobinID__c);
                    }

                    else {
                        roundRobin.roundRobinID__c = 0;
                    }

                    if (roundRobin.roundRobinID__c > filteredList.size() - 1) {
                        roundRobin.roundRobinID__c = 0;
                    }

                    update roundRobin;

                    integer rrCounter = 1;
                    integer accountCounter = 0;

                    for (Opportunity singleOpty : optyList) {

                        if(accountCounter == rrAccounts.size()) {
                            accountCounter = 0;
                        }

                        while (singleOpty.AccountId != rrAccounts[accountCounter].Id) {

                            if(singleOpty.AccountId != rrAccounts[accountCounter].Id) {
                                accountCounter++;

                                if (accountCounter >= rrAccounts.size()) {
                                    accountCounter = 0;
                                }
                            }
                        }

                        if (storeOpty.size() > 0) {

                            swapped = true;

                            if (swapped == true) {

                                storeOpty.add(4);

                                if(swapped == true && storeOpty.size() > 0) {
                                    storeOpty.add(5);
                                    storeOpty.add(6);
                                    storeOpty.add(7);
                                    storeOpty.add(8);
                                    storeOpty.add(9);
                                    storeOpty.add(10);
                                    storeOpty.add(11);
                                    storeOpty.add(12);
                                    storeOpty.add(13);
                                }
                            }
                        }

                        if(optyList.size() > 0) {
                            System.debug('Eligible Optys Exist');
                        }

                        if(campaignList.size() > 0) {
                            System.debug('Eligble Campaigns Exist');
                        }

                        //Going to distribute opportunities by the highest campaign priority first
                        for (Campaign prioritizeCampaigns : campaignList) {

                            System.debug('HERE10');
                            //This line needs to be rewritten
                            //Criteria for 80 or less opportunities will be here
                            if (prioritizeCampaigns.Id == singleOpty.CampaignId) {

                                if (filteredList.size() != NULL) {

                                    System.debug('DISQUALIFIED REP: ' + disqualifiedReps);
                                    System.debug('DISQUALIFIED REP ID: ' + disqualifiedRepIds);
                                    System.debug('REP LANGUAGES: ' + filteredList[integer.valueOf(roundRobin.roundRobinID__c)].Language__c);
                                    System.debug('ACCOUNT LANGUAGE: ' + rrAccounts[accountCounter].CountryLanguage__c);
                                    System.debug('ACCOUNT ID: ' + accountIds);

                                    boolean b = false;
                                    boolean region = false;
                                    boolean secondRoundLanguage = false;
                                    boolean thirdRoundLanguage = false;
                                    boolean secondRoundRegion = false;
                                    boolean thirdRoundRegion = false;
                                    integer languageCounter = 0;
                                    integer regionCounter = 0;
                                    integer backupCounter = 0;
                                    integer backupbackupCounter = 0;
                                    integer codeCoverageCounter = 0;
                                    integer backupCodeCoverageCounter = 0;

                                    System.debug(singleOpty.AccountId);
                                    System.debug(rrAccounts[accountCounter].Id);
                                    System.debug(accountIds);

                                    while (b == false) {

                                        System.debug(rrAccounts[accountCounter].CountryLanguage__c);
                                        System.debug(filteredList[integer.valueOf(roundRobin.roundRobinID__c)]);
                                        if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(filteredList[integer.valueOf(roundRobin.roundRobinID__c)].Language_1__c)) {
                                            b = true;
                                            System.debug('User Language 1 Condition Met');
                                            System.debug('OPPTY: ' + optyList);
                                        }

                                        else if(rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(filteredList[integer.valueOf(roundRobin.roundRobinID__c)].Language_2__c) && secondRoundLanguage == true) {
                                            b = true;
                                            System.debug('User Language 2 Condition Met');
                                        }

                                        else if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(filteredList[integer.valueOf(roundRobin.roundRobinID__c)].Language_3__c) && thirdRoundLanguage == true) {
                                            b = true;
                                            System.debug('User Language 3 Condition Met');
                                        }

                                        else {
                                            System.debug('LANGUAGE NOT MET MOVING TO NEXT USER');
                                            roundRobin.roundRobinID__c++;
                                            System.debug('ROUND ROBIN ID: ' + roundRobin.roundRobinID__c);

                                            if (roundRobin.roundRobinID__c == filteredList.size() - 1) {
                                                roundRobin.roundRobinID__c = 0;
                                                System.debug('ROUND ROBIN RESET');
                                                languageCounter++;
                                                languageCounter++;

                                                if(languageCounter > 2 && roundRobin.roundRobinID__c == 0) {
                                                    secondRoundLanguage = true;
                                                }

                                                if(languageCounter > 4 && roundRobin.roundRobinID__c == 0) {
                                                    thirdRoundLanguage = true;
                                                }

                                                if(languageCounter > 8 && roundRobin.roundRobinID__c == 0) {
                                                    b = true;
                                                }
                                            }
                                        }
                                    }

                                    if(rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase('English')) {

                                        System.debug('ENGLISH IS TRUE: ' + rrAccounts[accountCounter].CountryLanguage__c);

                                        if (rrAccounts[accountCounter].Region__c !=  filteredList[integer.valueOf(roundRobin.roundRobinID__c)].SER_Region_Language__c) {

                                            while (region == false) {

                                                if(rrAccounts[accountCounter].Region__c.equalsIgnoreCase(filteredList[integer.valueOf(roundRobin.roundRobinID__c)].SER_Region_Language__c)) {
                                                    region = true;
                                                    System.debug('Required Region: ' + rrAccounts[accountCounter].Region__c);
                                                    System.debug('Region Condition Met: ' + filteredList[integer.valueOf(roundRobin.roundRobinID__c)].SER_Region_Language__c);
                                                    System.debug('USER: ' + filteredList[integer.valueOf(roundRobin.roundRobinID__c)].Name);
                                                }

                                                else {
                                                    System.debug('Region does not match moving to next rep');
                                                    roundRobin.roundRobinID__c++;
                                                }

                                                if (roundRobin.roundRobinID__c >= filteredList.size()) {
                                                    roundRobin.roundRobinID__c = 0;
                                                    System.debug('ROUND ROBIN RESET');
                                                }
                                            }
                                        }

                                        else {
                                            System.debug('Region already matches');
                                        }
                                    }

                                    if (storeOpty.size() > 0) {

                                        swapped = true;

                                        if (swapped == true) {

                                            storeOpty.add(4);

                                            if(swapped == true && storeOpty.size() > 0) {
                                                storeOpty.add(5);
                                                storeOpty.add(6);
                                                storeOpty.add(7);
                                            }
                                        }
                                    }

                                    if(optyList.size() > 0) {
                                        System.debug('Eligible Optys Exist');
                                    }

                                    if(campaignList.size() > 0) {
                                        System.debug('Eligble Campaigns Exist');
                                    }

                                    //Need something to prevent already assigned optys from being overwritten
                                    if (userIds.contains(singleOpty.OwnerId) == FALSE && disqualifiedRepIds.contains(singleOpty.OwnerId) == FALSE &&
                                            (rrAccounts[accountCounter].Id).equals(singleOpty.AccountId)) {

                                        boolean sortOptys = false;

                                        if(rrAccounts[accountCounter].CountryLanguage__c != 'French'
                                                || rrAccounts[accountCounter].CountryLanguage__c != 'Italian'
                                                || rrAccounts[accountCounter].CountryLanguage__c != 'Polish'
                                                || rrAccounts[accountCounter].CountryLanguage__c != 'German'
                                                || rrAccounts[accountCounter].CountryLanguage__c != 'Korean'
                                                || rrAccounts[accountCounter].CountryLanguage__c != 'Chinese'
                                                || rrAccounts[accountCounter].CountryLanguage__c != 'Hindi - English') {

                                            integer escapeSort = 0;
                                            integer indexCount = 0;
                                            integer firstLow = 0;
                                            integer reassignCount = 0;
                                            decimal firstRepRRId = 0;
                                            decimal optyCountPlaceHolder = roundRobin.roundRobinID__c;
                                            decimal repPlaceHolder = roundRobin.roundRobinID__c;
                                            List<integer> repOptyCount = new List<integer>();
                                            boolean reAssign = false;
                                            boolean language1 = false;
                                            boolean language2 = false;
                                            boolean language3 = false;
                                            boolean regionCheck = false;
                                            integer backupEscapeSort = 0;
                                            integer rrbackupVariable = 0;
                                            integer outofboundsReset = 0;
                                            boolean regionBackup = false;

                                            //CREATE NEW LIST AND RECOUNT OPTYS HERE FOR SORT OPERATION!
                                            for (Rep__c validRep : filteredList) {

                                                integer optyCount = 0;
                                                System.debug('INDEX COUNT: ' + indexCount);

                                                for (Opportunity existingOpty : existingOptys) {

                                                    if (validRep.User__c == existingOpty.OwnerId) {
                                                        optyCount++;
                                                    }
                                                }

                                                for(Opportunity dynamicOptys : optyList) {

                                                    System.debug('OPP NAME HERE: ' + dynamicOptys);

                                                    if(validRep.User__c == dynamicOptys.OwnerId) {
                                                        optyCount++;
                                                        System.debug('WHAT?');
                                                    }
                                                }

                                                repOptyCount.add(optyCount);
                                                System.debug('REP: ' + validRep.Name + ' OPTYS ADDED ' + repOptyCount[indexCount] + ' SIZE: ' + repOptyCount.size());
                                                indexCount++;
                                            }

                                            while (sortOptys == false) {

                                                SYSTEM.DEBUG('SPECIAL SORT HERE ' + repOptyCount);

                                                if (repPlaceHolder >= filteredList.size()) {
                                                    repPlaceHolder = 0;
                                                }

                                                if (optyCountPlaceHolder >= repOptyCount.size()) {
                                                    optyCountPlaceHolder = 0;
                                                }

                                                System.debug('REP AT CURRENT RR: ' + filteredList[integer.valueOf(roundRobin.RoundRobinId__c)]);
                                                System.debug('REP NEXT IN LINE: ' + filteredList[integer.valueOf(repPlaceHolder)]);
                                                System.debug('OPTY COUNT FOR CURRENT REP: ' + repOptyCount[integer.valueOf(roundRobin.RoundRobinId__c)]);
                                                System.debug('OPTY COUNT FOR NEXT IN LINE: ' + repOptyCount[integer.valueOf(optyCountPlaceHolder)]);

                                                if (repOptyCount[integer.valueOf(roundRobin.RoundRobinId__c)] > repOptyCount[integer.valueOf(optyCountPlaceHolder)]) {

                                                    System.debug('MORE OPTYS: ' + filteredList[integer.valueOf(roundRobin.RoundRobinId__c)].Name);
                                                    System.debug('LESS OPTYS ' + filteredList[integer.valueOf(repPlaceHolder)].Name);

                                                    System.debug('OPTY GREATER THAN: ' + repOptyCount[integer.valueOf(roundRobin.RoundRobinId__c)]);
                                                    System.debug('OPTY COUNT LESS THAN: ' + repOptyCount[integer.valueOf(optyCountPlaceHolder)]);

                                                    language1 = false;
                                                    language2 = false;
                                                    language3 = false;
                                                    regionCheck = false;

                                                    if(rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(filteredList[integer.valueOf(repPlaceHolder)].Language_1__c)) {
                                                        language1 = true;
                                                    }

                                                    else if(rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(filteredList[integer.valueOf(repPlaceHolder)].Language_2__c)) {
                                                        language2 = true;
                                                    }

                                                    else if(rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(filteredList[integer.valueOf(repPlaceHolder)].Language_3__c)) {
                                                        language3 = true;
                                                    }

                                                    System.debug('ACCOUNT LANGUAGE: ' + rrAccounts[accountCounter].CountryLanguage__c +
                                                            ' LANGUAGE 1 FOR REP: ' + filteredList[integer.valueOf(repPlaceHolder)].Language_1__c);

                                                    System.debug('ACCOUNT LANGUAGE: ' + rrAccounts[accountCounter].CountryLanguage__c +
                                                            ' LANGUAGE 2 FOR REP: ' + filteredList[integer.valueOf(repPlaceHolder)].Language_2__c);

                                                    System.debug('ACCOUNT LANGUAGE: ' + rrAccounts[accountCounter].CountryLanguage__c +
                                                            ' LANGUAGE 3 FOR REP: ' + filteredList[integer.valueOf(repPlaceHolder)].Language_3__c);

                                                    if(language1 == true) {

                                                        if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase('English')) {

                                                            if (rrAccounts[accountCounter].Region__c.equals(filteredList[integer.valueOf(repPlaceHolder)].SER_Region_Language__c)) {
                                                                regionCheck = true;
                                                            }
                                                        }

                                                        else {
                                                            regionCheck = true;
                                                        }

                                                        if (language1 == true && regionCheck == true) {

                                                            reAssignCount++;
                                                            reAssign = true;
                                                            System.debug('CRITERIA 1 MET');

                                                            if (reAssignCount == 1) {

                                                                System.debug('LANGUAGE CONDITION 1 MET:');
                                                                System.debug('ACCOUNT LANGUAGE: ' + rrAccounts[accountCounter].CountryLanguage__c +
                                                                        ' LANGUAGE 1 FOR REP: ' + filteredList[integer.valueOf(repPlaceHolder)].Language_1__c);

                                                                firstRepRRId = repPlaceHolder;
                                                                System.debug('FIRST LOW RR ID: ' + firstRepRRId + ' OPTY First Assigned To: ' + filteredList[integer.valueOf(repPlaceHolder)].Name);

                                                                firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                                System.debug('FIRST LOW: ' + firstLow);
                                                            }

                                                            System.debug('CURRENT LOW: ' + firstLow + ' CURRENT NUMBER: ' + repOptyCount[integer.valueOf(optyCountPlaceHolder)]);

                                                            if (firstLow > repOptyCount[integer.valueOf(optyCountPlaceHolder)] && escapeSort < 15) {

                                                                firstRepRRId = repPlaceHolder;
                                                                System.debug('New LOW RR ID: ' + firstRepRRId + 'OPTY Now Assigned To: ' + filteredList[integer.valueOf(repPlaceHolder)].Name);

                                                                firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                                System.debug('NEW FIRST LOW: ' + firstLow);
                                                            }
                                                        }
                                                    }

                                                    else if (language2 == true) {

                                                        if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase('English')) {

                                                            if (rrAccounts[accountCounter].Region__c.equals(filteredList[integer.valueOf(repPlaceHolder)].SER_Region_Language__c)) {
                                                                regionCheck = true;
                                                            }
                                                        }

                                                        else {
                                                            regionCheck = true;
                                                        }

                                                        if (language2 == true && regionCheck == true) {

                                                            reAssignCount++;
                                                            reAssign = true;

                                                            if (reAssignCount == 1) {

                                                                System.debug('LANGUAGE CONDITION 2 MET:');
                                                                System.debug('ACCOUNT LANGUAGE: ' + rrAccounts[accountCounter].CountryLanguage__c +
                                                                        ' LANGUAGE 2 FOR REP: ' + filteredList[integer.valueOf(repPlaceHolder)].Language_2__c);

                                                                firstRepRRId = repPlaceHolder;
                                                                System.debug('FIRST LOW RR ID: ' + firstRepRRId + ' OPTY First Assigned To: ' + filteredList[integer.valueOf(repPlaceHolder)].Name);

                                                                firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                                System.debug('FIRST LOW: ' + firstLow);
                                                            }

                                                            System.debug('CURRENT LOW: ' + firstLow + ' CURRENT NUMBER: ' + repOptyCount[integer.valueOf(optyCountPlaceHolder)]);

                                                            if (firstLow > repOptyCount[integer.valueOf(optyCountPlaceHolder)] && escapeSort < 15) {

                                                                firstRepRRId = repPlaceHolder;
                                                                System.debug('New LOW RR ID: ' + firstRepRRId + 'OPTY Now Assigned To: ' + filteredList[integer.valueOf(repPlaceHolder)].Name);

                                                                firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                                System.debug('NEW FIRST LOW: ' + firstLow);
                                                            }
                                                        }
                                                    }

                                                    else if(language3 == true) {

                                                        if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase('English')) {

                                                            if (rrAccounts[accountCounter].Region__c.equals(filteredList[integer.valueOf(repPlaceHolder)].SER_Region_Language__c)) {
                                                                regionCheck = true;
                                                            }
                                                        }

                                                        else {
                                                            regionCheck = true;
                                                        }

                                                        if (language3 == true && regionCheck == true) {

                                                            reAssignCount++;
                                                            reAssign = true;

                                                            if (reAssignCount == 1) {

                                                                System.debug('LANGUAGE CONDITION 3 MET');
                                                                System.debug('ACCOUNT LANGUAGE: ' + rrAccounts[accountCounter].CountryLanguage__c +
                                                                        ' LANGUAGE 3 FOR REP: ' + filteredList[integer.valueOf(repPlaceHolder)].Language_3__c);

                                                                firstRepRRId = repPlaceHolder;
                                                                System.debug('FIRST LOW RR ID: ' + firstRepRRId + ' OPTY First Assigned To: ' + filteredList[integer.valueOf(repPlaceHolder)].Name);

                                                                firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                                System.debug('FIRST LOW: ' + firstLow);
                                                            }

                                                            System.debug('CURRENT LOW: ' + firstLow + ' CURRENT NUMBER: ' + repOptyCount[integer.valueOf(optyCountPlaceHolder)]);

                                                            if (firstLow > repOptyCount[integer.valueOf(optyCountPlaceHolder)] && escapeSort < 15) {

                                                                firstRepRRId = repPlaceHolder;
                                                                System.debug('New LOW RR ID: ' + firstRepRRId + 'OPTY Now Assigned To: ' + filteredList[integer.valueOf(repPlaceHolder)].Name);

                                                                firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                                System.debug('NEW FIRST LOW: ' + firstLow);
                                                            }
                                                        }
                                                    }

                                                    else {
                                                        System.debug('REP WITH LESS OPTYS DID NOT MEET LANGUAGE OR REGION REQUIREMENT');
                                                    }
                                                }

                                                repPlaceHolder++;
                                                optyCountPlaceHolder++;
                                                escapeSort++;

                                                if(escapeSort > 60) {
                                                    sortOptys = true;

                                                    System.debug('REASSIGN: ' + reAssign);

                                                    if(reAssign == true) {
                                                        System.debug('OLD RR VALUE ' + roundRobin.roundRobinID__c);

                                                        roundRobin.roundRobinID__c = firstRepRRId;
                                                        System.debug('NEWLY ASSIGNED RR VALUE: ' + firstRepRRId);
                                                    }
                                                }
                                            }
                                        }

                                        System.debug('REP LANGUAGES: ' + filteredList[integer.valueOf(roundRobin.roundRobinID__c)].Language_1__c);
                                        System.debug('REP LANGUAGES: ' + filteredList[integer.valueOf(roundRobin.roundRobinID__c)].Language_2__c);
                                        System.debug('REP LANGUAGES: ' + filteredList[integer.valueOf(roundRobin.roundRobinID__c)].Language_3__c);
                                        System.debug('ACCOUNT LANGUAGE: ' + rrAccounts[accountCounter].CountryLanguage__c);
                                        System.debug('ACCOUNT ID: ' + accountIds);

                                        System.debug('DISQUALIFIED REP ID: ' + disqualifiedRepIds);
                                        System.debug('USER ID: ' + userIds);

                                        System.debug('INSIDE HERE: ' + singleOpty.Opp_Owner_Name_First__c);
                                        System.debug('INSIDE HERE: ' + singleOpty.OwnerId);
                                        System.debug('BEFORE RR ID: ' + roundRobin.roundRobinID__c);

                                        singleOpty.OwnerId = filteredList[integer.valueOf(roundRobin.roundRobinID__c)].User__c;

                                        System.debug('AFTERMATH: ' + singleOpty.OwnerId + ' ' + singleOpty.Opp_Owner_Name_First__c);
                                        System.debug('AFTERMATH2: ' + filteredList[integer.valueOf(roundRobin.roundRobinID__c)].Name);
                                        System.debug('ACCOUNT NAME: ' + rrAccounts[accountCounter].Name);
                                        System.debug('OPTY NAME: ' + singleOpty.Name);

                                        if (roundRobin.roundRobinID__c == filteredList.size() - 1) {
                                            roundRobin.roundRobinID__c = 0;
                                            System.debug('WORKS YO! ' + roundRobin.roundRobinID__c);
                                        }

                                        else {
                                            roundRobin.roundRobinID__c++;
                                            System.debug('AFTER Round Robin ID: ' + roundRobin.roundRobinID__c);
                                        }
                                    }
                                }

                                else {
                                    System.debug('This user already owns this opportunity');
                                }
                            }

                            else {
                                System.debug('Campaign has no opportunities that meet requirements for round robin');
                            }
                        }

                        accountCounter++;
                        System.debug('END ACCOUNT COUNTER: ' + accountCounter);
                        System.debug('ACCOUNT LIST SIZE: ' + rrAccounts.size());
                    }

                    if (roundRobinOriginal != Integer.valueOf(roundRobin.roundRobinID__c)) {
                        update roundRobin;
                    }
                }
            }

            else {
                System.debug('No Campaigns are in a go state to be assigned to reps');
            }

            update optyList;
        }

        else {
            System.debug('NO REPS QUALIFY FOR ROUND ROBIN');
        }
    }
}