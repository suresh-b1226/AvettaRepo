global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Created by: Emmon Chow
    // Created on: 1/12/2019
    // Modified last: 1/18/2019 - EC
    // Description: This class is meant to generate fake Http Responses only so that the API_SER_DatedConversionRate_UpdateTest can pass
    // 		successfully, but is useless to check if the API is correctly working.
    // 
    // (1) Test methods *CANNOT* actually call Salesforce nor https://free.currencyconverterapi.com/, you can create fake http responses
    // 	   which can be found in the MockHttpResponseGenerator. However, these are useless as they don't truly simulate the data that can be edited/retrieved
    // 	   
    // 	   (1a) Therefore, run these methods by using the CTRL + E or Debug > Open Execute Anonymous Window. You can run all of them by running 
    // 	   API_SER_DatedConversionRate_RetrieveJSON.getALLJSON(); or run each of them individually.
    
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        // System.assertEquals('https://free.currencyconverterapi.com/api/v6/convert?q=USD_AUD&compact=ultra', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"USD_AUD":1.39025}');
        res.setStatusCode(200);
        return res;

    }
    


}