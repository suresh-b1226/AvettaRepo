public class QB_SupplierConvertExt {

    public String campaignId {get;set;}
    
    public QB_SupplierConvertExt(ApexPages.StandardSetController controller)
    {

    }

    public void convertSuppliers()
    {

		SIT_Settings__c sitSettings;
        integer batchSize; 
        
        sitSettings = SIT_Settings__c.getInstance('General SIT');
        if(sitSettings != Null)
		{
      		if (sitSettings.Batch_Size__c != null)  
      			batchSize =  sitSettings.Batch_Size__c.intValue();
  		}  
  		
        try
        {
            if(campaignId == null)
                throw new SupplierDeleteException('Campaign Id cannot be blank');

            campaignId = String.escapeSingleQuotes(campaignId);

            if((campaignId.length() == 15 || campaignId.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', campaignId))
            {
                QB_SuppliersService.validateCampaigns(new Set<String>{campaignId});

                System.debug('creating batch stuff'); 
                QB_BacthConvertSuppliers convertBatch = new QB_BacthConvertSuppliers();
                convertBatch.convertCampaignId = campaignId;
				Database.executebatch(convertBatch, batchSize);  
				System.debug('done executing batch stuff');  
            }
            else
            {
                throw new SupplierDeleteException('Campaign Id is not a valid Id');
            }
            ApexPages.Message successMessage =
                    new ApexPages.Message(
                            ApexPages.severity.CONFIRM,
                             'The supplier staging records has been submitted for conversion successfully. Please see Staging Results for more details' 
                    );
            ApexPages.addMessage(successMessage);
        }
        
        catch(QB_SupplierConvertionException e){

                 ApexPages.Message errorMessage =
                    new ApexPages.Message(
                            ApexPages.severity.ERROR,
                            'An error has occured while trying to convert supplier records: ' + e.getMessage() 
                    );
            ApexPages.addMessage(errorMessage);

        }
        catch(Exception e)
        {
            ApexPages.Message errorMessage =
                    new ApexPages.Message(
                            ApexPages.severity.ERROR,
                            'An error has occured while trying to convert supplier records: ' + e.getMessage() 
                    );
            ApexPages.addMessage(errorMessage);
        }
        
    }

    public class SupplierDeleteException extends Exception
    {
    }

}