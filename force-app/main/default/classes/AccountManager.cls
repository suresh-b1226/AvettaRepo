public class AccountManager {

    public String salesRepName { get; set; }
    public String salesRepEmail { get; set; }
    public String salesRepPhone { get; set; }
    public String successManagerName { get; set; }
    public String successManagerEmail { get; set; }
    public String successManagerPhone { get; set; }


    public AccountManager() {
        User AccountManagerUser = [
                SELECT
                        Id,
                        Contact.Id,
                        Contact.Account.Sales_Rep_Owner__r.Name,
                        Contact.Account.Sales_Rep_Owner__r.Phone,
                        Contact.Account.Sales_Rep_Owner__r.Email,
                  Contact.Account.Client_Success_Manager__r.Name,
                        Contact.Account.Client_Success_Manager__r.Phone,
                        Contact.Account.Client_Success_Manager__r.Email

                FROM
                        User
                WHERE Id = :UserInfo.getUserId()
                LIMIT 1
        ];
        System.debug('AccountManagerUser = ' + AccountManagerUser);
        System.debug('AccountManagerUser.Contact.Account.Sales_Rep_Owner__r.Name = ' + AccountManagerUser.Contact.Account.Sales_Rep_Owner__r.Name);
        System.debug('AccountManagerUser.Contact.Account.Sales_Rep_Owner__r.Email = ' + AccountManagerUser.Contact.Account.Sales_Rep_Owner__r.Email);
        System.debug('AccountManagerUser.Contact.Account.Sales_Rep_Owner__r.Phone = ' + AccountManagerUser.Contact.Account.Sales_Rep_Owner__r.Phone);

        salesRepName = AccountManagerUser.Contact.Account.Sales_Rep_Owner__r.Name;
        salesRepEmail = AccountManagerUser.Contact.Account.Sales_Rep_Owner__r.Email;
        salesRepPhone = AccountManagerUser.Contact.Account.Sales_Rep_Owner__r.Phone;
        successManagerName = AccountManagerUser.Contact.Account.Client_Success_Manager__r.Name;
        successManagerEmail = AccountManagerUser.Contact.Account.Client_Success_Manager__r.Email;
        successManagerPhone = AccountManagerUser.Contact.Account.Client_Success_Manager__r.Phone;


//        Client_Success_Manager__c
//          Sales_Rep_Owner__c
    }
}