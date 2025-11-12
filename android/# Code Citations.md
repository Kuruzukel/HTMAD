# Code Citations

## License: BSD_3_Clause

https://github.com/flutter/flutter/tree/a672b016a3f13acee08137d351b93bacbdc9989e/dev/a11y_assessments/android/settings.gradle

```
def properties = new Properties()
           file("local.properties").withInputStream { properties.load(it) }
           def flutterSdkPath = properties.getProperty("flutter.sdk")
           assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
```
