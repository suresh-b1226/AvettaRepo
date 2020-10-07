/*
 * controller for CommissionApproval page. By leo in November,2013
*/
public with sharing class CommissionApprovalController 
{

   public CommissionApprovalController() {}

/* SSF - commented out for test case failure and no usage of this functionality (confirmed with Jeff)
    public User currentUser { get; set; }
    public String Month { get; set; }
    public String selectMonth { get; set;}
    public String selectYear { get; set;}
    public String selectUser { get; set; }//user ID
    public String selectUserName { get; set; }
    private transient List<Commission__c> CommissionsList { get; set; }// Commissions of all users in certain month
    public List<CommissionStatistics> CommissionStatisticsList { get; set; }
    public List<Commission__c> CommissinsInOneMonth { get; set; } // Commissions of a certain user in certain month
    private List<User> salesReps { get; set; }
    private Set<String> salesRepIdSet { get; set; }
    private Map<String, User> salesRepsMap { get; set; }
    private transient Map<String, List<Commission__c>> CommissionMap { get; set; }// commissions of all users in certain month
    private Map<String, CommissionStatistics> CommissionStatisticsMap { get; set; }
    public Decimal QuotaTotal { get; set; }
    public Decimal InvoiceQuotaEligibleTotal { get; set; }
    public Decimal QuotaAttainedTotal { get; set; }
    public Decimal InvoiceCommissionEligibleTotal { get; set; }
    public Decimal CommissionTotal { get; set; }
    public Boolean IsSalesManager { get; set; }
    public Boolean DiplayCommissions { get; set; }
    public Boolean CanAdjustOrNot { get; set; }
    public Commission__c AdjustCommission { get; set; }
    public Commission__c CommissionAdjustTemp { get; set; }
    public String commissionId { get; set; }
    public Decimal CommissionAmount { get; set; }//for adjust
    public String  AdjustmentDescription { get; set; }// for adjust
    //paging
    public Integer mp_iOFFSET { get; set; }
    public Integer mp_iTotalPages { get; set; }
    public Integer mp_iCurrentPage { get; set; }
    public Integer mp_iPageRecords { get; set; }
    public Integer mp_iTotalRecordCounts { get; set; }

    public List<SelectOption> MonthOptions
    {
        get
        {
            List<SelectOption> results = new List<SelectOption>();
            Integer currentYear = Date.today().year();
            Integer currentMonth = Date.today().month();
            for(Integer i = currentYear; i > currentYear - 2; i--)
            {
                if(i == currentYear)
                {
                    for(Integer j = currentMonth - 1; j > 0; j-- )
                    {
                        results.add(new SelectOption(String.valueof(i) + String.valueOf(j), String.valueOf(i) + ' - ' + String.valueOf(j)));
                    }
                }
                else
                {
                    for(Integer j = 12; j > 0; j-- )
                    {
                        results.add(new SelectOption(String.valueof(i) + String.valueOf(j), String.valueOf(i) + ' - ' + String.valueOf(j)));
                    }
                }
                
            }
            return results;
        }   
    }

    public CommissionApprovalController()
    {
        String currentUserId = UserInfo.getUserId();
        currentUser = [select Id, Name, YearlyQuota__c, (select Id, Name, YearlyQuota__c, IsActive from sales__r) from User where Id = :currentUserId];
        
        salesRepIdSet = new Set<String>();
        salesRepsMap = new Map<String, User>();
        Profile accountManagerProfile = [select Id from Profile where Name = 'Account Management'];
        String currentUserProfileId = UserInfo.getProfileId();
        if(accountManagerProfile != null && currentUserProfileId == accountManagerProfile.Id)
        {
            IsSalesManager = false;
            List<User> userList = [select Id, Name, YearlyQuota__c, IsActive, (select Id, Name, YearlyQuota__c, IsActive from sales__r) from User where IsActive = true and Id != :currentUserId];
            for(User userTemp : userList)
            {
                salesRepIdSet.add(userTemp.Id);
                salesRepsMap.put(userTemp.Id, userTemp);
            }          
        }
        else
        {
            salesReps = currentUser.sales__r;
            if(salesReps.size() > 0)//is sales manager
            {
                for(User user : salesReps)
                {
                    if(user.IsActive == true)
                    {
                        salesRepIdSet.add(user.Id);
                        salesRepsMap.put(user.Id, user);
                    }
                }
                IsSalesManager = true;
            }
        }
        
        String currentYear = String.valueOf(Date.today().year());
        String defaultMonth = String.valueOf(Date.today().month() - 1);
        selectMonth = defaultMonth;
        selectYear = currentYear;
        CommissionsList = [select Id, AdjustmentDescription__c, Commissionable_Amount__c, Commission_Amount__c, Commission_Percent__c, Contractor__c, InvoiceID__c, InvoiceTotalAmount__c, Invoice_Type__c, Operator__c, Payment_Date__c, Payment_ID__c, Quota_Attributable_Amount__c, QuotaAttributablePercent__c, Total_Payment_Amount__c, Transaction_Status__c, User__c from Commission__c where User__c in :salesRepIdSet and FY_Year__c = :selectYear and FY_Month__c = :selectMonth order by Payment_Date__c]; 
        List<SummarizedCommission__c> summarizedCommissionList = [select Id, ApprovalType__c, Commission_Month_Year__c, User__c from SummarizedCommission__c];
        doStatistics(summarizedCommissionList);
        DiplayCommissions = false;
        CanAdjustOrNot = true;

        mp_iOFFSET = 0;
        mp_iCurrentPage = 1;
        mp_iPageRecords = 25;
        //getPayments();
    }
    public void monthSelectChange()
    {
        List<SummarizedCommission__c> summarizedCommissionList = null;
        if(Month != null)
        {
            selectYear = Month.substring(0,4);
            selectMonth = Month.substring(4);
            CommissionsList = [select Id, AdjustmentDescription__c, Commissionable_Amount__c, Commission_Amount__c, Commission_Percent__c, Contractor__c, InvoiceID__c, InvoiceTotalAmount__c, Invoice_Type__c, Operator__c, Payment_Date__c, Payment_ID__c, Quota_Attributable_Amount__c, QuotaAttributablePercent__c, Total_Payment_Amount__c, Transaction_Status__c, User__c from Commission__c where User__c in :salesRepIdSet and FY_Year__c = :selectYear and FY_Month__c = :selectMonth order by Payment_Date__c]; 
            summarizedCommissionList = [select Id, ApprovalType__c, Commission_Month_Year__c, User__c from SummarizedCommission__c];
        }
        doStatistics(summarizedCommissionList);
        DiplayCommissions = false;
    }
    public void doStatistics(List<SummarizedCommission__c> summarizedCommissionList)
    {
        CommissionStatisticsList = new List<CommissionStatistics>();

        CommissionMap = new Map<String, List<Commission__c>>();
        List<String> salesRepIdList = new List<String>();
        salesRepIdList.addAll(salesRepIdSet);
        for(Integer i = 0; i < salesRepIdList.size(); i++)
        {
            CommissionMap.put(salesRepIdList.get(i), new List<Commission__c>());   
        }
        for(Commission__c commission : CommissionsList)
        {
            if(commission.User__c != null)
            {
                String commissionUser = commission.User__c;
                CommissionMap.get(commissionUser).add(commission);
            }
        }
        
        Set<String> hasNoUnapprovedUserIdSet = new Set<String>();        
        for(Integer i = 0; i < salesRepIdList.size(); i++)//do Statistics per user in certain month
        {
            Decimal quotaTemp = 0;
            if(salesRepsMap.get(salesRepIdList.get(i)).YearlyQuota__c != null)
            {
                quotaTemp = salesRepsMap.get(salesRepIdList.get(i)).YearlyQuota__c;
            }
            else{
                quotaTemp = 0;
            }
            CommissionStatistics commissionStatistics = new CommissionStatistics(salesRepsMap.get(salesRepIdList.get(i)), quotaTemp);

            commissionStatistics.Commission = 0;
            commissionStatistics.QuotaAttributableAmount = 0;
            commissionStatistics.QuotaAttributablePercent = 0;
            commissionStatistics.CommissionableAmount = 0;
            List<Commission__c> tempList =  CommissionMap.get(salesRepIdList.get(i));
            if(tempList.size() > 0)
            {
                // judge commissions (of certain user in certain month) has been approved or not
                if(summarizedCommissionList.size() > 0)
                {
                    for(SummarizedCommission__c sc : summarizedCommissionList)
                    {
                        String approvalTypeTem = (IsSalesManager == true ? 'Sales Manager' : 'Accounting User');
                        String monthYearTem = selectMonth + '/' + selectYear;
                        if(sc.User__c == salesRepIdList.get(i) && sc.ApprovalType__c ==  approvalTypeTem && sc.Commission_Month_Year__c == monthYearTem)
                        {
                            commissionStatistics.Hidden = true;
                        }
                    }
                }

                Integer adjustCommissionCounter = 0;
                for(Commission__c commission : tempList)
                {
                    if(commission.Invoice_Type__c != 'Adjustment')
                    {
                        if(commission.Quota_Attributable_Amount__c != null)
                        {
                            commissionStatistics.QuotaAttributableAmount += commission.Quota_Attributable_Amount__c;
                        }
                        if(commission.QuotaAttributablePercent__c != null)
                        {
                            commissionStatistics.QuotaAttributablePercent += commission.QuotaAttributablePercent__c;
                        }
                        if(commission.Commissionable_Amount__c != null)
                        {
                           commissionStatistics.CommissionableAmount += commission.Commissionable_Amount__c;
                        }
                    }
                    else
                    {
                        adjustCommissionCounter ++;
                    }
                    if(commission.Commission_Amount__c != null)
                    {
                        commissionStatistics.Commission += commission.Commission_Amount__c;  
                    }
                }
                Integer divNumber = tempList.size()-adjustCommissionCounter;
                if(divNumber > 0)
                {
                    commissionStatistics.QuotaAttributablePercent = commissionStatistics.QuotaAttributablePercent / divNumber;
                }
                CommissionStatisticsList.add(commissionStatistics);
            }
            else
            {
                hasNoUnapprovedUserIdSet.add(salesRepIdList.get(i));
            }
        }

        //CommissionStatisticsMap is used in approval method for convenience
        CommissionStatisticsMap = new Map<String, CommissionStatistics>();
        for(CommissionStatistics commissionStatistics : CommissionStatisticsList)
        {
            CommissionStatisticsMap.put(commissionStatistics.User.Id, commissionStatistics);
        }

        //do statistics of all users
        QuotaTotal = 0;
        InvoiceQuotaEligibleTotal = 0;
        QuotaAttainedTotal =0;
        InvoiceCommissionEligibleTotal =0;
        CommissionTotal =0;
        for(Integer i = 0; i < salesRepIdList.size(); i++)
        {
            if(!hasNoUnapprovedUserIdSet.contains(salesRepIdList.get(i)))
            {
                if(salesRepsMap.get(salesRepIdList.get(i)).YearlyQuota__c != null)
                {
                    QuotaTotal = QuotaTotal + salesRepsMap.get(salesRepIdList.get(i)).YearlyQuota__c;
                }
            }
        }
        for(CommissionStatistics commissionStatisticsList : CommissionStatisticsList)
        {
            InvoiceQuotaEligibleTotal += commissionStatisticsList.QuotaAttributableAmount;
            QuotaAttainedTotal += commissionStatisticsList.QuotaAttributablePercent;
            InvoiceCommissionEligibleTotal += commissionStatisticsList.CommissionableAmount;
            CommissionTotal += commissionStatisticsList.Commission;
        }
    }

    public void approval()
    {
         String userId = Apexpages.currentPage().getParameters().get('approvedUserId');
         if(userId != null)
         {
            SummarizedCommission__c summarizedCommission = new SummarizedCommission__c();
            summarizedCommission.User__c = userId;
            summarizedCommission.ApprovalDate__c = Date.today();
            summarizedCommission.ApprovalType__c = IsSalesManager == true ? 'Sales Manager' : 'Accounting User';
            summarizedCommission.CommissionAmount__c = CommissionStatisticsMap.get(userId).Commission;
            Integer selectYearInteger = Integer.valueOf(selectYear);
            Integer selectMonthInteger = Integer.valueOf(selectMonth);
            summarizedCommission.Commission_Month_Year__c = selectMonthInteger + '/' + selectYearInteger;
            summarizedCommission.MgrApprover__c = currentUser.Id;
            Integer days = Date.daysInMonth(selectYearInteger, selectMonthInteger);
            summarizedCommission.PeriodEndDate__c = Date.newInstance(selectYearInteger, selectMonthInteger, days);
            summarizedCommission.PeriodStartDate__c = Date.newInstance(selectYearInteger, selectMonthInteger, 1);
            summarizedCommission.QuotaActual__c = CommissionStatisticsMap.get(userId).Quota * CommissionStatisticsMap.get(userId).QuotaAttributablePercent/100.00;
            summarizedCommission.QuotaGoal__c = CommissionStatisticsMap.get(userId).Quota;
            insert summarizedCommission;
            
            Integer approvedUserIndex = null;
            for(Integer i = 0; i < CommissionStatisticsList.size(); i++)
            {
                if(CommissionStatisticsList.get(i).User.Id == userId)
                {
                    approvedUserIndex = i;
                    break;
                }
            }
            if(approvedUserIndex != null)
            {
                CommissionStatisticsList.get(approvedUserIndex).Hidden = true;
            }

            if(selectUser != null && userId == selectUser)
            {
                CanAdjustOrNot = false;
            }
         }
         
    }

    public void diplayCommissionForCertainUser()
    {
        CanAdjustOrNot = true;
        if(selectUser != null)
        {
            if(selectYear != null && selectMonth != null)
            {
                mp_iOFFSET = 0;
                mp_iCurrentPage = 1;
                getResults();
            }
           //CommissinsInOneMonth = CommissionMap.get(selectUser);
            List<SummarizedCommission__c> smList = [select Id, ApprovalType__c, Commission_Month_Year__c, User__c from SummarizedCommission__c];
            if(smList.size() > 0)
            {
                for(SummarizedCommission__c sc : smList)
                {
                    String atTem = (IsSalesManager == true ? 'Sales Manager' : 'Accounting User');
                    String myTem = selectMonth + '/' + selectYear;
                    if(sc.User__c == selectUser && sc.ApprovalType__c ==  atTem && sc.Commission_Month_Year__c == myTem)
                    {
                        CanAdjustOrNot = false;
                    }
                }
            }
            DiplayCommissions = true;
        }
    }
    public void getResults()
    {
        String soql = 'select Id, AdjustmentDescription__c, Commissionable_Amount__c, Commission_Amount__c, Commission_Percent__c, Contractor__c, InvoiceID__c, InvoiceTotalAmount__c, Invoice_Type__c, Operator__c, Payment_Date__c, Payment_ID__c, Quota_Attributable_Amount__c, QuotaAttributablePercent__c, Total_Payment_Amount__c, Transaction_Status__c, User__c from Commission__c where User__c = :selectUser and FY_Year__c = :selectYear and FY_Month__c = :selectMonth order by Payment_Date__c';
        mp_iTotalRecordCounts = (dataBase.query(soql)).size();
        mp_iTotalPages = (mp_iTotalRecordCounts/mp_iPageRecords) + ((math.mod(mp_iTotalRecordCounts, mp_iPageRecords) == 0)?0:1);       
        mp_iOFFSET = (math.max(math.min(mp_iCurrentPage, mp_iTotalPages), 1) - 1)*mp_iPageRecords;
        soql += ' Limit :mp_iPageRecords OFFSET :mp_iOFFSET';
        CommissinsInOneMonth = dataBase.query(soql);
    }

    public void adjust()
    {
        if(commissionId != null)
        {
            Commission__c cion = [select Id, Operator__c, Operator__r.Name, Contractor__c , Contractor__r.Name , User__c, User__r.Name ,  Invoice_Type__c,  Payment_Date__c, Creator__c, Commission_Amount__c, AdjustmentDescription__c from Commission__c where Id = :commissionId];
            CommissionAdjustTemp = cion;
            AdjustCommission = new Commission__c(Operator__c = cion.Operator__c, Contractor__c = cion.Contractor__c, User__c = cion.User__c, Invoice_Type__c = 'Adjustment', Payment_Date__c = cion.Payment_Date__c, Creator__c = currentUser.Id);
        }
    }

    public void createAdjustCommission()
    {
        if(AdjustCommission != null)
        {
            AdjustCommission.Commission_Amount__c = CommissionAmount;
            AdjustCommission.AdjustmentDescription__c = AdjustmentDescription;
            insert AdjustCommission;
            getResults();// to dispaly commission adjustment
            if(AdjustCommission.User__c != null)
            {
                Integer userIndex = null;
                for(Integer i = 0; i < CommissionStatisticsList.size(); i++)
                {
                    if(CommissionStatisticsList.get(i).User.Id == AdjustCommission.User__c)
                    {
                        userIndex = i;
                        CommissionMap.get(AdjustCommission.User__c).add(AdjustCommission);
                        break;
                    }
                }
                if(userIndex != null)
                {
                    CommissionStatisticsList.get(userIndex).Commission += CommissionAmount;
                    CommissionTotal += CommissionAmount;
                }
            }
        }
    }
    
    //monthly Statistics for each user
    public class CommissionStatistics
    {
        public User User { get; set; }
        public Decimal Commission { get; set; }
        public Decimal Quota { get; set; }
        public Decimal QuotaAttributableAmount { get; set; }
        public Decimal QuotaAttributablePercent { get; set; }
        public Decimal CommissionableAmount { get; set; }
        public Boolean Hidden { get; set; }

        public CommissionStatistics(User user, Decimal quota)
        {
            this.User = user;
            this.Quota = quota;
            this.Hidden = false;
        }
    }
    SSF */
}