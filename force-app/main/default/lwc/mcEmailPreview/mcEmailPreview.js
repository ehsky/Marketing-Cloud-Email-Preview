import { LightningElement, wire, api } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import EMAIL_ID from "@salesforce/schema/et4ae5__IndividualEmailResult__c.et4ae5__Email_ID__c";
import getEmailPreview from "@salesforce/apex/MCEmailPreview.getEmailPreviewHTML";

/**
 * This component is used to display the email preview from marketing cloud.
 * It uses the emailId to fetch the email preview from marketing cloud api.
 */
export default class McEmailPreview extends LightningElement {
  _recordId;
  @api namedCredentialName;
  friendlyMessage;
  error;

  @api
  get recordId() {
    return this._recordId;
  }
  // Validate that the recordId is of object type IndividualEmailResult
  set recordId(value) {
    if (value.substring(0, 3) === "a2h") {
      this.error = undefined;
      this._recordId = value;
    } else {
      this._recordId = undefined;
      this.error = true;
      this.friendlyMessage = "This is not a valid email record";
    }
  }

  @wire(getRecord, { recordId: "$_recordId", fields: [EMAIL_ID] })
  wiredEmailResult({ error, data }) {
    if (error) {
      this.error = error;
    } else if (data) {
      this.error = undefined;
      const emailId = getFieldValue(data, EMAIL_ID);
      this.getEmailContent(emailId);
    }
  }

  /**
   * Get the HTML content of the email
   * @param {string} emailId
   * @returns
   */
  async getEmailContent(emailId) {
    if (!emailId) {
      // if emailId is null or undefined
      this.error = true;
      this.friendlyMessage = "This record has no Email ID";
      return;
    }
    getEmailPreview({
      emailId: emailId,
      namedCredentialName: this.namedCredentialName
    })
      .then((result) => {
        this.template.querySelector(".emailPreview").innerHTML = result;
      })
      .catch((error) => {
        this.error = error;
      });
  }
}
