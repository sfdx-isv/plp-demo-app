public with sharing class LicensingUtil {
	
 	private static String currentNamespace = getNamespace();
    private static Set<String> packageNamespaces = new Set<String> {'plpdp_mynamespace1', 'IsvlTdxDemo'};
    
	
    public static boolean hasAccessToLCP(String customPerm) {
        // TODO: Confirm that the customPerm is not null, exists, and is a Licensed Custom Perm - otherwise throw exception
        
        /*
        System.debug('debug Test.isRunningTest ' + Test.isRunningTest());
        System.debug('debug isDevOrg ' + isDevOrg());
        System.debug('debug isPackagingOrg ' + isPackagingOrg());
        System.debug('debug userHasPackageLicense ' + userHasPackageLicense());
        System.debug('debug FeatureManagement.checkPermission ' + FeatureManagement.checkPermission(customPerm));
        System.debug('debug getNamespace ' + getNamespace());
        System.debug('debug getPackageId ' + getPackageId());
        */
        
        if(Test.isRunningTest() ||                           // bypass access check for automated tests
           isDevOrg() ||                                     // bypass access check if within a developer org (without local namespace)
           isPackagingOrg() ||                               // bypass access check if within your packaging org (with local namespace)
           userHasPackageLicense() ||         				 // allow access if the user has a managed package license (for hybrid licensing)
           FeatureManagement.checkPermission(customPerm)) {  // check for user's access for the feature gated by this LCP
            return true;
        }
        
        return false;
    }
    
    
    public static String getNamespace() {
        if (currentNamespace == null) {
            String classWithDotNotation = LicensingUtil.class.getName();

            if (classWithDotNotation.contains('.')) {
                currentNamespace = classWithDotNotation.substringBefore('.');
            } else {
                currentNamespace = '';
            }
        }
        return currentNamespace;
    }
    
    private static Boolean isDevOrg() {
        return String.isBlank(getNamespace());
    }
    
    public static String getPackageId() {
        try {
            return Packaging.getCurrentPackageId();
        } catch (System.NoDataFoundException e) {  // the running context is not within a managed package
            return '';
        }
    }
    
    private static Boolean isPackagingOrg() {
        return String.isNotBlank(getNamespace()) && packageNamespaces.contains(getNamespace()) && String.isBlank(getPackageId());
    }
        
    public static boolean userHasPackageLicense() {
            String packageId = getPackageId();
            return String.isNotBlank(packageId) && UserInfo.hasPackageLicense(packageId);
    }
}