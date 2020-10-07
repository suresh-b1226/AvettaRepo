/***
* Created by MarkSimpson on 7/23/2020..
*/

public with sharing class Supplier_SER_Opty_Registration_RR {

    private static Boolean firstRun = true;

    public static Boolean isFirstRun() {
        System.debug('isFirstRun returned ' + firstRun);
        return firstRun;
    }

    public static void setFirstRunFalse() {
        firstRun = false;
        System.debug('setFirstRunFalse run');
    }

    public void QueryRegistrationOpportunity(List<Opportunity> optyFromConnect) {

        Automation_Switch__mdt serRoundRobinSwitch = [
                SELECT On_Off__c
                FROM Automation_Switch__mdt
                WHERE Label = 'SER Round Robin'
        ][0];

        if (serRoundRobinSwitch.On_Off__c == True) {

            List<Opportunity> collOpty = new List<Opportunity>();
            for (Opportunity singleOpty : optyFromConnect) {
                if (singleOpty.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() && (singleOpty.Priority__c == 'Registration Request')) {
                    collOpty.add(singleOpty);
                }
            }

            System.debug('COLL OPTY: ' + collOpty);
            System.debug('COLL OPTY SIZE ' + collOpty.size());
            System.debug('TRIGGER NEW: ' + optyFromConnect);
            System.debug('TRIGGER NEW SIZE: ' + optyFromConnect.size());

            if (collOpty.size() > 0 && Supplier_SER_Opty_RoundRobin.isFirstRun() == true) {

                List<Rep__c> validReps = new List<Rep__c>();
                validReps = [
                        SELECT Id, Name, User__c, Language__c, RecordTypeId, OwnerId, Language_1__c, Language_2__c, Language_3__c, SER_Region_Language__c
                        FROM Rep__c
                        WHERE RecordType.Name = 'SER'
                ];

                List<Id> userIds = new List<Id>();
                for (Rep__c newRep : validReps) {
                    userIds.add(newRep.User__c);
                }

                System.debug('VALID REP LIST: ' + validReps);
                System.debug('VALID REP LIST SIZE: ' + validReps.size());
                System.debug('REP USER IDS: ' + userIds);
                System.debug('REP USER IDS LIST SIZE: ' + userIds.size());

                List<Id> oppAccountIds = new List<Id>();
                for (Opportunity optyAccountIds : optyFromConnect) {
                    oppAccountIds.add(optyAccountIds.AccountId);
                }

                //Make sure you filter the opportunity by campaign source and by Owner
                List<Account> rrAccounts = [
                        SELECT Id, Name, CountryLanguage__c, Region__c
                        FROM Account
                        WHERE Id IN :oppAccountIds
                ];

                List<Id> accountIds = new List<Id>();
                for (Account accounts : rrAccounts) {
                    accountIds.add(accounts.Id);
                }

                System.debug('ROUND ROBIN ACCOUNTS: ' + rrAccounts);
                System.debug('ROUND ROBIN ACCOUNTS SIZE: ' + rrAccounts.size());

                List<Opportunity> existingOptys = [
                        SELECT Id, AccountId, OwnerId, Opp_Owner_Name_First__c, Priority__c, Created_Date_Elapsed_Days__c
                        FROM Opportunity
                        WHERE RecordType.Name = 'Supplier'
                        AND Priority__c = 'Registration Request'
                        AND Created_Date_Elapsed_Days__c >= 0
                    	AND Created_Date_Elapsed_Days__c < 3
                    	AND OwnerId = :userIds
                ];

                System.debug('EXISTING OPTYS: ' + existingOptys);
                System.debug('EXISTING OPTY SIZE: ' + existingOptys.size());

                Integer roundRobinOriginal = 0;

                List<roundRobinVariable__c> roundRobinList = new List<roundRobinVariable__c>();
                roundRobinList = [
                        SELECT roundRobinID__c
                        FROM roundRobinVariable__c
                        WHERE Name = 'SER'
                ];

                roundRobinVariable__c roundRobin = (roundRobinList != null && roundRobinList.size() > 0) ? roundRobinList[0] : null;

                if (roundRobin == null) {

                }

                else {

                    if (roundRobin != null) {
                        roundRobinOriginal = Integer.valueOf(roundRobin.roundRobinID__c);
                    }

                    else {
                        roundRobin.roundRobinID__c = 0;
                    }

                    if (roundRobin.roundRobinID__c > validReps.size() - 1) {
                        roundRobin.roundRobinID__c = 0;
                    }

                    update roundRobin;

                    integer accountCounter = 0;
                    integer randomCounter = 0;

                    for (Opportunity singleOpty : optyFromConnect) {

                        if (accountCounter == rrAccounts.size()) {
                            accountCounter = 0;
                        }

                        while (singleOpty.AccountId != rrAccounts[accountCounter].Id) {

                            if (singleOpty.AccountId != rrAccounts[accountCounter].Id) {
                                accountCounter++;

                                if (accountCounter >= rrAccounts.size()) {
                                    accountCounter = 0;
                                }
                            }
                        }

                        System.debug('CORRECT ACCOUNT ID: ' + rrAccounts[accountCounter].Id);
                        System.debug('CORRECT ACCOUNT NAME: ' + rrAccounts[accountCounter].Name);

                        if (optyFromConnect.size() > 0) {
                            System.debug('Eligible Optys Exist');
                        }

                        if (validReps.size() > 0) {

                            boolean b = false;
                            boolean region = false;
                            boolean secondRoundLanguage = false;
                            boolean thirdRoundLanguage = false;
                            integer languageCounter = 0;

                            while (b == false) {

                                System.debug(rrAccounts[accountCounter].CountryLanguage__c);
                                
                                if (roundRobin.roundRobinID__c >= validReps.size()) {
                                    roundRobin.roundRobinID__c = 0;
                                }
                                
                                System.debug(validReps[integer.valueOf(roundRobin.roundRobinID__c)]);
                                if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(validReps[integer.valueOf(roundRobin.roundRobinID__c)].Language_1__c)) {
                                    b = true;
                                    System.debug('ACCOUNT: ' + rrAccounts[accountCounter].Name);
                                    System.debug('User Language 1 Condition Met');
                                }

                                else if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(validReps[integer.valueOf(roundRobin.roundRobinID__c)].Language_2__c) && secondRoundLanguage == true) {
                                    b = true;
                                }

                                else if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(validReps[integer.valueOf(roundRobin.roundRobinID__c)].Language_3__c) && thirdRoundLanguage == true) {
                                    b = true;
                                }

                                else {
                                    System.debug('LANGUAGE NOT MET MOVING TO NEXT USER');
                                    roundRobin.roundRobinID__c++;
                                    System.debug('ROUND ROBIN ID: ' + roundRobin.roundRobinID__c);

                                    if (roundRobin.roundRobinID__c == validReps.size() - 1) {
                                        roundRobin.roundRobinID__c = 0;
                                        System.debug('ROUND ROBIN RESET');
                                        languageCounter++;
                                        languageCounter++;

                                        if (languageCounter > 2 && roundRobin.roundRobinID__c == 0) {
                                            secondRoundLanguage = true;
                                        }

                                        if (languageCounter > 4 && roundRobin.roundRobinID__c == 0) {
                                            thirdRoundLanguage = true;
                                        }

                                        if (languageCounter > 8 && roundRobin.roundRobinID__c == 0) {
                                            b = true;
                                        }
                                    }
                                }
                            }

                            if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase('English')) {

                                System.debug('ENGLISH IS TRUE: ' + rrAccounts[accountCounter].CountryLanguage__c);

                                if (rrAccounts[accountCounter].Region__c != validReps[integer.valueOf(roundRobin.roundRobinID__c)].SER_Region_Language__c) {

                                    while (region == false) {

                                        if (rrAccounts[accountCounter].Region__c.equalsIgnoreCase(validReps[integer.valueOf(roundRobin.roundRobinID__c)].SER_Region_Language__c)) {
                                            region = true;
                                            System.debug('Required Region: ' + rrAccounts[accountCounter].Region__c);
                                            System.debug('Region Condition Met: ' + validReps[integer.valueOf(roundRobin.roundRobinID__c)].SER_Region_Language__c);
                                            System.debug('USER: ' + validReps[integer.valueOf(roundRobin.roundRobinID__c)].Name);
                                        }

                                        else {
                                            System.debug('Region does not match moving to next rep');
                                            roundRobin.roundRobinID__c++;
                                        }

                                        if (roundRobin.roundRobinID__c >= validReps.size()) {
                                            roundRobin.roundRobinID__c = 0;
                                            System.debug('ROUND ROBIN RESET');
                                        }
                                    }
                                }

                                else {
                                    System.debug('Region already matches');
                                }
                            }

                            if (userIds.contains(singleOpty.OwnerId) == FALSE && (rrAccounts[accountCounter].Id).equals(singleOpty.AccountId)) {

                                if (rrAccounts[accountCounter].CountryLanguage__c == 'English'
                                        || rrAccounts[accountCounter].CountryLanguage__c == 'Spanish'
                                        || rrAccounts[accountCounter].CountryLanguage__c == 'Portuguese') {

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
                                    boolean sortOptys = false;
                                    integer randomCounter2 = 0;

                                    for (Rep__c repCount : validReps) {

                                        integer optyCount = 0;
                                        System.debug('INDEX COUNT: ' + indexCount);

                                        
                                        for (Opportunity dynamicOpty : existingOptys) {

                                            if (repCount.User__c == dynamicOpty.OwnerId) {
                                                optyCount++;
                                            }
                                        }

                                        repOptyCount.add(optyCount);
                                        indexCount++;
                                    }

                                    while (sortOptys == false) {

                                        if (repPlaceHolder >= validReps.size()) {
                                            repPlaceHolder = 0;
                                        }

                                        if (optyCountPlaceHolder >= repOptyCount.size()) {
                                            optyCountPlaceHolder = 0;
                                        }

                                        if (repOptyCount[integer.valueOf(roundRobin.RoundRobinId__c)] > repOptyCount[integer.valueOf(optyCountPlaceHolder)]) {

                                            language1 = false;
                                            language2 = false;
                                            language3 = false;
                                            regionCheck = false;

                                            if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(validReps[integer.valueOf(repPlaceHolder)].Language_1__c)) {
                                                language1 = true;
                                            }

                                            else if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(validReps[integer.valueOf(repPlaceHolder)].Language_2__c)) {
                                                language2 = true;
                                            }

                                            else if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase(validReps[integer.valueOf(repPlaceHolder)].Language_3__c)) {
                                                language3 = true;
                                            }

                                            if (language1 == true) {

                                                if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase('English')) {

                                                    if (rrAccounts[accountCounter].Region__c.equals(validReps[integer.valueOf(repPlaceHolder)].SER_Region_Language__c)) {
                                                        regionCheck = true;
                                                    }
                                                }

                                                else {
                                                    regionCheck = true;
                                                }

                                                if (language1 == true && regionCheck == true) {

                                                    reAssignCount++;
                                                    reAssign = true;

                                                    if (reAssignCount == 1) {

                                                        firstRepRRId = repPlaceHolder;
                                                        firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                    }

                                                    if (firstLow > repOptyCount[integer.valueOf(optyCountPlaceHolder)] && escapeSort < 15) {

                                                        firstRepRRId = repPlaceHolder;
                                                        firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                    }
                                                }
                                            }

                                            else if (language2 == true) {

                                                if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase('English')) {

                                                    if (rrAccounts[accountCounter].Region__c.equals(validReps[integer.valueOf(repPlaceHolder)].SER_Region_Language__c)) {
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

                                                        firstRepRRId = repPlaceHolder;
                                                        firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                    }

                                                    System.debug('CURRENT LOW: ' + firstLow + ' CURRENT NUMBER: ' + repOptyCount[integer.valueOf(optyCountPlaceHolder)]);

                                                    if (firstLow > repOptyCount[integer.valueOf(optyCountPlaceHolder)] && escapeSort < 15) {

                                                        firstRepRRId = repPlaceHolder;
                                                        firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                    }
                                                }
                                            }

                                            else if (language3 == true) {

                                                if (rrAccounts[accountCounter].CountryLanguage__c.equalsIgnoreCase('English')) {

                                                    if (rrAccounts[accountCounter].Region__c.equals(validReps[integer.valueOf(repPlaceHolder)].SER_Region_Language__c)) {
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

                                                        firstRepRRId = repPlaceHolder;
                                                        firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
                                                    }

                                                    if (firstLow > repOptyCount[integer.valueOf(optyCountPlaceHolder)] && escapeSort < 15) {

                                                        firstRepRRId = repPlaceHolder;
                                                        firstLow = repOptyCount[integer.valueOf(optyCountPlaceHolder)];
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

                                        if (escapeSort > 60) {
                                            sortOptys = true;

                                            System.debug('REASSIGN: ' + reAssign);

                                            if (reAssign == true) {
                                                System.debug('OLD RR VALUE ' + roundRobin.roundRobinID__c);

                                                roundRobin.roundRobinID__c = firstRepRRId;
                                                System.debug('NEWLY ASSIGNED RR VALUE: ' + firstRepRRId);
                                            }
                                        }
                                    }
                                }

                                singleOpty.OwnerId = validReps[integer.valueOf(roundRobin.roundRobinID__c)].User__c;

                                if (roundRobin.roundRobinID__c == validReps.size() - 1) {
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
                            System.debug('User already owns this opportunity');
                        }
                    }

                    accountCounter++;
                    randomCounter++;

                    List<integer> storeOpty = new List<integer>();

                    storeOpty.add(1);
                    storeOpty.add(2);
                    storeOpty.add(3);
                    boolean swapped = false;

                    if (storeOpty.size() > 0) {

                        swapped = true;

                        if (swapped == true) {

                            storeOpty.add(4);

                            if (swapped == true && storeOpty.size() > 0) {
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

                    if (storeOpty.size() > 0) {

                        swapped = true;

                        if (swapped == true) {

                            storeOpty.add(14);

                            if (swapped == true && storeOpty.size() > 0) {
                                storeOpty.add(15);
                                storeOpty.add(16);
                                storeOpty.add(17);
                                storeOpty.add(18);
                                storeOpty.add(19);
                                storeOpty.add(20);
                                storeOpty.add(21);
                                storeOpty.add(22);
                                storeOpty.add(23);
                            }
                        }
                    }

                    if (storeOpty.size() > 0) {

                        swapped = true;

                        if (swapped == true) {

                            storeOpty.add(24);

                            if (swapped == true && storeOpty.size() > 0) {
                                storeOpty.add(25);
                                storeOpty.add(26);
                                storeOpty.add(27);
                                storeOpty.add(28);
                                storeOpty.add(29);
                                storeOpty.add(30);
                                storeOpty.add(31);
                                storeOpty.add(32);
                                storeOpty.add(33);
                            }
                        }
                    }

                    if (storeOpty.size() > 0) {

                        swapped = true;

                        if (swapped == true) {

                            storeOpty.add(44);

                            if (swapped == true && storeOpty.size() > 0) {
                                storeOpty.add(45);
                                storeOpty.add(46);
                                storeOpty.add(47);
                                storeOpty.add(48);
                                storeOpty.add(49);
                                storeOpty.add(50);
                                storeOpty.add(51);
                                storeOpty.add(52);
                                storeOpty.add(53);
                            }
                        }
                    }

                    if (storeOpty.size() > 0) {

                        swapped = true;

                        if (swapped == true) {

                            storeOpty.add(54);

                            if (swapped == true && storeOpty.size() > 0) {
                                storeOpty.add(55);
                                storeOpty.add(56);
                                storeOpty.add(57);
                                storeOpty.add(58);
                                storeOpty.add(59);
                                storeOpty.add(60);
                                storeOpty.add(61);
                                storeOpty.add(62);
                                storeOpty.add(63);
                                storeOpty.add(64);
                                storeOpty.add(65);
                                storeOpty.add(66);
                            }
                        }
                    }


                    if (storeOpty.size() > 0) {

                        swapped = true;

                        if (swapped == true) {

                            storeOpty.add(67);

                            if (swapped == true && storeOpty.size() > 0) {
                                storeOpty.add(68);
                                storeOpty.add(69);
                                storeOpty.add(70);
                                storeOpty.add(71);
                                storeOpty.add(72);
                                storeOpty.add(73);
                                storeOpty.add(74);
                                storeOpty.add(75);
                                storeOpty.add(76);
                                storeOpty.add(77);
                                storeOpty.add(78);
                            }
                        }
                    }

                    if (roundRobinOriginal != Integer.valueOf(roundRobin.roundRobinID__c)) {
                        update roundRobin;
                    }
                }
            }
        }
    }
}