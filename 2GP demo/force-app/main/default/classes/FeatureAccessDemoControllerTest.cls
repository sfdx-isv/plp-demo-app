@isTest
private class FeatureAccessDemoControllerTest {
    @isTest
    static void testFeatureAccessByCustomPermissionFeatureA() {
		string accessSuccess = 'Yes, you can!';
        FeatureAccessDemoController featureAccessController = new FeatureAccessDemoController();
        featureAccessController.checkAccessFeatureA();
        
        System.assertEquals(featureAccessController.canAccessFeatureA, accessSuccess);
    }
    
    @isTest
    static void testFeatureAccessByCustomPermissionFeatureB() {
        string accessSuccess = 'Yes, you can!';
        FeatureAccessDemoController featureAccessController = new FeatureAccessDemoController();
        featureAccessController.checkAccessFeatureB();
        
        System.assertEquals(featureAccessController.canAccessFeatureB, accessSuccess);
    }
    
    @isTest
    static void testLicensingUtilHasAccessToLCP() {     
        System.assertEquals(LicensingUtil.hasAccessToLCP('Feature_B'), true);
    }
    
}