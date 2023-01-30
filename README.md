# Marketing Cloud Email Preview

This app solves the preview issue when you have a lot of dynamic content blocks, ampScript etc in an email and you want to view the actual sent message to the end user.

![Preview of component](/.assets/noContent.png)

_This requires Marketing Cloud Connect._

## Deploy

You can use the quick installer here to deploy the code directly to your org. \
[![Deploy to salesforce](https://githubsfdeploy.herokuapp.com/resources/img/deploy.png)](https://githubsfdeploy.herokuapp.com/?owner=ehsky&repo=Marketing-Cloud-Email-Preview)

## Setup

### Create Package In Marketing Cloud

- Ensure you're in the **_Business Unit_** that you'd like the component to display emails from.
- Inside Marketing Cloud, open **_Setup_**, expand Appsa and choose **_Installed Packages_**. Then click on **_New_**
- Give the package a name, such as **_SFMC Email Preview_**, then click **_Save_**
- Click on **_Add Component_**m select **_API Integration_**, and click on **_Next_**, then choose **_Web App_**, click **_Next_**, and finally in the permissions panel, you must cik the following options:
  - Offline Access
  - Email: Read
- At the top, set the **_URI_** field to any URL you can think of - we'll change it later. E.g. google.com, and then click **_Save_**
- Click on the tab **_Access_**, then **_License All Users_** or pick a specific integration user. If you pick a specific user this would be used in a later step.

### Configure Auth Provider

- From Setup, in the Quick Find box, enter Auth, and then select **_Auth. Providers_**.
- Click New.
- For the provider type, select OpenID Connect.
  - Provider name: **_SFMC Email Preview_**
  - URL suffix: **_SFMC_Email_Preview_**
  - Consumer Key: **_Paste the Client Id from the Marketing Cloud Package we just created._**
  - Consumer Secret: **_Paste the Client Secret from the Marketing Cloud Package we just created._**
  - Authorize Endpoint URL: **_Paste the Authentication Base URI from the Marketing Cloud package we just created, and add v2/authorize at the end_** (e.g. https://xxxxxxxxxx.auth.marketingcloudapis.com/v2/authorize)
  - Token Endpoint URL: **_Paste the Authentication Base URI from the Marketing Cloud package we just created, and add v2/token at the end_** (e.g. https://xxxxxxxxxx.auth.marketingcloudapis.com/v2/token)
- Then click **_Save_**.
- Now, at the bottom of there page you'll find a **_Callback URL_**, copy it.
- Go back into the **_Marketing Cloud Package_** configuration page, click on **_Edit_** inside the API integration box, and replace the dummy URI you had entered at the top (google.com) with the one you just copied. Click **_Save_**.

![Auth. Provider Setup Example](/.assets/authProviderSetup.png)

### Configure External Credential

Start by creating a new permission set or find an existing where you want to grant access to this api.

- From Setup, in the Quick Find box, enter Credential, and then select **_Named Credential_**.
- ***https://xxxxxxxxxx.rest.marketingcloudapis.com***

![Auth. Provider Setup Example](/.assets/externalCredential.png)

#### Authenticate External Credential

We are now going to use the newly created or chosen permission set.

- In the section **_Permission Set Mappings_**, click on **\*New**.
- Find the permission set of your choosing.
- Pick one of the following Identity Types:
  - Per User Principal: If you requiere that only users of this component need to have a user in marketing cloud.
  - Named Credential: All users of the component are pre-authenticated as on the Salesforce org-level.
- Click **_Save_**

_If your unsure of the Identity Type, then pick ***Named Credential***_

- If you chose **_Named Credential_** then click on the arrow under the _Actions_ column.
- Then click **_Authorize_**.
- Continue logging in to marketing with your user, or use an integration user mentioned in the package setup section previously.
- Confirm that the _Authentication Status_ is **_Configured_**

![Auth. Provider Setup Example](/.assets/authenticate.png)

### Configure Named Credential

Continuing from the previews step.

- Click on the Named Credential tab.
- Then click on **_New_**, and complete the form with the following options:
- Label: **_SFMC Email Preview_**
- Name: **_SFMC_Email_Preview_**
- URL: ***https://xxxxxxxxxx.rest.marketingcloudapis.com***
- External Credential: **_Your recently created External Credential with same name_**
- Click **_save_**

![Auth. Provider Setup Example](/.assets/namedCredential.png)

### Add Lightning Web Component to Record Pages

The final step is to add the component "Marketing Cloud Email Preview" to the record page layout of the IndividualEmailResult object.
In the component properties you input the Developer name of the **Named Credential**, in this guide it is **_SFMC_Email_Preview_**
