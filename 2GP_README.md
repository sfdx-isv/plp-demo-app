# PLP 2GP Demo
Sample code and instructions for test driving the Partner Licensing Platform (PLP) using second-generation packaging (2GP).

## Step One: Set the default Dev Hub for the `2gp-demo` project folder.
1. Navigate to the `plp-demo-app/2gp-demo` folder in your terminal.
2. Run the following command, replacing `YOUR_PLP_ENABLED_DEV_HUB` with the alias or username of a developer hub that has been activated for the PLP developer preview.
```
sfdx config:set defaultdevhubusername=YOUR_PLP_ENABLED_DEV_HUB 
```

## Step Two: Update the namespace in `sfdx-project.json`
1. Open `sfdx-project.json`.
2. Go to **LINE 8** and replace `plpdp_??????` with the namespace that you created for this developer preview.
3. Your namespace MUST be linked to the Dev Hub specified in the previous step. 
    * See [Linking a Namespace to a Dev Hub Org](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_reg_namespace.htm) for detailed instructions if you have not already linked your namespace to your PLP-enabled developer hub

## Step Three: Create a new second-generation managed package.
```
sfdx force:package:create -n "PLP Demo (2GP)" -r force-app -t Managed
```

## Step Four: Create a package development scratch org and push your source
* Execute each command individually.
* The first command must complete successfully before executing the second command.
```
# Create a scratch org
sfdx force:org:create -a PLP-developer -f config/developer-scratch-def.json

# Push your source
sfdx force:source:push -u PLP-developer
```

## Step Five: Create and promote version `1.0` of your package.
* Execute each command individually.
* The first command must complete successfully before executing the second command.
* Make sure `"PLP Demo (2GP)@1.0.0-1"`appears in the `packageAliases` section of `sfdx-project.json` before executing the second command.
* When asked if you're sure you want to release this package, type `y` and hit `ENTER`.
```
# Create a package version.
sfdx force:package:version:create -p "PLP Demo (2GP)" -f config/developer-scratch-def.json -x -w 15 -c --skipancestorcheck

# Promote the package version you just created.
sfdx force:package:version:promote -p "PLP Demo (2GP)@1.0.0-1"
```

## Step Six: Create a subscriber demo scratch org.
* Note the use of the `-n` (`nonamespace`) and `-c` (`noancestors`) flags.
* This allows you accurately simulate a subscriber org
```
sfdx force:org:create -n -c -a PLP-subscriber -f config/subscriber-scratch-def.json
```

## Step Seven: Install your package in the subscriber demo scratch org.
```
sfdx force:package:install -r -p "PLP Demo (2GP)@1.0.0-1" -w 10 -u PLP-subscriber
```

## Step Eight: Open the subscriber demo scratch org as the ADMIN user.
```
sfdx force:org:open -u PLP-subscriber
```

## Step Nine: Verify package installation in the subscriber demo scratch org.
1. From Setup, in the Quick Find box, type `pack`, then click on `Installed Packages`.
2. You should see one installed package named `PLP Demo (2GP)`.

## Step Ten: Create a test user in the subscriber demo scratch org.
```
sfdx force:user:create -a PLP-test-user -f config/subscriber-user-def.json -u PLP-subscriber
```

## Step Eleven: Assign the `Feature_Access_Demo_User` permset to the test user.
* This permset is needed for you to see the **Feature Access Demo** page in the subscriber org.
```
sfdx force:user:permset:assign -u PLP-subscriber -n Feature_Access_Demo_User -o PLP-test-user
```

## Step Twelve: Open the subscriber demo scratch org as the TEST user in a DIFFERENT browser.
* The goal here is for you to simulate TWO user personas, the org ADMIN and a standard USER. 
* The easiset way to do this is to open the USER persona in a browser that is not your system default.
* The `-b` flag of the `force:org:open` command allows you to specify which browser the CLI will use when "opening" an org.  The available options are:
    * `chrome`
    * `firefox`
    * `edge`
* Execute the command below, making sure to specify a browser that **is not your system default**.
    * For example, if your system default browser is Chrome, specify either `firefox` or `safari` 
* IMPORTANT: If you do not have one of the alternative browsers installed on your machine, you can follow along with this demo as long as you switch user contexts.
```
sfdx force:org:open -u PLP-test-user -b firefox
```

## Step Thirteen: Open the "Feature Access Check" demo page.


## Step Fourteen: Assign the Custom PSL for Feature A.


## Step Fifteen: Try the "access check" demo page again.







# PLACEHOLDERS


### Step ???: Open the package developer scratch org.
```
sfdx force:org:open -u PLP-developer
```

### Step ???: Make declarative modifications to custom Permission Set License definitions.
1. From Setup, in the Quick Find box, type `custom perm`, then click on `Custom Permission Set License Definitions`.
2. In the **Custom Permission Set License Definitions** setup page, click on `Demo FeatureA`.
3. 


### Step ???: Pull any declarative modifications
```
sfdx force:source:pull -u PLP-developer
```
