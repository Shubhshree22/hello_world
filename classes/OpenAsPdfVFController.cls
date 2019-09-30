public class OpenAsPdfVFController {
    public Opportunity opp{get;set;}
    public OpenAsPdfVFController(){
        Id oppId = apexpages.currentpage().getparameters().get('id');
       opp = [select id,Name,StageName,AccountId from opportunity where id=: oppId];
    }
}