public class QB_SupplierDeleteExt
{
    public String campaignId {get;set;}

    public QB_SupplierDeleteExt(ApexPages.StandardSetController controller)
    {

    }

    public void deleteSupplier()
    {
        integer numSuppliersDeleted;
        try
        {
            if(campaignId == null)
                throw new SupplierDeleteException('Campaign Id cannot be blank');

            campaignId = String.escapeSingleQuotes(campaignId);

            if((campaignId.length() == 15 || campaignId.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', campaignId))
            {
                numSuppliersDeleted = QB_SuppliersService.deleteSuppliers(new Set<string>
                {
                        campaignId
                });
            }
            else
            {
                throw new SupplierDeleteException('Campaign Id is not a valid Id');
            }
            ApexPages.Message successMessage =
                    new ApexPages.Message(
                            ApexPages.severity.CONFIRM,
                             'A total of ' +  numSuppliersDeleted + ' Supplier Staging records have successfully been deleted.' 
                    );
            ApexPages.addMessage(successMessage);
        }
        catch(Exception e)
        {
            ApexPages.Message errorMessage =
                    new ApexPages.Message(
                            ApexPages.severity.ERROR,
                            'An error has occured while trying to remove supplier records: ' + e.getMessage()
                    );
            ApexPages.addMessage(errorMessage);
        }
    }

   public class SupplierDeleteException extends Exception
    {
    }
}