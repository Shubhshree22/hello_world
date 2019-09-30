public class UrlMaking {
    
    public static void url() {
        String str = 'https://shubshreerathore-dev-ed.my.salesforce.com/home/home.jsp?source=lex&abc=12a&bdg=12b&jhks=13c&jsiks=14d&pko=15d';
        List<String> splitted = str.split('\\?');
        System.debug('split   '+splitted[1]);
        List<String> storingParameters = splitted[1].split('\\&');
        Map<String,String> mapToStoreAllParam = new Map<String,String>();
        for(String parameter : storingParameters) {
            List<String>  firstParam = parameter.split('\\=');
            System.debug('firstParam    '+firstParam);
            mapToStoreAllParam.put(firstParam[0],firstParam[1]);
        }
        System.debug('split    '+mapToStoreAllParam);
    } 
}