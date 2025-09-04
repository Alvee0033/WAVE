plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.wave.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    repositories {
        google()
        mavenCentral()
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.wave.app"
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
}

flutter {
    source = "../.."
}

// Custom task to clean up old APK files after build
tasks.register("cleanOldApks") {
    doLast {
        val apkDir = file("../../build/app/outputs/flutter-apk")
        if (apkDir.exists()) {
            apkDir.listFiles()?.forEach { file ->
                if (file.isFile && file.name.endsWith(".apk")) {
                    println("Deleting old APK: ${file.name}")
                    file.delete()
                }
                if (file.isFile && file.name.endsWith(".apk.sha1")) {
                    println("Deleting old SHA1: ${file.name}")
                    file.delete()
                }
            }
        }
    }
}

// Run cleanup before assembling new APKs
afterEvaluate {
    tasks.findByName("assembleDebug")?.dependsOn("cleanOldApks")
    tasks.findByName("assembleRelease")?.dependsOn("cleanOldApks")
}
