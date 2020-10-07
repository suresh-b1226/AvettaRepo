public class API_SER_DatedConversionRate_RetrieveJSON 
{
    // Created by: Emmon Chow
    // Created on: 1/12/2019
    // Modified last: 1/18/2019 - EC
    // Description: This class is meant to retrieve JSON files off of https://free.currencyconverterapi.com/ for 12 different country's exchange rate.
    //There are one method for 12 countries and they pass the JSON file to API_SER_DatedConversionRate_Update for parsing and updating.

    @future(callout=true)
    public static void getALLJSON() {
        
        Boolean bStopRunning = False;
        Boolean isError = False;
        
        try {
            
			//Australian Dollar
            HttpRequest ausreq = new HttpRequest();
            
            //Each exchange rate URL is unique. I use ultra compact URL, because it requires less looping through JSON tokens.
            //The URL is different per country
            ausreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_AUD&compact=ultra&apiKey=0130c24b628aaf0233d2');
            
            //'GET' retrieves the JSON file
            ausreq.setMethod('GET');
            Http aush = new Http();
            
            //This is where the API is actually called to retrieve from the web
            HttpResponse ausres = aush.send(ausreq);
            String ausoutput = ausres.getBody();
            System.debug('This is the response from free.currencyconverter.com aus: ' + ausoutput);
            
            //Pass the JSON file over to a method where it can be parsed
            //isError is for when the API connection works, but the JSON file from the source has been altered
            //Checks for 400 and 401 errors, AUD to USD rate can't be > 5
            isError = API_SER_DatedConversionRate_Update.getExchangeRateAUDtoUSD(ausres);
            
            if (isError) API_SER_DatedConversionRate_Creation.scheduleNowBecauseFail();
        } 
        
        catch (exception e) {
            
            System.debug('Job Failed..., re-running again in 30 minutes');
            System.debug('Check https://free.currencyconverterapi.com/api/v6/convert?q=USD_AUD&compact=ultra to see if the website is actually down');
            bStopRunning = True;

            API_SER_DatedConversionRate_Creation.scheduleNowBecauseFail();
        }
        
		if (bStopRunning == false || isError == false) {
            
            //Brazilian Real
            HttpRequest brlreq = new HttpRequest();
            
            //Our exchange rate URL is unique. I use ultra compact, because it requires less looping
            brlreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_BRL&compact=ultra&apiKey=0130c24b628aaf0233d2');
            
            brlreq.setMethod('GET');
            Http brlh = new Http();
            
            HttpResponse brlres = brlh.send(brlreq);
            String brloutput = brlres.getBody();
            System.debug('This is the response from free.currencyconverter.com brl: ' + brloutput);
          
            API_SER_DatedConversionRate_Update.getExchangeRateBRLtoUSD(brlres);
      
            //Canadian Dollar        
            HttpRequest cadreq = new HttpRequest();
            
            cadreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_CAD&compact=ultra&apiKey=0130c24b628aaf0233d2');        
            cadreq.setMethod('GET');
            
            Http cadh = new Http();
            HttpResponse cadres = cadh.send(cadreq);
            
            String cadoutput = cadres.getBody();
            System.debug('This is the response from free.currencyconverter.com cad: ' + cadoutput);
            API_SER_DatedConversionRate_Update.getExchangeRateCADtoUSD(cadres);
            
            //Swiss Franc
            HttpRequest chfreq = new HttpRequest();
            chfreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_CHF&compact=ultra&apiKey=0130c24b628aaf0233d2');        
            chfreq.setMethod('GET');
            
            Http chfh = new Http();
            HttpResponse chfres = chfh.send(chfreq);
            String chfoutput = chfres.getBody();
            
            System.debug('This is the response from free.currencyconverter.com chf: ' + chfoutput);
            API_SER_DatedConversionRate_Update.getExchangeRateCHFtoUSD(chfres);
    
            //Chinese Yuan
            HttpRequest cnyreq = new HttpRequest();
            cnyreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_CNY&compact=ultra&apiKey=0130c24b628aaf0233d2');
            cnyreq.setMethod('GET');
            
            Http cnyh = new Http();
            HttpResponse cnyres = cnyh.send(cnyreq);
            String cnyoutput = cnyres.getBody();
            
            System.debug('This is the response from free.currencyconverter.com cny: ' + cnyoutput);
            API_SER_DatedConversionRate_Update.getExchangeRateCNYtoUSD(cnyres);
    
            //Danish Krone
            HttpRequest dkkreq = new HttpRequest();        
            dkkreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_DKK&compact=ultra&apiKey=0130c24b628aaf0233d2');
            
            dkkreq.setMethod('GET');
            Http dkkh = new Http();
            
            HttpResponse dkkres = dkkh.send(dkkreq);
            String dkkoutput = dkkres.getBody();
            
            System.debug('This is the response from free.currencyconverter.com dkk: ' + dkkoutput);
            API_SER_DatedConversionRate_Update.getExchangeRateDKKtoUSD(dkkres);
    
            //Euro        
            HttpRequest eurreq = new HttpRequest();        
            eurreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_EUR&compact=ultra&apiKey=0130c24b628aaf0233d2');
            
            eurreq.setMethod('GET');
            Http eurh = new Http();
            
            HttpResponse eurres = eurh.send(eurreq);
            String euroutput = eurres.getBody();
            
            System.debug('This is the response from free.currencyconverter.com eur: ' + euroutput);
            API_SER_DatedConversionRate_Update.getExchangeRateEURtoUSD(eurres);
   
            //British Pound                
            HttpRequest gbpreq = new HttpRequest();         
            gbpreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_GBP&compact=ultra&apiKey=0130c24b628aaf0233d2');
            gbpreq.setMethod('GET');
            
            Http gbph = new Http();
            HttpResponse gbpres = gbph.send(gbpreq);
            
            String gbpoutput = gbpres.getBody();
            System.debug('This is the response from free.currencyconverter.com gbp: ' + gbpoutput);
            
            API_SER_DatedConversionRate_Update.getExchangeRateGBPtoUSD(gbpres);
    
            //Indian Rupee                
            HttpRequest inrreq = new HttpRequest();
            inrreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_INR&compact=ultra&apiKey=0130c24b628aaf0233d2');
            inrreq.setMethod('GET');
            
            Http inrh = new Http();
            HttpResponse inrres = inrh.send(inrreq);
            String inroutput = inrres.getBody();
            
            System.debug('This is the response from free.currencyconverter.com inr: ' + inroutput);
            API_SER_DatedConversionRate_Update.getExchangeRateINRtoUSD(inrres);
    
            //Norwegian Krone	                        
            HttpRequest nokreq = new HttpRequest();        
            nokreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_NOK&compact=ultra&apiKey=0130c24b628aaf0233d2');
            nokreq.setMethod('GET');
            
            Http nokh = new Http();
            HttpResponse nokres = nokh.send(nokreq);
            
            String nokoutput = nokres.getBody();
            System.debug('This is the response from free.currencyconverter.com nok: ' + nokoutput);
            API_SER_DatedConversionRate_Update.getExchangeRateNOKtoUSD(nokres);
            
            //New Zealand Dollar	        
            HttpRequest nzdreq = new HttpRequest();
            nzdreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_NZD&compact=ultra&apiKey=0130c24b628aaf0233d2');
            nzdreq.setMethod('GET');
            
            Http nzdh = new Http();
            HttpResponse nzdres = nzdh.send(nzdreq);
            
            String nzdoutput = nzdres.getBody();
            System.debug('This is the response from free.currencyconverter.com nzd: ' + nzdoutput);
            API_SER_DatedConversionRate_Update.getExchangeRateNZDtoUSD(nzdres);
            
            //Polish Zloty	
            HttpRequest plnreq = new HttpRequest();
            plnreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_PLN&compact=ultra&apiKey=0130c24b628aaf0233d2');
            plnreq.setMethod('GET');
            
            Http plnh = new Http();
            HttpResponse plnres = plnh.send(plnreq);
            
            String plnoutput = plnres.getBody();
            System.debug('This is the response from free.currencyconverter.com pln: ' + plnoutput);
            API_SER_DatedConversionRate_Update.getExchangeRatePLNtoUSD(plnres);
            
            //Swedish Krona	
            HttpRequest sekreq = new HttpRequest();
            sekreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_SEK&compact=ultra&apiKey=0130c24b628aaf0233d2');
            sekreq.setMethod('GET');
            
            Http sekh = new Http();
            HttpResponse sekres = sekh.send(sekreq);
            
            String sekoutput = sekres.getBody();
            System.debug('This is the response from free.currencyconverter.com sek: ' + sekoutput);
            API_SER_DatedConversionRate_Update.getExchangeRateSEKtoUSD(sekres);
    
            //South African Rand	
            HttpRequest zarreq = new HttpRequest();
            zarreq.setEndpoint('https://free.currencyconverterapi.com/api/v6/convert?q=USD_ZAR&compact=ultra&apiKey=0130c24b628aaf0233d2');
            zarreq.setMethod('GET');
            
            Http zarh = new Http();
            HttpResponse zarres = zarh.send(zarreq);
            
            String zaroutput = zarres.getBody();
            System.debug('This is the response from free.currencyconverter.com zar: ' + zaroutput);
            
            API_SER_DatedConversionRate_Update.getExchangeRateZARtoUSD(zarres);
			API_SER_DatedConversionRate_Creation.scheduleNowSuccess();  
        }
    } 
}