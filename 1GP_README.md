# PLP 1GP Demo
This document contains sample code and step-by-step instructions for test driving the Partner Licensing Platform (PLP) using **first-generation packaging (1GP)**.

### Prerequisites:
This document assumes that you've completed the ["Getting Started" instructions](README.md) in the main README file of this repository. If you haven't, please do so before continuing here.

### CLI Commands:
Unless otherwise noted, the commands shared in this guide can be copy/pasted directly into your terminal/CLI program and executed without modification.





# PART ONE: Initial Setup
In the first part of this demo, you'll connect the Salesforce CLI to your packaging org and create a simple first-generation managed package (1GP) using the provided sample code.

You'll need approximately 20 minutes to complete this part.

## Authorize the Salesforce CLI to your PLP-enabled packaging org.
[Authorize](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth.htm) the Salesforce CLI to access a PLP-enabled packaging org using the following command.
* As part of the PLP dev preview onboarding process you were asked to create a Partner Developer Edition (PDE) org and give it a namespace beginning with `plpdp_`.
* This PDE org is the same one you used when linking your `plpdp_` namespace to your PLP-enabled Dev Hub in the ["Getting Started" instructions](README.md).
* For the 1GP version of the PLP Demo App, this PDE org will become your **packaging org**.
* You must authorize the Salesforce CLI on your local machine to access **this specific org**.
```
sfdx force:auth:web:login -a PkgOrg:PLP-Dev-Preview
```

## Use the Salesforce CLI to open your packaging org.
```
sfdx force:org:open -u PkgOrg:PLP-Dev-Preview
```

## Create a managed first-generation package (1GP).
1. Inside of your packaging org, open Setup.
2. Type `pack` in the Quick Find box, then click on the **Package Manager** setup menu item.
    * A **namespace prefix** that starts with `plpdp_` should already be assigned to this org.
    * If this is not the case, then you are either in the wrong org or you have not correctly completed the ["Getting Started" instructions](README.md).
    * If further assistance is required, please reach out to the [Partner Licensing Platform - Dev Preview](https://partners.salesforce.com/_ui/core/chatter/groups/GroupProfilePage?g=0F94V0000010zlV) group in the Partner Community.
3. In the **Packages** related list, click the `New` button.
4. Create a package using **EXACTLY** the following information. 
    * **Package Name:** `PLP Demo`
    * **Language:** `English`
    * **Managed:** `Checked`
5. Click the `Save` button.

## Convert the demo app SFDX source to MDAPI source.
* Make sure that the value provided to the `-n` argument **exactly matches the Package Name** you specified in the previous step.
* This ensures the metadata components that are deployed in the following step will automatically be added to your managed package.
```
sfdx force:source:convert -d mdapi-source -n "PLP Demo"
```

## Deploy the demo app source to your packaging org using the Metadata API.
```
sfdx force:mdapi:deploy -d mdapi-source -l NoTestRun -w 15 -u PkgOrg:PLP-Dev-Preview
```

## Verify that the demo app metadata components were added to your managed package.
1. Inside of your packaging org, open Setup.
2. Type `pack` in the Quick Find box, then click on the **Package Manager** setup menu item.
3. In the **Packages** related list, click the package named `PLP Demo`.
4. In the **Components** tab of the **Package Details** page, verify that a number of metadata components are listed.
    * If you **do not** see any metadata components in your package, one of two things happened
        * The value you specified for the `-n` flag when running `force:source:convert` did not **exactly** match the name of your package.
        * You did not use `force:mdapi:deploy` to deploy to your packaging org.
    * You can attempt to recover by carefully repeating the previous steps, or by manually adding all of the demo app's metadata to your managed package by clicking the `Add` button in the **Package Details** page.

## Upload version `1.0` of your managed package.
1. Make sure you're still on the **Package Details** page.
2. Click the `Upload` button.
3. On the **Upload Package** screen, specify the following values, leaving everythig else as-is:
    * **Version Name:** `ver 1.0`
    * **Version Number:** `1.0`
    * **Release Type:** `Managed - Released`
4. Click the `Upload` button again, then click the `OK` button when asked to confirm that you want to upload a **Managed - Released** package.
5. Wait for the package upload process to complete successfully.

## Create a subscriber scratch org.
* Note the use of the `-n` (`nonamespace`) and `-c` (`noancestors`) flags.
* These flags allow this scratch org to accurately simulate a subscriber org
```
sfdx force:org:create -n -c -a PLP-admin-user -f config/subscriber-scratch-def.json
```

## Get the `04t` ID for version `1.0` of your managed package.
1. Run the command, below.
```
sfdx force:package1:version:list -u PkgOrg:PLP-Dev-Preview
```
2. Your output will look something like this:
```
MetadataPackageVersionId  MetadataPackageId   Name     Version  ReleaseState  BuildNumber
────────────────────────  ──────────────────  ───────  ───────  ────────────  ───────────
04t00000000ZI00AAG        03300000000ZU00AAC  ver 1.0  1.0.0    Released      1
```
3. Make note of the `MetadataPackageVersionId` value for version `1.0.0` of your app so you can use it during the next step.

## Install your package in the subscriber scratch org.
* When executing the following command, make sure to replace `YOUR_PACKAGE_VERSION_ID` with the `04t` Package Version ID you got from `force:package1:version:list` during the previous step.
```
sfdx force:package:install -r -p YOUR_PACKAGE_VERSION_ID -w 10 -u PLP-admin-user
```

## Create a DEMO user in the subscriber scratch org.
```
sfdx force:user:create -a PLP-demo-user -f config/demo-user-def.json -u PLP-admin-user
```





# PART TWO: Experience PLP from the package subscriber's perspective.
In the second part of this demo, you'll interact with the subscriber scratch org using two different users. 
* The DEMO user simulates a standard user within the subscriber's org
* The ADMIN user simulates a system administrator within the subscriber's org.

Approximately 10 minutes are required to complete this part.

## Open the subscriber scratch org as the DEMO user.
```
sfdx force:org:open -u PLP-demo-user
```

## Use the "Feature Access Check Demo" page to see which features the DEMO user can access.
1. In the subscriber demo org, click the App Launcher icon.
    * Some call this the "waffle icon", a 3x3 grid of dots at the top-left of the page, right below the Salesforce logo and directly to the left of the word "Sales".
2. Type `Feature` into the App Launcher's search box, then click on the `Feature Access` item.
3. Click the button that says `Can I access Feature A?`.
    * The response should be **"Nope"**.
4. Click the button that says `Can I access Feature B?`.
    * The response should be **"Nope"**

## Open the subscriber scratch org as the ADMIN user in a second browser.
These instructions will help you open the ADMIN user in a browser that is not your system default. This allows you to simulate both the DEMO and ADMIN user personas at the same time.

* The `-b` flag of the `force:org:open` command allows you to specify which browser the CLI will use when "opening" an org.  The available options are:
    * `chrome`
    * `firefox`
    * `edge`
* Execute the command below, making sure to replace `YOUR_NON_DEFAULT_BROWSER` with one of the three options that **is not your system default**.
    * For example, if your system default browser is Chrome, specify either `firefox` or `edge`, depending on what's available on your local machine. 
```
sfdx force:org:open -u PLP-admin-user -b YOUR_NON_DEFAULT_BROWSER
```
#### OPTIONAL: Switch from one subscriber user to the other using one browser. 
If you do not have access to at least one of the three alternative browsers on your machine, you can follow along with this demo by manually switching the user context using your default browser.
1. Determine the current user context by clicking the user icon at the top-right of the Lightning Experience UI and inspecting the first and last name displayed there.
    * The DEMO user appears as `Demo User (Non-Admin)`.
    * The ADMIN user appears as `User User`.
2. Using the Salesforce UI, log the current user out of your subscriber org.
3. Use the Salesforce CLI to reopen the org using the desired user context.
    * DEMO user context: `sfdx force:org:open -u PLP-demo-user`
    * ADMIN user context: `sfdx force:org:open -u PLP-admin-user`

## Assign the Custom PSL for "Feature A" to the DEMO user.
1. Using the ADMIN user context, open Setup.
2. Type `Users` in the Quick Find box, then click on the **Users** setup menu item.
3. In the list of all users, click the Alias for `DemoUser` to enter the setup page for `Demo User (Non-Admin)`.
4. Scroll down to the **Permission Set License Assignments** related list and click the `Edit Assignments` button.
5. Check the `Enabled` box for `Demo FeatureA`.
    * Do not enable the PSL for `Demo FeatureB` yet.
6. Click the `Save` button.

## Assign the `FeatureA User` Permission Set to the DEMO user.
1. Make sure you're still in the setup page for `Demo User (Non-Admin)`.
2. Scroll down to the **Permission Set Assignments** related list and click the `Edit Assignments` button.
3. Move `FeatureA User` from the list of **available permission sets** over to the list of **enabled permission sets**.
4. Click the `Save` button.

After completing this step, the following language can be used to describe the DEMO user.
* The DEMO user is **entitled** to use "Feature A" because they were assigned the `Demo FeatureA` Permission Set License (PSL).
* The DEMO user has been **granted access** to "Feature A" by the org administrator because they were assigned the `FeatureA User` Permission Set.

The next step will demonstrate what happens when the ADMIN user tries to **grant access** to a feature that the DEMO user is not **entitled** to.

## Attempt to grant access to "Feature B" without the DEMO user being entitled to it.
1. Make sure you're still in the setup page for `Demo User (Non-Admin)`.
2. Scroll down to the **Permission Set Assignments** related list and click the `Edit Assignments` button.
3. Move `FeatureB User` from the list of **available permission sets** over to the list of **enabled permission sets**.
4. Click the `Save` button.
5. Note the error message that appears.

When you attempt to **grant access** using a permission set to a feature that the user is not **entitled** to via application of a Permission Set License (PSL), you get the following error:

```
Can't assign permission set FeatureB User to user Demo User (Non-Admin).
The user license doesn't allow the permission: Custom Permission Feature B 
is not valid for this Permission Set. 
```

## Return to the "Feature Access Check Demo" page as the DEMO user to see which features are now accessible.
1. Using the DEMO user context, click the App Launcher icon.
    * If you are using two browsers, your DEMO user is probably still on this page.
    * If this is the case, reload the page and skip to step 3.
2. Type `Feature` into the App Launcher's search box, then click on the `Feature Access` item.
3. Click the button that says `Can I access Feature A?`.
    * The response should be **"Yes, you can!"**.
4. Click the button that says `Can I access Feature B?`.
    * The response should be **"Nope"**





# PART THREE: Experience PLP from the package developer's perspective.
In the final part of this demo, you'll create and package a new **entitlement** and the means to **grant access** to it.

You'll need approximately 25 minutes to complete this part.

## Use the Salesforce CLI to open your packaging org.
```
sfdx force:org:open -u PkgOrg:PLP-Dev-Preview
```

## Create a new Custom Permission Set License definition.
1. In your packaging org, open Setup.
2. Type `custom perm` in the Quick Find box, then click on `Custom Permission Set License Definitions`.
3. In the **Custom Permission Set License Definitions** setup page, click the `New` button.
4. Type `All_Access` in the **Label** field and hit the **TAB** key.  This will automatically set the **Name** field to `All_Access` as well.
5. Click the `Save` button.

## Add Licensed Custom Permissions to your new Custom PSL.
1. You should already be on the **Custom Permission Set License Definition Detail** page for the `All_Access` Custom PSL.
2. Find the **Licensed Custom Permissions** related list at the bottom of the page and click the `Add Licensed Custom Permission` button.
3. Move both `Feature A` and `Feature B` from the list of **Available Licensed Custom Permissions** to the list of **Included Licensed Custom Permissions**.
4. Click the `Save` button.

## Add the `All_Access` component to your managed package.
1. You should still be in Setup in your packaging org.
2. Type `pack` in the Quick Find box, then click on the **Package Manager** setup menu item.
3. In the **Packages** related list, click the package named `PLP Demo`.
4. On the **Components** tab of the **Package Details** page, click the `Add` button.
5. On the **Add to Package** screen...
    * Set the **Component Type** drop-down to `Custom Permission Set License Definition`.
    * Check the box next to `All_Access`.
    * Click the `Add to Package` button.
6. Verify that the list of components in your package now includes the `All_Access` Custom PSL.

## Upload version `2.0` of your managed package.
1. Make sure you're still on the **Package Details** page.
2. Click the `Upload` button.
3. On the **Upload Package** screen, specify the following values, leaving everythig else as-is:
    * **Version Name:** `ver 2.0`
    * **Version Number:** `2.0`
    * **Release Type:** `Managed - Released`
4. Click the `Upload` button again, then click the `OK` button when asked to confirm that you want to upload a **Managed - Released** package.
5. Wait for the package upload process to complete successfully.

## Get the `04t` ID for version `2.0` of your managed package.
1. Run the command, below.
```
sfdx force:package1:version:list -u PkgOrg:PLP-Dev-Preview
```
2. Your output will look something like this:
```
MetadataPackageVersionId  MetadataPackageId   Name     Version  ReleaseState  BuildNumber
────────────────────────  ──────────────────  ───────  ───────  ────────────  ───────────
04t00000000ZI00AAG        03300000000ZU00AAC  ver 1.0  1.0.0    Released      1
04t00000000ZJ00ZUG        03300000000ZU00AAC  ver 2.0  2.0.0    Released      1
```
3. Make note of the `MetadataPackageVersionId` value for version `2.0.0` of your app so you can use it during the next step.

## Upgrade the package in your subscriber scratch org to `ver 2.0`.
* When executing the following command, make sure to replace `YOUR_PACKAGE_VERSION_ID` with the `04t` Package Version ID for version `2.0.0`.
```
sfdx force:package:install -r -p YOUR_PACKAGE_VERSION_ID -w 10 -u PLP-admin-user
```

## Assign the `All_Access` Custom PSL to the DEMO user.
1. Using the ADMIN user context in your subscriber scratch org, open Setup.
2. Type `Users` in the Quick Find box, then click on the **Users** setup menu item.
3. In the list of all users, click the Alias for `DemoUser` to enter the setup page for `Demo User (Non-Admin)`.
4. Scroll down to the **Permission Set License Assignments** related list and click the `Edit Assignments` button.
5. Check the `Enabled` box for `All_Access`.
6. Click the `Save` button.

## Assign the `FeatureB User` Permission Set to the DEMO user.
1. Make sure you're still in the setup page for `Demo User (Non-Admin)`.
2. Scroll down to the **Permission Set Assignments** related list and click the `Edit Assignments` button.
3. Move `FeatureB User` from the list of **available permission sets** over to the list of **enabled permission sets**.
4. Click the `Save` button.
5. This time, the attempt to assign the`FeatureB User` permset is **successful!**

After completing this step, the following language can be used to describe the DEMO user.
* The DEMO user is **entitled** to use BOTH "Feature A" and "Feature B" because they were assigned the `All_Access` Permission Set License (PSL).
* The DEMO user has now been **granted access** to "Feature B" by the org administrator because they were assigned the `FeatureB User` Permission Set.

## Return to the "Feature Access Check Demo" page as the DEMO user to see which features are now accessible.
1. Using the DEMO user context in your subscriber scratch org, click the App Launcher icon.
2. Type `Feature` into the App Launcher's search box, then click on the `Feature Access` item.
3. Click the button that says `Can I access Feature A?`
    * The response should be **"Yes, you can!"**
4. Click the button that says `Can I access Feature B?`
    * The response should be **"Yes, you can!"**

# Congratulations! You've completed the PLP Demo!
This demo gave you the chance to get a hands-on understanding of the fundamental building blocks of the Partner Licensing Platform.

In this demo, you learned that...
* Custom Permission Set Licenses **entitle** a subscriber's user to one or more features.
* Subscriber admins **grant access** to those features by assigning **Permission Sets** that include one or more **Licensed Custom Permissions**.
* Attempting to assign such Permission Sets results in an error when the target user does not have the **entitlement** that comes with the assignment of a **Custom Permission Set License**.

To learn more, please see [Partner Licensing Platform Components and Concepts](https://developer.salesforce.com/docs/atlas.en-us.packagingGuide.meta/packagingGuide/partner_licensing_platform_concepts.htm) in the ISVforce guide.

Have questions or comments about this demo? Please visit the [Partner Licensing Platform - Dev Preview](https://partners.salesforce.com/_ui/core/chatter/groups/GroupProfilePage?g=0F94V0000010zlV) group in the Partner Community.

Have general questions or comments about PLP? Please visit the main [Partner Licensing Platform](https://partners.salesforce.com/_ui/core/chatter/groups/GroupProfilePage?g=0F94V0000009l4D) group in the Partner Community.