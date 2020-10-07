trigger ConvertLead on Account (after insert, after update) {
	
//	Set<String> picsOrgIds = new Set<String>();
//
//	Account oldAccount;
//	for(Account account : trigger.new) {
//
//		oldAccount = null;
//		if(trigger.oldMap != null) {
//			oldAccount = trigger.oldMap.get(account.Id);
//		}
//
//		if(oldAccount == null) {
//			oldAccount = new Account(Status__c = 'dummy');
//		}
//
//		if(account.Organizer_ID__c != null && account.Organizer_ID__c != '' && !picsOrgIds.contains(account.Organizer_ID__c) && account.Status__c == 'Active' /*oldAccount.Status__c != account.Status__c*/) {
//			picsOrgIds.add(account.Organizer_ID__c);
//		}
//	}
//
//	if(picsOrgIds.size() == 0) {
//		return;
//	}
//
//	List<Lead> leads = [select Id,FirstName,LastName,Email,Contractor_PICS_ID__c,OwnerId from Lead
//			where Contractor_PICS_ID__c in :picsOrgIds
//			and RecordTypeId in (select Id from RecordType where Name = 'Contractor Mailing')
//			and (Status = 'Registered' or Status = 'Pending' or Status = 'Active')
//			and IsConverted = false
//			and Contractor_PICS_ID__c != null and Contractor_PICS_ID__c != ''
//			and OwnerId in (select Id from User where IsActive = true)];
//
//	if(leads.size() == 0) {
//		return;
//	}
//
//	RecordType contractorRecordType = [select Id from RecordType where Name = 'Contractor' and SobjectType = 'Account'];
//
//
//	List<Contact> contacts = [select Id,AccountId,FirstName,LastName,Email from Contact
//			where AccountId in :trigger.new];
//
//	/*****TEMPCODE TO DEAL WITH DUPLICATE LEADS *****/
//	//List<AggregateResult> results = [select Contractor_PICS_ID__c from Lead where IsConverted = false and (status = 'Pending' or Status = 'Registered' or Status = 'Active') and Contractor_PICS_ID__c != null and Contractor_PICS_ID__c != '' group by Contractor_PICS_ID__c having count(id) > 1];
//	//Set<String> tempBadLeadCpId = new Set<String>();
//	//for(AggregateResult aggregateResult : results) {
//	//	if(!tempBadLeadCpId.contains((String)aggregateResult.get('Contractor_PICS_ID__c'))) {
//	//		tempBadLeadCpId.add((String)aggregateResult.get('Contractor_PICS_ID__c'));
//	//	}
//	//}
//
//	//Map<Id,Lead> tempIgnoreLeads = new Map<Id,Lead>([select Id from Lead where Contractor_PICS_ID__c in :tempBadLeadCpId and Contractor_PICS_ID__c != null and Contractor_PICS_ID__c != '']);
//	/*****END TEMPCODE TO DEAL WITH DUPLICATE LEADS *****/
//
//	List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
//	List<Account> updateAccounts = new List<Account>();
//	List<Contact> updateContacts = new List<Contact>();
//	Database.LeadConvert leadConvert;
//	for(Account account : trigger.new) {
//
//		if(account.RecordTypeId != contractorRecordType.Id || account.Status__c != 'Active') {
//			continue;
//		}
//
//		/*****TEMPCODE TO DEAL WITH DUPLICATE LEADS *****/
//		List<AggregateResult> results = [select Contractor_PICS_ID__c from Lead where Contractor_PICS_ID__c =: account.Organizer_ID__c and (status = 'Pending' or Status = 'Registered' or Status = 'Active') and Contractor_PICS_ID__c != null and Contractor_PICS_ID__c != '' group by Contractor_PICS_ID__c having count(id) > 1];
//		Set<String> tempBadLeadCpId = new Set<String>();
//		for(AggregateResult aggregateResult : results) {
//			if(!tempBadLeadCpId.contains((String)aggregateResult.get('Contractor_PICS_ID__c'))) {
//				tempBadLeadCpId.add((String)aggregateResult.get('Contractor_PICS_ID__c'));
//			}
//		}
//		Map<Id,Lead> tempIgnoreLeads = new Map<Id,Lead>([select Id from Lead where Contractor_PICS_ID__c in :tempBadLeadCpId and Contractor_PICS_ID__c != null and Contractor_PICS_ID__c != '']);
//		/*****END TEMPCODE TO DEAL WITH DUPLICATE LEADS *****/
//
//		for(Lead lead : leads) {
//
//			/*****TEMPCODE TO DEAL WITH DUPLICATE LEADS *****/
//			if(tempIgnoreLeads.containsKey(lead.Id)) {
//				continue;
//			}
//			/*****END TEMPCODE TO DEAL WITH DUPLICATE LEADS *****/
//
//			if(lead.Contractor_PICS_ID__c == account.Organizer_ID__c) {
//				leadConvert = new Database.LeadConvert();
//				leadConvert.convertedStatus = 'Active';
//				leadConvert.doNotCreateOpportunity = true;
//				leadConvert.leadId = lead.Id;
//				leadConvert.accountId = account.Id;
//
//				if((lead.Email != null && lead.Email != '') || (lead.FirstName != null && lead.FirstName != '')) {
//					for(Contact contact : contacts) {
//						if(contact.AccountId == account.Id && ((lead.Email == contact.Email && lead.Email != null && lead.Email != '') ||
//							(lead.FirstName == contact.FirstName && lead.LastName == contact.LastName && lead.FirstName != null && lead.FirstName != ''))) {
//								leadConvert.contactId = contact.Id;
//								leadConvert.overwriteLeadSource = false;
//								if(contact.Supplier_Enablement_Rep__c == null) {
//									updateContacts.Add(new Contact(Id = contact.Id, Supplier_Enablement_Rep__c = lead.OwnerId));
//								}
//								break;
//							}
//					}
//				}
//
//				leadConverts.Add(leadConvert);
//				if(account.Supplier_Enablement_Rep__c == null) {
//					updateAccounts.Add(new Account(Id = account.Id, Supplier_Enablement_Rep__c = lead.OwnerId));
//				}
//			}
//		}
//	}
//
//	Database.convertLead(leadConverts);
//	update updateAccounts;
//	update updateContacts;
	
}