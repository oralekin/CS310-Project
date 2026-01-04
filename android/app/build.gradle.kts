plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")

    // 🔑 Firebase
    id("com.google.gms.google-services")

    // 🔵 Flutter (en sonda)
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.uniconnect.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.uniconnect.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
