plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.proyecto_x.dashboard"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.proyecto_x.dashboard"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // flavorDimensions "default"
    // productFlavors {
    //     development {
    //         // Assigns this product flavor to the "version" flavor dimension.
    //         // If you are using only one dimension, this property is optional,
    //         // and the plugin automatically assigns all the module's flavors to
    //         // that dimension.
    //         dimension "default"
    //         applicationIdSuffix ".dev"
    //         versionNameSuffix "-dev"
    //         flutterVersionName = "-dev"
    //         resValue "string", "app_name", "Dev DashBoard"
    //         signingConfig signingConfigs.production
    //         minSdkVersion 21
    //         // flutterVersionName = "-dev"
    //     }
    //     staging {
    //         dimension "default"
    //         applicationIdSuffix ".stg"
    //         versionNameSuffix "-staging"
    //         flutterVersionName = "-staging"
    //         resValue "string", "app_name", "Stg DashBoard"
    //         signingConfig signingConfigs.production
    //         minSdkVersion 21
    //     }
    //     production {
    //         dimension "default"
    //         resValue "string", "app_name", "DashBoard"
    //         signingConfig signingConfigs.production
    //         minSdkVersion 21
    //     }
    // }
}

flutter {
    source = "../.."
}
