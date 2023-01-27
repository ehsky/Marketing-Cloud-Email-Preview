/**
 * @description       : Test class for MCEmailPreview
 * @author            : erlend.hansen@stretch.no | https://trailblazer.me/id/ehansen7
 * @group             : Test
 * @last modified on  : 01-26-2023
 * @last modified by  : erlend.hansen@stretch.no | https://trailblazer.me/id/ehansen7
 **/
@isTest
private class MCEmailPreviewTest {
  @isTest
  static void testGetEmailPreviewHTMLSuccess() {
    // Arrange
    String emailId = 'testEmailId';
    String namedCredentialName = 'testCredentialName';
    String mockResponse = '{"message": {"links": {"self": {"href": "/v1/emails/10330/preview"}},"views": [{"contentType": "vnd.exacttarget.message.email.htmlBody","content": "<a href=\\"https://cloud.marketing.customer.com/linkMe\\">Link</a>"}]}}';

    Test.setMock(
      HttpCalloutMock.class,
      new MCEmailPreviewMock(200, mockResponse)
    );

    // Act
    String previewHTML = MCEmailPreview.getEmailPreviewHTML(
      emailId,
      namedCredentialName
    );

    // Assert
    System.assertNotEquals(
      null,
      previewHTML,
      'Preview HTML should not be null'
    );
    System.assertEquals(
      '<a href="https://cloud.marketing.customer.com/linkMe">Link</a>',
      previewHTML
    );
  }

  private class MCEmailPreviewMock implements HttpCalloutMock {
    private Integer statusCode;
    private String responseBody;

    public MCEmailPreviewMock(Integer statusCode, String responseBody) {
      this.statusCode = statusCode;
      this.responseBody = responseBody;
    }

    public HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HttpResponse();
      res.setStatusCode(this.statusCode);
      res.setBody(this.responseBody);
      return res;
    }
  }
}
