public with sharing class LicensingUtil {
	
    public static boolean hasAccessToLCP(String customPerm) {
        // TODO: Confirm that the customPerm is not null, exists, and is a Licensed Custom Perm - otherwise throw exception
        
        /*
        System.debug('debug Test.isRunningTest ' + Test.isRunningTest());
        System.debug('debug isDevOrg ' + isDevOrg());
        System.debug('debug userHasPackageLicense ' + userHasPackageLicense());
        System.debug('debug FeatureManagement.checkPermission ' + FeatureManagement.checkPermission(customPerm));
        System.debug('debug getPackageId ' + getPackageId());
        */
        
        if(Test.isRunningTest() ||                           // bypass access check for automated tests
           isDevOrg() ||                                     // bypass access check if within a developer org (without local namespace)
           //userHasPackageLicense() ||         				 // allow access if the user has a managed package license (for hybrid licensing)
           FeatureManagement.checkPermission(customPerm)) {  // check for user's access for the feature gated by this LCP
            return true;
        }
        
        return false;
    }
    
    public static Boolean isDevOrg() {
        return String.isBlank(getPackageId());
    }
    
    public static Boolean isSubscriberOrg() {
        return String.isNotBlank(getPackageId());
    }
    
    public static String getPackageId() {
        try {
            return Packaging.getCurrentPackageId();
        } catch (System.NoDataFoundException e) {  // the running context is not within a managed package
            return '';
        }
    }
        
    public static boolean userHasPackageLicense() {
        String packageId = getPackageId();
        return String.isNotBlank(packageId) && UserInfo.hasPackageLicense(packageId);
    }
}