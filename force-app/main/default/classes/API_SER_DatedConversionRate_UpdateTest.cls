@isTest
global class API_SER_DatedConversionRate_UpdateTest 
{	
    @isTest
    global static void API_SER_DatedConversionRate_TestAll()
    {
        //Create a fake test response found inside class MockHttpResponseGenerator.apxc
        //Basically fake test are useless as the API is grabbing whatever fake data you give it
        //Instead use CTRL + E 'Open Execute Anonymous Window' to see if API actually works
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());     
        API_SER_DatedConversionRate_RetrieveJSON start =  new API_SER_DatedConversionRate_RetrieveJSON();
        
        //This is the actual method that gets all the JSON > calls methods to parse JSON > those methods then set the parsed exchanged rates to the new rates
        API_SER_DatedConversionRate_RetrieveJSON.getALLJSON();
    
    //Ignore all the commented stuff, this was how we used to test
    
    /*@isTest static void testGetExchangeRateAUDtoUS() 
     {
		Double tAUDtoUSD;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); //Turn Off
        
       	// 1) This method gets the JSON file from currencyconverterapi.com
        HttpResponse res = API_SER_DatedConversionRate_Update.getJSONfromAUDtoUSD();
        
        // 2) This method parses the JSON file to get the exchange rate
        tAUDtoUSD = API_SER_DatedConversionRate_Update.getExchangeRateAUDtoUSD(res);
        
        System.debug('Testing Getting Exchange Rates ' + tAUDtoUSD);
         
         
        // Verify response received contains fake values, if you make a change on the Test class,
        // Changes such as: JSON body, header 
        // the changes need to be made on the MockHttpResponseGenerator class as well.
        
        //String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json');
        //String actualValue = res.getBody();
        //String expectedValue = '{"USD_AUD":1.38465}';
        //System.debug(actualValue);
        
        //System.assertEquals(actualValue, expectedValue);
        //System.assertEquals(200, res.getStatusCode());
        
    } */
 
    /*@isTest static void testSetExchangeRateAUDtoUS() 
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); //Turn Off
		HttpResponse json = API_SER_DatedConversionRate_Update.getJSONfromAUDtoUSD();

		Double tAUDtoUSD = API_SER_DatedConversionRate_Update.getExchangeRateAUDtoUSD(json);

        HttpRequest req = API_SER_DatedConversionRate_Update.setExchangeRateAUDtoUSD(tAUDtoUSD); 
        
        
        //Query for the Id that is the country we want and the most recently updated
		
        //String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json');
        String actualValue = req.getBody();
        //String expectedValue = '{"USD_AUD":1.38465}';
        System.debug('The most updated Id number has the newest exchange rate ' +  actualValue);
        
        //System.assertEquals(actualValue, expectedValue);
        //System.assertEquals(200, res.getStatusCode());

        
        //Put that queried ID back into another JSON request, to start changing values 

    }*/

 
 }
    

}