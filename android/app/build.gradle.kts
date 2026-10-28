import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Las contraseñas de la firma viven en android/key.properties, fuera del
// repositorio. Sin ese archivo el proyecto sigue compilando: la versión de
// release se firma con la clave de depuración, que vale para probar pero no
// para publicar.
val signingProperties = Properties()
val signingPropertiesFile = rootProject.file("key.properties")
val isSigned = signingPropertiesFile.exists()
if (isSigned) {
    signingPropertiesFile.inputStream().use(signingProperties::load)
}

android {
    namespace = "com.blancotech.planova"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.blancotech.planova"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // ARCore pide Android 9 para arriba. El resto de la app funcionaría
        // en teléfonos más viejos, pero no hay forma de separarlo.
        minSdk = maxOf(flutter.minSdkVersion, 28)
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (isSigned) {
                storeFile = rootProject.file(
                    signingProperties.getProperty("storeFile"),
                )
                storePassword = signingProperties.getProperty("storePassword")
                keyAlias = signingProperties.getProperty("keyAlias")
                keyPassword = signingProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName(
                if (isSigned) "release" else "debug",
            )
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
    // Para preguntarle a ARCore si este teléfono lo soporta. La versión es
    // la que arrastra el paquete de medición (sceneview 2.2.1).
    implementation("com.google.ar:core:1.42.0")
}
