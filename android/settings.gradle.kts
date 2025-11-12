pluginManagement {
    val flutterSdkPath = run {
        val localProperties = java.util.Properties()
        val localPropertiesFile = file("local.properties")
        if (localPropertiesFile.exists()) {
            localPropertiesFile.inputStream().use { stream ->
                localProperties.load(stream)
            }
        }
        val flutterSdkPath = localProperties.getProperty("flutter.sdk")
        requireNotNull(flutterSdkPath) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

val localProperties = java.util.Properties()
val localPropertiesFile = file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { stream ->
        localProperties.load(stream)
    }
}

val flutterSdkPath = localProperties.getProperty("flutter.sdk")
require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }

apply(from = "$flutterSdkPath/packages/flutter_tools/gradle/flutter.settings.gradle.kts")


include(":app")
