public class OppStageName {
    
    public static void opportunityStageName(List<Opportunity> newList, Map<Id,Opportunity> oldMap) {
        List<String> newListToHold = new List <String>();
         for(Opportunity opp : newList) {
            if(opp != NULL && opp.StageName != NULL && opp.StageName != oldMap.get(opp.Id).StageName )  {
                
                if(oldMap == NULL && opp.StageName =='Prospecting' ) {
                    if(newListToHold == NULL) {
                        newListToHold.add(opp.StageName);
                    }
                }
                else if( opp.StageName =='Qualification' && oldMap.get(opp.Id).StageName =='Prospecting') {
                    if(newListToHold == NULL) {
                        newListToHold.add(opp.StageName);
                    }
                }
                else if (opp.StageName =='Processing' && oldMap.get(opp.Id).StageName =='Qualification') {
                    if(newListToHold == NULL) {
                        newListToHold.add(opp.StageName);
                    }
                }
                else if(opp.StageName =='Shipped To Customer' && oldMap.get(opp.Id).StageName =='Processing') {
                    if(newListToHold == NULL) {
                        newListToHold.add(opp.StageName);
                    }
                }
                else if(opp.StageName =='Return To HQ' && oldMap.get(opp.Id).StageName =='Shipped To Customer') {
                    if(newListToHold == NULL) {
                        newListToHold.add(opp.StageName);
                    }
                }
                else if(opp.StageName =='Return To Customer' && oldMap.get(opp.Id).StageName =='Return To HQ') {
                    if(newListToHold == NULL) {
                        newListToHold.add(opp.StageName);
                    }
                }else if(opp.StageName =='Closed Won' && oldMap.get(opp.Id).StageName =='Return To Customer') {
                    if(newListToHold == NULL) {
                        newListToHold.add(opp.StageName);
                    }
                }
                else{
                    opp.addError('You cannot change Opportunity stage to this Stage Name');
                }
            } 
        }
    }
}