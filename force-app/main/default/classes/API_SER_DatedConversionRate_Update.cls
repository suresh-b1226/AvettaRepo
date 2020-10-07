public class API_SER_DatedConversionRate_Update {
    // Created by: Emmon Chow
    // Created on: 1/12/2019
    // Modified last: 1/18/2019 - EC
    // Description: This class is meant to parse and update DatedExchangeRates.
    //		There are two methods per country that are used to update DatedExchangeRates. getExchangeRateAUDtoUSD() and setExchangeRateAUDtoUSD(). 
    //		12 country's exchange rates are updated via API calls to an external exchange rate website. 
    //
    // High-level Overview:
    // (1) getExchangeRateXXXtoUSD(HttpResponse JSON) takes in the JSON passed in from API_SER_DatedConversionRate_RetrieveJSON
    //     and parses the second token off the JSON file which contains the Double Exchange Rate: Double XXXtoUSD. 
    //     The JSON string from API_SER_DatedConversionRate_RetrieveJSON is retrieved through an API call to https://free.currencyconverterapi.com/.
    // (2) getExchangeRateXXXtoUSD() passes through the Double Exchange Rate: Double XXXtoUSD to the method setExchangeRateXXXtoUSD(double XXXtoUSD)
    // (3) setExchangeRateXXXtoUSD() has to make another API call to Salesforce to update the respective country's exchange rate. It MUST use an API call because 
    //     Exchange Rate instead of DatedExchangeRate object *CANNOT* be modified using a DML.
    // (4) setExchangeRateXXXtoUSD() queries for the Id of the most recently changed exchanged rate for the respective country and updates the parsed Double Exchange Rate.
    // (5) Last modified date in DatedExchangeRates are automatically changed by Salesforce.
    // 
    // Note: 
    // (1) Because of the two types of methods in this class, Historical Exchange Rates are not maintained.
    // (2) All methods are carbon copies of each other, other than the country they refer to. Refer to Australian dollar for code comments
    // (3) Test methods *CANNOT* actually call Salesforce nor https://free.currencyconverterapi.com/, you can create fake http responses
    // 	   which can be found in the MockHttpResponseGenerator. However, these are useless as they don't truly simulate the data that can be edited/retrieved
    // 	   
    // 	   (3a) Therefore, run these methods by using the CTRL + E or Debug > Open Execute Anonymous Window. You can run all of them by running 
    // 	   API_SER_DatedConversionRate_RetrieveJSON.getALLJSON(); or run each of them individually.
    // (4) These methods are run once a day.

    
    
    //----------Australian Dollar----------Australian Dollar----------Australian Dollar----------Australian Dollar
 						 
    public static Boolean getExchangeRateAUDtoUSD(HttpResponse res) 
    { 
        //Description: This method parses through the JSON file that is passed into it. It takes the second token's value
        //	and passes it through to be updated.

        Integer iParseCounter = 0;
        Double AUDtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        Boolean isError = False;
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) {
            if (iParseCounter == 2) {
                try {
                    AUDtoUSD = Double.valueOf(parser.getText());
                    bEndEarly = True;                    
                } catch (Exception ex) {
                    System.debug('The exchange rate value in the JSON file is not of a numberic type');
                    System.debug('Check the API  link for connection issues: https://free.currencyconverterapi.com/api/v6/convert?q=USD_AUD&compact=ultra&apiKey=61b5b3e0cad963a33d5c');
                    isError = True;
                } 
                
                //If conversion rate is at a ridiculously high number or website returns 401 or 400 error
                if (AUDtoUSD > 5) {                      
                    
                    System.debug('Website Errored Out the exchange rate is: ' + AUDtoUSD);
                    isError = True;
                    break;
                } else {
                    //Pass through the Exchange Rate token so that it can be set and updated
                    API_SER_DatedConversionRate_Update.setExchangeRateAUDtoUSD(AUDtoUSD);  
                    break;
                }	
            }
            iParseCounter ++;
        }
        
        return isError;
    }

    public static HttpRequest setExchangeRateAUDtoUSD(double tAUDtoUSD)
    {
        //Description: This method finds the most recently changed Australian dollar's Id, feeds it into the API's URL
        //	and uses the Double Exchange Rate that was passed into it to update the Exchange Rate.
       
		//Create a query and find the Id of the most recently changed Australian dollar. 
		//This will Id is later used to access it through an API
		
        
        DatedConversionRate dcr = //Advanced Currency Management - 'Dated Exchange Rates' - Dated Exchange Rates are used in opportunities, opportunity products, and opportunity reports.
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'AUD' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];


        System.debug('The most recent ID for AUD is: ' + dcr.Id);
        System.debug('Setting exchange Rate output ' + tAUDtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest req = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        req.setBody('{ "ConversionRate" :' + tAUDtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'AUD'
                LIMIT 1
            ];

		System.debug('The most recent ID for AUD is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tAUDtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tAUDtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
        
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
				http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrecnyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    
    
    
    //----------Brazilian Real----------Brazilian Real----------Brazilian Real----------Brazilian Real
    
    public static void getExchangeRateBRLtoUSD(HttpResponse res) //Brazilian Real
    {   

        Integer iParseCounter = 0;
        Double BRLtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    BRLtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + BRLtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateBRLtoUSD(BRLtoUSD);
    }

    public static HttpRequest setExchangeRateBRLtoUSD(double tBRLtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'BRL' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for BRL is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tBRLtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tBRLtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'BRL'
                LIMIT 1
            ];

		System.debug('The most recent ID for AUD is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tBRLtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tBRLtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
        
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrecnyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    
    
    
    //----------Canadian Dollar----------Canadian Dollar----------Canadian Dollar----------Canadian Dollar   
    
    public static void getExchangeRateCADtoUSD(HttpResponse res) //Canadian Dollar
    {   

        Integer iParseCounter = 0;
        Double CADtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    CADtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + CADtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateCADtoUSD(CADtoUSD);

    }

    public static HttpRequest setExchangeRateCADtoUSD(double tCADtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'CAD' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for CAD is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tCADtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tCADtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'CAD'
                LIMIT 1
            ];

		System.debug('The most recent ID for CAD is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tCADtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tCADtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
        
        
        Http http = new Http();
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrecnyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    
    

    
    //----------Swiss Franc----------Swiss Franc----------Swiss Franc---------Swiss Franc   
    
    public static void getExchangeRateCHFtoUSD(HttpResponse res) //Swiss Franc
    {   

        Integer iParseCounter = 0;
        Double CHFtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    CHFtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + CHFtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateCHFtoUSD(CHFtoUSD);

    }

    public static HttpRequest setExchangeRateCHFtoUSD(double tCHFtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'CHF' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for CHF is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tCHFtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tCHFtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
        
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'CHF'
                LIMIT 1
            ];

		System.debug('The most recent ID for CHF is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tCHFtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tCHFtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
           
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrecnyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
        

    
    //----------Chinese Yuan----------Chinese Yuan----------Chinese Yuan---------Chinese Yuan 


    public static void getExchangeRateCNYtoUSD(HttpResponse res) //Chinese Yuan
    {   

        Integer iParseCounter = 0;
        Double CNYtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    CNYtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + CNYtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateCNYtoUSD(CNYtoUSD);

    }

    public static HttpRequest setExchangeRateCNYtoUSD(double tCNYtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'CNY' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for CNY is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tCNYtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tCNYtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'CNY'
                LIMIT 1
            ];

		System.debug('The most recent ID for CNY is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tCNYtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tCNYtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');

        
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrecnyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
        
    
    
    //----------Danish Krone----------Danish Krone----------Danish Krone---------Danish Krone

    public static void getExchangeRateDKKtoUSD(HttpResponse res) //Danish Krone
    {   

        Integer iParseCounter = 0;
        Double DKKtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    DKKtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + DKKtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateDKKtoUSD(DKKtoUSD);

    }

    public static HttpRequest setExchangeRateDKKtoUSD(double tDKKtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'DKK' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for DKK is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tDKKtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tDKKtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'DKK'
                LIMIT 1
            ];

		System.debug('The most recent ID for DKK is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tDKKtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tDKKtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
        
        
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurreDKKConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    


    //----------Euro----------Euro----------Euro---------Euro
    
    public static void getExchangeRateEURtoUSD(HttpResponse res) //Euro
    {   

        Integer iParseCounter = 0;
        Double EURtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    EURtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + EURtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateEURtoUSD(EURtoUSD);

    }

    public static HttpRequest setExchangeRateEURtoUSD(double tEURtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'EUR' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for EUR is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tEURtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tEURtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'EUR'
                LIMIT 1
            ];

		System.debug('The most recent ID for EUR is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tEURtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tEURtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
        
                
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurreEURConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    


    //----------British Pound----------British Pound----------British Pound---------British Pound

    public static void getExchangeRateGBPtoUSD(HttpResponse res) //British Pound	
    {   

        Integer iParseCounter = 0;
        Double GBPtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    GBPtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + GBPtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateGBPtoUSD(GBPtoUSD);

    }

    public static HttpRequest setExchangeRateGBPtoUSD(double tGBPtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'GBP' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for GBP is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tGBPtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseURL().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseURL().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tGBPtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'GBP'
                LIMIT 1
            ];

		System.debug('The most recent ID for GBP is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tGBPtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tGBPtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
                
        
              
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrencyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    

    
    //----------Indian Rupee----------Indian Rupee----------Indian Rupee---------Indian Rupee

    public static void getExchangeRateINRtoUSD(HttpResponse res) //Indian Rupee	
    {   

        Integer iParseCounter = 0;
        Double INRtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    INRtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + INRtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateINRtoUSD(INRtoUSD);

    }

    public static HttpRequest setExchangeRateINRtoUSD(double tINRtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'INR' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for INR is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tINRtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tINRtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'INR'
                LIMIT 1
            ];

		System.debug('The most recent ID for INR is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tINRtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tINRtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');

        
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurreINRConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
   
    

    //----------Norwegian Krone----------Norwegian Krone----------Norwegian Krone---------Norwegian Krone

    public static void getExchangeRateNOKtoUSD(HttpResponse res) //Norwegian Krone	
    {   

        Integer iParseCounter = 0;
        Double NOKtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    NOKtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + NOKtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateNOKtoUSD(NOKtoUSD);

    }

    public static HttpRequest setExchangeRateNOKtoUSD(double tNOKtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'NOK' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for NOK is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tNOKtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseURL().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseURL().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tNOKtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'NOK'
                LIMIT 1
            ];

		System.debug('The most recent ID for NOK is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tNOKtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tNOKtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');    

        
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrencyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    

    
    //----------New Zealand Dollar----------New Zealand Dollar----------New Zealand Dollar---------New Zealand Dollar
    
    public static void getExchangeRateNZDtoUSD(HttpResponse res) //New Zealand Dollar	
    {   

        Integer iParseCounter = 0;
        Double NZDtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    NZDtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + NZDtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateNZDtoUSD(NZDtoUSD);

    }

    public static HttpRequest setExchangeRateNZDtoUSD(double tNZDtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'NZD' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for NZD is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tNZDtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseURL().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseURL().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tNZDtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        

        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'NZD'
                LIMIT 1
            ];

		System.debug('The most recent ID for NZD is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tNZDtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tNZDtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
        
        
             
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrencyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    
    

    //----------Polish Zloty----------Polish Zloty----------Polish Zloty---------Polish Zloty

    public static void getExchangeRatePLNtoUSD(HttpResponse res) //Polish Zloty	
    {   

        Integer iParseCounter = 0;
        Double PLNtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    PLNtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + PLNtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRatePLNtoUSD(PLNtoUSD);

    }

    public static HttpRequest setExchangeRatePLNtoUSD(double tPLNtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'PLN' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for PLN is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tPLNtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseURL().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseURL().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tPLNtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'PLN'
                LIMIT 1
            ];

		System.debug('The most recent ID for PLN is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tPLNtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tPLNtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
              
               
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
            	http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrencyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }


 
    //----------Swedish Krona----------Swedish Krona----------Swedish Krona---------Swedish Krona

    public static void getExchangeRateSEKtoUSD(HttpResponse res) //Swedish Krona	
    {   

        Integer iParseCounter = 0;
        Double SEKtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    SEKtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + SEKtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateSEKtoUSD(SEKtoUSD);

    }

    public static HttpRequest setExchangeRateSEKtoUSD(double tSEKtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'SEK' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for SEK is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tSEKtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseURL().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseURL().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tSEKtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'SEK'
                LIMIT 1
            ];

		System.debug('The most recent ID for SEK is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tSEKtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tSEKtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');
         
               
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrencyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    
    
    
    
    //----------South African Rand----------South African Rand----------South African Rand---------South African Rand
    
    public static void getExchangeRateZARtoUSD(HttpResponse res) //South African Rand
    {   

        Integer iParseCounter = 0;
        Double ZARtoUSD;
        Boolean bEndEarly = False;
        
        //Create a parser object with the JSON object that was passed through
        JSONParser parser = JSON.createParser(res.getBody());
        
        //Parsing logic, loop through 2 .nextToken() to get to the rate
        while (parser.nextToken() != null || bEndEarly == False) 
            {
                if (iParseCounter == 2)
                {
                    ZARtoUSD = Double.valueOf(parser.getText());
                    System.debug('This is the Exchange Rate ' + ZARtoUSD);
					bEndEarly = True;

                }
                iParseCounter ++;
            }
        
        API_SER_DatedConversionRate_Update.setExchangeRateZARtoUSD(ZARtoUSD);

    }

    public static HttpRequest setExchangeRateZARtoUSD(double tZARtoUSD)
    {

        DatedConversionRate dcr = 
            [ 
                SELECT Id
                FROM DatedConversionRate 
                WHERE 
                    IsoCode = :'ZAR' //^^^ Needs to be changed per country
                ORDER BY StartDate DESC
                LIMIT 1
            ];

        System.debug('The most recent ID for ZAR is: ' + dcr.Id);


        System.debug('Setting exchange Rate output ' + tZARtoUSD);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseURL().toExternalForm() 
            + '/services/data/v28.0/sobjects/DatedConversionRate/'
            + dcr.Id
            + '?_HttpMethod=PATCH');
       
		System.debug('THE URL IS ' + URL.getSalesforceBaseURL().toExternalForm() 
                     + '/services/data/v28.0/sobjects/DatedConversionRate/'
                     + dcr.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + dcr.Id + ' and Exchange rate before setting new body ' + req.getBody());
        req.setBody('{ "ConversionRate" :' + tZARtoUSD + ' }');   //req.setBody('{ "ConversionRate" : 2.5 }');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        req.setMethod('POST');
        
        
        
        //Update CURRENCYTYPE Object -------------------------------------------------
                
        CurrencyType cur = //Manage currencies - o manage exchange rates for other objects, to add new currencies, to activate or deactivate currencies, or to change the corporate currency
            [
                SELECT Id, ConversionRate 
                FROM CurrencyType
                WHERE
                	IsoCode = :'ZAR'
                LIMIT 1
            ];

		System.debug('The most recent ID for ZAR is: ' + cur.Id);
        System.debug('Setting exchange Rate output ' + tZARtoUSD);

		//Create an HttpRequest, an API request this is for DATEDCONVERSIONRATE       
        HttpRequest curreq = new HttpRequest();
        
        //Set the URL to the queried exchange rate's Id so that we can access it and make edits to it
        curreq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() 
            + '/services/data/v28.0/sobjects/CurrencyType/'
            + cur.Id
            + '?_HttpMethod=PATCH');
       
				System.debug('THE URL IS ' + URL.getSalesforceBaseUrl().toExternalForm() 
                     + '/services/data/v28.0/sobjects/CurrencyType/'
                     + cur.Id
                     + '?_HttpMethod=PATCH');
		
        System.debug('The ID: ' + cur.Id + ' and Exchange rate before setting new body ' + curreq.getBody());
       	
        //Replace the old conversion rate with the Double Exchange Rate that was passed into this method.
        curreq.setBody('{ "ConversionRate" :' + tZARtoUSD + ' }'); 
        curreq.setHeader('Content-Type', 'application/json');
        curreq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        curreq.setMethod('POST');

        
        
        Http http = new Http();        
        
		try
        {
            if(!Test.isRunningTest()){
                HTTPResponse feedResponse = http.send(req);
                http.send(curreq);
            }
        }         
        catch(Exception ex)
        {
            System.debug('exception in BatchCurrencyConversionUpdate.execute method '+ ex.getMessage());
        }
        
        System.debug('Is the ID new? ' + dcr.Id + ' and new exchange rates are the following ' + req.getBody());
        System.debug('The request method is: ' + req.getMethod());
        
        return req;
    }
    



    
    
}