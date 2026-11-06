import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing (phase 39): the same upload key as the phone app, which
// the Wearable data layer requires. Read from the phone's
// android/key.properties or the ANDROID_KEYSTORE_* variables the release
// workflow sets; debug key otherwise.
val keyProperties = Properties().apply {
    val file = rootProject.file("../../android/key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}

fun signingValue(property: String, env: String): String? =
    keyProperties.getProperty(property) ?: System.getenv(env)

val releaseStoreFile = signingValue("storeFile", "ANDROID_KEYSTORE_PATH")?.let {
    // key.properties paths are relative to the phone's android/ folder.
    if (File(it).isAbsolute) it else rootProject.file("../../android/$it").path
}

// Play needs a distinct version code per form factor under one package.
// Mirrors AppRelease.wearVersionCodeOffset in lib/config/app_config.dart.
val wearVersionCodeOffset = 100_000_000

android {
    namespace = "app.migrainetracker.migraine_tracker_wear"
    // Same as the phone app: plugins compile against API 37.
    compileSdk = maxOf(37, flutter.compileSdkVersion)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // The Wearable data layer only connects apps with the same package
        // name and signing key, so this mirrors the phone's applicationId
        // (AppIdentity.bundleId in lib/config/app_config.dart).
        applicationId = "app.migrainetracker.migraine_tracker"
        // Wear OS 3 (API 30) is the floor for tiles and the data layer.
        minSdk = maxOf(30, flutter.minSdkVersion)
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = wearVersionCodeOffset + flutter.versionCode
        versionName = flutter.versionName
    }

    buildFeatures {
        resValues = true
    }

    // Flavors mirror the phone app's (android/app/build.gradle.kts): the
    // suffixes must match for the watch to find its phone app.
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Migraine Tracker (dev)")
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            resValue("string", "app_name", "Migraine Tracker (beta)")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Migraine Tracker")
        }
    }

    signingConfigs {
        if (releaseStoreFile != null) {
            create("release") {
                storeFile = file(releaseStoreFile)
                storePassword = signingValue("storePassword", "ANDROID_KEYSTORE_PASSWORD")
                keyAlias = signingValue("keyAlias", "ANDROID_KEY_ALIAS")
                keyPassword = signingValue("keyPassword", "ANDROID_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (releaseStoreFile != null) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
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

dependencies {
    // Risk tile (RiskTileService.kt).
    implementation("androidx.wear.tiles:tiles:1.4.1")
    implementation("androidx.wear.protolayout:protolayout:1.2.1")
    implementation("androidx.concurrent:concurrent-futures:1.2.0")
    implementation("com.google.guava:listenablefuture:1.0")
}
