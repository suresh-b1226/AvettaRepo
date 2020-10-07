/**
 * ISR View Quotas
 */
public class ISRViewQuotasController 
{
	public ISRViewQuotasController()
	{
		isActionByURL = true;
		init();
	}
	
	public List<EmployeeISRQuoteInfo> CurrentSalesManagerISRQuotes { get; set; }
	public String SelectUserId { get; set; }
	public String Year { get; set; }
	public Boolean isActionByURL { get; set; }
	
	public List<SelectOption> AllSalesOptions
    {
    		get
    		{
    			List<SelectOption> results = new List<SelectOption>();
    			List<User> allSales = [select Id, Name from User where IsActive = true limit 45000];
	    		for(User u : allSales)
	    		{	    			
	    			results.add(new selectOption(u.Id, u.Name));
	    		}
    			return results;
    		}
    }
    
	public List<SelectOption> AllSalesManagerOptions
    {
    		get
    		{
    			List<SelectOption> results = new List<SelectOption>();
    			results.add(new selectOption('', '--None--'));
    			List<User> allHasManagerUsers = [select Id, SalesManager__c from User where IsActive = true and SalesManager__c != null];
    			set<Id> allManagerIds = new set<Id>();
    			for(User allHasManagerUser : allHasManagerUsers)
    			{
    				allManagerIds.add(allHasManagerUser.SalesManager__c);
    			}
    			List<User> allManagers = [select Id, Name from User where Id in:allManagerIds and IsActive = true];
	    		for(User u : allManagers)
	    		{	    			
	    			results.add(new selectOption(u.Id, u.Name));
	    		}
    			return results; 
    		}
    }
    
    public List<SelectOption> AllYearsOptions
    {
    		get
    		{
    			List<SelectOption> results = new List<SelectOption>();
    			results.add(new selectOption('', '--None--'));
	    		for(Integer i = 0; i < 10; i++)
	    		{	   
	    			 			
	    			results.add(new selectOption(String.valueOf(i + 2012), String.valueOf(i + 2012)));
	    		}
    			return results;
    		}
    }
    
	public List<String> AllQuotesMonths
	{
		get
		{
			List<String> results = new List<String>();
			if(year != null && year != '')
			{
				//Date currentDay = Date.today();
				//Date startDay = currentDay.toStartOfMonth();
				Integer yearInt = integer.valueOf(year);
				Date startDay = Date.newInstance(yearInt, 1, 1);
				for(Integer i = 0; i < 12; i++)
				{
					Date currentMonthDay = startDay.addMOnths(i);
					DateTime currentMonthDatetime = Datetime.newInstance(currentMonthDay.year(), currentMonthDay.month(), currentMonthDay.day());
					String currentMonthTime = currentMonthDatetime.format('MMM yyyy');
					results.add(currentMonthTime	);
				}
			}
			return results;
		}		
	}
	
	public void populateQuotas()
	{
		isActionByURL = false;
		init();	
	}
	
	private void init()
	{
		CurrentSalesManagerISRQuotes = new List<EmployeeISRQuoteInfo>();
		Boolean isProcess = false;
		if(selectUserId != null && selectUserId != '' && year != null && year != '')
		{
			isProcess = true;			
		}
		else if(isActionByURL && ApexPages.currentPage().getParameters().get('salesmanagerId') != null && ApexPages.currentPage().getParameters().get('salesmanagerId') instanceOf Id)
		{
			isProcess = true;
			isActionByURL = false;
			selectUserId = ApexPages.currentPage().getParameters().get('salesmanagerId');
			year = String.valueOf(Date.today().year());
		}
		if(isProcess)
		{
			CurrentSalesManagerISRQuotes = new List<EmployeeISRQuoteInfo>();
			List<User> allSalesUnderCurrentManager = [select Id, Name from User where IsActive = true and SalesManager__c = : selectUserId];
			Integer yearInt = integer.valueOf(year);
			Date startDay = Date.newInstance(yearInt, 1, 1);
			Date endDay = startDay.addMonths(12);
			List<ISR_Quota__c> ISRQuotes = [select Id, Name, Actual__c, Employee__c, Manager__c, Month__c, Percent__c, Quota__c, Year__c from ISR_Quota__c where Employee__c in:allSalesUnderCurrentManager and Manager__c = : selectUserId and Month__c >= : startDay and Month__c < :endDay];
			if(ISRQuotes.size() > 0)
			{
				Map<Id, Map<Date, ISR_Quota__c>> userQuotesMap = new Map<Id, Map<Date, ISR_Quota__c>>();
				for(ISR_Quota__c quote : ISRQuotes)
				{
					Date currentQuoteDate = quote.Month__c.toStartOfMonth();
					if(userQuotesMap.containskey(quote.Employee__c))
					{
						Map<Date, ISR_Quota__c> currentEmployeeQUotesMap = userQuotesMap.get(quote.Employee__c);		
						currentEmployeeQUotesMap.put(currentQuoteDate, quote);
						userQuotesMap.put(quote.Employee__c, currentEmployeeQUotesMap);
					}
					else
					{
						Map<Date, ISR_Quota__c> currentEmployeeQUotesMap = new Map<Date, ISR_Quota__c>();
						currentEmployeeQUotesMap.put(currentQuoteDate, quote);
						userQuotesMap.put(quote.Employee__c, currentEmployeeQUotesMap);
					}
				}	
				for(User u : allSalesUnderCurrentManager)
				{
					
					if(userQuotesMap.containsKey(u.Id))
					{
						Map<Date, ISR_Quota__c> currentEmployeeQUotesMap = userQuotesMap.get(u.Id);
						for(Integer i = 0; i < 12; i++)
						{
							Date currentMonthDay = startDay.addMOnths(i);
							if(!currentEmployeeQuotesMap.containsKey(currentMonthDay))
							{
								currentEmployeeQUotesMap.put(currentMonthDay, new ISR_Quota__c(Employee__c = u.Id, Manager__c = selectUserId, Month__c = currentMonthDay, Year__c = String.valueOf(currentMonthDay.year())));
							}
						}
						userQuotesMap.put(u.Id, currentEmployeeQuotesMap);
					}
					else
					{
						Map<Date, ISR_Quota__c> currentEmployeeQuotesMap = new Map<Date, ISR_Quota__c>();
						for(Integer i = 0; i < 12; i++)
						{
							Date currentMonthDay = startDay.addMOnths(i);
							currentEmployeeQUotesMap.put(currentMonthDay, new ISR_Quota__c(Employee__c = u.Id, Manager__c = selectUserId, Month__c = currentMonthDay, Year__c = String.valueOf(currentMonthDay.year())));
						}
						userQuotesMap.put(u.Id, currentEmployeeQuotesMap);
					}
				}
				for(Id userId : userQuotesMap.keyset())
				{
					Map<Date, ISR_Quota__c> currentEmployeeQUotesMap = userQuotesMap.get(userId);
					EmployeeISRQuoteInfo currentEmployeeISRQuoteItem = new EmployeeISRQuoteInfo();
					currentEmployeeISRQuoteItem.EmployeeId = userId;
					for(Integer i = 0; i < 12; i++)
					{
						Date currentMonthDay = startDay.addMOnths(i);
						ISR_Quota__c currentMonthQuote = currentEmployeeQUotesMap.get(currentMonthDay);
						ISRQuoteInfo currentMonthQUoteItem = new ISRQuoteInfo();
						currentMonthQUoteItem.ISRQuote = currentMonthQuote;
						currentMonthQUoteItem.Employee = userId;
						currentMonthQUoteItem.QuoteDate = currentMonthDay;
						currentMonthQUoteItem.SalesManager = selectUserId;
						if(currentMonthQuote.Id != null)
						{
							currentMonthQUoteItem.QuoteAmount = currentMonthQuote.Quota__c;					
							currentMonthQUoteItem.QuoteId = currentMonthQuote.Id;
							currentMonthQUoteItem.QuoteName = currentMonthQuote.Name;
						}
						currentEmployeeISRQuoteItem.CurrentQuotes.add(currentMonthQUoteItem);
					}
					CurrentSalesManagerISRQuotes.add(currentEmployeeISRQuoteItem);
				}
			}
		}
	}
	
	public class EmployeeISRQuoteInfo
	{
		public EmployeeISRQuoteInfo()
		{
			this.CurrentQuotes = new List<ISRQuoteInfo>();
		}
		
		public Id EmployeeId { get; set; }
		public List<ISRQuoteInfo> CurrentQuotes { get; set; }
	}
	
	public class ISRQuoteInfo
	{
		public ISRQuoteInfo()
		{
			
		}
		
		public ISR_Quota__c ISRQuote { get; set; }
		public String QuoteName { get; set; }
		public String QuoteId { get; set; }
		public Decimal QuoteAmount { get; set; }
		public Id SalesManager { get; set; }
		public Id Employee { get; set; }
		public Date QuoteDate { get; set; }
	}
}