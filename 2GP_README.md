# PLP 2GP Demo
This document contains sample code and step-by-step instructions for test driving the Partner Licensing Platform (PLP) using **second-generation packaging (2GP)**.

### Prerequisites:
This document assumes that you've completed the ["Getting Started" instructions](README.md) in the main README file of this repository. If you haven't, please do so before continuing here.


### CLI Commands:
Unless otherwise noted, the commands shared in this guide can be copy/pasted directly into your terminal/CLI program and executed without modification.


# PART ONE: Initial Setup
In the first part of this demo, you'll build a simple second-generation managed package using the provided sample code. 

You'll need approximately 10 minutes to complete this part.

## Create a new second-generation managed package.
```
sfdx force:package:create -n "PLP Demo" -r force-app -t Managed
```

## Create and promote version `1.0` of your package.
* Execute each command individually.
* After executing the first command, the alias `"PLP Demo@1.0.0-1"` should appear in the `packageAliases` section of `sfdx-project.json`.  Ensure this is the case **before** executing the second command.
* When asked if you're sure you want to release this package, type `y` and hit `ENTER`.
```
# Create a package version.
sfdx force:package:version:create -p "PLP Demo" -f config/developer-scratch-def.json -x -c -w 15 --skipancestorcheck

# Promote the package version you just created.
sfdx force:package:version:promote -p "PLP Demo@1.0.0-1"
```

## Create a subscriber scratch org.
* Note the use of the `-n` (`nonamespace`) and `-c` (`noancestors`) flags.
* These flags allow this scratch org to accurately simulate a subscriber org
```
sfdx force:org:create -n -c -a PLP-admin-user -f config/subscriber-scratch-def.json
```

## Install your package in the subscriber scratch org.
```
sfdx force:package:install -r -p "PLP Demo@1.0.0-1" -w 10 -u PLP-admin-user
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

## Create a package development scratch org and push your source.
* Execute each command individually.
* The first command must complete successfully before executing the second command.
* Note that the use of `--noancestors` with `force:org:create` is due to a Salesforce CLI bug. This flag can be removed once the bug is fixed.
```
# Create a scratch org
sfdx force:org:create -a PLP-developer -f config/developer-scratch-def.json --noancestors

# Push your source
sfdx force:source:push -u PLP-developer
```

## Open the package developer scratch org.
```
sfdx force:org:open -u PLP-developer
```

## Create a new Custom Permission Set License definition.
1. In your `PLP-developer` org, open Setup.
2. Type `custom perm` in the Quick Find box, then click on `Custom Permission Set License Definitions`.
3. In the **Custom Permission Set License Definitions** setup page, click the `New` button.
4. Type `All_Access` in the **Label** field and hit the **TAB** key.  This will automatically set the **Name** field to `All_Access` as well.
5. Click the `Save` button.

## Add Licensed Custom Permissions to your new Custom PSL.
1. You should already be on the **Custom Permission Set License Definition Detail** page for the `All_Access` Custom PSL.
2. Find the **Licensed Custom Permissions** related list at the bottom of the page and click the `Add Licensed Custom Permission` button.
3. Move both `Feature A` and `Feature B` from the list of **Available Licensed Custom Permissions** to the list of **Included Licensed Custom Permissions**.
4. Click the `Save` button.

## Pull the updated source into your project.
```
sfdx force:source:pull -u PLP-developer
```

## Update the `versionName`, `versionNumber`, and `ancestorVersion` values in `sfdx-project.json`.
1. Open the `sfdx-project.json` file in the `plp-demo-app` directory using a text/source editor (e.g. VS Code).
2. Go to **LINE 6** and set the `versionName` value to `ver 2.0`.
3. Go to **LINE 7** and set the `versionNumber` value to `2.0.0.NEXT`.
4. Go to **LINE 8** and set the `ancestorVersion` value to `1.0.0`.
3. Save `sfdx-project.json`.

## Create and promote version `2.0` of your package.
* Execute each command individually.
* After executing the first command, the alias `"PLP Demo@2.0.0-1"` should appear in the `packageAliases` section of `sfdx-project.json`.  Ensure this is the case **before** executing the second command.
* When asked if you're sure you want to release this package, type `y` and hit `ENTER`.
```
# Create a new package version.
sfdx force:package:version:create -p "PLP Demo" -f config/developer-scratch-def.json -x -c -w 15 

# Promote the package version you just created.
sfdx force:package:version:promote -p "PLP Demo@2.0.0-1"
```

## Upgrade the package in your subscriber scratch org to `ver 2.0`.
```
sfdx force:package:install -r -p "PLP Demo@2.0.0-1" -w 10 -u PLP-admin-user
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