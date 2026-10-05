plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
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

    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = java.util.Properties()
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
    }

    signingConfigs {
        create("release") {
            val keyPath = System.getenv("ANDROID_KEYSTORE_PATH")
                ?: keystoreProperties.getProperty("storeFile")
            val keyPasswordEnv = System.getenv("ANDROID_KEY_PASSWORD")
                ?: keystoreProperties.getProperty("keyPassword")
            val storePasswordEnv = System.getenv("ANDROID_KEYSTORE_PASSWORD")
                ?: keystoreProperties.getProperty("storePassword")
            val keyAliasEnv = System.getenv("ANDROID_KEY_ALIAS")
                ?: keystoreProperties.getProperty("keyAlias")

            if (!keyPath.isNullOrEmpty() && file(keyPath).exists()) {
                storeFile = file(keyPath)
                storePassword = storePasswordEnv
                keyAlias = keyAliasEnv
                keyPassword = keyPasswordEnv
            } else {
                // Fallback to debug keystore for local testing and CI when release secrets are not provisioned
                val debugConfig = getByName("debug")
                storeFile = debugConfig.storeFile
                storePassword = debugConfig.storePassword
                keyAlias = debugConfig.keyAlias
                keyPassword = debugConfig.keyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
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
