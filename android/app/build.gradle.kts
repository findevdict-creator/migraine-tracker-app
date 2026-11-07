import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing (phase 39). Read from android/key.properties on a
// developer machine (gitignored; see docs/release/README.md) or from the
// ANDROID_KEYSTORE_* variables the release workflow sets from secrets.
// Without either, release builds fall back to the debug key so local
// `flutter run --release` keeps working; such builds are refused by Play.
val keyProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}

fun signingValue(property: String, env: String): String? =
    keyProperties.getProperty(property) ?: System.getenv(env)

val releaseStoreFile = signingValue("storeFile", "ANDROID_KEYSTORE_PATH")?.let {
    // key.properties paths are relative to the android/ folder.
    if (File(it).isAbsolute) it else rootProject.file(it).path
}

android {
    namespace = "app.aurawell.mobile"
    // flutter_local_notifications 23 and androidx.core 1.19 compile against
    // API 37. Compiling against a newer API is backward compatible; the
    // target SDK (runtime behaviour) still follows Flutter's default.
    compileSdk = maxOf(37, flutter.compileSdkVersion)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // flutter_local_notifications (phase 21) needs java.time on API 28.
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // Mirrors AppIdentity.bundleId in lib/config/app_config.dart.
        applicationId = "app.aurawell.mobile"
        // Android 9 (API 28) is the floor from the requirements doc
        // (Health Connect needs it).
        minSdk = maxOf(28, flutter.minSdkVersion)
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildFeatures {
        // Needed for the per-flavor app_name resValue below.
        resValues = true
    }

    // Flavors mirror AppFlavor in lib/config/app_config.dart. The suffix and
    // label must match AppIdentity.bundleIdFor and AppIdentity.displayName.
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Aurawell (dev)")
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            resValue("string", "app_name", "Aurawell (beta)")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Aurawell")
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
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
