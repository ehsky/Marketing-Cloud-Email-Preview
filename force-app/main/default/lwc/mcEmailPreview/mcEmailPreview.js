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
  _objectApiName;
  tempRecordId;

  @api namedCredentialName;
  friendlyMessage;
  error;

  @api
  get objectApiName() {
    return this._objectApiName;
  }
  set objectApiName(value) {
    this._objectApiName = value;
    this.validateRecordIdAndObjectName();
  }

  @api
  get recordId() {
    return this._recordId;
  }
  // Validate that the recordId is of object type IndividualEmailResult
  set recordId(value) {
    this.tempRecordId = value;
    this.validateRecordIdAndObjectName();
  }
  validateRecordIdAndObjectName() {
    if (this._objectApiName && this.tempRecordId) {
      this._recordId = this.tempRecordId;
    } else if (this._objectApiName !== "et4ae5__IndividualEmailResult__c") {
      this.error = true;
      this.friendlyMessage =
        "This component can only be used with IndividualEmailResult";
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
