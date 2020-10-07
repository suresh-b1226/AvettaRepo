@RestResource(urlMapping='/avetta/brazilPayment/*')
global with sharing class ConnectBrazilPaymentCase {
	
    @HttpPost
    global static ID insertCase (String accountId, String contactId, Double invoiceAmount, Double termLength, String currencyCode) {
    	
        Group rsmUser;
        try {
        	rsmUser = [SELECT Id FROM Group WHERE Name = 'RSM'][0];
        } catch (Exception e) {
                        API_CONNECT_Helpers.logException(e);
                    }
        System.debug('rsmUser = ' + rsmUser);
        
        Account sfAccount;
        try {
            sfAccount = [SELECT Id FROM Account WHERE AccountMongoID__c =: accountId][0];
        } catch (Exception e) {
                        API_CONNECT_Helpers.logException(e);
                    }
        System.debug('account = ' + sfAccount);
        
        List<Contact> sfContacts = new List<Contact>();
        try {
            sfContacts = [SELECT Id FROM Contact WHERE MongoDB_ID__c =: contactId];
        } catch (Exception e) {
                        API_CONNECT_Helpers.logException(e);
                    }
        System.debug('contact = ' + sfContacts);
        
        Contact sfContact;
        sfContact = sfContacts.size() > 0 ? sfContacts[0] : NULL;
        
        Case thisCase = new Case(
            
            AccountId = sfAccount.Id,
            ContactId = sfContact != NULL ? sfContact.Id : NULL,
            Invoice_Amount__c = invoiceAmount,
            Term_Length_Months__c = termLength,
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Supplier - RSM').getRecordTypeId(),
            OwnerId = rsmUser.Id,
            Origin = 'Avetta',
            Status = 'Sent Nota Fiscal',
            Priority = 'High',
            CurrencyIsoCode = currencyCode
            
        );
        
        insert thisCase;
        
        return thisCase.Id;
    }
    
 	@HttpPut
    global static ID updateCaseCouponCode (String accountId, String couponCode) {
        
        Case existingCase;
        try {
            existingCase = [SELECT Id 
                            FROM Case 
                            WHERE Account.AccountMongoID__c =: accountId 
                            	AND Coupon_Code__c = NULL 
                            ORDER BY CreatedDate DESC LIMIT 1][0];
        } catch (Exception e) {
        	API_CONNECT_Helpers.logException(e);
        }
        
        existingCase.Coupon_Code__c = couponCode;
        update existingCase;
        
        return existingCase.Id;
    }
    
}