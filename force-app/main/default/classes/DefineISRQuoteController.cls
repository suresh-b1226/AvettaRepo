/**
 * Defines ISR Quotes for sales manager
 */
public class DefineISRQuoteController 
{
	public DefineISRQuoteController()
	{
		init();
	}
	
	public List<EmployeeISRQuoteInfo> CurrentSalesManagerISRQuotes { get; set; }
	
	public void defineQuotes()
	{
		//List<ISR_Quota__c> toBeFinedQuotas = new List<ISR_Quota__c>();
		List<ISR_Quota__c> newISRQUotas = new List<ISR_Quota__c>();
		List<ISR_Quota__c> updatedQuotas = new List<ISR_Quota__c>();
		List<ISR_Quota__c> deletedQuotas = new List<ISR_Quota__c>();
		for(EmployeeISRQuoteInfo employeeQuota : CurrentSalesManagerISRQuotes)
		{
			for(ISRQuoteInfo isrQuota : employeeQuota.CurrentQuotes)
			{
				if(isrQuota.ISRQuote.Id == null)
				{
					if(isrQuota.ISRQuote.Quota__c != null && isrQuota.ISRQuote.Quota__c != 0)
					{
						newISRQUotas.add(isrQuota.ISRQuote);
					}
				}
				else
				{
					if(isrQuota.ISRQuote.Quota__c == null)
					{
						deletedQuotas.add(isrQuota.ISRQuote);						
					}
					else
					{
						updatedQuotas.add(isrQuota.ISRQuote);
					}
				}
			}
		}
		Boolean isSuccessed = true;
		String Errors = '';
		if(newISRQUotas.size() > 0)
		{			
			try
			{
				insert newISRQUotas;				
			}
			catch(Exception ex)
			{
				isSuccessed = false;
				Errors += ex.getMessage() + '/r/n';
			}
		}
		if(isSuccessed && newISRQUotas.size() > 0)
		{
			set<Id> employeeIds = new set<Id>();
			newISRQUotas = [select Id, Name, Actual__c, Employee__c, Manager__c, Month__c, Percent__c, Quota__c, Year__c from ISR_Quota__c where Id in :newISRQUotas];
			for(ISR_Quota__c newIsrQuotaItem : newISRQUotas)
			{
				employeeIds.add(newIsrQuotaItem.Employee__c);
			}
			for(Id employeeId : employeeIds)
			{
				createChatterPost(employeeId);
			}
			/*List<FeedItem> feedItems = new List<FeedItem>();
			newISRQUotas = [select Id, Name, Actual__c, Employee__c, Manager__c, Month__c, Percent__c, Quota__c, Year__c from ISR_Quota__c where Id in :newISRQUotas];
			for(ISR_Quota__c newIsrQuotaItem : newISRQUotas)
			{
				FeedItem newItem = new FeedItem(ParentId = newIsrQuotaItem.Id, Type='LinkPost', Title='Click here to view the details.', LinkUrl='/apex/ISRViewQuotas', CreatedById = newIsrQuotaItem.Employee__c, Body='You received a new Quota assignment.');
				feedItems.add(newItem);
			}
			system.debug('###' + feedItems);
			insert feedItems;
			feedItems = [select Id, Body, parentId from FeedItem where Id in:feedItems];
			system.debug('###2' + feedItems);*/
		}
		if(isSuccessed && updatedQuotas.size() > 0)
		{
			try
			{
				update updatedQuotas;
			}
			catch(Exception ex)
			{
				delete newISRQUotas;
				isSuccessed = false;
				Errors += ex.getMessage() + '/r/n';
			}
		}
		if(isSuccessed && deletedQuotas.size() > 0)
		{
			try
			{
				delete deletedQuotas;
			}
			catch(Exception ex)
			{
				delete newISRQUotas;
				isSuccessed = false;
				Errors += ex.getMessage() + '/r/n';
			}
		}
		if(isSuccessed)
		{
			init();
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Quotas succesfully defined.'));
			
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to define quotas. Please contact your system administrator. ' + Errors));
		}
	}
	
	private void createChatterPost(Id employeeId)
	{
		String communityId = null;
		ConnectApi.FeedType feedType = ConnectApi.FeedType.UserProfile;		
		ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
		ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegment;
		ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();		
		messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		mentionSegment.id = employeeId;
		messageInput.messageSegments.add(mentionSegment);
		textSegment = new ConnectApi.TextSegmentInput();
		textSegment.text = ' You received a Quota. Please click ';
		messageInput.messageSegments.add(textSegment);
		ConnectApi.LinkSegmentInput linkSegment = new ConnectApi.LinkSegmentInput();
		PageReference currentPage = ApexPages.currentPage();
		String hostName = currentPage.getHeaders().get('Host');
		linkSegment.Url= 'https://' + hostName + '/apex/ISRViewQuotas?salesmanagerId=' + UserInfo.getUserId();
		messageInput.messageSegments.add(linkSegment);
		textSegment = new ConnectApi.TextSegmentInput();
		textSegment.text = ' to view Details.';
		messageInput.messageSegments.add(textSegment);
		input.body = messageInput;		
		ConnectApi.FeedItem feedItemRep = ConnectApi.ChatterFeeds.postFeedItem(communityId, feedType, 'me', input, null);
	}
	
	public List<String> AllQuotesMonths
	{
		get
		{
			List<String> results = new List<String>();
			Date currentDay = Date.today();
			//Date startDay = currentDay.toStartOfMonth();
			Date startDay = Date.newInstance(currentDay.year(), 1, 1);
			for(Integer i = 0; i < 12; i++)
			{
				Date currentMonthDay = startDay.addMonths(i);
				DateTime currentMonthDatetime = Datetime.newInstance(currentMonthDay.year(), currentMonthDay.month(), currentMonthDay.day());
				String currentMonthTime = currentMonthDatetime.format('MMM yyyy');
				results.add(currentMonthTime	);
			}
			return results;
		}		
	}
	
	public List<SelectOption> AllSalesOptions
    {
    		get
    		{
    			List<SelectOption> results = new List<SelectOption>();
    			List<User> allSales = [select Id, Name from User where IsActive = true and SalesManager__c = : UserInfo.getUserId()];
	    		for(User u : allSales)
	    		{	    			
	    			results.add(new selectOption(u.Id, u.Name));
	    		}
    			return results;
    		}
    }
    
	private void init()
	{
		CurrentSalesManagerISRQuotes = new List<EmployeeISRQuoteInfo>();
		List<User> allSalesUnderCurrentManager = [select Id, Name from User where IsActive = true and SalesManager__c = : UserInfo.getUserId()];
		Date currentDay = Date.today();
		//Date startDay = currentDay.toStartOfMonth();
		Date startDay = Date.newInstance(currentDay.year(), 1, 1);
		Date endDay = startDay.addMonths(12);
		List<ISR_Quota__c> ISRQuotes = [select Id, Name, Actual__c, Employee__c, Manager__c, Month__c, Percent__c, Quota__c, Year__c from ISR_Quota__c where Employee__c in:allSalesUnderCurrentManager and Manager__c = : UserInfo.getUserId() and Month__c >= : startDay and Month__c < :endDay];
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
						currentEmployeeQUotesMap.put(currentMonthDay, new ISR_Quota__c(Employee__c = u.Id, Manager__c = UserInfo.getUserId(), Month__c = currentMonthDay, Year__c = String.valueOf(currentMonthDay.year())));
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
					currentEmployeeQUotesMap.put(currentMonthDay, new ISR_Quota__c(Employee__c = u.Id, Manager__c = UserInfo.getUserId(), Month__c = currentMonthDay, Year__c = String.valueOf(currentMonthDay.year())));
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
				currentMonthQUoteItem.SalesManager = UserInfo.getUserId();
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