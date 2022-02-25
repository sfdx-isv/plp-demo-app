@isTest
private class LicensingUtilTest {
    @isTest
    static void testIsDevOrg() {
        LicensingUtil.isDevOrg();
    }

    @isTest
    static void testGetPackageId() {
        String result = LicensingUtil.getPackageId();
    }

    @isTest
    static void testUserHasPackageLicense() {
        Boolean result = LicensingUtil.userHasPackageLicense();
    }

}