# The Partner Licensing Platform (PLP) Demo App
This repository contains sample code and instructions for test driving the Partner Licensing Platform (PLP) using both first-generation packaging (1GP) and second-generation packaging (2GP).

# Getting Started
To start using this demo, you must first...
1. Request, and be granted, access to the Partner Licensing Platform developer preview.
2. Ensure that your local environment supports Git-based development with SFDX.
3. Clone this repository to your local machine.
4. Authorize the Salesforce CLI to your PLP-enabled Dev Hub.
5. Update the `namespace` value in `sfdx-project.json`
6. Decide between 1GP and 2GP for your demo app

**You'll need between 10 and 45 minutes** to complete the "Getting Started" steps, mostly depending on whether you have Git and the Salesforce CLI already installed on your local machine.

## Request access to the Partner Licensing Platform developer preview.

All AppExchange partners in good standing are eligible to participate in the **Partner Licensing Platform (PLP) developer preview**.  To request access, you must...
1. Join the [Partner Licensing Platform - Dev Preview](https://partners.salesforce.com/_ui/core/chatter/groups/GroupProfilePage?g=0F94V0000010zlV) group in the Partner Community.
2. Review the Onboarding Guide and follow the pre-activation instructions.
4. Request activation of PLP features.

Acceptance to the dev preview and activation of PLP features is required **before** using this demo. 

While waiting for activation, you can proceed to the next step of ensuring your local environment supports Git and SFDX.

## Ensure your local environment supports Git and SFDX.

Both Git and the Salesforce CLI must be installed and properly configured on your local machine.
* If you need to install Git, see [Git Guides - Install Git](https://github.com/git-guides/install-git)
* If you need to install the Salesforce CLI, see the [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm)

## Use Git to clone this repository to your local machine.
1. Open your terminal/CLI program.
2. Clone the `plp-demo-app` repository.
3. Navigate to the root of the `plp-demo-app` folder.
```
# Clone the plp-demo-app repository
git clone https://github.com/sfdx-isv/plp-demo-app.git

# Navigate to the root of the demo-app folder
cd plp-demo-app
```
## Authorize the Salesforce CLI to your PLP-enabled Dev Hub.
[Authorize](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth.htm) the Salesforce CLI to access a PLP-enabled Developer Hub using the following command.
* As part of the PLP dev preview onboarding process you were asked to create a Dev Hub org.
* You must authorize the Salesforce CLI on your local machine to access **that specific org**.
```
sfdx force:auth:web:login -a DevHub:PLP-Dev-Preview
```

## Set the default Dev Hub for the `plp-demo-app` project.
* Ensure the working directory of your terminal/CLI is `plp-demo-app` before executing this command.
* If your PLP-enabled Dev Hub has a different alias, use it instead of `DevHub:PLP-Dev-Preview`.
    * Remember, the Dev Hub you specify here **must** be activated for the PLP developer preview.
    * If you specifiy a Dev Hub that **has not** been activated for the PLP developer preview, you must run this command again with an appropriate Dev Hub or your demo app will not work.
```
# Make sure your current working directory is plp-demo-app!
sfdx config:set defaultdevhubusername=DevHub:PLP-Dev-Preview
```

## Update the `namespace` value in `sfdx-project.json`
1. Open the `sfdx-project.json` file in the `plp-demo-app` directory using a text/source editor (e.g. VS Code).
2. Go to **LINE 12** and replace `plpdp_??????` with the namespace from the Partner Developer Edition org that you created for this developer preview.
    * Your namespace MUST begin with `plpdp_`.
3. Make sure that your namespace is linked to your PLP-enabled Dev Hub.
    * See [Linking a Namespace to a Dev Hub Org](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_reg_namespace.htm) for detailed instructions.
    * This is required for **both** 1GP and 2GP demos.
3. Save `sfdx-project.json`.


## Decide between using 1GP and 2GP for this demo.
The final step in getting started with the PLP demo app is deciding whether you want to test drive the features of the Partner Licensing Platform using 1GP or 2GP.

**Using second-generation packaging (2GP) is strongly recommended.** It's much easier to follow along with the demo steps using 2GP, even if you've never used 2GP before.

* To experience the demo with 2GP, go to the [PLP 2GP Demo README](2GP_README.md).
* To experience the demo with 1GP, go to the [PLP 1GP Demo README](1GP_README.md).

Please follow the steps in the either the 2GP or 1GP Demo README to complete your PLP demo experience.