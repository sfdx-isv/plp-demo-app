public class FeatureAccessDemoController {
    public string canAccessFeatureA {get; set;}
    public string canAccessFeatureB {get; set;}
    public string canAccessFeatureC {get; set;}

    public string featureAAccessResultColor {get; set;}
    public string featureBAccessResultColor {get; set;}
    public string featureCAccessResultColor {get; set;}
    
    string featureALCP = 'Feature_A';
    string featureBLCP = 'Feature_B';
    string featureCLCP = 'Feature_C';
    
    string accessSuccess = 'Yes, you can!';
    string accessFailure = 'Nope';
    
    string accessSuccessColor = 'DarkGreen';
    string accessFailureColor = 'DarkRed';
    
    
    Public PageReference checkAccessFeatureA() {    
        if (LicensingUtil.hasAccessToLCP(featureALCP)) {
            canAccessFeatureA = accessSuccess;
            featureAAccessResultColor = accessSuccessColor;
        } else {
            canAccessFeatureA = accessFailure;
            featureAAccessResultColor = accessFailureColor;
        }
        return Page.FeatureAccessDemo;
    }
    
    Public PageReference checkAccessFeatureB() {    
        if (LicensingUtil.hasAccessToLCP(featureBLCP)) {
            canAccessFeatureB = accessSuccess;
            featureBAccessResultColor = accessSuccessColor;
        } else {
            canAccessFeatureB = accessFailure;
            featureBAccessResultColor = accessFailureColor;
        }
        return Page.FeatureAccessDemo;
    }

    Public PageReference checkAccessFeatureC() {    
        if (LicensingUtil.hasAccessToLCP(featureCLCP)) {
            canAccessFeatureC = accessSuccess;
            featureCAccessResultColor = accessSuccessColor;
        } else {
            canAccessFeatureC = accessFailure;
            featureCAccessResultColor = accessFailureColor;
        }
        return Page.FeatureAccessDemo;
    }
}