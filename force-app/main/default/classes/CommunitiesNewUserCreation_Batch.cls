/************************************************************************************************************************
 * Created by JasonMcGrew on 9/3/2019.
 *
 * Salesforce Case # 01285041
 *
 * This Apex Batch class will batch process new community(Avetta Help Center) user creation. It's scheduled
 * to run daily from the
 * CommunitiesNewUserCreation_Schedulable class. 
 * 
 *
 *
 ***********************************************************************************************************************/
/*
*  Code will query on the Contact object, it will then make new community users for both 'Operators' and 'Contractors'
*  It will set the Language based on the 'LanguageMap' the Key being the Country code and the value being the associated
*  country language. If there isn't a 'Billing Country' on the Account, it will default to 'en_US'.
*  If there isn't a timezone listed on the account the User will not be created.
*  Code will check to see if there is already a user created with a 'Supplier Community Login' or 'Client Community Login'
*  if there isn't the contact will be assigned to a new list and the  SF Users will be inserted from that final list.
*
* ***********************************************************************************************************************
* To QA test this the following objects must not be Null:
*
* Account.BillingCountry
* Account.BillingState
*
* Must be a United States or English Speaking Country.
*
* Contact.Account.Status__c = Active
* Contact.Organizer_isActive__c = Yes
* Contact.Organizer_Last_Login__c != null
* Contact.Organizer_Last_Login__c = last_n_days:182
* Contact.Organizer_User_ID__c != null
* Contact.Email != null
*
* Email Address must not be an '@avetta.com email address or @test.com, use @sftest.com
*
* Run the Batch in Anonymous Apex with the Following Code:
* CommunitiesNewUserCreation_Batch b = new CommunitiesNewUserCreation_Batch();
*        if(!Test.isRunningTest()){
*
*            Database.executeBatch(b, 20);
*       }
*
************************************************************************************************************************/


global class CommunitiesNewUserCreation_Batch implements Database.Batchable<SObject>{

    global Database.QueryLocator start(Database.BatchableContext bc) {

        String query = 'SELECT Id, LastName, Language__c, FirstName, Email, Organizer_User_ID__c, account.Name, account.RecordTypeId,' +
                'account.RecordType.DeveloperName, Account.CurrencyIsoCode, Account.Status__c, account.BillingCountry, account.BillingCity, Account.CountryLanguage__c,' +
                'account.tz__Timezone_SFDC__c, account.tz__Local_Time__c, account.tz__Timezone_F__c, Account.BillingState, account.BillingPostalCode, account.Organizer_Id__c,' +
                'Primary_PICS_Organizer_User__c, Organizer_Last_Login__c ' +
                'FROM Contact ' +
                'WHERE Account.Status__c               = \'Active\' ' +
                'AND Organizer_isActive__c         = \'Yes\' ' +
                'AND Organizer_Last_Login__c      != null ' +
                'AND Organizer_Last_Login__c       = last_n_days:182 ' +
                'AND Organizer_User_ID__c         != null ' +
                'AND Email                        != null ' +
                'AND Account.tz__Timezone_SFDC__c != null ' +
                'AND (Account.BillingCountry       = \'US\' ' +
                'OR Account.BillingCountry     = \'GB\' ' +
                'OR Account.BillingCountry     = \'AU\' ' +
                'OR Account.BillingCountry     = \'CA\' ' +
                'OR Account.BillingCountry     = \'United States\' ' +
                'OR Account.BillingCountry     = \'Canada\' ' +
                'OR Account.BillingCountry     = \'Australia\' ' +
                'OR Account.BillingCountry     = \'USA\' ' +
                'OR Account.BillingCountry     = \'UK\') ' +
                'AND Account.BillingState         != \'Quebec\' ' +
                'AND (NOT Account.NAME LIKE \'%Suncor%\') ' +
                'AND (NOT Email LIKE \'%@avetta.com%\') ' +
                'AND (NOT Email LIKE \'%@picsauditing.com%\') ' +
                'AND (NOT Email LIKE \'%@safetyservicescompany.com%\') ' +
                'AND (NOT Email LIKE \'%@workforcecompliancesafety.ca%\') ' +
                'AND (NOT Email LIKE \'%@greystar%\') ' +
                'AND (NOT Email LIKE \'%avetta%\') ' +
                'AND (NOT Email LIKE \'%@jjsafetyllc.com%\') ' +
                'AND (NOT Email LIKE \'%@corrigalsafety.com%\') ' +
                'AND (NOT Email LIKE \'%@industrialcompliancesafety.com%\') ' +
                'AND (NOT Email LIKE \'%@cmssafetymanagement.com%\') ' +
                'AND (NOT Email LIKE \'%@greenflagsafetyadmin.com%\') ' +
                'AND (NOT Email LIKE \'%@riskwise.biz%\') ' +
                'AND (NOT Email LIKE \'%@pssafety.net%\') ' +
                'AND (NOT Email LIKE \'%@safetyresourcing.com%\') ' +
                'AND (NOT Email LIKE \'%@blakemanandassociates.com%\') ' +
                'AND (NOT Email LIKE \'%@ironwoodbc.com%\') ' +
                'AND (NOT Email LIKE \'%@on-tracksafety.com%\') ' +
                'AND (NOT Email LIKE \'%@wscinc.ca%\') ' +
                'AND (NOT Email LIKE \'%@safetyproconsulting.com%\') ' +
                'AND (NOT Email LIKE \'%@firstcompliancesafety.com%\') ' +
                'AND (NOT Email LIKE \'%@hutchingssafetyservices.com%\') ' +
                'AND (NOT Email LIKE \'%@suncor.com%\') ' +
                'AND (NOT Email LIKE \'%@test.com%\') ' +
                'AND (NOT Email LIKE \'%@g.c%\') ' +
                'AND Id NOT IN  (SELECT contactID from User where (isActive = true OR isActive = false) AND UserType like \'%High Volume Portal%\') ';

        return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext bc, List<Contact> contRecords) {

        //System.debug(' ** CONTACT LIST SIZE = ' + contRecords.size());
        //System.debug(' ** CONTACT LIST = ' + contRecords);

        Profile sProfile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'Supplier Community Login'
        ];

        Profile cProfile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'Client Community Login'
        ];

        Map<String, String> LanguageMap = new Map<String, String>();
        LanguageMap.put('US', 'en_US');
        LanguageMap.put('GG', 'en_GG');
        LanguageMap.put('GY', 'en_GY');
        LanguageMap.put('HU', 'en_HU');
        LanguageMap.put('IQ', 'en_IQ');
        LanguageMap.put('IE', 'en_IE');
        LanguageMap.put('IM', 'en_IM');
        LanguageMap.put('JM', 'en_JM');
        LanguageMap.put('JE', 'en_JE');
        LanguageMap.put('KE', 'en_KE');
        LanguageMap.put('LA', 'en_LA');
        LanguageMap.put('LR', 'en_LR');
        LanguageMap.put('MW', 'en_MW');
        LanguageMap.put('MT', 'en_MT');
        LanguageMap.put('MU', 'en_MU');
        LanguageMap.put('MA', 'en_MA');
        LanguageMap.put('NP', 'en_NP');
        LanguageMap.put('NG', 'en_NG');
        LanguageMap.put('PK', 'en_PK');
        LanguageMap.put('AL', 'en_AL');
        LanguageMap.put('DZ', 'en_DZ');
        LanguageMap.put('AU', 'en_AU');
        LanguageMap.put('AZ', 'en_AZ');
        LanguageMap.put('BS', 'en_BS');
        LanguageMap.put('BW', 'en_BW');
        LanguageMap.put('VG', 'en_VG');
        LanguageMap.put('BG', 'en_BG');
        LanguageMap.put('CA', 'en_CA');
        LanguageMap.put('HR', 'en_HR');
        LanguageMap.put('CZ', 'en_CZ');
        LanguageMap.put('DM', 'en_DM');
        LanguageMap.put('EG', 'en_EG');
        LanguageMap.put('ET', 'en_ET');
        LanguageMap.put('GU', 'en_GU');
        LanguageMap.put('PH', 'en_PH');
        LanguageMap.put('SA', 'en_SA');
        LanguageMap.put('SL', 'en_SL');
        LanguageMap.put('ZA', 'en_ZA');
        LanguageMap.put('TZ', 'en_TZ');
        LanguageMap.put('TH', 'en_TH');
        LanguageMap.put('TT', 'en_TT');
        LanguageMap.put('TN', 'en_TN');
        LanguageMap.put('AE', 'en_AE');
        LanguageMap.put('GB', 'en_GB');
        LanguageMap.put('VI', 'en_VI');
        LanguageMap.put('VN', 'en_VN');
        LanguageMap.put('ZM', 'en_ZM');
        LanguageMap.put('ZW', 'en_ZW');
        LanguageMap.put('GT', 'es_GT');
        LanguageMap.put('HN', 'es_HN');
        LanguageMap.put('MX', 'es_MX');
        LanguageMap.put('NI', 'es_NI');
        LanguageMap.put('PA', 'es_PA');
        LanguageMap.put('AR', 'es_AR');
        LanguageMap.put('CL', 'es_CL');
        LanguageMap.put('CO', 'es_CO');
        LanguageMap.put('CR', 'es_CR');
        LanguageMap.put('DO', 'es_DO');
        LanguageMap.put('EC', 'es_EC');
        LanguageMap.put('SV', 'es_SV');
        LanguageMap.put('PE', 'es_PE');
        LanguageMap.put('ES', 'es_ES');
        LanguageMap.put('PR', 'es_PR');
        LanguageMap.put('MZ', 'pt_MZ');
        LanguageMap.put('AO', 'pt_AO');
        LanguageMap.put('BR', 'pt_BR');
        LanguageMap.put('PT', 'pt_PT');
        LanguageMap.put('MG', 'fr_MG');
        LanguageMap.put('GN', 'fr_GN');
        LanguageMap.put('NC', 'fr_NC');
        LanguageMap.put('CD', 'fr_CD');
        LanguageMap.put('CG', 'fr_CG');
        LanguageMap.put('CI', 'fr_CI');
        LanguageMap.put('FR', 'fr_FR');
        LanguageMap.put('GA', 'fr_GA');
        LanguageMap.put('DK', 'da_DK');
        LanguageMap.put('NL', 'nl_NL');
        LanguageMap.put('BE', 'nl_BE');
        LanguageMap.put('SR', 'nl_SR');
        LanguageMap.put('LU', 'de_LU');
        LanguageMap.put('AT', 'de_AT');
        LanguageMap.put('DE', 'de_DE');
        LanguageMap.put('CH', 'de_CH');
        LanguageMap.put('IT', 'it_IT');
        LanguageMap.put('SI', 'it_SI');
        LanguageMap.put('LT', 'lt_LT');
        LanguageMap.put('PL', 'pl_PL');
        LanguageMap.put('RO', 'ro_RO');
        LanguageMap.put('RS', 'sr_RS');
        LanguageMap.put('FI', 'fi_FI');
        LanguageMap.put('GR', 'el_GR');
        LanguageMap.put('IL', 'iw_IL');
        LanguageMap.put('IN', 'hi_IN');
        LanguageMap.put('JP', 'ja_JP');
        LanguageMap.put('KR', 'ko_KR');
        LanguageMap.put('MY', 'ms_MY');
        LanguageMap.put('NO', 'no_NO');
        LanguageMap.put('SE', 'sv_SE');
        LanguageMap.put('TR', 'tr_TR');

        List<String> UserNamesEmailList = new List<String>();

        for ( Contact con : contRecords ) {
            UserNamesEmailList.add(con.Email+'.avetta');
        }

        //System.debug(' ** UserNamesEmailList = ' + UserNamesEmailList);

        List<User> existingUsers = [
                SELECT Username, LastName, ContactId, Id
                FROM User
                WHERE Username =: UserNamesEmailList
                AND Profile.Name IN ( 'Supplier Community Login', 'Client Community Login' )
        ];

        //System.debug(' ** EXISTING COMMUNITY USERS SIZE = ' + existingUsers.size());

        List<User> supplierUsers      = new List<User>();
        List<User> clientUsers        = new List<User>();

        for (Contact cont : contRecords) {

            if (cont.Account.RecordType.DeveloperName == 'Contractor') {

                User newSupplierUser = new User(
                        LastName         = cont.LastName,
                        FirstName        = cont.FirstName,
                        Alias            = cont.FirstName.left(1) + cont.LastName.left(4),
                        ContactId        = cont.Id,
                        CompanyName      = cont.Account.Name,
                        ProfileId        = sProfile.Id,
                        Username         = cont.Email  + '.avetta',
                        TimeZoneSidKey   = cont.Account.tz__Timezone_SFDC__c,
                        EmailEncodingKey = 'UTF-8',
                        IsActive         = true,
                        Email            = cont.Email,
                        CurrencyIsoCode  = cont.Account.CurrencyIsoCode
                );

                if (LanguageMap.containsKey(cont.Account.BillingCountry)) {

                    newSupplierUser.LocaleSidKey      = LanguageMap.get(cont.Account.BillingCountry);
                    newSupplierUser.LanguageLocaleKey = LanguageMap.get(cont.Account.BillingCountry);

                }

                else if (newSupplierUser.LanguageLocaleKey == null && newSupplierUser.LocaleSidKey == null) {

                    newSupplierUser.LanguageLocaleKey = 'en_US';
                    newSupplierUser.LocaleSidKey      = 'en_US';
                }

                supplierUsers.add(newSupplierUser);

            } else {

                if (cont.Account.RecordType.DeveloperName == 'Operator') {

                    User newClientUser = new User(
                            LastName         = cont.LastName,
                            FirstName        = cont.FirstName,
                            Alias            = cont.FirstName.left(1) + cont.LastName.left(4),
                            ContactId        = cont.Id,
                            CompanyName      = cont.Account.Name,
                            ProfileId        = cProfile.Id,
                            Username         = cont.Email + '.avetta',
                            TimeZoneSidKey   = cont.Account.tz__Timezone_SFDC__c,
                            EmailEncodingKey = 'UTF-8',
                            IsActive         = true,
                            Email            = cont.Email,
                            CurrencyIsoCode  = cont.Account.CurrencyIsoCode
                    );

                    if (LanguageMap.containsKey(cont.Account.BillingCountry)) {

                        newClientUser.LocaleSidKey      = LanguageMap.get(cont.Account.BillingCountry);
                        newClientUser.LanguageLocaleKey = LanguageMap.get(cont.Account.BillingCountry);

                    }

                    else if (newClientUser.LanguageLocaleKey == null && newClientUser.LocaleSidKey == null) {

                        newClientUser.LanguageLocaleKey = 'en_US';
                        newClientUser.LocaleSidKey      = 'en_US';

                    }
                    clientUsers.add(newClientUser);
                }
            }
        }

        List<User> combinedUserList = new List<User>();
        combinedUserList.addAll(supplierUsers);
        combinedUserList.addAll(clientUsers);

        List<User> allNewUsersToInsert = new List<User>();

        //System.debug(' ** combinedUserList SIZE = ' + combinedUserList.size());

        Map<String, User> existingUserMap = new Map<String, User>(existingUsers);
        for (User eu : existingUsers){
            existingUserMap.put(eu.Username, eu);
        }

        Map<String, User> newUserMap = new Map<String, User>();
        for (User u : combinedUserList){
            newUserMap.put(u.Username, u);
        }

        List<User> userList2 = [SELECT Id, Username FROM User WHERE Name IN: newUserMap.keySet() LIMIT 50000];

        if (userList2.size() > 0) {
            for (User u : userList2) {

                if (newUserMap.containsKey(u.Username)){
                    newUserMap.remove(u.Username);
                }
            }
        }
        System.debug(' ** newUserMap = ' + newUserMap);
        if ( existingUsers.size() == 0 ) {
            insert newUserMap.values();

        } else {

            for (User newCommunityUser : newUserMap.values()) {
                for (User existingUser : existingUserMap.values()) {
                    if (newUserMap.containsKey(existingUser.Username)) {

                        newUserMap.remove(existingUser.Username);
                        allNewUsersToInsert.add(newCommunityUser);
                    }
                }
            }
        }
        //System.debug(' ** newUserMap -1  = ' + newUserMap);
        //System.debug(' ** existingUserMap = ' + existingUserMap);

        //System.debug(' ** allNewUsersToInsert SIZE = ' + allNewUsersToInsert.size());
        //System.debug(' ** allNewUsersToInsert  = ' + allNewUsersToInsert);
        insert allNewUsersToInsert;

    }

    global void finish(Database.BatchableContext bc){

        /**
         * This execute any post-processing operations...
         * Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
         * Query the AsyncApexJob object to retrieve the current job's information.
         * This will send a report to tgarcia@avetta.com once batch job is complete.
         *
         **/


/*
        AsyncApexJob a = [
                SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                FROM AsyncApexJob
                WHERE Id =:bc.getJobId()
        ];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[] { 'tgarcia@avetta.com.com' };
        mail.setToAddresses(toAddress);
        mail.setSubject('Apex Batch Process for New Community User Creation ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
*/

    }
}