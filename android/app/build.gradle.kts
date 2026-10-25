import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Loaded outside `android {}`: with AGP 9, `java` inside that block resolves to
// a Gradle extension, so fully qualified `java.util.*` names no longer compile.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

android {
    namespace = "app.locomotion.mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "app.locomotion.mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["appName"] = "LocoMotion"
    }

    flavorDimensions += listOf("environment")

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            manifestPlaceholders["appName"] = "LocoMotion Dev"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            manifestPlaceholders["appName"] = "LocoMotion Staging"
        }
        create("prod") {
            dimension = "environment"
            manifestPlaceholders["appName"] = "LocoMotion"
        }
    }

    val releaseKeyPath = System.getenv("ANDROID_KEYSTORE_PATH")
        ?: keystoreProperties.getProperty("storeFile")
    val hasReleaseKeystore = !releaseKeyPath.isNullOrEmpty() && file(releaseKeyPath).exists()
    val allowDebugSigning = System.getenv("ALLOW_DEBUG_SIGNING") == "true"

    signingConfigs {
        create("release") {
            if (hasReleaseKeystore) {
                storeFile = file(releaseKeyPath!!)
                storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
                    ?: keystoreProperties.getProperty("storePassword")
                keyAlias = System.getenv("ANDROID_KEY_ALIAS")
                    ?: keystoreProperties.getProperty("keyAlias")
                keyPassword = System.getenv("ANDROID_KEY_PASSWORD")
                    ?: keystoreProperties.getProperty("keyPassword")
            }
            // Without a keystore this config stays incomplete, so a release
            // build fails on purpose instead of shipping a debug-signed app.
        }
    }

    buildTypes {
        release {
            signingConfig = if (!hasReleaseKeystore && allowDebugSigning) {
                // Explicit opt-in only (CI smoke builds): never ship this
                // artifact. Using the `debug` config itself, not a copy of its
                // path, lets AGP create the debug keystore on a fresh machine.
                signingConfigs.getByName("debug")
            } else {
                signingConfigs.getByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

val hasGoogleServicesJson = file("google-services.json").exists() ||
    file("src/dev/google-services.json").exists() ||
    file("src/staging/google-services.json").exists() ||
    file("src/prod/google-services.json").exists()

if (hasGoogleServicesJson) {
    apply(plugin = "com.google.gms.google-services")
}
