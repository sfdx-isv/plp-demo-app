# PLP 2GP Demo
This document contains sample code and step-by-step instructions for test driving the Partner Licensing Platform (PLP) using **second-generation packaging (2GP)**.

**Prerequisites:** This document assumes that you've completed the ["Getting Started" instructions](README.md) in the main README file of this repository. If you haven't, please do so before continuing here.


**CLI Commands:** Unless otherwise noted, the commands shared in this guide can be copy/pasted directly into your terminal/CLI program and executed without modification.


# PART ONE: Initial Setup
In the first part of this demo, you'll build a simple second-generation managed package using the provided sample code. 

You'll need approximately 10 minutes to complete this part.



## Create a new second-generation managed package.
```
sfdx force:package:create -n "PLP Demo" -r force-app -t Managed
```

## Update `versionName` and `versionNumber` in `sfdx-project.json`.
1. Wait for the command from the previous step to complete.
2. Open `sfdx-project.json` using a text/source editor (e.g. VS Code).
3. Go to **LINE 7** and specify `ver 1.0` as the value for `versionName`.
4. Go to **LINE 8** and specify `1.0.0.NEXT` as the value for `versionNumber`.
5. Save `sfdx-project.json`.


## Create and promote version `1.0` of your package.
* Execute each command individually.
* Make sure `"PLP Demo@1.0.0-1"`appears in the `packageAliases` section of `sfdx-project.json` **before** executing the second command.
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





# PART TWO: Experience PLP from the subscriber's perspective.
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

## Create a package development scratch org and push your source
* Execute each command individually.
* The first command must complete successfully before executing the second command.
```
# Create a scratch org
sfdx force:org:create -a PLP-developer -f config/developer-scratch-def.json

# Push your source
sfdx force:source:push -u PLP-developer
```

### Open the package developer scratch org.
```
sfdx force:org:open -u PLP-developer
```

### Make declarative modifications to custom Permission Set License definitions.
1. From Setup, in the Quick Find box, type `custom perm`, then click on `Custom Permission Set License Definitions`.
2. In the **Custom Permission Set License Definitions** setup page, click on `Demo FeatureA`.
3. 

### Pull any declarative modifications
```
sfdx force:source:pull -u PLP-developer
```

