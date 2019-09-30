public class  OpportunityStage {
    
    public static void opportunityStageName(List<Opportunity> newOppList, Map<Id,Opportunity> oldOppMap) {
        List<String> newListToHold = new List <String>();
        
        newListToHold.add('Prospecting');
        newListToHold.add('Qualification');
        newListToHold.add('Processing');
        newListToHold.add('Shipped To Customer');
        newListToHold.add('Return To HQ');
        newListToHold.add('Return To Customer');
        newListToHold.add('Closed Won');
        
        for(Opportunity opp : newOppList) {
            if(opp.StageName != NULL && (oldOppMap == null || opp.StageName != oldOppMap.get(opp.Id).StageName))  {
                
                if(oldOppMap == null ) {
                    if(newListToHold[0] != opp.StageName) {
                        opp.addError('You cannot change Opportunity stage to this Stage Name');
                    }
                }
                
                else if (oldOppMap != null && (opp.StageName != oldOppMap.get(opp.Id).StageName)) {
                    Integer oldvalue;
                    Integer newValue;
                    if(opp.StageName != null || oldOppMap.get(opp.Id).StageName == null) 
                        newValue = newListToHold.indexof(opp.StageName) ; 
                    
                    if(oldOppMap.get(opp.Id).StageName != null ) 
                        oldvalue = newListToHold.indexof(oldOppMap.get(opp.Id).StageName) ;
                    
                    if(newValue - oldvalue > 0 && newValue != oldvalue +1) {
                        opp.addError('You cannot change Opportunity stage to this Stage Name');
                    }    
                }
            }
        }
    } 
}