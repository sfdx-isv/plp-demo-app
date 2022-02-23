public with sharing class DebugFeatureAccessDemoController {
    public boolean isDevOrg {get; set;}
    public boolean isSubscriberOrg {get; set;}
    public boolean userHasPackageLicense {get; set;}
    public String packageId {get; set;}
    
    
    public DebugFeatureAccessDemoController() {
        isDevOrg = LicensingUtil.isDevOrg();
        isSubscriberOrg = LicensingUtil.isSubscriberOrg();
        userHasPackageLicense = LicensingUtil.userHasPackageLicense();
        packageId = LicensingUtil.getPackageId();
    }
}
