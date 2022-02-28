public with sharing class LicensingUtil {
	
    /**
     * Check access to the Licensed Custom Permission (LCP).
     * 
     * Returns: true
     *  - Running automated tests
     *  - Running in developer or packaging org
     *  - User has access to LCP
     */
    public static boolean hasAccessToLCP(String customPerm) {
        if(Test.isRunningTest() ||
           isDevOrg() ||
           //userHasPackageLicense() ||         		     // Commented out since this method always returns true in scratch org context. Scratch orgs by default are on a "site-wide" package license
           FeatureManagement.checkPermission(customPerm)) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Return true for developer or packaging org.
     * 
     * When a component is accessed and if the component is not in a package then it could be either developer or packaging org. 
     */
    public static Boolean isDevOrg() {
        return String.isBlank(getPackageId());
    }
    
    /**
     * Return true for Subscriber org (org where the package is installed)
     * 
     * When a component is accessed and if the component is in package which means package is installed and it is subscriber org.
     */
    public static Boolean isSubscriberOrg() {
        return String.isNotBlank(getPackageId());
    }
    
    /**
     * Get packageId of the component that is currently executing.
     * 
     * Return either packageId or empty, depending on if the component is in package or not 
     */
    public static String getPackageId() {
        try {
            return Packaging.getCurrentPackageId();
        } catch (System.NoDataFoundException e) {  // the running context is not within a managed package
            return '';
        }
    }
    
    /**
     * Check if the user has access to the package via ONLY managed package license.
     * 
     * Note: returns true if package licensing for current org is set to "site-wide". 
     * Scratch orgs and sandboxes are always on site-wide licensing for packages.
     */
    public static boolean userHasPackageLicense() {
        String packageId = getPackageId();
        return String.isNotBlank(packageId) && UserInfo.hasPackageLicense(packageId);
    }
}