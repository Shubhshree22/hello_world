public class OpenPDFController {
    @auraEnabled
    public static void savePDF(String recId){
        system.debug('id' +recId);
        PageReference pdfPage = new PageReference('/apex/OpenAsPDF');
        system.debug('page' +pdfPage);
        pdfPage.getParameters().put('Id', recId);
        Blob pdfContent = pdfPage.getContent();
        
        Attachment attach1= new Attachment();
        attach1.ParentId = recId;
        attach1.Name = 'Test Attachment for PDF';
        attach1.Body = pdfContent;
        attach1.contentType = 'application/pdf';
        insert attach1;
    }
}