# plp-samples
Sample code and instructions for test driving the Partner Licensing Platform (PLP)

### Step One: Set the default Dev Hub for the `2GP demo` project folder.
From the command prompt, make sure you are in the `plp-demo-app/
```
sfdx force:package:create -n "Global Apex Test" -r sfdx-source/core-app -t Managed
```


### Step One: Add your package namespace to `sfdx-project.json`
```
sfdx force:package:create -n "Global Apex Test" -r sfdx-source/core-app -t Managed
```

### Step Two: Create a Scratch Org
```
sfdx force:org:create -s -a PKG-Scratch:global-apex-test -f config/project-scratch-def.json
```
