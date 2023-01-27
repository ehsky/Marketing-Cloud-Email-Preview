/**
 * @description       : Controller for the LWC component mcEmailPreview.
 *                      Controller is used to make a API request to the Marketing Cloud API.
 * @author            : erlend.hansen@stretch.no | https://trailblazer.me/id/ehansen7
 * @group             : MarketingCloud
 * @last modified on  : 01-26-2023
 * @last modified by  : erlend.hansen@stretch.no | https://trailblazer.me/id/ehansen7
 **/
public with sharing class MCEmailPreview {
  public class MCEmailPreviewException extends Exception {
  }

  /**
   * Get email preview HTML from Marketing Cloud
   * @param emailId
   * @param namedCredentialName
   * @return                    `String`
   */
  @AuraEnabled
  public static String getEmailPreviewHTML(
    String emailId,
    String namedCredentialName
  ) {
    try {
      String path = '/guide/v1/emails/' + emailId + '/preview?kind=html';
      String resBody = doPost(path, namedCredentialName);
      System.debug('resBody: ' + resBody);
      MCEmailPreviewWrapper emailPreviewResponse = MCEmailPreviewWrapper.parse(
        resBody
      );

      return emailPreviewResponse.message.views[0].content;
    } catch (System.Exception e) {
      System.debug(e);
      throw new MCEmailPreviewException(
        'Unable to get email preview. ' + e.getMessage()
      );
    }
  }

  /**
   * Generic method for making a POST request
   * @param path
   * @param credentialName
   * @return               `string`
   * @exception            AuraHandledException when the response status code is not 200
   */
  private static string doPost(String path, String credentialName) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:' + credentialName + path);
    req.setMethod('POST');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    if (res.getStatusCode() != 200) {
      throw new MCEmailPreviewException(
        'Response body: ' + res.getBody() + '.'
      );
    }
    return res.getBody();
  }

  /**
   * Wrapper class for the JSON response from the Marketing Cloud API for email preview.
   */
  public class MCEmailPreviewWrapper {
    public Message message;
  }

  public class Views {
    public String contentType;
    public String content;
  }

  public class Message {
    public Links links;
    public List<Views> views;
  }

  public class Links {
    public Self self;
  }

  public class Self {
    public String href;
  }

  public static MCEmailPreviewWrapper parse(String json) {
    return (MCEmailPreviewWrapper) System.JSON.deserialize(
      json,
      MCEmailPreviewWrapper.class
    );
  }
}
