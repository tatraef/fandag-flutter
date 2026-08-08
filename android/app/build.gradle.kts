import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

val envProperties = Properties().apply {
    rootProject.file("environment.properties").takeIf { it.exists() }?.reader(Charsets.UTF_8)?.use { load(it) }
}

val secretProperties = Properties().apply {
    rootProject.file("secrets.properties").takeIf { it.exists() }?.reader(Charsets.UTF_8)?.use { load(it) }
}

android {
    namespace = "ru.fandag.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = envProperties.getProperty("applicationId", "ru.fandag.app")
        manifestPlaceholders += mapOf(
            "applicationLabel" to envProperties.getProperty("applicationLabel", "Fandag"),
        )
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        getByName("debug") {
            storeFile = file("debug.keystore")
        }
        
        create("release") {
            storeFile = file(secretProperties.getProperty("storeFilePath", "./release.keystore"))
            storePassword = secretProperties.getProperty("storePassword", "")
            keyAlias = secretProperties.getProperty("keyAlias", "")
            keyPassword = secretProperties.getProperty("keyPassword", "")
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }

        release {
            // TODO: Switch to signingConfigs.getByName("release") when keystore is ready
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
