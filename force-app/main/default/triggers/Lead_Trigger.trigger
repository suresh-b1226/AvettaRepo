trigger Lead_Trigger on Lead (before Insert, before Update) {
    Client_SDR_Lead_RoundRobin    sdrRoundRobin = new Client_SDR_Lead_RoundRobin();
    
    if(Trigger.isInsert && Trigger.isBefore){
        sdrRoundRobin.Client_SDR_Lead_RoundRobin(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
        sdrRoundRobin.Client_SDR_Lead_RoundRobin(Trigger.new);
    }
}